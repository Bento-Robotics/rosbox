FROM docker.io/ros:jazzy

# Install dependencies & utilities
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install \
                 ros-jazzy-diagnostic-updater \
                 ros-jazzy-diagnostic-aggregator \
                 ros-jazzy-joy-linux \
                 ros-jazzy-camera-ros \
                 ros-jazzy-libcamera \
                 ros-jazzy-zbar-ros \
                 ros-jazzy-rplidar-ros \
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

# Build workspace
RUN bash -c " \
	 . /opt/ros/$ROS_DISTRO/setup.bash &&\
         colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release \
	 "

# Set up automatic sourcing
RUN echo -e "source /opt/ros/jazzy/setup.bash\nsource /bento_ws/install/setup.bash" >> ~/.bashrc

# Add entry point
COPY --chmod=555 ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
