FROM ubuntu:24.04
RUN apt-get update && apt-get install -y curl wget vim iputils-ping  iproute2 procps ca-certificates tzdata && rm -rf /var/lib/apt/lists/*

# Userdata, DIR,  Aliases
RUN useradd -m bob && mkdir /home/tmp

# Ownershop:
RUN chmod 1777 /home/tmp

# Aliases : 
RUN echo "alias cc='clear'" >> /etc/bash.bashrc 

