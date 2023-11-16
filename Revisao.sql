CREATE PROCEDURE iniciarRevisao
@codigo_revisao INT,
@codigo_carro INT,
@data_entrada DATE,
@hora_entrada TIME
AS
BEGIN TRANSACTION
	INSERT INTO Revisao (codigo_revisao, data_entrada, hora_entrada)
	VALUES (@codigo_revisao, @data_entrada, @hora_entrada);
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE Carro
		SET codigo_revisao = @codigo_revisao
		WHERE codigo_carro = @codigo_carro;
		IF @@ROWCOUNT > 0
			COMMIT TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION;
	END
	ELSE
		ROLLBACK TRANSACTION;

EXEC iniciarRevisao 1, 1, '2023-11-15', '22:47:00';


CREATE PROCEDURE finalizarRevisao
@codigo_revisao INT,
@data_saida DATE,
@hora_saida TIME,
@observacoes TEXT,
@resultados TEXT
AS
UPDATE Revisao
SET data_saida = @data_saida, hora_saida = @hora_saida, observacoes = @observacoes, resultados = @resultados
WHERE codigo_revisao = @codigo_revisao;