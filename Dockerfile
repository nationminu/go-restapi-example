FROM ubuntu:20.04

ENV PATH=$PATH:/usr/local/go/bin

ADD https://golang.org/dl/go1.16.1.linux-amd64.tar.gz ./

RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.1.linux-amd64.tar.gz

RUN useradd -m -s /bin/bash ghost && \
    mkdir /home/ghost/restapi && chown -R golang:golang /home/ghost/restapi

COPY --chown=golang:golang main.go /home/ghost/restapi/main.go 

RUN cd /home/ghost/restapi/
EXPOSE 10000

CMD ["go","run","main.go"]