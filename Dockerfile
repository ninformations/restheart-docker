FROM java:8u66-jre

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 1.1.3

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/releases/download/${release}/restheart-${release}.tar.gz /opt/
RUN tar zxvf restheart-${release}.tar.gz
RUN mv restheart-${release} restheart

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/

COPY entrypoint.sh rh-entrypoint.sh

ENTRYPOINT ["./rh-entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
