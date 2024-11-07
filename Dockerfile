FROM --platform=linux/amd64 dperson/samba:latest@sha256:e1d2a7366690749a7be06f72bdbf6a5a7d15726fc84e4e4f41e967214516edfd AS build_amd64
FROM --platform=linux/arm dperson/samba:latest@sha256:9295923d089cb29c56786c1092c295442f6ca88e3362deb7600a6774cb63434b AS build_arm
FROM --platform=linux/arm64 dperson/samba:latest@sha256:4cb487986c024c4b42c7900b03ee5cc051d66ba57ec687c9f393e64a54cac3e3 AS build_arm64

FROM build_${TARGETARCH} AS build

RUN apk --no-cache add nginx &&\
    mkdir /shares &&\
    mkdir -p /app/nginx-conf.d

COPY nginx.conf /app/nginx.conf
COPY entry.sh /entry.sh

EXPOSE 80
VOLUME [ "/shares" ]

ENTRYPOINT [ "tini", "--", "/entry.sh" ]
