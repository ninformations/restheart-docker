# Docker for RESTHeart (development branch)

[![](https://badge.imagelayers.io/softinstigate/restheart:latest.svg)](https://imagelayers.io/?images=softinstigate/restheart:latest 'Get your own badge on imagelayers.io')

[Docker](https://www.docker.com) container for [RESTHeart](http://restheart.org).
It creates a Docker container with a JVM running RESTHeart, linked to another container running MongoDB, which makes use of the official [MongoDB](https://registry.hub.docker.com/_/mongo/) image.

**Note**: this docker container runs the experimental **Beta** builds of RESTHeart (downloaded from Maven Central). SNAPSHOT images are tagged with `2.0.0-beta-*` in Docker Hub.

## Setup

### 1) Pull the MongoDB and RESTHeart images:

 1. `docker pull mongo`
 1. `docker pull softinstigate/restheart:2.0.0-beta-1`

 Note: if you want to pull a specific mongodb image only, you could add the exact tag, for example:

    docker pull mongo:3.2

### 2) Run the MongoDB container:

`docker run -d --name mongodb mongo:3.2`

If you want to make it accessible from your host and also add a persistent data volume:

`docker run -d -p 27017:27017 --name mongodb -v <db-dir>:/data/db mongo:3.2`

The `<db-dir>` must be a folder in your host, such as `/var/data/db` or whatever you like. If you don't attach a volume then all your data will be lost when you delete the container.

### 3) Run RESTHeart providing a link to the mongodb instance

interactively:

`docker run -i -t -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.0-beta-1`

Or in background:

`docker run -d -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.0-beta-1`

### 4) Check that is working:

If you are running docker-machine point your browser to: [http://192.168.99.100:8080/browser/](http://192.168.99.100:8080/browser/), otherwise: [http://localhost:8080/browser/](http://localhost:8080/browser/). To know the docker-machine IP issue the `docker-machine ip default` command (if you are running the default VM).

### 5) Stop and restart

To stop RESTHeart just issue a normal `CTRL-C` if it's in foreground, otherwise you have to stop it with `[$ docker stop restheart](https://docs.docker.com/engine/reference/commandline/stop/)`

You can start it again with `docker start -i -a restheart` but the easiest thing to do is to delete the container and just create a new one, it's ligthing fast.

To stop MongoDb issue `docker stop mongodb`

To start MongoDb again `docker start mongodb`

### 6) Pass arguments to RESTHeart and JVM

You can append arguments to *docker run* command to provide RESTHeart and the JVM with arguments.

For example you can mount an alternate configuration file and specify it as an argument

`docker run -i -t -p 8080:8080 -v my-conf-file.yml:/opt/restheart/etc/my-conf-file.yml:ro --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.0-beta-1 my-conf-file.yml`

If you want to pass system properties to the JVM, just specify -D or -X arguments. Note that in this case you **need** to provide the configuration file as well.

`docker run -i -t -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.0-beta-1 restheart.yml -Dkey=value`

Available at the [Docker Hub](https://registry.hub.docker.com/u/softinstigate/restheart/).
