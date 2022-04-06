/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-c-eng.p - English language definitions for Scrolling Lists */

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
  qbf-lang[ 1] = '����⥫� �� ����� ��� �ਫ਼ � ���㩫� ['
               + KBLABEL("END-ERROR") + '] ��� �⢦�.'
  qbf-lang[ 2] = '���㩫� [' + KBLABEL("GO") + '] ���� ����⥜��,['
               + KBLABEL("INSERT-MODE") + '] ��� ��������,['
               + KBLABEL("END-ERROR") + '] ��� �⢦�.'
  qbf-lang[ 3] = '���㩫� [' + KBLABEL("END-ERROR")
               + '] ���� ����⥜�� �� �����.'
  qbf-lang[ 4] = '���㩫� [' + KBLABEL("GO") + '] ���� ����⥜��, ['
               + KBLABEL("INSERT-MODE")
               + '] �������� ������./���./��暨.'
  qbf-lang[ 5] = '����⫫�/�������'
  qbf-lang[ 6] = '���������/�������-'
  qbf-lang[ 7] = '�����---,��暨����,���������'
  qbf-lang[ 8] = '���稜�� �� �����...'
  qbf-lang[ 9] = '������� �����'
  qbf-lang[10] = '������� ����妬'
  qbf-lang[11] = '������� ����妬 �� ��⩞'
  qbf-lang[12] = '������� �樣�� �������'
  qbf-lang[13] = '������� ���ᛘ� ��曦�'
  qbf-lang[14] = '��ਫ਼' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '          �����' /* max length 16 */
  qbf-lang[18] = '           ����' /* max length 16 */
  qbf-lang[19] = '  �⚠��� ��㟦�' /* max length 16 */
  qbf-lang[20] = '� ����'
  qbf-lang[21] = '������夜� �� ��㟦� �������� ��� �夘�� - 1 ��'
  qbf-lang[22] = '�� ��������� ��� �⢦� ��� ��ᨮ���� ����妬; '
  qbf-lang[23] = '��礘�� � ������� �� �� ���������⤦ ��������� ��曦�'
  qbf-lang[24] = '�驫� ��� ������� ��� ����妬 ��曦�'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = '��㩫� �� ���� ��� �����樬�� �夘��, � �驫� ��'
  qbf-lang[28] = '�婫� ����������� �������� ��� �夘�� (������'
  qbf-lang[29] = '������) ��� ���ਠ��� ��㢜� ���� ����ਫ਼.'
  qbf-lang[30] = '�驫� �� �婫� ����������� �������� ��� �夘��' 
  qbf-lang[31] = '(������ ������) ��� ���� �� ���ਠ��� ��㢜�.'
  qbf-lang[32] = '�驫� ��� ��填� ��� ������妬 ��� �夘��.'.

RETURN.
