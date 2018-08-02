FROM node:carbon
RUN npm install -g @mapbox/togeojson && apt-get update && apt-get install -y jq
