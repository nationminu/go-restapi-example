FROM ubuntu:20.04 AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git golang \
        sudo && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash golang

# Switch to hummingbot user
USER golang:golang
WORKDIR /home/golang

COPY --chown=golang:golang main.go main.go 

RUN go get github.com/google/uuid && go build

# Build final image using artifacts from builer
FROM ubuntu:20.04 AS release
# Dockerfile author / maintainer 
LABEL maintainer="rockPLACE, Inc. <dev@rockplace.co.kr>"

RUN useradd -m -s /bin/bash golang && \
    mkdir /home/golang/bin && chown -R golang:golang /home/golang/bin

# Switch to hummingbot user
USER golang:golang
WORKDIR /home/golang

# Copy all build artifacts from builder image
COPY --from=builder --chown=golang:golang /home/golang/* /home/golang/bin

EXPOSE 10000

CMD "/home/golang/bin/golang"