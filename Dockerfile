FROM ubuntu:22.04
LABEL maintainer "V2Fly Community <dev@v2fly.org>"

WORKDIR /root
ARG TARGETPLATFORM
ARG TAG

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y openssh-server tzdata openssl ca-certificates unzip wget curl \
	&& mkdir /var/run/sshd \
	&& echo 'root:root' |chpasswd \
	&& passwd --expire root \
	&& mkdir /root/.ssh \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray \
	&& sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& chmod +x /root/v2ray.sh \
	&& /root/v2ray.sh "${TARGETPLATFORM}" "${TAG}" \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
EXPOSE 8888
COPY v2ray.sh /root/v2ray.sh
COPY config.json /etc/v2ray/config.json
ENV PATH /usr/bin/v2ray:$PATH
ENV PORT 8888
ENV TZ=Asia/Shanghai
CMD [ "/usr/bin/v2ray", "-config", "/etc/v2ray/config.json" ]
CMD ["/usr/sbin/sshd", "-D"]

