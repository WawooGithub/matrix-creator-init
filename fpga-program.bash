###
 # @Description: 
 # @Author: Wawoo
 # @Date: 2024-06-04 16:02:48
 # @LastEditTime: 2024-06-04 16:13:15
 # @LastEditors: Wawoo
### 
#!/bin/bash

cd /usr/share/matrixlabs/matrixio-devices

P4DETECT=$(grep "Pi 4" /sys/firmware/devicetree/base/model)

# Pi GPIO26 > stm32mp157-dk2 GPIO85
function reset_voice(){
  echo 85 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio85/direction
  echo 1 > /sys/class/gpio/gpio85/value
  echo 0 > /sys/class/gpio/gpio85/value
  echo 1 > /sys/class/gpio/gpio85/value 
  sleep 2
}

function reset_creator(){
  echo 18 > /sys/class/gpio/export 2>/dev/null
  echo out > /sys/class/gpio/gpio18/direction
  echo 1 > /sys/class/gpio/gpio18/value
  echo 0 > /sys/class/gpio/gpio18/value
  echo 1 > /sys/class/gpio/gpio18/value
}

function try_program_creator() {
  if [ -n "$P4DETECT" ]; 
  then 
	  CABLE=sysfsgpio_creator
  else
	  CABLE=matrix_creator
  fi

  reset_creator
  sleep 0.1
  xc3sprog -c $CABLE blob/system_creator.bit -p 1 > /dev/null 2> /dev/null
}

function try_program_voice() {
  if [ -n "$P4DETECT" ]; 
  then 
	  CABLE=sysfsgpio_voice
  else
	  CABLE=matrix_voice
  fi

  reset_voice
  sleep 0.1
  xc3sprog -c $CABLE blob/bscan_spi_s6lx9_ftg256.bit > /dev/null 2> /dev/null
  sleep 0.1
  xc3sprog -c $CABLE -I blob/system_voice.bit > /dev/null 2> /dev/null
}

function update_voice(){
count=0
while [  $count -lt 5 ]; do 
  try_program_voice
  if [ $? -eq 0 ];then
        echo "****  MATRIX Voice FPGA Software has been updated!"
	reset_voice
        exit 0
   fi
  let count=count+1
done
}

function program_creator(){
count=0
while [  $count -lt 5 ]; do
  try_program_creator
  if [ $? -eq 0 ];then
        echo "**** MATRIX Creator FPGA has been programmed!"
	./fpga_info
        exit 0
   fi
  let count=count+1
done
}

function check_voice() {
  reset_voice
  COMPARE_VERSION=$(diff <(./fpga_info | grep FPGA) <(cat voice.version)|wc -l)
  if [ "$COMPARE_VERSION" == "0" ];then
     echo "*** MATRIX Voice has a updated firmware"
     exit 0
   else #failed
     update_voice
  fi
}

# some pins of creator have been occupied in stmewmp157f-dk2, so stop the attemption of programming the creator
# program_creator # If MATRIX Creator has not been detected, try with MATRIX Voice steps
check_voice

echo "**** Could not program FPGA"
exit 1

