FROM golang:1.25-alpine@sha256:6032270f7aa8f5831fb69a1024b1b21898b986e8073c71781437cfc0c5f49051 as build
RUN apk --no-cache add git
WORKDIR /go/src/github.com/owasp-amass/amass
COPY . .
RUN go install -v ./...

FROM alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1
RUN apk --no-cache add ca-certificates
COPY --from=build /go/bin/amass /bin/amass
ENV HOME /
RUN addgroup user \
    && adduser user -D -G user \
    && mkdir /.config \
    && mkdir /.config/amass \
    && chown -R user:user /.config
USER user
ENTRYPOINT ["/bin/amass"]
