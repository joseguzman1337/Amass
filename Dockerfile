FROM golang:1.25-alpine@sha256:ac09a5f469f307e5da71e766b0bd59c9c49ea460a528cc3e6686513d64a6f1fb as build
RUN apk --no-cache add git
WORKDIR /go/src/github.com/owasp-amass/amass
COPY . .
RUN go install -v ./...

FROM alpine:latest@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62
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
