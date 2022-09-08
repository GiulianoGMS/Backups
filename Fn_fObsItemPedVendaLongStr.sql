create or replace function fObsItemPedVendaLongStr(
             pnNumeroDF           in  mad_pedvendaitem.numerodf%type,
             psSerieDF            in  mad_pedvendaitem.seriedf%type,
             pnNroEmpresaDF       in  mad_pedvendaitem.nroempresadf%type,
             pnSeqProduto         in  mad_pedvendaitem.seqproduto%type,
             pnQtdEmbalagem       in  mad_pedvendaitem.qtdembalagem%type,
             pnSeqNotaFiscal      in  mfl_doctofiscal.seqnotafiscal%type,
             pnSeqItemDf          in  mfl_dfitem.seqitemdf%type) 
return varchar2
is
       vsObsItem              varchar2(500);
begin
     vsObsItem := '';
       select max(trim(substr(d.observacaoitem, 1, 500)))
       into   vsObsItem
       from   mad_pedvendaitem a, mad_pedvenda b, mfl_doctofiscal c, mfl_dfitem d
       where  a.nropedvenda  = b.nropedvenda
       and    a.nroempresa   = b.nroempresa
       and    c.nroempresa   = d.nroempresa
       and    c.numerodf     = d.numerodf
       and    c.nroserieecf  = d.nroserieecf
       and    c.seriedf      = d.seriedf
       and    (c.seqnf Is Null Or (c.seqnf = d.seqnf))
       and    b.nroempresa    = c.nroempresa
       and    b.seqpessoa    = c.seqpessoa
       and    a.numerodf      = c.numerodf
       and    a.seriedf      = c.seriedf
       and    a.seqproduto   = d.seqproduto
       and    a.numerodf     = pnNumeroDF
       and    a.seriedf      = psSerieDF
       and    a.nroempresadf = pnNroEmpresaDF
       and    a.seqproduto   = pnSeqProduto
       and    a.qtdembalagem = pnQtdEmbalagem
       and    d.seqitemdf    = pnSeqItemDf
       and    c.seqnotafiscal = pnSeqNotaFiscal
       and    a.tipotabvenda in ('V', 'T');
     return vsObsItem;
exception     
when others then
  vsObsItem:= NULL;
  return vsObsItem;
end  fObsItemPedVendaLongStr;
