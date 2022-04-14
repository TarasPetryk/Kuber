pipeline {
    
    environment {
        registryCredential = 'kuber'
    }
    
    agent any 
    
    stages {
        
        stage ('Test'){
            steps{
                echo "Running ${env.BUILD_ID}"
                echo params.branch
                script {
                    currentBuild.result = 'ABORTED'
                    error("Aborting the build.")
                }
            }
        }
        
        stage('Build') {
            steps {
              checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']],
                userRemoteConfigs: [[url: 'https://github.com/TarasPetryk/Kuber.git']]])
                sh "echo '<html><body><h1>Build number is ${env.BUILD_ID}</h1>' > index.html"
                sh "sed -i 's/placeholder/${env.BUILD_ID}/' deployment.yaml"
          }
        }
        
        stage('Build Image'){
            steps {
                script {
                    docker.withRegistry( '', registryCredential ){
                        def httpdImage = docker.build("taraspetryk/httpd:${env.BUILD_ID}")
                        httpdImage.push()
                        httpdImage.push('latest')
                    }
                }
            }
        }
        
        
        stage('K8s update'){
            steps {
                //sh "sudo pkill kubectl -9"
                withKubeConfig([credentialsId: 'kub-rob', serverUrl: 'https://192.168.49.2:8443']) {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
        
        
    }
    
    post { 
        always { 
            cleanWs()
            sh 'docker system prune -af'
        }
    }
    
}
