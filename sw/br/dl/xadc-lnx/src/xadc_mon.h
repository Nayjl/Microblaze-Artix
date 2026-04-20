#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


#define TEMP_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_temp0_raw"
#define TEMP_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_temp0_scale"
#define TEMP_OFFSET_XADC "/sys/bus/iio/devices/iio:device0/in_temp0_offset"

#define VCCINT_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage0_vccint_raw"
#define VCCINT_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage0_vccint_scale"
#define VCCINT_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage0_vccint_label"

#define VCCAUX_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage1_vccaux_raw"
#define VCCAUX_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage1_vccaux_scale"
#define VCCAUX_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage1_vccaux_label"

#define VCCBRAM_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage2_vccbram_raw"
#define VCCBRAM_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage2_vccbram_scale"
#define VCCBRAM_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage2_vccbram_label"

#define VCCPINT_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage3_vccpint_raw"
#define VCCPINT_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage3_vccpint_scale"
#define VCCPINT_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage3_vccpint_label"

#define VCCPAUX_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage4_vccpaux_raw"
#define VCCPAUX_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage4_vccpaux_scale"
#define VCCPAUX_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage4_vccpaux_label"

#define VCCODDR_RAW_XADC "/sys/bus/iio/devices/iio:device0/in_voltage5_vccoddr_raw"
#define VCCODDR_SCALE_XADC "/sys/bus/iio/devices/iio:device0/in_voltage5_vccoddr_scale"
#define VCCODDR_LABEL_XADC "/sys/bus/iio/devices/iio:device0/in_voltage5_vccoddr_label"



float get_temp_xadc();
float get_vccint_xadc();
float get_vccaux_xadc();
float get_vccbram_xadc();
float get_vccpint_xadc();
float get_vccpaux_xadc();
float get_vccoddr_xadc();