FROM golang:1.20 as builder

WORKDIR /go/src/app
ENV CGO_ENABLED=0

COPY go.mod go.sum ./
RUN go mod graph | awk '{if ($1 !~ "@") print $2}' | xargs go get


COPY unbound_exporter.go ./
RUN go build unbound_exporter.go

FROM scratch
COPY --from=builder /go/src/app/unbound_exporter /unbound_exporter
ENTRYPOINT ["/unbound_exporter"]