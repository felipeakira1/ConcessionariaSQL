CREATE PROCEDURE inserirClientePessoaFisica
@codigo INT,
@endereco VARCHAR(255),
@telefone VARCHAR(15),
@email VARCHAR(100),
@cpf VARCHAR(14),
@nome VARCHAR(100),
@data_nascimento DATE
AS
BEGIN TRANSACTION
	INSERT INTO Pessoa (codigo_pessoa, endereco, telefone, email, tipo_pessoa)
	VALUES (@codigo, @endereco, @telefone, @email, 1);
	IF @@ROWCOUNT > 0
	BEGIN
		INSERT INTO PessoaFisica (codigo_pessoaFisica, cpf, nome, data_nascimento)
		VALUES (@codigo, @cpf, @nome, @data_nascimento);
		IF @@ROWCOUNT > 0
		BEGIN
			INSERT INTO Cliente (codigo_cliente, tipo_pessoa, codigo_pessoaFisica)
			VALUES (@codigo, 1, @codigo)
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

EXEC inserirClientePessoaFisica 1, "Rua Aviao, 123", "(14) 99999-9999", "felipe@gmail.com", "123.456.789-79", "Felipe Akira Nozaki", "2004-02-09";