---                         ***BLOQUEIA MODIFICAÇÃO DA EMPRESA BRANCA***

CREATE OR REPLACE TRIGGER EX_BLOQ_EMP_BRANCO 
BEFORE UPDATE OR DELETE ON GEEMPRES
FOR EACH ROW
BEGIN
IF (:OLD.CD_EMPRESA=' ') THEN
    --RAISE_APPLICATION_ERROR(-20001, 'A modificação do cadastro da empresa branca não é permitida');
    RAISE_APPLICATION_ERROR(-20001, 'Você está tentando alterar o cadastro branco, retorne até a tela de pesquisa das empresas e clique em CRIAR no canto inferior direito. A modificação do cadastro branco não é permitida');
END IF;

END;
---

---                         ***BLOQUEIA MODIFICAÇÃO DA PORTADOR BRANCO***

CREATE OR REPLACE TRIGGER EX_BLOQ_PORT_BRANCO 
BEFORE UPDATE OR DELETE ON GFPORTAD
FOR EACH ROW
BEGIN
IF (:OLD.CD_PORTADOR=' ') THEN
    RAISE_APPLICATION_ERROR(-20001, 'A modificação do cadastro do Portador Branco não é permitida. Para criar um novo portador pressione CTRL+ I.');
END IF;

END;

---                         ***ALTERAÇÃO DE RATEIO FINANCEIRO***
--EXEC EX_ALTERA_RATEIO (171024, 'IUA0');

CREATE OR REPLACE PROCEDURE EX_ALTERA_RATEIO (V_LANCAMENTO NUMBER, V_DESCR STRING)
AS
V_CONTA_GER VARCHAR(25);
BEGIN
    V_CONTA_GER:= EX_BUSCA_REDUZIDO(V_DESCR);

    UPDATE GFRGEREN SET PERCENTUAL_RATE=0
    WHERE CD_LANCAMENTO=V_LANCAMENTO
    AND PERCENTUAL_RATE=100;
    
    UPDATE GFRGEREN SET PERCENTUAL_RATE=100
    WHERE CD_LANCAMENTO=V_LANCAMENTO
    AND CD_CONTA_GERENC=V_CONTA_GER;

    COMMIT;
END;

CREATE OR REPLACE FUNCTION EX_BUSCA_REDUZIDO (V_DESCRICAO CHAR)
return  CHAR
as
V_CONTA VARCHAR(10);
V_DESCRI VARCHAR(20);
begin
    V_DESCRI := V_DESCRICAO||'%';
    select pcc_classific_c into V_CONTA
    from ccpcc 
    where pcc_nome_conta like V_DESCRI;

    RETURN V_CONTA;

end;
