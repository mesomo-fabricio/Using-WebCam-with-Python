select * from esmovime where movimento='1027525'

SELECT * FROM ESMATERI WHERE CD_MATERIAL='400001000241'

SELECT * FROM PPIDENT

213659

400001000241        

SELECT cd_carac FROM PPIDENT WHERE CD_CARAC LIKE '%;M2%' AND IDENTIFICADOR='213659'
SELECT sequencial FROM PPIDENT WHERE CD_CARAC LIKE '%;M2%' AND IDENTIFICADOR='213659'

create or replace function ROWIDM2 (V_IDENTIFICADOR VARCHAR) 
RETURN number as
V_SEQUENCIAL number;
V_CARACT CHAR(5);
BEGIN
    V_CARACT:='%;M2%';
    SELECT sequencial INTO V_SEQUENCIAL FROM PPIDENT WHERE CD_CARAC LIKE V_CARACT AND IDENTIFICADOR=V_IDENTIFICADOR;
    
    RETURN V_SEQUENCIAL;
END;
/

select ROWIDM2('213659') AS M2  FROM DUAL

CREATE OR REPLACE FUNCTION M2_ESTUFA (

select
trim(substr(cd_carac, instr(cd_carac,';M2',1,1)+3, 15)) as metragem
from ppident where IDENTIFICADOR='213659' and sequencial='7'

select mov.nf, mov.serie, mov.pr_total_custo, trim(substr(cd_carac, instr(cd_carac,';M2',1,1)+3, 15)) as metragem, mov.cd_empresa

from esmovime mov

inner join ppident pp
on mov.cd_especif1=pp.identificador

where mov.nf='7670'
AND 


