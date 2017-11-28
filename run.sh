#!/bin/sh
docker container kill nginx
docker container rm nginx
docker run -it --name nginx -d  --restart always -p 80:80 -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf nginx