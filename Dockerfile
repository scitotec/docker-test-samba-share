FROM dperson/samba:latest

RUN apk --no-cache add nginx &&\
    mkdir /shares

COPY nginx.conf /app/nginx.conf
COPY entry.sh /entry.sh

EXPOSE 80
VOLUME [ "/shares" ]

ENTRYPOINT [ "tini", "--", "/entry.sh" ]
