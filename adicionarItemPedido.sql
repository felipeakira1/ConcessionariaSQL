CREATE PROCEDURE adicionarItemPedido
@codigo_pedido INT,
@codigo_acessorio INT,
@quantidade_pedido INT
AS
BEGIN TRANSACTION
	INSERT INTO ItemPedido (codigo_pedido, codigo_acessorio, quantidade_pedido)
	VALUES (@codigo_pedido, @codigo_acessorio, @quantidade_pedido);
	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE Pedido
		SET valor_total = (SELECT SUM(IP.quantidade_pedido * A.preco)
							FROM ItemPedido IP
							JOIN Acessorio A
							ON IP.codigo_acessorio = A.codigo_acessorio
							WHERE IP.codigo_pedido = @codigo_pedido)
		WHERE codigo_pedido = @codigo_pedido;
		IF @@ROWCOUNT > 0
			COMMIT TRANSACTION;
		ELSE
			ROLLBACK TRANSACTION;
	END
	ELSE
		ROLLBACK TRANSACTION;