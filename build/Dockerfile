FROM docker.injective.dev/go-cross:latest
ONBUILD ARG PKG=.
ONBUILD ARG BUILDMODE=default
ONBUILD ARG LDFLAGS=
ONBUILD COPY --from=mod $GOCACHE $GOCACHE
ONBUILD COPY --from=mod $GOPATH/pkg/mod $GOPATH/pkg/mod
WORKDIR /src
ONBUILD COPY . .
ONBUILD RUN /cross/build $PKG
