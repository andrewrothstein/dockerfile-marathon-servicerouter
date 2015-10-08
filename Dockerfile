FROM python:2.7.10-slim

ENV HAPROXY_VERSION 1.5.8-3+deb8u2

# install haproxy and mercurial and rsyslog
RUN apt-get update -qq && \
    apt-get install -qfy \
      haproxy=${HAPROXY_VERSION} \
      mercurial \
      rsyslog \
      curl \
      --no-install-recommends && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# install devcron
RUN pip install -e hg+https://bitbucket.org/dbenamy/devcron#egg=devcron requests && \
    apt-get remove --purge -y mercurial

# download marathon code
ENV MARATHON_VERSION 0.11.0
ENV MARATHON_TGZ_URL https://github.com/mesosphere/marathon/archive/v${MARATHON_VERSION}.tar.gz
RUN curl -L $MARATHON_TGZ_URL | tar vxz
RUN ln -s /marathon-$MARATHON_VERSION /marathon

# Setup defaults
RUN mkdir /var/log/haproxy

ADD rsyslog-haproxy.conf /etc/rsyslog.d/49-haproxy.conf
ADD logrotate-haproxy.conf /etc/logrotate.d/haproxy
ADD run.sh /etc/run.sh

ENV MARATHON_MASTER_IP 127.0.0.1
ENV MARATHON_MASTER_PORT 8080
CMD /etc/run.sh

EXPOSE 80 443 9090
