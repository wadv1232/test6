FROM ubuntu:20.04
LABEL maintainer="https://github.com/jianyuann"

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y openssh-server \
	&& mkdir /var/run/sshd \
	&& echo 'root:root' |chpasswd \
	&& passwd --expire root \
	&& sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& mkdir /root/.ssh \
	
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

FROM teddysun/xray
COPY config.json /etc/xray/config.json
COPY xray.sh /xray.sh
RUN chmod +x /xray.sh
ENV PATH /usr/bin/xray:$PATH
ENV PORT 8888
WORKDIR /etc/xray
ENTRYPOINT ["/xray.sh"]

EXPOSE 8888
CMD ["xray", "-config=/etc/xray/config.json"]
