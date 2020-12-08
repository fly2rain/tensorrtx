#ARG BASE_IMAGE=mobileshrinkage.azurecr.io/tensorrt_yolov5_base:latest
#ARG BASE_IMAGE=mobileshrinkage.azurecr.io/tritonclientbase:20.03.1-py3
ARG BASE_IMAGE=nvcr.io/nvidia/tensorrt:20.03-py3

FROM ${BASE_IMAGE}

RUN apt-get update -y && \
    apt-get install -y software-properties-common ca-certificates curl nano
#    add-apt-repository -y ppa:timsc/opencv-3.3 && \

#RUN add-apt-repository ppa:timsc/opencv-3.3 &&  apt-get update
#RUN apt-get install -y -s libopencv-dev
# apt-get install libopencv-dev

# Set the Working Directory to /app
RUN  mkdir -p  /app
WORKDIR   /app

# Copy the current directory contents into the container at /app # 🔥🔥🔥
COPY requirements.txt ./

# Install Dependencies # 🔥🔥
RUN pip3 install -r ./requirements.txt

# Healthcheck
HEALTHCHECK CMD pidof python3 || exit 1

# Expose flask port 8080
EXPOSE 8080