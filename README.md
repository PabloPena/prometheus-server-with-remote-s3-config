This is an extension of the standard *[prom/prometheus](https://hub.docker.com/r/prom/prometheus/)* Docker image. 

The image building requires setting a mandatory environment variable:`S3_CONFIG_LOCATION`. It should contains a S3 URI to valid Prometheus config YAML file.

The possibility of securing the service via one administrator user has been added. To enable it, we need to set the `HTTP_BASIC_AUTH` environment variable. The user will be `admin` and the default password will be admin by default or the one configured in `WEB_AUTH_PASSWORD` environment variable.

Other prometheus configurations can be overwritten:
- `PROMETHEUS_RETENTION_TIME`: Default value "30d". Check the *[documentation](https://prometheus.io/docs/prometheus/latest/storage/)* before changing the value.
- `PROMETHEUS_RETENTION_SIZE`: Default value "10GB". Check *[documentation](https://prometheus.io/docs/prometheus/latest/storage/)* before changing the value.
- `HTTP_LISTEN_PORT`: Default value 9090.

## Building

`docker build -t prometheus-with-remote-s3-config .`

## Running

`docker run -e S3_CONFIG_LOCATION=s3://<s3-bucket>/prometheus.yml -p 9090:9090 prometheus-with-remote-s3-config`

<br>

### AWS Permissions

The deployed container should includes some IAM role policy to allow access to AWS S3 locations:

```
{
  Effect = "Allow"
  Action = [
    "s3:GetObject",
    "s3:ListBucket",
  ]
  Resource = [
    ${<s3-bucket-name>},
    "${<s3-bucket-name>}/*"
  ]
}
```
