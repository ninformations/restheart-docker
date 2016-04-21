FROM anapsix/alpine-java:jre8

MAINTAINER SoftInstigate <info@softinstigate.com>

ENV release 2.0.0

RUN apk update && apk upgrade && apk add curl

WORKDIR /opt/

RUN curl -sL https://github.com/SoftInstigate/restheart/releases/download/${release}/restheart-${release}.tar.gz --output restheart.tar.gz \
&& tar -zxvf restheart.tar.gz \
&& mv restheart-${release} restheart \
&& rm -f restheart.tar.gz

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/
COPY entrypoint.sh /opt/restheart/

ENTRYPOINT ["./entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
