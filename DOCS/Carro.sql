CREATE PROCEDURE inserirCarro
@codigo_carro INT,
@cor VARCHAR(50),
@preco DECIMAL(10,2),
@quantidade_estoque INT,
@codigo_modelo INT
AS
BEGIN TRANSACTION
	INSERT INTO Carro (codigo_carro, cor, preco, quantidade_estoque, codigo_modelo)
	VALUES (@codigo_carro, @cor, @preco, @quantidade_estoque, @codigo_modelo);
	IF @@ROWCOUNT > 0
		COMMIT TRANSACTION;
	ELSE
		ROLLBACK TRANSACTION;

CREATE PROCEDURE alterarCarro
@codigo_carro INT,
@cor VARCHAR(50),
@preco DECIMAL(10,2),
@quantidade_estoque INT
AS
UPDATE Carro
SET cor = @cor, preco = @preco, quantidade_estoque = @quantidade_estoque
WHERE codigo_carro = @codigo_carro;

CREATE PROCEDURE removerCarro
@codigo_carro INT,
AS
DELETE Carro
WHERE codigo_carro = @codigo_carro;

EXECUTE inserirCarro 1, 'Prata', 95000.00, 5, 1;
EXECUTE inserirCarro 2, 'Preto', 110000.00, 3, 2;
EXECUTE inserirCarro 3, 'Vermelho', 60000.00, 10, 3;
EXECUTE inserirCarro 4, 'Branco', 120000.00, 4, 4;
EXECUTE inserirCarro 5, 'Azul', 85000.00, 6, 5;
EXECUTE inserirCarro 6, 'Vermelho Rally', 150000.00, 2, 6;
EXECUTE inserirCarro 7, 'Cinza Metálico', 95000.00, 4, 7;
EXECUTE inserirCarro 8, 'Azul Obsidiana', 140000.00, 3, 8;