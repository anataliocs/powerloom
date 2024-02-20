## About

Run a Powerloom lite Node slot on Polygon POS on Spheron

If you don't already have one, (Create a Spheron account )[https://app.spheron.network/#/signup]

## Setup
There are multiple ways to set up the Snapshotter Lite Node. You can either use the Docker image or run it directly on your local machine.
However, it is recommended to use the Docker image as it is the easiest and most reliable way to set up the Snapshotter Lite Node.

```bash
docker build --platform linux/amd64 -t spheron-powerloom-snapshotter-lite .
```

Push to DockerHub
```
docker tag spheron-powerloom-snapshotter-lite chrisaspheron/spheron-powerloom-snapshotter-lite:latest
docker push chrisaspheron/spheron-powerloom-snapshotter-lite:latest
```

