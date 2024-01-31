image_name = bento-box:1.1

build-container:
	podman build -t $(image_name) .

multiarch-build-and-push:
	podman manifest create bentorobotics/$(image_name)
	podman build --platform linux/arm64,linux/amd64 --manifest bentorobotics/$(image_name) .
	podman manifest push bentorobotics/$(image_name)
