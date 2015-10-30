FROM maven:3-jdk-8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/archive/master.zip /opt/
RUN unzip master.zip

WORKDIR /opt/restheart-master/src/main/resources
ADD https://github.com/mikekelly/hal-browser/archive/master.zip /opt/restheart-master/src/main/resources/
RUN unzip master.zip
RUN rm -rf browser/
RUN mv -f hal-browser-master/ browser/

WORKDIR /opt/restheart-master
RUN mvn package -DskipIts=false

COPY etc/* /opt/restheart-master/target/etc/

#CMD java -server -jar target/restheart.jar target/etc/restheart.yml
#EXPOSE 8080
