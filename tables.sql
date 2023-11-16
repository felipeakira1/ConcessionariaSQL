create database Concessionaria;
use Concessionaria;

CREATE TABLE Pessoa (
    codigo_pessoa INT PRIMARY KEY,
    endereco VARCHAR(255),
    telefone VARCHAR(15),
    email VARCHAR(100),
    tipo_pessoa INT
);

CREATE TABLE PessoaFisica (
    codigo_pessoaFisica INT PRIMARY KEY,
    cpf VARCHAR(14),
    nome VARCHAR(100),
    data_nascimento DATE,
    FOREIGN KEY (codigo_pessoaFisica) REFERENCES Pessoa(codigo_pessoa)
);

CREATE TABLE PessoaJuridica (
    codigo_pessoaJuridica INT PRIMARY KEY,
    cnpj VARCHAR(18),
    razao_social VARCHAR(100),
    nome_fantasia VARCHAR(100),
    data_fundacao DATE,
    inscricao_estadual VARCHAR(20),
    FOREIGN KEY (codigo_pessoaJuridica) REFERENCES Pessoa(codigo_pessoa)
);

CREATE TABLE Funcionario (
    codigo_funcionario INT PRIMARY KEY,
    salario DECIMAL(10, 2),
    FOREIGN KEY (codigo_funcionario) REFERENCES PessoaFisica(codigo_pessoaFisica)
);

-- Nao criei ainda
CREATE TABLE Cliente (
    codigo_cliente INT PRIMARY KEY,
    tipo_pessoa VARCHAR(20), 
    codigo_pessoaFisica INT,
    codigo_pessoaJuridica INT,
    FOREIGN KEY (codigo_pessoaFisica) REFERENCES PessoaFisica(codigo_pessoaFisica),
    FOREIGN KEY (codigo_pessoaJuridica) REFERENCES PessoaJuridica(codigo_pessoaJuridica)
);

CREATE TABLE Modelo (
    codigo_modelo INT PRIMARY KEY,
    nome VARCHAR(255),
    tipo_modelo VARCHAR(50),
    ano_lancamento INT,
    descricao TEXT,
    motorizacao VARCHAR(50),
    capacidade_passageiros INT,
    caracteristicas_especiais TEXT
);

CREATE TABLE Revisao (
    codigo_revisao INT PRIMARY KEY,
    data_entrada DATE,
    hora_entrada TIME,
    data_saida DATE,
    hora_saida TIME,
    observacoes TEXT,
    resultados TEXT
);

CREATE TABLE Carro (
    codigo_carro INT PRIMARY KEY,
    numero_chassi VARCHAR(17) NOT NULL UNIQUE,
    cor VARCHAR(50),
    preco DECIMAL(10, 2),
    quantidade_estoque INT,
    codigo_modelo INT,
    codigo_revisao INT,
    FOREIGN KEY (codigo_modelo) REFERENCES Modelo(codigo_modelo),
    FOREIGN KEY (codigo_revisao) REFERENCES Revisao(codigo_revisao)
);

CREATE TABLE Nota_Fiscal (
    codigo_notaFiscal INT PRIMARY KEY,
    data DATE,
    hora TIME,
    valor_total DECIMAL(10, 2),
    metodo_pagamento VARCHAR(50),
    desconto DECIMAL(10, 2),
    parcelas INT,
    juros DECIMAL(5, 2),
    codigo_funcionario INT,
    codigo_cliente INT,
    codigo_carro INT,
    FOREIGN KEY (codigo_funcionario) REFERENCES Funcionario(codigo_funcionario),
    FOREIGN KEY (codigo_cliente) REFERENCES Cliente(codigo_cliente),
    FOREIGN KEY (codigo_carro) REFERENCES Carro(codigo_carro)
);

CREATE TABLE Fornecedor(
	codigo_fornecedor INT PRIMARY KEY,
    FOREIGN KEY (codigo_fornecedor) REFERENCES PessoaJuridica(codigo_pessoaJuridica)
);

CREATE TABLE Acessorio (
    codigo_acessorio INT PRIMARY KEY,
    nome VARCHAR(100),
    descricao VARCHAR(255),
    preco DECIMAL(10, 2),
    categoria VARCHAR(50),
    compatibilidade VARCHAR(255),
    quantidade_estoque INT,
    codigo_fornecedor INT,
    FOREIGN KEY (codigo_fornecedor) REFERENCES Fornecedor(codigo_fornecedor)
);

CREATE TABLE Pedido (
    codigo_pedido INT PRIMARY KEY,
    data DATE,
    hora TIME,
    valor_total DECIMAL(10, 2),
    status VARCHAR(50),
    metodo_pagamento VARCHAR(50),
    desconto DECIMAL(10, 2),
    parcelas INT,
    juros DECIMAL(5, 2),
    codigo_cliente INT,
    FOREIGN KEY (codigo_cliente) REFERENCES Cliente(codigo_cliente)
);

CREATE TABLE ItemPedido (
    codigo_pedido INT,
    codigo_acessorio INT,
    quantidade_pedido INT,
    PRIMARY KEY (codigo_pedido, codigo_acessorio),
    FOREIGN KEY (codigo_pedido) REFERENCES Pedido(codigo_pedido),
    FOREIGN KEY (codigo_acessorio) REFERENCES Acessorio(codigo_acessorio)
);