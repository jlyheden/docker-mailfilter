#FROM arm64v8/alpine:3.8
FROM alpine:3.8

RUN apk --no-cache add \
  amavisd-new \
  spamassassin \
  clamav-daemon \
  clamav-libunrar \
  perl-net-dns \
  perl-mail-spf \
  razor \
  unarj \
  bzip2 \
  cabextract \
  cpio \
  file \
  gzip \
  lha \
  unrar \
  unzip \
  zip \
  supervisor \
  rsyslog \
  bash \
  curl

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /usr/local/bin/confd \
  && chmod +x /usr/local/bin/confd \
  && chown root:root /usr/local/bin/confd

EXPOSE 10024

COPY ./files/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./files/startup.sh /
COPY ./files/rsyslog.conf /etc/rsyslog.conf
RUN chmod +x /startup.sh
COPY ./conf.d /etc/confd/conf.d
COPY ./templates /etc/confd/templates

ENTRYPOINT [ "/startup.sh" ]
