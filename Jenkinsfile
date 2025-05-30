pipeline {
    agent any

    triggers {
        cron('H/5 * * * *') // Executa a cada 5 minutos
    }

    stages {
        stage('Subir ambiente') {
            steps {
                echo 'Subindo todos os serviços com docker-compose up...'
                sh 'docker compose up -d --build'
            }
        }

        stage('Esperar Serviços') {
            steps {
                echo 'Aguardando serviços estabilizarem...'
                // Dá tempo para PostgreSQL, Spark, R etc. inicializarem
                sleep time: 30, unit: 'SECONDS'
            }
        }

        stage('Gerar Dados') {
            steps {
                echo 'Executando gerador-dados...'
                sh 'docker compose run --rm gerador-dados'
            }
        }

        stage('Análise em R') {
            steps {
                echo 'Executando analise-dados (R)...'
                sh 'docker compose run --rm analise-dados'
            }
        }

        stage('Executar Big Data') {
            steps {
                echo 'Executando bigdata (PySpark)...'
                sh 'docker compose run --rm bigdata'
            }
        }
    }

    post {
        always {
            echo 'Encerrando containers e limpando...'
            sh 'docker compose down -v'
        }
    }
}
