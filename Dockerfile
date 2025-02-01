# Building and running
#
# docker build -t gp-nvim-test .
# docker run --rm gp-nvim-test
#

FROM ubuntu:22.04

# Prevent tzdata from asking for user input
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    build-essential \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install neovim from PPA
RUN add-apt-repository ppa:neovim-ppa/stable \
    && apt-get update \
    && apt-get install -y neovim \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /app

# Copy plugin files
COPY . .

# Set entrypoint
ENTRYPOINT ["./run_tests.sh"]
