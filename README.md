# Jenkins-as-Code - Jenkins in docker for build docker containers in docker

This image provide jenkins in docker for build docker containers in docker agents.

## Project tree
Based on https://github.com/rmuhamedgaliev/jenkins_docker

```sh
.
├── Dockerfile
├── Dockerfile.build
├── Jenkinsfile
├── README.md
└── docker-compose.yml
```

## Jenkins container startup example:

- Create your Jenkins admin secret:

```sh
echo "<user>:<password>" > .secret
```

- Start up docker-compose stack:

```sh
docker-compose up -d
```

- Login into Jenkins at http://<HOST_IP>:8080

- Create test Pipeine using Jenkinsfile from this repo

- Execute test Pipeine and make sure it is ok

- Destroy docker-compose stack with docker volumes:

```sh
docker-compose down -v
```
