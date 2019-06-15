######################################################################
# Docker image for IBM Cloud Development
# Build with:
#     docker build --rm -t ibm-cloud-dev .
# Run with:
#     docker run --rm -it -h ibmcloud -v $(pwd):/app ibm-cloud-dev
# To use Docker in this container you must also mount:
#     -v /var/run/docker.sock:/var/run/docker.sock
######################################################################
FROM python:3.7-slim

# Add packages needed to do development
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    iputils-ping \
    sudo \
    vim

# Create a non-root user to become and give it sudo access
RUN useradd -m devops && \
    usermod -aG sudo devops && \
    echo "devops ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/devops
USER devops

# Install IBM Cloud CLI tools for development as devops user
RUN sudo -H -i -u devops sh -c 'curl -sL http://ibm.biz/idt-installer | bash'
RUN sudo usermod -aG docker devops

# Setup development environment and expose your ports
WORKDIR /app
EXPOSE 5000 8080
VOLUME ["/app", "/var/run/docker.sock"]

# To use Docker in this container you must mount -v /var/run/docker.sock:/var/run/docker.sock
CMD sudo chown :docker /var/run/docker.sock && bash
