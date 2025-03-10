# DevOps Simple NodeJS app

How to build & run the app:

```sh
npm install
npm start # node app.js
```

How to create & run a Docker image:

```sh
# MacOS: the architecture generated is linux/arm64
docker build -t josefloressv/nodeapp:latest .

# MacOS: change the architecture generated to linux/amd64
docker build --platform=linux/amd64 -t josefloressv/nodeapp:latest .

# run
docker run --name=node01 -itd -p 80:3000 josefloressv/nodeapp:latest
```

Tag & push to Docker Registry:
```sh
#Docker Hub
docker login
docker tag josefloressv/nodeapp:latest josefloressv/nodeapp:v1.0
docker push josefloressv/nodeapp:v1.0

#AWS ECR
docker login --username AWS --password $(aws ecr get-login-password --region us-east-1) [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com
docker tag josefloressv/nodeapp:latest [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/nodeapp:v1.0
docker push [AWS_ACCOUNT_NUMBER].dkr.ecr.[AWS_REGION].amazonaws.com/nodeapp:v1.0
```

...
