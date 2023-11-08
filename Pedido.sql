-- iniciar Pedido
CREATE PROCEDURE iniciarPedido
@codigo_pedido INT,
@codigo_cliente INT
AS
DECLARE @status VARCHAR(50);
SET @status = 'Vazio';
INSERT INTO Pedido(codigo_pedido, status, codigo_cliente)
VALUES (@codigo_pedido, @status, @codigo_cliente);

-- adicionar Item ao Pedido
-- Se status de pedido = 'Vazio', mudar status para 'Pendente'
-- Verificar se o estoque possui a quantidade de acessorios solicitada
-- Inserir acessorio e quantidade na tabela ItemPedido
-- Alterar a quantidade de acessorios na tabela Acessorios
-- Alterar o valor total de pedido

CREATE PROCEDURE adicionarItemPedido
@codigo_pedido INT,
@codigo_acessorio INT,
@quantidade_solicitada INT
AS
BEGIN TRANSACTION
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

    -- Verificar se o estoque possui a quantidade de acessorios solicitada
    DECLARE @quantidade_estoque INT;

    SELECT @quantidade_estoque = quantidade_estoque
    FROM Acessorio
    WHERE codigo_acessorio = @codigo_acessorio;

    IF @quantidade_estoque < @quantidade_solicitada
    BEGIN
        ROLLBACK TRANSACTION;
		RETURN;
    END
    -- Inserir acessorio e quantidade na tabela ItemPedido
    ELSE
    BEGIN
        INSERT INTO ItemPedido (codigo_pedido, codigo_acessorio, quantidade_pedido)
        VALUES (@codigo_pedido, @codigo_acessorio, @quantidade_solicitada);

        
        -- Alterar a quantidade de acessorios na tabela Acessorios
        IF @@ROWCOUNT > 0
        BEGIN
            UPDATE Acessorio
            SET quantidade_estoque = quantidade_estoque - @quantidade_solicitada
            WHERE codigo_acessorio = @codigo_acessorio;

            -- Alterar o valor total de pedido
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
        END
        ELSE
            ROLLBACK TRANSACTION;
    END

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
-- Alterar as quantidades de cada 