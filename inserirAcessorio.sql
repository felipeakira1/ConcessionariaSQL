CREATE PROCEDURE inserirAcessorio
@codigo_acessorio INT,
@nome VARCHAR(100),
@descricao VARCHAR(255),
@preco DECIMAL(10,2),
@categoria VARCHAR(50),
@compatibilidade VARCHAR(255),
@quantidade_estoque INT,
@codigo_fornecedor INT
AS
BEGIN TRANSACTION
	INSERT Acessorio (codigo_acessorio, nome, descricao, preco, categoria, compatibilidade, quantidade_estoque, codigo_fornecedor)
	VALUES (@codigo_acessorio, @nome, @descricao, @preco, @categoria, @compatibilidade, @quantidade_estoque, @codigo_fornecedor);
	IF @@ROWCOUNT > 0
		COMMIT TRANSACTION;
	ELSE
		ROLLBACK TRANSACTION;


EXEC inserirAcessorio 1, 'Tapetes de Borracha', 'Tapetes de borracha duráveis para proteger o interior do carro.', 29.99, 'Interior', '1, 3, 5', 100, 1;