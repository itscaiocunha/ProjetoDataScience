pipeline {
    agent any

    stages {
        stage('Gerar Dados') {
            steps {
                sh 'docker compose run --rm gerador-dados'
            }
        }
        stage('Análise em R') {
            steps {
                sh 'docker compose run --rm analise-r'
            }
        }
    }

    post {
        always {
            sh 'docker compose down'
        }
    }
}
