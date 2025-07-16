#!/bin/bash

# OS environment
sudo cp $HOME/autoware.whill/config/netplan.yaml /etc/netplan/99_autoware_whill.yaml
sudo cp $HOME/autoware.whill/config/ptp4l.conf /etc/linuxptp/ptp4l.conf

# service
sudo cp $HOME/autoware.whill/service/*.service /etc/systemd/system -v
sudo systemctl daemon-reload

sudo systemctl enable can0_linkup.service
sudo systemctl enable ptp4l_lidar.service
sudo systemctl enable multicast-lo.service

echo "Please reboot the system to apply settings!"
