FROM dperson/samba:latest@sha256:e1d2a7366690749a7be06f72bdbf6a5a7d15726fc84e4e4f41e967214516edfd

RUN apk --no-cache add nginx &&\
    mkdir /shares &&\
    mkdir -p /app/nginx-conf.d

COPY nginx.conf /app/nginx.conf
COPY entry.sh /entry.sh

EXPOSE 80
VOLUME [ "/shares" ]

ENTRYPOINT [ "tini", "--", "/entry.sh" ]
