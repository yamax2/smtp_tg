FROM golang:1.13 AS builder

RUN apt install git

WORKDIR /app

COPY . .

# The image should be built with
# --build-arg ST_VERSION=`git describe --tags --always`
ARG ST_VERSION
RUN CGO_ENABLED=0 GOOS=linux go build \
        -ldflags "-s -w \
            -X main.Version=${ST_VERSION:-UNKNOWN_RELEASE}" \
        -a -o smtp_to_telegram





FROM ubuntu

# RUN apt install ca-certificates

COPY --from=builder /app/smtp_to_telegram /smtp_to_telegram

# USER daemon

ENV ST_SMTP_LISTEN "0.0.0.0:2525"
EXPOSE 2525

# ENTRYPOINT ["/smtp_to_telegram"]
