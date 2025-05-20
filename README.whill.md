# 使用方法


## インストール

autoware公式の[Sorce installation](https://autowarefoundation.github.io/autoware-documentation/main/installation/autoware/source-installation/)にしたがって，autowareのインストールとコンパイルを行ってください．

以下の箇所については，手動でファイルの修正を行ってください．

``` diff
diff --git a/planning/autoware_static_centerline_generator/package.xml b/planning/autoware_static_centerline_generator/package.xml
index cea18e560..1562bb158 100644
--- a/planning/autoware_static_centerline_generator/package.xml
+++ b/planning/autoware_static_centerline_generator/package.xml
@@ -38,6 +38,7 @@
   <depend>geometry_msgs</depend>
   <depend>rclcpp</depend>
   <depend>rclcpp_components</depend>
+  <depend>grid_map_core</depend>
 
   <exec_depend>python3-flask-cors</exec_depend>
   <exec_depend>rosidl_default_runtime</exec_depend>
diff --git a/planning/autoware_velocity_smoother/package.xml b/planning/autoware_velocity_smoother/package.xml
index 96462602d..a3c03ab46 100644
--- a/planning/autoware_velocity_smoother/package.xml
+++ b/planning/autoware_velocity_smoother/package.xml
@@ -36,6 +36,7 @@
   <depend>tf2_ros</depend>
   <depend>tier4_debug_msgs</depend>
   <depend>tier4_planning_msgs</depend>
+  <depend>grid_map_core</depend>
 
   <test_depend>ament_cmake_ros</test_depend>
   <test_depend>ament_lint_auto</test_depend>
diff --git a/planning/motion_velocity_planner/autoware_motion_velocity_planner_node/package.xml b/planning/motion_velocity_planner/autoware_motion_velocity_planner_node/package.xml
index 186140cba..f22bbf8f7 100644
--- a/planning/motion_velocity_planner/autoware_motion_velocity_planner_node/package.xml
+++ b/planning/motion_velocity_planner/autoware_motion_velocity_planner_node/package.xml
@@ -41,6 +41,7 @@
   <depend>tier4_metric_msgs</depend>
   <depend>tier4_planning_msgs</depend>
   <depend>visualization_msgs</depend>
+  <depend>grid_map_core</depend>
 
   <exec_depend>rosidl_default_runtime</exec_depend>
```


## autowareの追加設定

autowareに関連する以下の設定を公式に従って行ってください．
- DDSのCyclonDDSへの変更：[DDS settings for ROS 2 and Autoware](https://autowarefoundation.github.io/autoware-documentation/main/installation/additional-settings-for-developers/network-configuration/dds-settings/)
- マルチキャストの設定：[Enable multicast on lo](https://autowarefoundation.github.io/autoware-documentation/main/installation/additional-settings-for-developers/network-configuration/enable-multicast-for-lo/)

autowareでは，DDSの実装をCyclonDDSに設定することが推奨されています．
マルチキャストの設定が正しく行われていないと，社内のネットワークに大量のパケットを流出してしまいます．



## ハードウェアの接続

使用する外部機器とその物理インターフェースは以下のとおりです．
- Vehicle : Whill - Model C
    - USB(Serial)
- IMU : Tamagawa - TAG300N1000
    - USB(CAN)
- LiDAR : Hesai - PandarQT64
    - Ethernet(100BASE-T)

IMUとLiDARについては，外部電源を必要とします．Whillを走行させる際は，モバイルバッテリーから電源を取るようにしてください．

### USB(Serial)の設定

USB(Serial)については，他のUSBデバイスを接続することでデバイス名が頻繁に変わる可能性が高いです．
Whillの車速・ステア角が表示されないなど通信に問題があれば，実際のデバイス名と`whill interface`に登録されているデバイス名が一致しているか，確認ください．
上記のトラブルを避けるために，常にデバイス名が一意になるように，udevを登録することがおすすめです．


### USB(CAN)の設定

USB(Serial)と同様，デバイス名を確認ください．
また，USB(CAN)では接続するたびに，通信速度設定とリンクアップを行う必要があります．
デバイス名が`can0`のとき，以下のとおりです．
- install
    ```bash
    sudo apt install can-utils
    ```
- setup
    ```bash
    sudo ptpd -M -i enp45s0
    ```


### ptpの設定

LidarとPCの時刻同期を行うために，PCを起動するたびに，ptpサーバを立ち上げる必要があります．
NIC名が`enp45s0`のとき，以下のとおりです．
- install
    ```bash
    sudo apt install ptpd
    ```
- setup
    ```bash
    sudo ptpd -M -i enp45s0
    ```

## autowareの立ち上げ

autowareのsampleと異なり，whill専用にlaunchファイルを用意しています．
以下のコマンドにより，立ち上げを行ってください．
- logging simulator
    ```
    ros2 launch autoware_launch logging_simulator.whill.launch.xml map_path:=$HOME/autoware_map/office_map 
    ```
- 実機
    ```
    ros2 launch autoware_launch autoware.whill.launch.xml map_path:=$HOME/autoware_map/office_map
    ```


## コマンドのalias集`cmds.sh`について

`cmds.sh`に，下記のようなよく使うコマンドのaliasを登録しています．
- `bld` : ビルド
- `sethd` : ハードウェアの接続・設定
- `lsimw` : whillのlsim
- `whill` : whillの実機


mapやrosbagのパスなどを修正して活用ください．