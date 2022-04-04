
use [db_dwsiasg]
SET LANGUAGE Português
SELECT 
		-- identificação da licitação --
		substring([DS_CMPR_COMPRA_EDIT],9,5)+'/'+substring([DS_CMPR_COMPRA_EDIT],14,4) as licitacao,
		
		-- ItemCompra --
		D_ItemCompra.CH_ITCP_ITEM_COMPRA as Identificação_ItemCompra,
		D_ItemCompra.DS_ITCP_ITEM_COMPRA as Descrição_ItemCompra,
		D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] as Descrição_Complementar_ItemCompra,

		-- Compra --
		D_Compra.DS_CMPR_COMPRA as Identificação_Compra,
		--substring([DS_CMPR_COMPRA_EDIT],9,9) in ('001162010','000202011','000362010'),fitem
		D_Compra.DS_CMPR_OBJETO_COMPRA as Objeto_Compra,
		convert(char,D_Compra.DT_CMPR_RESULTADO_COMPRA,103) as Data_resultado_Compra,	
		D_ModalComp.DS_CMPR_MODALIDADE_COMPRA as Modalidade_Licitação, 
		
		
		-- Material_Serviço
		F_ItemCompraFornec.ID_ITCP_TP_COD_MAT_SERV as Codigo_MaterialServico,
		D_MaterialServico.DS_ITCP_MATERIAL_SERVICO as Descricao_MaterialServico,
		D_TipoMaterialServico.DS_ITCP_TP_MATERIAL_SERVICO as Tipo_MaterialServico,

		-- Unidade --
		substring(D_ItemCompra.CH_ITCP_ITEM_COMPRA_EDIT, 1, 6) as Cod_Unidade,
		D_Unidade.NO_UNDD_UNIDADE as Nome_Unidade,	
		D_Unidade.ID_LCAL_UF_UNIDADE as UF_Unidade,
		--D_Unidade.ID_LCAL_REGIAO_UNIDADE as Regiao_Unidade,
		substring('00000', 1, 5-len(D_Orgao.ID_UNDD_ORGAO)) + D_Orgao.ID_UNDD_ORGAO as Cod_Orgao,
		D_Orgao.DS_UNDD_ORGAO as Nome_Orgao,
		substring('00000', 1, 5-len(D_OrgaoSup.ID_UNDD_ORGAO_SUP)) + D_OrgaoSup.ID_UNDD_ORGAO_SUP as Cod_OrgaoSup,
		D_OrgaoSup.DS_UNDD_ORGAO_SUP as Nome_OrgaoSup,

		-- Fornecedor
		F_ItemCompraFornec.ID_FRND_FORNECEDOR_COMPRA as Cpf_Cnpj_Fornecedor,
		D_Fornecedor.NO_FRND_FORNECEDOR as Nome_Fornecedor,
		D_Municipio.DS_LCAL_MUNICIPIO as Municipio_Fornecedor,
		D_Fornecedor.ID_LCAL_UF_FORNEC as UF_Fornecedor,
		case 
         when F_ItemCompraFornec.VL_PRECO_UNIT_HOMOLOG = 0 then 'Não'
		   else 'Sim' 
      end as Fornecedor_venceu_licitacao,
		-- Lances
		F_ItemCompraFornec.VL_ULT_LANCE AS Valor_Ultimo_Lance,
		F_ItemCompraFornec.QT_OFERTADA AS Qtd_Ofertada,
		convert(char,F_ItemCompraFornec.DT_ULT_LANCE_FORNEC,103) AS Data_Ultimo_Lance,
		
		-- Métrica -- 
		F_ItemCompraFornec.VL_PRECO_TOTAL_HOMOLOG AS Valor_Total_Homologado,
		F_ItemCompraFornec.[VL_PRECO_UNIT_HOMOLOG] AS Valor_Unitario_Homologado,
		F_ItemCompraFornec.[VL_ULT_LANCE] AS Valor_Ultimo_Lance
		
		-- Campos Extras
		--UPPER(DATENAME(month, D_Compra.DT_CMPR_RESULTADO_COMPRA)) as Mes_Resultado_Compra,
		--year(D_Compra.DT_CMPR_RESULTADO_COMPRA) as Ano_Resultado_Compra,
		--UPPER(DATENAME(month, F_ItemCompraFornec.DT_ULT_LANCE_FORNEC)) as Mes_Ultimo_Lance,
		--year(F_ItemCompraFornec.DT_ULT_LANCE_FORNEC) as Ano_Ultimo_Lance,

	--	D_Poder.DS_UNDD_PODER as Poder_Unidade,
	--	D_Esfera.DS_UNDD_ESFERA as Esfera_Unidade
		
		

	FROM F_ITEM_FORNECEDOR F_ItemCompraFornec
		
		
		--- COMPRA ----	
		LEFT JOIN
		D_CMPR_COMPRA D_Compra
		ON F_ItemCompraFornec.ID_CMPR_COMPRA = D_Compra.ID_CMPR_COMPRA	

		LEFT JOIN
		D_CMPR_MODALIDADE_COMPRA D_ModalComp
		ON D_Compra.ID_CMPR_MODALIDADE_COMPRA = D_ModalComp.ID_CMPR_MODALIDADE_COMPRA 

		--- ITEM COMPRA ----	
		LEFT JOIN
		D_ITCP_ITEM_COMPRA D_ItemCompra
		ON F_ItemCompraFornec.ID_ITCP_ITEM_COMPRA = D_ItemCompra.ID_ITCP_ITEM_COMPRA 
		
		---	MATERIAL SERVIÇO ----	
		LEFT JOIN
		D_ITCP_MATERIAL_SERVICO D_MaterialServico ON F_ItemCompraFornec.ID_ITCP_TP_COD_MAT_SERV = D_MaterialServico.ID_ITCP_TP_COD_MAT_SERV 

		LEFT JOIN
		D_ITCP_TP_MATERIAL_SERVICO D_TipoMaterialServico
		ON D_TipoMaterialServico.ID_ITCP_TP_MATERIAL_SERVICO = D_MaterialServico.ID_ITCP_TP_MATERIAL_SERVICO  

		--- UNIDADE ----		
		LEFT JOIN
		D_UNDD_UNIDADE D_Unidade
		ON substring(D_ItemCompra.CH_ITCP_ITEM_COMPRA_EDIT , 1, 6) = substring('000000', 1, 6-len(D_Unidade.CD_UNDD_UNIDADE)) + D_Unidade.CD_UNDD_UNIDADE 

		LEFT JOIN
		D_UNDD_ORGAO D_Orgao
		ON D_Unidade.ID_UNDD_ORGAO = D_Orgao.ID_UNDD_ORGAO

		LEFT JOIN
		dbo.D_UNDD_ORGAO_SUP D_OrgaoSup
		ON D_Unidade.ID_UNDD_ORGAO_SUP = D_OrgaoSup.ID_UNDD_ORGAO_SUP

		LEFT JOIN
		dbo.D_UNDD_ESFERA D_Esfera 
		ON D_Unidade.ID_UNDD_ESFERA = D_Esfera.ID_UNDD_ESFERA

		LEFT JOIN
		dbo.D_UNDD_PODER D_Poder 
		ON D_Unidade.ID_UNDD_PODER = D_Poder .ID_UNDD_PODER

		--- FORNECEDOR ----	
		LEFT JOIN
		dbo.D_FRND_FORNECEDOR D_Fornecedor
		ON F_ItemCompraFornec.ID_FRND_FORNECEDOR_COMPRA = D_Fornecedor.ID_FRND_FORNECEDOR

		LEFT JOIN
		dbo.D_LCAL_MUNICIPIO D_Municipio
		ON D_Fornecedor.ID_LCAL_MUNICIPIO_FORNEC = D_Municipio.ID_LCAL_MUNICIPIO

		where  
		
		 F_ItemCompraFornec.ID_ITCP_TP_COD_MAT_SERV in (1000113026, 1000150375, 1000198960, 1000074365, 2000003697, 1000137499, 1000047686, 1000056154) --??
		-- and D_Unidade.ID_LCAL_UF_UNIDADE='RJ'
		and  F_ItemCompraFornec.VL_PRECO_UNIT_HOMOLOG>0
		and year(F_ItemCompraFornec.DT_ULT_LANCE_FORNEC) > 2011
		 
		and [VL_PRECO_UNIT_HOMOLOG]<>0 and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] like '%suco%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] like '%200%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] like '%ml%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] like '%caix%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] not like '%kit%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] not like '%pão%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] not like '%bolo%' and 
      D_ItemCompra.[DS_ITCP_COMPL_ITEM_COMPRA] not like '%lanche%'
		--order by year(F_ItemCompraFornec.DT_ULT_LANCE_FORNEC)
		order by (F_ItemCompraFornec.[VL_PRECO_UNIT_HOMOLOG]) DESC
      