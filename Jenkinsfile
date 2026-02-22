pipeline {
    agent any
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'test', 'staging', 'prod'],
            description: 'Environment (dev, test, staging or prod)'
        )
    }

    stages {
        stage('terraform init') {
            steps {
                script {
                    echo "Chosen environment: ${params.ENVIRONMENT}"
                    withAWS(region: 'eu-central-1', credentials: 'aws-terraform') {
                        dir("environments/${params.ENVIRONMENT}") {
                            sh "terraform init"
                        }
                    }
                }
            }
        }

        stage('terraform plan') {
            steps {
                script {
                    withAWS(region: 'eu-central-1', credentials: 'aws-terraform') {
                        dir("environments/${params.ENVIRONMENT}") {
                            sh "terraform plan -target=module.network -target=module.compute -out=tfplan"
                            sh "terraform show -no-color tfplan > tfplan.txt"
                        }
                    }
                }
            }
        }

        stage('if prod -> ask for confirmation') {
            when {
                expression { params.ENVIRONMENT == "prod"}
            }
            steps {
                input message: "Are you sure you want to change the prod environment?", ok: "Yes, please!"
            }
        }

        stage('terraform apply') {
            steps {
                script {
                    withAWS(region: 'eu-central-1', credentials: 'aws-terraform') {
                        dir("environments/${params.ENVIRONMENT}") {
                            // logging out of docker to prevent "401: Unauthorized" error when downloading helm charts
                            sh "docker logout"

                            echo "Applying base infrastructure (network, compute)"
                            sh "terraform apply -target=module.network -target=module.compute --auto-approve"

                            echo "Waiting for EKS to be ready"
                            sleep 30

                            echo "Applying database and security modules"
                            sh "terraform apply -target=module.database -target=module.security --auto-approve"

                            echo "Applying app-config module"
                            sh "terraform apply --auto-approve"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                archiveArtifacts artifacts: 'environments/**/tfplan.txt', allowEmptyArchive: true
            }
            deleteDir()
        }
    }
}