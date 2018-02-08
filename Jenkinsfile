pipeline {
  agent none
  options {
    ansiColor('xterm')
    buildDiscarder(logRotator(daysToKeepStr:'30', artifactNumToKeepStr:'3'))
    timeout(time:5, unit:'MINUTES')
    timestamps()
  }
  parameters {
    string( name: 'GIT_REF', description: 'Git reference to build from', defaultValue: '')
    string( name: 'DOCKER_IMAGE_NAME', description: 'Docker image name', defaultValue: 'image')
    string( name: 'DOCKER_IMAGE_NAMESPACE', description: 'Docker image namespace', defaultValue: 'test')
    string( name: 'DOCKER_IMAGE_TAG', description: 'Docker image version tag', defaultValue: '')
  }
  environment {
    TERRAFORM_CMD = 'docker run --network host " -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light'
    ARTIFACTORY = credentials('user-artifactory-reader')
    ARTIFACTORY_URL = 'https://quadanalytix.jfrog.io/quadanalytix'
    AWS_DEFAULT_REGION = 'us-west-2'
    dockerDir = 'infrastructure/docker'
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
        script {
          if (fileExists("${JENKINS_HOME}")) {
            NODE_HOME = "${JENKINS_HOME}"
          } else {
            NODE_HOME = ("${WORKSPACE}" =~ /^(.*)\/workspace/)[0][1]
          }
          env.HOME = "${env.WORKSPACE}"
          env.NODE_HOME = "${NODE_HOME}"
          env.PATH = "${PATH}:${NODE_HOME}/bin"
        }
        sh  '''
            set +x
            echo "HOME = ${HOME}"
            echo "NODE_HOME = ${NODE_HOME}"
            echo "PATH = ${PATH}"
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
          environment {
            aws_RO_accounts = '830036458304,116821282425,763929378304'
          }
          steps {
            sh  '''
                set +x
                echo "HOME = ${HOME}"
                echo "NODE_HOME = ${NODE_HOME}"
                echo "PATH = ${PATH}"
                echo "ECR repo creation..."
                echo "aws_region = ${AWS_DEFAULT_REGION}"
                echo "aws_RO_accounts = ${aws_RO_accounts}"
                echo "image_name = ${DOCKER_IMAGE_NAME}"
                echo "namespace = ${DOCKER_IMAGE_NAMESPACE}"
                '''
            // Failing in ValidatingStringParameter, regex , NullPointerException
            // All variables are set
            //build(job: 'UTIL+ansible-playbook-ecr+CI+Build+ECR_Create',
            //  parameters: [
            //    [$class: 'ValidatingStringParameterValue', name: 'aws_region', value: "${AWS_DEFAULT_REGION}"],
            //    [$class: 'ValidatingStringParameterValue', name: 'aws_RO_accounts', value: "${aws_RO_accounts}"],
            //    [$class: 'ValidatingStringParameterValue', name: 'image_name', value: "${DOCKER_IMAGE_NAME}"],
            //    [$class: 'ValidatingStringParameterValue', name: 'namespace', value: "${DOCKER_IMAGE_NAMESPACE}"]
            //  ])
            // Exactly from generator. Fails the same
            //build job: 'UTIL+ansible-playbook-ecr+CI+Build+ECR_Create', parameters: [[$class: 'ValidatingStringParameterValue', name: 'aws_region', value: 'us-west-2'], [$class: 'ValidatingStringParameterValue', name: 'aws_RO_accounts', value: '830036458304,116821282425,763929378304'], [$class: 'ValidatingStringParameterValue', name: 'image_name', value: 'image'], [$class: 'ValidatingStringParameterValue', name: 'namespace', value: 'test']]
          }
        }
        stage('Analyse Dockerfile') {
          agent { label "slave" }
          steps {
            sh  '''
                echo "Dockerfile analysis..."
                # Vars:
                static-analysis-dockerfile-wrapper.sh
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
