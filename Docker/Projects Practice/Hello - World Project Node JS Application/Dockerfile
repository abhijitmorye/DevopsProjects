FROM node:13-alpine  
# install node on container


RUN mkdir -p /home/app
# create /app folder in home directory

COPY ./app /home/app
#copy code from app to container's app directory

WORKDIR /home/app
# set working directory as /home/app


CMD ["node","app.js"]
#run app.js command