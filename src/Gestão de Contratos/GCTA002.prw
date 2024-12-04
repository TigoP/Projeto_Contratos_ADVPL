#include 'totvs.ch'

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
    Local nCampos  := Count()
    Local cCampos  := ''
    Local xConteudo
    Local x

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
                          .T.           )  // -- Indica que as coordenadas serão em pixels

    for x := 1 to nCampos
        cCampos     := fieldname(x)
        cConteudo   := if(nOpc == 3,criavar(cCampo,.T.,.T.), fieldget(x))
        M->&(cCampo):= xConteudo // substitui as aspas pelo conteudo de uma variavel declarada
    next

    //regToMemory(cAlias,if(nOpc ==3,.T.,.F.),.T.) // esta é uma outra forma de dizer o for ai de cima

    oDlg:activate() //ativa a tela assim que a encontra e a abre

Return
