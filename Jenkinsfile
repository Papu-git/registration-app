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
    // stage('Cleanup Workspace') {
    //   steps {
    //     cleanWs()
    //   }
    // }
    stage('Checkout from SCM') {
      steps {
        git branch: 'dev', credentialsId: 'github', url: 'https://github.com/Papu-git/registration-app/'
      }
    }
    stage('Print Working Directory') {
      steps {
        sh 'pwd'
      }
    }
    stage('Build Application') {
      steps {
        sh "mvn package"
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
    stage('Verify Build Artifacts') {
      steps {
        script {
          // Print the contents of the target directory to ensure the .war file is present
          sh "ls -la target"
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
    stage('Trivy Scan') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
            // Pull the Docker Image
            sh """
              docker pull ${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG}
            """
            // Run Trivy scan
            sh """
              docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG}
            """
          }
        }
      }
    }
    stage('Cleanup Artifacts') {
      steps {
        script {
          // Remove the Docker image to free up space
          sh """
            docker rmi ${DOCKER_USER}/${APP_NAME}:${IMAGE_TAG} || true
          """
          // Additional cleanup commands can be added here
          // For example, clean the workspace
          // cleanWs()
        }
      }
    }
    stage('Trigger CD pipeline') {
      steps {
        script {
          // Trigger the downstream CD pipeline via Jenkins API
          withCredentials([string(credentialsId: 'jenkins-api-token', variable: 'JENKINS_API_TOKEN')]) {
            sh """
              curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST "http://ec2-13-127-0-86.ap-south-1.compute.amazonaws.com/job/gitops-register-app-cd/buildWithParameters?APP_NAME=${APP_NAME}&IMAGE_TAG=${IMAGE_TAG}"
            """
          }
        }
      }
    }
  }
}

