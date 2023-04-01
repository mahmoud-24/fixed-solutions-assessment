pipeline {
    agent any

    stages {

        stage('CI'){
            steps {

                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])            {

                sh """
                    cd backend-app
                    docker build . -t mmelegy/python-app:v$BUILD_NUMBER
                    docker login -u ${USERNAME} -p ${PASSWORD}
                    docker push mmelegy/python-app:v$BUILD_NUMBER
                    cd ..
                """
                }
              }
        }

        stage('CD'){
            steps {

                withCredentials([file(credentialsId: 'srv-access', variable: 'config')]){
                    sh """
                       
                        sed -i 's/tag/${BUILD_NUMBER}/g' deployment/deployment.yaml
                        kubectl apply -Rf deployment
                    """
                }
            }
 
        }
    }
}
