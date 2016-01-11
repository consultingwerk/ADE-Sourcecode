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
/*----------------------------------------------------------------------------

File: _rdproc.p

Description:
    Readin the Procedure Settings for a procedure.

Input Parameters:
    pp-recid:  The recid of the current procedure.

Output Parameters:
   <None>

Author : Wm.T.Wood
Date Created: 1995
Changed by  : HD  Added read of User-fields  
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER pp-recid AS RECID NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */

DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line      AS CHARACTER EXTENT 100           NO-UNDO.
DEFINE SHARED  VARIABLE  adm_version    AS CHARACTER                      NO-UNDO.

DEFINE VARIABLE cur-tt AS RECID                                       NO-UNDO.
DEFINE VARIABLE i      AS INTEGER                                     NO-UNDO.

/* Use this to turn debugging on after each line that is read in. */
&Scoped-define debuga  message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] .

FIND _P WHERE RECID(_P) eq pp-recid.

    
FIND-SETTINGS:
REPEAT:
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.  {&debug}
  IF _inp_line[2] = "Settings":U THEN DO:
     PARSE-SETTINGS:
     REPEAT:
       _inp_line = "".
       IMPORT STREAM _P_QS _inp_line.  {&debug}
       CASE _inp_line[1]:
         WHEN "Type:"     THEN ASSIGN _P._type     = _inp_line[2]
                                      _P._template = _inp_line[3] eq "Template":U.
         WHEN "External"  THEN _P._xTblList = _inp_line[3].
         WHEN "Allow:"    THEN _P._allow = _inp_line[2].
         WHEN "Container" THEN _P._links           = _inp_line[3].
         WHEN "Compile"   THEN _P._compile-into    = _inp_line[3].
         WHEN "Frames:"   THEN _P._max-frame-count = INTEGER(_inp_line[2]).
         WHEN "Design "   THEN _P._page-current    = IF _inp_line[3] eq "All" THEN ?
                                                     ELSE INTEGER(_inp_line[3]).
         WHEN "Add"       THEN _P._add-fields      = _inp_line[4].
         WHEN "Editing:"  THEN _P._editing         = _inp_line[2].
         WHEN "Events:"   THEN _P._events          = _inp_line[2].
         WHEN "Application" THEN _P._partition     = _inp_line[3].
         WHEN "Partition:" THEN _P._partition      = _inp_line[2].
         WHEN "Data"      THEN _P._data-object     = TRIM(_inp_line[3] , '"').
         WHEN "Other"     THEN DO:
           /* Look at each of the remaining tokens in the line */
           i = 3.
           DO WHILE _inp_line[i] ne "":
             CASE _inp_line[i]:
               WHEN "CODE-ONLY"       THEN _P._file-type       = "p":U.
               WHEN "INCLUDE-ONLY"    THEN _P._file-type       = "i":U.
               WHEN "HTML-ONLY"       THEN _P._file-type       = "html":U.
               WHEN "PERSISTENT-ONLY" THEN _P._persistent-only = yes.
               WHEN "COMPILE"         THEN _P._compile         = yes.
               WHEN "APPSERVER"       THEN _P._app-srv-aware   = yes.
               WHEN "DB-AWARE"        THEN _P._DB-AWARE        = yes.
               WHEN "NO-PROXY"        THEN _P._NO-PROXY        = yes.
             END CASE.
            i = i + 1.
           END. /* DO... */
         END. /* WHEN Other */
         
         WHEN "Temp-Tables":U THEN DO:
           READ-TEMP-TABLE-INFO:
           REPEAT:
             IMPORT STREAM _P_QS _inp_line.
             IF _inp_line[1] = "END-TABLES.":U THEN LEAVE READ-TEMP-TABLE-INFO.
             ELSE IF _inp_line[1] = "TABLE:":U THEN DO:
               CREATE _TT.
               ASSIGN _TT._p-recid    = pp-recid
                      _TT._NAME       = _inp_line[2]
                      _TT._TABLE-TYPE = _inp_line[3]
                      _TT._SHARE-TYPE = IF _inp_line[4] = "?"
                                        THEN "":U  ELSE _inp_line[4]
                      _TT._UNDO-TYPE  = IF _inp_line[5] = ?
                                        THEN "":U  ELSE _inp_line[5]
                      _TT._LIKE-DB    = _inp_line[6]
                      _TT._LIKE-TABLE = _inp_line[7]
                      cur-tt          = RECID(_TT).
             END.  /* If TABLE information */
             ELSE IF _inp_line[1] = "ADDITIONAL-FIELDS:":U THEN DO:
               FIND _TT WHERE RECID(_TT) = cur-tt.
               READ-ADDITIONAL-FIELD-INFO:
               REPEAT:
                 IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
                 _inp_line[1] = TRIM(_inp_line[1]).
                 IF _inp_line[1] = "END-FIELDS.":U THEN
                   LEAVE READ-ADDITIONAL-FIELD-INFO.
                 ELSE
                   ASSIGN _TT._ADDITIONAL_FIELDS = _TT._ADDITIONAL_FIELDS +
                              CHR(10) + _inp_line[1].
               END.  /* Reading additional field info */
               _TT._ADDITIONAL_FIELDS = LEFT-TRIM(_TT._ADDITIONAL_FIELDS).
             END.  /* IF additional-fields */
           END.  /* Reading temp-table info */
         END.  /* When TEMP-TABLES and BUFFERS */
         
         WHEN "User-Fields:" THEN
         DO:
           CREATE _UF.
           ASSIGN _UF._p-recid = pp-recid. /* Unique per _P */                            
           READ-USER-FIELDS:
           REPEAT:
             IMPORT STREAM _P_QS UNFORMATTED _inp_line[1].
             _inp_line[1] = TRIM(_inp_line[1]).
             IF _inp_line[1] = "END-USER-FIELDS.":U THEN 
                LEAVE READ-USER-FIELDS.                        
             ELSE
               ASSIGN _UF._DEFINITION = _UF._DEFINITION + CHR(10) + _inp_line[1].   
           END.
           _UF._DEFINITION = LEFT-TRIM(_UF._DEFINITION).           
         END. /* When USER-FIELDS */
         
         WHEN "_END-PROCEDURE-SETTINGS":U THEN LEAVE FIND-SETTINGS.
         OTHERWISE LEAVE PARSE-SETTINGS.
       END CASE.
     END. /* parse-settings: repeat... */
  END.  /* If _inp_line[2] = Settings */
  IF _inp_line[1] = "_END-PROCEDURE-SETTINGS":U THEN LEAVE FIND-SETTINGS.
END.  /* FIND-SETTINGS: REPEAT */

/* By this time, vrfyimp.i has set the adm_version shared var. So as long _P._ADM-VERSION
   hasn't already been set, do so now. jpalazzo 3/3/98 */
IF adm_version = "" AND _P._TYPE BEGINS "Smart":U THEN adm_version = "ADM1":U.
ASSIGN _P._ADM-VERSION = adm_version WHEN _P._ADM-VERSION = "".



