# GDAL Docker Images

Change from geodata/gdal:
use debian image, and install go

This is an debian derived image containing the Geospatial Data Abstraction
Library (GDAL) compiled with a broad range of drivers. The build process is
based on that defined in the
[GDAL TravisCI tests](https://github.com/OSGeo/gdal/blob/trunk/.travis.yml).

Each branch in the git repository corresponds to a supported GDAL version
(e.g. `1.11.2`) with the master branch following GDAL master. These branch names
are reflected in the image tags on the Docker Index (e.g. branch `1.11.2`
corresponds to the image `geodata/gdal:1.11.2`).

## Usage

Running the container without any arguments will by default output the GDAL
version string as well as the supported raster and vector formats:

    docker run --rm -ti tjun/gdal-go

The following command will open a bash shell in an Ubuntu based environment
with GDAL available:

    docker run --rm -ti tjun/gdal-go /bin/bash

You will most likely want to work with data on the host system from within the
docker container, in which case run the container with the -v option. Assuming
you have a raster called `test.tif` in your current working directory on your
host system, running the following command should invoke `gdalinfo` on
`test.tif`:

    docker run -v $(pwd):/app tjun/gdal-go gdalinfo test.tif

This works because the current working directory is set to `/app` in the
container, and you have mapped the current working directory on your host to
`/app`.

GDAL will be run under user `nobody` in the container, so if editing or creating
files the appropriate permissions for that user must be applied to the directory
pointed to by `$(pwd)`.  Alternatively pass the `--user` option to `docker run`.

Note that the image tagged `latest`, GDAL represents the latest code *at the
time the image was built*. If you want to include the most up-to-date commits
then you need to build the docker image yourself locally along these lines:

    docker build -t tjun/gdal-go:local git://github.com/tjun/gdal-docker-go.git
