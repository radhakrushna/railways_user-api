FROM golang:1.14.6

ENV REPO_URL=github.com/radhakrushna/railways_user-api

ENV GOPATH=/app

ENV APP_PATH=$GOPATH/src/$REPO_URL

ENV WORKPATH=$APP_PATH/src

COPY src $WORKPATH

WORKDIR $WORKPATH
RUN go get github.com/gin-gonic/gin
RUN go build -o railways-api .

EXPOSE 8080

CMD ["./railways-api"]