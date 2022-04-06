&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
define shared variable hMeter as handle no-undo.
define shared variable StopProcessing as logical no-undo.
define shared variable hGloss as handle no-undo.   
define shared variable hMain as handle no-undo.   
define shared variable KitDB as char no-undo.
define shared variable CurrentTool as char no-undo.
define shared variable Priv2 AS LOGICAL   NO-UNDO.

define variable OptionState as logical no-undo init true.
define variable ThisMessage as char no-undo.
define variable ErrorStatus as logical no-undo.
define variable i as int no-undo.
DEFINE VARIABLE skip-it AS LOGICAL NO-UNDO.
define variable TempFile as char no-undo.

{adetran/vt/vthlp.i}

def stream ThisStream.
def var RecsRead as int.
def var Result as log.
def var FileSize as int.
def var NumRecs like RecsRead.
def var Fld1 as char.
def var Fld2 as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Rect3 Rect2 Rect1 BtnOK GlossaryName ~
BtnCancel BtnHelp BtnOptions FileName BtnFile CodePage FieldOrder Delim ~
ToLabel GlossaryLabel FromLabel FileNameLabel CodePageLabel OptionsLabel ~
OrderLabel DelimLabel 
&Scoped-Define DISPLAYED-OBJECTS GlossaryName FileName CodePage FieldOrder ~
Delim ToLabel GlossaryLabel FromLabel FileNameLabel CodePageLabel ~
OptionsLabel OrderLabel DelimLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnFile 
     LABEL "&Files..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOptions 
     LABEL "&Options >>":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE CodePage AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE GlossaryName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE CodePageLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Code Page:" 
      VIEW-AS TEXT 
     SIZE 34.8 BY .67 NO-UNDO.

DEFINE VARIABLE DelimLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Delimiter" 
      VIEW-AS TEXT 
     SIZE 22.2 BY .67 NO-UNDO.

DEFINE VARIABLE FileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE VARIABLE FileNameLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Filename:" 
      VIEW-AS TEXT 
     SIZE 35.4 BY .67 NO-UNDO.

DEFINE VARIABLE FromLabel AS CHARACTER FORMAT "X(256)":U INITIAL "From" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .67 NO-UNDO.

DEFINE VARIABLE GlossaryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Glossary Name:" 
      VIEW-AS TEXT 
     SIZE 45.8 BY .67 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Options" 
      VIEW-AS TEXT 
     SIZE 8.6 BY .67 NO-UNDO.

DEFINE VARIABLE OrderLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Order:" 
      VIEW-AS TEXT 
     SIZE 7.6 BY .67 NO-UNDO.

DEFINE VARIABLE ToLabel AS CHARACTER FORMAT "X(256)":U INITIAL "To" 
      VIEW-AS TEXT 
     SIZE 4.6 BY .67 NO-UNDO.

DEFINE VARIABLE Delim AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Space &Delimited", "B":U,
"&Comma Delimited", "C":U
     SIZE 22 BY 1.62 NO-UNDO.

DEFINE VARIABLE FieldOrder AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Source/Target", 1,
"&Target/Source", 2
     SIZE 22 BY 1.62 NO-UNDO.

DEFINE RECTANGLE Rect1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.4 BY 2.19.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.4 BY 4.1.

DEFINE RECTANGLE Rect3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.4 BY 3.05.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BtnOK AT ROW 1.48 COL 63
     GlossaryName AT ROW 2.52 COL 4.4 NO-LABEL
     BtnCancel AT ROW 2.76 COL 63
     BtnHelp AT ROW 4.05 COL 63
     BtnOptions AT ROW 5.29 COL 63
     FileName AT ROW 5.38 COL 4.4 NO-LABEL
     BtnFile AT ROW 5.48 COL 44
     CodePage AT ROW 7.24 COL 4.4 NO-LABEL
     FieldOrder AT ROW 9.86 COL 4.4 NO-LABEL
     Delim AT ROW 9.86 COL 29.2 NO-LABEL
     ToLabel AT ROW 1.24 COL 4.4 NO-LABEL
     GlossaryLabel AT ROW 1.81 COL 4.4 NO-LABEL
     FromLabel AT ROW 4 COL 4.4 NO-LABEL
     FileNameLabel AT ROW 4.71 COL 4.4 NO-LABEL
     CodePageLabel AT ROW 6.52 COL 4.4 NO-LABEL
     OptionsLabel AT ROW 8.52 COL 4.4 NO-LABEL
     OrderLabel AT ROW 9.19 COL 4.4 NO-LABEL
     DelimLabel AT ROW 9.19 COL 29.2 NO-LABEL
     Rect3 AT ROW 8.81 COL 2.6
     Rect2 AT ROW 4.33 COL 2.6
     Rect1 AT ROW 1.52 COL 2.6
     SPACE(18.19) SKIP(8.61)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Import":L
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   L-To-R                                                               */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR COMBO-BOX CodePage IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN CodePageLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN DelimLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileName IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FileNameLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN FromLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN GlossaryLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX GlossaryName IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN OptionsLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN OrderLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ToLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile DIALOG-1
ON CHOOSE OF BtnFile IN FRAME DIALOG-1 /* Files... */
DO:
  define variable ImportFile as character no-undo.
  define variable OKPressed as logical no-undo.

  system-dialog get-file ImportFile
     title      "Import File..."
     filters    "Comma-Delimited (*.csv)":u   "*.csv":u,
                "ASCII Text (*.txt)":u        "*.txt":u, 
                "Export (*.d)":u              "*.d":u,                
                "All Files (*.*)":u           "*.*":u
     use-filename
     update okpressed.      

  if okpressed = true then do:
    FileName:screen-value = ImportFile. 
    apply "leave":u to FileName.
  end.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR help OF FRAME Dialog-1 /* Help */
DO:
  if CurrentTool = "VT":u then
    run adecomm/_adehelp.p ("vt":u,"context":u,{&Import_dlgbox}, ?).  
  else    
    run adecomm/_adehelp.p ("tran":u,"context":u,{&Import_dlgbox}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:      
  define var NewFld1 as char.
  define var NewFld2 as char.
  define var TestCP as char.
  
  if FileName:screen-value = "" then do: 
    ThisMessage = "You must enter a filename first.".    
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    FileName:auto-zap = true.   
    apply "entry":u to FileName.
    return no-apply.
  end.

  FILE-INFO:FILE-NAME = FileName:SCREEN-VALUE.
  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    ThisMessage = FileName:SCREEN-VALUE +
         "^Cannot find this file. Please verify that the pathname and filename are correct.".
    run adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
    FileName:AUTO-ZAP = TRUE.
    RETURN NO-APPLY.
  END.

  /*
  ** Check to see if the import file has any codepage conversion that will work.
  ** if it fails, ask whether or not we should continue without a conversion.
  */
  run adetran/common/_convert.p (session:charset, CodePage:screen-value, output ErrorStatus).
  if not ErrorStatus then do:
    ThisMessage = "Continue import without a codepage conversion?".
    run adecomm/_s-alert.p (input-output Result, "q*":u, "yes-no":u, ThisMessage). 
    if Result then 
      input stream ThisStream from value(FileName:screen-value).
    else
      return no-apply.
  end. 
  else do:
    input stream ThisStream from value(FileName:screen-value) convert source CodePage:screen-value target session:charset. 
  end. 
  
  frame {&frame-name}:hidden = true.         
  run Realize in hMeter("Importing...").
   
  seek stream ThisStream to end.
  assign
    FileSize = seek(ThisStream)
    Result   = yes.  
   
  seek stream ThisStream to 0.
  if not Result or Result = ? then do:
    input stream ThisStream close.
    return.
  end.    

  skip-it = false.   
  repeat:
    process events.
    if StopProcessing then do:
      run HideMe in hMeter.
      leave.         
    end. 

    ASSIGN Fld1     = ""
           Fld2     = ""
           RecsRead = RecsRead + 1.
 
    if Delim:screen-value = "C":U then    
      import stream ThisStream delimiter ",":u Fld1 Fld2 no-error. 
    else
      import stream ThisStream Fld1 Fld2 no-error.
       
    run SetBar in hMeter (FileSize, seek(ThisStream), Fld1). 
          
    if FieldOrder:screen-value = string(1) then
      assign NewFld1 = Fld1
             NewFld2 = Fld2.
    else
      assign NewFld1 = Fld2
             NewFld2 = Fld1. 

    IF Not Priv2 THEN DO:
      skip-it = CAN-FIND(FIRST kit.XL_GlossEntry where
           kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(NewFld1, 1, 63, "RAW":U) AND
           kit.XL_GlossEntry.SourcePhrase MATCHES NewFld1).
    END.

    find kit.XL_GlossEntry where
      kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(NewFld1, 1, 63, "RAW":U) AND
      kit.XL_GlossEntry.ShortTarg    BEGINS SUBSTRING(NewFld2, 1, 63, "RAW":U) AND
      kit.XL_GlossEntry.SourcePhrase MATCHES NewFld1 and
      kit.XL_GlossEntry.TargetPhrase MATCHES NewFld2
      use-index SrcTarg no-error.
       
    if not available kit.XL_GlossEntry AND NOT skip-it then do:             
      create kit.XL_GlossEntry no-error.
      assign NumRecs                                 = NumRecs + 1
             kit.XL_GlossEntry.GlossaryType          = "C":u
             kit.XL_GlossEntry.ModifiedByTranslator  = TRUE
             kit.XL_GlossEntry.ShortSrc              = SUBSTRING(NewFld1, 1, 63, "RAW":U)
             kit.XL_GlossEntry.ShortTarg             = SUBSTRING(NewFld2, 1, 63, "RAW":U)
             kit.XL_GlossEntry.SourcePhrase          = NewFld1
             kit.XL_GlossEntry.TargetPhrase          = NewFld2.
    end.
  end.
  output close.
  run HideMe in hMeter. 

   
  run OpenQuery in hGloss. 
  run SetSensitivity in hMain.
    
  ThisMessage = string(RecsRead) + " Glossary records were read; " + string(NumRecs) + " were added.".  
  run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions DIALOG-1
ON CHOOSE OF BtnOptions IN FRAME DIALOG-1 /* Options >> */
DO:
 if OptionState then do:
   frame {&frame-name}:height = 12.5.
   
   assign
     OptionState                  = false
     Rect3:hidden                 = false
     OptionsLabel:hidden          = false
     OrderLabel:hidden            = false
     FieldOrder:hidden            = false
     DelimLabel:hidden            = false
     Delim:hidden                 = false
     BtnOptions:label             = ">> &Options".
     
   apply "entry":u to FieldOrder.
 end.
 else do:
   assign                                
     OptionState                  = true
     Rect3:hidden                 = true
     OptionsLabel:hidden          = true
     OrderLabel:hidden            = true
     FieldOrder:hidden            = true
     DelimLabel:hidden            = true
     Delim:hidden                 = true
     BtnOptions:label             = "&Options >>"  
     frame {&frame-name}:height   = 9.    
     
   apply "entry":u to FileName.
 end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileName DIALOG-1
ON LEAVE OF FileName IN FRAME DIALOG-1
DO:
  DEFINE VARIABLE FileExt AS CHARACTER                                     NO-UNDO.
  IF FileName:SCREEN-VALUE = "" THEN RETURN.

  IF NUM-ENTRIES(FileName:SCREEN-VALUE,".":U) > 1 THEN
    FileExt = ENTRY(2,FileName:SCREEN-VALUE,".":U).

  Delim:SCREEN-VALUE = IF FileExt = "csv":U THEN "C":U ELSE "B":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  assign       
    GlossaryName              = KitDB
    GlossaryName:list-items   = GlossaryName
    GlossaryName:screen-value = GlossaryName:entry(1)
    
    CodePage:list-items        = get-codepages
    CodePage:screen-value      = "ISO8859-1":u
    
    ToLabel:screen-value       = "To"
    FromLabel:screen-value     = "From"
    OptionsLabel:screen-value  = "Options"
    
    GlossaryLabel:screen-value = "Glossary Name:"
    FileNameLabel:screen-value = "Filename:"
    CodePageLabel:screen-value = "Code Page:"
    OrderLabel:screen-value    = "Order:"
    DelimLabel:screen-value    = "Delimiter:"
    
    ToLabel:width              = font-table:get-text-width-chars (ToLabel:screen-value,4)
    FromLabel:width            = font-table:get-text-width-chars (FromLabel:screen-value,4)
    OrderLabel:width           = font-table:get-text-width-chars (OrderLabel:screen-value,4).
   
  RUN Realize.
  
  
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1  _DEFAULT-DISABLE
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
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize DIALOG-1 
PROCEDURE Realize :
frame {&frame-name}:hidden = true.

  enable      
    ToLabel
    FromLabel
    
    FileName
    BtnFile
    CodePage
    FieldOrder 
    Delim
    
    BtnOk
    BtnCancel
    BtnHelp
    BtnOptions
  with frame {&frame-name}.
  
  assign
     Rect3:hidden                 = true
     OptionsLabel:hidden          = true
     OrderLabel:hidden            = true
     FieldOrder:hidden            = true
     DelimLabel:hidden            = true
     Delim:hidden                 = true
     frame {&frame-name}:height   = 9.
     
  frame {&frame-name}:hidden = false.
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

