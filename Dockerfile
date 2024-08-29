# Build the container (local architecture)
#   % docker build . -t lboschet/computer-vision-demo
#
# Build the container for "Cross architecture build"
# Learn more at https://docs.docker.com/go/build-multi-platform/
#   % docker buildx create --use
# Build: 
#   % docker buildx build --platform linux/amd64,linux/arm64 -t lboschet/computer-vision-demo:latest --push .
#
# Push the container to the repository
#   % docker login; docker push lboschet/computer-vision-demo (default to 'latest' tag)
# 
# Run the container
#   % docker run -p 8888:8888 -it --name computer-vision-demo lboschet/computer-vision-demo:latest
#
# Connect to tthe container
#   % docker run -p 8888:8888 -it --entrypoint /bin/bash --name computer-vision-demo lboschet/computer-vision-demo:latest

# In case of issue when building the container, remove unused volumes:
#   % docker volume ls -q 
# Then
#   % docker volume rm buildx_buildkit_strange_torvalds0_state

# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables for non-interactive mode (same variable for Debian & Ubuntu)
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary python3 and dependencies for h5py (all in 1 line to minimize container layers)
RUN apt update -y && apt install -y python3 python3-pip python3-dev build-essential libssl-dev libffi-dev \ 
    libhdf5-dev libhdf5-serial-dev pkg-config && rm -rf /var/lib/apt/lists/*

# Install all necessary python3 packages (including jupyter) from the requirements.txt file
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --timeout=100 -r /tmp/requirements.txt

# Create a user within the container & set the working directory
RUN useradd -ms /bin/bash cvdemo 
RUN chown -R cvdemo:cvdemo /home/cvdemo
USER cvdemo
WORKDIR /home/cvdemo

# Copy the Jupyter notebook into the user directory
COPY computer-vision-demo.ipynb /home/cvdemo/computer-vision-demo.ipynb

# Expose the Jupyter Notebook port on port 8888
EXPOSE 8888

# Run the Jupyter Notebook in the virtual environment
#CMD ["/opt/computer-vision-demo/bin/jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Set the entry point to Jupyter Notebook and specify the working directory
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--notebook-dir=/home/cvdemo"]
