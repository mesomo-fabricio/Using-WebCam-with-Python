--MONTAR GRANT PARA TODAS AS TABELAS USER CIGAM 
SELECT
'GRANT SELECT ON CIGAM.'|| TABLE_NAME || ' TO SACVIEW;'

FROM USER_TABLES

---RECOMPILAR OBJETOS DO BD
begin
sys.dbms_utility.compile_schema(schema => 'CIGAM');
end;

--ERRO OPEN CURSOR
ALTER SYSTEM SET OPEN_CURSORS=5000 SCOPE=BOTH;

--SETAR MOVIMENTO DE SAÍDA E CA EM BRANCO NO MOVIMENTO DE SAIDA DOS NROS DE SÉIRE (PIONEIRA)
update esnserie set CAMPO23=' ', 
movimento_saida=(select movimento from esmovime where nf='2737' and serie='NFE8')
                where numero_de_serie='7017' AND CAMPO23='001'

--CRIAR TABELA COM A MESMA ESTRUTURA (TIPO DE DADOS) 

select cd_empresa,nome_completo, fone, fantasia, divisao,Cnpj_cpf, Inscricao,Endereco,Numero, Bairro, Municipio, Uf, Cep,Fax_fone, Nome_completo as email into GEEMPRES_IMP from geempres where cd_empresa='0'

--IMPORTAR DE ARQUIVO .CSV
bulk insert geempres_imp from 'C:\tmp\GEEMPRES_IMP.csv' with (fieldterminator = ';', rowterminator = '\n', firstrow = 2, codepage = 'acp')

EXP CIGAM/CIGAM@XE FILE=C:\Temp\CIGAMTESTE260918.dmp statistics=none consistent=no

--PARA FAZER BACKUP DA BASE
cd C:\Oracle\product\19.3.0\bin\
EXP CIGAM/CIGAM@XE FILE=C:\CIGAM.dmp statistics=none consistent=no log=C:\logdump.txt

EXP 'SYS/CIGAM@CIGAM AS SYSDBA' FILE=C:\BACKUP\CIGAM.dmp statistics=none consistent=no log=C:\BACKUP\logdump.txt

-- verifica e mata sessão no BD (Linha alocada, aplicável somente para Oracle)
SELECT ss.sid,ss.serial#, ss.username, ss.osuser, ao.owner || '.' || ao.object_name AS OBJECT_NAME
FROM v$session ss, v$lock lk, dba_objects ao
WHERE lk.sid = ss.sid
AND ss.username is not null
AND ao.object_id(+) = lk.id1
AND ao.object_name like '%';
                                      
ALTER SYSTEM KILL SESSION 'sid, serial';


select username, profile
	from dba_users;

-- Verificar em que tablespace esta uma tabela:

select table_name, tablespace_name
from user_tables
where table_name='GEEMPRES';
--NO CMD:
SQLPLUS

--LOGIN:
USER: SYS@XE AS SYSDBA
PASS: 

Antes de DROPAR, verificar em qual tablespace esta o CIGAM_TESTE

--REMOVER USUARIO TESTE
DROP USER CIGAMTESTE CASCADE;


sE OCORRER erro DO TIPO:
-----------------------------------------------------------------------------------------------
ORA-01940: cannot drop an user that is currently connected

EXECUTAR O COMANDO ABAIXO:

select s.sid, s.serial#, s.status, p.spid
from v$session s, v$process p
where s.username = 'CIGAMTESTE' 
and p.addr (+) = s.paddr;

E MATAR O PROCESSO:
-- alter system kill session '<sid>,<serial#>';
-- alter system kill session '697,35409';

e ENTAO EXCLUIR O USUARIO:
DROP USER CIGAMTESTE CASCADE;
-------------------------------------------------------------------------------------------------
ORA-28014: cannot drop administrative users

EXECUTAR O COMANDO ABAIXO:
alter session set "_oracle_script"=true;
e ENTAO EXCLUIR O USUARIO:
DROP USER CIGAMTESTE CASCADE;
-------------------------------------------------------------------------------------------------


--CRIAR USUÁRIO DE TESTE
CREATE USER CIGAMTESTE
IDENTIFIED BY CIGAMTESTE
DEFAULT TABLESPACE CIGAM_DATA
TEMPORARY TABLESPACE TEMP;

--GARANTIR ACESSOS
GRANT CONNECT, RESOURCE, CREATE VIEW TO CIGAMTESTE;
grant IMP_FULL_DATABASE to CIGAMTESTE;

--REMOVER O RESOURCE
REVOKE UNLIMITED TABLESPACE FROM CIGAMTESTE;

--COTAS DO USUÁRIO (CONFIRMAR OS NOMES)
ALTER USER CIGAMTESTE QUOTA 0 ON SYSTEM QUOTA 0 ON SYSAUX QUOTA UNLIMITED ON CIGAM_DATA;
--ALTER USER CIGAM QUOTA 0 ON SYSTEM QUOTA 0 ON SYSAUX QUOTA UNLIMITED ON CIGAM_DATA;
--QUOTA UNLIMITED ON CIGAM_INDEX
--QUOTA UNLIMITED ON USERS;

--ESTOQUE 3.0
grant select on "SYS"."V_$SESSION" to "CIGAMTESTE";
grant administer database trigger to "CIGAMTESTE";
grant create any trigger to "CIGAMTESTE";
grant all privileges to "CIGAMTESTE";

--Setar sessao como false
alter session set "_oracle_script"=FALSE;

--EXECUTAR COMO CIGAM
select table_name, tablespace_name
from user_tables
where table_name='GFLANCAM';

--IMP TESTE
IMP CIGAMTESTE/CIGAMTESTE@XE FILE=C:\CIGAM.dmp FROMUSER=CIGAM TOUSER=CIGAMTESTE

--IMP OFICIAL
IMP CIGAM/CIGAM@XE FILE=C:\INST\Utilitarios\bdimple.dmp FROMUSER=BDIMPLE TOUSER=CIGAM

impdp CIGAMTESTE/CIGAMTESTE dumpfile=CIGAM.DMP directory=DIR_BACKUP logfile=CIGAMTESTE.log remap_schema=CIGAM:CIGAMTESTE

--EM CASO DE CRIAÇÃO DE AMBIENTE TESTE, VALIDAR SEGUINTES NOMES LÓGICOS

DATABASE = CIGAMTESTE
DBOWNER = CIGAMTESTE
DBUSUARIO = CIGAMTESTE
DBSENHA = CIGAMTESTE
DBOWNER_AMBIENTE = CIGAMTESTE
CGAMBIENTE = TESTES


Apos, copiar a pasta CAB do CIGAM Oficial para a base Teste

Necessário tambem atualizar as rotinas da base, inicializando o CIGAM como AtualizaCIGAM.eci
*reprocessei as rotinas e foi


-------------------------------------------------------------------


select mov.movimento, trim(mov.cd_material) ||' - '|| mat.descricao as material,mov.cd_especif1, mov.nf, mov.serie, sum(mov.pr_total_item) as pr_total_item, 
--trim(substr(cd_carac, instr(cd_carac,';M2',1,1)+3, 15)) as metragem, 
--SUM( TO_NUMBER( REPLACE('1.110,50','.','') ) AS
--sum(TO_NUMBER( REPLACE((trim(substr(cd_carac, instr(cd_carac,';M2',1,1)+3, 15))),'.',''))) AS SOMA_M2,
--
sum(CAST(REPLACE(REPLACE(Trim(substr(cd_carac, instr(cd_carac,';M2',1,1)+3, 15)),'.','') ,',','.') AS DECIMAL(12,2)))
AS SOMA_M2,

--
mov.cd_empresa || ' - '||emp.nome_completo as cliente

from esmovime mov

inner join geempres emp
on mov.cd_empresa = emp.cd_empresa
inner join esmateri mat
on trim(mov.cd_material) = mat.cd_material
inner join ppident pp
on mov.cd_especif1=pp.identificador
left join fanfisca fa
on fa.nf=mov.nf
and fa.serie= trim(mov.serie)
and fa.cd_unidade_de_n=mov.uni_neg
and fa.cd_cliente = mov.cd_empresa

where pp.cd_carac like  '%;M2 %'
and mov.cd_empresa between ':cliente_inicial' and ':cliente_final'
and mov.serie between ':serie_inicial' and ':serie_final'
and mov.dt_movimento between to_date(:dt_mov_inicial,'DD/MM/YYYY') AND to_date(:dt_mov_final,'DD/MM/YYYY')

GROUP by mov.movimento, mov.cd_material, mat.descricao,mov.cd_especif1,mov.nf, mov.serie, mov.pr_total_item, 
PP.cd_carac,
mov.cd_empresa, emp.nome_completo