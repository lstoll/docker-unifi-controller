FROM ubuntu:14.04

# 4.7.5-6348. So we wildcard
ENV unifi_version=4.7.5*

RUN echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/ubiquity.list && \
   echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/10gen.list && \
   apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
   apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7F0CEB10
RUN apt-get update -q -y && \
    apt-cache madison unifi && \
    apt-get install -q -y unifi=${unifi_version}

EXPOSE 8080 8443 8880 8843
VOLUME ["/var/lib/unifi"]
# oh my is this a hack
CMD sh -c '/usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java -Xmx256M -jar /usr/lib/unifi/lib/ace.jar start &' && tail -f /var/log/unifi/server.log
