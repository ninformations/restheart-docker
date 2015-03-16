# Docker for RESTHeart

Experimental [Docker](https://www.docker.com) container for [RESTHeart](http://restheart.org).

## Setup

1) Pull the repo: 

`docker pull softinstigate/restheart`

(alternatively you can just build your own image from the Dockerfile: `build -t <image_name> .`. Then you can also edit the restheart.yml file to match your configuration).

2) Run the [MongoDB](http://dockerfile.github.io/#/mongodb) container:

`docker run -d --name mongodb dockerfile/mongodb`

3) Run RESTHeart:

`docker run -i -t -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart`

4) Check that is working:

If you are running boot2docker point your browser to: [http://192.168.59.103:8080/browser](http://192.168.59.103:8080/browser), otherwise: [http://localhost:8080/browser](http://localhost:8080/browser). To know the boot2docker IP issue the `boot2docker ip` command.

To stop RESTHeart just issue a normal `CTRL-C`.

You can start it again with `docker start -i -a restheart`.

Available at the [Docker Hub](https://registry.hub.docker.com/u/softinstigate/restheart/).
