create or replace function consinco.fObsItemPedVendaLongStr(
             pnNumeroDF           in  mad_pedvendaitem.numerodf%type,
             psSerieDF            in  mad_pedvendaitem.seriedf%type,
             pnNroEmpresaDF       in  mad_pedvendaitem.nroempresadf%type,
             pnSeqProduto         in  mad_pedvendaitem.seqproduto%type,
             pnQtdEmbalagem       in  mad_pedvendaitem.qtdembalagem%type)
return varchar2
is
       vsObsItem              varchar2(500);
begin
     vsObsItem := '';
       select max(trim(substr(a.observacaoitem, 1, 500)))
       into   vsObsItem
       from   mad_pedvendaitem a, mad_pedvenda b
       where  a.nropedvenda  = b.nropedvenda
       and    a.nroempresa   = b.nroempresa
       and    a.numerodf     = pnNumeroDF
       and    a.seriedf      = psSerieDF
       and    a.nroempresadf = pnNroEmpresaDF
       and    a.seqproduto   = pnSeqProduto
       and    a.qtdembalagem = pnQtdEmbalagem
       and    a.tipotabvenda in ('V', 'T');
     return vsObsItem;
end  fObsItemPedVendaLongStr;
