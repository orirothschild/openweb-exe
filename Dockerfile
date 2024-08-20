# Stage 1: Build the Go binary
FROM golang:1.20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum for caching dependencies
COPY go.mod go.sum ./

# Download Go module dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go binary
RUN go build -o main .

# Stage 2: Create a lightweight image for running the application
FROM alpine:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the Go binary from the builder stage
COPY --from=builder /app/main .

# Copy static files (e.g., views directory) from the builder stage
COPY --from=builder /app/views /app/views

# Set environment variables
ENV DB_USER=myuser
ENV DB_PASSWORD=mypassword
ENV DB_HOST=myhost
ENV DB_NAME=mydatabase

# Expose the port the application will run on
EXPOSE 8080

# Command to run the application
CMD ["./main"]
