# Build all docker images
docker build -t esaputra/multi-client:latest -t esaputra/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t esaputra/multi-server:latest -t esaputra/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t esaputra/multi-worker:latest -t esaputra/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push all docker images to the docker hub
docker push esaputra/multi-client:latest
docker push esaputra/multi-server:latest
docker push esaputra/multi-worker:latest

docker push esaputra/multi-client:$SHA
docker push esaputra/multi-server:$SHA
docker push esaputra/multi-worker:$SHA

# Apply all kubernetes config file in k8s folder
kubectl apply -f k8s

# Set image
kubectl set image deployments/server-deployment server=esaputra/multi-server:$SHA
kubectl set image deployments/client-deployment client=esaputra/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=esaputra/multi-worker:$SHA