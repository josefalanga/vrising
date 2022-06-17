docker system prune -a && docker build . -t vrising
docker run -d -it --name vrising-container -v vrising-storage:/home/steam/vrising-server-dedicated/save-data vrising
sudo docker exec -u 0 vrising-container chown steam:steam /home/steam/vrising-server-dedicated/save-data