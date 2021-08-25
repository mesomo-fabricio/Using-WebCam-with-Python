begin
declare @v_qtdeEstoque float,
            @v_qtdeTabela  float,
            @v_nadaNum     float,
            @v_prMedio     float,
            @v_prMedioTabela float,
            @v_prCusto       float;
                        
declare @v_cd_material varchar(20),
            @v_cd_centro_armaz varchar(4),
            @v_cd_unidade_de_n varchar(3),
            @v_cd_especif1 varchar(6),
            @v_especif2 varchar(6),
            @v_especif3 varchar(6),
            @v_numeracao varchar(4),
            @v_lote varchar(14),
            @v_data_atual datetime;
            
            
 
declare @c_estoque cursor;
 
set @v_data_atual = dbo.CGFC_DATAATUAL();
 
 
set @c_estoque = cursor static for
   select cd_material,
          cd_centro_armaz,
          cd_unidade_de_n,
          cd_especif1,
          especif2,
          especif3,
          numeracao,
          lote
   from esestoqu (nolock)
 
   where cd_unidade_de_n<>' '
      and cd_centro_armaz<>' '
 
begin
      
      open  @c_estoque
      FETCH NEXT FROM @c_estoque INTO @v_cd_material,      
                                                     @v_cd_centro_armaz,     
                                                     @v_cd_unidade_de_n,
                                                     @v_cd_especif1,
                                                     @v_especif2,
                                                     @v_especif3,
                                                     @v_numeracao,
                                                     @v_lote
  
        while @@fetch_status = 0
        begin 
        
        exec dbo.cgpr_est_posicao_estoque 'A',
                               @v_cd_unidade_de_n,
                               @v_cd_centro_armaz,
                               @v_cd_material,
                               @v_cd_especif1,
                               @v_especif2,
                               @v_especif3,
                               @v_numeracao,
                               @v_lote,
                               @v_data_atual,
                               0,
                               ' ',
                               @v_qtdeEstoque output,
                               @v_nadaNum output,
                               @v_prMedio output,
                               @v_nadaNum output;
        
      begin
         select @v_qtdeTabela = qt_online,@v_prMedioTabela = pr_medio,@v_prCusto = pr_custo
         --into @v_qtdeTabela,@v_prMedioTabela,@v_prCusto
         from esestoqu (nolock)
         where cd_material=@v_cd_material
            and cd_centro_armaz=@v_cd_centro_armaz
            and cd_unidade_de_n=@v_cd_unidade_de_n
            and cd_especif1=@v_cd_especif1
            and especif2=@v_especif2
            and especif3=@v_especif3
            and numeracao=@v_numeracao
            and lote=@v_lote;
            
              if @@error !=0 or @@rowcount = 0
              begin 
                  set @v_qtdeTabela=0;
                  set @v_prMedioTabela=0;
                  set @v_prCusto=0;
              end;
          
      end;
         
      if @v_qtdeEstoque <> @v_qtdeTabela  or @v_prMedio <> @v_prMedioTabela or @v_prCusto <> @v_prMedio 
      begin    
                           
         update esestoqu 
         set qt_online = @v_qtdeEstoque,
             quantidade = @v_qtdeEstoque,
             qt_total_entrad = @v_qtdeEstoque,
             qt_total_saidas = 0,
             dt_atualizacao=@v_data_atual,
             pr_medio = @v_prMedio,
             pr_custo = @v_prMedio
         where cd_material=@v_cd_material
            and cd_centro_armaz=@v_cd_centro_armaz
            and cd_unidade_de_n=@v_cd_unidade_de_n
            and cd_especif1=@v_cd_especif1
            and especif2=@v_especif2
            and especif3=@v_especif3
            and numeracao=@v_numeracao
            and lote=@v_lote;
           
      end;
      
    FETCH NEXT FROM @c_estoque INTO @v_cd_material,  
                                                     @v_cd_centro_armaz,     
                                                     @v_cd_unidade_de_n,
                                                     @v_cd_especif1,
                                                     @v_especif2,
                                                     @v_especif3,
                                                     @v_numeracao,
                                                     @v_lote
      
      end-- fim do while do cursor @@c_estoque
      close @c_estoque
      deallocate @c_estoque
      end
end;
 
 
 
 
 


select e.cd_unidade_de_n,
       e.cd_centro_armaz,
       e.cd_material,
       e.lote,
       e.qt_online,
       dbo.cgfc_est_posicao_estoque('1',
                               'Q',
                               e.cd_unidade_de_n,
                               e.cd_centro_armaz,
                               e.cd_material,
                               e.cd_especif1,
                               e.especif2,
                               e.especif3,
                               e.numeracao,
                               e.lote,
                               Dbo.cgfc_dataatual(),
                               0,
                               ' ')      
  from esestoqu e (nolock)
where e.qt_online <> dbo.cgfc_est_posicao_estoque('1',
                                               'Q',
                                               e.cd_unidade_de_n,
                                               e.cd_centro_armaz,
                                               e.cd_material,
                                               e.cd_especif1,
                                               e.especif2,
                                               e.especif3,
                                               e.numeracao,
                                               e.lote,
                                               Dbo.cgfc_dataatual(),
                                               0,
                                               ' ')
--and e.cd_centro_armaz<>' '
--and e.cd_material='500300027'
--and e.cd_unidade_de_n<> ' '