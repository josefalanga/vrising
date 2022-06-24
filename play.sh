docker stop vrising-container
docker system prune -a
docker build . -t vrising
DATA="/home/steam/vrising-server-dedicated/save-data"
docker run -d -it --name vrising-container -p 27015-27036:27015-27036 -p 9876:9876 -p 9877:9877 -p 25575:25575 -v "vrising-storage:$DATA" vrising
sudo docker exec -u 0 vrising-container chown steam:steam "$DATA"
sudo docker exec -it vrising-container /bin/sh