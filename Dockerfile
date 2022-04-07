FROM node:12-alpine

RUN apk update ; apk upgrade ; apk add bash

SHELL [ "/bin/bash", "-c" ]

COPY . /home/node/

# change to directory
WORKDIR /home/node/

RUN apk add curl

ARG BUILD_ENVIRONMENT
ARG ENV_FILE

RUN yarn add -g @angular/cli
RUN yarn add my-foo@npm:foo@1.0.1
RUN yarn add foo@1.2.3 --exact

RUN npm install my-react@npm:react
RUN npm install jquery2@npm:jquery@2
RUN npm install jquery3@npm:jquery@3
RUN npm install npa@npm:npm-package-arg
RUN npm install sax@latest
RUN npm install @myorg/mypackage@latest
RUN npm install -g react-scripts

RUN chown -Rh node:node /usr/src/app

RUN gem install a0-tzmigration-ruby
RUN gem i GEMNAME1
RUN gem i GEMNAME2 --version 1.2.3
RUN gem i --version 1.2.3 GEMNAME-Version

RUN python3 -m pip install "SomeProject~=1.4.2"
RUN python3 -m pip install "SomeProject==1.4"
RUN pip install rabbit-mq celery redis jira


RUN composer require stripe/stripe-php

# RUN go get example.com/theirmodule@v1.3.4
# RUN go get example.com/theirmodule@latest
# RUN go get -d golang.org/x/text@v0.3.2

CMD [ "sh", "-c", "npm install && npm run start" ]

#FOR PROD
# CMD [ "sh", "-c", "npm install build" ]

RUN yarn run build:$BUILD_ENVIRONMENT

RUN mkdir /home/bishamonten
RUN cp /home/node/public/envs/$ENV_FILE /home/node/build/

RUN mv /home/node/build/$ENV_FILE /home/node/build/env.js 

RUN cp /home/node/redirect.html /home/node/build/

RUN cp -rf /home/node/build /home/bishamonten/

RUN apk add nginx openrc

RUN mkdir /etc/nginx/sites-enabled /etc/nginx/sites-available

RUN cp -rf /home/node/docker/nginx/nginx.conf /etc/nginx/

RUN openrc ; touch /run/openrc/softlevel


RUN chmod +x startup.sh

ENTRYPOINT ["/bin/bash", "startup.sh"]
