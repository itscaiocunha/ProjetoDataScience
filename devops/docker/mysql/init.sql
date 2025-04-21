CREATE DATABASE IF NOT EXISTS ist_data;

USE ist_data;

CREATE TABLE IF NOT EXISTS pacientes (
    id VARCHAR(36) PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    doenca VARCHAR(50),
    cidade VARCHAR(50),
    educacao VARCHAR(20),
    data_teste DATE,
    data_insercao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);