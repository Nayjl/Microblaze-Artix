#include "xadc_mon.h"


static float read_sensor(const char* path_xadc) {
    char buf[32];
    float value = 0.0;

    int fd = open(path_xadc, O_RDONLY);
    if (fd < 0) {
        perror("open fd xadc");
        return -1;
    }

    if (read(fd, buf, sizeof(buf)) > 0) {
        value = atof(buf);
    }

    close(fd);
    return value;
}


float get_temp_xadc() {
    float raw, scale, offset, result;

    raw = read_sensor(TEMP_RAW_XADC);
    scale = read_sensor(TEMP_SCALE_XADC);
    offset = read_sensor(TEMP_OFFSET_XADC);

    if (raw != -1 && scale != -1) {
        result = (raw * scale + offset) / 1000.0;
    } else {
        return -1;
    }
    result -= 273.15;

    return result;
}

float get_vccint_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCINT_RAW_XADC);
    scale = read_sensor(VCCINT_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}

float get_vccaux_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCAUX_RAW_XADC);
    scale = read_sensor(VCCAUX_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}

float get_vccbram_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCBRAM_RAW_XADC);
    scale = read_sensor(VCCBRAM_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}

float get_vccpint_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCPINT_RAW_XADC);
    scale = read_sensor(VCCPINT_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}

float get_vccpaux_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCPAUX_RAW_XADC);
    scale = read_sensor(VCCPAUX_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}

float get_vccoddr_xadc() {
    float raw, scale, result;

    raw = read_sensor(VCCODDR_RAW_XADC);
    scale = read_sensor(VCCODDR_SCALE_XADC);
    
    if (raw != -1 && scale != -1) {
        result = (raw * scale) / 1000.0;
    } else {
        return -1;
    }

    return result;
}