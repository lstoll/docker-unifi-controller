FROM ubuntu:14.04

ENV UNIFI_RELEASE=5.2.3-aa0da1c8

# Repos
RUN echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/ubiquity.list && \
   echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/10gen.list && \
   apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
   apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7F0CEB10

# Things
RUN apt-get update && \
    apt-get install -y curl

# Deps
RUN apt-get install -y binutils jsvc mongodb-10gen openjdk-7-jre-headless

RUN cd /tmp && \
    curl -sLo unifi.deb http://dl.ubnt.com/unifi/${UNIFI_RELEASE}/unifi_sysvinit_all.deb && \
    dpkg -i unifi.deb && \
    rm unifi.deb

EXPOSE 8080 8443 8880 8843
VOLUME ["/usr/lib/unifi/data"]
# oh my is this a hack
CMD sh -c '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java -Xmx256M -jar /usr/lib/unifi/lib/ace.jar start &' && sleep 1 && tail -f /logs/server.log

