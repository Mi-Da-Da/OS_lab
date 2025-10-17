#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_system_pmm.h>
#include <stdio.h>

# define MAX_ORDER 15   // 定义最大阶数

static buddy_free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 计算所需阶数
static unsigned int
get_order(size_t n) 
{
    unsigned int order = 0;
    size_t size = 1;
    
    while (size < n) 
    {
        order++;
        size *= 2;
    }
    return order;
}

// 判断是否为2的幂
static unsigned int
is_power_of_2(size_t n) 
{
    return n != 0 && (n & (n - 1)) == 0;
}

// 获取伙伴块
static struct Page *
get_buddy(struct Page *page, unsigned int order) 
{
    if (page == NULL) return NULL;
    size_t page_idx = page - pages;
    size_t buddy_idx = page_idx ^ (1 << order);
    if (buddy_idx >= npage) return NULL;  // 检查边界
    return &pages[buddy_idx];
}

// 初始化结构体中的链表数组和参数,MAX_ORDER为最大阶数，设置为15
static void
buddy_system_init(void) 
{
    for (int i = 0; i <= MAX_ORDER; i++) 
    {
        list_init(&free_list[i]);
    }
    nr_free = 0;
}

static void
buddy_system_init_memmap(struct Page *base, size_t n) 
{
    assert(n > 0);
    
    // 初始化所有空闲页，对每个页结构体重置标志位 flags 与 property，清空引用计数
    struct Page *p = base;
    for (; p != base + n; p++) 
    {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    // 空闲页数量加 n
    nr_free += n;
    
    // 将内存块分解为2的幂次方块并添加到合适的阶链表中
    size_t remaining = n;
    struct Page *current = base;
    
    while (remaining > 0) 
    {
        // 找到最大的可以放入的2的幂次内存块,从最大的开始找，依次递减
        unsigned int order = 0;
        size_t block_size = 1;
        
        while (order < MAX_ORDER && block_size * 2 <= remaining) 
        {
            order++;
            block_size *= 2;
        }
        
        // 设置块属性
        current->property = block_size;
        SetPageProperty(current);
        
        // 添加到对应阶的空闲链表
        list_add(&free_list[order], &(current->page_link));
        
        // 剩余空闲块数量递减，为下一轮寻找做准备
        current += block_size;
        remaining -= block_size;
    }
}

static struct Page *
buddy_system_alloc_pages(size_t n)
{
    // 所需连续空闲页数量需大于 0
    assert(n > 0);
    // 所需连续空闲页数量大于空闲页数量，则找不到合适的空闲块，返回空
    if (n > nr_free) 
    {
        return NULL;
    }
    
    // 计算需要的阶
    unsigned int req_order = get_order(n);
    // 所需空闲块对应的阶大于当前最大的阶，则找不到合适的空闲块，返回空
    if (req_order > MAX_ORDER) 
    {
        return NULL;
    }
    
    // 从req_order开始向上查找可用的块
    unsigned int current_order = req_order;
    struct Page *page = NULL;
    list_entry_t *le = NULL;
    
    while (current_order <= MAX_ORDER) 
    {
        if (!list_empty(&free_list[current_order])) 
        {
            // 找到可用的块
            le = list_next(&free_list[current_order]);
            page = le2page(le, page_link);
            // 从空闲链表中删除该节点，该节点对应的空闲块已经被分配
            list_del(le);
            break;
        }
        current_order++;
    }
    
    if (page == NULL) 
    {
        return NULL;  // 没有找到合适的块
    }
    
    // 如果找到的块比需要的大，需要分裂
    while (current_order > req_order) 
    {
        // 分裂后的伙伴块应当添加到下一级链表中
        current_order--;
        
        // 分裂块，将伙伴块添加到空闲链表
        struct Page *buddy = get_buddy(page, current_order);
        if (buddy != NULL) 
        {
            buddy->property = (1 << current_order);
            SetPageProperty(buddy);
            list_add(&free_list[current_order], &(buddy->page_link));
        }
    }
    
    // 设置分配页面的属性
    ClearPageProperty(page);  // 清除空闲标记
    nr_free -= (1 << req_order);  // 减去实际分配的大小
    
    return page;
}

static void
buddy_system_free_pages(struct Page *base, size_t n) 
{
    // 释放的页数量需大于0
    assert(n > 0);
    // 被释放的页指针不应当为空
    assert(base != NULL);
    
    // 初始化释放的页面
    struct Page *p = base;
    for (; p != base + n; p++) 
    {
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    
    // 计算块的阶，向上取整到2的幂
    unsigned int order = get_order(n);
    
    // 对块首页设置页属性为取整后的阶
    size_t actual_size = (1 << order);
    base->property = actual_size;
    // 设置PageProperty标志
    SetPageProperty(base);
    // 空闲页数量加n
    nr_free += actual_size;
    
    // 尝试合并buddy
    struct Page *current = base;
    unsigned int current_order = order;
    
    while (current_order < MAX_ORDER) 
    {
        struct Page *buddy = get_buddy(current, current_order);
        
        // 检查伙伴块是否空闲、大小相同且在同一个内存区域
        if (buddy == NULL || !PageProperty(buddy) || 
            buddy->property != (1 << current_order) ||
            buddy < pages || buddy >= pages + npage) 
        {
            break;  // 不能合并
        }
        
        // 从空闲链表中移除伙伴块，因为被合并了
        list_del(&(buddy->page_link));
        
        // 确定合并后的块，取地址较小的那个
        if (current > buddy) 
        {
            struct Page *temp = current;
            current = buddy;
            buddy = temp;
        }
        
        // 合并块
        current->property = (1 << (current_order + 1));
        ClearPageProperty(buddy);
        buddy->property = 0;
        
        // 尝试与上一阶的伙伴块合并
        current_order++;
    }
    
    // 将合并结束的块添加到空闲链表
    list_add(&free_list[current_order], &(current->page_link));
}

static size_t
buddy_system_nr_free_pages(void) 
{
    return nr_free;
}

static void
show_array(void) 
{
    cprintf("==============================================================================\n");
    for (int i = 0; i <= MAX_ORDER; i++) 
    {
        int count = 0;
        list_entry_t *le = &free_list[i];
        while ((le = list_next(le)) != &free_list[i]) 
        {
            count++;
        }
        if (count > 0) 
        {
            cprintf("Order %d (%d pages): %d free blocks\n", i, (1 << i), count);
        }
    }
    cprintf("==============================================================================\n");
}

// 检查函数
static void
base_check(void) 
{
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    cprintf("开始检测\n");
    cprintf("当前空闲块总数：%d\n", nr_free);
    show_array();

    cprintf("p0请求10页\n");
    p0 = buddy_system_alloc_pages(10);
    show_array();

    cprintf("p1请求10页\n");
    p1 = buddy_system_alloc_pages(10);
    show_array();

    cprintf("p2请求10页\n");
    p2 = buddy_system_alloc_pages(10);
    show_array();

    cprintf("p0的虚拟地址为：%p\n", p0);
    cprintf("p1的虚拟地址为：%p\n", p1);
    cprintf("p2的虚拟地址为：%p\n", p2);

    buddy_system_free_pages(p0, 10);
    cprintf("释放p0后总空闲块数量：%d\n", nr_free);

    buddy_system_free_pages(p1, 10);
    cprintf("释放p1后总空闲块数量：%d\n", nr_free);

    buddy_system_free_pages(p2, 10);
    cprintf("释放p2后总空闲块数量：%d\n", nr_free);
}

const struct pmm_manager buddy_system_pmm_manager =
{
    .name = "buddy_system_pmm_manager",
    .init = buddy_system_init,
    .init_memmap = buddy_system_init_memmap,
    .alloc_pages = buddy_system_alloc_pages,
    .free_pages = buddy_system_free_pages,
    .nr_free_pages = buddy_system_nr_free_pages,
    .check = base_check,
};