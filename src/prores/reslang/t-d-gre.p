/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-d-eng.p - English language definitions for Data Export module */

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
    qbf-lang[ 1] = '⤘ �磙��� ��'
    qbf-lang[ 2] = '��� ��� ������� �夘��.'
    qbf-lang[ 3] = '���㩫� [' + KBLABEL("GET")
                 + '] ��� �������/���ਫ਼ ������� ��� ������ �������.'
    /* format x(70): */
    qbf-lang[ 4] = '���� ��� �������� ������, �� ������� �����ᝦ���� '
                 + '���矜�� :'
    /* format x(60): */
    qbf-lang[ 5] = '���� ������㨘� �⩘ �� ���� ����������.'
    qbf-lang[ 6] = '������眫�� � ������㨘� ��⚮��.'
    qbf-lang[ 7] = '⤘ � ������� ���������� ���� ��� �� ��ᣣ� "h".'
    qbf-lang[ 8] = '⤘, �� � ��� ����, ⤘� �������� ������.'
    qbf-lang[ 9] = '�夘� ᚤ੫�� ������. �������� �����驫� ��.'
    qbf-lang[10] = '���������� �� �������� ��⚮�� ��� �������...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '���. :,     :,     :,     :,     :'
    qbf-lang[ 2] = '�����:'
    qbf-lang[ 3] = '������� �������'
    qbf-lang[ 4] = '����嘩� �������'
    qbf-lang[ 5] = '����:,      :,      :,      :,      :'
    qbf-lang[ 7] = ' �秦� �������:'
    qbf-lang[ 8] = '��������囘:'
    qbf-lang[ 9] = '(��髞 �������= ������圪 �����)'
    qbf-lang[10] = '  ���� �������:'
    qbf-lang[11] = ' �⢦� �������:'
    qbf-lang[12] = ' �����⫞� ���.:'
    qbf-lang[13] = '����ਠ��� ���:'
    qbf-lang[14] = '� ������� �������� ��� �������坜� ���� �����樬���� '
                 + '�夘���. ��� ���⮜��, �� ��������� ��� ��� �������.'
                 + '^�⢜�� �� �����婜��; '
    qbf-lang[15] = '��礘�� � ������� �������� ��� ��� ������ �����.'
    qbf-lang[21] = '��� ⮜�� ����驜� ��� ��⮦��� ����� �������. '
                 + '�⢜�� �� �����婜��; '
    qbf-lang[22] = '��������� ��� �����ᣣ���� �������...'
    qbf-lang[23] = '"Compile" ��� �����ᣣ���� �������...'
    qbf-lang[24] = '���⢜�� ��� �����ᣣ���� ��� ��������㟞��...'
    qbf-lang[25] = '��礘�� � ��������� �� �� �����/���ᛘ'
    qbf-lang[26] = '������ ������� ������� - ~{1~} .'
    qbf-lang[31] = '��������ਫ਼ ������⫞��� �� ����婜� �������'
    qbf-lang[32] = '��������ਫ਼ ��曦� ��� ���� ��� ������'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
/* this set contains only export formats.  Each is composed of the */
/* internal RESULTS id and the description.  The description must  */
/* not contain a comma, and must fit within format x(32).          */
IF qbf-s = 3 THEN
  ASSIGN
    qbf-lang[ 1] = 'PROGRESS,������� PROGRESS'
    qbf-lang[ 2] = 'ASCII   ,������ ASCII (Generic)'
    qbf-lang[ 3] = 'ASCII-H ,ASCII �� ������.������嘪 ���妬'
    qbf-lang[ 4] = 'FIXED   ,ASCII �������� �㡦�� (SDF)'
    qbf-lang[ 5] = 'CSV     ,����ਠ��⤘ �� �棣��� (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word ��� Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,��������⤞ ��� ��� ��㩫�'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
