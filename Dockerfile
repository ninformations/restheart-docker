FROM java:8u66-jre

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 1.0.3

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/releases/download/${release}/restheart-${release}.tar.gz /opt/
RUN tar zxvf restheart-${release}.tar.gz
RUN mv restheart-${release} restheart

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/

CMD java -server -jar restheart.jar etc/restheart.yml
EXPOSE 8080
