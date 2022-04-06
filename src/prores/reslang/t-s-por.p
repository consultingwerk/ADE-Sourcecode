/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-s-por.p - Portuguese language definitions for general system use */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/

/* l-edit.p,s-edit.p */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Insere'
    qbf-lang[ 2] = 'Voce tem certeza que quer encerrar sem salvar as alteracoes?'
    qbf-lang[ 3] = 'Digite o nome do arquivo a marginar'
    qbf-lang[ 4] = 'Digite a string de escolha'
    qbf-lang[ 5] = 'Selecione o campo a inserir'
    qbf-lang[ 6] = 'Pressione [' + KBLABEL("GO") + '] para salvar, ['
		 + KBLABEL("GET") + '] para adicionar o campo, ['
		 + KBLABEL("END-ERROR") + '] para desfazer.'
    qbf-lang[ 7] = 'String escolhida nao encontrada.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-ask.p,s-where.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Igual'
    qbf-lang[ 2] = 'Diferente'
    qbf-lang[ 3] = 'Menor que'
    qbf-lang[ 4] = 'Menor ou Igual'
    qbf-lang[ 5] = 'Maior que'
    qbf-lang[ 6] = 'Maior ou Igual'
    qbf-lang[ 7] = 'Comeca'
    qbf-lang[ 8] = 'Contem'    /* must match [r.4.23] */
    qbf-lang[ 9] = 'Escolhas'

    qbf-lang[10] = 'Seleciona um campo'
    qbf-lang[11] = 'Expressao'
    qbf-lang[12] = 'Entra um valor'
    qbf-lang[13] = 'Comparacoes'

    qbf-lang[14] = 'No run-time, questiona o usuario por um valor.'
    qbf-lang[15] = 'Digite a questao referida no run-time:'

    qbf-lang[16] = 'Questiona por' /* data-type */
    qbf-lang[17] = 'Valor'

    qbf-lang[18] = 'Pressione [' + KBLABEL("END-ERROR") + '] para encerrar.'
    qbf-lang[19] = 'Pressione [' + KBLABEL("END-ERROR") + '] para desfazer o ultimo passo.'
    qbf-lang[20] = 'Pressione [' + KBLABEL("GET") + '] para o modulo Expert.'

    qbf-lang[21] = 'Selecione o tipo de comparacao para montar o arquivo.'

    qbf-lang[22] = 'Digite o valor ~{1~} para comparar com "~{2~}".'
    qbf-lang[23] = 'Por favor digite o valor ~{1~} por "~{2~}".'
    qbf-lang[24] = 'Pressione [' + KBLABEL("PUT")
		 + '] para prontificar por um valor no run-time.'
    qbf-lang[25] = 'Contexto: valor ~{1~} e ~{2~} algum ~{3~}.'

    qbf-lang[27] = 'Desculpe, mas o "Modulo Expert" nao e compativel com "questiona '
		 + 'por um valor no run-time".  Voce pode usar um ou outro.'
    qbf-lang[28] = 'Nao deve ser um valor desconhecido!'
    qbf-lang[29] = 'Digite mais valores para' /* '?' acrescentar a string */
    qbf-lang[30] = 'Entra com mais criterios de selecao?'
    qbf-lang[31] = 'Combina usando os criterios pre-selecionados?'
    qbf-lang[32] = 'Modulo Mode'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
/* s-info.p, s-format.p */
    qbf-lang[ 1] = 'Ordem de'  /* s-info.p automatically right-justifies */
    qbf-lang[ 2] = 'e de'    /*   1..9 and adds colons for you. */
    qbf-lang[ 3] = 'Arquivo'      /* but must fit in format x(24) */
    qbf-lang[ 4] = 'Relacao'
    qbf-lang[ 5] = 'Onde'
    qbf-lang[ 6] = 'Campo'
    qbf-lang[ 7] = 'Expresssao'
    qbf-lang[ 9] = 'Encobre valores repetidos?'

    qbf-lang[10] = 'FROM,BY,FOR'
    qbf-lang[11] = 'Voce ainda nao selecionou nenhum arquivo!'
    qbf-lang[12] = 'Formatos e Rotulos'
    qbf-lang[13] = 'Formatos'
    qbf-lang[14] = 'Escolha um campo' /* also used by s-calc.p below */
    /* 15..18 must be format x(16) (see notes on 1..7) */
    qbf-lang[15] = 'Rotulo'
    qbf-lang[16] = 'Formato'
    qbf-lang[17] = 'Base de Dados'
    qbf-lang[18] = 'Tipo'
    qbf-lang[19] = 'Tempo decorrido na ultima execucao,minutos:segundos'
    qbf-lang[20] = 'Expressoes nao podem ter valor desconhecido (?)'

/*s-calc.p*/ /* there are many more for s-calc.p, see qbf-s = 5 thru 8 */
/*s-calc.p also uses #14 */
    qbf-lang[27] = 'Construtor de expressoes'
    qbf-lang[28] = 'Expressao'
    qbf-lang[29] = 'Continua adicionando a esta expressao?'
    qbf-lang[30] = 'Operacao de Selecao'
    qbf-lang[31] = 'data de hoje'
    qbf-lang[32] = 'valor constante'.

ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 4 THEN
  ASSIGN
/*s-help.p*/
    qbf-lang[ 1] = 'Desculpe, nenhuma ajuda esta disponivel para esta opcao.'
    qbf-lang[ 2] = 'Ajuda'

/*s-order.p*/
    qbf-lang[15] = 'asc/desc' /*neither can be over 8 characters */
    qbf-lang[16] = 'Para cada componente, digite "a" para'
    qbf-lang[17] = 'ascendente ou "d" para descendente.'

/*s-define.p*/
    qbf-lang[21] = 'W. Largura/Formato dos campos'
    qbf-lang[22] = 'F. Campos'
    qbf-lang[23] = 'A. Arquivos ativos'
    qbf-lang[24] = 'T. Totais e Subtotais'
    qbf-lang[25] = 'R. Executando Total'
    qbf-lang[26] = 'P. Percentual do Total'
    qbf-lang[27] = 'C. Contadores'
    qbf-lang[28] = 'M. Expressoes matematicas'
    qbf-lang[29] = 'S. Expressoes String'
    qbf-lang[30] = 'N. Expressoes Numericas'
    qbf-lang[31] = 'D. Expressoes de Data'
    qbf-lang[32] = 'L. Expressoes Logicas'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - string expressions */
IF qbf-s = 5 THEN
  ASSIGN
    qbf-lang[ 1] = 's,Constante ou Campo,s00=s24,~{1~}'
    qbf-lang[ 2] = 's,Substring,s00=s25n26n27,SUBSTRING(~{1~}'
		 + ';INTEGER(~{2~});INTEGER(~{3~}))'
    qbf-lang[ 3] = 's,Combina duas Strings,s00=s28s29,~{1~} + ~{2~}'
    qbf-lang[ 4] = 's,Combina tres Strings,s00=s28s29s29,'
		 + '~{1~} + ~{2~} + ~{3~}'
    qbf-lang[ 5] = 's,Combina quatro Strings,s00=s28s29s29s29,'
		 + '~{1~} + ~{2~} + ~{3~} + ~{4~}'
    qbf-lang[ 6] = 's,Menos de duas Strings,s00=s30s31,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 's,Mais de duas Strings,s00=s30s31,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 8] = 's,Largura da String,n00=s32,;LENGHT(~{1~})'
    qbf-lang[ 9] = 's,ID do Usuario,s00=,USERID("RESULTSDB")'
    qbf-lang[10] = 's,Tempo Atual,s00=,STRING(TIME;"HH:MM:SS")'

    qbf-lang[24] = 'Digite o nome do campo a incluir como uma coluna no seu '
		 + 'relatorio, ou selecione <<valor constante>> para inserir um '
		 + 'valor constante de string no relatorio.'
    qbf-lang[25] = 'SUBSTRING permite extrair uma parte de um caracter da '
		 + 'string para mostrar.  Selecione um nome de campo.'
    qbf-lang[26] = 'Digite a posicao do caracter inicial'
    qbf-lang[27] = 'Digite o numero de caracteres para extrair'
    qbf-lang[28] = 'Selecione o primeiro valor'
    qbf-lang[29] = 'Selecione o proximo valor'
    qbf-lang[30] = 'Selecione a primeira entrada para comparar'
    qbf-lang[31] = 'Selecione a segunda entrada para comparar'
    qbf-lang[32] = 'O numero retornado corresponde a largura da '
		 + 'string selecionada.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - numeric expressions */
IF qbf-s = 6 THEN
  ASSIGN
    qbf-lang[ 1] = 'n,Constante ou Campos,n00=n26,~{1~}'
    qbf-lang[ 2] = 'n,Menor de dois Numeros,n00=n24n25,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 3] = 'n,Maior de dois Numeros,n00=n24n25,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 4] = 'n,Resto,n00=n31n32,~{1~} MODULO ~{2~}'
    qbf-lang[ 5] = 'n,Valor inteiro,n00=n27,'
		 + '(IF ~{1~} < 0 THEN - ~{1~} ELSE ~{1~})'
    qbf-lang[ 6] = 'n,Arredonda,n00=n28,ROUND(~{1~};0)'
    qbf-lang[ 7] = 'n,Trunca,n00=n29,TRUNCATE(~{1~};0)'
    qbf-lang[ 8] = 'n,Raiz Quadrada,n00=n30,SQRT(~{1~})'
    qbf-lang[ 9] = 'n,Mostra Hora,s00=n23,STRING(INTEGER(~{1~});"HH:MM:SS")'

    qbf-lang[23] = 'Selecione um campo a ser mostrado como HH:MM:SS'
    qbf-lang[24] = 'Selecione a primeira entrada para comparar'
    qbf-lang[25] = 'Selecione a segunda entrada para comparar'
    qbf-lang[26] = 'Digite o nome do campo a ser incluso como uma coluna no seu '
		 + 'relatorio, ou selecione <<valor constante>> para inserir um'
		 + 'valor de constante numerica no relatorio.'
    qbf-lang[27] = 'Selecione um campo a ser mostrado (nao assinalado) com valor'
		 + 'inteiro.'
    qbf-lang[28] = 'Selecione um campo a ser arredondado mais proximo do numero inteiro.'
    qbf-lang[29] = 'Selecione um campo a ser arredondado a menos (remocao da parte '
		 + 'fracional).'
    qbf-lang[30] = 'Selecione um campo para ser raiz quadrada.'
    qbf-lang[31] = 'Depois de dividir um numero por um quociente, este e '
		 + 'arredondado.  Que valor voce quer arredondar?'
    qbf-lang[32] = 'Divide pelo que?'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - date expressions */
IF qbf-s = 7 THEN
  ASSIGN
    qbf-lang[ 1] = 'd,Data atual,d00=,TODAY'
    qbf-lang[ 2] = 'd,Adiciona dias ao valor da data,d00=d22n23,~{1~} + ~{2~}'
    qbf-lang[ 3] = 'd,Subtrai dias do valor da data,d00=d22n24,~{1~} - ~{2~}'
    qbf-lang[ 4] = 'd,Diferenca entre duas datas,n00=d25d26,~{1~} - ~{2~}'
    qbf-lang[ 5] = 'd,Antecipacao de duas datas,d00=d20d21,MINIMUM(~{1~};~{2~})'
    qbf-lang[ 6] = 'd,Prorrogacao de duas datas,d00=d20d21,MAXIMUM(~{1~};~{2~})'
    qbf-lang[ 7] = 'd,Dia do mes,n00=d27,DAY(~{1~})'
    qbf-lang[ 8] = 'd,Mes do ano,n00=d28,MONTH(~{1~})'
    qbf-lang[ 9] = 'd,Nome do mes,s00=d29,ENTRY(MONTH(~{1~});"Janeiro'
		 + ';Fevereiro;Marco;Abril;Maio;Junho;Julho;Agosto;Setembro'
		 + ';Outubro;Novembro;Dezembro")'
    qbf-lang[10] = 'd,Valor do ano,n00=d30,YEAR(~{1~})'
    qbf-lang[11] = 'd,Dia da semana,n00=d31,WEEKDAY(~{1~})'
    qbf-lang[12] = 'd,Nome do dia da semana,s00=d32,ENTRY(WEEKDAY(~{1~});"'
		 + 'Domingo;Segunda;Terca;Quarta;Quinta;Sexta;Sabado")'

    qbf-lang[20] = 'Selecione a primeira entrada para comparar'
    qbf-lang[21] = 'Selecione a segunda entrada para comparar'
    qbf-lang[22] = 'Selecione um cmapo data.'
    qbf-lang[23] = 'Selecione um campo que contenha o numero de dias a ser '
		 + 'adicionado nesta data.'
    qbf-lang[24] = 'Selecione um campo que contenha o numero de dias a ser '
		 + 'subtraido desta data.'
    qbf-lang[25] = 'Compara dois valores de data e mostra a diferenca entre '
		 + 'eles, em dias, como uma coluna.  Escolha o '
		 + 'primeiro campo.'
    qbf-lang[26] = 'Agora escolha o segundo campo data.'
    qbf-lang[27] = 'Retorna o dia do mes como um numero de '
		 + '1 a 31.'
    qbf-lang[28] = 'Retorna o mes do ano como um numero de '
		 + '1 a 12.'
    qbf-lang[29] = 'Retorna o nome do mes.'
    qbf-lang[30] = 'Retorna a porcao do ano da data como um inteiro.'
    qbf-lang[31] = 'Retorna um numero do dia da semana, Domingo comecando com 1.'
    qbf-lang[32] = 'Retorna o nome do dia da semana.'.

ELSE

/*--------------------------------------------------------------------------*/

/* s-calc.p - mathematical expressions */
IF qbf-s = 8 THEN
  ASSIGN
    qbf-lang[ 1] = 'm,Adiciona,n00=n25n26m...,~{1~} + ~{2~}'
    qbf-lang[ 2] = 'm,Subtrai,n00=n25n27m...,~{1~} - ~{2~}'
    qbf-lang[ 3] = 'm,Multiplica,n00=n28n29m...,~{1~} * ~{2~}'
    qbf-lang[ 4] = 'm,Divide,n00=n30n31m...,~{1~} / ~{2~}'
    qbf-lang[ 5] = 'm,Traz o calculo,n00=n25n32m...,EXP(~{1~};~{2~})'

    qbf-lang[25] = 'Digite o primeiro numero'
    qbf-lang[26] = 'Digite o proximo numero a adicionar'
    qbf-lang[27] = 'Digite o proximo numero a subtrair'
    qbf-lang[28] = 'Digite o primeiro multiplicador'
    qbf-lang[29] = 'Digite o proximo multiplicador'
    qbf-lang[30] = 'Digite o quociente'
    qbf-lang[31] = 'Digite o divisor'
    qbf-lang[32] = 'Calcula'.

/*--------------------------------------------------------------------------*/

RETURN.
