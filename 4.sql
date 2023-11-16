CREATE TRIGGER inclusaoFaturaPaga
ON fatura
FOR UPDATE
AS
    IF UPDATE(dtpagamento)
    BEGIN
        DELETE FROM fatura
        WHERE numfatura = (select numfatura from inserted)
        IF @@ROWCOUNT > 0
        BEGIN
            INSERT INTO faturapaga select * from inserted
            IF @@ROWCOUNT = 0
                ROLLBACK TRANSACTION
        end
        ELSE
            ROLLBACK TRANSACTION
        END
    END