docker network create app-network

docker run -d --name redis \
  --network app-network \
  redis

docker run -d --name db \
  --network app-network \
  -e POSTGRES_PASSWORD=password \
  postgres

docker run -d --name backend \
  --network app-network \
  -p 5000:5000 \
  my-backend

docker run -d --name frontend \
  --network app-network \
  -p 8080:80 \
  my-frontend