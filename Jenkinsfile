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

     /*   stage('Authenticate SSO for AWS role') {
            steps {
                sh "python3 /usr/local/bin/gaws.py 503125591 --profile default --account 400123706343 --role bu-power-user --region eu-west-1 --passwd ${JENKINS_USER_PASS}"
            }
        } */

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
                  sudo terraform init
                  sudo terraform plan -input=false -out ${plan} --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"
                  // terraform plan --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"

                   sudo terraform show $plan
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
                   sudo terraform init
                   sudo terraform plan -input=false -out ${plan} --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"
		   //terraform plan --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"
                   """
            script {
              input "Create/update Terraform stack for GEHC ODP ${params.environment} env in aws?" 

                sh """
                  cd environments/nprod
                  sudo terraform apply -input=false -auto-approve ${plan} --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"
		  //terraform apply --var-file="/var/lib/jenkins/tfvars/nprod/terraform.tfvars"
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
                   sudo terraform init
                   sudo terraform show
                   """            
            script {
              input "Destroy Terraform stack for GEHC ODP ${params.environment} env in aws?" 

                sh """
                  cd environments/nprod
                  sudo terraform destroy -auto-approve
                """
            }
          }
       }
    }    
    post {
        always {
            echo 'Clean up workspace'
            // deleteDir()
        }
    }
}
