# Docker images for RESTHeart

[![Docker Stars](https://img.shields.io/docker/stars/softinstigate/restheart.svg?maxAge=2592000)](https://hub.docker.com/r/softinstigate/restheart/) [![Docker Pulls](https://img.shields.io/docker/pulls/softinstigate/restheart.svg?maxAge=2592000)](https://hub.docker.com/r/softinstigate/restheart/)

**Note**: This has been tested with docker version 1.10+. Please [upgrade](https://docs.docker.com/engine/installation/) if you have an older docker version. To check your version: `$ docker -v`.

## TL;DR - Use docker-compose

RESTHeart fully embraces a microservices architecture. The quickest way to run RESTHeart + MongoDB both as docker containers is to use [docker-compose](https://docs.docker.com/compose/).

The file `docker-compose.yml` defines a single microservice made of a RESTHeart and MongoDB instance configured to work together.
To start both services just type:

```
$ docker-compose up -d

Creating restheartdocker_mongodb_1
Creating restheartdocker_restheart_1
```

Check everything is fine:

```
$ docker-compose ps

           Name                          Command               State                Ports               
-------------------------------------------------------------------------------------------------------
restheartdocker_mongodb_1     /entrypoint.sh mongod            Up      0.0.0.0:27017->27017/tcp         
restheartdocker_restheart_1   ./entrypoint.sh etc/resthe ...   Up      4443/tcp, 0.0.0.0:8080->8080/tcp 
```

Tail the logs of both services:

```
$ docker-compose logs -f

Attaching to restheartdocker_restheart_1, restheartdocker_mongodb_1
restheart_1  | 08:44:28.538 [main] INFO  org.restheart.Bootstrapper - Starting RESTHeart instance restheart-docker
restheart_1  | 08:44:28.546 [main] INFO  org.restheart.Bootstrapper - version 2.0.1
restheart_1  | 08:44:28.557 [main] INFO  org.restheart.Bootstrapper - Logging to file /var/log/restheart.log with level DEBUG
...
restheart_1  | 08:44:30.044 [main] INFO  org.restheart.Bootstrapper - Pid file /var/run/restheart--1441246088.pid
restheart_1  | 08:44:30.045 [main] INFO  org.restheart.Bootstrapper - RESTHeart started
```

You can now create a database with curl or [httpie](http://httpie.org/)

```
$ http -j -a admin:changeit PUT 127.0.0.1:8080/testdb

HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ETag, Auth-Token, Auth-Token-Valid-Until, Auth-Token-Location, X-Powered-By
Auth-Token: 7275cf59-4b51-4a44-aa34-f393c617bd16
Auth-Token-Location: /_authtokens/admin
Auth-Token-Valid-Until: 2016-06-11T09:08:50.859Z
Connection: keep-alive
Content-Length: 0
Date: Sat, 11 Jun 2016 08:53:50 GMT
ETag: 575bd19efca13600050d9581
X-Powered-By: restheart.org
```

GET the testdb

```
$ http -a admin:changeit 127.0.0.1:8080/testdb

HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Access-Control-Expose-Headers: Location, ETag, Auth-Token, Auth-Token-Valid-Until, Auth-Token-Location, X-Powered-By
Auth-Token: 7275cf59-4b51-4a44-aa34-f393c617bd16
Auth-Token-Location: /_authtokens/admin
Auth-Token-Valid-Until: 2016-06-11T09:11:14.843Z
Connection: keep-alive
Content-Encoding: gzip
Content-Length: 113
Content-Type: application/hal+json
Date: Sat, 11 Jun 2016 08:56:14 GMT
ETag: 575bd0fefca13600050d957d
X-Powered-By: restheart.org

{
    "_etag": {
        "$oid": "575bd0fefca13600050d957d"
    }, 
    "_id": "testdb", 
    "_returned": 0, 
    "_size": 0, 
    "_total_pages": 0
}

```

See our [API Tutorial](https://softinstigate.atlassian.net/wiki/x/GICM) for more.

## Build and run manually

This section is useful if you want to run RESTHeart with docker but you already have an existing MongoDB container to connect to. Note that if instead you want to connect to a remote MongoDB instance then you must edit the restheart.yml configuration file and change the mongouri.

`mongo-uri: mongodb://<remote-host>`

You can then decide to rebuild the container itself with your version of this file or mount the folder as a volume, so that you can override the default configuration files. For example:

`$ docker run -d -p 80:8080 --name restheart -v "$PWD"/etc:/opt/restheart/etc:ro softinstigate/restheart:2.0.1`

> We strongly recommend to always add the tag to the image (e.g. `softinstigate/restheart:2.0.1`), so that you are sure which version of RESTHeart you are running.

### 1) Pull the MongoDB and RESTHeart images

 1. `docker pull mongo:3.2`
 1. `docker pull softinstigate/restheart:2.0.1`

> We recommend to pull a specific MongoDB image, for example `docker pull mongo:3.2`. RESTHeart has been tested so far with MongoDB 2.6, 3.0 and 3.2.

### 2) Run the MongoDB container

```
docker run -d --name mongodb mongo:3.2
```

To make it accessible from your host and add a [persistent data volume](https://docs.docker.com/userguide/dockervolumes/):

```
docker run -d -p 27017:27017 --name mongodb -v <db-dir>:/data/db mongo:3.2
```

The `<db-dir>` must be a folder in your host, such as `/var/data/db` or whatever you like. If you don't attach a volume then your data will be lost when you delete the container.

### 3) Run RESTHeart interactively

Run in **foreground**, linking to the `mongodb` instance, mapping the container's 8080 port to the 80 port on host:

```
docker run --rm -i -t -p 80:8080 --name restheart --link mongodb softinstigate/restheart:2.0.1
```

In alternative, you might prefer to run it in **background**:

```
docker run -d -p 80:8080 --name restheart --link mongodb softinstigate/restheart:2.0.1
```

### 4) Check that is working:

If it's running in background, you can open the RESTHeart's logs:

```
docker logs restheart
```

### 5) Pass arguments to RESTHeart and JVM

You can append arguments to *docker run* command to provide RESTHeart and the JVM with arguments.

For example you can mount an alternate configuration file and specify it as an argument

```
docker run --rm -i -t -p 80:8080 -v my-conf-file.yml:/opt/restheart/etc/my-conf-file.yml:ro --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.1 my-conf-file.yml
```

If you want to pass system properties to the JVM, just specify -D or -X arguments. Note that in this case you **need** to provide the configuration file as well.

```
docker run --rm -i -t -p 80:8080 --name restheart --link mongodb:mongodb softinstigate/restheart:2.0.1 etc/restheart.yml -Dkey=value
```

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

When you containers are up and running you can go to the official [RESTHeart's Documentation](https://softinstigate.atlassian.net/wiki/display/RH/Documentation).

<hr></hr>

_Made with :heart: by [The SoftInstigate Team](http://www.softinstigate.com/). Follow us on [Twitter](https://twitter.com/softinstigate)_.
