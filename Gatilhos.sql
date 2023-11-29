use Concessionaria2;

-- (FINALIZADO)
CREATE TRIGGER VerificarEstoqueEStatusAntesDeInserirItemPedido
ON ItemPedido
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

	-- Verificar se o status do pedido não é Finalizado
	IF NOT EXISTS (
		SELECT 1 FROM inserted i
		INNER JOIN Pedido p 
		ON i.codigo_pedido = p.codigo_pedido
		WHERE p.status = 'Finalizado'
	)

	BEGIN
		-- Verificar se o estoque é suficiente
		IF NOT EXISTS (
			SELECT 1
			FROM inserted i
			INNER JOIN Acessorio a ON i.codigo_acessorio = a.codigo_acessorio
			WHERE a.quantidade_estoque < i.quantidade_pedido
		)
		BEGIN
			INSERT INTO ItemPedido (codigo_pedido, codigo_acessorio, quantidade_pedido)
			SELECT i.codigo_pedido, i.codigo_acessorio, i.quantidade_pedido
			FROM inserted i;
		END
		ELSE
		BEGIN
			PRINT 'Estoque de acessorios insuficiente. Pedido nao realizado. Mandaremos mensagem para o fornecedor';
		END
	END
	ELSE
	BEGIN
		PRINT 'Não é possível adicionar itens a um pedido finalizado.';
	END
END

CREATE TRIGGER VerificarEstoqueEStatusAntesDeAtualizarItemPedido
ON ItemPedido
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN Pedido p ON i.codigo_pedido = p.codigo_pedido
        WHERE p.status = 'Finalizado'
    )
	BEGIN
        -- Verificar se o estoque é suficiente
		-- Deve considerar o estoque como sendo a soma do estoque atual do acessório e da quantidade solicitada no item pedido
        IF NOT EXISTS (
            SELECT 1
            FROM inserted i
            INNER JOIN Acessorio a ON i.codigo_acessorio = a.codigo_acessorio
            LEFT JOIN ItemPedido ip ON i.codigo_pedido = ip.codigo_pedido AND i.codigo_acessorio = ip.codigo_acessorio
            WHERE a.quantidade_estoque + ip.quantidade_pedido < i.quantidade_pedido
        )
        BEGIN
            -- Realizar a atualização se ambas as condições forem satisfeitas
            UPDATE ItemPedido
            SET codigo_pedido = i.codigo_pedido, 
                codigo_acessorio = i.codigo_acessorio, 
                quantidade_pedido = i.quantidade_pedido
            FROM inserted i
            WHERE ItemPedido.codigo_pedido = i.codigo_pedido
              AND ItemPedido.codigo_acessorio = i.codigo_acessorio;
        END
        ELSE
        BEGIN
            PRINT 'Estoque de acessorios insuficiente. Atualização do pedido não realizada.';
			ROLLBACK TRANSACTION;
        END
    END
    ELSE
    BEGIN
        PRINT 'Não é possível atualizar itens em um pedido finalizado.';
		ROLLBACK TRANSACTION;
    END
END;

-- (FINALIZADO)
--  Ele atualiza a quantidade de estoque do acess�rio subtraindo a quantidade que foi pedida.
CREATE TRIGGER AtualizarEstoqueAposInserirItemPedido
ON ItemPedido
AFTER INSERT
AS
BEGIN
    UPDATE Acessorio
    SET quantidade_estoque = quantidade_estoque - (SELECT quantidade_pedido FROM inserted)
    WHERE codigo_acessorio = (SELECT codigo_acessorio FROM inserted);
END;



-- (FINALIZADO)
-- Apos Atualizar ItemPedido
CREATE TRIGGER AtualizarEstoqueAposAlterarItemPedido
ON ItemPedido
AFTER UPDATE
AS
BEGIN
	UPDATE Acessorio
	SET quantidade_estoque = quantidade_estoque - (SELECT quantidade_pedido FROM inserted) + (SELECT quantidade_pedido FROM deleted)
	WHERE codigo_acessorio = (SELECT codigo_acessorio FROM inserted)
END;


-- (FINALIZADO)
-- Apos Inserir Item Pedido
-- Apos Atualizar Item Pedido
CREATE TRIGGER AtualizarValorTotalAposInserirAtualizarItemPedido
ON ItemPedido
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Atualizar o valor total do pedido
    UPDATE Pedido
    SET valor_total = (
        SELECT SUM(A.preco * IP.quantidade_pedido)
        FROM ItemPedido IP
        INNER JOIN Acessorio A ON IP.codigo_acessorio = A.codigo_acessorio
        WHERE IP.codigo_pedido = Pedido.codigo_pedido
    )
    FROM Pedido
    INNER JOIN inserted ON Pedido.codigo_pedido = inserted.codigo_pedido;
END;

-- (FINALIZADO)
-- Apos Excluir Item Pedido
CREATE TRIGGER AtualizarEstoqueAposExcluirItemPedido
ON ItemPedido
AFTER DELETE
AS
BEGIN
	UPDATE Acessorio
	SET quantidade_estoque = quantidade_estoque + (SELECT quantidade_pedido FROM deleted)
	WHERE codigo_acessorio = (SELECT codigo_acessorio FROM deleted);
END;

-- (FINALIZADO)
-- Apos Excluir ItemPedido
CREATE TRIGGER AtualizarValorTotalAposExcluirItemPedido
ON ItemPedido
AFTER DELETE
AS
BEGIN
	UPDATE Pedido
	SET valor_total = (
		SELECT ISNULL(SUM(A.preco * IP.quantidade_pedido), 0)
        FROM ItemPedido IP
        INNER JOIN Acessorio A ON IP.codigo_acessorio = A.codigo_acessorio
        WHERE IP.codigo_pedido = p.codigo_pedido
	)
	FROM Pedido p 
	INNER JOIN deleted d
	ON p.codigo_pedido = d.codigo_pedido;
END;

CREATE TRIGGER BeforeUpdatePedido
ON Pedido
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ItemPedido ip ON i.codigo_pedido = ip.codigo_pedido
        JOIN Acessorio a ON ip.codigo_acessorio = a.codigo_acessorio
        WHERE a.quantidade_estoque < ip.quantidade_pedido
    )
    BEGIN
        -- O throw lanca exce��es personalizadas
        THROW 50000, 'Estoque insuficiente para os acess�rios no pedido.', 1;
    END;
END;




SELECT * FROM INFORMATION_SCHEMA.TRIGGERS;

SELECT 
    name AS TriggerName,
    type_desc AS TriggerType
FROM sys.triggers
WHERE parent_id = OBJECT_ID('pedido');

DROP TRIGGER dbo.AfterDeletePedido;

use Concessionaria2;

-- finalizado
CREATE TRIGGER AtualizarEstoqueCarroAposInserirNotaFiscal
ON Nota_Fiscal
AFTER INSERT
AS
BEGIN
    UPDATE Carro
    SET quantidade_estoque = quantidade_estoque - 1
    FROM Carro
    INNER JOIN INSERTED i 
    ON Carro.codigo_carro = i.codigo_carro;
END;

-- finalizado
CREATE TRIGGER AtualizarValorTotalNotaFiscalAposInserirNotaFiscal
ON Nota_Fiscal
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizar o valor_total da Nota Fiscal com base no pre�o do carro
    UPDATE nf
    SET nf.valor_total = c.preco
    FROM Nota_Fiscal nf
    INNER JOIN Carro c ON nf.codigo_carro = c.codigo_carro
    INNER JOIN inserted i ON nf.codigo_notaFiscal = i.codigo_notaFiscal;
END;

-- ja tem o trigger de dar update na quantidade de carro
CREATE TRIGGER InserirNotaFiscal
ON Nota_Fiscal
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @quantidade_estoque_carro INT;
 
    SELECT @quantidade_estoque_carro = quantidade_estoque
    FROM Carro
    WHERE codigo_carro IN (SELECT codigo_carro FROM inserted);

    IF @quantidade_estoque_carro > 0
    BEGIN
        
        UPDATE Carro
        SET quantidade_estoque = quantidade_estoque - 1
        WHERE codigo_carro IN (SELECT codigo_carro FROM inserted);
      
        INSERT INTO Nota_Fiscal (codigo_notaFiscal, data, hora, metodo_pagamento, desconto, parcelas, juros, codigo_funcionario, codigo_cliente, codigo_carro)
        SELECT 
            i.codigo_notaFiscal, i.data, i.hora, i.metodo_pagamento, i.desconto, i.parcelas, i.juros, i.codigo_funcionario, i.codigo_cliente, i.codigo_carro
        FROM inserted i;
    END
    ELSE
    BEGIN
        PRINT 'Quantidade de carros no estoque insuficiente. N�o � poss�vel inserir a nota fiscal.';
    END
END;


CREATE TRIGGER instead_of_delete_nota_fiscal
ON Nota_Fiscal
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @codigo_carro INT;

    SELECT @codigo_carro = codigo_carro
    FROM deleted;

    
    UPDATE Carro
    SET quantidade_estoque = quantidade_estoque + 1
    WHERE codigo_carro = @codigo_carro;

    DELETE FROM Nota_Fiscal
    WHERE codigo_notaFiscal IN (SELECT codigo_notaFiscal FROM deleted);
END;

-- FINALIZADO
CREATE TRIGGER AfterInsertNotaFiscal
ON Nota_Fiscal
AFTER INSERT
AS
BEGIN
    PRINT 'Nota Fiscal criada com sucesso.';
END;

DELETE FROM Nota_Fiscal
WHERE codigo_notaFiscal = 1;

DROP TRIGGER dbo.instead_of_insert_nota_fiscal;