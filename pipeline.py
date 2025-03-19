import numpy as np
import pandas as pd
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (accuracy_score, precision_score, recall_score, f1_score, confusion_matrix)
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.compose import ColumnTransformer
import matplotlib.pyplot as plt

from google.colab import drive
drive.mount('/content/drive')

df = pd.read_csv('/content/drive/MyDrive/dados_ist.csv')

# Pré-processamento dos Dados
# Separando features e target
X = df.drop('ist', axis=1)
y = df['ist']

# Identificando colunas numéricas e categóricas
numeric_features = X.select_dtypes(include=['int64', 'float64']).columns
categorical_features = X.select_dtypes(include=['object', 'category']).columns

# Criando transformers para pré-processamento
numeric_transformer = Pipeline(steps=[
   ('imputer', SimpleImputer(strategy='median')),  # Imputação de valores faltantes
   ('scaler', StandardScaler())  # Escalonamento
])

categorical_transformer = Pipeline(steps=[
   ('imputer', SimpleImputer(strategy='constant', fill_value='missing')),  # Imputação de valores faltantes
   ('onehot', OneHotEncoder(handle_unknown='ignore'))  # Codificação one-hot
])

# Combinando transformers em um ColumnTransformer
preprocessor = ColumnTransformer(
   transformers=[
       ('num', numeric_transformer, numeric_features),
       ('cat', categorical_transformer, categorical_features)
   ])

# Divisão dos Dados em Treino e Teste
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Seleção do Modelo
model = RandomForestClassifier(n_estimators=100, random_state=42)

# Criando a Pipeline completa
pipeline = Pipeline(steps=[
   ('preprocessor', preprocessor),
   ('classifier', model)
])

#Treinamento do Modelo
pipeline.fit(X_train, y_train)

# Avaliação do Modelo
y_pred = pipeline.predict(X_test)
y_pred_proba = pipeline.predict_proba(X_test)[:, 1]  # Probabilidades para a classe positiva

# Métricas de Classificação
print(f'Acurácia: {accuracy_score(y_test, y_pred)}')
print(f'Precisão: {precision_score(y_test, y_pred, average="macro")}')
print(f'Recall: {recall_score(y_test, y_pred, average="macro")}')
print(f'F1-Score: {f1_score(y_test, y_pred, average="macro")}')

# Matriz de confusão
cm = confusion_matrix(y_test, y_pred)
classes = ['Classe 0', 'Classe 1', 'Classe 2']

# Plotando a matriz de confusão
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', xticklabels=classes, yticklabels=classes)
plt.title('Matriz de Confusão')
plt.xlabel('Previsão')
plt.ylabel('Verdadeiro')
plt.show()