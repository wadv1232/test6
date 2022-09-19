FROM teddysun/xray
LABEL maintainer="https://github.com/jianyuann"

ENV PATH /usr/bin/xray:$PATH
ENV PORT 443
ENV TZ=Asia/Shanghai
COPY config.json /etc/xray/config.json
COPY xray.sh /xray.sh
RUN chmod +x /xray.sh
CMD /xray.sh

EXPOSE 443
CMD ["xray", "-config=/etc/xray/config.json"]
