FROM python:3.8.10-slim-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    libssl-dev \
    build-essential git \
    libfuse-dev libcurl4-openssl-dev \
    libxml2-dev mime-support automake libtool libgl1-mesa-dev libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


## Install s3fs
ENV S3FS_VERSION=1.87 S3FS_SHA256=c5e064efb8fb5134a463731a7cf8d7174c93a296957145200347d2f4d9d11985
ADD *.sh /
RUN /build-s3fs.sh 

## Create Pytorch Env
# Install python dependencies
COPY requirements.txt .
RUN python3 -m pip install --user --upgrade pip
RUN pip install --no-cache -r requirements.txt && rm -rf /root/.cache/pip  && rm requirements.txt

# CUDA 10.1
RUN pip install torch==1.7.1+cu101 torchvision==0.8.2+cu101 -f https://download.pytorch.org/whl/torch_stable.html && rm -rf /root/.cache/pip


## Create Data folders
RUN mkdir -p /app/data /app/data/batch-uploads /app/data/batch-uploads-processed /app/data/src && apt-get clean
WORKDIR /app/data

## Set Your AWS Access credentials
ENV AWS_ACCESS_KEY=''
ENV AWS_SECRET_ACCESS_KEY='7'

## Specify the directory where you want to mount your s3 bucket into the container
ENV S3_MOUNT_UPLOADS=/app/data/batch-uploads
ENV S3_MOUNT_PROCESSED=/app/data/batch-uploads-processed
ENV S3_MOUNT_SRC=/app/data/src

## Define S3 buckets
ENV S3_UPLOADS=batch-uploads
ENV S3_PROCESSED=batch-uploads-processed
ENV S3_SRC=batch-uploads-src

## S3fs-fuse credential config
RUN echo $AWS_ACCESS_KEY:$AWS_SECRET_ACCESS_KEY > /root/.passwd-s3fs && \
    chmod 600 /root/.passwd-s3fs

WORKDIR /

## Adding scripts to mount S3 and run inference
ADD start-script.sh /start-script.sh
ADD mount-s3.sh /mount-s3.sh
RUN chmod 755 /start-script.sh /mount-s3.sh #/run-inference.sh


CMD ["/bin/bash", "/start-script.sh"]