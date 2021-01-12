# using a node-alpine image, do the following:
FROM node:alpine as STAGE1

WORKDIR /vinod/files

# copy package.json to container
COPY ./package.json ./

# install node dependencies from package.json

# COPY ./deps.sh ./
# RUN sh ./deps.sh
RUN run npm install

# copy the source code to the container
COPY ./ ./

# run npm run build --> generates the static files html/js/css 
# and stores in ./build within the container
RUN npm run build

# STAGE1 ends here (since there is new base image used in the next step)

# using nginx-alpine image, create a new container
FROM nginx:alpine as STAGE2
# the above step now discards the FS-Snapshot created during the previous step

# copy the generated build artifacts to this new container
COPY --from=STAGE1 /vinod/files/build /usr/share/nginx/html

# run the nginx server
EXPOSE 80

ENTRYPOINT [ "nginx", "-g", "daemon off;"]

# docker build -t learnwithvinod/my-react-app:latest .    
# docker run --name my-react-app --rm -p 8080:80 -d learnwithvinod/my-react-app