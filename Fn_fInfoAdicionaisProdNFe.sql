CREATE OR REPLACE FUNCTION fInfoAdicionaisProdNFe (pnSeqNotaFiscal                IN MFL_DOCTOFISCAL.SEQNOTAFISCAL%TYPE,
                                                   pnNROPEDVENDALICIT             IN MFLV_BASEDFITEM.NROPEDVENDALICIT%TYPE,
                                                   psOBSITEMPEDVENDALONGSTR       IN MFLV_BASEDFITEM.OBSITEMPEDVENDALONGSTR%TYPE,
                                                   psOBSITEMPedVendaComplLote     IN MFLV_BASEDFITEM.ObsItemPedVendaComplLote%TYPE,
                                                   pnSEQPRODUTO                   IN MFLV_BASEDFITEM.SEQPRODUTO%TYPE,
                                                   pnQTDEMBALAGEM                 IN MFLV_BASEDFITEM.QTDEMBALAGEM%TYPE,
                                                   psTIPOTABELA                   IN MFLV_BASEDFITEM.TIPOTABELA%TYPE,
                                                   pnVLRICMSSTDISTRIB             IN MFLV_BASEDFITEM.VLRICMSSTDISTRIB%TYPE,
                                                   pnBASICMSSTDISTRIB             IN MFLV_BASEDFITEM.BASICMSSTDISTRIB%TYPE,
                                                   pnVLRICMSOPPROPDISTRIB         IN MFLV_BASEDFITEM.VLRICMSOPPROPDISTRIB%TYPE,
                                                   pnMOTIVODESONERACAOICMS        IN MFLV_BASEDFITEM.MOTIVODESONERACAOICMS%TYPE,
                                                   pnBASCALCICMSOPPROPRIADISTRIB  IN MFLV_BASEDFITEM.BASCALCICMSOPPROPRIADISTRIB%TYPE,
                                                   psOBSITEM                      IN MFLV_BASEDFITEM.OBSITEM%TYPE,
                                                   psSERIEDF                      IN MFLV_BASEDFITEM.SERIEDF%TYPE,
                                                   pnNUMERODF                     IN MFLV_BASEDFITEM.NUMERODF%TYPE,
                                                   pnNROEMPRESA                   IN MFLV_BASEDFITEM.NROEMPRESA%TYPE,
                                                   pnNROSERIEECF                  IN MFLV_BASEDFITEM.NROSERIEECF%TYPE,
                                                   pnVLRDESCSUFRAMA               IN MFLV_BASEDFITEM.VLRDESCSUFRAMA%TYPE,
                                                   pnVLRPRODBRUTO                 IN MFLV_BASEDFITEM.VLRPRODBRUTO%TYPE,
                                                   pnVLRDESCONTO                  IN MFLV_BASEDFITEM.VLRDESCONTO%TYPE,
                                                   pnVLRDESCSF                    IN MFLV_BASEDFITEM.VLRDESCSF%TYPE,
                                                   pnVLRDESCICMS                  IN MFLV_BASEDFITEM.VLRDESCICMS%TYPE,
                                                   pnVLRICMS                      IN MFLV_BASEDFITEM.VLRICMS%TYPE,
                                                   pnBASEFCPICMS                  IN MFLV_BASEDFITEM.BASEFCPICMS%TYPE,
                                                   pnPERALIQFCPICMS               IN MFLV_BASEDFITEM.PERALIQFCPICMS%TYPE,
                                                   pnVLRFCPICMS                   IN MFLV_BASEDFITEM.VLRFCPICMS%TYPE,
                                                   pnBASEFCPST                    IN MFLV_BASEDFITEM.BASEFCPST%TYPE,
                                                   PnVLRICMSST                    IN MFLV_BASEDFITEM.VLRICMSST%TYPE,
                                                   pnPERALIQFCPST                 IN MFLV_BASEDFITEM.PERALIQFCPST%TYPE,
                                                   pnVLRFCPST                     IN MFLV_BASEDFITEM.VLRFCPST%TYPE,
                                                   psObsEmergencial               IN MAP_FAMILIA.OBSEMERGENCIAL%TYPE,
                                                   psNroFCI                       IN MRL_PRODUTOEMPRESA.NROFCI%TYPE,
                                                   pnPERCCI                       IN MRL_PRODUTOEMPRESA.PERCCI%TYPE,
                                                   psIndEmiteSTRefUltEntrada      IN MRL_CLIENTE.INDEMITESTREFULTENTRADA%TYPE,
                                                   pnIndNFIntegraFiscal           IN MFLV_BASENF.INDNFINTEGRAFISCAL%TYPE,
                                                   pnMotivoDesICMS                IN NUMBER,
                                                   pnVlrICMSDesonerado            IN NUMBER,
                                                   psUfOrigem                     IN MAX_EMPRESA.UF%TYPE)
RETURN VARCHAR2 IS
  vsPDEmiteObsEmergItemAItem      MAX_PARAMETRO.VALOR%TYPE;
  vsPDConcObsPedVdaItemInfoItem   MAX_PARAMETRO.VALOR%TYPE;
  vsPDEmiteFiguraObsItem          MAX_PARAMETRO.VALOR%TYPE;
  vsPDExibeValorIcmsUltEntItem    MAX_PARAMETRO.VALOR%TYPE;
  vsPDEmiteInforMlfNFItemObs      MAX_PARAMETRO.VALOR%TYPE;
  vsEmiteCertificadoLoteProd      MAX_PARAMETRO.VALOR%TYPE;
  vsPDExibeDescAbatSuframa        MAX_PARAMETRO.VALOR%TYPE;
  vsPDConsidVlrDescEspecialItem   MAX_PARAMETRO.VALOR%TYPE;
  vsPD_ObsVlrDeson                MAX_PARAMETRO.VALOR%TYPE;
  vsPdEmiteInfoEanProd            MAX_PARAMETRO.VALOR%TYPE;
  vsIndUtilCalcFCP                MAX_EMPRESA.INDUTILCALCFCP%TYPE;
  vsPDGeraFCI                     VARCHAR2(1);
  vsSelectResult                  VARCHAR2(500);
  vsPdEmiteInfoFCP                MAX_PARAMETRO.VALOR%TYPE;
  vsUfPessoaOrigem                TMP_M002_DESTINATARIO.M002_DS_UF%TYPE;
BEGIN

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', 0,'EMITE_OBS_EMERG_ITEM_A_ITEM','S','O',
                          'EMITE OBSERVAÇÃO EMERGÊNCIAL ITEM A ITEM NA NF? '||chr(13) ||
                          'N=NÃO EMITE OBS EMERGÊNCIAL DOS ITENS '||chr(13) ||
                          'S=SIM EMITE OBS EMERGÊNCIAL ITEM A ITEM NA NF '||chr(13) ||
                          'O=COLOCA ASTERICO NOS ITENS QUE POSSUEM OBS EMERGÊNCIAL E EMITE A OBS NOS DADOS ADICIONAIS DA NF.'||chr(13) ||
                          'VALOR PADRÃO=O',vsPDEmiteObsEmergItemAItem);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE',pnNroEmpresa,'CONC_OBSPEDVENDAITEM_INFO_ITEM','S','N',
                          'GERA OBSERVACAO INFORMADA NO ITEM DO PEDIDO DE VENDA NO CAMPO DE INFORMACAO DO ITEM (M014_DS_INFO)?'||chr(13)||
                          'S-CONCATENA COM A DESC.(SOMENTE LICITAÇÃO),'||chr(13)||
                          'T-SUBSTITUI A DESC. PELA OBSERVAÇÃO,'||chr(13)||
                          'C-CONCATENA COM A DESC. DO PROD(LIMITE 120).'||chr(13)||
                          'N-NAO(PADRAO)',
                           vsPDConcObsPedVdaItemInfoItem);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE',pnNroEmpresa,'EMITE_FIGURA_OBSITEM','S','N',
                          'INDICA SE EMITE OS DADOS DE FIGURA NA OBSEVAÇÃO DOS ÍTENS NA DANFE (S/N). '||chr(13) ||
                          'VALOR PADRÃO N',
                          vsPDEmiteFiguraObsItem);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa,'EXIBE_VALORICMSULTENT_ITEM','S','N',
                           'EXIBE BASE, VALOR ICMS ST  E VALOR DE ICMS OP. PRÓPRIA DA ÚLTIMA ENTRADA NAS OBSERVAÇÕES DO ITEM, QUANDO O CLIENTE ESTÁ CONFIGURADO PARA MRL_CLIENTE.INDEMITESTREFULTENTRADA = S ? (S - SIM / N - NÃO). VALOR PADRÃO N.',
                           vsPDExibeValorIcmsUltEntItem);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa,'EMITE_INFOR_MLF_NFITEMOBS','S','N',
                           'EMITE INFORMAÇÕES DA TABELA MLF_NFITEMOBS NA OSERVAÇÂO DO ITEM?'||chr(13) ||
                           'S = SIM'||chr(13) ||
                           'N = NÃO,'||chr(13) ||
                           'VALOR PADRÃO N',
                           vsPDEmiteInforMlfNFItemObs);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa, 'EMITE_CERTIFICADO_LOTE_PROD','S','N',
                          'EMITE CERTIFICADO VINCULADO AO LOTE NA OBSERVAÇÃO DO ITEM?' ||  chr(13) ||
                          ' ( S ) - SIM'  ||chr(13)||
                          '( N ) - NÃO'||chr(13)||
                          'PADRÃO ( N ).'  ||chr(13)||
                          'OBS: VERIFICAR CONFIGURAÇÃO ASSUMIR LOTE GERADO PELO LOCUS',
                          vsEmiteCertificadoLoteProd);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa, 'EMITE_DESC_ABAT_SUFRAMA', 'S', 'S',
                          'EMITE OBSERVAÇÃO DO VALOR DO ICMS ABATIDO (SUFRAMA) NOS DADOS ADICIONAIS DO PRODUTO/NFE?' || chr(13) || chr(10) ||
                          'S-SIM(PADRÃO)' ||chr(13) || chr(10) ||
                          'C-CONFORME ORIENTAÇÃO DE PREENCHIMENTO VERSÃO 1.05' || chr(13) || chr(10) ||
                          'N-NÃO', vsPDExibeDescAbatSuframa);

  SP_BUSCAPARAMDINAMICO('SILLUS_INTEGRA_CAPITIS', 0,'CONSID_VLR_DESC_ESPECIAL_ITEM','S','N',
                          'CONSIDERA O VLR DESC ESPECIAL CLIE NA INTEGRAÇÃO DO VLR DO ITEM P/ O FISCI(S/N)?'||chr(13) ||
                          'QDO (S) O QRP DA NF DEVERÁ SER CONFIG P/ TRATAR O VLR DO ITEM SUBTRAÍDO DESTE DESC.'||chr(13) ||
                          'OBS:USADO NA NFE. ESSE PD NÃO É APLICADO QDO DESC SF NA EMPRESA FOR GERA/NÃO GERA',
                          vsPDConsidVlrDescEspecialItem);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa,'OBS_VLR_DESON_PADRAO_DANFE','S',null,
                          'EXIBE OBSERVAÇÃO PADRÃO DO VALOR DE ICMS DESONERADO QUE SERÁ EXIBIDO NOS DADOS ADICIONAIS DANFE.'|| chr(13) || chr(10) ||
                          'CASO ESTE PARÂMETRO ESTIVER CONFIGURADO, O VALOR DE ICMS DESONERADO TAMBÉM SERÁ EXIBIDO NAS INFORMAÇÕES '|| chr(13) || chr(10) ||
                          'ADICIONAIS DO ITEM (SEM A OBSERVAÇÃO PADRÃO).' || chr(13) || chr(10) ||
                          'NULL(PADRÃO)', vsPD_ObsVlrDeson);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa, 'GERA_FCI', 'S', 'N',
                          'GERA INFORMAÇÃO DA FCI NO ITEM?' || CHR(13) || CHR(10)  ||
                          'N-NÃO GERA(PADRÃO).' || CHR(13) || CHR(10)  ||
                          'S-GERA NA INF. ADIC. DO ITEM SOMENTE O NRO DA FCI.' || CHR(13) || CHR(10) ||
                          'P-GERA NA INF. ADIC. DO ITEM O NRO DA FCI E PERC.' || CHR(13) || CHR(10) ||
                          'D-NO CAMPO PRÓPRIO DA FCI. ESSA OPÇÃO ESTA DISPONÍVEL PARA NDDIGITAL VERSÃO 4.3.2.0 OU SUPERIOR.',
                          vsPDGeraFCI);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa,'EMITE_INFO_EAN_PROD', 'S', 'N',
                          'EMITE O CÓDIGO EAN DO PRODUTO JUNTO AO GRUPO DE INFORMAÇÕES ADICIONAIS DO PRODUTO NO DANFE?'  ||
                          CHR(13) || CHR(10) || 'N - NÃO (PADRÃO).' ||
                          CHR(13) || CHR(10) || 'S - SIM.',
                          vsPdEmiteInfoEanProd);

  SP_BUSCAPARAMDINAMICO('EXPORT_NFE', pnNroEmpresa,'EMITE_INF_FCP', 'S', 'S',
                          'EMITE INFORMACOES DE FCP.'  ||
                          CHR(13) || CHR(10) || 'N - NÃO.' ||
                          CHR(13) || CHR(10) || 'S - SIM(PADRÃO).',
                          vsPdEmiteInfoFCP);


  SELECT NVL(MAX(A.INDUTILCALCFCP), 'N'),
         DECODE(MAX(B.INDGERADESCSF), 'C', vsPDConsidVlrDescEspecialItem, 'N') IND
  INTO   vsIndUtilCalcFCP,
         vsPDConsidVlrDescEspecialItem
  FROM   MAX_EMPRESA A,
         MAD_PARAMETRO B
  WHERE  A.NROEMPRESA = pnNroEmpresa
  AND    A.NROEMPRESA = B.NROEMPRESA;

  SELECT D.M002_DS_UF
  INTO   vsUfPessoaOrigem
  FROM   TMP_M002_DESTINATARIO D
  WHERE  D.M000_ID_NF = pnSeqNotaFiscal;


  SELECT TRIM(
       SUBSTR((CASE WHEN psUfOrigem = 'RJ' AND vsUfPessoaOrigem = 'RJ' AND vsPDEmiteObsEmergItemAItem = 'S' AND TRIM( psObsEmergencial ) IS NOT NULL THEN
                 fc5limpatexto( psObsEmergencial, 'DOCTOe') || ' '
                 ELSE
                   CASE WHEN psUfOrigem != 'RJ' AND vsPDEmiteObsEmergItemAItem = 'S' AND TRIM( psObsEmergencial ) IS NOT NULL THEN
                     psObsEmergencial || ' '
                     END
               END) ||
              (CASE WHEN vsPDConcObsPedVdaItemInfoItem = 'S' THEN
                 DECODE(pnNROPEDVENDALICIT, NULL, psOBSITEMPEDVENDALONGSTR, NULL)
               WHEN vsPDConcObsPedVdaItemInfoItem = 'C' THEN
                 SUBSTR(psOBSITEMPEDVENDALONGSTR, 1, 120)
               END) ||
              (CASE WHEN vsPDEmiteFiguraObsItem = 'S' AND TO_NUMBER(SUBSTR(fBuscaDadosFigura(pnSEQNOTAFISCAL, pnSEQPRODUTO, pnQTDEMBALAGEM, psTIPOTABELA, 'Q'), 1, 250)) > 0 THEN
                ' Fórmula: ' || SUBSTR(fBuscaDadosFigura(pnSEQNOTAFISCAL, pnSEQPRODUTO, pnQTDEMBALAGEM, psTIPOTABELA, 'F'), 1, 250) ||
                ' Qtde. Figuras: ' || SUBSTR(fBuscaDadosFigura(pnSEQNOTAFISCAL, pnSEQPRODUTO, pnQTDEMBALAGEM, psTIPOTABELA, 'Q'), 1, 250)
               END) ||
              (CASE WHEN (vsPDExibeValorIcmsUltEntItem  = 'S' OR vsPDExibeValorIcmsUltEntItem = 'T') AND psIndEmiteSTRefUltEntrada = 'S' THEN
                 (CASE WHEN NVL(pnVLRICMSSTDISTRIB, 0) > 0 THEN
                    ' Vlr ICMS ST Ult Entr: '|| fc5convertenumbertochar(pnVLRICMSSTDISTRIB) ||
                    ', Base ICMS ST Ult Entr: '|| fc5convertenumbertochar(pnBASICMSSTDISTRIB)
                  END) ||
                 (CASE WHEN NVL(pnVLRICMSOPPROPDISTRIB, 0) > 0 and vsPDExibeValorIcmsUltEntItem = 'S' THEN
                    ', ICMS OP.Próprio: ' || fc5convertenumbertochar(pnVLRICMSOPPROPDISTRIB) ||
                    ', Base ICMS OP.Próprio: ' || fc5convertenumbertochar(pnBASCALCICMSOPPROPRIADISTRIB)
                  END)
               END) ||
              DECODE(vsPDEmiteInforMlfNFItemObs, 'S', psOBSITEM, NULL) ||
              (CASE WHEN vsEmiteCertificadoLoteProd = 'S' THEN
                 fcBuscaCertificadoLote(
                         pnNUMERODF,
                         psSERIEDF,
                         pnNROEMPRESA,
                         pnNROSERIEECF,
                         pnSEQPRODUTO,
                         pnQTDEMBALAGEM )
               END) ||
              (CASE WHEN vsPDExibeDescAbatSuframa != 'N' AND pnVLRDESCSUFRAMA > 0 THEN
                 'Valor do ICMS abatido: R$ '|| REPLACE(fc5convertenumbertochar(pnVLRDESCSUFRAMA), '.', ',') ||
                 ' (' || ROUND((
                           pnVLRDESCSUFRAMA /
                           ( pnVLRPRODBRUTO
                             - (pnVLRDESCONTO - pnVLRDESCSUFRAMA)
                             + DECODE(vsPDConsidVlrDescEspecialItem, 'S', 0, NVL(pnVLRDESCSF, 0))
                           )
                        ) * 100) ||
                        '% sobre R$ ' ||
                 REPLACE(TRIM(TO_CHAR( pnVLRPRODBRUTO
                                       - (pnVLRDESCONTO - pnVLRDESCSUFRAMA)
                                       + DECODE(vsPDConsidVlrDescEspecialItem, 'S', 0, NVL(pnVLRDESCSF, 0)), '999999990.00' )), '.', ',') ||
                  ').' ||
                 (CASE WHEN (pnVLRDESCONTO - pnVLRDESCSUFRAMA) > 0 THEN
                    ' Valor do desconto comercial: R$ ' || REPLACE(fc5convertenumbertochar(pnVLRDESCONTO - pnVLRDESCSUFRAMA), '.', ',') || '.'
                  END)
               END) ||
              (CASE WHEN pnMOTIVODESONERACAOICMS = 9 AND pnVLRDESCICMS > 0 AND vsPD_ObsVlrDeson IS NOT NULL THEN
                 ' Valor do ICMS Desonerado: ' || fc5convertenumbertochar(pnVLRDESCICMS)
               WHEN pnMOTIVODESONERACAOICMS IN (3, 12) AND pnVLRICMS > 0 AND vsPD_ObsVlrDeson IS NOT NULL THEN
                 ' Valor do ICMS Desonerado: ' || fc5convertenumbertochar(pnVLRICMS)
               END) ||

            -- FCP ICMS
              (CASE WHEN vsIndUtilCalcFCP = 'S' AND vsPdEmiteInfoFCP = 'S' AND NVL(pnBASEFCPICMS, NVL(pnPERALIQFCPICMS, NVL(pnVLRFCPICMS, 0))) > 0 THEN
                 ' Base. FCP ICMS: ' || fc5convertenumbertochar(NVL(pnBASEFCPICMS, 0), 13) ||
                 ' - Aliq. FCP ICMS: ' || fc5convertenumbertochar(NVL(pnPERALIQFCPICMS, 0), 3) ||
                 ' - Vlr. FCP ICMS: ' || fc5convertenumbertochar(NVL(pnVLRFCPICMS, 0), 13)
               END) ||

            -- FCP ICMS ST
              (CASE WHEN vsIndUtilCalcFCP = 'S' AND vsPdEmiteInfoFCP = 'S' AND  NVL(pnBASEFCPST, NVL(pnPERALIQFCPST, NVL(pnVLRFCPST, 0))) > 0 THEN
                 ' Base FCP ST: ' || fc5convertenumbertochar(NVL(pnBASEFCPST, 0), 13) ||
                 ' - Aliq. FCP ST: ' || fc5convertenumbertochar(NVL(pnPERALIQFCPST, 0), 3) ||
                 ' - Vlr. FCP ST: ' || fc5convertenumbertochar(NVL(pnVLRFCPST, 0), 13)
               END) ||

              (CASE WHEN (psNroFCI IS NOT NULL OR pnPERCCI IS NOT NULL) AND vsPDGeraFCI != 'N' AND  vsPDGeraFCI != 'D' THEN
                 'Resolução do Senado Federal nº 13/2012' ||
                 DECODE(psNroFCI, NULL, NULL, ', Número da FCI ' || psNroFCI) ||
                 (CASE WHEN vsPDGeraFCI = 'P' THEN
                    DECODE(pnPERCCI, NULL, NULL, ', CI ' || TRIM(TO_CHAR(pnPERCCI)) || '%')
                  END) || '.'
               END) ||
              (CASE WHEN pnIndNFIntegraFiscal = 15 AND pnVLRICMSST > 0 THEN
                 ' vIcmsST = ' || fc5convertenumbertochar(pnVLRICMSST)
               END) ||
              psOBSITEMPedVendaComplLote ||
              DECODE( vsPdEmiteInfoEanProd, 'S', ' Ean: ' || fc5_NFeCodAcesso(pnNROEMPRESA, pnSEQPRODUTO, pnQTDEMBALAGEM, 'S'), NULL) ||
              (CASE WHEN pnMotivoDesICMS = 8 AND pnVlrICMSDesonerado > 0 THEN
                 ' Valor do ICMS desonerado: R$ ' || fc5ConverteNumberToChar(pnVlrICMSDesonerado)
               END), 1, 500)
         )
  INTO   vsSelectResult
  FROM   DUAL;

  vsSelectResult:= substr(vsSelectResult || ' '|| fInfoAdicionalProdNFeCust(pnSeqNotaFiscal ,pnSEQPRODUTO, pnQTDEMBALAGEM, psTIPOTABELA),1,500);

  RETURN(vsSelectResult);
END fInfoAdicionaisProdNFe;
