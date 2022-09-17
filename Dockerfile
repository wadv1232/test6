FROM ubuntu:20.04
FROM v2fly/v2fly-core
LABEL maintainer="https://github.com/jianyuann"

COPY config.json /etc/v2ray/config.json
COPY v2ray.sh /v2ray.sh

ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888
ENTRYPOINT ["/v2ray.sh"]
CMD ["v2ray", "-config=/etc/v2ray/config.json"]

WORKDIR /etc/v2ray

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN passwd --expire root
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
EXPOSE 8888
CMD ["/usr/sbin/sshd", "-D"]
