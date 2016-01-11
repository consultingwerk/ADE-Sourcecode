/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */

/*************************************************************/
/*------------------------------------------------------------------------

File        : prodict/dump/_lodaudp.p
Purpose     : Wrapper procedure for loading audit policies into the database.
              
Parameters  : INPUT pcMode      - The format of the dump file.  There is 
                                  currently only one mode, supported by 
                                  this utility, for dumping policies:
                                  
                                  "x" = XML format (.xml)
                                                                    
              INPUT pcLoadFiles - The Filename to load from. 
                                  
              INPUT plOverwrite - Indicates whether to automatically overwrite 
                                  duplicate policies found in the db.
                                  
Syntax      :

Description :

Author(s)   : Kenneth S. McIntosh
Created     : April 25, 2005
Notes       : If we're loading from XML this routine calls procedures in 
              the auditing directory to load, otherwise it uses the 
              secure load routine in prodict/dump/_lodsec.p.
History     :
    kmcintos   Aug 18, 2005   Added RETURN to indicate whether policies were 
                              loaded or not 20050629-018.
              

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcMode      AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcLoadFiles AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER plOverwrite AS LOGICAL     NO-UNDO.

{prodict/sec/sec-func.i}

DEFINE STREAM errStream.

DEFINE VARIABLE gcErrFile     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDBName       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE lSuccess      AS LOGICAL     NO-UNDO.

FORM SKIP(1) "Database: " VIEW-AS TEXT
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
       AT 10 &ENDIF SPACE(0)
     cDBName VIEW-AS TEXT FORMAT "x(32)" SKIP
     "Load File: " VIEW-AS TEXT
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
       AT 10
     &ENDIF SPACE(0)
     pcLoadFiles VIEW-AS TEXT FORMAT "x(45)" SKIP(1)
   WITH FRAME statFrame CENTERED USE-TEXT 
        ROW &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 4
            &ELSE 2 &ENDIF NO-LABELS 
        TITLE "Loading Audit Policies"
        &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
          VIEW-AS DIALOG-BOX SIZE 75 BY 5 THREE-D
        &ENDIF.
        
gcErrFile = ENTRY(1,pcLoadFiles,".") + ".e".
cDBName   = LDBNAME("DICTDB").

/* If the user is not an Audit Administrator display a message and return. */
IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN PERM-CHK: DO:
  IF SESSION:BATCH-MODE = FALSE THEN DO:
    OUTPUT STREAM errStream TO VALUE(gcErrFile).
    PUT STREAM errStream UNFORMATTED 
        "You must be an Audit Administrator to access this Load Option!" 
        CHR(10).
    OUTPUT STREAM errStream CLOSE.

    MESSAGE "You must be an Audit Administrator to access this Load Option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.
  ELSE DO:
    OUTPUT STREAM errStream TO VALUE(gcErrFile).
    PUT STREAM errStream UNFORMATTED 
        "You must be an Audit Administrator to access this Load Option!"
        CHR(10).
    OUTPUT STREAM errStream CLOSE.

    RETURN.
  END.

  MESSAGE "Errors were written to " + 
          REPLACE(pcLoadFiles,".xml",".e")
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN.
END.

RUN loadAuditPolicyAsXML.

PROCEDURE loadAuditPolicyAsXML:
  DEFINE VARIABLE cErrorMsg    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE hProc        AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cList        AS CHARACTER   NO-UNDO.

  RUN adecomm/_setcurs.p ( INPUT "WAIT" ).

  DISPLAY cDBName pcLoadFiles WITH FRAME statFrame.

  RUN auditing/_imp-policies.p  PERSISTENT SET hProc.
    
  RUN import-xml-db IN hProc ( INPUT  pcLoadFiles,       /* xml file name */
                               INPUT  LDBNAME("DICTDB"), /* logical db name */
                               INPUT  TRUE,              /* wait on lock */
                               INPUT  plOverwrite,       /* override existing policies */
                               OUTPUT cList,             /* list of duplicate policies */
                               OUTPUT cErrorMsg ).
    
  IF cErrorMsg EQ "":U THEN DO:
    IF cList <> "":U THEN DO:
      IF (SESSION:BATCH-MODE = FALSE) THEN DO:
        RUN adecomm/_setcurs.p ( INPUT "" ).
        MESSAGE "The following policies already exist: " SKIP(1) 
                REPLACE(cList,",",CHR(10)) SKIP(1)
                "Do you want to override them?" SKIP
                "(If Yes the listed policies will be deleted and re-imported)" 
            VIEW-AS ALERT-BOX QUESTION 
            BUTTONS YES-NO UPDATE lChoice AS LOGICAL.
        RUN adecomm/_setcurs.p ( INPUT "WAIT" ).
        IF (lChoice = TRUE) THEN DO:
          RUN save-changes-to-db IN hProc ( INPUT  LDBNAME("DICTDB"), /* logical db name */
                                            INPUT  TRUE,              /* wait on lock */
                                            OUTPUT cErrorMsg ).
          IF cErrorMsg <> "" THEN DO:
            OUTPUT STREAM errStream TO VALUE(gcErrFile).
            PUT STREAM errStream UNFORMATTED cErrorMsg CHR(10).
            OUTPUT STREAM errStream CLOSE.

            MESSAGE cErrorMsg VIEW-AS ALERT-BOX ERROR.
          END.
        END.
      END.
      ELSE DO:
        OUTPUT STREAM errStream TO VALUE(gcErrFile).
        PUT STREAM errStream UNFORMATTED 
            "The following policies already exist and you attempted " +
            " to overwrite them:" 
            CHR(10) CHR(10).
        PUT STREAM errStream UNFORMATTED REPLACE(cList,",",CHR(10)) 
            CHR(10) CHR(10).
        OUTPUT STREAM errStream CLOSE.
      END.
    END. /* If cList ne "" */
  END.
  ELSE DO: 
    IF (SESSION:BATCH-MODE = FALSE) THEN DO:
      OUTPUT STREAM errStream TO VALUE(gcErrFile).
      PUT STREAM errStream UNFORMATTED cErrorMsg CHR(10).
      OUTPUT STREAM errStream CLOSE.

      MESSAGE cErrorMsg VIEW-AS ALERT-BOX ERROR.
    END.
    ELSE DO:
      OUTPUT STREAM errStream TO VALUE(gcErrFile).
      PUT STREAM errStream UNFORMATTED cErrorMsg CHR(10).
      OUTPUT STREAM errStream CLOSE.
    END.
  END.

  RUN cleanup IN hProc.
  DELETE PROCEDURE hProc.

  RUN adecomm/_setcurs.p ( INPUT "" ).

  IF cErrorMsg <> "" THEN DO: 
    MESSAGE "Errors were written to " + 
            REPLACE(pcLoadFiles,".xml",".e") + "."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    HIDE FRAME statFrame.
    RETURN.
  END.

  IF (SESSION:BATCH-MODE = FALSE) THEN DO:
    IF cList NE "" AND lChoice EQ FALSE THEN DO:
      MESSAGE "No Audit Policies were loaded."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      lSuccess = FALSE.
    END.
    ELSE DO:
      MESSAGE "Audit Policy load successful!"
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      lSuccess = TRUE.
    END.
  END.

  HIDE FRAME statFrame.
  IF lSuccess = FALSE THEN
    RETURN "Failed".
  ELSE RETURN "".

END PROCEDURE.
