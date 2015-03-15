# Docker RESTHeart

An experimental [Docker](https://www.docker.com) container for [RESTHeart](http://restheart.org).

Note: this has been tested only with [boot2docker](http://boot2docker.io) and it usues its IP (usually `192.168.59.103`), so RESTHeart expects a MongoDB instance running at the same IP. If you are not running boot2docker then it is mandatory to change the restheart.yml file, specifically the following section

    mongo-servers:
        - host: 192.168.59.103
          port: 27017

Then re-build the image. In the future we'll put in place a more flexible configuration.

## Setup

1) Pull the repo: 

`docker pull softinstigate/restheart`

(alternatively you can just build your own image from the Dockerfile: `build -t <image_name> .`. Then you can also edit the restheart.yml file to match your configuration).

2) Run [MongoDB](http://dockerfile.github.io/#/mongodb):

`docker run -d -p 27017:27017 --name mongodb dockerfile/mongodb`

3) Run RESTHeart:

`docker run -d -p 8080:8080 --name restheart softinstigate/restheart`

4) Check that is working, point your browser to:

`http://192.168.59.103:8080/browser`

Note: there is a problem after stopping the RESTHeart container (`docker stop restheart`), so it's necessary to delete (`docker rm restheart`) and re-run it.


Available at the [Docker Hub](https://registry.hub.docker.com/u/softinstigate/restheart/).
