--MODIFICAR O VALOR DO CHEQUE
UPDATE GFCHEQUE SET CAMPO49 ='[VALOR DO CHEQUE]' WHERE CD_LANCAMENTO='[Nro. LANÇAMENTO]'
UPDATE GFLANCAM SET VALOR = '[VALOR DO CHEQUE]', VL_SALDO = '[VALOR DO CHEQUE]' WHERE CD_LANCAMENTO='[Nro. LANÇAMENTO]'

--SELECT GRUPOS, NOMES, SUBGRUPOS, NOMES, REFERÊNCIA, ESPECIF
select 
ES.CD_MATERIAL, 
ES.DESCRICAO, 
ES.CD_GRUPO, 
ES.CD_SUB_GRUPO, 
ES.REFERENCIA, 
GP.DESCRICAO AS DESC_GRUPO,
SG.DESCRICAO AS DESC_SUBGRUPO,
EP.DESCRICAO AS DESC_ESPECIF

FROM ESMATERI ES

LEFT JOIN ESGRUPO GP
ON GP.CD_GRUPO = ES.CD_GRUPO
LEFT JOIN ESSUBGRU SG
ON SG.CD_SUB_GRUPO = ES.CD_SUB_GRUPO AND  SG.CD_GRUPO = ES.CD_SUB_GRUPO
LEFT JOIN ESES2 EP
ON EP.CD_GRUPO = ES.CD_GRUPO AND EP.ESPECIF2 = ES.CD_ESPECIF2


--ENCONTRAR CHEQUE DO LANÇAMENTO
SELECT * FROM GFCHEQUE
WHERE CD_LANCAMENTO = 10867;
-- DELETAR CHEQUE
DELETE FROM GFCHEQUE
WHERE CD_LANCAMENTO = 10867;

--FAZER BKP DE TABELA
CREATE TABLE NOME NOVA_TABELA AS select * from TABELA OFICIAL

--MIGRAÇÃO CIGAMe 10 --> CIGAM 11 NA TELA REQUISIÇÃO DE MATERIAIS N APARECE NENHUMA REQUISIÇÃO
UPDATE COSOLICI SET CAMPO23='S' WHERE CAMPO23= ' ';

-- verifica e mata sessão no BD (Linha alocada, aplicável somente para Oracle)
SELECT ss.sid,ss.serial#, ss.username, ss.osuser, ao.owner || '.' || ao.object_name AS OBJECT_NAME
FROM v$session ss, v$lock lk, dba_objects ao
WHERE lk.sid = ss.sid
AND ss.username is not null
AND ao.object_id(+) = lk.id1
AND ao.object_name like '%';
                                      
ALTER SYSTEM KILL SESSION 'sid, serial';

-- VALIDAR CTE
update cogerxml set status='1' where id in ('14021','13969');

-- MUDAR REMESSA EVIADA

UPDATE GFLANCAM SET REMESSA_ENVIADA='0' WHERE CD_LANCAMENTO IN
('5526796',
'5526797',
'5526812',
'5526818')

--ALTERAR TIPO DO MATERIAL 
UPDATE ESMATERI SET TIPO='A' WHERE CD_MATERIAL IN ('520110015600','520110015610', '520110015620');




--LISTAR NFs EMITIDAS DE UM PERÍODO
SELECT NF.DT_EMISSAO, NF.NF,NF.CD_REPRESENTANT AS REPRESENTANTE, EMP.CD_EMPRESA,EMP.NOME_COMPLETO, EMP.CNPJ_CPF, EMP.UF, EMP.ENDERECO,
 EMP.BAIRRO, EMP.MUNICIPIO,EMP.NUMERO, EMP.COMPLEMENTO, EMP.CEP, EMP.FONE,NF.PESO_LIQUIDO, NF.PESO_BRUTO, 
NF.TOTAL_FATURADO, MAIL.EMAIL, PAG.DESCRICAO AS COD_PAG, WM_CONCAT(FIN.CD_PORTADOR) AS PORTADORES FROM FANFISCA NF, GEEMPRES EMP, VECEMPRE MAIL, GFLANCAM FIN,  
FACPAGAM PAG WHERE NF.CD_CLIENTE = EMP.CD_EMPRESA AND NF.DT_EMISSAO BETWEEN '01/09/18' AND '30/09/18' AND NF.TOTAL_FATURADO>0
 AND EMP.CD_EMPRESA=MAIL.CD_EMPRESA AND MAIL.SEQUENCIA_CONTA=0 AND NF.CD_CONDICAO_PAG=PAG.CD_CONDICAO_PAG 
 AND NF.NF=FIN.NF AND NF.SERIE=FIN.SERIE AND NF.CD_UNIDADE_DE_N=FIN.CD_UNIDADE_DE_N AND NF.CD_CLIENTE=FIN.CD_EMPRESA
 GROUP BY NF.DT_EMISSAO, NF.NF,NF.CD_REPRESENTANT, EMP.CD_EMPRESA,EMP.NOME_COMPLETO, EMP.CNPJ_CPF, EMP.UF, EMP.ENDERECO,
 EMP.BAIRRO, EMP.MUNICIPIO,EMP.NUMERO, EMP.COMPLEMENTO, EMP.CEP, EMP.FONE,NF.PESO_LIQUIDO, NF.PESO_BRUTO, 
NF.TOTAL_FATURADO, MAIL.EMAIL, PAG.DESCRICAO
 ORDER BY NF.DT_EMISSAO;

--GERAR PEDIDO EM EXCEL
select ite.codigo_fabrica, ite.descricao, ite.peso, ped.quantidade, ped.QT_SALDO, ped.pr_unitario from
faitempe ped, esmateri ite where
ped.cd_material = ite.cd_material and
ped.cd_pedido = ('0318606') and
ped.cd_especie='R';

--GERAR DOIS OU MAIS PEDIDO EM EXCEL
select ite.codigo_fabrica, ite.descricao, ite.peso, ped.quantidade, ped.QT_SALDO, ped.pr_unitario from
faitempe ped, esmateri ite where
ped.cd_material = ite.cd_material and
ped.cd_pedido in ('0318606','0318605') and
ped.cd_especie='R';

--TODAS AS NOTAS DE UM DETERMINADO PERÍODO DE CERTO REPRESENTANTE
SELECT NF.DT_EMISSAO, NF.NF, EMP.CD_EMPRESA, EMP.NOME_COMPLETO, NF.TOTAL_FATURADO 
FROM FANFISCA NF, GEEMPRES EMP WHERE NF.CD_CLIENTE = EMP.CD_EMPRESA AND NF.DT_EMISSAO BETWEEN '01/05/17' AND '31/05/17'
AND NF.CD_REPRESENTANT='700906' AND NF.TOTAL_FATURADO>0
ORDER BY NF.DT_EMISSAO;



--TODAS AS NOTAS DE UM DETERMINADO PERÍODO DE CERTO CLIENTE
SELECT NF.DT_EMISSAO, NF.NF, EMP.CD_EMPRESA, EMP.NOME_COMPLETO, NF.TOTAL_FATURADO 
FROM FANFISCA NF, GEEMPRES EMP WHERE NF.CD_CLIENTE = EMP.CD_EMPRESA AND NF.DT_EMISSAO BETWEEN '01/09/16' AND '21/11/16'
AND NF.CD_CLIENTE='014756' AND NF.TOTAL_FATURADO>0
ORDER BY NF.DT_EMISSAO;



--VERIFICAR SE GEROU NOTAS EM UMA REMESSA
SELECT DISTINCT (NF), CD_PEDIDO FROM FAITEMPE WHERE PLANO_MESTRE='R018104' ORDER BY NF;




--ESTOQUES GUIGO CENTROS 5, 5AT, 5AAI
SELECT ite.codigo_fabrica,ITE.DESCRICAO, EST.QUANTIDADE
FROM ESMATERI ITE, ESESTOQU EST WHERE
EST.QUANTIDADE != '0' AND
ITE.CD_MATERIAL = EST.CD_MATERIAL(+) AND
EST.CD_UNIDADE_DE_N(+)='5' AND
EST.CD_CENTRO_ARMAZ(+) IN ('5AT')
group by ite.codigo_fabrica, ITE.DESCRICAO, est.quantidade ORDER BY ITE.CODIGO_FABRICA;




--AGRUPAR PEDIDOS
SELECT ITE.CODIGO_FABRICA, ITE.DESCRICAO, ITE.PESO, SUM(PED.QT_SALDO), SUM(PED.QT_SALDO*PR_UNITARIO)
FROM FAITEMPE PED, ESMATERI ITE WHERE 
PED.CD_MATERIAL = ITE.CD_MATERIAL AND
PED.CD_PEDIDO IN 
('0318843',
'0318843',
'0318843',
'0318843',
'0318845') AND
PED.CD_ESPECIE='R' and
PED.QT_SALDO >0 GROUP BY ITE.CODIGO_FABRICA, ITE.DESCRICAO, ITE.PESO
ORDER BY ITE.CODIGO_FABRICA;


--CLIENTES DE UM REPRSENTANTE
SELECT * FROM GEEMPRES WHERE CD_REPRESENTANT = '700960';

--NFS DE UM PEDIDO
SELECT DISTINCT(NF) FROM FAITEMPE WHERE CD_PEDIDO='XXXXXX' AND NF<>'0';



--HORA EM QUE FOI DADA A ENTRADA EM UMA OP
SELECT OP,QT_FABRICADA, TALAO, DATA, To_Char(DATA, 'HH24:MM:SS') FROM temp_control
WHERE OP='664320';

--MUDAR MÁQUINA PADRÃO EM PEDIDO (ENTRADA ANTECIPADA)

UPDATE FAITEMPE MAT SET MAT.ESPECIF2=(SELECT EMP.CD_ESPECIF2 FROM ESMATERI EMP WHERE EMP.CD_MATERIAL=MAT.CD_MATERIAL) WHERE MAT.CD_PEDIDO='0221791';

--CÓDIGO ESTRUTURAL DE ÍTEM

SELECT CD_MATERIAL, CODIGO_FABRICA FROM ESMATERI WHERE TIPO='A' AND CODIGO_FABRICA IN
('104057',
'200766',
'200780')

--Estoque CA "5"

SELECT MAT.CODIGO_FABRICA, MAT.DESCRICAO, EST.QUANTIDADE FROM ESMATERI MAT, ESESTOQU EST WHERE
EST.CD_MATERIAL=MAT.CD_MATERIAL AND
MAT.CD_GRUPO='20' AND
EST.QUANTIDADE>0 AND
EST.CD_UNIDADE_DE_N='5' AND
EST.CD_CENTRO_ARMAZ='5'
ORDER BY MAT.CODIGO_FABRICA;

--ALTERAR PRAZO DE ENTREGA DE UM PEDIDO

UPDATE FAitempe SET DT_PRAZO_ENTREG='26/10/19' WHERE CD_PEDIDO IN(
'X0337965',
'X0338082',
'X0338083',
'X0338124',
'X0338135',
'X0338217',
'X0338218',
'X0338250',
'X0338251',
'X0338252',
'X0338265',
'X0338282',
'X0338312',
'X0338313',
'X0338320',
'X0338324',
'X0338325',
'X0338345',
'X0338372',
'X0338403',
'X0338419');




--------------------
COORDEM - oc
COIORDEM - itens
COGORDEM - se tiver grade/lote
--------------------