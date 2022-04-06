/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-l-por.p - Portuguese language definitions for Labels module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* l-guess.p:1..5,l-verify.p:6.. */
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Selecinando "~{1~}" para campo "~{2~}"...'
    qbf-lang[ 2] = 'Nenhum campo foi encontrado usando a selecao automatica.'
    qbf-lang[ 4] = 'Configurando rotulo dos campos'
    qbf-lang[ 5] = 'nome,endereco #1,endereco #2,endereco #3,cidade,'
                 + 'estado,cep+4,cep,cidade-estado-cep,pais'

    qbf-lang[ 6] = 'Linha ~{1~}: Chave perdida ou desequilibrada.'
    qbf-lang[ 7] = 'Linha ~{2~}: Incapaz de encontrar campo "~{1~}".'
    qbf-lang[ 8] = 'Linha ~{2~}: Campo "~{1~}", nao e um arranjo de campo.'
    qbf-lang[ 9] = 'Linha ~{2~}: Campo "~{1~}", extent ~{3~} fora do intervalo.'
    qbf-lang[10] = 'Linha ~{2~}: Campo "~{1~}", do arquivo nao selecionado.'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    /* each entry of 1 and also 2 must fit in format x(6) */
    qbf-lang[ 1] = 'Arquivos:,     :,     :,     :,     :'
    qbf-lang[ 2] = 'Ordem:'
    qbf-lang[ 3] = 'Informacoes do rotulo'
    qbf-lang[ 4] = 'Forma do rotulo'
    qbf-lang[ 5] = 'Escolhe um campo'
    /*cannot change length of 6 thru 17, right-justify 6-11,13-14 */
    qbf-lang[ 6] = 'Omite linhas em branco:'
    qbf-lang[ 7] = '  Copias de cada:'
    qbf-lang[ 8] = '  Altura total:'
    qbf-lang[ 9] = '    Topo da margem:'
    qbf-lang[10] = ' Espacejamento de texto para texto:'
    qbf-lang[11] = '   Estruturacao da margem esquerda:'
    qbf-lang[12] = '(largura)'
    qbf-lang[13] = '   Texto da etiqueta'
    qbf-lang[14] = '   e campos'
    qbf-lang[15] = 'Numero de         ' /* 15..17 used as group.   */
    qbf-lang[16] = 'Rotulos            ' /*   do not change length, */
    qbf-lang[17] = 'Atraves de:      ' /*        but do right-justify  */
    qbf-lang[19] = 'Voce nao pode reestruturar o rotulo corrente.  '
                 + 'Voce ainda quer continuar?'
    qbf-lang[20] = 'Sua altura de rotulo e ~{1~}, mas voce tem ~{2~} linhas '
                 + 'definidas.  Alguma informacao nao se enquadrara no tamanho do rotulo '
                 + 'que voce definiu, e, assim, nao sera impressa.  '
                 + 'Voce ainda quer continuar e imprimir estes rotulos?'
    qbf-lang[21] = 'Nao ha etiqueta texto ou campos para imprimir!'
    qbf-lang[22] = 'Gerando programas de etiqueta...'
    qbf-lang[23] = 'Compilando programa de etiquetas...'
    qbf-lang[24] = 'Executando programa gerado...'
    qbf-lang[25] = 'Nao pode gravar para arquivo ou dispositivo'
    qbf-lang[26] = '~{1~} etiquetas impressas.'
    qbf-lang[27] = 'F. Campos'
    qbf-lang[28] = 'A. Arquivos ativos'
    qbf-lang[29] = 'Poderia este programa tentar selecionar os campos para os '
                 + 'rotulos automaticamente?'
    qbf-lang[31] = 'Voce tem certeza que quer reestruturar estas configuracoes?'
    qbf-lang[32] = 'Voce tem certeza que quer encerrar este modulo?'.

ELSE

/*--------------------------------------------------------------------------*/
/* l-main.p */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'Se mais do que um rotulo de largura, espacejamento de texto tem que ser > 0'
    qbf-lang[ 2] = 'Topo da margem nao pode ser negativo'
    qbf-lang[ 3] = 'Altura total tem que ser maior que um'
    qbf-lang[ 4] = 'Numero de rotulos de largura tem que ser no minimo um'
    qbf-lang[ 5] = 'Numero de copias tem que ser no minimo um'
    qbf-lang[ 6] = 'Margem esquerda nao pode ser negativa'
    qbf-lang[ 7] = 'Espacejamento de texto tem quer ser maior que um'
    qbf-lang[ 8] = 'Move as linhas inferiores para cima quando a linha estiver em branco'
    qbf-lang[ 9] = 'Numero de linhas do topo do rotulo para a primeira linha da impressao'
    qbf-lang[10] = 'Altura total do rotulo medido em linhas'
    qbf-lang[11] = 'Numero da largura do rotulo'
    qbf-lang[12] = 'Numero de copias de cada rotulo'
    qbf-lang[13] = 'Numero de espacos da borda do rotulo para a primeira posicao de impressao'
    qbf-lang[14] = 'Distancia da borda esquerda de um rotulo ate a proxima borda'.

/*--------------------------------------------------------------------------*/

RETURN.
