FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w' -o memoryleak main.go

FROM alpine
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.schema-version=1.0 \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/nbarnum/docker-memory-leak"
COPY --from=build-env /src/memoryleak /usr/local/bin
EXPOSE 8081
ENTRYPOINT ["/usr/local/bin/memoryleak"]
