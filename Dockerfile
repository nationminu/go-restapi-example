FROM ubuntu:20.04

ENV PATH=$PATH:/usr/local/go/bin

ADD https://golang.org/dl/go1.16.1.linux-amd64.tar.gz ./

RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.1.linux-amd64.tar.gz

RUN useradd -m -s /bin/bash ghost && \
    mkdir /home/ghost/restapi && \
    mkdir /home/ghost/bin && \
    chown -R golang:golang /home/ghost/restapi

COPY --chown=ghost:ghost main.go /home/ghost/restapi/main.go 

RUN cd /home/ghost/restapi/ && \
    go get github.com/google/uuid && \
    go build && \ 
    mv restapi  /home/ghost/bun && \ 
    chown -R ghost:ghost /home/ghost/bun 
    
EXPOSE 10000

CMD ["go","run","main.go"]