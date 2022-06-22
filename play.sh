docker stop vrising-container
docker system prune -a
docker build . -t vrising
DATA="/home/steam/vrising-server-dedicated/save-data"
docker run -d -it --name vrising-container -v "vrising-storage:$DATA" vrising
sudo docker exec -u 0 vrising-container chown steam:steam "$DATA"