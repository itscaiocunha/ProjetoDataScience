knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(ggplot2)
library(dplyr)
library(tidyr)

# Limpeza e Tratamento de Dados de IST
caminho <- read.csv("/data/dados_ist_realistas.csv")
dados <- read.csv(caminho)

## 1. Padronização de Dados

# Padronizar colunas categóricas
dados <- dados %>%
  mutate(
    genero = toupper(trimws(genero)),
    doenca = toupper(trimws(doenca)),
    localidade = tools::toTitleCase(tolower(localidade))
  )

# Verificar valores únicos
list(
  genero = unique(dados$genero),
  doenca = unique(dados$doenca)
)

## 2. Tratamento de Valores Ausentes

# Identificar valores ausentes
colSums(is.na(dados))

# Opcional: Preencher valores ausentes (exemplo para idade)
dados <- dados %>%
  mutate(idade = ifelse(is.na(idade), median(idade, na.rm = TRUE), idade))

## 3. Tratamento de Outliers
identificar_outliers <- function(x) {
  q <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  iqr <- q[2] - q[1]
  which(x < (q[1] - 1.5*iqr) | x > (q[2] + 1.5*iqr))
}

# Outliers em idade
outliers_idade <- identificar_outliers(dados$idade)
dados$idade[outliers_idade] <- median(dados$idade, na.rm = TRUE)

# Visualização pós-tratamento
boxplot(dados$idade, main = "Idade (após tratamento de outliers)")


## 4. Transformação de Variáveis
# Converter datas
dados <- dados %>%
  mutate(
    data_teste = as.Date(data_teste),
    mes_teste = format(data_teste, "%Y-%m")
  )

# Criar variáveis derivadas
dados <- dados %>%
  mutate(
    faixa_etaria = cut(idade, 
                      breaks = c(0, 20, 30, 40, 50, 60, Inf),
                      labels = c("0-20", "21-30", "31-40", "41-50", "51-60", "60+"))
  )


## 5. Salvando Dados Processados
write.csv(dados, "/data/analise_resultado.csv", row.names = FALSE)

print("Análise concluída. Resultado salvo em /data/analise_resultado.csv")

