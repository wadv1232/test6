FROM ubuntu:22.04
RUN apt-get update \
	&& apt-get install -y openssh-server \
	&& mkdir /var/run/sshd \
	&& echo 'root:root' |chpasswd \
	&& passwd --expire root \
	&& sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& mkdir /root/.ssh \
	&& apt-get clean && \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

FROM v2fly/v2fly-core
COPY config.json /etc/v2ray/config.json
COPY v2ray.sh /v2ray.sh
RUN chmod +x /v2ray.sh
ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888
WORKDIR /etc/v2ray
ENTRYPOINT ["/v2ray.sh"]
EXPOSE 8888
CMD ["v2ray", "-config=/etc/v2ray/config.json"]
