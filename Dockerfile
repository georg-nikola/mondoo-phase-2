
# Start with a base image containing Go
FROM golang:1.22.2 as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY *.go ./

# Build the Go app
RUN go build -o mondoo.example .

# Start a new stage from scratch
FROM alpine:latest

# Install libc6-compat package for compatibility
RUN apk add --no-cache libc6-compat

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/mondoo.example /mondoo.example

# Ensure the binary is executable
RUN chmod +x /mondoo.example

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the executable
CMD ["./mondoo.example"]

