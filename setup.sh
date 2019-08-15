#!/bin/bash

# This script will setup the most stable release of ESP-IDF
# The environment is installed in the ~/esp directory (by default).
# Environment variables are set in the ~/.profile directory.

# Change this to manually set the install location
ESP_DIR="$HOME/esp"

# Install deps
sudo apt-get --assume-yes install gcc git wget make libncurses-dev flex bison gperf python python-pip python-setuptools python-serial python-cryptography python-future aria2

# Download toolchain
mkdir -p $ESP_DIR
cd $ESP_DIR
aria2c -x 16 https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
tar -xvf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
rm xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

# Setup path to toolchain
if grep -q "export ESP_DIR=" $HOME/.profile; then
	echo "ESP_DIR already defined"
else
	echo "export ESP_DIR=$(echo $ESP_DIR)" >> $HOME/.profile
fi
if grep -q "export PATH=\"\$ESP_DIR/xtensa-esp32-elf/bin" $HOME/.profile; then
	echo "PATH already defined"
else
	echo 'export PATH="$ESP_DIR/xtensa-esp32-elf/bin:$PATH"' >> $HOME/.profile
fi

# Get ESP-IDF
git clone -b v3.2.2 --recursive https://github.com/espressif/esp-idf.git

# Setup path to ESP-IDF
if grep -q "export IDF_PATH=" $HOME/.profile; then
	echo "IDF_PATH already defined"
else
	echo 'export IDF_PATH="$ESP_DIR/esp-idf"' >> $HOME/.profile
fi

# Install python deps
python -m pip install --user -r $IDF_PATH/requirements.txt

# Setup path to esptool
if grep -q "alias esptool" $HOME/.profile; then
	echo "esptool alias already defined"
else
	echo 'alias esptool="python $IDF_PATH/components/esptool_py/esptool/esptool.py"' >> $HOME/.profile
fi


# Setup path to espsecure
if grep -q "alias espsecure" $HOME/.profile; then
	echo "espsecure alias already defined"
else
	echo 'alias espsecure="python $IDF_PATH/components/esptool_py/esptool/espsecure.py"' >> $HOME/.profile
fi

# Setup path to espefuse
if grep -q "alias espefuse" $HOME/.profile; then
	echo "espefuse alias already defined"
else
	echo 'alias espefuse="python $IDF_PATH/components/esptool_py/esptool/espefuse.py"' >> $HOME/.profile
fi

# Set environment variables
source $HOME/.profile

# Exit script
exit
