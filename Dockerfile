FROM ros:humble

# Install dependencies & utilities
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install \
		 ros-humble-diagnostic-updater \
		 ros-humble-diagnostic-aggregator \
		 ros-humble-joy-linux \
		 #ros-humble-camera-ros \
     ros-humble-libcamera \
		 ros-humble-zbar-ros \
     btop libcamera-tools can-utils \
		 -y && rm -rf /var/lib/apt/lists/*


# Create workspace
RUN mkdir -p /bento_ws/src
WORKDIR /bento_ws

# Get sources
RUN cd src &&\
	 git clone https://github.com/Bento-Robotics/bento_drive &&\
	 git clone https://github.com/Bento-Robotics/TunnelVision &&\
   cd ..

# inclue camera_ros and dependencies from specific source
RUN cd src &&\
	 git clone https://github.com/christianrauch/camera_ros &&\
   git -C camera_ros checkout fix_dynamic_extent &&\
	 cd .. &&\
   apt-get update &&\
   bash -c ". /opt/ros/$ROS_DISTRO/setup.bash &&\
            rosdep install --from-paths src --ignore-src -y --skip-keys='image_view ament_lint_auto ament_cmake_clang_format ament_cmake_cppcheck ament_cmake_flake8 ament_cmake_lint_cmake ament_cmake_mypy ament_cmake_pep257 ament_cmake_pyflakes ament_cmake_xmllint'" &&\
   rm -rf /var/lib/apt/lists/*

# Build workspace
RUN bash -c " \
	 . /opt/ros/$ROS_DISTRO/setup.bash &&\
         colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release \
	 "

# Set up automatic sourcing
RUN echo -e "source /opt/ros/humble/setup.bash\nsource /bento_ws/install/setup.bash" >> ~/.bashrc

# Add entry point
COPY --chmod=555 ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
