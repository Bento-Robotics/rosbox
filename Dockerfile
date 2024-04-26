FROM ros:humble

# Install dependencies & utilities
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install \
		 btop \
		 qt5ct \
		 fonts-comfortaa \
		 ros-humble-rqt \
		 ros-humble-rqt-robot-monitor \
		 ros-humble-rqt-reconfigure \
		 ros-humble-rqt-tf-tree \
		 ros-humble-rqt-image-view \
		 ros-humble-image-transport-plugins \
		 -y && rm -rf /var/lib/apt/lists/*


# Create workspace
RUN mkdir -p /bento_ws/src
WORKDIR /bento_ws

# Get sources
RUN cd src &&\
	 git clone https://github.com/EduArt-Robotik/edu_drive_ros2/ &&\
	 cd ..

# Build workspace
RUN bash -c " \
	 . /opt/ros/$ROS_DISTRO/setup.bash &&\
         colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release \
	 "

# Set up automatic sourcing
RUN echo -e "source /opt/ros/humble/setup.bash\nsource /bento_ws/install/setup.bash" >> ~/.bashrc

# Add entry point
ENTRYPOINT [ "/bin/bash" ]
