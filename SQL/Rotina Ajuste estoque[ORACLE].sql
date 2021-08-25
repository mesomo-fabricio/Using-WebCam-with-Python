SELECT e.cd_unidade_de_n,
       e.cd_centro_armaz,
       e.cd_material,
       e.lote,
       e.qt_online,
       Cgfc_est_posicao_estoque( '1', 'Q', e.cd_unidade_de_n, e.cd_centro_armaz, e.cd_material, e.cd_especif1, e.especif2, e.especif3, e.numeracao, e.lote, Trunc( SYSDATE ), 0, ' ' ) AS POSICAO
FROM   ESESTOQU e
WHERE  e.qt_online <> Cgfc_est_posicao_estoque( '1', 'Q', e.cd_unidade_de_n, e.cd_centro_armaz, e.cd_material, e.cd_especif1, e.especif2, e.especif3, e.numeracao, e.lote, Trunc( SYSDATE ), 0, ' ' )
--and e.cd_centro_armaz<>' '
and e.cd_material LIKE '001%'
and e.cd_unidade_de_n= '001';

declare  v_qtdeTabela  number;
        v_nadaNum     number;
        v_enter       varchar2(2) default chr(13)||chr(10);
        v_prMedio     number;
        v_prMedioTabela number;
        v_prCusto       number;
        v_qtdeEstoque  number;
        v_pr_compra NUMBER;
        v_data_compra date;
        v_PR_DATA__CUSTO date;

cursor c_estoque is
   select cd_material,
          cd_centro_armaz,
          cd_unidade_de_n,
          cd_especif1,
          especif2,
          especif3,
          numeracao,
          lote
   from esestoqu
   where cd_unidade_de_n<>' '
      and cd_centro_armaz<>' '
      and cd_material like '5203000002'
    /*  and rownum=1*/;

 
begin
  dbms_output.put_line('Iniciou');
   for est in c_estoque
   loop
      cgpr_est_posicao_estoque('A',
                               est.cd_unidade_de_n,
                               est.cd_centro_armaz,
                               est.cd_material,
                               est.cd_especif1,
                               est.especif2,
                               est.especif3,
                               est.numeracao,
                               est.lote,
                               trunc(sysdate),
                               0,
                               ' ',
                               v_qtdeEstoque,
                               v_nadaNum,
                               v_prMedio,
                               v_nadaNum);
                               
                               CGPR_EST_BUSCA_PR_COMPRA (est.cd_unidade_de_n,
EST.cd_material,
EST.cd_especif1,
EST.especif2,
0,
v_pr_compra ,
v_data_compra );

      begin
         select qt_online,pr_medio,pr_custo, PR_DATA__CUSTO
         into v_qtdeTabela,v_prMedioTabela,v_prCusto, v_PR_DATA__CUSTO
         from esestoqu
         where cd_material=est.cd_material
            and cd_centro_armaz=est.cd_centro_armaz
            and cd_unidade_de_n=est.cd_unidade_de_n
            and cd_especif1=est.cd_especif1
            and especif2=est.especif2
            and especif3=est.especif3
            and numeracao=est.numeracao
            and lote=est.lote;
      exception
      when others then
         v_qtdeTabela:=0;
         v_prMedioTabela:=0;
         v_prCusto:=0;
      end;
         
      if v_qtdeEstoque <> v_qtdeTabela  or v_prMedio <> v_prMedioTabela or v_prCusto <> v_prMedio  or v_PR_DATA__CUSTO <> v_data_compra then  
                           
         update esestoqu
         set qt_online = v_qtdeEstoque,
             quantidade = v_qtdeEstoque,
             qt_total_entrad = v_qtdeEstoque,
             qt_total_saidas = 0,
             dt_atualizacao=trunc(sysdate),
             pr_medio = v_prMedio,
             pr_custo = v_prMedio,
             PR_DATA__CUSTO = v_data_compra
         where cd_material=est.cd_material
            and cd_centro_armaz=est.cd_centro_armaz
            and cd_unidade_de_n=est.cd_unidade_de_n
            and cd_especif1=est.cd_especif1
            and especif2=est.especif2
            and especif3=est.especif3
            and numeracao=est.numeracao
            and lote=est.lote;
            
        /* dbms_output.put_line('========================================'||v_enter
                             ||'Material: '||est.cd_material||v_enter
                              ||'CA: '||est.cd_centro_armaz||v_enter
                              ||'UN: '||est.cd_unidade_de_n||v_enter
                              ||'Especif1: '||est.cd_especif1||v_enter
                              ||'Especif2: '||est.especif2||v_enter
                              ||'Especif3: '||est.especif3||v_enter
                              ||'Numeracao: '||est.numeracao||v_enter
                              ||'Lote: '||est.lote||v_enter
                              ||'Quantidade: '||cast(v_qtdeEstoque as varchar2)||v_enter
                              ||'========================================');*/
         commit;
      end if;
   end loop;
end;