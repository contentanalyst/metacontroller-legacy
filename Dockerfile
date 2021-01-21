FROM golang:1.10 AS build

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

COPY . /go/src/metacontroller.app/
WORKDIR /go/src/metacontroller.app/
ENV CGO_ENABLED=0
RUN dep ensure && go install

FROM r1k8sacrdev.azurecr.io/r1/base/security-alpine3:v3
RUN apk update && apk add --no-cache ca-certificates && apk add --update bash
COPY --from=build /go/bin/metacontroller.app /usr/bin/metacontroller
RUN chown -R 2000:2000 /usr/bin/metacontroller
USER 2000
CMD ["/usr/bin/metacontroller"]
