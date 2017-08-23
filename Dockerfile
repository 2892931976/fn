# build stage
FROM golang:alpine AS build-env
RUN apk --no-cache add build-base git bzr mercurial gcc
ENV D=/go/src/github.com/fnproject/fn
# TODO: once we get rid of the vendor dirs, add dep step using `dep ensure --vendor-only` from here: https://medium.com/travis-on-docker/triple-stage-docker-builds-with-go-and-angular-1b7d2006cb88
ADD . $D
RUN cd $D && go build -o fn-alpine && cp fn-alpine /tmp/

# final stage
FROM fnproject/dind
WORKDIR /app
COPY --from=build-env /tmp/fn-alpine /app/functions
CMD ["./functions"]
