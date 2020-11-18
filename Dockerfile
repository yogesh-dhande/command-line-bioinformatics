FROM node

WORKDIR /app

COPY docker-debian.sh .

RUN apt-get update \
    && /bin/bash docker-debian.sh \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN mkdir server client

COPY server/package.json /app/server
RUN cd /app/server && npm install


COPY client/package.json /app/client
RUN cd /app/client && npm install

COPY . .

CMD ["/bin/bash", "run.sh"]