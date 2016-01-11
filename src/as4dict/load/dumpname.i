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

/*--------------------------------------------------------------------

File: as4dict/load/dumpname.i

Description:
    checkes and eventually transformes a name into a valid unique 
    dumpname
    
Text-Parameters:
    none

Objects changed:
    nam         INPUT:  dump-name estimation
                OUTPUT: valid, unique dump-name
                    
Included in:
    as4dict/load/_lodname.p
    as4dict/load/_lod_fil.p
    

Author: Tom Hutegger

History:
    hutegger    94/05/23    creation
    mcmann      95/01/31    Modified for DB2/400 V7 Utilities
    
--------------------------------------------------------------------*/
/*h-*/
/*--------------------------------------------------------------------
needs the following variables defined:

DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
--------------------------------------------------------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

  nam = LC(SUBSTRING(nam,1,8)).
  IF CAN-FIND(as4dict.p__File WHERE as4dict.p__File._Dump-name = nam) THEN
    ASSIGN
      pass = 1 /*ABSOLUTE(_File-num)*/
      nam  = SUBSTRING(nam + "-------",1,8 - LENGTH(STRING(pass)))
           + STRING(pass).

  DO pass = 1 TO 9999 WHILE CAN-FIND(as4dict.p__File 
                 WHERE as4dict.p__File._Dump-name = nam):
    ASSIGN nam = SUBSTRING(nam + "-------",1,8 - LENGTH(STRING(pass)))
               + STRING(pass).
  END.

/*------------------------------------------------------------------*/
