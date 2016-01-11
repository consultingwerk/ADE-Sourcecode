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
/* t-c-eng.p - Portuguese language definitions for Scrolling Lists */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*
As of [Thu Apr 25 15:13:33 EDT 1991], this
is a list of the scrolling list programs:
  u-browse.i     c-print.p
  b-pick.p       i-pick.p
  c-entry.p      i-zap.p
  c-field.p      s-field.p
  c-file.p       u-pick.p
  c-flag.p       u-print.p
  c-form.p
*/

/* c-entry.p,c-field.p,c-file.p,c-form.p,c-print.p,c-vector.p,s-field.p */
ASSIGN
  qbf-lang[ 1] = 'Selecione arquivo para juntar ou pressione ['
               + KBLABEL("END-ERROR") + '] para encerrar.'
  qbf-lang[ 2] = 'Pressione [' + KBLABEL("GO") + '] quando feito, ['
               + KBLABEL("INSERT-MODE") + '] para articular, ['
               + KBLABEL("END-ERROR") + '] para encerrar.'
  qbf-lang[ 3] = 'Pressione [' + KBLABEL("END-ERROR")
               + '] para parar a selecao de arquivos.'
  qbf-lang[ 4] = 'Pressione [' + KBLABEL("GO") + '] quando feito, ['
               + KBLABEL("INSERT-MODE")
               + '] para articular descricao/arquivo/programa.'
  qbf-lang[ 5] = 'Rotulo/Nome-'
  qbf-lang[ 6] = 'Descricao/Nome'
  qbf-lang[ 7] = 'Arquivo,Programa,Descricao'
  qbf-lang[ 8] = 'Procurando campos disponiveis...'
  qbf-lang[ 9] = 'Escolha Campos'
  qbf-lang[10] = 'Seleciona Arquivos'
  qbf-lang[11] = 'Seleciona Arquivo Relatado'
  qbf-lang[12] = 'Seleciona Formulario de Consulta'
  qbf-lang[13] = 'Seleciona Dispositivo de Saida'
  qbf-lang[14] = 'Juncao' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '   Base de Dados' /* max length 16 */
  qbf-lang[17] = '         Arquivo' /* max length 16 */
  qbf-lang[18] = '           Campo' /* max length 16 */
  qbf-lang[19] = ' Extensao Maxima' /* max length 16 */
  qbf-lang[20] = 'O valor'
  qbf-lang[21] = 'esta fora do intervalo de 1 ate'
  qbf-lang[22] = 'Checa a existencia de arquivo?'
  qbf-lang[23] = 'Nao pode usar esta opcao com a destinacao de saida especificada'
  qbf-lang[24] = 'Digite o nome do arquivo de saida'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = 'Deixe branco para os elementos arranjados em pilha, ou digite'
  qbf-lang[28] = 'uma lista separada por virgulas de elementos arranjados individualmente'
  qbf-lang[29] = 'para incluir lado a lado no relatorio.'
  qbf-lang[30] = 'Digite uma lista separada por virgulas de elementos arranjados'
  qbf-lang[31] = 'para incluir lado a lado como campos.'
  qbf-lang[32] = 'Digite o indexador do elemento arranjado para usar.'.

RETURN.
