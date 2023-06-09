# Use the official Ubuntu 20.04 image as the base
FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set the DEBIAN_FRONTEND environment variable to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install tzdata package
RUN apt-get install -y tzdata

# Set the desired timezone
ENV TZ=America/New_York

# Create a symbolic link for the timezone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata


RUN apt-get install -y git pkg-config libssl-dev


# Set the environment variables
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /home

RUN git clone https://github.com/matter-labs/foundry-zksync.git
RUN git clone https://github.com/sammyshakes/sample-fzksync-project.git

RUN cd foundry-zksync && cargo build -p foundry-cli

RUN cd sample-fzksync-project && git submodule update --init --recursive

# Define the entry point
CMD ["/bin/bash"]
