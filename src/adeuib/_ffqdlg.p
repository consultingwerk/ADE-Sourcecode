/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ffqdlg.p

Description:
    Freeform Query dialog to set up freeform querys from the 
    query builder.  This "extra" call is necessary because the
    query builder doesn't have access to _query-u-rec (The
    recid of the current _U.

Input Parameters:
   <none>
   
Input-Output Parameters:
   ok-cancel - Character field that is either "Freeform" or "Cancel".

Output Parameters:
   oqcode     - Character field containing the open query statement

Author: D. Ross Hunter

Date Created: 1995

---------------------------------------------------------------------------- */

DEF INPUT        PARAMETER _4GLQury  AS CHARACTER                      NO-UNDO.
DEF INPUT        PARAMETER TblLIst   AS CHARACTER                      NO-UNDO.
DEF INPUT-OUTPUT PARAMETER ok-cancel AS CHARACTER                      NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/sharvars.i}
{adeuib/uibhlp.i}
{adecomm/oeideservice.i}

DEF VAR never-again          AS LOGICAL                                NO-UNDO.

if OEIDE_CanLaunchDialog() then
   RUN adeuib/ide/_dialog_advisor.p (
  /* TEXT */    INPUT "Freeform queries are edited using the Section Editor." +
                      "  This is an advanced feature, press 'Help' for details.",
  /* OPTIONS */ INPUT "Freeform.  Allow freeform editing of query.,Freeform," +
                      "Cancel.  Use Query Builder.,Cancel",
                INPUT FALSE,
                INPUT "AB",
                INPUT {&Free_Form_Query_Dlg_Box},
                INPUT-OUTPUT ok-cancel,
                OUTPUT never-again).
else
     RUN adeuib/_advisor.w (
     /* TEXT */    INPUT "Freeform queries are edited using the Section Editor." +
                      "  This is an advanced feature, press 'Help' for details.",
     /* OPTIONS */ INPUT "Freeform.  Allow freeform editing of query.,Freeform," +
                      "Cancel.  Use Query Builder.,Cancel",
                   INPUT FALSE,
                   INPUT "AB",
                   INPUT {&Free_Form_Query_Dlg_Box},
                   INPUT-OUTPUT ok-cancel,
                   OUTPUT never-again).

IF ok-cancel = "Freeform":U THEN DO:
  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  FIND _Q WHERE RECID(_Q) = _C._q-recid. 
  
  FIND _P WHERE _P._window-handle = _U._window-handle.

  ASSIGN _Q._4GLQury = _4GLQury
         _Q._TblList = TblList.

  /* Get the OPEN-QUERY statement that is going to be output into the preprocessor
     section. Note that this will have lines that end with tilde. Remove these
     tilde's. */
  RUN adeshar/_coddflt.p (INPUT "_OPEN-QUERY", INPUT _query-u-rec, OUTPUT _4GLQury).
  ASSIGN _4GLQury = REPLACE(REPLACE(_4GLQury,":":U,".":U)," ~~":U + CHR(10) , CHR(10)).
  CREATE _TRG.
  ASSIGN _TRG._pRECID   = RECID(_P)
         _TRG._tSECTION = "_CONTROL":U
         _TRG._tEVENT   = "OPEN_QUERY":U
         _TRG._wRECID   = _query-u-rec
         _TRG._tSPECIAL = "_OPEN-QUERY":U
         _TRG._tCODE    = IF _4GLQury NE "":U THEN 
                          (IF _4GLQury BEGINS "OPEN QUERY":U
                              THEN _4GLQury
                              ELSE "OPEN QUERY ~{&SELF-NAME} ":U + _4GLQury)
                          ELSE "OPEN QUERY ~{&SELF-NAME}":U + 
                               " FOR EACH <record-phrase>.":U.

  
  IF VALID-HANDLE(_P._tv-proc) THEN
    RUN addCodeNode IN _P._tv-proc( _TRG._tSection, RECID(_U), _TRG._tEvent).

  IF _U._TYPE = "BROWSE":U THEN DO:
    CREATE _TRG.
    ASSIGN _TRG._pRECID   = RECID(_P)
           _TRG._tSECTION = "_CONTROL":U
           _TRG._tEVENT   = "DISPLAY":U
           _TRG._wRECID   = _query-u-rec
           _TRG._tSPECIAL = "_DISPLAY-FIELDS":U
           _TRG._tCODE    = "      ":U.
    RUN adeshar/_coddflt.p (INPUT "_DISPLAY-FIELDS", INPUT _query-u-rec, OUTPUT _TRG._tCODE).
    
    /* Not necessary yet 
    IF VALID-HANDLE(_P._tv-proc) THEN
      RUN addCodeNode IN _P._tv-proc( _TRG._tSection, RECID(_U), _TRG._tEvent).
    */

    /* Remove _BC records and their triggers */
    FOR EACH _BC WHERE _BC._x-recid = _query-u-rec:
      FOR EACH _TRG WHERE _TRG._wRECID = RECID(_BC):
        DELETE _TRG.
      END.
      DELETE _BC.
    END.  /* FOR EACH _BC */
  END.
END.

