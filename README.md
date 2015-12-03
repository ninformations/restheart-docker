# Docker container for RESTHeart

![Docker logo](https://www.docker.com/sites/all/themes/docker/assets/images/logo.png)

## Introduction

This README explains how to build your own Docker image for [RESTHeart](http://restheart.org), the REST API Server for MongoDB.

> Pre-built images are already available at the [Docker Hub](https://hub.docker.com/r/softinstigate/restheart/).

This Dockerfile creates a Docker container with a JRE 8 running RESTHeart on port 8080, linked to another container running MongoDB 3.0.

## Build

If you want to build this Docker image by yourself, just clone this repo and issue the build command, providing a image name:

    docker build -t <image_name> .

## Run

If you want to [run](https://docs.docker.com/reference/commandline/run/) the pre-built Docker image from the [Hub](https://hub.docker.com/r/softinstigate/restheart/) then:

### 1) Pull the MongoDB and RESTHeart images:

 1. `docker pull mongo`
 1. `docker pull softinstigate/restheart`

> It's recommended to pull a specific MongoDB image only, for example `docker pull mongo:3.0`. RESTHeart has been tested so far with MongoDB 2.6 and 3.0.

### 2) Run the MongoDB container

    docker run -d --name mongodb mongo:3.0

If you want to make it accessible from your host and, for example, also add a [persistent data volume](https://docs.docker.com/userguide/dockervolumes/):

    docker run -d -p 27017:27017 --name mongodb -v <db-dir>:/data/db mongo:3.0

The `<db-dir>` must be a folder in your host, such as `/var/data/db` or whatever you like. If you don't attach a volume then all your data will be lost when you delete the container.

### 3) Run RESTHeart interactively

Run in **foreground**, linking to the mongodb instance, mapping the container's 8080 port to the same port on host:

    docker run -i -t -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart

In alternative, you might prefer to run it in **background**:

    docker run -d -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart

### 4) Check that is working:

Open the RESTHeart's logs:

    docker logs restheart

Finally you should see something similar to this:

```
06:34:08.562 [main] INFO  org.restheart.Bootstrapper - Starting RESTHeart ********************************************
06:34:08.585 [main] INFO  org.restheart.Bootstrapper - Creating pid file /var/run/restheart.pid
06:34:08.717 [main] INFO  org.restheart.Bootstrapper - RESTHeart version 1.0.0
06:34:08.815 [main] INFO  org.restheart.Bootstrapper - Initializing MongoDB connection pool to mongodb:27017
06:34:08.816 [main] INFO  org.restheart.Bootstrapper - MongoDB connection pool initialized
06:34:09.223 [main] INFO  org.restheart.Bootstrapper - Token based authentication enabled with token TTL 15 minutes
06:34:09.425 [main] INFO  org.restheart.Bootstrapper - HTTPS listener bound at 0.0.0.0:4443
06:34:09.426 [main] INFO  org.restheart.Bootstrapper - HTTP listener bound at 0.0.0.0:8080
06:34:09.427 [main] INFO  org.restheart.Bootstrapper - Local cache for db and collection properties enabled
06:34:09.443 [main] INFO  o.r.handlers.RequestDispacherHandler - Initialize default HTTP handlers:
06:34:09.444 [main] INFO  o.r.handlers.RequestDispacherHandler - putPipedHttpHandler( ROOT, GET, org.restheart.handlers.root.GetRootHandler )
...
...
06:34:09.476 [main] INFO  org.restheart.Bootstrapper - URL / bound to MongoDB resource *
06:34:09.588 [main] INFO  org.restheart.Bootstrapper - Embedded static resources browser extracted in /tmp/restheart-6456780946911760020
06:34:09.598 [main] INFO  org.restheart.Bootstrapper - URL /browser bound to static resources browser. access manager: false
06:34:09.602 [main] INFO  org.restheart.Bootstrapper - URL /_logic/ping bound to application logic handler org.restheart.handlers.applicationlogic.PingHandler. access manager: false
06:34:09.626 [main] INFO  org.restheart.Bootstrapper - URL /_logic/roles bound to application logic handler org.restheart.handlers.applicationlogic.GetRoleHandler. access manager: false
06:34:09.833 [main] INFO  org.restheart.Bootstrapper - RESTHeart started **********************************************
```

### 5) Pass arguments to RESTHeart and JVM

You can append arguments to *docker run* command to provide RESTHeart and the JVM with arguments.

For example you can mount an alternate configuration file and specify it as an argument

`docker run -i -t -p 8080:8080 -v my-conf-file.yml:/opt/restheart/etc/my-conf-file.yml:ro --name restheart --link mongodb:mongodb softinstigate/restheart my-conf-file.yml`

If you want to pass system properties to the JVM, just specify -D or -X arguments. Note that in this case you **need** to provide the configuration file as well.

`docker run -i -t -p 8080:8080 -v my-conf-file.yml:/opt/restheart/etc/my-conf-file.yml:ro --name restheart --link mongodb:mongodb softinstigate/restheart restheart.yml -Dkey=value`

## Accessing the HAL Browser

If you are running the `docker-machine` from [Docker Toolbox](https://www.docker.com/toolbox) then point your browser to something like:

 * [http://192.168.99.100:8080/browser](http://192.168.99.100:8080/browser).

Beware your configuration might use a different IP address than `192.168.99.100`. Issue the [env](https://docs.docker.com/machine/reference/env/) command to discover the real IP (usually `docker-machine env default`)

If you are running Docker directly on a Linux box:

 * [http://localhost:8080/browser](http://localhost:8080/browser).

### Credentials

Whenever the browser asks for credentials then use the following:

    username: admin
    password: changeit

## Stop and start again

To stop the RESTHeart background daemon just issue

    docker stop restheart

or simply press `CTRL-C` if it was running in foreground.

You can start it again with

    docker start restheart

but it's **not recommended**: RESTHeart is a stateless service, best Docker practices would suggest to just delete the stopped container with `docker rm restheart` or to run it in foreground with the `--rm` parameter, so that it will be automatically removed when it exits.

The MongoDB container instead is stateful, so if you delete it then you'll lose all data unless you attached to it a persistent volume. In this case you might prefer to start it again, so that your data is preserved, or ypu might prefer to attach a [Docker Volume](https://docs.docker.com/userguide/dockervolumes/) to it.

To stop MongoDb issue

    docker stop mongodb

To start MongoDb again

    docker start mongodb

Note that you must **always stop RESTHeart before MongoDB**, or you might experience data losses.

## Next Steps

When you containers are up and running you can go to the official [RESTHEart's Documentation](https://softinstigate.atlassian.net/wiki/display/RH/Documentation).

<hr></hr>

_Made with :heart: by [The SoftInstigate Team](http://www.softinstigate.com/). Follow us on [Twitter](https://twitter.com/softinstigate)_.
