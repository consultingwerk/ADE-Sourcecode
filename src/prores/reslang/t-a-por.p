/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-a-por.p - Portuguese language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'Q. Consulta'
    qbf-lang[ 2] = 'R. Relatorios'
    qbf-lang[ 3] = 'L. Rotulos'
    qbf-lang[ 4] = 'D. Exportacao'
    qbf-lang[ 5] = 'U. Usuario'
    qbf-lang[ 6] = 'A. Administracao'
    qbf-lang[ 7] = 'E. Encerra'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'O Arquivo' /*DBNAME.qc*/
    qbf-lang[11] = 'nao foi encontrado.  Isto significa que voce precisa fazer um "Initial'
                 + ' Build" nesta Base de Dados.  Voce quer fazer isto agora?'
    qbf-lang[12] = 'Selecione novo modulo ou pressione [' + KBLABEL("END-ERROR")
                 + '] para ficar no modulo corrente.'
    qbf-lang[13] = 'Voce nao adquiriu o RESULTS.  Programa encerrado.'
    qbf-lang[14] = 'Voce tem certeza que quer encerrar "~{1~}" agora?'
    qbf-lang[15] = 'MANUAL,SEMI,AUTO'
    qbf-lang[16] = 'Nao existem Base de Dados conectadas.'
    qbf-lang[17] = 'Nao pode executar quando uma Base de Dados tem um nome logico '
                 + 'comecando com "QBF$".'
    qbf-lang[18] = 'Encerra'
    qbf-lang[19] = '** RESULTS esta confuso **^^No diretorio ~{1~}, '
                 + 'nem ~{2~}.db nem ~{2~}.qc pode ser encontrado.  ~{3~}.qc '
                 + 'nao foi encontrado no PROPATH, mas parece pertencer  ao'
                 + '~{3~}.db.  Por favor corrija seu PROPATH ou renomeie/delete '
                 + '~{3~}.db e .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Existem tres maneiras de construir um relatorio de consultas para '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTS.  A qualquer momento depois da construcao do RESULTS '
                 + 'formularios de consulta,'
    qbf-lang[23] = '         voce pode faze-lo manualmente.'
    qbf-lang[25] = 'Voce quer manualmente definir cada formulario de consulta.'
    qbf-lang[27] = 'Depois que voce selecionou um subconjunto de arquivos das'
    qbf-lang[28] = 'Base de Dados conectadas, RESULTS gerara apenas formularios de consulta para'
    qbf-lang[29] = 'os arquivos selecionados.'
    qbf-lang[31] = 'RESULTS gerara todos os formularios de consulta automaticamente.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Digite o nome do arquivo include a ser usado pela'
    qbf-lang[ 2] = 'Opcao de Paginacao no modulo de Consulta.'
    qbf-lang[ 3] = '   Arquivo include padrao:' /*format x(24)*/

    qbf-lang[ 8] = 'Nao pode encontrar programa'

    qbf-lang[ 9] = 'Digite o nome do programa selecionado.  Este programa pode' 
                 + 'ser tanto'
    qbf-lang[10] = 'um simples logo, ou um procedimento de identificacao similar ao '
                 + '"login.p"'
    qbf-lang[11] = 'no diretorio "DLC".  Este programa e executado tao '
                 + 'logo a '
    qbf-lang[12] = 'linha "signon=" for lida do arquivo DBNAME.qc. '
    qbf-lang[13] = 'Digite o nome do produto a ser mostrado'
    qbf-lang[14] = 'no Menu Principal.'
    qbf-lang[15] = '        Programa selecionado:' /*format x(24)*/
    qbf-lang[16] = '           Nome do Produto:' /*format x(24)*/
    qbf-lang[17] = 'Padroes:'

    qbf-lang[18] = 'Procedimento de usuario PROGRESS:'
    qbf-lang[19] = 'Este programa e executado quando a opcao "Usuario" e selecionada '
                 + 'de algum menu.'

    qbf-lang[20] = 'Isto permite que um programa de exportacao do usuario seja usado.'
    qbf-lang[21] = 'Por favor digite o nome do procedimento e a descricao'
    qbf-lang[22] = 'para o menu "Exportacao".'
    qbf-lang[23] = 'Procedimento:'
    qbf-lang[24] = 'Descricao:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
   ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Traz,obtem um ~{1~} definido previamente.'
    qbf-lang[ 2] = 'Salva,Salva o ~{1~} corrente.'
    qbf-lang[ 3] = 'Executa,Executa o ~{1~} corrente.'
    qbf-lang[ 4] = 'Define,Seleciona arquivos e campos.'
    qbf-lang[ 5] = 'Configuracoes,Troca tipo, formata ou configura o ~{1~} corrente.'
    qbf-lang[ 6] = 'Onde,editor de clausula WHERE, selecao de registros.'
    qbf-lang[ 7] = 'Ordem,Troca a ordem de saida para registros.'
    qbf-lang[ 8] = 'Limpa,Limpa o ~{1~} definido currentemente.'
    qbf-lang[ 9] = 'Info,Informacoes das definicoes correntes.'
    qbf-lang[10] = 'Modulo,Seleciona um modulo diferente.'
    qbf-lang[11] = 'Usuario,Transfere para uma opcao personalizada.'
    qbf-lang[12] = 'Encerra,Encerra.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'exporta,rotulo,relatorio'

    qbf-lang[15] = 'Lendo configuracao do arquivo...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '  Continua' /* for error dialog box */
    qbf-lang[19] = 'Portugues' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = 'faz'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Executando Total,Percentual do Total,Func Count,String Expr,'
                 + 'Expr Data,Expr Numerica,Expr Logica,Tabela Stacked'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = '  Sim   ,  Nao  ' /* for yes/no dialog box */

    qbf-lang[25] = 'Uma montagem automatica estava sendo executada e foi interrompida.  '
                 + 'Continua com a montagem automatica?'

    qbf-lang[26] = '* CUIDADO - Versao incorreta *^^Versao corrente e '
                 + '<~{1~}> enquanto arquivo .qc e para versao <~{2~}>.  Podem '
                 + 'haver problemas ate que os formularios de Consulta sejam regenerados com '
                 + '"Reparacao da Aplicacao".'

    qbf-lang[27] = '* CUIDADO - Base de Dados perdidas *^^A Base de Dados '
                 + 'referida precisa, mas nao esta conectada:'

    qbf-lang[32] = '* CUIDADO - Dicionario modificado *^^A estrutura da Base de Dados '
                 + 'foi modificada desde que algum formulario de consulta foi criado.  '
                 + 'Por favor use a "Reparacao da Aplicacao" do menu '
                 + 'de Administracao tao logo for possivel.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " A. Reparacao da Aplicacao"
    qbf-lang[ 2] = " F. Definicao de Telas para Consultas"
    qbf-lang[ 3] = " R. Relacoes entre Arquivos"

    qbf-lang[ 4] = " C. Conteudo do Diretorio de um Usuario"
    qbf-lang[ 5] = " H. Como Encerrar a Aplicacao"
    qbf-lang[ 6] = " M. Permissoes do Modulo"
    qbf-lang[ 7] = " Q. Permissoes de Consulta"
    qbf-lang[ 8] = " S. Programa Selecionado/Nome do Produto"

    qbf-lang[11] = " G. Idioma"
    qbf-lang[12] = " P. Configuracao da Impressora"
    qbf-lang[13] = " T. Configuracao de Cor do Terminal"

    qbf-lang[14] = " B. Programa de Paginacao para Consulta"
    qbf-lang[15] = " D. Configuracoes Padrao para Relatorios"
    qbf-lang[16] = " E. Formato de Exportacao Definido pelo Usuario"
    qbf-lang[17] = " L. Selecao do Rotulo do Campo"
    qbf-lang[18] = " U. Opcao do Usuario"

    qbf-lang[21] = 'Selecione uma opcao ou pressione [' + KBLABEL("END-ERROR")
                 + '] para encerrar e salvar as modificacoes.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Arquivos:'
    qbf-lang[23] = 'Configuracoes:'
    qbf-lang[24] = 'Seguranca:'
    qbf-lang[25] = 'Modulos:'

    qbf-lang[26] = 'Administracao'
    qbf-lang[27] = 'Versao'
    qbf-lang[28] = 'Trazendo configuracoes adicionais de administracao do '
                 + 'arquivo configurado.'
    qbf-lang[29] = 'Voce tem certeza que quer reparar a aplicacao?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Quando o usuario deixa o menu principal, este programa deveria '
                 + 'Encerrar ou Retornar?'
    qbf-lang[31] = 'Voce tem certeza que quer deixar o menu '
                 + 'de Administracao agora?'
    qbf-lang[32] = 'Verificando estrutura do arquivo configurado e salvando '
                 + 'qualquer modificacao.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'Permissoes'
    qbf-lang[ 2] = '    *                   - Todos os usuarios tem acesso.'
    qbf-lang[ 3] = '    <usuario>,<usuario>,etc.  - Apenas estes usuarios tem acesso.'
    qbf-lang[ 4] = '    !<usuario>,!<usuario>,*   - Todos exceto estes usuarios '
                 + 'tem acesso.'
    qbf-lang[ 5] = '    acct*               - Apenas os usuarios comecados com '
                 + '"acct" tem acesso.'
    qbf-lang[ 6] = 'Lista usuarios pela identificacao, e separa-os com '
                 + 'virgulas.'
    qbf-lang[ 7] = 'Identificacoes podem conter coringas.  Use sinal de exclamacao '
                 + 'para excluir usuarios.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Selecione um modulo da'
    qbf-lang[ 9] = 'lista a esquerda para'
    qbf-lang[10] = 'configurar permissoes.'
    qbf-lang[11] = 'Selecione uma funcao da '
    qbf-lang[12] = 'lista a esquerda para'
    qbf-lang[13] = 'configurar permissoes.'
    qbf-lang[14] = 'Pressione [' + KBLABEL("END-ERROR")
                 + '] quando as modificacoes estiverem prontas.'
    qbf-lang[15] = 'Pressione [' + KBLABEL("GO") + '] para gravar, ['
                 + KBLABEL("END-ERROR") + '] para refazer modificacoes.'
    qbf-lang[16] = 'Voce nao pode se excluir da Administracao!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '  Inicializacao'
    qbf-lang[22] = '                '
    qbf-lang[23] = '  Impressao Normal'
    qbf-lang[24] = '        Comprimida'
    qbf-lang[25] = '         Expandida'
    qbf-lang[26] = '     Nao Expandida'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Carregando configuracoes do modulo'
    qbf-lang[ 2] = 'Carregando configuracoes de cor'
    qbf-lang[ 3] = 'Carregando configuracao da impressora'
    qbf-lang[ 4] = 'Carregando lista de arquivos disponiveis'
    qbf-lang[ 5] = 'Carregando lista de relacoes'
    qbf-lang[ 6] = 'Carregando lista de campos selecionados para etiqueta'
    qbf-lang[ 7] = 'Carregando lista de permissoes para funcoes de consulta'
    qbf-lang[ 8] = 'Carregando informacoes de opcao de usuario'
    qbf-lang[ 9] = 'Carregando sistema padrao de relatorios'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = ' Cores para um tipo de terminal:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Menu:             Normal:' /* must be 25 */
    qbf-lang[13] = '             Em Destaque:'
    qbf-lang[14] = 'Comentarios:      Normal:'
    qbf-lang[15] = '             Em Destaque:'
    qbf-lang[16] = 'Lista de Selecao: Normal:'
    qbf-lang[17] = '             Em Destaque:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'Mostra? Atualiza? Consulta? Paginacao?  Seq'
    qbf-lang[31] = 'Tem que estar no limite de 1 ate 9999.'
    qbf-lang[32] = 'Voce quer gravar as modificacoes que foram feitas '
                 + 'na lista de campos?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Digite os nomes dos campos que foram escolhidos para endereco.'
                 + 'Use CAN-DO'
    qbf-lang[ 3] = 'lista de estilos para relacionar estes nomes de campos ("*" relaciona '
                 + 'qualquer numero de'
    qbf-lang[ 4] = 'caracteres, "." relaciona qualquer caracter).  Esta '
                 + 'informacao e usada'
    qbf-lang[ 5] = 'para criar etiquetas padrao.  Notifique-se que algunas '
                 + 'entradas podem ser'
    qbf-lang[ 6] = 'redundantes - por exemplo, se voce sempre armazena cidade, estado '
                 + 'e cep em'
    qbf-lang[ 7] = 'campos separados, voce nao precisa usar a linha de "C-E-Z".'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
    qbf-lang[ 9] = 'Nome,End1,End2,End3,Cidade,Estado,Cep,Cep+4,C-E-Z,Pais'
    qbf-lang[10] = 'Campo contendo <nome>'
    qbf-lang[11] = 'Campo contendo <primeira> linha do endereco (i.e. rua)'
    qbf-lang[12] = 'Campo contendo <segunda> linha do endereco (i.e. Caixa postal)'
    qbf-lang[13] = 'Campo contendo <terceira> linha do endereco (opcional)'
    qbf-lang[14] = 'Campo contendo nome de <cidade>'
    qbf-lang[15] = 'Campo contendo nome de <estado>'
    qbf-lang[16] = 'Campo contendo <cep> (5 ou 9 digitos)'
    qbf-lang[17] = 'Campo contendo <ultinos 4 digitos> ou cep'
    qbf-lang[18] = 'Campo contendo <combinacao cidade-estado-cep>'
    qbf-lang[19] = 'Campo contendo <pais>'

/*a-join.p*/
    qbf-lang[23] = 'Desculpe, mas desta vez juncoes (joins) nao serao permitidas.'
    qbf-lang[24] = 'Numero Maximo de relacionamentos de juncoes tem que estar extendidos.'
    qbf-lang[25] = 'Relacao de' /* 25 and 26 are automatically */
    qbf-lang[26] = 'para'          /*   right-justified           */
    qbf-lang[27] = 'Digite a clausula WHERE ou OF: (deixe espaco para remover relacao)'
    qbf-lang[28] = 'Pressione [' + KBLABEL("END-ERROR") + '] quando da atualizacao feita.'
    qbf-lang[30] = 'A declaracao tem que comecar com WHERE ou OF.'
    qbf-lang[31] = 'Digite o primeiro arquivo da relacao para adicionar ou remover.'
    qbf-lang[32] = 'Agora digite o segundo arquivo da relacao.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Adiciona Novo Formulario de Consulta '
    qbf-lang[ 2] = ' C. Seleciona Formulario de Consulta para Editar '
    qbf-lang[ 3] = ' G. Caracteristicas de Formularios Gerais '
    qbf-lang[ 4] = ' W. Quais Campos no Formulario '
    qbf-lang[ 5] = ' P. Permissoes '
    qbf-lang[ 6] = ' D. Deleta Formulario de Consulta Corrente '
    qbf-lang[ 7] = ' Seleciona: ' /* format x(10) */
    qbf-lang[ 8] = ' Atualiza: ' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '     Nome do Arquivo da Base de Dados' /* right-justify 9..14 */
    qbf-lang[10] = '              Tipo de formulario'
    qbf-lang[11] = 'Nome do Arquivo do Programa de Consulta'
    qbf-lang[12] = 'Nome Fisico do Arquivo de Formulario'
    qbf-lang[13] = 'Nome do Quadro para codigo 4GL'
    qbf-lang[14] = '            Descricao'
    qbf-lang[15] = '(.p assumido)     ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(extensao pedida)'
    qbf-lang[18] = 'Este formulario esta com ~{1~} linhas a mais.  Desde que RESULTS reserva '
                 + '5 linhas para seu proprio uso, este excedera o tamanho de tela de'
                 + '24x80 do terminal.  Voce tem certeza que quer '
                 + 'definir um formulario deste tamanho?'
    qbf-lang[19] = 'Um programa de consulta ja existe com aquele nome.'
    qbf-lang[20] = 'Este formulario ja deve existir, ou tem terminacao .f para'
                 + 'geracao automatica.'
    qbf-lang[21] = 'O nome que voce selecionou para o formulario de 4GL form esta reservado.  '
                 + 'Selecione outro.'
    qbf-lang[22] = ' Selecione arquivos acessiveis '
    qbf-lang[23] = 'Pressione [' + KBLABEL("END-ERROR") + '] quando da atualizacao feita'
    qbf-lang[24] = 'Gravando informacoes do formulario no cashe do formulario de consulta...'
    qbf-lang[25] = 'Voce modificou o ultimo formulario de consulta.  Voce pode'
                 + 'tanto compilar o formulario modificado agora, ou fazer uma'
                 + '"Reparacao da Aplicacao" depois.  Compila agora?'
    qbf-lang[26] = 'Nenhum formulario de consulta chamado "~{1~}" pode ser encontrado.  Voce '
                 + 'quer que seja gerado?'
    qbf-lang[27] = 'Um formulario de consulta chamado "~{1~}" existe.  Usa campos'
                 + 'deste formulario?'
    qbf-lang[28] = 'Voce tem certeza que quer deletar este formulario de consulta'
    qbf-lang[29] = '** Programa de consulta "~{1~}" deletado. **'
    qbf-lang[30] = 'Gravando formulario de consulta...'
    qbf-lang[31] = 'Numero maximo de formularios de consulta tem que estar determinado.'
    qbf-lang[32] = 'Nao pode montar formulario de consulta com este arquivo.^^Para '
                 + 'montar um formulario de consulta, tanto o portao tem que suportar '
                 + 'RECIDs ou deve haver um unico indice no arquivo.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' A. Adiciona Novo Dispositivo de Saida '
    qbf-lang[ 2] = ' C. Seleciona Dispositivo para Edicao '
    qbf-lang[ 3] = ' G. Caracteristicas Gerais dos Dispositivos'
    qbf-lang[ 4] = ' S. Sequencia de Controles'
    qbf-lang[ 5] = ' P. Permissoes de Impressao '
    qbf-lang[ 6] = ' D. Dispositivo Corrente de Delecao '
    qbf-lang[ 7] = ' Seleciona: ' /* format x(10) */
    qbf-lang[ 8] = ' Atualiza: ' /* format x(10) */
    qbf-lang[ 9] = 'Tem que ser menor que 256 mas maior que 0'
    qbf-lang[10] = 'Tipo tem que ser term, thru, to, view, file, page or prog'
    qbf-lang[11] = 'Numero Maximo de dispositivos de saida alcancados.'
    qbf-lang[12] = 'Apenas tipo de dispositivo "term" pode sair para TERMINAL.'
    qbf-lang[13] = 'Nao pode encontrar nome de programa com PROPATH corrente.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Desc  para listagem'
    qbf-lang[18] = 'Nome do Dispositivo'
    qbf-lang[19] = '     Largura Maxima'
    qbf-lang[20] = '               Tipo'
    qbf-lang[21] = 'ver abaixo'
    qbf-lang[22] = 'TERMINAL, como na SAIDA PARA TERMINAL PAGINADO'
    qbf-lang[23] = 'PARA um dispositivo, como uma SAIDA DE IMPRESSORA'
    qbf-lang[24] = 'ATRAVES de um filtro ou canal UNIX ou OS/2'
    qbf-lang[25] = 'Envia um relatorio para um arquivo, e entao executa este programa'
    qbf-lang[26] = 'Pede um usuario de um nome de arquivo para o meio de saida '
    qbf-lang[27] = 'Para telas que suportem prev-page e next-page'
    qbf-lang[28] = 'Chama um programa 4GL para comecar/encerrar um fluxo de saida'
    qbf-lang[30] = 'Pressione [' + KBLABEL("END-ERROR") + '] quando da atualizacao'
    qbf-lang[31] = 'Deve existir no ultimo dispositivo de saida!'
    qbf-lang[32] = 'Voce tem certeza que quer deletar esta impressora?'.

/*--------------------------------------------------------------------------*/

RETURN.
