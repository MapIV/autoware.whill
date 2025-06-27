#!/bin/bash


helpsc() {
    echo "  cln   : Clean objects"
    echo "  dpd   : Install dependency"
    echo "  bld   : Build all packages" 
    echo "  bldo  : Build all packages up to the specified package"
    echo "  ins   : Source launch setup"
    echo "  sethd : Setting hardware device"
    echo "  lsim  : Launch sample logging simulator"
    echo "  lsimw : Launch whill  logging simulator"
    echo "  bag   : Play rosbag for sample logging simulator"
    echo "  bagw  : Play sample for whill  logging simulator"
    echo "  whill : Launch whill"
    echo "  whill_l : Launch whill, localization only"
    echo "  whill_l_sim : Launch whill, localization only in simulation"
    echo "  recw  : Record rosbag for whill"
}

alias cln="rm -rf build/ install/ log/"
alias dpd="install_dependency"
alias bld="colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release"
alias bldo="colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --packages-up-to"
alias ins="install_setup"
alias sethd="setup_hardware_device"
alias lsim="launch_lsim"
alias lsimw="launch_lsim_whill"
alias bag="ros2 bag play ~/autoware_map/sample-rosbag/ -r 0.2 -s sqlite3"
alias bagw="ros2 bag play ~/whill_bag/rosbag2_2025_04_22-10_59_26 -r 0.2 --clock"
alias whill="launch_whill"
alias whill_l="launch_whill_localization"
alias whill_l_sim="launch_whill_localization_sim"
alias recw="ros2 bag record -o ~/whill_bag/bagfile \
                /sensing/lidar/top/pandar_packets \
                /sensing/imu/tamagawa/from_can_bus \
                /whill/odom 
                /clock"
alias rec_yb="ros2 bag record -o ~/whill_bag/bagfile_yaw_bias \
                /sensing/lidar/top/pandar_packets \
                /sensing/imu/tamagawa/from_can_bus \
                /whill/odom \
                /whill/speed_profile \
                /localization/pose_twist_fusion_filter/estimated_yaw_bias \
                /clock"
alias rec_gb="ros2 bag record -o ~/whill_bag/bagfile_gyro_bias \
                /sensing/lidar/top/pandar_packets \
                /sensing/imu/tamagawa/from_can_bus \
                /whill/odom \
                /whill/speed_profile \
                /sensing/imu/gyro_bias \
                /clock"

alias rec_all="ros2 bag record -o ~/whill_bag/rec_all\
                /sensing/lidar/top/pandar_packets \
                /sensing/imu/tamagawa/from_can_bus \
                /whill/controller/joy \
                /whill/modelc_state \
                /whill/odom \
                /whill/speed_profile \
                /whill/states/batttery_state \
                /whill/states/imu \
                /whill/states/joint_state \
                /whill/states/joy \
                /whill/twist_with_covariance \
                /clock"

# alias bag="ros2 bag play ~/whill_test/ros2/rosbag2_2025_04_11-16_19_18 -r 0.2 \
#             --topics /lidar/top/pandar_packets /imu/tamagawa/from_can_bus /whill/odom \
#             --remap /lidar/top/pandar_packets:=/sensing/lidar/top/pandar_packets \
#                     /imu/tamagawa/from_can_bus:=/sensing/imu/tamagawa/from_can_bus \
#             --clock"

function install_dependency () {
    sudo apt update && sudo apt upgrade
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
}

function install_setup () {
    source install/setup.bash
}
install_setup

function setup_hardware_device () {
    sudo ip link set can0 type can bitrate 500000 
    sudo ip link set can0 up
    # sudo chmod 777 /dev/ttyUSB0
    sudo ptpd -M -i enp45s0
}

function launch_lsim () {
    install_setup
    ros2 launch autoware_launch logging_simulator.launch.xml map_path:=$HOME/autoware_map/sample-map-rosbag
}

function launch_lsim_whill () {
    install_setup
    ros2 launch autoware_launch logging_simulator.whill.launch.xml map_path:=$HOME/autoware_map/office_map 
}

function launch_whill () {
    install_setup
    ros2 launch autoware_launch autoware.whill.launch.xml map_path:=$HOME/autoware_map/office_map 
}

function launch_whill_localization () {
    install_setup
    ros2 launch autoware_launch autoware.whill.localization_only.launch.xml map_path:=$HOME/autoware_map/office_map 
}

function launch_whill_localization_sim () {
    install_setup
    ros2 launch autoware_launch autoware.whill.localization_only.launch.xml \
        map_path:=$HOME/autoware_map/office_map \
        use_sim_time:=true \
        launch_sensing_driver:=false \
        launch_vehicle_interface:=false
}