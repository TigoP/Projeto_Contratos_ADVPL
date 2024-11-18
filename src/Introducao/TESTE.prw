//-- AREA DE DIRETIVA DE COMPILACAO
#include 'totvs.ch'
#include 'fwmvcdef.ch'

#define DATA_DO_DIA date()

/*/{Protheus.doc} User Function TESTE
	Exemplo de descricao
	@type Function
	@author Tigo
	@since 30/10/24
	@version 1.0
/*/

// AREA DE DECLARACAO DA FUNCAO
User Function TESTE

	//-- area de ajustes iniciais
	Local dData := DATA_DO_DIA
	Local nOpc := 1
	Local lret := .T.

	//-- CORPO DO PROGRAMA
	if dData = date()
		nOpc := 2
	endif

	private cTexto2 := 'TESTE'

	teste()

	fwAlertInfo(cTexto2)

//-- AREA DE ENCERRAMENTO
Return lret
