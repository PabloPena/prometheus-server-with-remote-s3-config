#!/bin/sh
set -e

if [ -z $S3_CONFIG_LOCATION ]
then
  echo "S3_CONFIG_LOCATION environment variable is mandatory and must be contains a S3 valid URI"
  exit 1
fi

# Loads prometheus server configuration from S3 location
rm /opt/bitnami/prometheus/conf/prometheus.yml -f
echo "Retrieving remote prometheus config: '${S3_CONFIG_LOCATION}'"
aws s3 cp $S3_CONFIG_LOCATION /opt/bitnami/prometheus/conf/prometheus.yml

if [ -z $HTTP_BASIC_AUTH ] 
then
  echo "Server client will be deployed without authentication"
  touch /opt/bitnami/prometheus/conf/web.yml
else
  WEB_AUTH_PASSWORD="admin"
  if [ $WEB_AUTH_PASSWORD_CONFIG ]
  then
    WEB_AUTH_PASSWORD=$WEB_AUTH_PASSWORD_CONFIG
  fi
  ENCRYPTED_WEB_AUTH_PASSWORD=$(python3 /tmp/gen-pass.py $WEB_AUTH_PASSWORD)

  # Builds web configuration (currently only adds an unique admin user)
  echo "Building web configuration with basic auth..."
  export ENCRYPTED_WEB_AUTH_PASSWORD
  envsubst < /tmp/web.yml > /opt/bitnami/prometheus/conf/web.yml
fi

/opt/bitnami/prometheus/bin/prometheus \
  --config.file=/opt/bitnami/prometheus/conf/prometheus.yml --web.config.file=/opt/bitnami/prometheus/conf/web.yml \
  --storage.tsdb.path=/opt/bitnami/prometheus/data --web.listen-address=:$HTTP_LISTEN_PORT \
  --storage.tsdb.retention.size=$PROMETHEUS_RETENTION_SIZE --storage.tsdb.retention.time=$PROMETHEUS_RETENTION_TIME \
  --log.format=json --web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries \
  --web.console.templates=/opt/bitnami/prometheus/conf/consoles 
