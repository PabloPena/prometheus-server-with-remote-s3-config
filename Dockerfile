FROM bitnami/prometheus:2.29.1

ENV PROMETHEUS_RETENTION_TIME "30d"
ENV PROMETHEUS_RETENTION_SIZE "10GB"
ENV HTTP_LISTEN_PORT "9090"

USER root

RUN apt-get update && apt-get install -y awscli && apt-get install -y gettext && apt install -y python3-bcrypt

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY web.yml gen-pass.py /tmp/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
