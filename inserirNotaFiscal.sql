CREATE PROCEDURE inserirNotaFiscal
@codigo_notaFiscal INT,
@data DATE,
@hora TIME,
@valor_total DECIMAL(10,2),
@metodo_pagamento VARCHAR(50),
@desconto DECIMAL(10,2),
@parcelas INT,
@juros DECIMAL(5,2),
@codigo_funcionario INT,
@codigo_cliente INT,
@codigo_carro INT
AS
INSERT INTO Nota_Fiscal
VALUES (@codigo_notaFiscal, @data, @hora, @valor_total, @metodo_pagamento, @desconto, @parcelas, @juros, @codigo_funcionario, @codigo_cliente, @codigo_carro);

EXEC inserirNotaFiscal 1, '2023-11-15', '22:14:00', 80.000, 'À vista', 0, 1, 0, 4, 1, 1; 