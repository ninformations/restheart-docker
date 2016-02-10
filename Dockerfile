FROM java:8u72-jre

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 2.0.0-SNAPSHOT

WORKDIR /opt/
COPY nexus.sh /opt/

RUN ./nexus.sh -i org.restheart:restheart:${release} -p tar.gz > restheart.tar.gz \
&& tar -zxvf restheart.tar.gz \
&& mv restheart-${release} restheart \
&& rm -f restheart.tar.gz

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/
COPY entrypoint.sh /opt/restheart/

ENTRYPOINT ["./entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
