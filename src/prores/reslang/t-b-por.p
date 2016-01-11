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
/* t-b-eng.p - Portuguese language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = 'Programa,Base de Dados e Arquivo,Tempo'
    qbf-lang[ 2] = 'Arquivo de Ponto de Teste esta corrompido.  Remova arquivo .qc e recomece '
                 + 'a montagem.'
    qbf-lang[ 3] = 'Trabalhando no'     /*format x(15)*/
    qbf-lang[ 4] = 'Compilando'      /*format x(15)*/
    qbf-lang[ 5] = 'Recompilando'   /*format x(15)*/
    qbf-lang[ 6] = 'Trabalhando no arquivo,Trabalhando no formulario,Trabalhando no programa'
    qbf-lang[ 7] = 'Todos os formularios selecionados serao montados.  Use ['
                 + KBLABEL("RETURN") + '] para marcar/desmarcar.'
    qbf-lang[ 8] = 'Pressione [' + KBLABEL("GO") + '] quando feito, ou ['
                 + KBLABEL("END-ERROR") + '] para encerrar.'
    qbf-lang[ 9] = 'Examinando arquivos para montar lista inicial dos formularios de consulta...'
    qbf-lang[10] = 'Voce esta definindo formularios de consulta?'
    qbf-lang[11] = 'Achando relacoes OF envolvidas.'
    qbf-lang[12] = 'Processando lista de relacoes.'
    qbf-lang[13] = 'Nem todas juncoes (joins) podem ser determinadas.'
    qbf-lang[14] = 'Eliminando informacoes de relacoes redundantes.'
    qbf-lang[15] = 'Voce tem certeza que quer encerrar?'
    qbf-lang[16] = 'Tempo decorrido,Tempo medio'
    qbf-lang[17] = 'Lendo programa de ponto de teste...'
    qbf-lang[18] = 'Gravando programa de ponto de teste...'
    qbf-lang[19] = 'ja existe.  Ao inves de usar'
    qbf-lang[20] = 'remontando arquivo'
    qbf-lang[21] = 'Examinando formulario "~{1~}" para modificacoes.'
    qbf-lang[22] = 'Nao pode montar formulario de consulta sem RECID ou UNIQUE INDEX '
                 + 'disponivel.'
    qbf-lang[23] = 'Formulario nao modificado.'
    qbf-lang[24] = 'nao precisa recompilar.'
    qbf-lang[25] = 'Nenhum campo a esquerda no formulario.  Formulario de consulta nao foi gerado.'
    qbf-lang[26] = 'Nenhum campo a esquerda no formulario.  Existem formulario de consulta deletados.'
    qbf-lang[27] = 'Compactando arquivos disponiveis listados.'
    qbf-lang[28] = 'Tempo decorrido'
    qbf-lang[29] = 'Feito!'
    qbf-lang[30] = 'Compilacao do "~{1~}" falhou.'
    qbf-lang[31] = 'Gravando configuracao do arquivo'
    qbf-lang[32] = 'Erros foram encontrados durante a montagem e/ou estagios de compilacao.'
                 + '^^Pressione uma tecla para ver o arquivo de erros de consulta.  Linhas '
                 + 'contendo erros serao destacadas.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'nome,*nome*,contato,*contato*,Name'
    qbf-lang[ 2] = '*rua,*end,*endereco,*endereco*1,Address'
    qbf-lang[ 3] = '*caixa*postal*,*endereco*2,Address2'
    qbf-lang[ 4] = '*endereco*3'
    qbf-lang[ 5] = 'cidade,*cidade*,City'
    qbf-lang[ 6] = 'uf,estado,*estado*,St'
    qbf-lang[ 7] = 'cep,*cep*,Zip'
    qbf-lang[ 8] = 'cep*4'
    qbf-lang[ 9] = '*cec*,*cidade*uf*c*'
    qbf-lang[10] = '*pais*'

    qbf-lang[15] = 'Exemplo de Exportacao'.

/*--------------------------------------------------------------------------*/

RETURN.
