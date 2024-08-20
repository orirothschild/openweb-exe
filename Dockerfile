# Stage 1: Build the Go binary
FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o main .

# Stage 2: Create a lightweight image for running the application
FROM alpine:latest

WORKDIR /app

# Copy the Go binary from the builder stage
COPY --from=builder /app/main .
# Copy static files (e.g., views directory) from the builder stage
COPY --from=builder /app/views /app/views
# Copy the .env file
COPY .env .env

EXPOSE 8080

CMD ["./main"]
