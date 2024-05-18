pipeline {
  agent { label 'Jenkins-Agent' }
  tools {
    jdk 'Java17'
    maven 'Maven3.9.6'
  }
  environment {
    APP_NAME = 'registration-app'
    RELEASE = '1.0.0'
    DOCKER_USER = 'chandan077'
    DOCKER_PASS = 'Papu@1234'
    IMAGE_NAME = '${DOCKER_USER}' + '/' + "${APP_NAME}
    IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    DOCKER_TAG = "{BUILD_NUMBER}"
  }
  stages {
    stage('Cleanup Workspace') {
      steps {
        cleanWs()
      }
    }
    stage('Checkout from SCM') {
      steps {
        git branch: 'dev', credentialsId: 'github', url: 'https://github.com/Papu-git/registration-app/'
      }
    }
    stage('Build Application') {
      steps {
        sh "mvn clean package"
      }
    }
    stage('Test Application') {
      steps {
        sh "mvn test"
      }
    }
    stage('SonarQube Analysis') {
      steps {
        script {
          withSonarQubeEnv(credentialsId: 'jenkinssonar') {
            sh "mvn sonar:sonar"
          }
        }
      }
    }
    stage('Quality Gate') {
      steps {
        script {
          waitForQualityGate abortPipeline: false, credentialsId: 'jenkinssonar'
        }
      }
    }
    stage('Docker Build and Push') {
      steps {
        script {
          // Build Docker Image
          sh """
            docker build -t ${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG} .
          """
          // Login to Docker Registry
          sh """
            echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin ${DOCKER_REGISTRY}
          """
          // Push Docker Image
          sh """
            docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
          """
        }
      }
    }
  }
}
