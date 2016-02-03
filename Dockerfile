FROM maven:3-jdk-8

MAINTAINER SoftInstigate <maurizio@softinstigate.com>

ENV release 1.2.0-SNAPSHOT

WORKDIR /opt/
RUN mvn dependency:get -DrepoUrl=https://oss.sonatype.org/content/repositories/snapshots/ \
-Dartifact=org.restheart:restheart:${release}:zip \
-Ddest=restheart.zip

RUN unzip restheart.zip && mv restheart-${release} restheart

WORKDIR /opt/restheart
COPY etc/* /opt/restheart/etc/

EXPOSE 8080 4443
CMD java -server -jar restheart.jar etc/restheart.yml
