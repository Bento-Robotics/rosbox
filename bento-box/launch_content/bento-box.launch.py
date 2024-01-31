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
    bento_box = Node(
        package='edu_robot',
        executable='ethernet-gateway',
        name='bento',
        parameters=[PathJoinSubstitution(['./', 'bento-box.yaml'])],
        namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento"),
        # prefix=['gdbserver localhost:3000'],
        output='screen'
    )

    aggregator = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([
                FindPackageShare('edu_robot'),
                'launch',
                'eduard-diagnostic.launch.py'
            ]),
        ])
    )

    joy_node = Node(
        package='joy_linux',
        executable='joy_linux_node',
        parameters=[{'autorepeat_rate': 20.0}],
        namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento")
    )

    remote_control_node = Node(
        package='edu_robot_control',
        executable='remote_control',
        parameters=[ PathJoinSubstitution(['./', 'bento_gamepad.yaml'])],
        namespace=EnvironmentVariable('EDU_ROBOT_NAMESPACE', default_value="bento")
    )

    return LaunchDescription([
        bento_box,
        aggregator,
        joy_node,
        remote_control_node
    ])

