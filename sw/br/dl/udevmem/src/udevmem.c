#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>

#define PAGE_SIZE (4096)


int fd;
unsigned int *map_base0;
unsigned long adr;

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <address> [data]\n", argv[0]);
        return (-1);
    }
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        printf("can not open /dev/mem \n");
        return (-1);
    } else {
        printf("/dev/mem is open \n");
    }
    if (argc > 1) {
        adr = strtoul(argv[1], NULL, 0);
    } else {
        return 1;
    }
    unsigned long base_addr = adr & ~(PAGE_SIZE - 1);
    unsigned long offset = adr & (PAGE_SIZE - 1);
    printf("Base address: 0x%lX, Offset: 0x%lX\n", base_addr, offset);
    map_base0 = (unsigned int*)mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, (off_t)base_addr);
    if (map_base0 == MAP_FAILED) {
        printf("NULL pointer\n");
        close(fd);
        return 0;
    } else {
        printf("mmap successful\n");
    }
    offset = offset / sizeof(unsigned int);
    if (argc == 3) {
        map_base0[offset] = strtoul(argv[2], NULL, 0);
        printf("Address register = %s\nWrite data = %s\n", argv[1], argv[2]);
    } else if (argc == 2) {
        printf("Address register = %s\nRead data = 0x%X\n", argv[1], map_base0[offset]);
    }
    munmap(map_base0, PAGE_SIZE);
    close(fd);
    return 0;
}
