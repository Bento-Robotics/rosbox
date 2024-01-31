import os

from ament_index_python.packages import get_package_share_path

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.conditions import IfCondition, UnlessCondition
from launch.substitutions import Command, EnvironmentVariable, PathJoinSubstitution
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.substitutions import FindPackageShare

from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='edu_robot',
            executable='iotbot-shield',
            name='bento',
            parameters=[PathJoinSubstitution(['./', 'parameters', 'zyklop.yaml'])],
            namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento"),
            # prefix=['gdbserver localhost:3000'],
            output='screen'
        ),

        IncludeLaunchDescription(
            PythonLaunchDescriptionSource([
                PathJoinSubstitution([
                    FindPackageShare('edu_robot'),
                    'launch',
                    'eduard-diagnostic.launch.py'
                ]),
            ])
        ),
        
        Node(
            package='joy_linux',
            executable='joy_linux_node',
            parameters=[{'autorepeat_rate': 20.0}],
            namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento")
        ),

        Node(
            package='edu_robot_control',
            executable='remote_control',
            parameters=[ PathJoinSubstitution(['./', 'parameters', 'zyklop_gamepad.yaml'])],
            namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento")
        ),

        Node(
            package='usb_cam',
            namespace='Monocle',
            executable='usb_cam_node_exe',
            name='CAM',
            parameters=[(PathJoinSubstitution(['./', 'parameters', 'Monocle_Camera.yaml']))]
        )
    ])

