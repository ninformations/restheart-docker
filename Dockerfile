FROM java:8u66-jre

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 1.1.5

WORKDIR /opt/
ADD https://github.com/SoftInstigate/restheart/releases/download/${release}/restheart-${release}.tar.gz /opt/
RUN tar zxvf restheart-${release}.tar.gz
RUN mv restheart-${release} restheart

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/
COPY entrypoint.sh /opt/restheart/

ENTRYPOINT ["./entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
