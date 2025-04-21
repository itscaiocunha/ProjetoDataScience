import pandas as pd
import numpy as np
from faker import Faker
import mysql.connector
from datetime import datetime
import os

fake = Faker('pt_BR')

# Configurações das doenças (mantido igual)
doencas = {
    "HIV": {"freq": 0.14, "idade_media": 35, "idade_desvio": 7},
    "Sífilis": {"freq": 0.23, "idade_media": 30, "idade_desvio": 10},
    "Gonorreia": {"freq": 0.28, "idade_media": 28, "idade_desvio": 8},
    "HPV": {"freq": 0.28, "idade_media": 26, "idade_desvio": 6},
}

# Conexão com MySQL (VM2)
def conectar_mysql():
    return mysql.connector.connect(
        host="192.168.56.20",
        user="root",
        password="senha123",
        database="ist_data"
    )

# Criar tabela se não existir
def criar_tabela(conn):
    cursor = conn.cursor()
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS pacientes (
        id VARCHAR(36) PRIMARY KEY,
        nome VARCHAR(100),
        idade INT,
        doenca VARCHAR(50),
        cidade VARCHAR(50),
        educacao VARCHAR(20),
        data_teste DATE,
        data_insercao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)
    conn.commit()

# Inserir dados no MySQL
def inserir_dados(conn, dados):
    cursor = conn.cursor()
    sql = """
    INSERT INTO pacientes 
    (id, nome, idade, doenca, cidade, educacao, data_teste)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    """
    
    batch = []
    for linha in dados:
        batch.append((
            linha['id'],
            linha['nome'],
            linha['idade'],
            linha['doenca'],
            linha['cidade'],
            linha['educacao'],
            datetime.strptime(linha['data_teste'], '%Y-%m-%d').date()
        ))
        
        # Insere em lotes de 1000
        if len(batch) >= 1000:
            cursor.executemany(sql, batch)
            conn.commit()
            batch = []
    
    if batch:  # Insere o restante
        cursor.executemany(sql, batch)
        conn.commit()

# Fluxo principal
def main():
    # Geração dos dados (mantido igual)
    dados = []
    for _ in range(100000):
        doenca = escolher_doenca()
        dados.append({
            "id": fake.uuid4(),
            "nome": fake.name(),
            "idade": max(18, int(np.random.normal(
                doencas[doenca]["idade_media"], 
                doencas[doenca]["idade_desvio"]))),
            "doenca": doenca,
            "cidade": fake.city(),
            "educacao": fake.random_element(["Fundamental", "Médio", "Superior"]),
            "data_teste": fake.date_this_decade().isoformat()
        })
    
    # Conexão com o banco
    conn = conectar_mysql()
    criar_tabela(conn)
    
    try:
        inserir_dados(conn, dados)
        print(f"{len(dados)} registros inseridos no MySQL!")
        
        # Backup opcional em CSV
        output_path = os.path.join(os.path.dirname(__file__), "../../data/raw/dados_ist.csv")
        pd.DataFrame(dados).to_csv(output_path, index=False)
        print(f"Backup CSV gerado em: {output_path}")
        
    finally:
        conn.close()

if __name__ == "__main__":
    main()