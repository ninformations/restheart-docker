FROM maven:3-jdk-8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/archive/develop.zip /opt/
RUN unzip develop.zip

WORKDIR /opt/restheart-develop/src/main/resources
ADD https://github.com/mikekelly/hal-browser/archive/master.zip /opt/restheart-develop/src/main/resources/
RUN unzip master.zip
RUN rm -rf browser/
RUN mv -f hal-browser-master/ browser/

WORKDIR /opt/restheart-develop
# RUN git submodule foreach git pull origin master
RUN mvn package

COPY etc/* /opt/restheart-develop/target/etc/

CMD java -server -jar target/restheart.jar target/etc/restheart.yml
EXPOSE 8080
