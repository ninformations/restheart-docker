FROM java:8u66-jre

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 0.10.4

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/releases/download/${release}/restheart-${release}.tar.gz /opt/
RUN tar zxvf restheart-${release}.tar.gz

WORKDIR /opt/restheart-${release}
COPY etc/* /opt/restheart-${release}/etc/

CMD java -server -jar restheart.jar etc/restheart.yml
EXPOSE 8080
