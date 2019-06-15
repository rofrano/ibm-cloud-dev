# Docker image for IBM Cloud Development

A Docker development environment for working with IBM Cloud CLI

This Dockerfile creates a Python linux development environment for working
with IBM Cloud. It installs the IBM Cloud CLI so that you can work with the
cloud without needing to install anything.

This image defines a userid: `devops` so that you are not developing as `root`.
It is not required, but it is a good habit to work with minimal permissions and
as for permission elivation only when needed. The `devops` user is added to the
`docker` group so that full docker support is maintained.

## Build the Image

You can build this image with the following `docker` command

```
docker build --rm -t ibm-cloud-dev .
```

This will create a rather large (900+GB) image but that has all of the development
tooling that you should need. If the tools get out of date, resist the temptation
to update them in the container. Instead, simply rebuild the image.

## Using the Image

Any time you want to work with the IBM Cloud you can start a new instance and
mount your current working directory under gthe `/app` folder inside of the image.

```
docker run --rm -it -h ibmcloud -v $(PWD):/app ibm-cloud-dev
```

The `--rm` remove parameter will delete the container once you exit.
Make sure that all of you work is saved to the `/app` folder which is mapped to
your local host folder so that nothing is lost.

The `-h` is optional but since the host name shows up in the command prompt, it
services as nice indicator of what shell you are in.

Your command prompt will look like this:

```
devops@ibmcloud:/app$
```

Which lets you know that you are working inside of the IBM Cloud container.

## Using the Image with Docker

If you want to work with Docker containers inside of this Docker container you
must mount `/var/run/docker.sock` inside the container. This is an example
invocation that does this:

```
docker run --rm -it -h ibmcloud \
    -v $(PWD):/app \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ibm-cloud-dev
```

**Note:** This is not `docker-in-docker`! This is **docker with docker**. You will be
manipulating docker images and containers on your host system. This is the most
desirable way to work in a development environment; the container is just the
shell that you are working in.
