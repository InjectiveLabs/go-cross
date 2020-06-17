# go-cross

`docker.injective.dev/go-cross` is a Docker image to cross compile golang binaries and plugins to linux/darwin/windows.

It is based off work from `docker/cli`:
- https://hub.docker.com/r/dockercore/golang-cross
- https://github.com/docker/cli/tree/master/scripts/build

## Cross-compiling using docker build

Using `docker.injective.dev/go-cross:mod` to cache go modules and `docker.injective.dev/go-cross:build` that has [ONBUILD](https://docs.docker.com/engine/reference/builder/#onbuild) triggers you can define a `Dockerfile` with only the following:

```Dockerfile
FROM docker.injective.dev/go-cross:mod AS mod
FROM docker.injective.dev/go-cross:build
```

For example, if my project looks like this:

```
❯ tree
.
├── cmd
│   └── program
│       └── main.go
├── Dockerfile
├── go.mod
└── go.sum
```

Then you can cross-compile the program like so (`BUILDMODE` and `LDFLAGS` are optional):

```sh
docker build -t my-cross-compile --build-arg PKG="./cmd/program" --build-arg BUILDMODE="default" --build-arg LDFLAGS="" .
```

Extract the binaries by creating a temporary container and `docker cp` them out.

```sh
mkdir bin
docker create --name tmp my-cross-compile bash
docker cp tmp:/root/go/bin/. bin
docker rm tmp
```

## Private Go modules

If you have private go modules, you can use that as long as the following are true:
- The stage is set to `AS mod`
- The go module cache is in `/root/.cache/go-build` and `/root/go/pkg/mod`

```Dockerfile
FROM golang:1.14-alpine AS mod
ENV GOPATH=/root/go
ENV GOCACHE=/root/.cache/go-build
RUN apk add --no-cache git openssh

# Copy or mount in SSH, certificates, etc...

WORKDIR /src
COPY go.mod .
COPY go.sum .
RUN go mod download
RUN touch /mod

FROM docker.injective.dev/go-cross:build
# ensures that dependency on mod stage (1) is properly resolved
COPY --from=mod /mod /mod
```
