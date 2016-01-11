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
/*------------------------------------------------------------------------

  File:        af/cod/aftemwizls.p

  Description: Writes the logic procedure. Called from the XFTR in the SDO
               template when the SDO is saved.

  Purpose:     If the logic procedure doesn't exist, this procedure will
               create the logic procedure in the same directory as the
               SDO. If the user specifies a path in the logic procedure, this
               will be ignored.
  Input Parameters:
      piContextID (integer)  - ContextID of internal XFTR block (_TRG)

  Input-Output Parameters:
      pcCode  (character) - code block of XFTR (body of XFTR)

  History:
  
------------------------------------------------------------------------*/

  DEFINE INPUT        PARAMETER piContextID AS INTEGER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcCode      AS CHARACTER NO-UNDO.

 /* {adeuib/sharvars.i}.*/
  DEFINE SHARED VARIABLE _Save_file AS CHARACTER  NO-UNDO.
  DEFINE SHARED VARIABLE _p_status  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cDefCode       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContextID     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRecID         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iStart         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEnd           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLine          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicProc     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelLogicProc  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSDOName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelSDOName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRelPath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicTemplate AS CHARACTER  NO-UNDO INIT "ry/obj/rytemlogic.p":U.
  DEFINE VARIABLE cTables        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryContext  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAction        AS CHARACTER    NO-UNDO.
 
  /* Only write datalogic procedure if saving object, not when doing 
     check-syntax, printing, preview, etc.. */
  IF NOT _p_status BEGINS "SAVE":U THEN
     RETURN.


  RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "DATA-LOGIC-PROCEDURE":U, OUTPUT cContextID).
  ASSIGN cLogicProc = trim(cContextID).

  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "ACTION":U, OUTPUT cContextID).
  ASSIGN cAction = trim(cContextID)  NO-ERROR.

  IF cLogicProc <> "" THEN
  DO:
    ASSIGN cSDOName = _Save_file
           cSDOName = REPLACE(cSDOName, "~\":U,"/":U).
    IF cSDOName = ? THEN
      RUN adeuib/_uibinfo.p (INT(piContextID),?,"FILE-NAME":U, OUTPUT cSDOName).
   
    IF cSDOName = ? OR cSDOName = "" THEN
       RETURN.

    /* Only create DLPs for new objects. */
    IF SEARCH(cLogicProc) = ? AND CAN-DO(cAction,"NEW":U) THEN
    DO:
          /* Get the Table names of the query */
       RUN adeuib/_uibinfo.p (INT(piContextID), "PROCEDURE ?":U, 
                              "CONTAINS QUERY RETURN CONTEXT":U, 
                              OUTPUT cQueryContext).

       RUN adeuib/_uibinfo.p (INPUT INT(cQueryContext), ?,"TABLES":U, OUTPUT cTables).
       ASSIGN cTables = ENTRY(1,cTables)
              cTables = IF NUM-ENTRIES(cTables,".") > 1
                        THEN ENTRY(2,cTables,".")
                        ELSE cTables.

      /* Add the directory of the SDO to the logic procedure.
         First strip out any subdirectory of the logic procedure*/
      IF NUM-ENTRIES(cLogicProc,"/") > 1 THEN
         ASSIGN cLogicProc = TRIM(SUBSTRING(cLogicProc,R-INDEX(cLogicProc,"/") + 1)).
      
      /* Ensure the logic proc has a .p extension */
      IF NUM-ENTRIES(cLogicProc,".") > 2 THEN
      DO:
         MESSAGE "The specified logic procedure has an invalid format." + CHR(10) +
                 "Only one dot (.) may be specified in the name." + CHR(10) +
                 "Logic procedure not created."
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
      END.
      ELSE IF NUM-ENTRIES(cLogicProc,".") <= 1 THEN
        ASSIGN cLogicProc = cLogicProc + ".p":u.
      ELSE IF NUM-ENTRIES(cLogicProc,".":u) = 2 AND INDEX(cLogicProc,".p":u) = 0 THEN
        ASSIGN cLogicProc = ENTRY(1,cLogicProc,".") + ".p":u.

      cLogicProc    = TRIM(SUBSTRING(cSDOName,1,R-INDEX(cSDOName,"/"))) + cLogicProc.
      
      IF cSDOName > "" THEN
        RUN adecomm/_relfile.p (cSDOName,
                                NO, /* Never check remote */
                                "Verbose":U, 
                                OUTPUT cRelSDOName).
      /* Strip out the filename from the relative filename */
      /* Add the relative path of the SDO to the logic procedure */
      ASSIGN cRelPath      = TRIM(SUBSTRING(cRelSDOName,1, R-INDEX(cRelSDOName,"/") ))
             cRelLogicProc = cRelPath + ENTRY(NUM-ENTRIES(cLogicProc,"/"),cLogicProc,"/").
      /* Run the procedure to create the new business logic procedure */
      RUN af/app/fullocrea2.p (cLogicTemplate, cLogicProc,cTables,cSDOName,cRelLogicProc,cRelSDOName) NO-ERROR.
      

    END. /* END Search(cLogicProc) = ? */
    
  END. /* END cLogicProc <> ".p" and cLogicProc <>"" */

  
