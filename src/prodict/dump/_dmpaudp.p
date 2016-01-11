/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */

/*************************************************************/
/*------------------------------------------------------------------------

File        : prodict/dump/_dmpaudp.p
Purpose     : Wrapper procedure for dumping audit policies from the database.
              
Parameters  : INPUT pcMode       - The format of the dump file.  There is 
                                   currently only one mode that policies are 
                                   dumped in, using this utility:
                                  
                                   "x" = XML format (.xml)
              
              INPUT pcPolicyList - List of policy names to dump.
                                  
              INPUT pcDumpFiles  - The File or Directory name to Dump to. 
                                   When dumping xml, the output goes to one
                                   file.  
                                                                     
Syntax      :

Description :

Author(s)   : Kenneth S. McIntosh
Created     : April 25, 2005
Notes       : This routine calls procedures in the $DLC/auditing directory 
              to perform the actual dump.
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER pcMode       AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcPolicyList AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcDumpFiles  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cDBName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPolicyList AS CHARACTER NO-UNDO
                                FORMAT "x(255)".

DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField      AS HANDLE    NO-UNDO.

{prodict/sec/sec-func.i}

DEFINE STREAM errStream.

DEFINE VARIABLE gcErrFile     AS CHARACTER   NO-UNDO.

FORM "Policy List:" VIEW-AS TEXT SKIP 
     cPolicyList VIEW-AS EDITOR SIZE 66 BY 3 AT 
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 4
     &ELSE 2 &ENDIF SKIP
     "Database: " VIEW-AS TEXT
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
       AT 10 &ENDIF SPACE(0)
     cDBName VIEW-AS TEXT FORMAT "x(32)" SKIP
     "Dump File:" VIEW-AS TEXT
     &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
       AT 10
     &ENDIF SPACE(0)
     pcDumpFiles VIEW-AS TEXT FORMAT "x(45)"
   WITH FRAME statFrame CENTERED USE-TEXT 
        ROW &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 4
            &ELSE 2 &ENDIF NO-LABELS 
        TITLE "Dumping Audit Policies"
        &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
          VIEW-AS DIALOG-BOX SIZE 75 BY 7 THREE-D
        &ENDIF.
   
gcErrFile = ENTRY(1,pcDumpFiles,".") + ".e".
cDBName   = LDBNAME("DICTDB").

/* If the user is not an Audit Administrator display a message and return. */
IF NOT hasRole(USERID("DICTDB"),"_sys.audit.admin",FALSE) THEN PERM-CHK: DO:
  IF SESSION:BATCH-MODE = FALSE THEN DO:
    OUTPUT STREAM errStream TO VALUE(gcErrFile).
    PUT STREAM errStream UNFORMATTED 
     "You must be an Audit Administrator to access this Dump Option!" CHR(10).
    OUTPUT STREAM errStream CLOSE.

    MESSAGE "You must be an Audit Administrator to access this Dump Option!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.
  ELSE DO:
    OUTPUT STREAM errStream TO VALUE(gcErrFile).
    PUT STREAM errStream UNFORMATTED 
     "You must be an Audit Administrator to access this Dump Option!" CHR(10).
    OUTPUT STREAM errStream CLOSE.
    
    RETURN.
  END.

  MESSAGE "Errors were written to " + 
          REPLACE(pcDumpFiles,".xml",".e") + "."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN.
END.

IF pcPolicyList NE "~*" THEN
  cPolicyList = pcPolicyList.
ELSE DO:
  CREATE BUFFER hBuffer FOR TABLE "DICTDB._aud-audit-policy".
  CREATE QUERY hQuery.
  
  hQuery:SET-BUFFERS(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH _aud-audit-policy NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT hQuery:QUERY-OFF-END:
    cPolicyList = cPolicyList + (IF cPolicyList NE "" THEN "," ELSE "") +
                  hBuffer::_audit-policy-name.
    hQuery:GET-NEXT().
  END.
END.

RUN dumpAuditPolicyAsXML.

PROCEDURE dumpAuditPolicyAsXML:
  DEFINE VARIABLE cErrorMsg    AS CHARACTER   NO-UNDO.

  DISPLAY cPolicyList cDBName pcDumpFiles WITH FRAME statFrame.
  
  RUN adecomm/_setcurs.p ( INPUT "WAIT" ).
  /* It's the caller's responsibility to check if the file exists and 
     check if it should be overwritten */
  RUN auditing/_exp-policies-db.p 
             ( INPUT pcPolicyList,      /* comma-separated list of policies 
                                           or "*" */
               INPUT pcDumpFiles,       /* xml file name */
               INPUT LDBNAME("DICTDB"), /* logical db name */
               OUTPUT cErrorMsg ).

  IF cErrorMsg NE "":U THEN DO:
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

  RUN adecomm/_setcurs.p ( INPUT "" ).

  IF cErrorMsg <> "" THEN DO: 
    MESSAGE "Errors were written to " + 
            REPLACE(pcDumpFiles,".xml",".e") + "."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    HIDE FRAME statFrame.
    RETURN.
  END.

  IF (SESSION:BATCH-MODE = FALSE) THEN
    MESSAGE "Audit Policy dump successful!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

  HIDE FRAME statFrame.
END PROCEDURE.
