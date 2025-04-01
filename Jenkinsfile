pipeline {
    agent any

    tools {
        jdk 'jdk-21'
        gradle 'gradle-8'
    }

    stages {
        stage('Checkout') {
            steps {
                // Git에서 지정된 브랜치를 체크아웃하여 코드 가져오기
                git branch: 'master', url: 'https://github.com/soulgrid/serviceDiscovery'
            }
        }

        stage('Backend Build') {
            steps {
                // Gradle을 사용하여 클린 빌드
                sh 'gradle clean build'
            }
        }

        stage('Docker Build and Deploy Backend') {
            environment {
                IMAGE_NAME = 'serviceDiscovery'
                CONTAINER_NAME = 'serviceDiscovery'
            }
            steps {
                // 이전에 실행 중인 컨테이너 중지 및 삭제 (오류가 나더라도 무시)
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"

                script {
                    // Docker 이미지를 빌드하고, 결과 상태 코드 확인
                    def buildOutput = sh(script: "docker build -t ${IMAGE_NAME} ./Backend/jes", returnStatus: true)
                    if (buildOutput == 0) {
                        // 빌드가 성공한 경우에만 <none> 태그를 가진 이미지 삭제
                        sh "docker images | grep '<none>' | awk '{print \$3}' | xargs -r docker rmi || true"
                    } else {
                        // 빌드 실패시 오류 메시지 출력
                        error "Docker build failed!"
                    }
                }
                // 새로운 Docker 컨테이너 실행
                sh "docker run -d -p 50000:50000 --name ${CONTAINER_NAME} ${IMAGE_NAME}"
            }
        }

    }
}
