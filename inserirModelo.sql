CREATE PROCEDURE inserirModelo
@codigo_modelo INT,
@nome VARCHAR(255),
@tipo_modelo VARCHAR(50),
@ano_lancamento INT,
@descricao TEXT,
@motorizacao VARCHAR(50),
@capacidade_passageiros INT,
@caracteristicas_especiais TEXT
AS
BEGIN
	INSERT INTO Modelo (codigo_modelo, nome, tipo_modelo, ano_lancamento, descricao, motorizacao, capacidade_passageiros, caracteristicas_especiais)
	VALUES (@codigo_modelo, @nome, @tipo_modelo, @ano_lancamento, @descricao, @motorizacao, @capacidade_passageiros, @caracteristicas_especiais);
END

EXECUTE inserirModelo 1, 'Honda Civic', 'Sedan', 2023, 'O Honda Civic é um sedan compacto que combina estilo moderno com eficiência de combustível.',  '1.5L Turbo', 5, 'Honda Sensing, Sistema de áudio premium, Conectividade Bluetooth';