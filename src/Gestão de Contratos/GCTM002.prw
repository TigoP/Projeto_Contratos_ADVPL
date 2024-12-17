#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc}
    @see https://tdn.totvs.com.br/display/framework/Classe_Acervo
    @see https://tdn.totvs.com.br/display/framework/FWBrowse
    @see https://tdn.totvs.com/display/MPFormModel
    @see https://tdn.totvs.com/display/FWFormStruct
    @see https://tdn.totvs.com/display/FWFormModelStruct
    @see https://tdn.totvs.com/display/FwStrucTrigger
    @see https://tdn.totvs.com/display/FWLoadModel
    @see https://tdn.totvs.com/display/FWFormView
    @see https://tdn.totvs.com/display/FWFormCommit
    @see https://tdn.totvs.com/display/FWFormCancel
    @see https://tdn.totvs.com/display/FWModelActive
/*/
Function U_GCTM002

    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()

    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z51_TPINTE == 'V' "                       ,"BR_AMARELO" ,"Vendas"        ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'C' "                       ,"BR_LARANJA" ,"Compras"       ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'S' "                       ,"BR_CINZA"   ,"Sem Integracao",'1')
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS) ","AMARELO"    ,"Não Iniciado"  ,'2')
    oBrowse:addLegend("Z51_STATUS == 'I' "                       ,"VERDE"      ,"Iniciado"      ,'2')
    oBrowse:addLegend("Z51_STATUS == 'E' "                       ,"VERMELHO"   ,"Encerrado"     ,'2')
    oBrowse:activate()
    
Return

Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'axPesqui'        OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GCTM002' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.GCTM002' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.GCTM002' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.GCTM002' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.GCTM002' OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.GCTM002' OPERATION 9 ACCESS 0
    
Return aRotina

/*/{Protheus.doc} Contrusção interface Grafica /*/
Static Function viewdef

    Local oView
    Local oModel
    Local oStructZ51
    Local oStructZ52

    oStructZ51          :=FWFormStruct(2,'Z51' )
    oStructZ52          :=FWFormStruct(2,'Z52' )
    oModel              :=FWLoadModel('GCTM002')
    oView               :=fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z51MASTER',oStructZ51,'Z51MASTER')
    oView:addGrid('Z52DETAIL' ,oStructZ52,'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL','Z52_ITEM')
    oView:createHorizontalBox('BOXZ51',50)
    oView:createHorizontalBox('BOXZ52',50)
    oView:setOwnerView('Z51MASTER','BOXZ51')
    oView:setOwnerView('Z52DETAIL','BOXZ52')
    
Return oView

/*/{Protheus.doc} Contrução da regra de negócios /*/
Static Function Modeldef

    local oModel
    
Return oModel

