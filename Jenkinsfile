pipeline {
  agent { none }
  options {
    ansiColor('xterm')
    buildDiscarder(logRotator(daysToKeepStr:'30', artifactNumToKeepStr:'3'))
    timeout(time:5, unit:'MINUTES')
    timestamps()
  }
  parameters {
    string( name: 'GIT_REF', description: 'Git reference to build from', defaultValue: '')
    string( name: 'DOCKER_IMAGE_NAME', description: 'Docker image name', defaultValue: 'image')
    string( name: 'DOCKER_IMAGE_NAMESPACE', description: 'Docker image namespace', defaultValue: 'namespace')
    string( name: 'DOCKER_IMAGE_TAG', description: 'Docker image version tag', defaultValue: '')
  }
  environment {
    TERRAFORM_CMD = 'docker run --network host " -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light'
    ARTIFACTORY = credentials('user-artifactory-reader')
    ARTIFACTORY_URL = 'https://quadanalytix.jfrog.io/quadanalytix'
    AWS_DEFAULT_REGION = 'us-west-2'
    //AWS = credentials('aws-one-jenkins') // Env: one
    //appEnv = 'One'
  }
  stages {
    stage('Test setup data') {
      agent { label "slave" }
      environment {
        STAGE = 'Test Setup'
      }
      steps{
        sh  '''
            set +x
            echo "TERRAFORM_CMD = ${TERRAFORM_CMD}"
            echo "ARTIFACTORY = ${ARTIFACTORY}"
            echo "ARTIFACTORY_PSW = ${ARTIFACTORY_PSW}"
            echo "ARTIFACTORY_USR = ${ARTIFACTORY_USR}"
            echo "ARTIFACTORY_URL = ${ARTIFACTORY_URL}"
            echo "AWS_DEFAULT_REGION = ${AWS_DEFAULT_REGION}"
            #echo "AWS = ${AWS}"
            #echo "AWS_PSW = ${AWS_PSW}"
            #echo "AWS_USR = ${AWS_USR}"
            #echo "appEnv = ${appEnv}"
            '''
        script {
          echo 'Test groovy loop'
          def browsers = ['chrome', 'firefox']
          for (int i = 0; i < browsers.size(); ++i) {
              echo "Testing the ${browsers[i]} browser"
          }
        }
      }
    }
    stage('Docker Building') {
      parallel {
        stage('ECR Repo') {
          agent { label "slave" }
          steps {
            echo "ECR repo creation..."
            echo "aws_region = ${AWS_DEFAULT_REGION}"
            echo "aws_RO_accounts = "
            echo "image_name = ${DOCKER_IMAGE_NAME}"
            echo "namespace = ${DOCKER_IMAGE_NAMESPACE}"
            //build job: 'UTIL+ansible-playbook-ecr+CI+Build+ECR_Create', parameters: [[$class: 'ValidatingStringParameterValue', name: 'aws_region', value: 'us-west-2'], [$class: 'ValidatingStringParameterValue', name: 'aws_RO_accounts', value: '123456789012'], [$class: 'ValidatingStringParameterValue', name: 'image_name', value: 'image'], [$class: 'ValidatingStringParameterValue', name: 'namespace', value: 'test']]
          }
        }
        stage('Analyse Dockerfile') {
          agent { label "slave" }
          steps {
            sh  '''
                echo "Dockerfile analysis..."
                '''
          }
        }
        stage('Build Docker') {
          agent { label "slave" }
          steps {
            echo 'Building docker image'
          }
        }
      }
    }
    //milestone 1
    stage('Deploy One'){
      agent { label "slave" }
      environment {
        AWS = credentials('aws-one-jenkins')
        appEnv = 'One'
      }
      steps {
        echo "Deploying to ${appEnv}"
      }
    }
  }
  post {
    always {
      pragprog displayLanguageCode: 'en', indicateBuildResult: true
    }
  }
}
