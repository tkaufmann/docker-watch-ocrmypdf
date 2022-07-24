FROM jbarlow83/ocrmypdf:latest

RUN apt-get update && \
    apt-get install inotify-tools curl unzip less nano man-db -y && \
    apt-get clean  && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

RUN curl https://raw.githubusercontent.com/tkaufmann/docker-watch-ocrmypdf/master/watch.sh --output /watch.sh
#ADD ./watch.sh /watch.sh
RUN chmod +x /watch.sh

RUN curl https://raw.githubusercontent.com/tkaufmann/docker-watch-ocrmypdf/master/copy.sh --output /copy.sh
#ADD ./copy.sh /copy.sh
RUN chmod +x /copy.sh

ENTRYPOINT [ "/watch.sh" ]
