&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
**********************************************************************

    File        : _unmapal.p
    Purpose     : Unmap all Mapped fields for a _P. 

    Syntax      : 

    Description :
    Input Param : piRecid  - _P or _U recid 
                  pcUnmap  -  "QUERY"   - pRecid is RECID(_U), all the tables 
                                         in the query should be unmapped 
                             "COLUMNS" - Unmap columns no longer in the 
                                         SmartDataObject                                        
                             *         - Unmap all  
                             Comma separated list of tables to unmap
    Author(s)   : Haavard Danielsen 
    Created     : 4/8/98
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeweb/htmwidg.i}

DEFINE INPUT  PARAMETER piRecid      AS INTEGER           NO-UNDO.
DEFINE INPUT  PARAMETER pcUnmap      AS CHAR              NO-UNDO.


DEFINE VARIABLE hSDO       AS HANDLE NO-UNDO.
DEFINE VARIABLE cColumns   AS CHAR NO-UNDO. 

FUNCTION get-sdo-hdl returns handle 
         (pName as char, pHdl as handle) in _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
               
IF pcUnmap = "QUERY":U THEN 
DO:
  FIND _U WHERE RECID(_U) = piRecid NO-ERROR.
  IF AVAIL _U THEN 
  DO: 
    FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR. 
    /* adeuib/_uibinfo gives error if no _P is avail. */
    IF AVAIL _P THEN      
      RUN adeuib/_uibinfo.p(RECID(_U),?,"TABLES":U,OUTPUT pcUnmap).    
  END.
END. /* IF pcUnmap = "QUERY" */               
ELSE
  FIND _P WHERE RECID(_P) eq piRecid NO-ERROR.

IF AVAIL _P THEN 
DO:      
  RUN adecomm/_setcurs.p("WAIT":U).
  
  /* If 'columns' find the SDO and its columns */
  IF pcUnmap = "COLUMNS":U THEN 
  DO:    
    IF _P._data-object <> "" AND VALID-HANDLE(_p._tv-proc) THEN     
       hSDO = get-sdo-hdl(_P._data-object, _P._tv-proc).
   
    IF VALID-HANDLE(hSDO) THEN   
       cColumns = DYNAMIC-FUNCTION('getDataColumns':U IN hSDO).        
  END. /* IF pcUnmap = "COLUMNS" */               


  
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE             
              AND   _U._STATUS EQ 'NORMAL':U,
           
       /*  The HTM join should be good enough so we don't need this crap 
                     (NOT (_U._NAME BEGINS '_LBL':U~
                                  OR ( _U._TYPE eq 'WINDOW':U~
                          AND _U._SUBTYPE eq 'Design-Window':U)))~
                   AND _U._STATUS EQ 'NORMAL':U~
                   AND CAN-DO(gWidgetList,_U._TYPE)~
                   AND _U._WINDOW-HANDLE eq _h_win,~
       */
       EACH _HTM WHERE _HTM._U-RECID = RECID(_U):
    
    IF _U._TABLE <> ? THEN 
      ASSIGN pcUnmap = REPLACE(pcUnmap,_U._dbname + ".","":U). 
    
       /* unmap all */ 
    IF pcUnmap = "*":U 
       /* unmap tables */
    OR CAN-DO(pcUnmap,_U._TABLE)
       /* unmapp RowObject when unmap query tables  */  
    OR (_U._TABLE = "RowObject":U AND pcUnmap  <> "COLUMNS":U)
       /* unmap columns that no longer exists in SDO */  
    OR (_U._TABLE = "RowObject":U AND cColumns <> "":U AND 
        NOT CAN-DO(cColumns,_U._NAME)                   )  THEN
   
      RUN adeweb/_dbfsel.p (INPUT _U._HANDLE , INPUT "_DESELECT":u).   
            
  END. /* for each _u */
  PUBLISH "AB_refreshfields":U.
END.
RUN adecomm/_setcurs.p("":U).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


