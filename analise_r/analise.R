```{r}
dados = read.csv("dados_ist_realistas.csv", sep = ',', stringsAsFactors = TRUE)
head(dados)
str(dados)
str(dados)
summary(dados)

```

```{r}
# verificar valores ausentes
colSums(is.na(dados))

# substituir outliers em renda_media por mediana
mediana_renda = median(dados$renda_media, na.rm = TRUE)
mediana_renda
dados$renda_media[dados$renda_media %in% out_renda] = mediana_renda

# substituir outliers em idade por mediana
mediana_idade = median(dados$idade, na.rm = TRUE)
mediana_idade
dados$idade[dados$idade %in% out_idade] = mediana_idade

# converter datas
dados$data_teste = as.Date(dados$data_teste)

str(dados)
```

```{r}
# Tratamento de gênero
dados$genero = tolower(dados$genero)
dados$genero = case_when(
  dados$genero %in% c("m", "masculino", "homem") ~ "Masculino",
  dados$genero %in% c("f", "feminino", "mulher") ~ "Feminino",
  is.na(dados$genero) | dados$genero %in% c("", "não informado") ~ "Não informado",
  TRUE ~ dados$genero
)

# Verificar gênero
table(dados$genero)
```

```{r}
# Tratamento de doenças
dados$doenca = tolower(dados$doenca)
dados$doenca = case_when(
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

# Verificar doenças
table(dados$doenca)
```

```{r}
# Tratamento de nível educacional
dados$nivel_educacional = tolower(dados$nivel_educacional)
dados$nivel_educacional = case_when(
  str_detect(dados$nivel_educacional, "fundamnetal") ~ "Fundamental",
  str_detect(dados$nivel_educacional, "medio") ~ "Médio",
  str_detect(dados$nivel_educacional, "superio") ~ "Superior",
  is.na(dados$nivel_educacional) | dados$nivel_educacional == "" ~ "Não informado",
  TRUE ~ str_to_title(dados$nivel_educacional)
)

# Verificar educação
table(dados$nivel_educacional)
```

```{r}
# Tratamento de datas
dados$data_teste = as.Date(dados$data_teste)
dados = dados[dados$data_teste <= Sys.Date(), ]  # Remove datas futuras
```

```{r}
# Análise de outliers - Renda
boxplot(dados$renda_media,
        main="Boxplot - Renda Média",
        ylab = "R$",
        col="lightblue", na.rm = TRUE)

out_renda = boxplot.stats(dados$renda_media)$out
mediana_renda = median(dados$renda_media, na.rm = TRUE)
dados$renda_media[dados$renda_media %in% out_renda] = mediana_renda
```

```{r}
# Análise de outliers - Idade
boxplot(dados$idade,
        main="Boxplot - Idade",
        ylab = "Anos",
        col="salmon", na.rm = TRUE)

out_idade = boxplot.stats(dados$idade)$out
mediana_idade = median(dados$idade, na.rm = TRUE)
dados$idade[dados$idade %in% out_idade] = mediana_idade
```

```{r}
# Verificar valores ausentes
colSums(is.na(dados))

# Verificar estrutura final
str(dados)
summary(dados)

# Salvar dados tratados
write.csv(dados, "dados_ist_tratados.csv", row.names = FALSE)
cat("Dados tratados com sucesso! Arquivo salvo como 'dados_ist_tratados.csv'")
```

```{r}
head(dados_tratados)
```