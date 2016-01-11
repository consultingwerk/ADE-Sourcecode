/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* t-r-por.p - Portuguese language definitions for Reports module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
/*r-header.p*/
    qbf-lang[ 1] = 'Digite expressoes para a '
    qbf-lang[ 2] = 'Linha' /* tem que ser < 8 caracteres */
                   /* 3..7 estao no formato x(64) */
    qbf-lang[ 3] = 'Estas funcoes estao disponiveis para uso no cabecalho '
                 + 'e rodape do texto'
    qbf-lang[ 4] = '~{CONTA~}  Registros lidos  :  '
                 + '~{TEMPO~}  Tempo do relatorio comecado'
    qbf-lang[ 5] = '~{HOJE~}  Data de hoje           :  '
                 + '~{AGORA~}   Hora corrente'
    qbf-lang[ 6] = '~{PAGINA~}   Numero da pagina corrente    :  '
                 + '~{USUARIO~}  Relatorio do usuario corrente'
    qbf-lang[ 7] = '~{VALUE <expressao>~;<formato>~} para inserir variaveis'
                 + ' ([' + KBLABEL("GET") + '] tecla)'
    qbf-lang[ 8] = 'Escolha um campo a inserir'
    qbf-lang[ 9] = 'Pressione [' + KBLABEL("GO") + '] para gravar, ['
                 + KBLABEL("GET") + '] para adicionar um campo, ['
                 + KBLABEL("END-ERROR") + '] para desfazer.'

/*r-total.p*/    /*"|---------------------------|"*/
    qbf-lang[12] = 'Executa estas acoes:'
                 /*"|--------------------------------------------|"*/
    qbf-lang[13] = 'Quando estes campos trocam de valores:'
                 /*"|---| |---| |---| |---| |---|" */
    qbf-lang[14] = 'Total Contado -Min- -Max- -Med-'
    qbf-lang[15] = 'Linha sumaria'
    qbf-lang[16] = 'Por campo:'
    qbf-lang[17] = 'Escolha um campo para totalizar'

/*r-calc.p*/
    qbf-lang[18] = 'Selecione coluna para Total'
    qbf-lang[19] = 'Selecione coluna para percentual do Total'
    qbf-lang[20] = 'Executando Totall'
    qbf-lang[21] = '% Total'
    qbf-lang[22] = 'String,Data,Logico,Matematico,Numerico'
    qbf-lang[23] = 'Valor'
    qbf-lang[24] = 'Digite um numero inicial para contagem'
    qbf-lang[25] = 'Digite incremento, ou um numero negativo para subtrair'
    qbf-lang[26] = 'Contadores'
    qbf-lang[27] = 'Contador'
                 /*"------------------------------|"*/
    qbf-lang[28] = '    Inicializando numero para contador' /*right justify*/
    qbf-lang[29] = '           Para cada registro,adicione' /*right justify*/
    qbf-lang[32] = 'Voce ja tem o numero maximo de colunas definidas.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN
/* r-space.p */  /*"------------------------------|  ---------|  |------"*/
    qbf-lang[ 1] = '             Opcao                Corrente   Padrao'
    /* 2..8 tem que ser menor que 32 caracteres */
    qbf-lang[ 2] = 'Margem esquerda'
    qbf-lang[ 3] = 'Espacejamento entre colunas'
    qbf-lang[ 4] = 'Linha inicial'
    qbf-lang[ 5] = 'Linhas por pagina'
    qbf-lang[ 6] = 'Espacejamento de linahs'
    qbf-lang[ 7] = 'Linhas entre cabecalho e corpo'
    qbf-lang[ 8] = 'Linhas entre corpo e rodape'
                  /*1234567890123456789012345678901*/
    qbf-lang[ 9] = 'Espacejando'
    qbf-lang[10] = 'Espacejamento de linhas tem que estar entre um e o tamanho da pagina'
    qbf-lang[11] = 'Comprimento da pagina nao pode ser negativo, por favor'
    qbf-lang[12] = 'O maximo a esquerda que o relatorio pode ir e para a coluna 1'
    qbf-lang[13] = 'Por favor guarde este valor razoavel'
    qbf-lang[14] = 'O maximo acima que o relatorio pode ir e para a linha 1'

/*r-set.p*/        /* formato x(30) para 15..22 */
    qbf-lang[15] = 'F.  Formatacoes e Rotulos'
    qbf-lang[16] = 'P.  Lanca paginas'
    qbf-lang[17] = 'T.  Totais apenas no relatorio'
    qbf-lang[18] = 'S.  Espacejamento'
    qbf-lang[19] = 'LH. Cabecalho da Esquerda'
    qbf-lang[20] = 'CH. Cabecalho do Centro'
    qbf-lang[21] = 'RH. Cabecalho da Direita'
    qbf-lang[22] = 'LF. Rodape da Esquerda'
    qbf-lang[23] = 'CF. Rodape do Centro'
    qbf-lang[24] = 'RF. Rodape da Direita'
    qbf-lang[25] = 'FO. Apenas 1a. pag. do cabecalho'
    qbf-lang[26] = 'LO. Apenas ultima pag. do cabecalho'
    qbf-lang[32] = 'Pressione [' + KBLABEL("END-ERROR")
                 + '] quando as modificaoes terminarem.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 3 THEN
  ASSIGN
    /* r-main.p,s-page.p */
    qbf-lang[ 1] = 'Arquivos:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordem:'
    qbf-lang[ 3] = 'Informacoes do Relatorio'
    qbf-lang[ 4] = 'Layout do Relatorio'
    qbf-lang[ 5] = 'mais' /* para <<mais e mais>> */
    qbf-lang[ 6] = 'Relatorio,Largura' /* each word comma-separated */
    qbf-lang[ 7] = 'Use < e > para paginar relatorio para esquerda e direita'
    qbf-lang[ 8] = 'Desculpe, nao pode gerar relatorio com largura maior que '
                 + '255 caracteres'
    qbf-lang[ 9] = 'Voce nao limpou o relatorio corrente.  Voce ainda quer '
                 + 'continuar?'
    qbf-lang[10] = 'Gerando programa...'
    qbf-lang[11] = 'Compilando programa gerado...'
    qbf-lang[12] = 'Executando programa gerado...'
    qbf-lang[13] = 'Nao pode gravar arquivo ou dispositivo'
    qbf-lang[14] = 'Voce tem certeza que quer limpar as definicoes do relatorio '
                 + 'corrente?'
    qbf-lang[15] = 'Voce tem certeza que quer encerrar este modulo?'
    qbf-lang[16] = 'Pressione ['
                 + (IF KBLABEL("CURSOR-UP") BEGINS "CTRL-" THEN 'CURSOR-UP'
                   ELSE KBLABEL("CURSOR-UP"))
                 + '] e ['
                 + (IF KBLABEL("CURSOR-DOWN") BEGINS "CTRL-" THEN 'CURSOR-DOWN'
                   ELSE KBLABEL("CURSOR-DOWN"))
                 + '] para navegar, ['
                 + KBLABEL("END-ERROR") + '] quando pronto.'
    qbf-lang[17] = 'Pagina'
    qbf-lang[18] = '~{1~} registros inclusos no relatorio.'
    qbf-lang[19] = 'Desculpe, nao pode gerar relatorio apenas com Totais quando '
                 + 'nao existir ordem por campo definida.'
    qbf-lang[20] = 'Desculpe, nao pode gerar relatorio apenas com Totais com '
                 + 'tabela de empilhacao de campo definida.'
    qbf-lang[21] = 'Apenas Totais'
    qbf-lang[23] = 'Desculpe, nao pode gerar um relatorio com campos nao definidos.'.

ELSE

/*--------------------------------------------------------------------------*/
/* FAST TRACK interface test for r-ft.p r-ftsub.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = 'FAST TRACK nao suporta saida para terminal quando'
    qbf-lang[ 2] = 'quando ativado para seleco de datas.  Saida trocada para impressora.'
    qbf-lang[ 3] = 'Analizando cabecalhos e rodapes...'
    qbf-lang[ 4] = 'Criando grupos de quebra...'
    qbf-lang[ 5] = 'Criando campos e agregacoes...'
    qbf-lang[ 6] = 'Criando arquivos e clausulas WHERE...'
    qbf-lang[ 7] = 'Criando cabecalhos e rodapes...'
    qbf-lang[ 8] = 'Criando filas-de-relaorios...'
    qbf-lang[ 9] = 'Ja existe um relatorio chamado ~{1~} no FAST TRACK.  Voce '
                 + 'quer regrava-lo?'
    qbf-lang[10] = 'Regravando relatorio...'
    qbf-lang[11] = 'Voce quer iniciar o FAST TRACK?'
    qbf-lang[12] = 'Digite um nome'
    qbf-lang[13] = 'FAST TRACK nao suporta HORA no cabecalho/rodape, '
                 + 'trocado por AGORA.'
    qbf-lang[14] = 'FAST TRACK nao suporta percentual do total, campo pulado'
    qbf-lang[15] = 'FAST TRACK nao suporta ~{1~} no cabecalho/rodape, '
                 + '~{2~} pulado.'
    qbf-lang[16] = 'Nome do relatorio so pode conter caracteres alfanumericos '
                 + 'ou under-score.'
    qbf-lang[17] = 'Nome do relatorio no FAST TRACK:'
    qbf-lang[18] = 'Relatorio nao transferido para FAST TRACK'
    qbf-lang[19] = 'Inicializando FAST TRACK, por favor aguarde...'
    qbf-lang[20] = 'Unmatched curly braces in header/footer, '
                 + 'report NOT transferred.'
    qbf-lang[21] = 'FAST TRACK nao suporta apenas primeiro/apenas ultimo cabecalhos.'
                 + '  Ignorado.'
    qbf-lang[22] = 'Atencao: Inicializando numero ~{1~} usado por contador.'
    qbf-lang[23] = 'CONTEM'
    qbf-lang[24] = 'TOTAL,CONTA,MAX,MIN,MEDIA'
    qbf-lang[25] = 'FAST TRACK nao suporta relatorio apenas com totais.  '
                 + 'Relatorio nao pode ser transferido.'
    qbf-lang[26] = 'Nao pode transferir um relatorio para o FAST TRACK quando nao ha '
                 + 'arquivos ou campos definidos.'.


ELSE

/*--------------------------------------------------------------------------*/

IF qbf-s = 5 THEN
  ASSIGN
    /* r-short.p */
    qbf-lang[ 1] = 'Definindo Relatorio apenas com Totais "danifica" o rela- '
                 + 'torio mostrando apenas informacoes sumarias.  Baseado no '
                 + 'no ultimo campo da sua lista de "Ordem", uma nova linha'
                 + 'aparecera cada vez que o valor da ordem dos campos for '
                 + 'trocada.^Para este relatorio, uma nova linha aparecera '
                 + 'cada vez que o campo ~{1~} for trocado.^Monta um rela-'
                 + 'torio apenas com Totais?'
    qbf-lang[ 2] = 'HABILITA'
    qbf-lang[ 3] = 'DESABILITA'
    qbf-lang[ 4] = 'Desculpe, voce nao pode usar a opcao "Apenas Totais" ate '
                 + 'que voce escolha a "Ordem" dos campos para sorting do seu relatorio.^^'
                 + 'Por favor escolha a ordem dos campos usando a opcao "Ordem" '
                 + 'do menu do Relatorio principal, e tente esta opcao '
                 + 'novamente.'
    qbf-lang[ 5] = 'Esta lista mostra todos os campos que voce ja '
                 + 'definiu para'
    qbf-lang[ 6] = 'este relatorio.  As marcas con asterisco serao '
                 + 'sumarizadas.'
    qbf-lang[ 7] = 'Se voce selecionar um campo numerico para sumarizar, um subtotal '
                 + 'por campo aparecera cada vez que o valor do campo ~{1~} '
                 + 'for trocado.'
    qbf-lang[ 8] = 'Se voce selecionar um campo nao numerico, uma contagem mostrara'
                 + 'o numero de registros em cada grupo ~{1~} aparecera.'
    qbf-lang[ 9] = 'Se voce nao selecionar uma campo para sumarizar, entao o valor '
                 + 'contido no ultimo registro do grupo aparecera.'

    /* r-page.p */
    qbf-lang[26] = 'Salta pagina'
    qbf-lang[27] = "nao salta pagina"

    qbf-lang[28] = 'Quando o valor em um dos seguintes campos'
    qbf-lang[29] = 'for trocado, o relatorio pode'
    qbf-lang[30] = 'automaticamente ir para uma nova pagina.'
    qbf-lang[31] = 'Escolha o campo da lista abaixo'
    qbf-lang[32] = 'onde voce quer que isto ocorra.'.

/*--------------------------------------------------------------------------*/

RETURN.
