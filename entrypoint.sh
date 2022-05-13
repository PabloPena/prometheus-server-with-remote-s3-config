#!/bin/sh
set -e

rm /etc/prometheus/prometheus.yml
if [[ -z $S3_CONFIG_LOCATION ]]; then
  echo "S3_CONFIG_LOCATION environment variable is mandatory and must be contains a S3 valid URI"
  exit 1
fi

echo "Retrieving remote prometheus config: '${S3_CONFIG_LOCATION}'"
aws s3 cp ${S3_CONFIG_LOCATION} /etc/prometheus

echo "The following config was loaded:"
cat /etc/prometheus

/bin/prometheus $@
