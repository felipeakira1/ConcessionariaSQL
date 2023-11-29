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
INSERT INTO Modelo (codigo_modelo, nome, tipo_modelo, ano_lancamento, descricao, motorizacao, capacidade_passageiros, caracteristicas_especiais)
VALUES (@codigo_modelo, @nome, @tipo_modelo, @ano_lancamento, @descricao, @motorizacao, @capacidade_passageiros, @caracteristicas_especiais);


-- Alterar modelo
CREATE PROCEDURE alterarModelo
@codigo_modelo INT,
@nome VARCHAR(255),
@tipo_modelo VARCHAR(50),
@ano_lancamento INT,
@descricao TEXT,
@motorizacao VARCHAR(50),
@capacidade_passageiros INT,
@caracteristicas_especiais TEXT
AS
UPDATE Modelo
SET nome = @nome, tipo_modelo = @tipo_modelo, ano_lancamento = @ano_lancamento, descricao = @descricao, motorizacao = @motorizacao, capacidade_passageiros = @capacidade_passageiros, caracteristicas_especiais = @caracteristicas_especiais
WHERE codigo_modelo = @codigo_modelo;

-- Remover modelo
CREATE PROCEDURE removerModelo
@codigo_modelo INT
AS
BEGIN TRANSACTION
	DELETE FROM Carro
	WHERE codigo_modelo = @codigo_modelo;
	IF @@ROWCOUNT > 0
	BEGIN
		DELETE FROM Modelo
		WHERE codigo_modelo = @codigo_modelo;
		IF @@ROWCOUNT > 0
			COMMIT TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION;
	END
	ELSE
		ROLLBACK TRANSACTION;

EXECUTE inserirModelo 1, 'Honda Civic', 'Sedan', 2023, 'O Honda Civic é um sedan compacto que combina estilo moderno com eficiência de combustível.',  '1.5L Turbo', 5, 'Honda Sensing, Sistema de áudio premium, Conectividade Bluetooth';
EXECUTE inserirModelo 2, 'Honda Accord', 'Sedan', 2022, 'O Honda Accord é um sedan espaçoso e confortável, conhecido por sua dirigibilidade suave e interior refinado.', '2.0L Turbo', 5, 'Assistente de Faixa de Rodagem, Apple CarPlay, Android Auto';
EXECUTE inserirModelo 3, 'Honda Fit', 'Hatchback', 2021, 'O Honda Fit é um hatchback compacto com excelente espaço interno e versatilidade, ideal para a cidade.', '1.5L', 5, 'Sistema Magic Seat, Câmera de ré, Conectividade Bluetooth';
EXECUTE inserirModelo 4, 'Honda CR-V', 'SUV', 2023, 'O Honda CR-V é um SUV espaçoso e confortável, perfeito para famílias, com bom desempenho e eficiência energética.', '1.5L Turbo', 5, 'Sistema de navegação, Honda Sensing, Apple CarPlay e Android Auto';
EXECUTE inserirModelo 5, 'Honda HR-V', 'SUV Compacto', 2022, 'O Honda HR-V combina o estilo e a altura de um SUV com a agilidade de um hatchback.', '1.8L', 5, 'Magic Seat, Câmera de visão lateral, Conectividade Bluetooth';
EXECUTE inserirModelo 6, 'Honda Civic Type R', 'Hatchback Esportivo', 2023, 'O Civic Type R é um hatchback de alto desempenho, com um motor turbo e características de design esportivo.', '2.0L Turbo', 4, 'Modos de condução esportivos, Suspensão ajustável, Interior esportivo';
EXECUTE inserirModelo 7, 'Honda Insight', 'Sedan Híbrido', 2021, 'O Honda Insight é um sedan híbrido elegante, oferecendo excelente eficiência de combustível com um interior confortável.', '1.5L híbrido', 5, 'Honda Sensing, Apple CarPlay, Android Auto';
EXECUTE inserirModelo 8, 'Honda Odyssey', 'Minivan', 2022, 'A Honda Odyssey é uma minivan familiar com amplo espaço, versatilidade e muitos recursos de tecnologia.', '3.5L V6', 7, 'Magic Slide Seats, Sistema de entretenimento traseiro, HondaVAC';