FROM public.ecr.aws/lambda/nodejs:14.2022.06.14.15

RUN npm install -g yarn

RUN yum install unzip -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
	rm -rf awscliv2.zip ./aws

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production=false

COPY . .

RUN chmod +x generate-deploy-site.sh

ENV BROWSERSLIST_IGNORE_OLD_DATA=TRUE

ENTRYPOINT ["/app/node_modules/qxpcms-site/bin/generate-deploy-site.sh"]
