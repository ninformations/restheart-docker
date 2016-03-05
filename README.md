# Docker images for RESTHeart

<img src="https://www.mongodb.com/assets/MongoDB_Brand_Resources/powered-by-mongodb-logo-light-a07ae588cd2d5f460ccc886b2d76476dc256bd7d8d376f884102d09d36885320.jpg" width="200" alt="MongoDB logo">
<img src="https://www.docker.com/sites/all/themes/docker/assets/images/logo.png" width="240" alt="Docker logo">

## Tags

| tag | size |
|-----|------|
| latest | [![](https://badge.imagelayers.io/softinstigate/restheart:latest.svg)](https://imagelayers.io/?images=softinstigate/restheart:latest 'Get your own badge on imagelayers.io') |
| beta | [![](https://badge.imagelayers.io/softinstigate/restheart:2.0.0-beta-1.svg)](https://imagelayers.io/?images=softinstigate/restheart:2.0.0-beta-1 'Get your own badge on imagelayers.io') |

## Run

### 1) Pull the MongoDB and RESTHeart images

 1. `docker pull mongo:3.2`
 1. `docker pull softinstigate/restheart`

> It's recommended to pull a specific MongoDB image, for example `docker pull mongo:3.2`. RESTHeart has been tested so far with MongoDB 2.6, 3.0 and 3.2.

### 2) Run the MongoDB container

    docker run -d --name mongodb mongo:3.2

To make it accessible from your host and add a [persistent data volume](https://docs.docker.com/userguide/dockervolumes/):

    docker run -d -p 27017:27017 --name mongodb -v <db-dir>:/data/db mongo:3.2

The `<db-dir>` must be a folder in your host, such as `/var/data/db` or whatever you like. If you don't attach a volume then your data will be lost when you delete the container.

### 3) Run RESTHeart interactively

Run in **foreground**, linking to the `mongodb` instance, mapping the container's 8080 port to the 80 port on host:

    docker run --rm -i -t -p 80:8080 --name restheart --link mongodb softinstigate/restheart

In alternative, you might prefer to run it in **background**:

    docker run -d -p 80:8080 --name restheart --link mongodb softinstigate/restheart

### 4) Check that is working:

If it's running in background, you can open the RESTHeart's logs:

    docker logs restheart

### 5) Pass arguments to RESTHeart and JVM

You can append arguments to *docker run* command to provide RESTHeart and the JVM with arguments.

For example you can mount an alternate configuration file and specify it as an argument

`docker run --rm -i -t -p 80:8080 -v my-conf-file.yml:/opt/restheart/etc/my-conf-file.yml:ro --name restheart --link mongodb:mongodb softinstigate/restheart my-conf-file.yml`

If you want to pass system properties to the JVM, just specify -D or -X arguments. Note that in this case you **need** to provide the configuration file as well.

`docker run --rm -i -t -p 80:8080 --name restheart --link mongodb:mongodb softinstigate/restheart etc/restheart.yml -Dkey=value`

## Accessing the HAL Browser

If you are running the `docker-machine` from [Docker Toolbox](https://www.docker.com/toolbox) then point your browser to something like:

 * [http://192.168.99.100:8080/browser](http://192.168.99.100:8080/browser).

Beware your configuration might use a different IP address than `192.168.99.100`. Issue the [env](https://docs.docker.com/machine/reference/env/) command to discover the real IP (usually `docker-machine env default`)

If you are running Docker directly on a Linux box:

 * [http://localhost/browser](http://localhost/browser).

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

The MongoDB container instead is stateful, so if you delete it then you'll lose all data unless you attached to it a persistent volume. In this case you might prefer to start it again, so that your data is preserved, or ypu might prefer to attach a local [Docker Volume](https://docs.docker.com/userguide/dockervolumes/) to it.

To stop MongoDb issue

    docker stop mongodb

To start MongoDb again

    docker start mongodb

Note that you must **always stop RESTHeart before MongoDB**, or you might experience data losses.

## Next Steps

When you containers are up and running you can go to the official [RESTHEart's Documentation](https://softinstigate.atlassian.net/wiki/display/RH/Documentation).

<hr></hr>

_Made with :heart: by [The SoftInstigate Team](http://www.softinstigate.com/). Follow us on [Twitter](https://twitter.com/softinstigate)_.
