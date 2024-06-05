FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A4B469963BF863CC

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    python3-wheel \
    python3-setuptools \
    python3-tk \
    cmake \
    wget \
    g++


RUN apt-get install -y --no-install-recommends \
    libsndfile1 x11-apps emacs less \
    subversion automake autoconf git sox gfortran libtool python2.7 \
    intel-mkl python \
    language-pack-ja


# Install python library
RUN pip3 install torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 torchmetrics -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install numba tqdm librosa h5py matplotlib colormap

WORKDIR /work
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs


# Declare the global argument to use at the current build stage
ARG MATLAB_RELEASE=r2021b

# Install mpm dependencies
RUN apt-get install --no-install-recommends --yes \
        unzip \
        ca-certificates && \
    apt-get clean && apt-get autoremove

# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \ 
    chmod +x mpm && \
    ./mpm install \
        --release=${MATLAB_RELEASE} \
        --destination=/opt/matlab \
        --products MATLAB MATLAB_Coder \
            Parallel_Computing_Toolbox \
            Statistics_and_Machine_Learning_Toolbox \
            Signal_Processing_Toolbox && \
    rm -f mpm /tmp/mathworks_root.log && \
    ln -s /opt/matlab/bin/matlab /usr/local/bin/matlab

# Add "matlab" user and grant sudo permission.
RUN mkdir -p /etc/sudoers.d
RUN adduser --shell /bin/bash --disabled-password --gecos "" matlab && \
    echo "matlab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/matlab && \
    chmod 0440 /etc/sudoers.d/matlab

# One of the following 2 ways of configuring the license server to use must be
# uncommented.

ARG LICENSE_SERVER
# Specify the host and port of the machine that serves the network licenses 
# if you want to bind in the license info as an environment variable. This 
# is the preferred option for licensing. It is either possible to build with 
# something like --build-arg LICENSE_SERVER=27000@MyServerName, alternatively
# you could specify the license server directly using
#       ENV MLM_LICENSE_FILE=27000@flexlm-server-name
ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# Alternatively you can put a license file into the container.
# You should fill this file out with the details of the license 
# server you want to use and uncomment the following line.
COPY license.lic /opt/matlab/licenses/
