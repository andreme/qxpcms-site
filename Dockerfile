FROM public.ecr.aws/lambda/nodejs:20.2024.11.19.18

RUN corepack enable && \
	corepack prepare pnpm@10.12.4 --activate

RUN dnf install unzip -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
	rm -rf awscliv2.zip ./aws

WORKDIR /app

ENV BROWSERSLIST_IGNORE_OLD_DATA=TRUE

COPY package.json pnpm-lock.yaml ./
RUN pnpm install && \
    chmod +x node_modules/qxpcms-site/bin/generate-deploy-site.sh

COPY . .

ENTRYPOINT ["/app/node_modules/qxpcms-site/bin/generate-deploy-site.sh"]
