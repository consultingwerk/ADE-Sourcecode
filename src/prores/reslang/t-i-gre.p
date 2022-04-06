/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-i-eng.p - English language definitions for Directory */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*i-dir.p,i-pick.p,i-zap.p,a-info.p,i-read.p*/
ASSIGN
  qbf-lang[ 1] = '�������,graph,����⫫�,query,����ਫ਼'
  qbf-lang[ 2] = '�驫� �� ��������� ���'
  qbf-lang[ 3] = '��� ⤘� ��� ���� ������� �暦�� ������ ����� 
                  ���/� ���� ������姦���� :^'
               + '1) �� ������ "database" ��� ⮦�� ��������^'
               + '2) ����� �夜� �������� �� ������ ��� "database"^'
               + '3) ��� ⮜�� �����飘�� ��橙����'
  qbf-lang[ 4] = '� ������� ��� �ៜ ~{1~} ��⧜� �� �夘� ��������. �������� �����驫�.'
  qbf-lang[ 5] = '���� ����㡜���� ������. �������� �����ᯫ� ������ ! '
               + '� �������� ��� �᧦�� ���ᢦ�� ������� �� ����������驜� �騦.'
  qbf-lang[ 6] = '���������,Database-,��暨����'
  qbf-lang[ 7] = '��������ਫ਼ ����᢬��� ��� ����妬'
  qbf-lang[ 8] = '��'
  qbf-lang[ 9] = '�������'
  qbf-lang[10] = '����� �������,graph,����⫫��,query,����ਫ਼�'
  qbf-lang[11] = '����� �������,graph,����⫫��,query,����ਫ਼�'
  qbf-lang[12] = '����� �������,graph,��������,query,�����驜�'
  qbf-lang[13] = '����� �������,graph,����� ��������,query,'
               + '������� �����驜�'
  qbf-lang[14] = '��� �樫ਫ਼,��� ����㡜���,��� ��������'
  qbf-lang[15] = '���⢜��...'
  qbf-lang[16] = '�樫ਫ਼ ~{1~} ��� ᢢ� ���ᢦ��'
  qbf-lang[17] = '����㡜��� �☪ ~{1~}'
  qbf-lang[18] = '��� ����埜���'
  qbf-lang[19] = '��� �� �������⤘ �� ���������. ['
               + KBLABEL('RETURN') + '] ��� �������/���ਫ਼ �������.'
  qbf-lang[20] = '���㩫� [' + KBLABEL('GO') + '] ���� ����⥜��, � ['
               + KBLABEL('END-ERROR') + '] ��� �⢦� ��� ��������.'
  qbf-lang[21] = '�����夞�� ��� ~{1~} ��� �⩞ ~{2~}.'
  qbf-lang[22] = '�������� ��� ~{1~}.'
  qbf-lang[23] = '[' + KBLABEL("GO") + '] ��� �������, ['
               + KBLABEL("INSERT-MODE") + '] ��� ��������, ['
               + KBLABEL("END-ERROR") + '] ��� �⢦�.'
  qbf-lang[24] = '��������� ��� �����暦� �����驜� �� ��� �������� ...'
/*a-info.p only:*/ /* 25..29 use format x(64) */
  qbf-lang[25] = '���� �� ��暨���� �����坜� �� ������棜�� ��� ����妬'
  qbf-lang[26] = '�������� ��㩫� ��� ��� ������� ���, ��室����� ����'
  qbf-lang[27] = '����������⤘ �����ᣣ��� ��㡦�� �� ���� �����驜��,'
  qbf-lang[28] = '�������,����⫫�� ���.'
  qbf-lang[29] = '�驫� ��� ��㨞 ������� ��� "path" ��� ����妬 ".qd" ��� ��㩫�:'
  qbf-lang[30] = '��� ��⟞�� �� ����� ��� �驜��.'
  qbf-lang[31] = '��⧜� �� �驜�� ��� ��� ���⡫��� ��� ������嘪 ".qd".'
  qbf-lang[32] = '��ᚤਫ਼ ��� �����暦�...'.

RETURN.
