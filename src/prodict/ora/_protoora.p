/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _protoora.p

Description:   
   This file contains the user interface for the advanced migration 
   window for openEdge DB to ORACLE Server migration. 
 
Author: Kumar Mayur

Date Created: 01/05/2011 

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
{ prodict/ora/oravar.i  }

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
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  SIZE 74 BY 3.1.     
     &ELSE SIZE 75 BY 4.5 . &ENDIF.
     
DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  SIZE 74 BY 3.1.    
     &ELSE SIZE 75 BY 4.5. &ENDIF.

&IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL FGCOLOR 7
     SIZE 74 BY 1.4. 
&ENDIF.

DEFINE VARIABLE cFormat    AS CHARACTER 
                           INITIAL "For field widths use:"
                           FORMAT "x(21)" NO-UNDO.
DEFINE VARIABLE dFormat    AS CHARACTER 
                           INITIAL "Create case insensitive fields with:"
                           FORMAT "x(37)" NO-UNDO.   
DEFINE VARIABLE Cuniq      AS CHARACTER 
                           INITIAL "Apply Uniqueness as:"
                           FORMAT "x(21)" NO-UNDO.
		   
DEFINE VARIABLE s_res          AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE disp_msg1      AS LOGICAL INITIAL TRUE     NO-UNDO.
DEFINE VARIABLE disp_msg2      AS LOGICAL INITIAL TRUE     NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME    
     
     pcompatible view-as toggle-box LABEL "Create RECID Field " AT 3  SKIP({&VM_WID})
     unicodeTypes view-as toggle-box label "Use Unicode Types " AT 3
     lCharSemantics VIEW-AS TOGGLE-BOX LABEL "Char semantics" AT 53 SKIP({&VM_WID})
     
     cFormat VIEW-AS TEXT NO-LABEL AT 3
     iFmtOption VIEW-AS RADIO-SET RADIO-BUTTONS "Width", 1,
                                             "ABL Format", 2
                               HORIZONTAL NO-LABEL SKIP({&VM_WID})
     lExpand VIEW-AS TOGGLE-BOX LABEL "Expand x(8) to 30" AT 46 SKIP({&VM_WIDG})
     
     dFormat VIEW-AS TEXT NO-LABEL AT 3 SKIP({&VM_WID})
     iShadow VIEW-AS RADIO-SET RADIO-BUTTONS "Function-Based Index", 1,
                                             "Shadow Column", 2
                               HORIZONTAL NO-LABEL  AT 10 SKIP({&VM_WID})
     nls_up view-as toggle-box LABEL "Use Linguistic Sorting" AT 3
     
     oralang FORMAT "x({&PATH_WIDG})"  view-as fill-in  size 15 by 1 
     LABEL "Sort Name"      
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN AT ROW 6.5 COL 30  SKIP({&VM_WIDG})SKIP({&VM_WIDG})
     &ELSE AT 30 SKIP({&VM_WIDG}) SKIP({&VM_WIDG}) &ENDIF   

     migconstraint view-as toggle-box LABEL "Migrate Constraints" AT 3 SKIP({&VM_WID})

     Cuniq VIEW-AS TEXT NO-LABEL AT 3 
     choiceUniquness VIEW-AS RADIO-SET RADIO-BUTTONS
                                "Index Attributes","1",
                                "Constraints","2"
                                HORIZONTAL NO-LABEL SKIP({&VM_WID})
     crtdefault VIEW-AS TOGGLE-BOX LABEL "Include Default" AT 3 SKIP({&VM_WIDG}) SKIP({&VM_WID})
     butt-ok AT 3 
     butt-cancel AT 14
     &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
         butt-help AT 26
     &ENDIF              
     
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN RECT-1 AT ROW 4.7 COL 2   
     &ELSE RECT-1 AT ROW 4.5 COL 2 &ENDIF      
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-2 AT ROW 8.2 COL 2   
     &ELSE RECT-2 AT ROW 9.5 COL 2 &ENDIF
     &IF "{&WINDOW-SYSTEM}" <> "TTY"  &THEN  RECT-3 AT ROW 11.5 COL 2 &ENDIF       
     
     WITH 1 DOWN  KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
     VIEW-AS DIALOG-BOX TITLE "OpenEdge DB to ORACLE Conversion Advanced Options".


ON CHOOSE OF butt-ok IN FRAME DEFAULT-FRAME 
DO:
  IF oralang:SCREEN-VALUE = "BINARY" AND nls_up:SCREEN-VALUE = "YES" THEN
         MESSAGE 'In order to use a BINARY sort name, uncheck the "Use Linguistic Sorting" checkbox'  view-as alert-box . 
  ELSE DO: 
    Assign pcompatible = (pcompatible:SCREEN-VALUE = "yes").
    Assign migConstraint =  (migConstraint:SCREEN-VALUE = "yes").
    Assign unicodeTypes = (unicodeTypes:SCREEN-VALUE = "yes" ).
    ASSIGN choiceUniquness = choiceUniquness:screen-value.
    ASSIGN iShadow         = INTEGER(iShadow:screen-value).     
    ASSIGN lCharSemantics = (lCharSemantics:SCREEN-VALUE = "yes").
    ASSIGN crtdefault = (crtdefault:SCREEN-VALUE = "YES").
    Assign nls_up = (nls_up:SCREEN-VALUE = "yes").

    oralang = IF oralang:screen-value = "" THEN "" ELSE oralang:screen-value.    
    IF unicodeTypes = TRUE 
    THEN
         ASSIGN ora_varlen = 2000. 
    ELSE 
         ASSIGN ora_varlen = 4000.
           
    IF iFmtOption:SCREEN-VALUE = "1" THEN
      ASSIGN lFormat = ?
             iFmtOption = 1.
    ELSE 
      ASSIGN lFormat = (NOT lExpand)
             iFmtOption = 2.

    IF ora_version >= 9 THEN DO: 
        IF unicodeTypes:SCREEN-VALUE = "yes" THEN
           ASSIGN unicodeTypes = YES.
        IF lCharSemantics:SCREEN-VALUE = "yes" THEN
           ASSIGN lCharSemantics = YES.
    END.
    ELSE
        ASSIGN unicodeTypes = NO
               lCharSemantics = NO.  
   
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   APPLY "END-ERROR" TO FRAME DEFAULT-FRAME.
  END. 
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
                              INPUT {&OpenEdge_DB_to_ORACLE_Advanced_Dialog_Box}, 
      	       	     	      INPUT ?).
 END.
&ENDIF

ON VALUE-CHANGED OF unicodeTypes IN FRAME DEFAULT-FRAME DO:

    IF SELF:screen-value = "yes" THEN DO:
        ASSIGN lCharSemantics:SENSITIVE = NO
               lCharSemantics:SCREEN-VALUE = "NO"
               lcsemantic = FALSE.
        IF disp_msg1 = TRUE THEN DO:

            ASSIGN disp_msg1 = FALSE.

            MESSAGE "The maximum char length default value is assuming AL16UTF16 encoding for the national" SKIP
                    "character set on the ORACLE database. For UTF8 encoding, you may have to set it to a" SKIP
                    "lower value depending on the data."
                VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        END.
    END.
    ELSE DO:
        ASSIGN lCharSemantics:SENSITIVE = YES.

    END.
END.


ON VALUE-CHANGED OF iFmtOption IN FRAME DEFAULT-FRAME DO:
  IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN lExpand:CHECKED   = FALSE
           lExpand:SENSITIVE = FALSE
           lFormat           = ?.
  ELSE
    ASSIGN lExpand:CHECKED   = TRUE
           lExpand:SENSITIVE = TRUE
           lFormat           = FALSE.
END.        

ON VALUE-CHANGED OF iShadow IN FRAME DEFAULT-FRAME DO:
   IF SELF:SCREEN-VALUE = "1" THEN
    ASSIGN nls_up:SENSITIVE  = TRUE
           oralang:SENSITIVE = TRUE.
  ELSE
    ASSIGN nls_up:SENSITIVE  = FALSE
           oralang:SENSITIVE = FALSE.
END.   

ON VALUE-CHANGED OF nls_up IN FRAME DEFAULT-FRAME DO:
   IF SELF:SCREEN-VALUE = "yes" THEN DO:
    ASSIGN oralang:SENSITIVE = TRUE
           oralang:SCREEN-VALUE = "".
  END.
  ELSE
    ASSIGN oralang:SCREEN-VALUE = "BINARY"
           oralang:SENSITIVE = FALSE.
END.   

ON LEAVE OF oralang IN FRAME DEFAULT-FRAME DO:
  IF SELF:SCREEN-VALUE = "BINARY" THEN DO:
   MESSAGE 'In order to use a BINARY sort name, uncheck the "Use Linguistic Sorting" checkbox'  view-as alert-box . 

   END.
END.

IF NOT batch_mode THEN 
_updtvar: 
  DO WHILE TRUE:
  ASSIGN oralang:SCREEN-VALUE in frame DEFAULT-FRAME = oralang.
  DISPLAY  cFormat dFormat Cuniq WITH FRAME DEFAULT-FRAME.
  UPDATE
        pcompatible     
        lCharSemantics WHEN lcsemantic = TRUE
        unicodeTypes WHEN  uctype = TRUE
        iFmtOption
        lExpand WHEN iFmtOption = 2
        iShadow
        nls_up WHEN iShadow = 1
        oralang WHEN nls_up
        migConstraint
        choiceUniquness
        crtdefault
        butt-ok butt-cancel
        &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            butt-help
        &ENDIF               	        
        WITH FRAME DEFAULT-FRAME. 

    IF nls_up:SCREEN-VALUE in frame DEFAULT-FRAME = "YES" 
    THEN DO:
        IF oralang:SCREEN-VALUE in frame DEFAULT-FRAME = "BINARY" THEN DO:
              MESSAGE 'In order to use a BINARY sort name, uncheck the "Use Linguistic Sorting" checkbox'  view-as alert-box . 
              next _updtvar.
        END.      
        ELSE DO:
           ASSIGN  oralang =  oralang:SCREEN-VALUE in frame DEFAULT-FRAME. 
           LEAVE _updtvar. 
        END.
    END.
    ELSE LEAVE _updtvar.         
 END.
