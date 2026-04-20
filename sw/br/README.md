# Инструкция про сборке *ROOTFS* в Buildroot
Это инструкция основана [на статье habr](https://habr.com/ru/articles/567408/) есть другие видео источники [FPGA-Systems](https://www.youtube.com/watch?v=339hpNuRZDo), [Макро-Групп](https://www.youtube.com/watch?v=aBFiVaTka6s&t=701s) и стрим Алексея Ростова в двух частях [1 часть](https://www.youtube.com/watch?v=Xn5cs9uh8gc) и [2 часть](https://www.youtube.com/watch?v=PxGK7h_DYfE&t=1299s).
Сайт проекта buildroot находится по адресу [Buildroot](http://buildroot.org/). На сайте находится очень подробная [документация](https://buildroot.org/downloads/manual/manual.html)
Для работа с buildroot нужны зависимые пакеты:
```bash
sudo apt update && sudo apt upgrade \
sudo apt install \
gcc-arm* \
bison flex \
libssl-dev \
uuid-dev \
libgnutls28-dev \
swig \
u-boot-tools build-essential binutils \
patch gzip bzip2 perl tar cpio unzip rsync bc libncurses-dev
```

# Перейдем к установке
Клонируем репозиторий удобную для вас папку: 
```bash
git clone git://git.buildroot.net/buildroot
```


