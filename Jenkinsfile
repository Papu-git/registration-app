pipeline {
  agent { label 'Jenkins-Agent' }
  tools {
    jdk 'Java17'
    maven 'Maven3.9.6'
  }
  environment {
    APP_NAME = 'registration-app'
    RELEASE = '1.0.0'
    IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
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
          // Use Jenkins credentials for Docker login
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
            // Build Docker Image
            sh """
              docker build -t ${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG} .
            """
            // Login to Docker Registry
            sh """
              echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
            """
            // Push Docker Image
            sh """
              docker push ${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG}
            """
          }
        }
      }
    }
  }
}
