/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-eng.p - Portuguese language definitions for Data Export module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* d-edit.p,a-edit.p */
IF qbf-s = 1 THEN
/*
When entering codes, the following methods may be used:
  'x' - literal character enclosed in single quotes.
  ^x  - interpreted as control-character.
  ##h - one or two hex digits followed by the letter "h".
  ### - one, two or three digits, a decimal number.
  xxx - "xxx" is a symbol such as "lf" from the following table.
 */
  ASSIGN
    qbf-lang[ 1] = 'e um simbolo tal qual'
    qbf-lang[ 2] = 'da seguinte tabela.'
    qbf-lang[ 3] = 'Pressione [' + KBLABEL("GET")
                 + '] para tornar o Modo Especialista ativado ou nao.'
    /* format x(70): */
    qbf-lang[ 4] = '\Quando entrar codigos, estes metodos podem ser usados e combinados '
                 + 'livremente:'
    /* format x(60): */
    qbf-lang[ 5] = 'caracter literal junto em aspas unicas.'
    qbf-lang[ 6] = 'interpretado como caracter de controle.'
    qbf-lang[ 7] = 'um ou dois digitos em hexa seguidos da letra "h".'
    qbf-lang[ 8] = 'um, dois ou tres digitos, um numero decimal.'
    qbf-lang[ 9] = 'e um codigo desconhecido.  Por favor corrija.'
    qbf-lang[10] = 'Processando definicoes de controle de impressoras...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Arquivos:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordem:'
    qbf-lang[ 3] = 'Informacoes de Exportacao de Dados'
    qbf-lang[ 4] = 'Gabarito de Exportacao de Dados'
    qbf-lang[ 5] = 'Campos:,      :,      :,      :,      :'
    qbf-lang[ 7] = '    Tipo de Exportacao:'
    qbf-lang[ 8] = 'Cabecalhos:'
    qbf-lang[ 9] = '   (nomes exportados como primeiro registro)'
    qbf-lang[10] = '   Comeco de regitro:'
    qbf-lang[11] = '     Fim de Registro:'
    qbf-lang[12] = 'Delimitador de Campo:'
    qbf-lang[13] = '  Separador de Campo:'
    qbf-lang[14] = 'Exportacao de Dados nao suporta a exportacao do arranjo '
                 + 'armazenado.  Se voce continuar, eles serao eliminados da '
                 + 'exportacao.^Voce deseja continuar?'
    qbf-lang[15] = 'Desculpe, nao pode exportar dados sem definir campos.'
    qbf-lang[21] = 'Voce nao restaurou o formato de exportacao corrente.  '
                 + 'Voce ainda quer continuar?'
    qbf-lang[22] = 'Gerando programa de exportacao...'
    qbf-lang[23] = 'Compilando programa de exportacao...'
    qbf-lang[24] = 'Executando programa gerado...'
    qbf-lang[25] = 'Nao pode gravar para arquivo ou dispositivo'
    qbf-lang[26] = '~{1~} registros exportados.'
    qbf-lang[31] = 'Voce tem certeza que quer desativar as configuracoes de exportacao?'
    qbf-lang[32] = 'Voce tem certeza que quer encerrar este modulo?'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,Exportacao do PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,ASCII generico'
    qbf-lang[ 3] = 'ASCII-H ,ASCII com cabecalho de nome de campo'
    qbf-lang[ 4] = 'FIXADO   ,Lagura fixada ASCII (SDF)'
    qbf-lang[ 5] = 'VSV     ,Valor separado por virgulas (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word para Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,Usuario'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
