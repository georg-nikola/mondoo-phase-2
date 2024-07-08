#Download latest package and unzip it
FROM alpine:latest AS unzipper
RUN apk add unzip wget curl jq

ENV REPO_OWNER=georg-nikola
ENV REPO_NAME=mondoo-phase-1

# Fetch the tarball URL
RUN curl -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest | jq -r '.tarball_url' > tarball_url.txt

# Download the tarball
RUN wget $(cat tarball_url.txt) -O source.tar.gz

# Extract the tar.gz file
RUN tar -xzf source.tar.gz --strip-components=1

FROM golang:1.22.2 as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go.mod and go.sum files from Phase 1 repository
COPY --from=unzipper ./go.mod ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the Phase 1 repository to the Working Directory inside the container
COPY --from=unzipper ./*.go ./

# Build the Go app
RUN go build -o mondoo.example .

# Start a new stage from scratch
FROM alpine:latest

# Install libc6-compat package for compatibility
RUN apk add --no-cache libc6-compat

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/mondoo.example .

# Ensure the binary is executable
RUN chmod +x /mondoo.example

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the executable
CMD ["./mondoo.example"]

