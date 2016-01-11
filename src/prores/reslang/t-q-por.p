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
/* t-q-por.p - Portuguese language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Nenhum registro encontrado usando este criterio.'
    qbf-lang[ 2] = 'Configuracao total,Juncao,Subconjunto'
    qbf-lang[ 3] = 'Mostra tudo,Em cima,Em baixo'
    qbf-lang[ 4] = 'Nao existem indices definidos para este arquivo.'
    qbf-lang[ 5] = 'Voce tem certeza que quer deletar este registro?'
    qbf-lang[ 6] = '' /* mensagem total especial: criado do #7 ou #8 */
    qbf-lang[ 7] = 'Operacao Total parada.'
    qbf-lang[ 8] = 'Total de registros disponiveis e '
    qbf-lang[ 9] = 'Executando Total...   Pressione [' + KBLABEL("END-ERROR")
                 + '] para parar.'
    qbf-lang[10] = 'Iguais,e menor que,e menor que ou igual a,'
                 + 'e maior que,e maior que ou igual a,'
                 + 'e diferente de,Corresponde,Comeca'
    qbf-lang[11] = 'Nao ha registros atualmente disponiveis.'
    qbf-lang[13] = 'Voce ja esta esta no primeiro registro do arquivo.'
    qbf-lang[14] = 'Voce ja esta no ultimo registro do arquivo.'
    qbf-lang[15] = 'Nao ha formularios de consulta definidos.'
    qbf-lang[16] = 'Consulta'
    qbf-lang[17] = 'Por favor selecione o nome do formulario de consulta a usar.'
    qbf-lang[18] = 'Pressione [' + KBLABEL("GO")
                 + '] ou [' + KBLABEL("RETURN")
                 + '] para selecionar formulario, ou [' + KBLABEL("END-ERROR")
                 + '] para encerrar.'
    qbf-lang[19] = 'Buscando formulario de consulta...'
    qbf-lang[20] = 'O formulario de consulta compilado esta perdido para este programa.  '
                 + 'O problema pode ser:^1) PROPATH errado,^2) programa '
                 + '.r danificado, or^3) programa .r nao compilado.^(Cheque o '
                 + 'arquivo <dbname>.ql para erros de compilacao).^^Voce pode'
                 + 'tentar continuar, mas isto pode ocasionar uma mensagem de erro.  '
                 + 'Voce insiste em continuar?'
    qbf-lang[21] = 'Ha uma clausula WHERE para a consulta corrente que '
                 + 'contem valores que sao requisitados no RUN-TIME.  Isto nao e '
                 + 'suportado no modulo de Consulta.  Ignora clausula WHERE '
                 + 'e continua?'
    qbf-lang[22] = 'Pressione [' + KBLABEL("GET")
                 + '] para configurar campos paginados.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = 'Proximo,Proximo registro.'
    qbf-lang[ 2] = 'Anterior,Registro anterior.'
    qbf-lang[ 3] = 'Primeiro,Primeiro registro.'
    qbf-lang[ 4] = 'Ultimo,Ultimo registro.'
    qbf-lang[ 5] = 'Inclui,Inclui um novo registro.'
    qbf-lang[ 6] = 'Atualiza,Atualiza o registro corrente mostrado.'
    qbf-lang[ 7] = 'Copia,Copia o registro corrente mostrado a um novo registro.'
    qbf-lang[ 8] = 'Deleta,Deleta o registro corrente mostrado.'
    qbf-lang[ 9] = 'Estrutura,Estrutura um formulario de consulta diferente.'
    qbf-lang[10] = 'Pagina,Pagina por entre uma lista de registros.'
    qbf-lang[11] = 'Juncao,Junta registros relatados.'
    qbf-lang[12] = 'Consulta,Consulta por uma selecao de registros exemplificados.'
    qbf-lang[13] = 'Where,Editor de clausula WHERE de selecao de registros.'
    qbf-lang[14] = 'Total,Numero de registros na atual configuracao ou subconfiguracao.'
    qbf-lang[15] = 'Ordem,Seleciona um outro indice.'
    qbf-lang[16] = 'Modulo,Seleciona um outro modulo.'
    qbf-lang[17] = 'Info,Informacoes das atuais configuracoes.'
    qbf-lang[18] = 'Uso,Transfere para outra opcao de uso.'
    qbf-lang[19] = 'Encerra,Encerra.'
    qbf-lang[20] = ''. /* terminator */

RETURN.
