FROM node
RUN apt update && \
    apt install -y jq && \
    npm install -g @mapbox/togeojson
ADD convert.sh .
RUN chmod +x convert.sh
