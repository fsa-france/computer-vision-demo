# Cross architecture settings
# Learn more at https://docs.docker.com/go/build-multi-platform/
#   % docker buildx create --use
# Build: 
#   % docker buildx build --platform linux/amd64,linux/arm64 -t lboschet/cv-demo --push .
# Push: 
#   % docker login; docker push lboschet/computer-vision-demo-notebook
# Run:
#   % docker run -p 8888:8888 -it lboschet/computer-vision-demo-notebook

# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables for non-interactive mode (same variable for Debian & Ubuntu)
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and Add the deadsnakes PPA 
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update

#  Install necessary dependencies, necessary packages and python 3.12 packages
RUN apt-get install -y pkg-config libhdf5-dev
RUN apt-get install -y iputils-ping
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN apt-get install -y libssl-dev
RUN apt-get install -y libffi-dev 
RUN apt-get install -y python3.12
RUN apt-get install -y python3-dev 
RUN apt-get install -y python3.12-dev
RUN apt-get install -y python3.12-venv
RUN apt-get install -y python3-pip

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Check Network Connectivity
RUN ping -c 4 google.com

# Create a virtual environment using venv
RUN python3.12 -m venv /opt/computer-vision-demo

# Activate the virtual environment and install Jupyter Notebook
RUN /opt/computer-vision-demo/bin/pip install --upgrade pip
RUN /opt/computer-vision-demo/bin/pip install numpy
RUN /opt/computer-vision-demo/bin/pip install jupyter
RUN /opt/computer-vision-demo/bin/pip install numpy
RUN /opt/computer-vision-demo/bin/pip install matplotlib
RUN /opt/computer-vision-demo/bin/pip install scikit-learn
RUN /opt/computer-vision-demo/bin/pip install seaborn
RUN /opt/computer-vision-demo/bin/pip install tensorflow
RUN /opt/computer-vision-demo/bin/pip install pydot
RUN /opt/computer-vision-demo/bin/pip install graphviz
RUN /opt/computer-vision-demo/bin/pip install livelossplot

# Add Graphviz and /opt/computer-vision-demo/bin to the Linux PATH
ENV PATH="/usr/bin:/opt/computer-vision-demo/bin:${PATH}"

# Verify the installation of Graphviz
RUN dot -V

# Create a user within the container & set the working directory
RUN useradd -ms /bin/bash cv-demo
USER cv-demo
WORKDIR /home/cv-demo

# Copy the Jupyter notebook into the user directory
COPY mnist-cv-demo.ipynb /home/cv-demo/mnist-cv-demo.ipynb

# Expose the Jupyter Notebook port on port 8888
EXPOSE 8888

# Run the Jupyter Notebook in the virtual environment
#CMD ["/opt/computer-vision-demo/bin/jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Set the entry point to Jupyter Notebook and specify the working directory
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--notebook-dir=/home/cv-demo"]
