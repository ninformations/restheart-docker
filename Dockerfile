FROM anapsix/alpine-java:jre8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 1.1.7

RUN apk update && apk upgrade && apk add curl

WORKDIR /opt/
COPY nexus.sh /opt/

RUN chmod a+x nexus.sh && ./nexus.sh -i org.restheart:restheart:${release} -p tar.gz > restheart.tar.gz \
&& tar -zxvf restheart.tar.gz \
&& mv restheart-${release} restheart \
&& rm -f restheart.tar.gz

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/
COPY entrypoint.sh /opt/restheart/

ENTRYPOINT ["./entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
