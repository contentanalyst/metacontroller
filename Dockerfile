FROM golang:1.14.4 AS build

COPY . /go/src/metacontroller.io/
WORKDIR /go/src/metacontroller.io/
ENV CGO_ENABLED=0
RUN make vendor && go install

FROM r1k8sacrdev.azurecr.io/r1/base/security-alpine3:v3
COPY --from=build /go/bin/metacontroller.io /usr/bin/metacontroller
RUN apk update && apk add --no-cache ca-certificates
RUN chown -R 2000:2000 /usr/bin/metacontroller
USER 2000
CMD ["/usr/bin/metacontroller"]
