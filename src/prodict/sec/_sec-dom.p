&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
/*************************************************************/
/* Copyright (c) 1984-2007,2011 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------

  File: prodict/sec/_sec-dom.p

  Description: Maintenance dialog for the _sec-authentication-domain table.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: April 25, 2005

  History: 
    kmcintos May 24, 2005  Added validation for Name and Type fields 
                           20050524-013.
    kmcintos May 25, 2005  Removed return when not available from browse 
                           value-changed trigger 20050524-012.
                           
                           Also had to refine some navigation logic.
    kmcintos May 26, 2005  Added validation to prevent saving duplicate 
                           domain 20050525-047.
    kmcintos June 7, 2005  Removed local help button trigger to allow the one 
                           in sec-trgs.i to fire.
    kmcintos June 17, 2005 Added logic in localSave to encrypt access code 
                           using the new ENCRYPT-AUDIT-MAC-KEY method of
                           the AUDIT-POLICY handle 20050614-032.
    kmcintos Oct 28, 2005  Added code to enforce mandatory assignment of
                           access code 20051028-022.
    fernando 11/30/07      Check if read-only mode.   
    rkamboj  08/16/11      Added new terminology for security items and windows.  
    rkamboj  09/14/11      Added support for allowing edit of all fields 
                           except Domain name, Tenant Name and System Type.
    rkmaboj  05/04/2012    Fixed default domain save problem.                       
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

{prodict/sec/sec-func.i}
{prodict/sec/ui-procs.i}
{prodict/misc/misc-funcs.i}

/* ***************************  Definitions  ************************** */
CREATE WIDGET-POOL.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to access this utility!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.
          
IF checkReadOnly("DICTDB","_sec-authentication-system") NE "" OR
   checkReadOnly("DICTDB","_sec-authentication-domain") NE "" THEN
   RETURN.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE saDom NO-UNDO RCODE-INFORMATION
    FIELD dName       AS CHARACTER LABEL "Name"             FORMAT "x(70)"
/*                                   CASE-SENSITIVE*/
    FIELD dType       AS CHARACTER LABEL "System Type" /* "Type" */             FORMAT "x(70)"
    FIELD dTenantName AS CHARACTER LABEL "Tenant Name"      FORMAT "x(32)"
    FIELD dDescrip    AS CHARACTER LABEL "Description"      FORMAT "x(255)"
    FIELD dAccessCode AS CHARACTER LABEL "Access Code"      FORMAT "x(255)"
    FIELD dAContext   AS CHARACTER LABEL "Auditing Context" FORMAT "x(255)"
    FIELD dROptions   AS CHARACTER LABEL "Runtime Options"  FORMAT "x(255)"
    FIELD dPAMOptions AS CHARACTER LABEL "System Options" /* "PAM Options" */     FORMAT "x(255)"
    FIELD dComments   AS CHARACTER LABEL "Custom Detail"    FORMAT "x(255)"
    FIELD dEnabled    AS LOGICAL   LABEL "Enabled"          FORMAT "Yes/No"
    FIELD dCategory   as integer   label "Category"    format "9"
    INDEX idxDomain   AS PRIMARY UNIQUE dName.

DEFINE VARIABLE gcSort        AS CHARACTER   NO-UNDO INITIAL "dName".
DEFINE VARIABLE gcSystemList  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcMods        AS CHARACTER   NO-UNDO.
define variable gcDoneLabel   as character   no-undo.
DEFINE VARIABLE inbuild       AS LOGICAL     NO-UNDO.
define variable gcOkLabel   as character   no-undo init "&OK".

define variable glInSelect      as logical no-undo.
/* ui behavior variables set in loadMultiTenantInfo */
define variable gcTenantName    as character  no-undo.
define variable glViewTenant    as logical    no-undo.
define variable glEnableTenant  as logical    no-undo.
define variable glMultiTenant   as logical    no-undo.
define variable ghBrowse        as handle     no-undo.
define variable ghQuery         as handle     no-undo.
define variable glInit          as logical    no-undo.

DEFINE QUERY qDomain1 FOR saDom SCROLLING.
DEFINE QUERY qDomain2 FOR saDom SCROLLING.

DEFINE BROWSE bDomainTenant  QUERY qDomain1
    DISPLAY dName width 42
            dTenant width 32
            dType width 20
            dDescrip width 45
             dEnabled view-as toggle-box
            /*
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE dName &ENDIF
    */
    WITH NO-ROW-MARKERS SEPARATORS  
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 14 DOWN WIDTH 75 NO-BOX
         &ELSE 15 DOWN WIDTH 98 &ENDIF FIT-LAST-COLUMN.

DEFINE BROWSE bDomainShared QUERY qDomain2
    DISPLAY dName width 32
            dType width 20
            dDescrip width 32
            dEnabled view-as toggle-box
    /*
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
      ENABLE dName &ENDIF
    */
    WITH NO-ROW-MARKERS SEPARATORS
         &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 14 DOWN WIDTH 75 NO-BOX
         &ELSE 15 DOWN WIDTH 98 &ENDIF FIT-LAST-COLUMN.



/* ********************  Preprocessor Definitions  ******************** */


&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame
 
/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCancel 
     LABEL "Ca&ncel" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnCreate 
     LABEL "&Create" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDelete 
     LABEL "Delete" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnDone 
     LABEL "&Done" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnTenant 
     LABEL "&Select Tenant..." 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 18 BY 1
     &ELSE SIZE 18 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnNext 
     LABEL ">" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 4 BY .95 &ENDIF
     BGCOLOR 8 .
     
DEFINE BUTTON btnPrev 
     LABEL "<" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 8 BY 1
     &ELSE SIZE 4 BY .95 &ENDIF
     BGCOLOR 8 .

DEFINE BUTTON btnSave 
     LABEL "&Save" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.

DEFINE BUTTON btnModify 
     LABEL "&Modify" 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 10 BY 1
     &ELSE SIZE 11 BY .95 &ENDIF.



&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  DEFINE BUTTON BtnHelp DEFAULT 
       LABEL "&Help" 
       SIZE 11 BY .95
       BGCOLOR 8 .
        
  DEFINE RECTANGLE RECT-1
       EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
       &ELSE SIZE 98 BY 1.52 &ENDIF.      
       
  DEFINE RECTANGLE RECT-2
       EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
       &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 2 BY 1
       &ELSE SIZE 78 BY 1.52 &ENDIF.
&ENDIF


DEFINE VARIABLE cbType AS CHARACTER FORMAT "X(256)":U 
     LABEL "System Type" /* "Type" */
     VIEW-AS COMBO-BOX 
     INNER-LINES &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 3 &ELSE 5 &ENDIF
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
     SIZE 36 BY 1
     &ELSE 
     SIZE 59.4 BY 1 
     &ENDIF 
     NO-UNDO.


DEFINE VARIABLE fiAContext AS CHARACTER FORMAT "X(256)":U 
     LABEL "Audit Context" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiAccessCode AS CHARACTER FORMAT "X(256)":U  
     LABEL "Access Code" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE edDescription AS CHARACTER
     LABEL "Description"  
      VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 4
     &ELSE SIZE 59.4 BY 2.91 &ENDIF NO-UNDO.

DEFINE VARIABLE edComments AS CHARACTER
     LABEL "Comments"  
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 4
     &ELSE SIZE 59.4 BY 2.91 &ENDIF NO-UNDO.



DEFINE VARIABLE fiTenant AS CHARACTER FORMAT "X(32)":U 
     LABEL "Tenant Name" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 32 BY 1
     &ELSE SIZE 40.49 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

 
DEFINE VARIABLE lblEnabled AS CHARACTER FORMAT "X(256)":U 
                              INITIAL "Domain Enabled:" 
      VIEW-AS TEXT 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 16 BY 1
     &ELSE SIZE 17 BY .62 &ENDIF NO-UNDO.


DEFINE VARIABLE fiROptions AS CHARACTER FORMAT "X(256)":U 
     LABEL "Runtime Options" 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.

DEFINE VARIABLE fiPAMOptions AS CHARACTER FORMAT "X(256)":U 
     LABEL "System Options" /* "PAM Options" */ 
     VIEW-AS FILL-IN 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN SIZE 58 BY 1
     &ELSE SIZE 59.4 BY 1 &ENDIF NO-UNDO.
                    
DEFINE VARIABLE tbEnabled AS LOGICAL INITIAL no 
     &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
     LABEL "Domain Enabled" 
     VIEW-AS FILL-IN 
     SIZE 3 BY 1
     &ELSE 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .71 
     &ENDIF 
     NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Browse-Frame
     bDomainTenant at 2
     bDomainShared at col-of bDomainTenant row-of bDomainTenant
     btnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT row 18 col 2
          &ELSE AT ROW 15.62 COL 3 &ENDIF  
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 25
          &ELSE AT ROW 15.62 COL 18.2 &ENDIF
     btnModify
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 36
          &ELSE AT ROW 15.62 COL 29.6 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 47
          &ELSE AT ROW 15.62 COL 41 &ENDIF
     
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       BtnHelp AT ROW 15.62 COL 88
       RECT-1 AT ROW 15.33 COL 2 
     &ENDIF 

WITH 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     VIEW-AS DIALOG-BOX THREE-D WIDTH 100
        &ELSE

        overlay
        
        &ENDIF 
     KEEP-TAB-ORDER ROW 1 SIDE-LABELS  
     NO-UNDERLINE 
     SCROLLABLE /* avoid rect-2 size error in gui */
     CENTERED
     
     TITLE "Domains" /* "Authentication System Domains" */
     DEFAULT-BUTTON btnDone.
 
DEFINE FRAME Dialog-Frame
     
     fiName   COLON 18      
     fiTenant COLON 18 btnTenant 
     cbType colon 18
   /*
           &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN
     tbEnabled   SKIP
           &endif
     */
     fiAccessCode PASSWORD-FIELD COLON 18
     fiAContext COLON 18 
     
     fiROptions  COLON 18
     fiPAMOptions  COLON 18
     edDescription   COLON 18 
     edComments  COLON 18 
     lblEnabled NO-LABEL VIEW-AS TEXT 
        &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
        AT 3
        &ELSE
        AT 4
        &ENDIF 
     tbEnabled NO-LABEL COLON 18 SKIP(1)
            
     btnDone
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 2
          &ELSE AT ROW 19.6 COL 3 &ENDIF
     btnCreate
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 15
          &ELSE AT ROW 19.62 COL 14.2 &ENDIF
     btnSave
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 26
          &ELSE AT ROW 19.62 COL 25.4 &ENDIF
     btnCancel
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 37
          &ELSE AT ROW 19.62 COL 36.8 &ENDIF
     btnDelete
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN AT 48
          &ELSE AT ROW 19.62 COL 48 &ENDIF
     btnPrev
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
             LABEL "&Prev" AT 61
          &ELSE 
             AT ROW 19.62 COL 59.2 
          &ENDIF     
     btnNext
          &IF '{&WINDOW-SYSTEM}' = 'TTY':U &THEN 
              LABEL "&Next"  AT 70
          &ELSE 
            AT ROW 19.62 COL 63.5 
          &ENDIF
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
       BtnHelp AT ROW 19.62 COL 67.76
       RECT-2 AT ROW 19.33 COL 2 
       
     &ENDIF 
/*     SPACE(1.39) SKIP(0.14)*/
 WITH 
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     VIEW-AS DIALOG-BOX THREE-D 
        &ELSE
    
    VIEW-AS DIALOG-BOX 
    WIDTH 80
        
        &ENDIF 
     KEEP-TAB-ORDER ROW 1 SIDE-LABELS  
     NO-UNDERLINE 
     SCROLLABLE /* avoid rect-2 size error in gui */
     CENTERED
     TITLE "Domains" /* "Authentication System Domains" */
     DEFAULT-BUTTON btnDone.


/* ************************  Functions ********************** */


function createQuery returns handle (  ):
    define variable hQuery as handle no-undo. 
    create query hQuery.
    hQuery:add-buffer(buffer saDom:handle).
    return hQuery.
end function.    

/* ** load MT info and define triggers ************************************************* */


RUN loadMultiTenantInfo.
if glViewTenant then
do: 
     ghBrowse = browse bdomainTenant:handle.
     browse bDomainShared:hidden = true.
end.
else do:
     ghBrowse = browse bdomainShared:handle.
     browse bDomainTenant:hidden = true.
end.

{prodict/sec/sec-trgs.i
      &frame_name    =   "Dialog-Frame"}
      
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  ghBrowse:HELP = KBLABEL("CTRL-A") + "=Create  " +
                        KBLABEL("DEL")    + "=Delete  " +
                        KBLABEL("GO")     + "=Done".
  cbType:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Domain Type then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiName:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Domain Name then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiAccessCode:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Access Code then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiAContext:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Auditing Context then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  fiROptions:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Runtime Options then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edDescription:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Description then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  edComments:HELP IN FRAME {&FRAME-NAME} =
                  "Enter Comments then hit " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
  tbEnabled:HELP IN FRAME {&FRAME-NAME} =
                  "Hit Spacebar, " + KBLABEL("GO") +
                  " to Save or " + KBLABEL("CTRL-N") + " to Cancel".
&ENDIF

/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

/* SETTINGS FOR DIALOG-BOX Dialog-Frame FRAME-NAME */
ASSIGN FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* ************************  Control Triggers  ************************ */

ON WINDOW-CLOSE OF FRAME Dialog-Frame  
DO:
  APPLY "END-ERROR":U TO SELF.
END.

ON WINDOW-CLOSE OF FRAME Browse-Frame  
DO:
  APPLY "END-ERROR":U TO SELF.
END.

on choose of btnCreate in frame browse-frame do: 
   run OpenDialog("create").
end.

on choose of btnModify in frame browse-frame do: 
   run OpenDialog("Modify").
end.

on choose of btnDelete in frame browse-frame do: 
   RUN deleteRecord.
   RUN localTrig ( INPUT "Delete" ).
end.

on default-action of ghBrowse do:
   run OpenDialog("Modify").
end.    

ON CHOOSE OF btnTenant IN FRAME {&FRAME-NAME} 
DO:
    run selectTenant.
END.

ON CHOOSE OF btnNext IN FRAME {&frame-name} DO:
    ghQuery:reposition-forward (0).
    run display.
END.

ON CHOOSE OF btnPrev IN FRAME {&frame-name} DO:
    ghQuery:reposition-backward (2).  
    run display.
END.

/* overrides sec-trgs.i */
ON CHOOSE OF btnSave DO :
    DEFINE VARIABLE err AS LOGICAL NO-UNDO.
  IF inbuild THEN 
  DO:
      
      RUN localSave ( INPUT "Before" ).
      IF RETURN-VALUE NE "" THEN
         RETURN RETURN-VALUE.  
      FIND FIRST DICTDB._sec-authentication-domain 
           WHERE DICTDB._sec-authentication-domain._Domain-name = TRIM(fiName:SCREEN-VALUE) NO-ERROR.
      IF AVAILABLE (DICTDB._sec-authentication-domain) THEN 
      DO:
          ASSIGN DICTDB._sec-authentication-domain._Domain-enabled = LOGICAL(tbEnabled:SCREEN-VALUE)
                 err = no.
          FIND FIRST saDom WHERE saDom.dName = TRIM(fiName:SCREEN-VALUE) NO-ERROR.
          IF AVAILABLE (saDom) THEN 
          DO:
              
             ASSIGN saDom.dEnabled =  DICTDB._sec-authentication-domain._Domain-enabled.
          END.              
          IF cbType:SCREEN-VALUE <>  DICTDB._sec-authentication-domain._Domain-type THEN 
          DO:
             err = YES. 
             RUN saveRecord.
             ASSIGN saDom.dType = DICTDB._sec-authentication-domain._Domain-type.
          END.   
      END.
      IF NOT err THEN 
      DO:
          RUN localSave ( INPUT "After" ).
          RUN setButtonState ( INPUT "ResetMode" ).
          RUN setFieldState  ( INPUT "ResetMode" ).
      END.    
              
  END.
  else    
     RUN saveRecord.
  
  IF RETURN-VALUE = "Retry" THEN
    RETURN NO-APPLY.
  IF RETURN-VALUE = "Fatal" THEN DO:
    RUN cancelRecord.
    RETURN NO-APPLY.
  END.
                 
  IF CAN-DO(THIS-PROCEDURE:INTERNAL-ENTRIES,"localTrig") THEN
    RUN localTrig ( INPUT "Save" ).

  APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF btnHelp IN FRAME BROWSE-Frame OR
CHOOSE OF btnHelp IN FRAME BROWSE-Frame 
DO:
    RUN adecomm/_adehelp.p ( INPUT "admn", 
                               INPUT "CONTEXT", 
                               INPUT {&Domains_Dialog_Box},
                               INPUT ? ).
end.
&ENDIF
ON CHOOSE OF btnDone IN FRAME {&frame-name} DO:
   IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} = true THEN
   do:
       apply "choose" to btnSave IN FRAME {&FRAME-NAME}.
   end.
   IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} = false then
       APPLY "WINDOW-CLOSE" TO FRAME {&frame-name}.
    
END.

ON CHOOSE OF btnDone IN FRAME browse-frame DO:
    APPLY "WINDOW-CLOSE" TO FRAME browse-frame.
end.

ON "GO" OF FRAME {&FRAME-NAME} DO:
  IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE THEN
    LEAVE.
  
  APPLY "CHOOSE" TO btnSave IN FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.
END.

ON VALUE-CHANGED OF fiTenant IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dTenant NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF cbType IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dType NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.



ON VALUE-CHANGED OF edDescription IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dDescrip NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF fiAccessCode IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dAccessCode NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF fiROptions IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dROptions NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF fiPAMOptions IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF  AVAILABLE saDom 
  AND saDom.dPAMOptions NE SELF:SCREEN-VALUE THEN 
  DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.


ON VALUE-CHANGED OF tbEnabled IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  IF AVAILABLE saDom AND
    saDom.dEnabled NE logical(SELF:screen-value) THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

ON VALUE-CHANGED OF ghBrowse DO:
  RUN display. 
END.

ON END-ERROR ANYWHERE DO:
   
  IF glinselect = false and btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
    APPLY "CHOOSE" TO btnCancel.
/*    RETURN NO-APPLY.*/
  END.
  
END.

ON VALUE-CHANGED OF fiAContext IN FRAME {&FRAME-NAME} DO:
  IF glCreateMode THEN LEAVE.
  
  IF AVAILABLE saDom AND
    saDom.dAContext NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
  END.
  ELSE DO:
    gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
    IF gcMods EQ "" OR
       gcMods EQ "," THEN DO:
      ghBrowse:SENSITIVE = TRUE.
      gcMods = "".
      RUN setButtonState ( "ResetMode" ).
    END.
  END.
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
/*  saDom.dName:READ-ONLY IN ghBrowse = TRUE.*/
  ON START-SEARCH OF ghBrowse DO:
    DEFINE VARIABLE cCol AS CHARACTER  NO-UNDO.
    ghBrowse:clear-sort-arrows().
    cCol = SELF:CURRENT-COLUMN:NAME.
    IF gcSort EQ cCol THEN
    do:
       SELF:CURRENT-COLUMN:sort-ascending = false.
       gcSort = cCol + " DESC".
    end.
    ELSE do:
       SELF:CURRENT-COLUMN:sort-ascending = true. 
       gcSort = cCol.
    end.
    RUN openQuery.
    apply "end-search" to ghBrowse. 
  END.

  ON VALUE-CHANGED OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.
    
    IF AVAILABLE saDom AND
       saDom.dComments NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN 
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR 
         gcMods EQ "," THEN DO:
        ghBrowse:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.  
    END.
  END.
&ELSE
  /* tbenabled is fill-in in tty so disallow ? */
  ON ANY-PRINTABLE OF tbEnabled IN FRAME {&FRAME-NAME} DO:
      if last-event:label = "?" then
      do:
          bell.
          return no-apply. 
      end.    
  END. 
  /*  
  ON ENTRY OF ghBrowse DO:
    IF LAST-EVENT:WIDGET-LEAVE = 
        btnDelete:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
      APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.

  ON LEAVE OF btnCreate IN FRAME {&FRAME-NAME} DO:
    IF btnDelete:SENSITIVE IN FRAME {&FRAME-NAME} EQ FALSE THEN DO:
      APPLY "ENTRY" TO btnDone IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.
                        
  ON ENTRY OF btnDone IN FRAME {&FRAME-NAME} DO:
    IF NOT ronly AND LAST-EVENT:WIDGET-LEAVE EQ
              ghBrowse:HANDLE THEN DO:
      APPLY "ENTRY" TO btnCreate IN FRAME {&FRAME-NAME}.
      RETURN NO-APPLY.
    END.
  END.
           
  ON ENTRY OF btnCreate DO:
     
    IF LAST-EVENT:WIDGET-LEAVE =
        btnDone:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
/*      APPLY "ENTRY" TO ghBrowse.*/
      RETURN NO-APPLY.
    END.
  END.
  */
  ON CTRL-N ANYWHERE DO:
    IF btnCancel:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
      IF FOCUS EQ edcomments:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
        IF gcMods NE "" THEN
          APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
        ELSE RETURN NO-APPLY.
      END.
      ELSE APPLY "CHOOSE" TO btnCancel IN FRAME {&FRAME-NAME}.
    END.
    ELSE RETURN NO-APPLY.
  END.
  
  ON CTRL-CURSOR-RIGHT ANYWHERE DO:
    IF btnNext:SENSITIVE IN FRAME {&FRAME-NAME} THEN  
        APPLY "CHOOSE" TO btnNext IN FRAME {&FRAME-NAME}.
   RETURN NO-APPLY.
  END.
  
  ON CTRL-CURSOR-LEFT ANYWHERE DO:
    IF btnPrev:SENSITIVE IN FRAME {&FRAME-NAME} THEN  
        APPLY "CHOOSE" TO btnPrev IN FRAME {&FRAME-NAME}.
   RETURN NO-APPLY.
  END.
  
  
  ON CTRL-A ANYWHERE DO:
    IF btnCreate:SENSITIVE IN FRAME {&FRAME-NAME} OR
       (FOCUS = edcomments:HANDLE IN FRAME {&FRAME-NAME} AND
        gcMods EQ "") THEN
      APPLY "CHOOSE" TO btnCreate IN FRAME {&FRAME-NAME}.
    ELSE RETURN NO-APPLY.
  END.
  
  ON CTRL-S ANYWHERE DO:
    IF btnSave:SENSITIVE IN FRAME {&FRAME-NAME} OR
       (FOCUS = edcomments:HANDLE IN FRAME {&FRAME-NAME} AND
        gcMods EQ "") THEN
      APPLY "CHOOSE" TO btnSave   IN FRAME {&FRAME-NAME}.
    ELSE RETURN NO-APPLY.
  END.

  ON DEL OF ghBrowse DO:
    IF AVAILABLE saDom THEN
      APPLY "CHOOSE" TO btnDelete IN FRAME {&FRAME-NAME}.
  END.

  ON ENTRY OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.

    RUN setButtonState ( INPUT "UpdateMode" ).
    ghBrowse:SENSITIVE = FALSE.
  END.

  ON LEAVE OF edComments IN FRAME {&FRAME-NAME} DO:
    IF glCreateMode THEN LEAVE.

    IF AVAILABLE saDom AND
     saDom.dComments NE SELF:SCREEN-VALUE THEN DO:
      RUN setButtonState ( INPUT "UpdateMode" ).
      ghBrowse:SENSITIVE = FALSE.
      IF NOT CAN-DO(gcMods,SELF:NAME) THEN
        gcMods = gcMods + (IF gcMods NE "" THEN "," ELSE "") +
                 SELF:NAME.
    END.
    ELSE DO:
      gcMods = REPLACE(REPLACE(gcMods,SELF:NAME,""),",,",",").
      IF gcMods EQ "" OR
         gcMods EQ "," THEN DO:
        ghBrowse:SENSITIVE = TRUE.
        gcMods = "".
        RUN setButtonState ( "ResetMode" ).
      END.
      /** go to create if save was disabled **/
      IF LAST-EVENT:WIDGET-ENTER = btnSave:HANDLE IN FRAME {&FRAME-NAME} THEN 
      DO:
         if btnSave:sensitive = false then 
         do:      
            APPLY "ENTRY" TO btnCreate IN FRAME {&FRAME-NAME}.  
            RETURN NO-APPLY.
         end. 
       END.     
    END.
  END.

&ENDIF

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enableBrowseUI.
  RUN initializeBrowseUI.
  WAIT-FOR GO OF FRAME browse-frame.
END.
RUN disable_UI.

/* **********************  Internal Procedures  *********************** */

PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME Dialog-Frame.
END PROCEDURE.


PROCEDURE OpenDialog:
    define input  parameter pcMode as character no-undo.
    if not glInit then
    do: 
        
        run initializeUI.
        run enable_UI.
        glInit = true.
    end.    
    else 
        view frame dialog-frame.
    run display.
    if pcMode = "Create" then 
        apply "choose" to btnCreate in frame dialog-frame.
    do on error   undo, leave
       on end-key undo, leave:
        wait-for go of frame dialog-frame.
    end.
    hide frame dialog-Frame.
end.

PROCEDURE enableBrowseUI :
   ENABLE 
       bDomainTenant when glViewtenant
       bDomainShared when not glViewtenant
       btnDone
       btnCreate
       btnModify
    &IF "{&WINDOW-SYSTEM}" <>  "TTY" &THEN
       btnHelp
    &ENDIF
    WITH FRAME BROWSE-Frame.
    VIEW FRAME BROWSE-Frame.

END procedure.

PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
   
  DISPLAY 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      cbType   tbEnabled fiTenant when glViewtenant fiName fiAccessCode fiAContext edDescription fiROptions edComments lblEnabled  
  &ELSE
      
      cbType fiTenant when glViewtenant fiName fiAccessCode fiAContext edDescription   fiROptions edComments lblEnabled tbEnabled
   &ENDIF
    
   WITH FRAME Dialog-Frame.
 
  
  ENABLE
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      fiTenant when glViewtenant
      btnTenant when glViewtenant
      cbType 
      tbEnabled  
      fiName 
      fiAccessCode 
      fiAContext 
      edDescription 
      fiROptions 
      edComments 
      btnSave 
      btnCancel 
      btnDone 
  
  &ELSE  
      fiTenant when glViewtenant
      btnTenant when glViewtenant
      cbType 
      fiName 
      fiAccessCode 
      fiAContext 
      edDescription 
      fiROptions 
      edComments 
      tbEnabled 
      btnCreate 
      btnSave 
      btnCancel 
      btnPrev
      btnNext
      btnDelete 
      btnDone 
      BtnHelp RECT-2 
      &ENDIF
  
   WITH FRAME Dialog-Frame.
 
   VIEW FRAME Dialog-Frame.
END PROCEDURE.

PROCEDURE initializeBrowseUI:
  ghBuffer   = BUFFER saDom:HANDLE.
  gcFileName = "Domains" /* "Authentication System Domains" */ .
  
 
  RUN loadDomains.
  
  IF NUM-DBS > 0 THEN
    FRAME browse-frame:TITLE = FRAME browse-frame:TITLE +
                                " (" + LDBNAME("DICTDB") + ")".
  ghFrame  = FRAME {&FRAME-NAME}:HANDLE.
  gcDBBuffer = "DICTDB._sec-authentication-domain".
  gcKeyField = "_domain-name,dName,CHAR".
  
  ghQuery = createQuery().
  ghBrowse:query = ghQuery. 
  RUN openQuery.
  
  ghBrowse:set-repositioned-row(1 ,"conditional":U). 
   
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ghBrowse:allow-column-searching = true. 
   &ENDIF
    
  APPLY "ENTRY" TO ghBrowse.
  APPLY "VALUE-CHANGED" TO ghBrowse.
END PROCEDURE.

PROCEDURE initializeUI:
  ghBuffer   = BUFFER saDom:HANDLE.
  gcFileName = "Domains" /* "Authentication System Domains" */ .
  
  DO WITH FRAME {&FRAME-NAME}:
    /* order is not same as ui  - new fields have been added at end (less risk) */ 
     setFieldHandles(STRING(cbType:HANDLE)        + "," +
                     STRING(fiName:HANDLE)        + "," + 
                     STRING(fiAccessCode:HANDLE)  + "," + 
                     STRING(fiAContext:HANDLE)    + "," + 
                     STRING(fiROptions:HANDLE)    + "," + 
                     STRING(edDescription:HANDLE) + "," +
                     STRING(edComments:HANDLE)    + "," + 
                     STRING(tbEnabled:HANDLE)     + "," + 
                     STRING(fiTenant:handle)     + "," + 
                     STRING(fiPAMOptions:handle)). 
      setInitValues("_oeusertable" + CHR(1)
                    + "" + CHR(1) 
                    + "" + CHR(1)
                    + "" + CHR(1) 
                    + "" + CHR(1) 
                    + "" + CHR(1) 
                    + "" + CHR(1) 
                    + "YES" + CHR(1) 
                    + gcTenantName + CHR(1)
                    + "").
      /*tenantname 9 is handled in localFieldState */                                     
      setCreateModeValues("yes,yes,yes,yes,yes,yes,yes,yes,no,yes").
      /* we handle fields in localFieldState 
         editors 6 7 are set to sensitive here and read-only is used in localFieldState */  
       setResetModeValues("iab,no,no,no,no,yes,yes,iab,no,no"). 
            setDisableModeValues("no,no,no,no,no,no,no,no,no,no").
      assign
           gcDBFields          = "_domain-type,_domain-name," +
                                 "_domain-access-code,_auditing-context," +
                                 "_domain-runtime-options," +
                                 "_domain-description," +
                                 "_domain-custom-detail,_domain-enabled," +
                                 "_tenant-name,_PAM-options"
           gcTTFields          = "dType,dName,dAccessCode,dAContext," + 
                                 "dROptions,dDescrip,dComments,dEnabled," +
                                 "dTenantName,dPAMOptions"
           ghFrame             = FRAME {&FRAME-NAME}:HANDLE.
          
   
    RUN loadSystemList.
    IF NUM-DBS > 0 THEN
        FRAME {&FRAME-NAME}:TITLE = FRAME {&FRAME-NAME}:TITLE +
                                   " (" + LDBNAME("DICTDB") + ")".
    cbType:LIST-ITEMS = gcSystemList.
  END.

  RUN layout. 
  
END PROCEDURE.

PROCEDURE loadSystemList:
  DEFINE VARIABLE hBuff  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE    NO-UNDO.
  
  CREATE BUFFER hBuff FOR TABLE "DICTDB._sec-authentication-system".
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuff).
  hQuery:QUERY-PREPARE("FOR EACH _sec-authentication-system NO-LOCK" +
                       " BY _domain-type").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  DO WHILE NOT hQuery:QUERY-OFF-END:
    gcSystemList = gcSystemList 
                   + (if gcSystemList = "" then "" else  ",")
                   + hBuff::_domain-type.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hQuery.
  DELETE OBJECT hBuff.
END PROCEDURE.

PROCEDURE checkTenantName:
   define input  parameter pcTenant as character no-undo. 
   define output  parameter plOk as logical no-undo.
   define variable hBuff as handle no-undo.

   CREATE BUFFER hBuff FOR TABLE "DICTDB._tenant".
   plok = hBuff:find-unique ("where _tenant._Tenant-name = " + quoter(pcTenant)) no-error.
end procedure. 

PROCEDURE loadMultiTenantInfo:
  define variable hBuff     as handle no-undo.  
  define variable iTenantid as integer no-undo.
  
  /* the code has no static db reference so use buffer */
  if int(dbversion("dictdb")) > 10 then
  do:
      CREATE BUFFER hBuff FOR TABLE "DICTDB._tenant".
      glMultiTenant = hBuff:find-first () no-error.
      if glMultiTenant then 
      do:
          gcTenantName = tenant-name(ldbname("dictdb")).
          glViewTenant = yes.
          glEnableTenant = yes. 
    
      end.
  end.
   
END.

PROCEDURE loadDomains:
  DEFINE VARIABLE hBuff  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery AS HANDLE    NO-UNDO.
  
  CREATE BUFFER hBuff FOR TABLE "DICTDB._sec-authentication-domain".
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuff).
  
  hQuery:QUERY-PREPARE("FOR EACH _sec-authentication-domain NO-LOCK").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  
  DO WHILE NOT hQuery:QUERY-OFF-END:
    DO TRANSACTION ON ERROR UNDO, NEXT:
      CREATE saDom.
      ASSIGN dName       = hBuff::_domain-name
             dType       = hBuff::_domain-type
             dTenant     = hBuff::_tenant-name
             dDescrip    = hBuff::_domain-description
             dAccessCode = hBuff::_domain-access-code
             dAContext   = hBuff::_auditing-context
             dROptions   = hBuff::_domain-runtime-options
             dEnabled    = hBuff::_domain-enabled
             dComments   = hBuff::_domain-custom-detail
             dCategory   = hBuff::_domain-category
             dPAMOptions = hBuff::_PAM-options.
    END.
    hQuery:GET-NEXT().
  END.

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuff.
END PROCEDURE.

procedure localFieldState:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/
  define input  parameter pcMode as character no-undo.
  define variable lok as logical no-undo.
  
  if pcMode = "CreateMode":u then 
  do with frame {&frame-name}:
       if glEnableTenant then 
          assign         
              fiTenant:sensitive = true
              btnTenant:sensitive = true.     
        assign
             edDescription:read-only = false
             edComments:read-only = false.
                 
  end.
  else if pcMode = "ResetMode":u then 
  do:
      /* don't enable fields for built-ins - category = 0 user defined
         (finame is always disabled in edit mode   
          tbEnabled is defined as "iab" and handled in ui-procs.i */
      if ghbuffer:avail 
      and ( ghBuffer::dCategory = 0 or ghBuffer::dCategory = 1 ) then
      do with frame {&frame-name}:
          assign
              fiTenant:sensitive = if ghBuffer::dCategory = 1  then false else glViewTenant 
              cbType:sensitive = true 
              btnTenant:sensitive = if ghBuffer::dCategory = 1  then false else true
              fiAccessCode:sensitive = true
              fiROptions:sensitive = true
              fiPAMOptions:sensitive = true
              fiAContext:sensitive = true
              /* use read-only for editors */
              edDescription:read-only = false
              edComments:read-only = false
              inbuild              = no.
           
      end.
      else do:
         assign
              /* use read-only for editors otherwise it cannot be scrolled and copied  */
             edDescription:read-only = true
             edComments:read-only = true
             btnTenant:sensitive = false
             inbuild             = yes.
      end. 
     
  end.
  
end procedure.

procedure localButtonState:
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/
  define input  parameter pcMode as character no-undo.
  
  define variable lok as logical no-undo.
  case pcMode:
      when "ResetMode":u then 
      do:
          /* don't enable fields for built-ins - category = 0 user defined
             (finame is always disabled in edit mode   
              tbEnabled and cbtype are defined as "iab" and handled in ui-procs.i 
              */
          if not ghbuffer:avail 
          or ghBuffer::dCategory <> 0 then
          do with frame {&frame-name}:
              assign
                  btndelete:sensitive = false.
                  btndelete:sensitive in frame browse-frame = false.
          end.
          else 
              btndelete:sensitive in frame browse-frame = true.
       
          assign
              btnPrev:sensitive in frame {&frame-name} = ghQuery:current-result-row > 1 
              btnNext:sensitive in frame {&frame-name} = ghQuery:NUM-RESULTS > ghQuery:current-result-row.
          
          if gcDoneLabel > "" then    
              btnDone:label in frame {&frame-name} = gcDoneLabel.
         
      end.
      when "CreateMode":u or when "UpdateMode":u then
      do:
          if gcDoneLabel = "" then 
               gcDoneLabel = btnDone:label in frame {&frame-name}.             
          assign
              btnPrev:sensitive in frame {&frame-name} = false
              btnNext:sensitive in frame {&frame-name} = false
              btnDone:sensitive in frame {&frame-name} = true
              btnDone:label in frame {&frame-name} = gcOkLabel.
             
      end.
           
  end case.      
  
end procedure.

PROCEDURE localDelete :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during the 
               deleteRecord event.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTxnLoc AS CHARACTER   NO-UNDO.
 
  DEFINE VARIABLE lDelete   AS LOGICAL     NO-UNDO.

  CASE pcTxnLoc:
    WHEN "Before" THEN DO:
        if can-find(first dictdb._user  where dictdb._user._domain-name = saDom.dName) then
        do:
            MESSAGE "You cannot delete a Security Authentication Domain record if there are User records associated with it."
            VIEW-AS ALERT-BOX ERROR.
            RETURN "Cancel".      
        end.    
            
        MESSAGE "Are you sure you want to delete this domain?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lDelete.
        IF NOT lDelete THEN RETURN "Cancel".

        RUN setRowidForDelete (ghQuery:PREPARE-STRING ).
        IF RETURN-VALUE NE "" THEN
            RETURN "Cancel".
        ELSE RETURN "".
    END.
    WHEN "After" THEN DO:
        
      RUN openQuery.
      
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE localSave :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur during a saveRecord
               event.
  Parameters:  INPUT pcTxnLoc - The location where this was called in respect
                                to the actual transaction.
  Notes:       "Before" = Before the transaction even begins
               "Start"  = At the start of the transaction, before anything is 
                          done
               "End"    = At the end of the transaction, after all logic has
                          executed
               "After"  = After the transaction has been commited.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTxnLoc AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hAuthDom AS HANDLE NO-UNDO.
  define variable lok as logical no-undo.
  
  CASE pcTxnLoc:
    WHEN "Before" THEN DO WITH FRAME {&FRAME-NAME}:
      IF cbType:SCREEN-VALUE EQ ""  OR
         cbType:SCREEN-VALUE EQ "?" OR
       cbType:SCREEN-VALUE EQ ? THEN DO:
        MESSAGE "You must select a domain type for this domain."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO cbType.
        RETURN "Retry".
      END.
      
      if not glMultiTenant then
           fiTenant:SCREEN-VALUE = ?.
      else if glViewTenant and fiTenant:sensitive then
      do:
          
        if (fiTenant:SCREEN-VALUE EQ ""  OR 
            fiTenant:SCREEN-VALUE EQ "?" OR
            fiTenant:SCREEN-VALUE EQ ?) 
            THEN 
        DO:
           if glEnableTenant then 
               MESSAGE "You must enter a name for the Tenant." 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
           else /* should not happen? */
               MESSAGE "There is no Tenant defined for the domain." 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           if glEnableTenant then 
               APPLY "ENTRY" TO fiTenant.
           RETURN "Retry".
        END.
        else do:
            run checkTenantName(fiTenant:SCREEN-VALUE,OUTPUT lok).
            if not lok then 
            do:
                MESSAGE "There is no Tenant with name " +  fiTenant:SCREEN-VALUE  + " in the database"
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                if glEnableTenant then 
                    APPLY "ENTRY" TO fiTenant.
                RETURN "Retry".
            end.
        end.    
      end.
    
      
      IF glCreateMode then
      do:
        /* The tenantname must be ? in a non MT db */   
        if (fiName:SCREEN-VALUE EQ ""  OR 
            fiName:SCREEN-VALUE EQ "?" OR
            fiName:SCREEN-VALUE EQ ?) THEN DO:
           MESSAGE "You must enter a name for this domain." 
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO fiName.
          RETURN "Retry".
        END.
        IF (fiAccessCode:SCREEN-VALUE EQ ""  OR
            fiAccessCode:SCREEN-VALUE EQ "?" OR
            fiAccessCode:SCREEN-VALUE EQ ?) THEN DO:
          MESSAGE "You must enter an access code."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO fiAccessCode.
          RETURN "Retry".
        END.
      
        CREATE BUFFER hAuthDom FOR TABLE "DICTDB._sec-authentication-domain".
        hAuthDom:FIND-FIRST("WHERE COMPARE(_domain-name,~"=~",~"" + 
                            fiName:SCREEN-VALUE + 
                            "~",~"CASE-SENSITIVE~")",NO-LOCK) NO-ERROR. 
        IF hAuthDom:AVAILABLE THEN DO:
          MESSAGE "A domain already exists with this name!" SKIP(1)
                  "Please enter a unique name for this domain." SKIP(1)
                  "Note: Domain Names are case sensitive."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          APPLY "ENTRY" TO fiName.
          RETURN "Retry".
        END.
      END. /* If glCreateMode */
      
      IF glCreateMode OR fiAccessCode:MODIFIED THEN
        fiAccessCode:SCREEN-VALUE = 
          AUDIT-POLICY:ENCRYPT-AUDIT-MAC-KEY(fiAccessCode:SCREEN-VALUE).
    END. /* When Before */
    WHEN "After" THEN DO:
      RUN openQuery.
      RETURN "".
    END.
  END CASE.
END PROCEDURE.

PROCEDURE localTrig :
/*------------------------------------------------------------------------------
  Purpose:     Local hook for additional logic to occur after a trigger fires
               prodict/sec/sec-trgs.i
  Parameters:  INPUT pcTrigger - The event that was fired
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTrigger AS CHARACTER   NO-UNDO.

  CASE pcTrigger:
    WHEN "Create" THEN DO:
        APPLY "ENTRY" TO fiName IN FRAME {&FRAME-NAME}.
        ghBrowse:SENSITIVE = FALSE.
        RETURN "".
    END.
    WHEN "Save" THEN DO:
        ghBrowse:SENSITIVE = TRUE.
        RETURN "".
    END.
    WHEN "Cancel" THEN DO:
        ghBrowse:SENSITIVE = TRUE.
        RETURN "".
    END.
    
  END CASE.
END PROCEDURE.

PROCEDURE openQuery:
  define variable rid as rowid no-undo.
  if grwLastRowid <> ? then 
     rid = grwLastRowid.
  else if ghQuery:is-open then
      rid = ghQuery:get-buffer-handle(1):rowid.
  ghQuery:QUERY-PREPARE("FOR EACH saDom BY " + gcSort).
/*  ghQuery:QUERY-PREPARE("PRESELECT EACH saDom BY " + gcSort).*/
  ghQuery:QUERY-OPEN().       
  IF rid NE ? THEN
    ghQuery:REPOSITION-TO-ROWID(rid) NO-ERROR.
                     
  run display.          
  RETURN "".
END PROCEDURE.

procedure display:
    RUN displayRecord.
    IF ronly THEN DO:
        RUN setFieldState ( INPUT "DisableMode" ).
        RUN setButtonState ( INPUT "DisableMode" ).
    END.
    ELSE DO:
        RUN setFieldState ( INPUT "ResetMode" ).
        RUN setButtonState ( INPUT "ResetMode" ).
    END.
end.

procedure layout:
    define variable fieldhandle as handle no-undo.   
    define variable hSidelabel as handle no-undo.
    define variable cellhandle as handle no-undo.   
    
    do with frame {&frame-name}:  
         
          &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      
        if not glViewTenant then 
        do:
            fiTenant:hidden in frame {&frame-name} = true.
            hSidelabel = fiTenant:side-label-handle in frame {&frame-name}.
            hSidelabel:hidden = true.

            btnTenant:hidden in frame {&frame-name}= true.
            fiName:row   in frame {&frame-name} = fiName:row + 1.
            hSidelabel = finame:side-label-handle in frame {&frame-name}.
            hSidelabel:row = fiName:row.  
        end.
       
          &ELSE
          
      /* this is not completely dynamic layout 
        the buttons row, which affects the size of the window,
        is defined statically in the frame 
        The fields are moved dynamically to ensure similar horizontal 
        spacing (which is difficult with decimal rows and no 
        UI designer) */  
        define variable dRow as decimal no-undo.  
        define variable dFill as decimal no-undo init 0.1.
        define variable dMove as decimal no-undo.
        
        drow =  1.5. 
        fieldhandle = frame dialog-frame:first-child.
        fieldhandle = fieldhandle:first-child.
        do while valid-handle(fieldhandle) :
            if lookup(string(fieldhandle),gcFieldHandles) > 0 then
            do:
                if not glViewTenant and fieldhandle:name = "fiTenant" then 
                do:
                     fieldhandle:hidden  = true.
                     btnTenant:hidden in frame {&frame-name} = true. 
                 
                end.
                else
                do:    
                    fieldhandle:row = dRow + (if fieldhandle:height lt 1 
                                              then (1 - fieldhandle:height) / 2
                                              else 0 ).
                    dRow = fieldhandle:Row + fieldhandle:height + dFill.
                    if can-query (fieldhandle,"side-label-handle":U) then
                    do:
                        hsidelabel = fieldhandle:side-label-handle.
                        if valid-handle(hsidelabel) then
                        do:
                            hsidelabel:row = fieldhandle:Row.
                        end.   
                    end.
                end.
            end.
            fieldhandle = fieldhandle:next-sibling.     
        end.
        /* adjust non-default label */ 
        lblEnabled:row = tbEnabled:row.
        /* adjust tenant browse button*/
        btnTenant:row = fiTenant:row.
        /* increase/decrease frame height and button positions according to last move 
          (this assumes adjustments in loop above are small enough to fit in original frame) */ 
       
        dMove = frame {&frame-name}:height - (dRow + 3).
        assign    
            btnDone:row = btnDone:row - dmove 
            btnCreate:row = btnCreate:row - dmove 
            btnSave:row = btnSave:row - dmove 
            btnCancel:row = btnCancel:row - dmove 
            btnDelete:row = btnDelete:row - dmove 
            btnPrev:row = btnPrev:row - dmove 
            btnNext:row = btnNext:row - dmove 
            BtnHelp:row = BtnHelp:row - dmove 
            RECT-2:row = RECT-2:row - dmove .         
        if dmove > 0 then                                                 
            frame {&frame-name}:height = frame {&frame-name}:height -  dmove.       
      &endif
       
    end.   
end.

Procedure selectTenant:
    define variable tenantdlg as prodict.pro._tenant-sel-presenter no-undo.
    tenantdlg = new  prodict.pro._tenant-sel-presenter ().
    do with frame {&frame-name}:
           &IF '{&WINDOW-SYSTEM}' <> 'TTY':U &THEN
        tenantdlg:Row = btnTenant:row + btnTenant:height +  frame {&frame-name}:row + 0.5.
        tenantdlg:Col =  fiTenant:col + frame {&frame-name}:col .
           &ELSE
        tenantdlg:Row = btnTenant:row + btnTenant:height +  frame {&frame-name}:row.
 
           &ENDIF
   
    tenantdlg:Title = "Select Tenant".
    glInSelect = true. /* stop end-error anywhere trigger */     
    if tenantdlg:Wait() then 
    do with frame {&frame-name}:
       fiTenant:screen-value = tenantdlg:ColumnValue("ttTenant.Name").
       apply "value-changed" to fiTenant.
    end.
    glInSelect = false.
   end.
 end.  


/* ************************  Function Implementations ***************** */

 
