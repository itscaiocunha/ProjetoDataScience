# Título: Tratamento de Dados

# Carregando pacotes necessários
library(ggplot2)
library(dplyr)

# --- Importação de Dados ---
dados <- read.csv("/data/dados_ist_realistas.csv", sep = ",", stringsAsFactors = TRUE)

# --- Análise Inicial ---
print(head(dados))
print(summary(dados))
str(dados)

# --- Análises Boxplot ---

# Idade dos Pacientes
print(summary(dados$idade))
boxplot(dados$idade, main="Boxplot - Idade dos Pacientes",
        ylab = "Idades (em Anos)", col="lightblue")
hist(dados$idade)

out_idade <- boxplot.stats(dados$idade)$out
print(out_idade)  # Não existe discrepância nas Idades

# Renda Média dos Pacientes
print(summary(dados$renda_media))
boxplot(dados$renda_media, main="Boxplot - Renda Média dos Pacientes",
        ylab = "Valor em Reais (R$)", col="red", outline = FALSE)

out_renda <- boxplot.stats(dados$renda_media)$out
print(length(out_renda))
print(out_renda)
print(dados[dados$renda_media %in% out_renda, ])

# --- Tratamento dos Dados Numéricos ---

# Verificando valores ausentes
print(colSums(is.na(dados)))

# Imputação da mediana na renda
mediana_renda <- median(dados$renda_media, na.rm = TRUE)
print(mediana_renda)
dados$renda_media[is.na(dados$renda_media)] <- mediana_renda

# Conversão de data
dados$data_teste <- as.Date(dados$data_teste)
str(dados)

# --- Tratamento dos Dados Categóricos ---

# Gênero
print(summary(dados$genero))

dados$genero[dados$genero %in% c("f", "F", "feminino")] <- "Feminino"
dados$genero[dados$genero %in% c("m", "M", "masculino")] <- "Masculino"
dados$genero[dados$genero %in% c("Não informado", "")] <- "Masculino"
dados$genero <- factor(dados$genero)

countsGenero <- table(dados$genero)
print(countsGenero)
barplot(countsGenero, main="Gênero", xlab="Gênero")

# Doença
countsDoenca <- table(dados$doenca)
print(countsDoenca)
barplot(countsDoenca, main="Doenças", xlab="Doenças")

# Localidade
dados$localidade[dados$localidade == ""] <- "Não Informado"

# Nível Educacional
print(summary(dados$nivel_educacional))

dados$nivel_educacional[dados$nivel_educacional %in% c("fundamnetal", "medio incompleto")] <- "Fundamental"
dados$nivel_educacional[dados$nivel_educacional == "superio"] <- "Superior"
dados$nivel_educacional[dados$nivel_educacional == ""] <- "Fundamental"
dados$nivel_educacional <- factor(dados$nivel_educacional)

countsEducacao <- table(dados$nivel_educacional)
print(countsEducacao)
barplot(countsEducacao, main="Educação", xlab="Nível de Estudo")

# --- Exportação dos Dados Tratados ---
write.csv(dados, "/data/dados_ist_tratados.csv", row.names = FALSE)
