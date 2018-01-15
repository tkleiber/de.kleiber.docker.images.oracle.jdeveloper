pipeline {
  agent {
    node {
      label 'localhost_vagrant'
    }

  }
  stages {
    stage('Build Oracle SQL JDeveloper Image') {
      steps {
        sh 'if [ ! -f $SW_FILE1 ]; then cp "$SW_DIR/$SW_FILE1" $SW_FILE1; fi'
        sh 'if [ ! -f $SW_FILE2 ]; then cp "$SW_DIR/$SW_FILE2" $SW_FILE2; fi'
        sh 'if [ ! -f silent.rsp ]; then cp "silent.rsp" silent.rsp; fi'
        sh 'if [ ! -f create_inventory.sh ]; then cp "create_inventory.sh" create_inventory.sh; fi'
        withCredentials([usernamePassword(credentialsId: 'store.docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh '''docker login --username $USERNAME --password $PASSWORD
sudo docker build --tag oracle/jdeveloper:$SW_VERSION --build-arg SW_FILE1=$SW_FILE1 --build-arg SW_FILE2=$SW_FILE2 .'''
        }
      }
    }
    stage('Push Docker Image to Local Registry') {
      steps {
        sh 'docker tag oracle/jdeveloper:$SW_VERSION localhost:5000/oracle/jdeveloper:$SW_VERSION'
        sh 'docker push localhost:5000/oracle/jdeveloper:$SW_VERSION'
      }
    }
    stage('Cleanup') {
      steps {
        sh 'docker rmi --force localhost:5000/oracle/jdeveloper:$SW_VERSION'
        sh 'docker rmi --force oracle/jdeveloper:$SW_VERSION'
      }
    }
  }
  environment {
    SW_VERSION = '12.2.1.3'
    SW_FILE1 = 'jdev_suite_122130.jar'
    SW_FILE2 = 'jdev_suite_1221302.jar'
    SW_DIR = '/software/Oracle/JDeveloper'
  }
}
