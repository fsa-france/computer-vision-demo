# Build the container
#   % docker build . -t lboschet/computer-vision-demo-notebook 
#
# Cross architecture settings
# Learn more at https://docs.docker.com/go/build-multi-platform/
#   % docker buildx create --use
# Build: 
#   % docker buildx build --platform linux/amd64,linux/arm64 -t lboschet/computer-vision-demo-notebook --push .
# Push: 
#   % docker login; docker push lboschet/computer-vision-demo-notebook
# Run:
#   % docker run -p 8888:8888 -it lboschet/computer-vision-demo-notebook

# In case of issue when building the container, remove unused volumes:
#   % docker volume ls -q 
# Then
#   % docker volume rm buildx_buildkit_strange_torvalds0_state

# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables for non-interactive mode (same variable for Debian & Ubuntu)
ENV DEBIAN_FRONTEND=noninteractive

# Run a system update & install python3 and pip3
RUN apt update
RUN apt install -y python3 python3-pip

# Install necessary dependencies for h5py
RUN apt install -y libhdf5-dev libhdf5-serial-dev pkg-config
RUN rm -rf /var/lib/apt/lists/*

# Install all necessary pythin3 packages (including jupyter) from the requirements.txt file
COPY requirements.txt /home/cv-demo/requirements.txt
RUN pip3 install -r /home/cv-demo/requirements.txt

# Create a user within the container & set the working directory
RUN useradd -ms /bin/bash cv-demo
RUN chown -R cv-demo:cv-demo /home/cv-demo
USER cv-demo
WORKDIR /home/cv-demo

# Create the .local directory and adjust permissions
#RUN mkdir -p /home/cv-demo/.local
#RUN chown -R cv-demo:cv-demo /home/cv-demo/.local

# Copy the Jupyter notebook into the user directory
COPY mnist-cv-demo.ipynb /home/cv-demo/mnist-cv-demo.ipynb

# Expose the Jupyter Notebook port on port 8888
EXPOSE 8888

# Run the Jupyter Notebook in the virtual environment
#CMD ["/opt/computer-vision-demo/bin/jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Set the entry point to Jupyter Notebook and specify the working directory
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--notebook-dir=/home/cv-demo"]
