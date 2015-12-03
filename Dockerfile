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
RUN mvn package

COPY etc/* /opt/restheart/
RUN cp target/restheart.jar /opt/restheart/
COPY entrypoint.sh /entrypoint.sh

WORKDIR /opt/restheart

COPY entrypoint.sh rh-entrypoint.sh

ENTRYPOINT ["./rh-entrypoint.sh"]
CMD ["restheart.yml"]
EXPOSE 8080 4443
