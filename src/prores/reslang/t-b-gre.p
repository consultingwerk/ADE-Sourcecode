/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-b-eng.p - English language definitions for Build subsystem */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/* b-build.p,b-again.p */
IF qbf-s = 1 THEN
  ASSIGN
                /* formats: x(10) x(45) x(8) */
    qbf-lang[ 1] = '��暨����,"Database" ��� �����,��椦�'
    qbf-lang[ 2] = '�� ����� ��⚮�� (Checkpoint) �������᭞��. �����ᯫ� �� ����� .qc '
                 + '��� �ᤫ� ��� �����ᩫ��� ��� ��� ����.'
    qbf-lang[ 3] = '���������� ���'     /*format x(15)*/
    qbf-lang[ 4] = 'Compile'      /*format x(15)*/
    qbf-lang[ 5] = 'Re-Compiling'   /*format x(15)*/
    qbf-lang[ 6] = '���������� ��� ����妬,���������� ��� �樣��,���������� �����ᣣ����'
    qbf-lang[ 7] = '��� �� �������⤘ ����� �� ������������. ['
                 + KBLABEL("RETURN") + '] ��� �������/���ਫ਼ �������.'
    qbf-lang[ 8] = '���㩫� [' + KBLABEL("GO") + '] ���� ����⥜�� � ['
                 + KBLABEL("END-ERROR") + '] ��� �⢦�.'
    qbf-lang[ 9] = '���稜�� ������ ��� ��������� ������ �婫� ����� �������...'
    qbf-lang[10] = '����� ��婜� 梜� ��� ������ �������; '
    qbf-lang[11] = '���稜�� ⣣��� ��ૠ�� ��⩜� -OF.'
    qbf-lang[12] = '���������� ��� �婫�� ��ૠ�� ��⩜�.'
    qbf-lang[13] = '��� �����婫���� 梜� �� ��驜��.'
    qbf-lang[14] = '�������� �� �����⦤ �������� �� ��ૠ�� ��⩜�.'
    qbf-lang[15] = '��������ਫ਼ ��曦�'
    qbf-lang[16] = '�������� ������,�⩦� ��椦�'
    qbf-lang[17] = '��ᚤਫ਼ ��� ����妬 ��⚮�� (checkpoint)...'
    qbf-lang[18] = '��������� ��� ����妬 ��⚮�� (checkpoint)...'
    qbf-lang[19] = '㛞 ��ᨮ��. �������ᩫ��� �� ��'
    qbf-lang[20] = '���������ᩫ��� ��� ����妬'
    qbf-lang[21] = '���稜�� ��� ������ "~{1~}" ��� ��������.'
    qbf-lang[22] = '��礘�� � �����ᩫ��� ��� ������ �騠� RECID � UNIQUE INDEX '
    qbf-lang[23] = '� �樣� ��� ᢢ���.'
    qbf-lang[24] = '��� ����᝜��� "recompiling".'
    qbf-lang[25] = '��� ��ᨮ��� ᢢ� ���� ��� �樣�. ��� ��������㟞�� � �樣�.'
    qbf-lang[26] = '��� ��ᨮ��� ᢢ� ���� ��� �樣�. � ��ᨮ���� �樣� �����᭞��.'
    qbf-lang[27] = '����圩� ��� �婫�� ������ �������.'
    qbf-lang[28] = '�������� ��椦�'
    qbf-lang[29] = '�⢦�!'
    qbf-lang[30] = '������� "Compile" ��� "~{1~}".'
    qbf-lang[31] = '��������� ��� ����妬 �����⫨� (config)'
    qbf-lang[32] = '�����婫���� �៞ ���� ��� �ᩞ "�����ᩫ���" ���/� "compile".'
                 + '^^���㩫� �᧦�� ��㡫�� ��� �� ��嫜 �� �������� ����� (query log file).'
                 + '� ������ ��� ����⮦�� �� �៞ ���坦����.'.

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 2 THEN
  ASSIGN

/* b-misc.p */
    /* 1..10 for qbf-l-auto[] */
    qbf-lang[ 1] = 'onoma,*onoma*,eponymia,*eponymia*,Name'
    qbf-lang[ 2] = 'contact,*contact*,ypeythinos,yp*opsin,Address'
    qbf-lang[ 3] = '*odos,dieyth*,*dieythinsh,*dieythinsh*1,Address2'
    qbf-lang[ 4] = '*tax*thyrida*,*dieythinsh*2'
    qbf-lang[ 5] = '*dieythinsh*3,City'
    qbf-lang[ 6] = 'tax*kod*,*tax*kvd*,t*k*,St'
    qbf-lang[ 7] = 'polh,*polh*,Zip'
    qbf-lang[ 8] = 't*p,*tax*polh*,tk*polh,t*k*polh'
    qbf-lang[ 9] = 'nomos,*nomos*'
    qbf-lang[10] = '*xvra*,*xora*'

    qbf-lang[15] = '��嚣� ����� �������'.

/*--------------------------------------------------------------------------*/
RETURN.
