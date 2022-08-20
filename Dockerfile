FROM golang:1.19 AS builder

ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

WORKDIR /app

COPY go.mod go.sum server.go ./

RUN go build -a -installsuffix cgo -o app .


FROM scratch

WORKDIR /app

EXPOSE 3000

COPY --from=builder /app/app ./

CMD [ "./app" ]
