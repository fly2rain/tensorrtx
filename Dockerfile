#ARG BASE_IMAGE=mobileshrinkage.azurecr.io/tensorrt_yolov5_base:latest
#ARG BASE_IMAGE=mobileshrinkage.azurecr.io/tritonclientbase:20.03.1-py3
ARG BASE_IMAGE=nvcr.io/nvidia/tensorrt:20.03-py3

FROM ${BASE_IMAGE}

RUN apt-get update -y \
    # 1. Install the libopencv-dev
    && apt-get install -y software-properties-common ca-certificates curl nano \
    && add-apt-repository -r ppa:timsc/opencv-3.3 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --quiet libopencv-dev \
    # 2. install torch, torchvision, torchaudio
    && pip install --upgrade pip \
    && pip install torch==1.7.0+cu110 torchvision==0.8.1+cu110 -f \
            https://download.pytorch.org/whl/torch_stable.html \
    && mkdir -p  /app

## Install conda ---------------------------------
#ENV CONDA_DIR  /opt/conda
#ENV PATH  $CONDA_DIR/bin:$PATH
#ENV MINICONDA  Miniconda3-latest-Linux-x86_64.sh
#
#RUN wget --quiet --no-check-certificate https://repo.anaconda.com/miniconda/${MINICONDA} && \
#    /bin/bash ${MINICONDA} -f -b -p $CONDA_DIR && \
#    rm ${MINICONDA} && \
#    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
#    conda install -y pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch
## Install conda ---------------------------------

# Set the Working Directory to /app
WORKDIR   /app

# Copy the current directory contents into the container at /app # 🔥🔥🔥
COPY requirements.txt ./
# Install Dependencies # 🔥🔥
RUN  pip install -r ./requirements.txt

# Healthcheck
HEALTHCHECK CMD pidof python3 || exit 1

# Expose flask port 8080
EXPOSE 8080