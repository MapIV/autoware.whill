#!/bin/bash

sudo chmod 666 /dev/ttyUSB0
sudo systemctl start can0_linkup.service
sudo systemctl start ptp4l_lidar.service