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
                sh "sed 's/placeholder/${env.BUILD_ID}/' deployment.yaml"
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
        
        
        stage('K8s update'){
            steps {
                //sh "ps aux | grep -i kubectl | grep -v grep | awk {'print $2'} | sudo xargs kill"
                withKubeConfig([credentialsId: 'kub-rob', serverUrl: 'https://192.168.49.2:8443']) {
                    sh 'kubectl apply -f deployment.yaml'
                }
               // sh "kubectl apply -f deployment.yaml"
                //sh "nohup sudo -E kubectl port-forward svc/my 80:80 --address='0.0.0.0' &"
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
