IMAGE_NAME=ansible-ec2
IMAGE_TAG=lastest

CONJUR_APPLIANCE=conjur
CONJUR_CERT_PATH=conjur-demo.pem

.PHONY: all build run ssh clean clean-all
all:
	build

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
		
run:
	docker run -d \
	--link $(CONJUR_APPLIANCE) \
	-v $$HOME/.netrc:/root/.netrc \
	-v $$HOME/.conjurrc:/root/.conjurrc \
	-v $$HOME/$(CONJUR_CERT_PATH):/root/$(CONJUR_CERT_PATH) \
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