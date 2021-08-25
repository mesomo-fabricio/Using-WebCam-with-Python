create sequence seq_pessoas minvalue 3001 increment by 1;

create table Pessoas (
cd_pessoa int PRIMARY KEY,
NOME VARCHAR (20),
SOBRENOME VARCHAR(60),
CPF CHAR (11)
);

create or replace NONEDITIONABLE FUNCTION valida_cpf(p_numero_cpf IN VARCHAR2) RETURN NUMBER IS
  v_cpf               VARCHAR2(11) := lpad(p_numero_cpf, 11, '0');
  v_soma_primeiro_dig NUMBER := 0;
  v_soma_segundo_dig  NUMBER := 0;
BEGIN
  -- Cálculo do primeiro dígito verificador
  FOR i IN REVERSE 2 .. 10
  LOOP
    v_soma_primeiro_dig := (v_soma_primeiro_dig + (i * to_number(substr(v_cpf, (11 - i), 1))));
  END LOOP;
  v_soma_primeiro_dig := (11 - (MOD(v_soma_primeiro_dig, 11)));
  IF (v_soma_primeiro_dig >= 10)
  THEN
    v_soma_primeiro_dig := 0;
  END IF;
  -- Cálculo do segundo dígito verificador
  FOR i IN REVERSE 2 .. 11
  LOOP
    v_soma_segundo_dig := (v_soma_segundo_dig + (i * to_number(substr(v_cpf, (12 - i), 1))));
  END LOOP;
  v_soma_segundo_dig := (11 - (MOD(v_soma_segundo_dig, 11)));
  IF (v_soma_segundo_dig = 10)
  THEN
    v_soma_segundo_dig := 0;
  END IF;
  IF ((v_soma_primeiro_dig = to_number(substr(v_cpf, 10, 1))) AND
     (v_soma_segundo_dig = to_number(substr(v_cpf, 11, 1))))
  THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END valida_cpf;


CREATE OR REPLACE TRIGGER TR_VALIDAR_CPF
before INSERT ON pessoas 
for each row
BEGIN
   IF (VALIDA_CPF(CPF)=1) THEN
        exit;
           -- CPF VALIDO, SÓ DAR CONTINUIDADE NO PROCESSO
       ELSE
           -- CPF ESTÁ INVALIDO, ENTÃO APARECE A MENSAGEM DE ERRO!
           RAISE_APPLICATION_ERROR(-20001, 'CPF inválido');
   END IF;

END TR_VALIDAR_CPF;