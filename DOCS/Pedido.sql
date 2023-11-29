-- iniciar Pedido (FINALIZADO)
CREATE PROCEDURE iniciarPedido
@codigo_pedido INT,
@codigo_cliente INT
AS
DECLARE @status VARCHAR(50);
SET @status = 'Vazio';
INSERT INTO Pedido(codigo_pedido, status, codigo_cliente)
VALUES (@codigo_pedido, @status, @codigo_cliente);

-- adicionar Item ao Pedido (FINALIZADO)
-- Se status de pedido = 'Vazio', mudar status para 'Pendente'
-- Verificar se o estoque possui a quantidade de acessorios solicitada
-- Inserir acessorio e quantidade na tabela ItemPedido
-- Gatilhos: Alterar a quantidade de acessorios na tabela Acessorios
-- Gatilhos: Alterar o valor total de pedido

CREATE PROCEDURE adicionarItemPedido
@codigo_pedido INT,
@codigo_acessorio INT,
@quantidade_solicitada INT
AS
BEGIN TRANSACTION
    SET NOCOUNT ON;

    -- Verificar o status atual do pedido
    DECLARE @status_pedido VARCHAR(50);

    SELECT @status_pedido = status
    FROM Pedido
    WHERE codigo_pedido = @codigo_pedido;

    IF @status_pedido = 'Vazio'
    BEGIN
        UPDATE Pedido
        SET status = 'Pendente'
        WHERE codigo_pedido = @codigo_pedido;
    END
    
    IF @status_pedido = 'Finalizado'
    BEGIN
		PRINT 'Não é possível adicionar itens a um pedido finalizado.';
        ROLLBACK TRANSACTION;
    END

    -- Inserir acessorio e quantidade na tabela ItemPedido
    INSERT INTO ItemPedido (codigo_pedido, codigo_acessorio, quantidade_pedido)
    VALUES (@codigo_pedido, @codigo_acessorio, @quantidade_solicitada);
    IF @@ROWCOUNT > 0
        COMMIT TRANSACTION;
    ELSE
        ROLLBACK TRANSACTION;

-- (FINALIZADO)
CREATE PROCEDURE removerItemPedido
@codigo_pedido INT,
@codigo_acessorio INT
AS
BEGIN TRANSACTION
    DELETE FROM ItemPedido
    WHERE codigo_pedido = @codigo_pedido AND codigo_acessorio = @codigo_acessorio;
    IF @@ROWCOUNT > 0
        COMMIT TRANSACTION;
    ELSE
        ROLLBACK TRANSACTION;

CREATE PROCEDURE alterarItemPedido
@codigo_pedido INT,
@codigo_acessorio INT,
@quantidade_pedido INT
AS
BEGIN TRANSACTION
    UPDATE ItemPedido
    SET quantidade_pedido = @quantidade_pedido
    WHERE codigo_pedido = @codigo_pedido AND codigo_acessorio = @codigo_acessorio;
    IF @@ROWCOUNT > 0
        COMMIT TRANSACTION;
    ELSE
        ROLLBACK TRANSACTION;

-- Cancelar pedido
--  1. Para cada ItemPedido, alterar quantidade_estoque 
CREATE PROCEDURE cancelarPedido
@codigo_pedido
AS
BEGIN TRANSACTION
	IF EXISTS (SELECT 1 FROM Pedido WHERE codigo_pedido = @codigo_pedido AND status IN ('Pendente', 'Em Andamento'))
	BEGIN
		UPDATE Pedido
		SET Status = 'Cancelado'
		WHERE codigo_pedido = @codigo_pedido;

		UPDATE Acessorio
		SET quantidade_estoque = quantidade_estoque + 
			(SELECT SUM(IP.quantidade_pedido)
			FROM ItemPedido IP
			WHERE IP.codigo_acessorio = @codigo_pedido)
		WHERE codigo_acessorio IN
			(SELECT codigo_acessorio
			FROM ItemPedido
			WHERE codigo_pedido = @codigo_pedido);

		-- Excluir os itens do pedido cancelado
        DELETE FROM ItemPedido
        WHERE codigo_pedido = @codigo_pedido;

        -- Confirmar o cancelamento do pedido
        COMMIT TRANSACTION;

		PRINT 'Pedido cancelado com sucesso.';
    END
    ELSE
    BEGIN
        -- Pedido não encontrado ou não está no status apropriado para cancelamento
        ROLLBACK TRANSACTION;
        PRINT 'Não foi possível cancelar o pedido. Pedido não encontrado ou não está no status apropriado para cancelamento.';
    END
END

-- Finalizar pedido
CREATE PROCEDURE finalizarPedido
@codigo_pedido INT,
@data DATE,
@hora TIME,
@metodo_pagamento VARCHAR(50),
@desconto DECIMAL(10,2),
@parcelas INT,
@juros DECIMAL(5,2)
AS
BEGIN TRANSACTION
    UPDATE Pedido
    SET data = @data, hora = @hora, status = 'Finalizado', metodo_pagamento = @metodo_pagamento, desconto = @desconto, parcelas = @parcelas, juros = @juros
    WHERE codigo_pedido = @codigo_pedido;
    IF @@ROWCOUNT > 0
        COMMIT TRANSACTION;
    ELSE
        ROLLBACK TRANSACTION;

EXEC finalizarPedido @codigo_pedido = 1, @data = '2023-11-28', @hora = '15:30:00', @metodo_pagamento = 'Cartão de crédito', @desconto = 0.00, @parcelas = 3, @juros = 0.00;