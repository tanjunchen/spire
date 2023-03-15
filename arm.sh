#!/bin/bash

set -o errexit

BIN_DIR="output/bin"
REL_OS_ARCH_ARM64="arm64 amd64"
REL_OS_ARCH_AMD64="amd64"
REL_OS="linux"
IMAGE_REPO="docker.io/tanjunchen"
IMAGE_NAME_1="spire-server"
IMAGE_NAME_2="spire-agent"
IMAGE_NAME_3="k8s-workload-registrar"
IMAGE_TAG="1.5.4"

export GOPROXY="https://goproxy.cn"

echo "===> docker buildx build ${IMAGE_NAME_4} <==="
rm -rf wait-for-it
git clone https://github.com/lqhl/wait-for-it
cd wait-for-it
docker buildx  build  --platform=linux/arm64 -t ${IMAGE_REPO}/wait-for-it:arm64 -f Dockerfile . --load
docker buildx  build  --platform=linux/amd64 -t ${IMAGE_REPO}/wait-for-it:amd64 -f Dockerfile . --load
docker push ${IMAGE_REPO}/wait-for-it:arm64
docker push ${IMAGE_REPO}/wait-for-it:amd64
docker manifest create ${IMAGE_REPO}/wait-for-it:latest ${IMAGE_REPO}/wait-for-it:arm64 ${IMAGE_REPO}/wait-for-it:amd64 --amend
docker manifest push ${IMAGE_REPO}/wait-for-it:latest
cd ..
rm -rf wait-for-it

rm -rf output

echo "===> compile spire-server spire-agent k8s-workload-registrar binary <==="
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o=${BIN_DIR}/${REL_OS}/amd64/ ./cmd/${IMAGE_NAME_1} \
	&& CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o=${BIN_DIR}/${REL_OS}/arm64/ ./cmd/${IMAGE_NAME_1} \
	&& CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o=${BIN_DIR}/${REL_OS}/arm64/ ./cmd/${IMAGE_NAME_2} \
	&& CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o=${BIN_DIR}/${REL_OS}/amd64/ ./cmd/${IMAGE_NAME_2} \
  && CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o=${BIN_DIR}/${REL_OS}/arm64/ ./support/k8s/${IMAGE_NAME_3} \
  && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o=${BIN_DIR}/${REL_OS}/amd64/ ./support/k8s/${IMAGE_NAME_3}

echo "===> docker buildx build ${IMAGE_NAME_1} <==="
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=amd64 -t ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-amd64 --platform linux/amd64  -f  arm/Dockerfile.${IMAGE_NAME_1} . --load
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=arm64 -t ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-arm64 --platform linux/arm64  -f  arm/Dockerfile.${IMAGE_NAME_1} . --load

echo "===> docker push <==="
docker push ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-amd64
docker push ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-arm64

echo "===> docker manifest <==="
docker manifest create ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG} ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-arm64 ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}-${REL_OS}-amd64 --amend
docker manifest push ${IMAGE_REPO}/${IMAGE_NAME_1}:${IMAGE_TAG}

echo "===> docker buildx build ${IMAGE_NAME_2}<==="
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=amd64 -t ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-amd64 --platform linux/amd64  -f  arm/Dockerfile.${IMAGE_NAME_2} . --load
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=arm64 -t ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-arm64 --platform linux/arm64  -f  arm/Dockerfile.${IMAGE_NAME_2} . --load

echo "===> docker push <==="
docker push ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-amd64
docker push ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-arm64

echo "===> docker manifest <==="
docker manifest create ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG} ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-arm64 ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}-${REL_OS}-amd64 --amend
docker manifest push ${IMAGE_REPO}/${IMAGE_NAME_2}:${IMAGE_TAG}

echo "===> docker buildx build ${IMAGE_NAME_3}<==="
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=amd64 -t ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-amd64 --platform linux/amd64  -f  arm/Dockerfile.${IMAGE_NAME_3} . --load
docker buildx build --build-arg OS=${REL_OS} --build-arg ARCH=arm64 -t ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-arm64 --platform linux/arm64  -f  arm/Dockerfile.${IMAGE_NAME_3} . --load

echo "===> docker push <==="
docker push ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-amd64
docker push ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-arm64

echo "===> docker manifest <==="
docker manifest create ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG} ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-arm64 ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}-${REL_OS}-amd64 --amend
docker manifest push ${IMAGE_REPO}/${IMAGE_NAME_3}:${IMAGE_TAG}

echo "===> build spire-server spire-agent k8s-workload-registrar images successful <==="
