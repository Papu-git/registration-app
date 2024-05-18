pipeline {
  agent { label 'Jenkins-Agent' }
  tools {
    jdk 'Java17'
    maven 'Maven3.9.6'
}
  stages("Cleanup Workspace"){
    steps {
      CleanWs()
    }
}
  stages("Checkout from scm"){
    steps {
      git branch: 'dev', credentialsId: 'github', url: 'https://github.com/Papu-git/registration-app/'
    }
  }
   stages("Build Application"){
    steps {
      sh "mvn clean package"
    }
  }
   stages("Test Application"){
    steps {
      sh "mvn test"
    }
  }
}
