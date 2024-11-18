#include 'totvs.ch'

Function U_VARIAVEIS

	Local cTexto := 'Primeiro texto'

	Private cTexto2 := 'Segundo texto'

	teste()

	fwAlertInfo(cTexto)

Return

Static Function TESTE()

	fwAlertInfo(cTexto2)
	fwAlertInfo(cTexto)

Return

Function U_VARIAVEL

	Local xVariable
	Local cVariable
	Local dVariable
	Local nVariable
	Local lVariable
	Local bVariable
	Local oVariable
	Local aVariable

	xVariable := nil // X - variavel
	cVariable := 'Texto' // C- character
	dVariable := date() // D- date
	nVariable := 99 // N- number
	lVariable := .T. // L- logical
	bVariable := {|| alert('ok')} // B - bloco codigo
	oVariable := fwJsonObject():new() // O- object
	aVariable := array(0) // A- array

Return return_var
