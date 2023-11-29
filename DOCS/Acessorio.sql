CREATE PROCEDURE inserirAcessorio
@codigo_acessorio INT,
@nome VARCHAR(100),
@descricao VARCHAR(255),
@preco DECIMAL(10,2),
@categoria VARCHAR(50),
@quantidade_estoque INT,
@codigo_fornecedor INT
AS
BEGIN TRANSACTION
	INSERT Acessorio (codigo_acessorio, nome, descricao, preco, categoria, quantidade_estoque, codigo_fornecedor)
	VALUES (@codigo_acessorio, @nome, @descricao, @preco, @categoria, @quantidade_estoque, @codigo_fornecedor);
	IF @@ROWCOUNT > 0
		COMMIT TRANSACTION;
	ELSE
		ROLLBACK TRANSACTION;

EXEC inserirAcessorio 1, 'Tapetes de Borracha', 'Tapetes de borracha duráveis para proteger o interior do carro.', 29.99, 'Interior', 100, 3;
EXEC inserirAcessorio 2, 'Alarme Automotivo', 'Alarme de alta segurança com sensor de movimento.', 150.00, 'Segurança', 50, 3;
EXEC inserirAcessorio 3, 'Capas de Assento', 'Capas de assento confortáveis e elegantes em couro sintético.', 200.00, 'Interior', 75, 3;
EXEC inserirAcessorio 4, 'GPS Navigator', 'Sistema de navegação GPS com mapas atualizados e tela touchscreen.', 300.00, 'Eletrônicos', 30, 3;


-- Alterar preço acessório
CREATE PROCEDURE alterarPrecoAcessorio
@codigo INT,
@preco DECIMAL(10,2)
AS
UPDATE Acessorio
SET preco = @preco
WHERE codigo_acessorio = @codigo;

-- Alterar quantidade acessório
CREATE PROCEDURE alterarQuantidadeAcessorio
@codigo INT,
@quantidade_estoque INT
AS
UPDATE Acessorio
SET quantidade_estoque = @quantidade_estoque
WHERE codigo_acessorio = @codigo;

-- Alterar acessório
CREATE PROCEDURE alterarAcessorio
@codigo_acessorio INT,
@novo_nome VARCHAR(100),
@nova_descricao VARCHAR(255),
@novo_preco DECIMAL(10,2),
@nova_categoria VARCHAR(50),
@nova_quantidade_estoque INT
AS
BEGIN
UPDATE Acessorio
SET nome = @novo_nome,
	descricao = @nova_descricao,
	preco = @novo_preco,
    categoria = @nova_categoria,
    quantidade_estoque = @nova_quantidade_estoque
WHERE codigo_acessorio = @codigo_acessorio;
END

CREATE PROCEDURE removerAcessorio
@codigo_acessorio INT
AS
DELETE FROM Acessorio
WHERE codigo_acessorio = @codigo_acessorio;