FROM dockerfile/java:oracle-java8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/releases/download/0.10.0/restheart-0.10.0.tar.gz /opt/
RUN tar zxvf restheart-0.10.0.tar.gz

WORKDIR /opt/restheart-0.10.0
COPY etc/* /opt/restheart-0.10.0/etc/

CMD java -server -jar restheart.jar etc/restheart.yml
EXPOSE 8080