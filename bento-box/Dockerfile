FROM ros:humble

# Install dependencies & utilities
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install \
		 btop \
		 ros-humble-diagnostic-updater \
		 ros-humble-diagnostic-aggregator \
		 ros-humble-joy-linux \
		 -y && rm -rf /var/lib/apt/lists/*


# Create workspace
RUN mkdir -p /bento_ws/src
WORKDIR /bento_ws

# Get sources
RUN cd src &&\
	 git clone https://github.com/Bento-Robotics/edu_robot &&\
	 git clone https://github.com/Bento-Robotics/edu_robot_control &&\
	 cd ..

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

# launch control node and joy interpreter
CMD [ "ros2", "launch", "edu_robot", "bento-box.launch.py" ]
