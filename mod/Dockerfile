FROM docker.injective.dev/go-cross:latest
WORKDIR /src
ONBUILD COPY go.mod .
ONBUILD COPY go.sum .
ONBUILD RUN go mod download
ONBUILD RUN touch /mod
