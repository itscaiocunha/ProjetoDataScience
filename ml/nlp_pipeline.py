import pandas as pd
import nltk
import re
from nltk.corpus import stopwords
from nltk.stem import RSLPStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.pipeline import Pipeline
import os

# Baixar recursos necessários do NLTK
nltk.download('stopwords')
nltk.download('rslp')
stopwords = stopwords.words('portuguese')
stemmer = RSLPStemmer()

# Função de pré-processamento
def preprocess_text(text):
    text = re.sub(r'[^a-zA-Záéíóúãõâêîôûç]', ' ', str(text))  # Garante que text seja string
    text = text.lower()
    text = ' '.join([word for word in text.split() if word not in stopwords])
    text = ' '.join([stemmer.stem(word) for word in text.split()])
    return text

# Carregar os dados do arquivo CSV
data_path = os.path.join(os.path.dirname(__file__), "../../data/raw/dados_ist.csv")
df = pd.read_csv(data_path)

# Verifica o nome das colunas e mostra uma prévia
print("Colunas disponíveis:", df.columns)
print(df.head())

# Ajuste aqui conforme os nomes reais das colunas do CSV
texto_coluna = 'doenca'  # ou o nome correto da coluna de texto
rotulo_coluna = 'ist'     # ou o nome correto da coluna de rótulo

# Pré-processar os textos
df[texto_coluna] = df[texto_coluna].apply(preprocess_text)

# Dividir os dados
X_train, X_test, y_train, y_test = train_test_split(
    df[texto_coluna], df[rotulo_coluna], test_size=0.2, random_state=42, stratify=df[rotulo_coluna])

    # Pipeline de classificação
pipeline = Pipeline([
    ('tfidf', TfidfVectorizer()),
    ('clf', RandomForestClassifier(n_estimators=100, random_state=42))
])

# Treinar modelo
pipeline.fit(X_train, y_train)

# Avaliação
y_pred = pipeline.predict(X_test)
print('Acurácia:', accuracy_score(y_test, y_pred))
print('Relatório de Classificação:\n', classification_report(y_test, y_pred, zero_division=1))

# Teste com novos comentários
novos_comentarios = ["Nenhum", "HPV"]
novos_comentarios = [preprocess_text(c) for c in novos_comentarios]
print("Previsões para novos comentários:", pipeline.predict(novos_comentarios))
