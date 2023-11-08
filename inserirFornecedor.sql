CREATE PROCEDURE inserirFornecedor
@codigo INT,
@endereco VARCHAR(255),
@telefone VARCHAR(15),
@email VARCHAR(100),
@cnpj VARCHAR(18),
@razao_social VARCHAR(100),
@nome_fantasia VARCHAR(100),
@data_fundacao DATE,
@inscricao_estadual VARCHAR(20)
AS
BEGIN TRANSACTION
	INSERT INTO Pessoa (codigo_pessoa, endereco, telefone, email, tipo_pessoa)
	VALUES (@codigo, @endereco, @telefone, @email, 2);
	IF @@ROWCOUNT > 0
	BEGIN
		INSERT INTO PessoaJuridica(codigo_pessoaJuridica, cnpj, razao_social, nome_fantasia, data_fundacao, inscricao_estadual)
		VALUES (@codigo, @cnpj, @razao_social, @nome_fantasia, @data_fundacao, @inscricao_estadual);
		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO Fornecedor (codigo_fornecedor)
			VALUES (@codigo);
			IF @@ROWCOUNT > 0
				COMMIT TRANSACTION;
			ELSE
				ROLLBACK TRANSACTION;
		END
		ELSE
			ROLLBACK TRANSACTION;
	END
	ELSE
		ROLLBACK TRANSACTION;

EXEC inserirFornecedor 1, '123 Rua do Comércio', '(99) 1234-5678', 'contato@exemplo.com', '12.345.678/0001-90', 'Exemplo Fornecedor', 'Exemplo Fantasia', '2023-01-01', '123.456.789.012';