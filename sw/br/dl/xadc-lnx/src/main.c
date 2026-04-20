#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <string.h>

#include "xadc_mon.h"


void signal_handler(int num_sig);

int event_wh = 1;

int main() {

    struct sigaction sia;
    memset(&sia, 0, sizeof(sia));
    sia.sa_handler = signal_handler;
    sia.sa_flags = 0;
    sigemptyset(&sia.sa_mask);
    if (sigaction(SIGINT, &sia, NULL) == -1) {
         perror("sigaction");
         return 1;
    }

    system("clear");
    while (event_wh == 1) {
        printf("Temperature chip %.3f `C\n", get_temp_xadc());
        printf("Voltage VCCAUX   %.3f V\n", get_vccaux_xadc());
        printf("Voltage VCCBRAM  %.3f V\n", get_vccbram_xadc());
        printf("Voltage VCCINT   %.3f V\n", get_vccint_xadc());
        printf("Voltage VCCODDR  %.3f V\n", get_vccoddr_xadc());
        printf("Voltage VCCPAUX  %.3f V\n", get_vccpaux_xadc());
        printf("Voltage VCCPINT  %.3f V\n", get_vccpint_xadc());
        sleep(1);
        system("clear");
    }
    
    return 0;
}



void signal_handler(int num_sig) {
    event_wh = 0;
    printf("cntrl + c %d\n", num_sig);
}