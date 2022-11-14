FROM public.ecr.aws/lambda/nodejs:14.2022.06.14.15

RUN npm install -g yarn

RUN yum install unzip -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
	rm -rf awscliv2.zip ./aws

WORKDIR /app

ENV BROWSERSLIST_IGNORE_OLD_DATA=TRUE

COPY package.json yarn.lock ./
RUN yarn install --production=false \
    chmod +x node_modules/qxpcms-site/bin/generate-deploy-site.sh

COPY . .

ENTRYPOINT ["/app/node_modules/qxpcms-site/bin/generate-deploy-site.sh"]
