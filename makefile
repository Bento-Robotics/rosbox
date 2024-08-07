image_name = rosbox:robot

build-container:
	podman build -t $(image_name) .

multiarch-build-and-push:
	podman manifest create bentorobotics/$(image_name)
	podman build --platform linux/arm64,linux/amd64 --manifest bentorobotics/$(image_name) .
	podman manifest push bentorobotics/$(image_name) docker.io/bentorobotics/$(image_name)

clean:
	podman image rm localhost/bentorobotics/$(image_name)
