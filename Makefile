REPO:=martkcz/alpine-php
VERSION:=8.0

all: build release

build:
	docker build -t $(REPO):${VERSION} --target main .
	#docker build -t $(REPO):${VERSION}-dev --target dev .

release:
	docker push $(REPO):${VERSION}
	#docker push $(REPO):${VERSION}-dev
