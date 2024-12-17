#include 'totvs.ch'
#include 'tbiconn.ch'

//funções do modelo 3 para fazer telas
Function U_GCTA002

    Private cTitulo := 'Cadastro de Contratos - Prototipo Modelo 3'
    Private aRotina := array(0)

    aadd(aRotina, {'Pesquisar' ,'AxPesqui'    ,0,1}) //padrão da documentação (nome, rotina, 0 e o 1 significa pesquisar)
    aadd(aRotina, {'Visualizar','U_GCTA002M'  ,0,2})
    aadd(aRotina, {'Incluir'   ,'U_GCTA002M'  ,0,3})
    aadd(aRotina, {'Alterar'   ,'U_GCTA002M'  ,0,4})
    aadd(aRotina, {'Excluir'   ,'U_GCTA002M'  ,0,5})

   //montagem da tela Principal
    Z51->(dbSetOrder(1),mBrowse(,,,,alias()))
    
Return

Function U_GCTA002M(cAlias,nReg,nOpc) //nRecno é o botão clicado pelo usuario e nOpc é qual numero ali em cima representa

    Local oDlg
    Local aAdvSize := msAdvSize()
    Local aInfo    := {aAdvSize[1],aAdvSize[2],aAdvSize[3],aAdvSize[4],3,3}
    Local aObj     := {{100,120,.T.,.F.},{100,100,.T.,.T.},{100,010,.T.,.F.}} //largura, altura,
    Local aPObj    := msObjSize(aInfo,aObj)
    Local nSalvar  := 0
    Local nStyle   := GD_INSERT+GD_UPDATE+GD_DELETE
    Local bSalvar  := {|| if(obrigatorio(aGets,aTela),(nSalvar := 1, oDlg:end()),nil)}//se for campo obrigatorio, executa o salvar. se não, nulo
    Local bCancelar:= {|| (nSalvar := 0, oDlg:end())}
    Local aButtons := array(0)
    Local aHeader  := fnGetHeader()
    Local aCols    := fnGetCols(nOpc, aHeader)

    //Local nCampos  := Count()
    //Local cCampos  := ''
    //Local xConteudo
    //Local x

    Private oGet
    Private aGets := array(0)
    Private aTela := array(0)

    oDlg := tDialog():new(0             ,; // -- Coordenada inicial, Linha inicial (Pixels)
                          0             ,; // -- Coordenada inicial, Coluna Inicial
                          aAdvSize[6]   ,; // -- Coordenada final,  Coluna final
                          aAdvSize[5]   ,; // -- Coordenada final, Linha final
                          cTitulo       ,; // -- Titulo da Janela
                          Nil           ,; // -- Fixo
                          Nil           ,; // -- Fixo
                          Nil           ,; // -- Fixo
                          Nil           ,; // -- Fixo
                          CLR_BLACK     ,; // -- Cor do Texto
                          CLR_WHITE     ,; // -- Cor da tela de Fundo
                          Nil           ,; // -- Fixo
                          Nil           ,; // -- Fixo
                          .T.            )  // -- Indica que as coordenadas serão em pixels

            //------------ esta é uma outra forma de dizer o regToMemory abaixo
    //for x := 1 to nCampos
    //    cCampos     := fieldname(x)
    //    cConteudo   := if(nOpc == 3,criavar(cCampo,.T.,.T.), fieldget(x))
    //    M->&(cCampo):= xConteudo // substitui as aspas pelo conteudo de uma variavel declarada
    //next

            // --------------------------------- Area Cabeçalho -----------------------------------
    regToMemory(cAlias,if(nOpc == 3,.T.,.F.),.T.) 
    M->Z51_NUMERO := if(nOpc == 3, getSxeNum('Z51','Z51_NUMERO'),Z51->Z51_NUMERO)
    msmGet():new(cAlias,nReg,nOpc,,,,,aPObj[1])
    // enchoice(cAlias,nReg,nOpc,,,,,aPObj[1]) //enchoice é um outro jeito de fazer o mget de cima
    enchoiceBar(oDlg,bSalvar,bCancelar,,aButtons)

            // --------------------------------- Area Itens -----------------------------------
    oGet := msNewGetDados():new(aPObj[2,1]     ,; // -- Coordenada inicial, Linha inicial 
                                aPObj[2,2]     ,; // -- Coordenada inicial, Coluna Inicial
                                aPObj[2,3]     ,; // -- Coordenada final,  Coluna final
                                aPObj[2,4]     ,; // -- Coordenada final, Linha final
                                nStyle         ,; // -- opções que podem ser executadas
                                'U_GCTA002V(1)',; // -- validação da mudança de linha
                                'U_GCTA002V(2)',; // -- validação final
                                '+Z52_ITEM'    ,; // -- definição do campo incremental
                                nil            ,; // -- lista dos campos que podem ser alterados
                                0              ,; // -- fixo
                                9999           ,; // -- total de linhas
                                'U_GCTA002V(3)',; // -- valida cada campo preenchido
                                nil            ,; // -- fixo
                                'U_GCTA002V(4)',; // -- funcao que valida se pode deletar
                                oDlg           ,; // -- objeto prorietario
                                aHeader        ,; // -- vetor com configuração de campos
                                aCols           )  // -- vetor com conteudo dos campos

    oDlg:activate() //ativa a tela assim que a encontra e a abre

    if nSalvar = 1
        // -- função de gravação de dados
        fnGravar(nOpc, aHeader,oGet:aCols)

        if __lSX8
            confirmSX8() //isto salva o numero para o sequencial
        endif
    else
        if __lSX8
            rollbackSX8()
        endif
    endif

Return

/*/{Protheus.doc} 
valida linhas do Grid
/*/
Function U_GCTA002V(nOpcao)

    Local lValid := .T.

    if nOpcao == 1 // -- mudança de linha

        lValid := oGet:chkObrigat(n) //-- n é o numero de linhas

    elseif nOpcao == 2 // -- validação final
        
    elseif nOpcao == 3 // -- valida cada campo preenchido
        
    elseif nOpcao == 4 // -- funcao que valida se pode deletar
        
    endif

Return lValid

/*/{Protheus.doc} 
Função auxiliar para gravação
/*/
Static Function fnGravar(nOpc,aHeader,aCols)

    Local x,y
    Local nCampos
    Local cCampo
    Local xConteudo
    Local aLinha := [0]
    Local lDelete
    Local lFound

    BEGIN TRANSACTION

    Do Case

        Case nOpc == 3 // -- Inclusao

            nCampos := Z51->(fCount()) //recebe a quantidade de campos que possui

            // -- gravacao dos dados do cabeçalho
            Z51->(reclock(alias(),.T.))

                for x := 1 to nCampos
                    Z51->&(fieldname(x)) := M->&(fieldname(x))
                next

                Z51->Z51_FILIAL := xFilial('Z51')

            Z51->(msunlock())

            // gravacao dos dados dos itens
            for x := 1 to Len(aCols)

                lFound  := Z52->(Found())

                aLinha  := aClone(aCols[x])
                lDelete := aLinha[Len(aLinha)]

                if lDelete
                    Loop
                endif

                Z52->(reclock(alias(),.T.))

                    for y := 1 to Len(aHeader)
                        cCampo          := aHeader[y,2]
                        xConteudo       := aCols[x,y]
                        Z52->&(cCampo)  := xConteudo
                    next

                    Z52->Z52_FILIAL     := xFilial('Z52')
                    Z52->Z52_NUMERO     := M->Z51_NUMERO

                Z52->(msunlock())

            next
            
        Case nOpc == 4 // -- Alteração

            nCampos := Z51->(fCount()) //recebe a quantidade de campos que possui

            Z51->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z51_NUMERO))

            // -- gravacao dos dados do cabeçalho
            Z51->(reclock(alias(),.F.))

                for x := 1 to nCampos
                    Z51->&(fieldname(x)) := M->&(fieldname(x))
                next

                Z51->Z51_FILIAL := xFilial('Z51')

            Z51->(msunlock())

            // -- gravação dos itens
            for x := 1 to Len(aCols)

                // posiciona no registro
                Z52->(dbSetOrder(1),dbSeek(xFilial(alias())+M->Z51_NUMERO+aCols[x,1]))

                aLinha  := aClone(aCols[x])
                lDelete := aLinha[Len(aLinha)]

                if lDelete

                    if Z52->(Found())
                        Z52->(reclock(alias(),.F.),dbDelete(),msunlock())
                    endif

                    Loop

                endif

                lInc := .not. lFound

                Z52->(reclock(alias(),lInc))

                    for y := 1 to Len(aHeader)
                        cCampo          := aHeader[y,2]
                        xConteudo       := aCols[x,y]
                        Z52->&(cCampo)  := xConteudo
                    next

                    Z52->Z52_FILIAL     := xFilial('Z52')
                    Z52->Z52_NUMERO     := M->Z51_NUMERO

                Z52->(msunlock())

            next

        Case nOpc == 5 // -- Exclusao

            Z52->(dbSetOrder(1),dbSeek(xFilial(alias())+Z51->Z51_NUMERO))

            while .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
                Z52->(reclock(alias(),.F.), dbDelete(),msunlock(),dbSkip())
            enddo

            Z51->(reclock(alias(),.F.), dbDelete(), msunlock())
            
    EndCase

    END TRANSACTION
    
Return

/*/{Protheus.doc} fnGetHeader
    Função que gera as configurações dos campos da msNerGetDados
/*/
Static Function fnGetHeader

    Local aHeader := array(0)
    Local aAux    := array(0)

    SX3->(dbSetOrder(1),dbSeek("Z52"))

    while .not. SX3->(eof()) .and. SX3->X3_ARQUIVO == 'Z52'

        if allTrim(SX3->X3_CAMPO) $ 'Z52_FILIAL|Z52_NUMERO'
            SX3->(dbSkip())
            Loop
        endif
        
        aAux := {}
        aadd(aAux,SX3->X3_TITULO  )
        aadd(aAux,SX3->X3_CAMPO   )
        aadd(aAux,SX3->X3_PICTURE )
        aadd(aAux,SX3->X3_TAMANHO )
        aadd(aAux,SX3->X3_DECIMAL )
        aadd(aAux,SX3->X3_VALID   )
        aadd(aAux,SX3->X3_USADO   )
        aadd(aAux,SX3->X3_TIPO    )
        aadd(aAux,SX3->X3_F3      )
        aadd(aAux,SX3->X3_CONTEXT )
        aadd(aAux,SX3->X3_CBOX    )
        aadd(aAux,SX3->X3_RELACAO )
        aadd(aAux,SX3->X3_WHEN    )
        aadd(aAux,SX3->X3_VISUAL  )
        aadd(aAux,SX3->X3_VLDUSER )
        aadd(aAux,SX3->X3_PICTVAR )
        aadd(aAux,SX3->X3_OBRIGAT )

        aadd(aHeader,aAux)
        SX3->(dbSkip())
    enddo
    
Return aHeader

/*/{Protheus.doc}
    retorna o conteudo do vetor aCols
/*/
Static Function fnGetCols(nOpc,aHeader)

    Local aCols := array(0)
    Local aAux  := array(0)

    if nOpc == 3 // inclusão
        aEval(aHeader,{|x| aadd(aAux,criavar(x[2],.T.))})
        aAux[1] := '001'
        aadd(aAux,.F.)
        aadd(aCols,aAux)
        Return aCols
    endif

    // --- alteração + visualização + exclusão
    Z52->(dbSetOrder(1),dbSeek(Z51->(Z51_FILIAl+Z51_NUMERO)))

    while .not. Z52->(eof()) .and. Z52->(Z52_FILIAL+Z52_NUMERO) == Z51->(Z51_FILIAL+Z51_NUMERO)
        aAux := {}
        aEval(aHeader,{|x| aadd(aAux,Z52->&(x[2]))})
        aadd(aAux,.F.)
        aadd(aCols,aAux)
        Z52->(dbSkip())
    enddo
    
Return aCols

