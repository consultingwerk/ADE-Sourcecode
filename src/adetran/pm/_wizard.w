&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_wizard.w
Author:       R. Ryan
Created:      1/95 
Updated:      11/96 SLK Increaded to 14 filters
                        Changed for FONT
                01/97 SLK Removed BGCOLOR 8
Purpose:      _wizard.w is a dialog shell that uses 14 persistent
              procedures (_wiz1-_wiz14) to guide the project 
              manager through a series of filter scenarios.  
              When the user is all done, he/she presses 'Apply' 
              and the filter criteria are written to two tables:
              
                XL_SelectedFilters (_wiz1-_wiz10) inclusion filters
                XL_CustomFilters (_wiz11-_wiz13)  exclusion filters
              
Background:   Each of the persistent procedures reads data from
              the appropriate tables (if present).  If their is no
              data present in XL_SelectedFilters and XL_CustomFilters,
              each procedures presents some logical defaults.  
              
              Each of the persistent procedures also has the mechanism
              to write their data to the appropriate tables - but only
              do so, when the 'Apply' button indicates that the 
              criteria are worth saving.
              
Notes:        The left-hand side of this procedure is a 'editor' that 
              substitutes text depending upon the counter that is
              increment or decremented each time next/previous buttons
              are pressed.  The right-hand side of this procedure is 
              just a reserved space that equates to the frame of
              each persistent procedure.  Each time a next/previous
              button is pressed, it equates to _hWiz1-_hWiz14 and runs
              a Realize (enable and display procedure) in the corresponding
              persistent procedure.  Each procedure does the following:
              
                _hWiz1 pm/_wiz1.w     row-labels   
                _hWiz2 pm/_wiz2.w     column-labels
                _hWiz3 pm/_wiz3.w     messages
                _hWiz4 pm/_wiz4.w     list-items/radio-sets
                _hWiz5 pm/_wiz5.w     titles
                _hWiz6 pm/_wiz6.w     assignments
                _hWiz7 pm/_wiz7.w     formats
                _hWiz8 pm/_wiz8.w     run
                _hWiz9 pm/_wiz9.w     comparison
                _hWiz10 pm/_wiz10.w   other 4GL
                _hWiz11 pm/_wiz11.w   keyword values
                _hWiz12 pm/_wiz12.w   custom filters
                _hWiz13 pm/_wiz13.w   special filters
                _hWiz14 pm/_wiz14.w   summary            
*/



define var ExitFlag as logical no-undo.
define var CurrentMode as integer no-undo init 1.
define var CR as char no-undo.
define var result as logical no-undo.

define var ThisLine as char.
define var ThisText as char.  
  
define var CR1 as char no-undo.
define var CR2 as char no-undo.
define var ModeText as char extent 14.
define var ModeLabel as char extent 14.

define var hWiz1 as handle no-undo.
define var hWiz2 like hWiz1.
define var hWiz3 like hWiz1.
define var hWiz4 like hWiz1.
define var hWiz5 like hWiz1.
define var hWiz6 like hWiz1.
define var hWiz7 like hWiz1.
define var hWiz8 like hWiz1.
define var hWiz9 like hWiz1.
define var hWiz10 like hWiz1.
define var hWiz11 like hWiz1.
define var hWiz12 like hWiz1.
define var hWiz13 like hWiz1.
define var hWiz14 like hWiz1.

CR1 = chr(10).
CR2 = CR1 + CR1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-3 RECT-2 RECT-1 BtnCancel BtnPrev ~
BtnNext BtnFinish IncludeLabel MessageLabel 
&Scoped-Define DISPLAYED-OBJECTS IncludeLabel MessageLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnFinish AUTO-GO 
     LABEL "&Finish" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnNext 
     LABEL "&Next >" 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnPrev 
     LABEL "< &Previous" 
     SIZE 15 BY 1.12.

DEFINE VARIABLE MessageText AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 38.57 BY 9.31 NO-UNDO.

DEFINE VARIABLE IncludeLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Include" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .62 NO-UNDO.

DEFINE VARIABLE MessageLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Label" 
      VIEW-AS TEXT 
     SIZE 33.86 BY .62
     FONT 6 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "adetran/images/ltbulb":U
     SIZE 9 BY 2.38.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 81 BY 1.81
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 9.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     MessageText AT ROW 1.92 COL 4.43 NO-LABEL
     BtnCancel AT ROW 11.65 COL 7
     BtnPrev AT ROW 11.65 COL 23
     BtnNext AT ROW 11.65 COL 39
     BtnFinish AT ROW 11.65 COL 55
     IncludeLabel AT ROW 1.65 COL 42.14 COLON-ALIGNED NO-LABEL
     MessageLabel AT ROW 2.04 COL 3.14 COLON-ALIGNED NO-LABEL
     IMAGE-3 AT ROW 1 COL 1
     RECT-2 AT ROW 1.92 COL 44
     RECT-1 AT ROW 11.35 COL 1
     SPACE(1.13) SKIP(0.06)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Filter Wizard"
         DEFAULT-BUTTON BtnNext.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR EDITOR MessageText IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       MessageText:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Filter Wizard */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFinish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFinish Dialog-Frame
ON CHOOSE OF BtnFinish IN FRAME Dialog-Frame /* Finish */
DO:
  if ExitFlag then do:
    run adecomm/_setcurs.p ("wait":u).
    run SetDB in hWiz1.
    run SetDB in hWiz2.
    run SetDB in hWiz3.
    run SetDB in hWiz4.
    run SetDB in hWiz5.
    run SetDB in hWiz6.
    run SetDB in hWiz7.
    run SetDB in hWiz8.
    run SetDB in hWiz9.
    run SetDB in hWiz10.
    run SetDB in hWiz11.
    run SetDB in hWiz12.
    run SetDB in hWiz13.
    run adecomm/_setcurs.p (""). 
  end.
  
  else do:
    CurrentMode = 14.
    run SetSensitivity.
    run SetTitle. 
    run SetMessage.
    run SetFrame.
    return no-apply.
  end.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnNext Dialog-Frame
ON CHOOSE OF BtnNext IN FRAME Dialog-Frame /* Next > */
DO:
  If CurrentMode < 14 then 
    CurrentMode = CurrentMode + 1.
  else
    CurrentMode = 14.
    
  run SetTitle.
  run SetMessage.
  run SetFrame.
  run SetSensitivity.
 eND.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPrev Dialog-Frame
ON CHOOSE OF BtnPrev IN FRAME Dialog-Frame /* < Previous */
DO:
  If CurrentMode > 1 then 
    CurrentMode = CurrentMode - 1.
  else
    CurrentMode = 1.
    
  run SetTitle.
  run SetMessage.
  run SetFrame.
  run SetSensitivity.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME Dialog-Frame:PARENT eq ?
THEN FRAME Dialog-Frame:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   def var ThisFrame as widget-handle no-undo.
   assign
     ThisFrame       = frame dialog-frame:handle.
   
   run adetran/pm/_wiz1.w persistent set hWiz1 (input ThisFrame).
   run adetran/pm/_wiz2.w persistent set hWiz2 (input ThisFrame).
   run adetran/pm/_wiz3.w persistent set hWiz3 (input ThisFrame).
   run adetran/pm/_wiz4.w persistent set hWiz4 (input ThisFrame).
   run adetran/pm/_wiz5.w persistent set hWiz5 (input ThisFrame).
   run adetran/pm/_wiz6.w persistent set hWiz6 (input ThisFrame).
   run adetran/pm/_wiz7.w persistent set hWiz7 (input ThisFrame).
   run adetran/pm/_wiz8.w persistent set hWiz8 (input ThisFrame).
   run adetran/pm/_wiz9.w persistent set hWiz9 (input ThisFrame).
   run adetran/pm/_wiz10.w persistent set hWiz10 (input ThisFrame).
   run adetran/pm/_wiz11.w persistent set hWiz11 (input ThisFrame).
   run adetran/pm/_wiz12.w persistent set hWiz12 (input ThisFrame).
   run adetran/pm/_wiz13.w persistent set hWiz13 (input ThisFrame).
      
   run adetran/pm/_wiz14.w persistent set hWiz14 (
     input ThisFrame,
     input hWiz1,
     input hWiz2,
     input hWiz3,
     input hWiz4,
     input hWiz5,
     input hWiz6,
     input hWiz7,
     input hWiz8,
     input hWiz9,
     input hWiz10,
     input hWiz11,
     input hWiz12,
     input hWiz13).
   
   run Realize.
   run SetTitle.
   run SetMessage.
   run SetFrame.
   run SetSensitivity.
   
  WAIT-FOR GO OF FRAME Dialog-Frame focus BtnNext.
END.
RUN Destroy.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Destroy Dialog-Frame 
PROCEDURE Destroy :
HIDE FRAME Dialog-Frame.
  delete procedure hWiz1.
  delete procedure hWiz2.
  delete procedure hWiz3.
  delete procedure hWiz4.
  delete procedure hWiz5.
  delete procedure hWiz6.
  delete procedure hWiz7.
  delete procedure hWiz8.
  delete procedure hWiz9.
  delete procedure hWiz10.
  delete procedure hWiz11.
  delete procedure hWiz12.
  delete procedure hWiz13.
  delete procedure hWiz14.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_ui Dialog-Frame _DEFAULT-DISABLE
PROCEDURE disable_ui :
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame 
PROCEDURE Realize :
define var ThisLine as char.
  define var ThisRec as char.
  
  assign
    ModeLabel[1] = "Labels":u
    ModeLabel[2] = "Column-Labels":u
    ModeLabel[3] = "Messages":u
    ModeLabel[4] = "List Items/Radio-Buttons":u
    ModeLabel[5] = "Titles":u
    ModeLabel[6] = "Assignments":u
    ModeLabel[7] = "Formats":u
    ModeLabel[8] = "Run Statements":u
    ModeLabel[9] = "Comparisons":u
    ModeLabel[10] = "Other":u /* translation allowed */
    ModeLabel[11] = "Keyword Values":u
    ModeLabel[12] = "Custom Filters":u
    ModeLabel[13] = "Special Filters":u
    ModeLabel[14] = "Summary":u. /* translation allowed */
  
  assign
    ModeText[1] = CR2 +
                  'Do you want to translate labels that appear in 4GL statements? Labels are the most common phrases translated. Examples:' + CR2 + 
                  '  define button x LABEL "Cancel".':u + CR1 +
                  '  display x LABEL "Address".':u + CR1 +
                  '  define menu x menubar':u + CR1 +
                  '    menu-item mExit LABEL "Exit".':u
                
    ModeText[2] = CR2 +
                  'Do you want to translate column-labels?  Column-labels most often appear in browsers but they also appear in set, update, and other statements. Example:' + CR2 +
                  '  define browse x query x display':u + CR1 +
                  '    kNet COLUMN-LABEL "Net"':u + CR1 +
                  '    kGross COLUMN-LABEL "Gross".':u
                
    ModeText[3] = CR2 +
                  'Do you want to translate message text? Messages appear in status and pause statements as well as regular expressions in message statements. Examples:' + CR2 +
                  '  MESSAGE "File not found".':u + CR1 +
                  '  STATUS MESSAGE "Press ESC".':u
                 
    ModeText[4] = CR2 +
                  'Do you want to translate radio-set buttons and list-items? Example:' + CR2 +
                  '  define var PayType as char':u + CR1 +
                  '    view-as combo-box':u + CR1 +
                  '    LIST-ITEMS "Visa,MC,AMEX"':u + CR2 +
                  'Note: Translating these phrases might generate logic errors when you compile the application.'

    ModeText[5] = CR2 +
                  'Do you want to translate titles for the captions of windows, frames, browse widgets, etc.? Example:' + CR2 +
                  '  define frame x':u + CR1 +
                  '    kNet at row 1 col 1':u + CR1 +
                  '    gNet at row 3 col 1':u + CR1 + 
                  '    with 1 down TITLE "Payment"':u

    ModeText[6] = CR2 +
                  'Do you want to translate assignment statements? Examples:' + CR2 +
                  '  PayType     = "Visa,MC,AMEX".':u + CR1 +
                  '  MyWin:title = "Order Entry".':u + CR1 +
                  '  propath     = propath + "," + "mydir".':u + CR2 +
                  'Note: This is a difficult assessment to make. You can include assignments now and exclude them later if needed.'
    .
    ASSIGN
    ModeText[7] = CR2 +
                  'Do you want to translate formats?  In most cases, you will not want to translate formats. However, you might want to translate formats to change the output of numeric or logical variables and fields.  Examples:' + CR2 +
                  '  define var x as logical FORMAT "oui/non".':u + CR1 +
                  '  display x FORMAT "$>>9.9(K)".':u

    ModeText[8] = CR2 +
                  'Do you want to translate the input parameters that appear in RUN statements? Examples:' + CR2 +
                  '  RUN myprog.p (input "Customer").':u + CR1 +
                  '  RUN dispatch (input "CLOSE").':u + CR2 +
                  'Note: Translating these phrases might generate logic errors when you compile the application.'

    ModeText[9] = CR2 +
                  'Do you want to translate values in comparisons? Comparisons are found in IF statements, DO loops, and WHERE clauses of FOR statements. Examples:' + CR2 +
                  '  IF x = "Quit" then ...':u + CR1 +
                  '  for each x WHERE y = "VISA":':u + CR2 +
                  'Note: Translating quoted values usually generates logic errors.'
                  
    ModeText[10] = CR2 +
                   'Do you want to translate text in other 4GL statements, such as EXPORT and PUT statements, and filenames in IMAGE phrases? Examples:' + CR2 +
                   '  define button x':u + CR1 +
                   '    image-up FILE "exit.ico".':u + CR1 +
                   '  put unformatted "Customer Name".':u
                   
    ModeText[11] = CR2 +
                   'Note: Up to this point, you have specified criteria to include in the translation data.' + CR2 +
                   'Do you want to exclude PROGRESS keyword values that appear in functions, assignments, and event-names?  Examples:' + CR2 +
                   '  apply "CHOOSE" to x.':u + CR1 +
                   '  session:date-format = "MDY".':u  
                   
    ModeText[12] = CR2 +
                   'Do you want to create your own custom filters to exclude specific phrases from translations? Examples:' + CR2 +
                   '  - Your company''s name or logo' + CR1 +
                   '  - Technical terms like DOS'

    ModeText[13] = CR2 +
                  'Use wildcard expressions for exclusions.  Examples:' + CR1 +
                  '  ".use*"  ':u + 'Would filter out: ' + CR1 +
                  '           '   + '    "Ause"':u + CR1 +
                  '           '   + '    "-use anything"':u + CR1 +
                  '           '   + '    "Duse ok."':u + CR1 +
                  '  "."      ':u + 'Would filter out all single character strings.' + CR2 +
                  'Single Character Strings.  Examples:' + CR1 +
                  '  ".","M","-","A"':u + ' and ' + '","':u + CR2 +
                  'No Alpha Characters.*  Examples:' + CR1 +
                  '  "123.45","&,.,=",':u + ' and ' + '">>,>>>.>>"':u + CR1 + 
                  '  * Alpha currently defined as English ' + 'A-Z, a-z.':u 
    ModeText[14] = CR2 +
                   'You have created several inclusion and exclusion filters that you can now write to the project translation database for future revision.'.


  /*
  ** Enable the frames and set up the appropriate initialization
  */
  do with frame Dialog-Frame:
    enable BtnCancel BtnPrev BtnNext BtnFinish MessageText with frame Dialog-Frame.

      
    display MessageLabel MessageText IncludeLabel with frame Dialog-Frame.
  end.
 
  run adecomm/_setcurs.p ("").
  frame Dialog-Frame:hidden = false.
  /*
  ** Silly run-time adjustments so that the dialog box will fit in Japanese
  ** Windows without the wonderful 4041 error. First, the rectangle, rect-1
  ** is adjusted to the width of the dialog box.  Then, the frame is adjusted
  ** to fit the bottom on the rectangle.  Dumb stuff...
  */
  assign
    result                    = MessageLabel:move-to-top()  
    Rect-1:width-p            = frame dialog-frame:width-p - 10.
   
  if session:pixels-per-row >= 26 then
    frame dialog-frame:height = rect-1:row + rect-1:height + .10.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetFrame Dialog-Frame 
PROCEDURE SetFrame :
case CurrentMode:
  when 1 then do:
    run SetLabel ("Include").
    run Realize in hWiz1.
    run HideMe in hWiz2.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.
  
  when 2 then do:
    run SetLabel ("Include").
    run Realize in hWiz2.
    run HideMe in hWiz1.
    run HideMe in hWiz3.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 3 then do:
    run SetLabel ("Include").
    run Realize in hWiz3.
    run HideMe in hWiz2.
    run HideMe in hWiz4.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 4 then do:
    run SetLabel ("Include").
    run Realize in hWiz4.
    run HideMe in hWiz3.
    run HideMe in hWiz5.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 5 then do:
    run SetLabel ("Include").
    run Realize in hWiz5.
    run HideMe in hWiz4.
    run HideMe in hWiz6.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 6 then do:
    run SetLabel ("Include").
    run Realize in hWiz6.
    run HideMe in hWiz5.
    run HideMe in hWiz7.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 7 then do:
    run SetLabel ("Include").
    run Realize in hWiz7.
    run HideMe in hWiz6.
    run HideMe in hWiz8.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 8 then do:
    run SetLabel ("Include").
    run Realize in hWiz8.
    run HideMe in hWiz7.
    run HideMe in hWiz9.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 9 then do:
    run SetLabel ("Include").
    run Realize in hWiz9.
    run HideMe in hWiz8.
    run HideMe in hWiz10.
    ExitFlag = false.
    BtnFinish:label in frame {&frame-name} = "&Finish".
  end.

  when 10 then do:
    run SetLabel ("Include").
    run Realize in hWiz10.
    run HideMe in hWiz9.
    run HideMe in hWiz11.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.
  
   when 11 then do:
    run SetLabel ("Exclude").
    run Realize in hWiz11.
    run HideMe in hWiz10.
    run HideMe in hWiz12.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 12 then do:
    run SetLabel ("Exclude").
    run Realize in hWiz12.
    run HideMe in hWiz11.
    run HideMe in hWiz13.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 13 then do:
    run SetLabel ("Exclude").
    run Realize in hWiz13.
    run HideMe in hWiz12.
    run HideMe in hWiz14.
    BtnFinish:label in frame {&frame-name} = "&Finish".
    ExitFlag = false.
  end.

  when 14 then do:   
    run adecomm/_setcurs.p ("wait":u).
    run SetLabel ("Defined").
    run Realize in hWiz14.
    run HideMe in hWiz13. 
    BtnFinish:label in frame {&frame-name} = "&Apply".
    ExitFlag = true.
    run adecomm/_setcurs.p ("").
  end. 
end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetLabel Dialog-Frame 
PROCEDURE SetLabel :
define input parameter pLabel as char no-undo.
  do with frame {&frame-name}:
    assign
      IncludeLabel:screen-value  = pLabel.
      IncludeLabel:width         = font-table:get-text-width-chars(IncludeLabel:screen-value,4).
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetMessage Dialog-Frame 
PROCEDURE SetMessage :
do with frame Dialog-Frame:
    assign
      MessageLabel:screen-value = ModeLabel[CurrentMode]
      MessageText:screen-value  = ModeText[CurrentMode].
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetSensitivity Dialog-Frame 
PROCEDURE SetSensitivity :
BtnPrev:sensitive in frame Dialog-Frame = CurrentMode > 1.
  BtnNext:sensitive in frame Dialog-Frame = CurrentMode <= 13.
 /* BtnFinish:sensitive in frame Dialog-Frame = CurrentMode <= 13. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetTitle Dialog-Frame 
PROCEDURE SetTitle :
if CurrentMode <= 13 then assign
  frame Dialog-Frame:title = "Filter Wizard - " + string(CurrentMode) + " of 13".
else assign
  frame Dialog-Frame:title = "Filter Wizard - Summary".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


