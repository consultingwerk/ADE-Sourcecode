/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-i-eng.p - Portuguese language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = 'exportacao,grafico,rotulo,consulta,relatorio'
  qbf-lang[ 2] = 'Digite a descricao de'
  qbf-lang[ 3] = 'Alguns dos arquivos e/ou campos foram omitidos por uma'
               + 'das seguintes razoes:^1) base de dados original nao '
               + 'conectada^2) modificacao na definicao da base de dados^3) permissao'
               + 'insuficiente'
  qbf-lang[ 4] = 'Cada ~{1~} tem que ter um unico nome.  Por favor retente.'
  qbf-lang[ 5] = 'Voce gravou entradas demais. Por favor delete algumas!  '
               + 'Deletando de qualquer diretorio do modulo desocupara espaco.'
  qbf-lang[ 6] = 'Desc----,Base de Dados,Programa-'
  qbf-lang[ 7] = 'Voce tem certeza que quer regravar'
  qbf-lang[ 8] = 'com'
  qbf-lang[ 9] = 'Escolha'
  qbf-lang[10] = 'um Formato de Exportacao,um Grafico,um Rotulo,uma Consulta,um Relatorio'
  qbf-lang[11] = 'formato de exportcao,graph,rotulo,consulta,relatorio'
  qbf-lang[12] = 'Formatos de Exportacao,Graficos,Rotulos,Consultas,Relatorios'
  qbf-lang[13] = 'Formatos de Exportacao de Dados,Graficos,Rotulos, Formatos,Consultas,'
               + 'Definicoes de Relatorios'
  qbf-lang[14] = 'para Obter,para Gravar,para Deletar'
  qbf-lang[15] = 'Trabalhando...'
  qbf-lang[16] = 'obtendo ~{1~} de outro diretorio'
  qbf-lang[17] = 'salvo como novo ~{1~}'
  qbf-lang[18] = 'nao disponivel'
  qbf-lang[19] = 'Tudo que esta marcado sera deletado.  Use ['
               + KBLABEL('RETURN') + '] para marcar/desmarcar.'
  qbf-lang[20] = 'Pressione [' + KBLABEL('GO') + '] quando feito, ou ['
               + KBLABEL('END-ERROR') + '] para nao deletar nada.'
  qbf-lang[21] = 'Movendo numero ~{1~} para a posicao ~{2~}.'
  qbf-lang[22] = 'Deletando numero ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] para selecionar, ['
               + KBLABEL("INSERT-MODE") + '] para articular, ['
               + KBLABEL("END-ERROR") + '] para encerrar.'
  qbf-lang[24] = 'Gravando no diretorio de relatorios atualizados...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = 'Este programa mostra o conteudo especifico do arquivo' 
  qbf-lang[26] = 'do diretorio local do usuario, mostrando o que gerou'
  qbf-lang[27] = 'programas correspondendo com cada relatorio definido, exportacao,'
  qbf-lang[28] = 'rotulo, e assim por diante.'
  qbf-lang[29] = 'Digite o nome completo do caminho do arquivo ".qd" do usuario:'
  qbf-lang[30] = 'Nao pode encontrar arquivo indicado.'
  qbf-lang[31] = 'Voce esqueceu a extensao ".qd".'
  qbf-lang[32] = 'Lendo diretorio...'.

RETURN.
