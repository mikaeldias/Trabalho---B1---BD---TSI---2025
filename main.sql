Trabalho B1 BD:

view vwEXTRATO:

CREATE VIEW vwEXTRATO 
AS
		SELECT
		C.Nome AS NomeCorrentista,
		CASE
			WHEN M.TipoMovimentacao = 'D' THEN 'Débito'
			WHEN M.TipoMovimentacao = 'C' THEN 'Crédito'
			ELSE 'Desconhecido'
		END AS TipoMovimentacaoExtenso,
		M.DataMovimentacao,
		M.Valor
FROM
    MOVIMENTACAO AS M
INNER JOIN
    CORRENTISTA AS C ON M.IdCorrentista = C.IdCorrentista;
GO
------------------------------------------------------------

(trigger) Movimentação:
CREATE TRIGGER ti_AtualizaSaldoFinanceiro
ON MOVIMENTACAO
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON; 

    UPDATE C
    SET SaldoFinanceiro = CASE
                            WHEN I.TipoMovimentacao = 'D' THEN C.SaldoFinanceiro - I.Valor
                            WHEN I.TipoMovimentacao = 'C' THEN C.SaldoFinanceiro + I.Valor
                            ELSE C.SaldoFinanceiro 
                          END
    FROM CORRENTISTA AS C
    INNER JOIN INSERTED AS I ON C.IdCorrentista = I.IdCorrentista;
END;
GO