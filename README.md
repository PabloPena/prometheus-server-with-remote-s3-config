This is an extension of the standard *[prom/prometheus](https://hub.docker.com/r/prom/prometheus/)* Docker image. 

The image building requires setting a unique environment variable:`S3_CONFIG_LOCATION`. It should contains a S3 URI to valid Prometheus config YAML file.

## Building

`docker build -t prometheus .`

## Running

`docker run -e S3_CONFIG_LOCATION=s3://<s3-bucket>/prometheus.yml prometheus`


## AWS Permissions

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
