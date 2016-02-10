FROM maven:3-jdk-8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 2.0.0-SNAPSHOT

WORKDIR /opt/
RUN mvn dependency:get -DrepoUrl=https://oss.sonatype.org/content/repositories/snapshots/ \
-Dartifact=org.restheart:restheart:${release}:zip \
-Ddest=restheart.zip \
&& unzip restheart.zip \
&& mv restheart-${release} restheart \
&& rm -f restheart.zip \

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/
COPY entrypoint.sh /opt/restheart/

ENTRYPOINT ["./entrypoint.sh"]
CMD ["etc/restheart.yml"]
EXPOSE 8080 4443
