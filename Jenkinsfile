pipeline {
    agent any

    /* environment {
        JENKINS_USER_PASS = credentials("jenkinsuser")
    }*/

    parameters {
        choice(name: 'action', choices: 'plan\napply\ndestroy', description: 'Create/update or destroy the AWS Infra.')
        string(name: 'environment', defaultValue : 'nprod', description: "GEHC ODP Plaform environment.")
    }

    /*options {
      disableConcurrentBuilds()
      timeout(time: 1, unit: 'HOURS')
      ansiColor('xterm')
    }*/

    stages {
        stage('Setup') {
          steps {
            script {
              currentBuild.displayName = "#" + env.BUILD_NUMBER + " " + params.action + "-" + params.environment
              plan = params.environment + '.plan'
            }
          }
        }

        stage('Checkout') {
          steps {
            checkout scm
          }
        }

        stage('TF Plan') {

          when {
            expression { params.action == 'plan' }
          }
          steps {
                sh """
                  cd environments/nprod
                  terraform init -input=false
                  terraform workspace select default
                  terraform plan -input=false -out ${plan} --var-file="/var/lib/jenkins/tfvars/nprod/rds.tfvars"
                  terraform show $plan
                   """
            }
        }

        stage('TF Apply') {
          when {
            expression { params.action == 'apply' }
          }
          steps {
                sh """
                   cd environments/nprod
                   terraform init -input=false
                   terraform plan -input=false -out ${plan} --var-file="/var/lib/jenkins/tfvars/nprod/rds.tfvars"
                                   """
            script {
              input "Create/update Terraform stack for GEHC ODP ${params.environment} env in aws?" 

                sh """
                 cd environments/nprod
                  terraform apply -input=false --auto-approve ${plan}
                   """
            }
          }
        }

        stage('TF Destroy') {
          when {
            expression { params.action == 'destroy' }
          }
          steps {
                sh """
                   cd environments/nprod
                   terraform init -input=false
                   terraform show
                   """            
            script {
              input "Destroy Terraform stack for GEHC ODP ${params.environment} env in aws?" 

                sh """
                  cd environments/nprod
                  terraform destroy --auto-approve --var-file="/var/lib/jenkins/tfvars/nprod/rds.tfvars"
                  """
            }
          }
       }
    }    
    post {
        always {
            echo 'Clean up workspace'
            deleteDir()
        }
    }
}
