CREATE PROCEDURE inserirFuncionario
@codigo INT,
@endereco VARCHAR(255),
@telefone VARCHAR(15),
@email VARCHAR(100),
@cpf VARCHAR(14),
@nome VARCHAR(100),
@data_nascimento DATE,
@salario DECIMAL(10,2)
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
			INSERT INTO Funcionario(codigo_funcionario, salario)
			VALUES (@codigo, @salario);
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

EXECUTE inserirFuncionario 3, 'Rua das Palmeiras, 456', '(55) 9876-5432', 'funcionario@gmail.com', '123.123.123-01', 'Joao da Silva', '2004-02-02', 3500.00;