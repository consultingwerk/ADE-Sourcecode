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
  qbf-lang[ 1] = '�������� �� ������ ��� ����� � ������� ['
               + KBLABEL("END-ERROR") + '] ��� �����.'
  qbf-lang[ 2] = '������� [' + KBLABEL("GO") + '] ���� ���������,['
               + KBLABEL("INSERT-MODE") + '] ��� ��������,['
               + KBLABEL("END-ERROR") + '] ��� �����.'
  qbf-lang[ 3] = '������� [' + KBLABEL("END-ERROR")
               + '] ���� ��������� �� ������.'
  qbf-lang[ 4] = '������� [' + KBLABEL("GO") + '] ���� ���������, ['
               + KBLABEL("INSERT-MODE")
               + '] �������� ������./���./�����.'
  qbf-lang[ 5] = '��������/��������'
  qbf-lang[ 6] = '���������/��������-'
  qbf-lang[ 7] = '������---,���������,���������'
  qbf-lang[ 8] = '�������� ��� ������...'
  qbf-lang[ 9] = '������� ������'
  qbf-lang[10] = '������� �������'
  qbf-lang[11] = '������� ������� �� �����'
  qbf-lang[12] = '������� ������ ��������'
  qbf-lang[13] = '������� ������� ������'
  qbf-lang[14] = '�����' /* should match t-q-eng.p "Join" string */
  qbf-lang[16] = '        Database' /* max length 16 */
  qbf-lang[17] = '          ������' /* max length 16 */
  qbf-lang[18] = '           �����' /* max length 16 */
  qbf-lang[19] = '  ������� ������' /* max length 16 */
  qbf-lang[20] = '� ����'
  qbf-lang[21] = '���������� �� ������ ��������� ��� ������ - 1 ���'
  qbf-lang[22] = '�� ��������� ��� ����� ��� ��������� �������; '
  qbf-lang[23] = '������� � ������� �� �� ������������ ��������� ������'
  qbf-lang[24] = '����� ��� �������� ��� ������� ������'

               /* 12345678901234567890123456789012345678901234567890 */
  qbf-lang[27] = '������ �� ���� ��� ���������� ������, � ����� ���'
  qbf-lang[28] = '����� ������������� ��������� ��� ������ (������'
  qbf-lang[29] = '��������) ��� ���������� ������ ���� ��������.'
  qbf-lang[30] = '����� ��� ����� ������������� ��������� ��� ������' 
  qbf-lang[31] = '(������ ��������) ��� ����� �� ���������� ������.'
  qbf-lang[32] = '����� ��� ������ ��� ��������� ��� ������.'.

RETURN.
