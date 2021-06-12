FROM ubuntu
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-aarch64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-aarch64.tar.gz -C / --exclude="./bin" && \
    tar xzf /tmp/s6-overlay-aarch64.tar.gz -C /usr ./bin
RUN apt-get update
RUN apt-get install -y curl
RUN ln -snf /usr/share/zoneinfo/$(curl https://ipapi.co/timezone) /etc/localtime
RUN apt-get install -y npm
RUN npm install -g --unsafe-perm serialport && npm install -g --unsafe-perm async && npm install -g homebridge-nikobus --unsafe-perm && npm install -g --unsafe-perm homebridge homebridge-config-ui-x
RUN mkdir -m 755 -p /etc/services.d/homebridge && touch /etc/services.d/homebridge/run && echo '#!/usr/bin/execlineb -P\ns6-setuidgid root /usr/local/bin/hb-service run --allow-root --docker' > /etc/services.d/homebridge/run
EXPOSE 8581
ENTRYPOINT ["/init"]
