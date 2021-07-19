# Dockerised s3fs Client

This Docker image facilitates mounting of remote S3 buckets resources into

containers. Mounting is performed through the fuse [s3fs] implementation. The

image basically implements a docker [volume] on the cheap: Used with the proper

creation options (see below) , you should be able to bind-mount back the remote

bucket onto a host directory. This directory will make the content of the bucket

available to processes, but also all other containers on the host. The image

automatically unmount the remote bucket on container termination.



  [s3fs]: https://github.com/s3fs-fuse/s3fs-fuse

  [volume]: https://docs.docker.com/storage/



The image [tags] follow the versions from the [s3fs] implementation. New

versions of [s3fs] will automatically be picked up when [rebuilding]. [s3fs] is

compiled from the tagged git versions from the main repository.


Docker image for [s3fs fuse](https://github.com/s3fs-fuse/s3fs-fuse).

## Configuration

- `AWS_ACCESS_KEY_ID` - (required)
- `AWS_SECRET_ACCESS_KEY` - (required)
- `AWS_STORAGE_BUCKET_NAME` - (required)
- `AWS_S3_AUTHFILE` - path to s3fs auth file.
- `AWS_S3_MOUNTPOINT` - mountpoint default `/mnt`
- `AWS_S3_URL` - s3 endpoint default `https://s3.amazonaws.com`
- `S3FS_ARGS` - additional s3fs mount arguments
- `DEBUG` - enable DEBUG mode.

## Usage example

```bash
docker run --rm -t -i --privileged \
  -e AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx \
  -e AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  -e AWS_STORAGE_BUCKET_NAME=example \
  your_container_repo:tag ls /mnt
```


