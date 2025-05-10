# ========================================
# Instalar e carregar pacotes necessários
# ========================================
pacotes_necessarios <- c("dplyr", "stringr")
instalar <- pacotes_necessarios[!(pacotes_necessarios %in% installed.packages()[,"Package"])]
if(length(instalar)) install.packages(instalar)

library(dplyr)
library(stringr)

# ========================================
# Espera ativa pelo arquivo
# ========================================
arquivo <- "/data/dados_ist_realistas.csv"
timeout <- 60  # segundos
inicio <- Sys.time()

while (!file.exists(arquivo)) {
  if (as.numeric(Sys.time() - inicio, units = "secs") > timeout) {
    stop("Tempo limite excedido: arquivo não encontrado.")
  }
  cat("Aguardando o arquivo", arquivo, "...\n")
  Sys.sleep(2)
}

# ========================================
# Carregamento dos dados
# ========================================
dados <- read.csv(arquivo, sep = ",", stringsAsFactors = TRUE)

# ========================================
# Análise inicial
# ========================================
cat("Visualização inicial dos dados:\n")
print(head(dados))
print(str(dados))
print(summary(dados))

# ========================================
# Verificação de valores ausentes
# ========================================
cat("\nValores ausentes por coluna:\n")
print(colSums(is.na(dados)))

# ========================================
# Tratamento de outliers - Renda Média
# ========================================
boxplot(dados$renda_media, main = "Boxplot - Renda Média", ylab = "R$", col = "lightblue", na.rm = TRUE)
out_renda <- boxplot.stats(dados$renda_media)$out
mediana_renda <- median(dados$renda_media, na.rm = TRUE)
dados$renda_media[dados$renda_media %in% out_renda] <- mediana_renda

# ========================================
# Tratamento de outliers - Idade
# ========================================
boxplot(dados$idade, main = "Boxplot - Idade", ylab = "Anos", col = "salmon", na.rm = TRUE)
out_idade <- boxplot.stats(dados$idade)$out
mediana_idade <- median(dados$idade, na.rm = TRUE)
dados$idade[dados$idade %in% out_idade] <- mediana_idade

# ========================================
# Normalização da variável Gênero
# ========================================
dados$genero <- tolower(dados$genero)
dados$genero <- case_when(
  dados$genero %in% c("m", "masculino", "homem") ~ "Masculino",
  dados$genero %in% c("f", "feminino", "mulher") ~ "Feminino",
  is.na(dados$genero) | dados$genero %in% c("", "não informado") ~ "Não informado",
  TRUE ~ dados$genero
)
cat("\nDistribuição de Gênero:\n")
print(table(dados$genero))

# ========================================
# Normalização da variável Doença
# ========================================
dados$doenca <- tolower(dados$doenca)
dados$doenca <- case_when(
  dados$doenca %in% c("", "na", "n/a", "nenhuma") ~ "Nenhuma",
  str_detect(dados$doenca, "hiv") ~ "HIV",
  str_detect(dados$doenca, "s[ií]filis") ~ "Sífilis",
  str_detect(dados$doenca, "hpv") ~ "HPV",
  str_detect(dados$doenca, "gonorreia") ~ "Gonorreia",
  str_detect(dados$doenca, "c[aâ]ncer") ~ "Câncer",
  str_detect(dados$doenca, "diabetes") ~ "Diabetes",
  str_detect(dados$doenca, "asma") ~ "Asma",
  str_detect(dados$doenca, "gripe") ~ "Gripe",
  str_detect(dados$doenca, "avc") ~ "AVC",
  TRUE ~ dados$doenca
)
cat("\nDistribuição de Doenças:\n")
print(table(dados$doenca))

# ========================================
# Normalização da variável Nível Educacional
# ========================================
dados$nivel_educacional <- tolower(dados$nivel_educacional)
dados$nivel_educacional <- case_when(
  str_detect(dados$nivel_educacional, "fundamnetal") ~ "Fundamental",
  str_detect(dados$nivel_educacional, "medio") ~ "Médio",
  str_detect(dados$nivel_educacional, "superio") ~ "Superior",
  is.na(dados$nivel_educacional) | dados$nivel_educacional == "" ~ "Não informado",
  TRUE ~ str_to_title(dados$nivel_educacional)
)
cat("\nDistribuição do Nível Educacional:\n")
print(table(dados$nivel_educacional))

# ========================================
# Conversão e limpeza de datas
# ========================================
dados$data_teste <- as.Date(dados$data_teste)
dados <- dados[dados$data_teste <= Sys.Date(), ]

# ========================================
# Verificação final dos dados tratados
# ========================================
cat("\nValores ausentes após tratamento:\n")
print(colSums(is.na(dados)))

cat("\nEstrutura dos dados tratados:\n")
print(str(dados))

cat("\nResumo estatístico dos dados tratados:\n")
print(summary(dados))

# ========================================
# Salvamento dos dados tratados
# ========================================
write.csv(dados, "/data/dados_ist_tratados.csv", row.names = FALSE)
cat("\nDados tratados com sucesso! Arquivo salvo como 'dados_ist_tratados.csv'\n")

# Exibir primeiras linhas dos dados tratados
cat("\nPrimeiras linhas dos dados tratados:\n")
print(head(dados))
