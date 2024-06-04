###
 # @Description: 
 # @Author: Wawoo
 # @Date: 2024-06-04 16:02:48
 # @LastEditTime: 2024-06-04 16:33:51
 # @LastEditors: Wawoo
### 
#!/bin/bash

cd /usr/share/matrixlabs/matrixio-devices

function detect_device(){
  MATRIX_DEVICE=$(./fpga_info | grep IDENTIFY | cut -f 4 -d ' ')
}

function read_voice_config(){
  ESP32_RESET=$(cat /etc/matrixio-devices/matrix_voice.config | grep ESP32_BOOT_ON_RESET| cut -f 3 -d ' ')
}

./fpga-program.bash
detect_device

case "${MATRIX_DEVICE}" in
  "5c344e8")  
     echo "*** MATRIX Creator initial process has been launched"
    ./em358-program.bash
    ./radio-init.bash
    ./sam3-program.bash
    ;;
  "6032bad2")
    echo "*** MATRIX Voice initial process has been launched"
    voice_esp32_reset
    read_voice_config
    # Pi GPIO 25 > stm32mp157-dk2 GPIO 84
    if [ "${ESP32_RESET}" == "FALSE" ]; then
      echo 1 > /sys/class/gpio/gpio84/value
    else 
      echo 0 > /sys/class/gpio/gpio84/value
    fi
    ;;
esac

exit 0
