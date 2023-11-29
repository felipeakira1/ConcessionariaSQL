CREATE PROCEDURE inserirClientePessoaJuridica
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
			INSERT INTO Cliente (codigo_cliente, tipo_pessoa, codigo_pessoaJuridica)
			VALUES (@codigo, 2, @codigo)
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

EXECUTE inserirClientePessoaJuridica 2, 'Rua das Flores, 123', '(99) 8765-4321', 'contato@empresaexemplo.com', '12.345.678/0001-90', 'Empresa Exemplo Ltda', 'Exemplo Emrpesarial', '2023-01-01', '123.456.789.012';

-- Alterar cliente pessoa juridica
CREATE PROCEDURE alterarClientePessoaJuridica
@codigo INT,
@endereco VARCHAR(255),
@telefone VARCHAR(15),
@email VARCHAR(100),
@razao_social VARCHAR(100),
@nome_fantasia VARCHAR(100)
AS
BEGIN TRANSACTION
	UPDATE Pessoa
	SET endereco = @endereco, telefone = @telefone, email = @email
	WHERE codigo_pessoa = @codigo;
	IF @@ROWCOUNT > 0
	BEGIN
		update PessoaJuridica
		SET razao_social = @razao_social, nome_fantasia = @nome_fantasia;
		IF @@ROWCOUNT > 0
			COMMIT TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION;
	END
	ELSE
		ROLLBACK TRANSACTION;

-- Remover cliente pessoa juridica
CREATE PROCEDURE removerClientePessoaJuridica
@codigo INT
AS
BEGIN TRANSACTION
	DELETE FROM Cliente
	WHERE codigo_cliente = @codigo;
	IF @@ROWCOUNT > 0
	BEGIN
		DELETE FROM PessoaJuridica
		WHERE codigo_pessoaJuridIca = @codigo;
		IF @@ROWCOUNT > 0
		BEGIN
			DELETE FROM Pessoa
			WHERE codigo_pessoa = @codigo;
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