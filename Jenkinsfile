pipeline {
    
    environment {
        registryCredential = 'kuber'
    }
    
    agent any 
    
    stages {
        
        stage ('Test'){
            steps{
                echo "Running ${env.BUILD_ID}"
            }
        }
        
        stage('Build') {
            steps {
              checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']],
                //doGenerateSubmoduleConfigurations: false,
                //extensions: [[$class: 'CleanCheckout']],
                //submoduleCfg: [], 
                userRemoteConfigs: [[url: 'https://github.com/TarasPetryk/Kuber.git']]])
                sh "echo '<html><body><h1>Build number is ${env.BUILD_ID}</h1></body></html>' > index.html"
                //sh 'chmod 666 index.html'
                //sh 'ls' 
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
        
    }
    
    post { 
        always { 
            cleanWs()
            sh 'docker logout'
            sh 'docker system prune -af'
        }
    }
    
}
