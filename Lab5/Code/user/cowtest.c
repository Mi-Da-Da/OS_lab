#include <ulib.h>
#include <stdio.h>

static char buf[4096];

int
main(void) {
    buf[0] = 'S';
    buf[100] = 's';

    int pid = fork();
    if (pid == 0) {
        assert(buf[0] == 'S');
        assert(buf[100] == 's');
        buf[0] = 'C';
        buf[100] = 'c';
        assert(buf[0] == 'C');
        assert(buf[100] == 'c');
        exit(0);
    }

    assert(pid > 0);
    assert(wait() == 0);
    // parent should see original data, not child's writes
    assert(buf[0] == 'S');
    assert(buf[100] == 's');
    buf[0] = 'P';
    assert(buf[0] == 'P');
    cprintf("cowtest pass.\n");
    return 0;
}
