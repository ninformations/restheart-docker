# Docker for RESTHeart

[Docker](https://www.docker.com) container for [RESTHeart](http://restheart.org).
It creates a Docker container with a JVM running RESTHeart, linked to another container running MongoDB, which makes use of the official [MongoDB](https://registry.hub.docker.com/_/mongo/) image.

## Setup

### 1) Pull the MongoDB and RESTHeart images: 

 1. `docker pull mongo`
 1. `docker pull softinstigate/restheart`

 Note: if you want to pull a specific mongodb image only, you could add the exact tag, for example:

    docker pull mongo:3.0

### 2) Run the MongoDB container (add a tag to specify the exact MongoDB version other than "latest"):

`docker run -d --name mongodb mongo:3.0`

If you want to make it accessible from your host and also add a persistent data volume:

`docker run -d -p 27017:27017 --name mongodb -v <db-dir>:/data/db mongo:3.0`

The `<db-dir>` must be a folder in your host, such as `/var/data/db` or whatever you like. If you don't attach a volume then all your data will be lost when you delete the container.

### 3) Run RESTHeart interactively, providing a link to the mongodb instance

`docker run -i -t -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart`

In alternative, you might prefer to run it in background

`docker run -d -p 8080:8080 --name restheart --link mongodb:mongodb softinstigate/restheart`

### 4) Check that is working:

First, check RESTHeart's logs

`docker logs restheart`

You will see the log file, which should end with 

`org.restheart.Bootstrapper - RESTHeart started **********************************************`

Below an example output

```
06:34:08.562 [main] INFO  org.restheart.Bootstrapper - Starting RESTHeart ********************************************
06:34:08.585 [main] INFO  org.restheart.Bootstrapper - Creating pid file /var/run/restheart.pid
06:34:08.717 [main] INFO  org.restheart.Bootstrapper - RESTHeart version 0.10.3
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

If you are running boot2docker point your browser to: [http://192.168.59.103:8080/browser](http://192.168.59.103:8080/browser), otherwise: [http://localhost:8080/browser](http://localhost:8080/browser).

Boopt2Docker usually maps to `192.168.59.103`, but to know the real IP in your own system check it using the `boot2docker ip` command.

### 5) Stop and start again

To stop the RESTHeart background daemon just issue `docker stop restheart`, or simply press `CTRL-C` if it was running in foreground.

You can start it again with `docker start restheart`, but it's not recommended. As RESTHeart is a stateless service, best Docker practices would suggest to just delete the stopped container with `docker rm restheart` and re-create a new one, it's ligthing fast and you are sure you are starting with a clean instance.

The MongoDB container instead is stateful, so if you delete it then you'll lose all data. In this case you might prefer to start it again, so that your data is preserved.

To stop MongoDb issue `docker stop mongodb`

To start MongoDb again `docker start mongodb`

Note that you must always stop RESTHeart before MongoDB, or you might experience data losses.

Available at the [Docker Hub](https://registry.hub.docker.com/u/softinstigate/restheart/).
