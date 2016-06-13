IMAGE_NAME=ansible-ec2
IMAGE_TAG=latest

CONJUR_APPLIANCE ?= conjur

.PHONY: all build run ssh clean clean-images
all:
	build

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
		
run:
	docker run -d \
	--link $(CONJUR_APPLIANCE):conjur \
	-v $(CURDIR)/../:/mnt/ansible-ec2 \
	$(IMAGE_NAME):$(IMAGE_TAG) 

ssh:
	ID=$$(docker ps | grep '$(IMAGE_NAME)' | awk '{print $$1}') && \
	docker exec -it $$ID bash

clean:
	IDS=$$(docker ps -a | grep '$(IMAGE_NAME)' | awk '{print $$1}') && \
	docker rm -f $$IDS
	
clean-images: clean
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG)
