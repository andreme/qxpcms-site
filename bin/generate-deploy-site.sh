#!/bin/bash
set -e

TASK_ID=$(echo $ECS_CONTAINER_METADATA_URI | cut -d "/" -f 5 | cut -d "-" -f 1)

aws events put-events --cli-input-json '{"Entries":[{"Source":"qxpcms.'"$PROJECT_NAME"'","Detail":"{\"action\":\"site-deployment.start\",\"siteDeploymentId\":\"'"$SITE_DEPLOYMENT_ID"'\",\"siteDeploymentLogId\":\"'"$TASK_ID"'\"}","EventBusName":"'"$PROJECT_NAME"'-events","DetailType":"cms.log.system"}]}' > /dev/null

pnpm build

pnpm run deploy

aws events put-events --cli-input-json '{"Entries":[{"Source":"qxpcms.'"$PROJECT_NAME"'","Detail":"{\"action\":\"site-deployment.finished\",\"siteDeploymentId\":\"'"$SITE_DEPLOYMENT_ID"'\"}","EventBusName":"'"$PROJECT_NAME"'-events","DetailType":"cms.log.system"}]}' > /dev/null
