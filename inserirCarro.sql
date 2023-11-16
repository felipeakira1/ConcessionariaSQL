CREATE PROCEDURE inserirCarro
@codigo_carro INT,
@numero_chassi VARCHAR(17),
@cor VARCHAR(50),
@preco DECIMAL(10,2),
@quantidade_estoque INT,
@codigo_modelo INT
AS
INSERT INTO Carro (codigo_carro, numero_chassi, cor, preco, quantidade_estoque, codigo_modelo)
VALUES (@codigo_carro, @numero_chassi, @cor, @preco, @quantidade_estoque, @codigo_modelo);

EXEC inserirCarro 1, '1HGCM82633A123456', 'Preto', 259.900, 5, 1;