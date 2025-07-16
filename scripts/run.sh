#!/bin/bash

bash /home/whill/autoware.whill/scripts/setting.sh

mkdir -p /tmp/autoware_logs
screen -S autoware_launch -L -Logfile /tmp/autoware_logs/autoware_launch.log -ADm bash -l -c "source /home/whill/autoware.whill/install/setup.bash && ros2 launch autoware_launch autoware.whill.launch.xml" &
