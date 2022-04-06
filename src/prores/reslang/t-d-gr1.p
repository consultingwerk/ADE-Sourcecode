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
    qbf-lang[ 1] = '��� ������� ����'
    qbf-lang[ 2] = '��� ��� �������� ������.'
    qbf-lang[ 3] = '������� [' + KBLABEL("GET")
                 + '] ��� �������/������� �������� ��� ������ �������.'
    /* format x(70): */
    qbf-lang[ 4] = '���� ��� �������� �������, �� �������� ������������ '
                 + '�������� :'
    /* format x(60): */
    qbf-lang[ 5] = '����� ���������� ���� �� ���� ����������.'
    qbf-lang[ 6] = '����������� �� ���������� �������.'
    qbf-lang[ 7] = '��� � �������� ���������� ����� ��� �� ������ "h".'
    qbf-lang[ 8] = '���, ��� � ���� �����, ���� ��������� �������.'
    qbf-lang[ 9] = '����� �������� �������. �������� ��������� ��.'
    qbf-lang[10] = '����������� ��� ���������� ������� ��� ��������...'.

ELSE

/*--------------------------------------------------------------------------*/
/* d-main.p */
IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '���. :,     :,     :,     :,     :'
    qbf-lang[ 2] = '�����:'
    qbf-lang[ 3] = '�������� ��������'
    qbf-lang[ 4] = '�������� ��������'
    qbf-lang[ 5] = '�����:,      :,      :,      :,      :'
    qbf-lang[ 7] = ' ����� ��������:'
    qbf-lang[ 8] = '�����������:'
    qbf-lang[ 9] = '(����� �������= ��������� ������)'
    qbf-lang[10] = '  ���� ��������:'
    qbf-lang[11] = ' ����� ��������:'
    qbf-lang[12] = ' ��������� ���.:'
    qbf-lang[13] = '����������� ���:'
    qbf-lang[14] = '� ������� ��������� ��� ����������� ���� ������������ '
                 + '�������. ��� ��������, �� ���������� ��� ��� �������.'
                 + '^������ �� ����������; '
    qbf-lang[15] = '������� � ������� ��������� ����� ��� ������ ������.'
    qbf-lang[21] = '��� ����� �������� ��� �������� ����� ��������. '
                 + '������ �� ����������; '
    qbf-lang[22] = '���������� ��� ������������ ��������...'
    qbf-lang[23] = '"Compile" ��� ������������ ��������...'
    qbf-lang[24] = '�������� ��� ������������ ��� �������������...'
    qbf-lang[25] = '������� � ����������� �� �� ������/������'
    qbf-lang[26] = '������� ���������� �������� - ~{1~} .'
    qbf-lang[31] = '����������� ������������ ��� ��������� ��������'
    qbf-lang[32] = '����������� ������ ��� ���� ��� �������'.

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
    qbf-lang[ 3] = 'ASCII-H ,ASCII �� ������.��������� ������'
    qbf-lang[ 4] = 'FIXED   ,ASCII �������� ������ (SDF)'
    qbf-lang[ 5] = 'CSV     ,������������ �� ������� (CSV)'
    qbf-lang[ 6] = 'DIF     ,DIF'
    qbf-lang[ 7] = 'SYLK    ,SYLK'
    qbf-lang[ 8] = 'WS      ,WordStar'
    qbf-lang[ 9] = 'WORD    ,Microsoft Word'
    qbf-lang[10] = 'WORD4WIN,Microsoft Word ��� Windows'
    qbf-lang[11] = 'WPERF   ,WordPerfect'
    qbf-lang[12] = 'OFISW   ,CTOS/BTOS OfisWriter'
    qbf-lang[13] = 'USER    ,����������� ��� ��� ������'
    qbf-lang[14] = '*'. /* terminator for list */

/*--------------------------------------------------------------------------*/

RETURN.
