/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: protomss1.p

Description:   
   This file contains the user interface for the split migration window 
   for openEdge to MS SQL Server Migration
 
Author: Kumar Mayur

Date Created: 06/20/2011 

History:


----------------------------------------------------------------------------*/


&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS mig_cnst TOGGLE-7 TOGGLE-8 TOGGLE-9 ~
RADIO-SET-5 TOGGLE-13 RADIO-SET-6 BUTTON-1 BUTTON-2 BUTTON-3 
&Scoped-Define DISPLAYED-OBJECTS mig_cnst TOGGLE-7 TOGGLE-8 TOGGLE-9 ~
RADIO-SET-5 TOGGLE-13 RADIO-SET-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* ***********************  Control Definitions  ********************** */

{ prodict/user/uservar.i }
{ prodict/mss/mssvar.i  }




DEFINE VARIABLE tmp_str       AS CHARACTER                NO-UNDO.
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.

batch_mode = SESSION:BATCH-MODE.
/* Definitions of the field level widgets                               */
DEFINE BUTTON butt-ok
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON butt-cancel
     LABEL "Cancel" 
     SIZE 10 BY 1.

DEFINE BUTTON butt-help 
     LABEL "Help" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  SIZE 75 BY 5.5.     
     &ELSE SIZE 75 BY 7.5. &ENDIF.
     
DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  SIZE 75 BY 1.9.     
     &ELSE SIZE 75 BY 4 . &ENDIF.

&IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL FGCOLOR 7
     SIZE 74 BY 1.4. 
&ENDIF.     

DEFINE VARIABLE text1      AS CHARACTER 
                           INITIAL "Apply Uniqueness as:"
                           FORMAT "x(21)" NO-UNDO.
DEFINE VARIABLE text2      AS CHARACTER 
                           INITIAL "Create RECID Field using"
                           FORMAT "x(30)" NO-UNDO.   
DEFINE VARIABLE text3      AS CHARACTER 
                           INITIAL "Using"
                           FORMAT "x(8)" NO-UNDO.    
DEFINE VARIABLE text4      AS CHARACTER 
                           INITIAL "For field widths use"
                           FORMAT "x(22)" NO-UNDO.              
DEFINE VARIABLE s_res         AS LOGICAL                  NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     migConstraint view-as toggle-box label "Migrate Constraints" AT 2 SKIP({&VM_WIDG})
     SPACE(2)    
     tryPimaryForRowid view-as toggle-box LABEL "Try Primary for ROWID" AT 2
     mkClusteredExplict view-as toggle-box LABEL "Make Clustered Explicit" AT 35 SKIP({&VM_WID})
     text2 VIEW-AS TEXT NO-LABEL AT 2
     iRecidOption VIEW-AS RADIO-SET RADIO-BUTTONS
        "Trigger", 1,
        "Computed column", 2
        HORIZONTAL AT 33 NO-LABEL SKIP({&VM_WID})
     ForRow view-as toggle-box LABEL "For" AT 8 
     choiceRowid VIEW-AS RADIO-SET RADIO-BUTTONS 
        "ROWID", 1,
        "Prime ROWID", 2
        HORIZONTAL AT 17 NO-LABEL SKIP({&VM_WID})
     forRowidUniq view-as toggle-box LABEL "For ROWID Uniqueness" AT 8 SKIP({&VM_WID})
     selBestRowidIdx view-as toggle-box LABEL "Select 'Best' ROWID Index"  AT 2 SKIP({&VM_WID})
     text3 VIEW-AS TEXT NO-LABEL AT 8
     choiceSchema VIEW-AS RADIO-SET RADIO-BUTTONS
        "OE Schema", 1,
        "Foreign schema", 2
        HORIZONTAL AT 28 NO-LABEL SKIP({&VM_WIDG})
     SPACE(2)
     mapMSSDatetime view-as toggle-box LABEL "Map to MSS 'Datetime' Type"  AT 2 
     shadowcol view-as toggle-box label "Create Shadow Column" AT 38 SKIP({&VM_WID})
     newseq view-as toggle-box LABEL  "Use revised sequence Generator"  AT 2 SKIP({&VM_WIDG})
     SPACE(2)         
     unicodeTypes view-as toggle-box LABEL "Use Unicode Types"  AT 2 
     lUniExpand view-as toggle-box LABEL "Expand Width(utf-8)" AT 36 SKIP({&VM_WID})
     text4 VIEW-AS TEXT NO-LABEL AT 2 
     iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS
         "Width", 1,
         "ABL Format", 2
         HORIZONTAL AT 24 NO-LABEL 
     lExpand view-as toggle-box LABEL "Expand x(8) to 30"  AT 53 SKIP({&VM_WIDG})
     
     SPACE(2)
     text1 VIEW-AS TEXT NO-LABEL AT 2       
     choiceUniquness VIEW-AS RADIO-SET RADIO-BUTTONS
         "Index Attributes", "1",
         "Constraints", "2"
         HORIZONTAL NO-LABEL AT 23 SKIP({&VM_WID})
     dflt  view-as toggle-box LABEL "Include Default" AT 2 SKIP({&VM_WID})
    
     "Apply Defaults as:" VIEW-AS TEXT AT 2
     choiceDefault VIEW-AS RADIO-SET RADIO-BUTTONS 
        "Field Attributes", "1",
        "Constraints", "2"
        HORIZONTAL AT 20 NO-LABEL SKIP({&VM_WIDG})
       
     butt-ok AT 3 WIDGET-ID 22
     butt-cancel AT 14 WIDGET-ID 24
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
         butt-help AT 26
     &ENDIF
     
    RECT-1 AT ROW 2.2 COL 1 
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-2 AT ROW 10.3 COL 1   
     &ELSE RECT-2 AT ROW 12.1 COL 1 &ENDIF

    &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-3 AT ROW 15.5 COL 2 &ENDIF                   
 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
    VIEW-AS DIALOG-BOX TITLE "OpenEdge To MS SQL Server Conversion Advanced Options".


  
ON CHOOSE OF butt-ok IN FRAME DEFAULT-FRAME 
DO:

   Assign migConstraint = (migConstraint:SCREEN-VALUE = "yes").

   ASSIGN tryPimaryForRowid  = (tryPimaryForRowid:SCREEN-VALUE  = "yes").
   ASSIGN mkClusteredExplict = (mkClusteredExplict:SCREEN-VALUE  = "yes").
   ASSIGN ForRow  = (ForRow:SCREEN-VALUE  = "yes").
   ASSIGN forRowidUniq  = (forRowidUniq:SCREEN-VALUE  = "yes").
   ASSIGN selBestRowidIdx  = (selBestRowidIdx:SCREEN-VALUE  = "yes").
   ASSIGN choiceRowid = INTEGER(choiceRowid:SCREEN-VALUE).
   ASSIGN iRecidOption = INTEGER(iRecidOption:SCREEN-VALUE).
   ASSIGN choiceSchema = INTEGER(choiceSchema:SCREEN-VALUE).
   IF NOT (forRowidUniq OR ForRow) THEN 
   ASSIGN iRecidOption = 0
            pcompatible = FALSE.
   IF (forRowidUniq OR ForRow) THEN ASSIGN pcompatible = TRUE. 
   Assign dflt = (dflt:SCREEN-VALUE = "yes").
   Assign mapMSSDatetime = (mapMSSDatetime:SCREEN-VALUE = "yes" ).
   Assign newseq = (newseq:SCREEN-VALUE = "yes" ). 
   ASSIGN choiceDefault = choiceDefault:screen-value.
   ASSIGN choiceUniquness = choiceUniquness:screen-value.
   ASSIGN shadowcol = (shadowcol:SCREEN-VALUE = "yes").
   ASSIGN lUniExpand = (lUniExpand:SCREEN-VALUE ="yes").
   ASSIGN iFmtOption = INTEGER(iFmtOption:SCREEN-VALUE).
   ASSIGN lExpand = (lExpand:SCREEN-VALUE = "yes" ).
   
   IF iFmtOption = 1 THEN
      ASSIGN lFormat = ?
             iFmtOption = 1.
   ELSE 
      ASSIGN lFormat = (NOT lExpand)
             iFmtOption = 2.

   IF unicodeTypes:SCREEN-VALUE ="yes" THEN
       ASSIGN long-length = 4000
              unicodeTypes = TRUE.
   ELSE 
   ASSIGN  long-length = 8000
           unicodeTypes = FALSE.
   
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   APPLY "END-ERROR" TO FRAME DEFAULT-FRAME.
END.

ON CHOOSE OF butt-cancel in frame DEFAULT-FRAME 
DO:  
   APPLY "END-ERROR" TO FRAME DEFAULT-FRAME.
END.

ON WINDOW-CLOSE OF FRAME DEFAULT-FRAME 
DO:
    APPLY "END-ERROR" TO FRAME DEFAULT-FRAME.
END. 

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME DEFAULT-FRAME OR CHOOSE OF butt-help IN FRAME DEFAULT-FRAME
 DO:   
    RUN adecomm/_adehelp.p (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&OpenEdge_DB_to_MS_SQL_Advanced_Dialog_Box}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

ON VALUE-CHANGED OF iFmtOption IN FRAME DEFAULT-FRAME DO:
  IF SELF:SCREEN-VALUE = "2" THEN
    ASSIGN lExpand:SENSITIVE = TRUE
           lExpand:CHECKED   = TRUE
           lFormat           = FALSE.
  ELSE ASSIGN lExpand:SENSITIVE = FALSE
              lExpand:CHECKED   = FALSE
              lFormat           = TRUE. 
END.

IF shdcol = YES
  THEN DO:
  ASSIGN  
           shadowcol:SENSITIVE IN FRAME DEFAULT-FRAME  = TRUE
           s_res = shadowcol:MOVE-BEFORE-TAB-ITEM(dflt:HANDLE).
  END.
  ELSE DO:
  ASSIGN 
           shadowcol:SENSITIVE IN FRAME DEFAULT-FRAME = FALSE
           shadowcol:CHECKED IN FRAME DEFAULT-FRAME = NO. 
  END.

ON VALUE-CHANGED OF dflt IN FRAME DEFAULT-FRAME DO:
 IF dflt:screen-value = "no" THEN
     ASSIGN choiceDefault:SENSITIVE = NO.
 ELSE
     ASSIGN choiceDefault:SENSITIVE = YES.
END.
 
ON VALUE-CHANGED OF unicodeTypes IN FRAME DEFAULT-FRAME DO:
 IF SELF:screen-value = "no" THEN
     ASSIGN
            lUniExpand:SCREEN-VALUE = "no"
            lUniExpand:SENSITIVE = NO.
 ELSE
     ASSIGN lUniExpand:SENSITIVE = YES
            s_res = lUniExpand:MOVE-AFTER-TAB-ITEM(unicodeTypes:HANDLE).
END.

ON VALUE-CHANGED OF tryPimaryForRowid IN FRAME DEFAULT-FRAME DO:
  IF SELF:SCREEN-VALUE = "no" THEN DO:
    IF migConstraint:SCREEN-VALUE = "no" THEN
       ASSIGN forRowidUniq:SENSITIVE   = FALSE
           forRowidUniq:SCREEN-VALUE   = "no".
    IF choiceRowid:SENSITIVE  = FALSE THEN  DO:
       ASSIGN mkClusteredExplict:SENSITIVE   = FALSE
              mkClusteredExplict:SCREEN-VALUE = "no".
    END.
    ELSE IF choiceRowid:SCREEN-VALUE <> "2" THEN 
            ASSIGN mkClusteredExplict:SENSITIVE   = FALSE
                   mkClusteredExplict:SCREEN-VALUE = "no".
  END.
  ELSE DO:
       ASSIGN mkClusteredExplict:SENSITIVE   = TRUE.
       IF ForRow:screen-value   = "no"  THEN 
          ASSIGN forRowidUniq:SENSITIVE   = TRUE.
       IF ForRowidUniq:screen-value   = "no"  THEN 
          ASSIGN forRow:SENSITIVE   = TRUE.
  END.
  IF ForRow:SCREEN-VALUE = "yes" THEN
     ASSIGN ForRow:SENSITIVE   = TRUE.
  ELSE ASSIGN ForRow:SENSITIVE   = FALSE.
  IF selBestRowidIdx:SCREEN-VALUE = "yes" THEN
     ASSIGN selBestRowidIdx:SENSITIVE   = TRUE.
  ELSE ASSIGN selBestRowidIdx:SENSITIVE   = FALSE.
END.

ON VALUE-CHANGED OF migConstraint IN FRAME DEFAULT-FRAME DO:
  IF SELF:SCREEN-VALUE = "no" THEN DO:
    IF tryPimaryForRowid:screen-value   = "no" THEN DO:
       ASSIGN forRowidUniq:SENSITIVE   = FALSE
              forRowidUniq:SCREEN-VALUE   = "no". 
    END. 
    IF selBestRowidIdx:screen-value   = "no" THEN DO:
       ASSIGN ForRow:SENSITIVE   = TRUE.
       IF ForRow:screen-value   = "no"  THEN 
          ASSIGN selBestRowidIdx:SENSITIVE   = TRUE
                 iRecidOption:SENSITIVE   = FALSE.
       ELSE ASSIGN iRecidOption:SENSITIVE   = TRUE.
    END.
    ELSE selBestRowidIdx:SENSITIVE   = TRUE.
  END.
  ELSE DO:
       IF ForRow:screen-value   = "no"  THEN 
          ASSIGN forRowidUniq:SENSITIVE   = TRUE.
                 
  END.
END.
/* Initialize RECID logic */
ON VALUE-CHANGED OF ForRow IN FRAME DEFAULT-FRAME DO:
 IF SELF:screen-value = "yes" THEN DO:
     ASSIGN forRowidUniq:SCREEN-VALUE   = "no"
            forRowidUniq:SENSITIVE   = FALSE
            iRecidOption:SENSITIVE   = TRUE
            choiceRowid:SENSITIVE   = TRUE
            selBestRowidIdx:SENSITIVE   = FALSE
            selBestRowidIdx:SCREEN-VALUE   = "no"
            choiceSchema:SENSITIVE   = FALSE.
     IF choiceRowid:SCREEN-VALUE  =  "2" THEN
        ASSIGN mkClusteredExplict:SENSITIVE   = TRUE.
 END.
 ELSE DO:
   ForRow:SENSITIVE   = FALSE.
   IF tryPimaryForRowid:SCREEN-VALUE   = "yes" 
           OR migConstraint:SCREEN-VALUE   = "yes" THEN
      forRowidUniq:SENSITIVE   = TRUE.
   IF tryPimaryForRowid:SCREEN-VALUE  =  "no" THEN  DO:
       ASSIGN mkClusteredExplict:SENSITIVE   = FALSE
              mkClusteredExplict:SCREEN-VALUE = "no".
   END.

   ASSIGN selBestRowidIdx:SENSITIVE   = TRUE
         selBestRowidIdx:SCREEN-VALUE   = "yes"
         choiceSchema:SENSITIVE   = TRUE
         iRecidOption:SENSITIVE   = FALSE
         choiceRowid:SCREEN-VALUE   = "0"
         choiceRowid:SENSITIVE   = FALSE.
 END.
END.

ON VALUE-CHANGED OF ForRowidUniq IN FRAME DEFAULT-FRAME DO:
 IF SELF:screen-value = "yes" THEN DO:
     ASSIGN forRow:SCREEN-VALUE   = "no"
            forRow:SENSITIVE   = FALSE
            choiceRowid:SENSITIVE   = FALSE
            iRecidOption:SENSITIVE   = TRUE
            selBestRowidIdx:SENSITIVE   = FALSE
            selBestRowidIdx:SCREEN-VALUE   = "yes"
            choiceSchema:SENSITIVE   = TRUE.
 END.
 ELSE DO:
    selBestRowidIdx:SENSITIVE   = TRUE.
    IF selBestRowidIdx:screen-value = "no"  THEN
       ASSIGN forRow:SENSITIVE   = TRUE.
    iRecidOption:SENSITIVE   = FALSE.
 END.
END.

ON VALUE-CHANGED OF selBestRowidIdx IN FRAME DEFAULT-FRAME DO:
 IF SELF:screen-value = "yes" THEN DO:
    ASSIGN forRow:SENSITIVE   = FALSE
           choiceRowid:SENSITIVE   = FALSE
           choiceSchema:SENSITIVE   = TRUE
           forRow:SCREEN-VALUE   = "no".
    IF tryPimaryForRowid:SCREEN-VALUE = "yes"  THEN ASSIGN forRowidUniq:SENSITIVE = TRUE.
 END.
 ELSE DO:
    ASSIGN selBestRowidIdx:SENSITIVE   = FALSE
           forRowidUniq:SCREEN-VALUE   = "no"
           forRowidUniq:SENSITIVE   = FALSE
           ForRow:SENSITIVE   = TRUE
           ForRow:SCREEN-VALUE   = "yes"
           choiceRowid:SENSITIVE   = TRUE
           iRecidOption:SENSITIVE   = TRUE
           choiceSchema:SENSITIVE   = FALSE.
    IF choiceRowid:SCREEN-VALUE = "2" THEN  ASSIGN mkClusteredExplict:SENSITIVE = TRUE.
 END.
END.

ON VALUE-CHANGED OF choiceRowid IN FRAME DEFAULT-FRAME DO:
    IF SELF:SCREEN-VALUE = "2" THEN
       ASSIGN mkClusteredExplict:SENSITIVE   = TRUE.
    ELSE  DO:
       IF tryPimaryForRowid:SCREEN-VALUE = "no" THEN
          ASSIGN mkClusteredExplict:SENSITIVE = FALSE.
    END.
END.

    
IF NOT batch_mode THEN
  DO: 
   DISPLAY text1 text2 text3 text4 WITH FRAME DEFAULT-FRAME.
   UPDATE
        migConstraint
        tryPimaryForRowid
        mkClusteredExplict WHEN tryPimaryForRowid = TRUE
        iRecidOption
        ForRow  WHEN forRowidUniq = FALSE
        choiceRowid WHEN ForRow = TRUE
        forRowidUniq WHEN ForRow = FALSE
        selBestRowidIdx WHEN pcompatible = FALSE
        choiceSchema WHEN pcompatible = FALSE 
              
        mapMSSDatetime
        shadowcol WHEN shdcol = YES  
        newseq
        unicodeTypes
        lUniExpand WHEN unicodeTypes = TRUE
        iFmtOption 
        lExpand WHEN iFmtOption = 2  
         
        choiceUniquness
        dflt
        choiceDefault WHEN dflt = TRUE
        butt-ok butt-cancel
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            butt-help
        &ENDIF              	        
        WITH FRAME DEFAULT-FRAME. 
        
        
        ASSIGN mkClusteredExplict = (mkClusteredExplict:SCREEN-VALUE  = "yes").
        ASSIGN iRecidOption = INTEGER(iRecidOption:SCREEN-VALUE).
        ASSIGN ForRow  = (ForRow:SCREEN-VALUE  = "yes").
        ASSIGN forRowidUniq  = (forRowidUniq:SCREEN-VALUE  = "yes").
        ASSIGN selBestRowidIdx  = (selBestRowidIdx:SCREEN-VALUE  = "yes").
        ASSIGN choiceRowid = INTEGER(choiceRowid:SCREEN-VALUE).
        ASSIGN choiceSchema = INTEGER(choiceSchema:SCREEN-VALUE).
        IF NOT (forRowidUniq OR ForRow) THEN 
        ASSIGN iRecidOption = 0
              pcompatible = FALSE.
        IF (forRowidUniq OR ForRow) THEN ASSIGN pcompatible = TRUE. 
   
        ASSIGN choiceDefault = choiceDefault:screen-value.
        ASSIGN shadowcol = (shadowcol:SCREEN-VALUE = "yes").
        ASSIGN lUniExpand = (lUniExpand:SCREEN-VALUE ="yes").
        ASSIGN iFmtOption = INTEGER(iFmtOption:SCREEN-VALUE).
   
        IF iFmtOption = 1 THEN
            ASSIGN lFormat = ?
                   iFmtOption = 1.
        ELSE 
            ASSIGN lFormat = (NOT lExpand)
                   iFmtOption = 2.

        IF unicodeTypes:SCREEN-VALUE ="yes" THEN
            ASSIGN long-length = 4000
                   unicodeTypes = TRUE.
        ELSE 
             ASSIGN long-length = 8000
                    unicodeTypes = FALSE.
 END.
