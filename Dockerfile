FROM golang:1.17.1-alpine3.14 AS builder
ARG HTTP_PROXY=""
ENV HTTP_PROXY=${HTTP_PROXY}
ARG HTTPS_PROXY=""
ENV HTTPS_PROXY=${HTTPS_PROXY}
WORKDIR /go/src/github.com/gliderlabs/registrator/
COPY . .
RUN \
	apk add --no-cache git \
	&& CGO_ENABLED=0 GOOS=linux go build \
		-a -installsuffix cgo \
		-ldflags "-X main.Version=$(cat VERSION)" \
		-o bin/registrator \
		.

FROM alpine:3.14
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/gliderlabs/registrator/bin/registrator /bin/registrator

ENTRYPOINT ["/bin/registrator"]
