#include 'totvs.ch'
/*/                                         {Protheus.doc}
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=24346981 (mBrowse)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23889143 (axPesqui)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23889145 (axVisual)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23888941 (axInclui)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23889132 (axAltera)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23889138 (axDeleta)
    @see http: //tdn.totvs.com/pages/viewpage.action?pageId=23889136 (axCadastro)
    /*/
Function U_GCTA001

    Local NopcPad := 4
    Local aLegenda := {}

    Private cCadastro := 'Cadastro de Tipos de Contratos' //recebe o titulo
    Private aRotina   := {}

    aadd(aLegenda, {"Z50_TIPO == 'V'","BR_AMARELO"})
    aadd(aLegenda, {"Z50_TIPO == 'C'","BR_LARANJA"})
    aadd(aLegenda, {"Z50_TIPO == 'S'","BR_CINZA"})

    aadd(aRotina, {"Pesquisar" , "axPesqui"  , 0, 1}) //padrão da documentação (nome, rotina, 0 e o 1 significa pesquisar)
    aadd(aRotina, {"Visualizar", "axVisual"  , 0, 2})
    aadd(aRotina, {"Incluir"   , "axInclui"  , 0, 3})
    aadd(aRotina, {"Alterar"   , "axAltera"  , 0, 4})
    aadd(aRotina, {"Excluir"   , "U_GCTA001D", 0, 5})
    aadd(aRotina, {"Legendas"  , "U_GCTA001L", 0, 6})

    dbSelectArea("Z50")
    dbSetOrder(1)

    mBrowse(,,,,alias(),,,,,nOpcPad,aLegenda) //padrão. Recebe linha inicial, coluna inicial, linha final, coluna final e o alias(no caso Z50) as outras , são outros paramentros até chegar no nopc
    
Return

Function U_GCTA001D

    Local cAliasSQL := ''
    Local lExist    := .F.

    cAliasSQL       := getNextAlias()

    BeginSQL alias cAliasSQL
        SELECT * FROM %table:Z51% Z51 //selecione a tabela z51
        WHERE Z51.%notdel% //está retirando da consulta os deletados
        AND Z51_FILIAL = %exp:Filial('Z51')% //está assegurando que vai pegar somente da filial corrente
        AND Z51_TIPO = %exp:Z50->Z50_CODIGO%
        LIMIT 1 //limitado somente a primeira linha
    EndSQL

    (cAliasSQL)->(dbEval({|| lExist := .T.}),dbCloseArea())//aqui indica que: se o select encontrou alguma linha preenchida, existe movimento na tabela

    if lExist
        fwAlertWarning('Tipo de Contrato ja utilizado!','Atenção')
        Return .F.
    endif
    
Return axDeleta(cAlias,nReg,nOpc) //são padrões do axDeleta da totvs

Function U_GCTA001L

    Local aLegenda := array(0)

    aadd(aLegenda, {"BR_AMARELO", "Contrato de Vendas" })
    aadd(aLegenda, {"BR_LARANJA", "Contrato de Compras"})
    aadd(aLegenda, {"BR_CINZA"  , "Sem integração"     })
    
Return brwLegenda("Tipos de Contratos","Legenda",aLegenda)//o brwLegenda é função que recebe, 1:titulo,2:subtitulo,3:retorno
