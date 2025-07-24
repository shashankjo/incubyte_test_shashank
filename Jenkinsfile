#!/usr/bin/env groovy

pipeline {
  agent { label 'builder' }

  environment {
    SERVICE                 = "concora-emulator"
    SLACK_CHANNEL           = "#uw-notifications"
    BRANCH                  = env.BRANCH_NAME.replace('/', '-')
    IMAGE_TAG               = "${env.BRANCH}-${env.BUILD_NUMBER}"
    CI_IMAGE_TAG            = "CI-${env.BRANCH}-${env.BUILD_NUMBER}"
    REGISTRY                = "315174919334.dkr.ecr.us-east-2.amazonaws.com"
    COMPOSE_PROJECT_NAME    = "${env.SERVICE}"
    REGISTRY_REGION         = "us-east-2"
  }

  stages {
    stage('build') {
      environment {
        GITHUB_TOKEN = credentials('acimabot-github-token')
        GITHUB_USERNAME = "acimabot"
      }
      steps {
        node('docker') {
          checkout scm
            sh '''
              docker build --target deploy --cache-from $REGISTRY/$SERVICE:latest -t $REGISTRY/$SERVICE:$IMAGE_TAG --build-arg GITHUB_TOKEN --build-arg GITHUB_USERNAME .
              docker build --target ci -t $REGISTRY/$SERVICE:CI-$IMAGE_TAG --build-arg GITHUB_TOKEN --build-arg GITHUB_USERNAME .
              docker push $REGISTRY/$SERVICE:CI-$IMAGE_TAG
              docker push $REGISTRY/$SERVICE:$IMAGE_TAG
            '''
        }
      }
      post {
        success {
          slackSend channel: "$SLACK_CHANNEL", color: '#6DC4E8', message: "<$RUN_DISPLAY_URL|Build $BUILD_NUMBER> on ${env.JOB_NAME.replace('%2F', '/')} \
\nImage ready, build in progress (<$RUN_CHANGES_DISPLAY_URL|Changes>).\nImage tag: *$IMAGE_TAG*\
\nDeploy to \
<https://jenkins.smpl.ch/job/k8s-deploy/buildWithParameters?token=abc123&IMAGE_TAG=$IMAGE_TAG&SERVICE_ENV=dev&SERVICE=$SERVICE|DEV> | \
<https://jenkins.smpl.ch/job/k8s-deploy/buildWithParameters?token=abc123&IMAGE_TAG=$IMAGE_TAG&SERVICE_ENV=preflight&SERVICE=$SERVICE|PREFLIGHT> \
while build finishes"
        }
        always {
          deleteDir()
        }
      }
    }
    stage('test') {
      steps {
        checkout scm
          ansiColor('xterm') {
            sh '''
              docker pull $REGISTRY/$SERVICE:CI-$IMAGE_TAG
              docker tag $REGISTRY/$SERVICE:CI-$IMAGE_TAG $SERVICE
              docker-compose -f docker-compose.ci.yml up -d
              sleep 5
              docker-compose -f docker-compose.ci.yml run web rspec
            '''
          }
      }
      post {
        always {
          sh 'docker-compose -f docker-compose.ci.yml down'
          deleteDir()
        }
      }
    }

    stage('dev-image') {
      when {
        branch 'master'
      }
      environment {
        GITHUB_TOKEN = credentials('acimabot-github-token')
        GITHUB_USERNAME = "acimabot"
        DEV_ENV_MASTER_KEY = credentials('dev_env_master_key')
      }
      steps {
        node('docker') {
          checkout scm
          sh '''
          docker pull $REGISTRY/$SERVICE:$IMAGE_TAG || true
          docker build --target dev --cache-from $REGISTRY/$SERVICE:$IMAGE_TAG -t $REGISTRY/$SERVICE:dev --build-arg DEV_ENV_MASTER_KEY="$DEV_ENV_MASTER_KEY" --build-arg GITHUB_TOKEN --build-arg GITHUB_USERNAME .
          docker push $REGISTRY/$SERVICE:dev
          '''
        }
      }
    }

    stage('deploy-dev') {
      when        { branch 'master' }
      environment { SERVICE_ENV = "dev" }
      steps { k8sDeploy() }
    }

    stage('deploy-preflight') {
      when        { branch 'master' }
      environment { SERVICE_ENV = "preflight" }
      steps { k8sDeploy() }
    }

    stage('deploy-sandbox') {
      when        { branch 'master' }
      environment { SERVICE_ENV = "sandbox" }
      steps { k8sDeploy() }
    }

    stage('deploy-learning') {
      when        { branch 'master' }
      environment { SERVICE_ENV = "learning" }
      steps { k8sDeploy() }
    }

  }

  post {
    success {
      slackSend channel: "$SLACK_CHANNEL", color: 'good', message: "<$RUN_DISPLAY_URL|Build $BUILD_NUMBER> on ${env.JOB_NAME.replace('%2F', '/')} \
passed (<$RUN_CHANGES_DISPLAY_URL|Changes>).\nImage tag: *$IMAGE_TAG*\
\nDeploy to \
<https://jenkins.smpl.ch/job/k8s-deploy/buildWithParameters?token=abc123&IMAGE_TAG=$IMAGE_TAG&SERVICE_ENV=preflight&SERVICE=$SERVICE|PREFLIGHT> | \
<https://jenkins.smpl.ch/job/k8s-deploy/buildWithParameters?token=abc123&IMAGE_TAG=$IMAGE_TAG&SERVICE_ENV=dev&SERVICE=$SERVICE|DEV>"
      slackSend channel: "$SLACK_CHANNEL", color: 'good', message: "Build $BUILD_NUMBER on branch $BRANCH_NAME passed: $BUILD_URL"
      script {
        if (env.BRANCH_NAME == "master") {
          sh '''
            docker pull $REGISTRY/$SERVICE:$IMAGE_TAG
            docker tag $REGISTRY/$SERVICE:$IMAGE_TAG $REGISTRY/$SERVICE:latest
            docker push $REGISTRY/$SERVICE:latest
            '''
        }
      }
    }
    failure {
      slackSend channel: env.SLACK_CHANNEL, color: 'danger', message: "Build $BUILD_NUMBER on branch $BRANCH_NAME failed: $BUILD_URL"
        sh '''
        aws ecr batch-delete-image --repository-name $SERVICE --image-ids imageTag=$IMAGE_TAG --region $REGISTRY_REGION
        '''
    }
  }
}