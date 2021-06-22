all:

base:
	docker build -t docker.injective.dev/go-cross-base -f base/Dockerfile .
	docker tag docker.injective.dev/go-cross-base gcr.io/injective-core/go-cross-base
	docker tag docker.injective.dev/go-cross-base gcr.io/injective-core/go-cross-base:1.16.5

main:
	docker build -t docker.injective.dev/go-cross -f Dockerfile .
	docker tag docker.injective.dev/go-cross gcr.io/injective-core/go-cross

mod: main
	docker build -t docker.injective.dev/go-cross:mod -f mod/Dockerfile .
	docker tag docker.injective.dev/go-cross:mod gcr.io/injective-core/go-cross:mod

build: main
	docker build -t docker.injective.dev/go-cross:build -f build/Dockerfile .
	docker tag docker.injective.dev/go-cross:build gcr.io/injective-core/go-cross:build

images: main mod build

push-base: base
	docker push gcr.io/injective-core/go-cross-base
	docker push gcr.io/injective-core/go-cross-base:1.16.5

push: main mod build
	docker push gcr.io/injective-core/go-cross
	docker push gcr.io/injective-core/go-cross:mod
	docker push gcr.io/injective-core/go-cross:build

.PHONY: base push-base main mod build push
