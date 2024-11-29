#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM001
    @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE
    @see https://tdn.totvs.com.br/display/framework/Classe_Acervo
    @see https://tdn.totvs.com.br/display/framework/FWMBrowse
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/FwStruTrigger
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
    @see https://tdn.totvs.com/display/framework/FWFormCommit
    @see https://tdn.totvs.com/display/framework/FWFormCancel
    @see https://tdn.totvs.com/display/framework/FWModelActive
    /*/

//-------------------------------------MODELO MVC---------------------

Function U_GCTM001 // -- FUNÇÃO PRINCIPAL--

    Private aRotina := menudef() //é obrigatorio
    Private oBrowse := fwMbrowse():New() //padrão do MVC

    oBrowse:setAlias( 'Z50' ) //faz automaticamente o dbselectarea e o dbsetorder
    oBrowse:setDescription( 'Tipos de Contratos' ) //titulo 
    oBrowse:setExecuteDef(2) //ação ao apertar duplo cliques
    oBrowse:addLegend("Z50_TIPO == 'V' ", "BR_AMARELO","Vendas")
    oBrowse:addLegend("Z50_TIPO == 'C' ", "BR_LARANJA","Compras")
    oBrowse:addLegend("Z50_TIPO == 'S' ", "BR_CINZA" ,"Sem Integracao")
    oBrowse:activate() //abre a tela para utilização
    
Return

/*/---------------------------------------M------------------------------------ TRATA DAS MONTAGENS DOS MENUS -------------------------------------/*/
Static Function menudef //-- 1/3 STATICS PRINCIPAIS --

    Local aRotina   := array(0) //precisa ter uma variavel local e retornar

 // comandos  |variavel|  titulo tela   |comando |nome do programa |opcao     |padrao 0
    ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'axPesqui'        OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GCTM001' OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.GCTM001' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.GCTM001' OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.GCTM001' OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.GCTM001' OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.GCTM001' OPERATION 9 ACCESS 0
    
Return aRotina //precisa retornar para utilizar na função principal

/*/---------------------------------------V------------------------------------ TRATA DAS INTERFACES GRAFICAS -------------------------------------/*/
Static Function viewdef //-- 2/3 STATICS PRINCIPAIS --

    Local oView // -- 1/3 variaveis obrigatorias
    Local oModel // -- 2/3 variaveis obrigatorias
    Local oStruct // --3/3 variaveis obrigatorias

    oStruct := FWFormStruct(2, 'Z50' ) //1 (1-se retornar modeldef. 2-se retornar viewdef) 2 (o alias)
    oModel  := FWLoadModel( 'GCTM001' ) //nome do arquivo no model
    oView   := FWFormView():New() //instancia do view

    oView:setModel(oModel)
    oView:addField( 'Z50MASTER' ,oStruct, 'Z50MASTER' ) //(identificação;estrutura de tabelas;qual componente do model ele é)
    oView:createHorizontalBox( 'BOXZ50' ,100) //area da interface que receberá os campos. 2 parametros: nome e tamanho da tela
    oView:setOwnerView( 'Z50MASTER' , 'BOXZ50' ) // vincula o objeto field com o objeto box 
    
Return oView //obrigaorio

/*/---------------------------------------C------------------------------------ TRATA DAS REGRAS DE NEGOCIO -------------------------------------/*/
Static Function modeldef //-- 3/3 STATICS PRINCIPAIS --

    Local oModel
    Local oStruct
    Local aTrigger
    Local bModelPre := {|x| fnModPre(x)}
    Local bModelPos := {|x| fnModPos(x)}
    Local bCommit   := {|x| fnCommit(x)}
    Local bCancel   := {|x| fnCancel(x)}

    oStruct         := FWFormStruct(1, 'Z50' )
    oModel          := mpFormModel():New('MODEL_GCTM001',bModelPre,bModelPos,bCommit,bCancel)

    aTrigger        := FwStruTrigger( 'Z50_TIPO' , 'Z50_CODIGO' , 'U_GCTT001()' ,.F.,Nil,Nil,Nil,Nil) //nils são: alias, chave de busca, condição, sequencia

    oStruct:addTrigger(aTrigger[1],aTrigger[2],aTrigger[3],aTrigger[4])
    oStruct:setProperty( 'Z50_TIPO' ,MODEL_FIELD_WHEN,{|| INCLUI})

    oModel:addFields( 'Z50MASTER' ,,oStruct)
    oModel:setDescription( 'Tipos de Contratos' )
    oModel:setPrimaryKey({'Z50_FILIAL', 'Z50_CODIGO'})
    
Return oModel

Static Function fnModPre(oModel)

    Local lValid    := .T.
    Local nOperator := oModel:getOperation()
    Local cCampo    := strtran(readvar(),"M->","")

    if nOperator == 4

        if cCampo == 'Z50_DESCRI'
            oModel:setErrorMessage(,,,,'ERRO DE VALIDACAO','ESTE CAMPO NAO PODE SER EDITADO!')
            lValid := .F.
        endif
    
    endif
    
Return lValid

Static Function fnModPos(oModel)

    Local lValid := .T.
    Local cAliasSQL := ''
    Local lExist    := .F.
    Local nOperator := oModel:getOperation()

    if nOperator == 5
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
                oModel:setErrorMessage(,,,,'Registro já Utilizado','Não pode excluir, pois já foi utilizado!')
            Return .F.
        endif        
    endif
    
Return lValid

Static Function fnCommit(oModel)

    Local lCommit := fwFormCommit(oModel,/*bBefore*/,/*bAfter*/,/*bAfterTTS*/,/*bInTTS*/,/*bBeforeTTS*/,/*bIntergEAI*/)

    if .not. lCommit
        oModel:setErrorMessage(,,,,'Gravação não Efetuada','Ocorreu um ero na gravação dos dados')
    endif
    
Return lCommit

Static Function fnCancel(oModel)

    Local lCancel := FWFormCancel(oModel)
    
Return lCancel

/*/{Protheus.doc} função que gera gatilho /*/
Function U_GCTT001

    Local cNovoCod  := ''
    Local cAliasSQL := ''
    Local oModel    := FWModelActive() // retorna o model ativo no momento
    Local nOperator := 0

    nOperator       := oModel:getOperation()

    if .not. (nOperator == 3 .or. nOperator == 9)
        cNovoCod := oModel:getModel( 'Z50MASTER' ):getValue( 'Z50_CODIGO' )
        Return cNovoCod
    endif

    cAliasSQL := getNextAlias()

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z50_CODIGO),'00') Z50_CODIGO //coalece é uma pergunta "is null" se não, retorna 00
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO = %exp:M->Z50_TIPO%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}),dbCloseArea())

    if cNovoCod == '00'
        cNovoCod := M->Z50_TIPO + '01'
    else
        cNovoCod := soma1(cNovoCod)
    endif
    
Return cNovoCod
