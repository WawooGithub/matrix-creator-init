###
 # @Description: 
 # @Author: Wawoo
 # @Date: 2024-06-04 16:02:48
 # @LastEditTime: 2024-06-04 16:32:08
 # @LastEditors: Wawoo
### 
#!/bin/bash

mkdir /etc/matrixio-devices/
mkdir /usr/share/matrixlabs
mkdir /usr/share/matrixlabs/matrixio-devices
mkdir /usr/share/matrixlabs/matrixio-devices/config

cp -avr blob \
        cfg \
        /usr/share/matrixlabs/matrixio-devices

cp -av sam3-program.bash \
       voice.version \
       fpga-program.bash \
       em358-program.bash \
       matrix-init.bash \
       radio-init.bash \
       ./build/cpp/firmware_info \
       ./build/cpp/fpga_info \
       mcu_firmware.version \
       matrixlabs_edit_settings.py \
       matrixlabs_remove_console.py \
       /usr/share/matrixlabs/matrixio-devices

cp -av voice_esp32_enable \
       voice_esp32_reset \
       /usr/bin

cp -av boot_modifications.txt \
       /usr/share/matrixlabs/matrixio-devices/config

cp -av matrixio-devices-firmware.service \
       /lib/systemd/system

cp -av matrix-creator-reset-jtag \
       /usr/bin

cp -av matrix-mics.conf \
       /etc/modules-load.d

cp -av raspicam.conf \
       /etc/modules-load.d

cp -av matrix_voice.config \
       /etc/matrixio-devices/