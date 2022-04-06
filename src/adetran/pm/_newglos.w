&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"Basic Dialog-Box Template

Use this template to create a new dialog-box. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
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

Procedure:    adetran/pm/_newglos.w
Author:       R. Ryan
Created:      1/95 
Updated:      9/95
                11/96 SLK lc/caps
		04/97 SLK Bug#97-02-02-005
Purpose:      Dialog which allows the user to add a glossary
              even if it is empty.               
Background:   A "glossary" is a really a name that identifies
              some records in the XL_GlossDet table:
              +--------------------------------------------------+
              | Glossary   | Source    | Target    | Modi-| Glos |
              | Name       | Phrase    | Phrase    | fied | Type |
              +--------------------------------------------------+
              | MyFrench   | hello     | bonjour   | no   | D    |
              | MyFrench   | city      | ville     | no   | D    |
              | MyFrench   | hi        | bonjour   | no   | D    |
              | Espanol    | hello     | como estas| no   | D    |
              | Espanol    | city      | cuidad    | no   | D    |
              | Espanol    | hi        | hola      | no   | D    |
              +--------------------------------------------------+
              
Notes:        The GlossaryName updates a shared variable, s_Glossary,
              to figure out which of the glossaries to insert the
              data into.  Because the primary key (regretably) is
              a concatenated key (GlossaryName,Source,Target), it is
              this combination that makes a glossary entry a member
              of a specific glossary.  Because of a Progress limitation
              where an index can't exceed 188 bytes, the length of
              the glossary name, the source, and target phrases is
              checked for 188 bytes and rejected if it exceeds that. 

              Besides creating an entry (or entries) in the XL_GlossDet
              table, an entry is also made for XL_Glossary that keeps
              track of the name of the glossary, when it created, when
              it was updated, and how many entries it has.
              
              Finally, Microsoft glossaries can be 'imported' by 
              selecting the appropriate check box.  When a MS glossary
              is selected, a selection list in a separate dialog allows
              the user to choose the appropriate glossary.  At this 
              point, the codepage of the glossary is evaluated to see if
              a codepage conversion is necessary/possible.  If it can
              be done, then the glossary is load *UNLESS* the combination
              of the glossary entry/glossaryname exceeds 188 bytes (then
              the user is warned that this entry can't be made).  Duplicates
              are all also kicked out (ask yourself why Microsoft has 
              so many duplicates?).  Otherwise, the glossary loads, and at
              the very end, the number of entries in the glossary (i.e. 
              where xlatedb.XL_GlossDet.GlossaryName = s_Glossary) are updated
              in the XL_Glossary table.
              
Called By:    pm/_gloss.p
Calls:        pm/_convert.p (checks to see if codepage conversion is possible)

*/


define output parameter pOKPressed as logical no-undo.
define output parameter pErrorStatus as logical no-undo. 

{ adetran/pm/tranhelp.i } /* definitions for help context strings */  
define shared var ProjectDB as char no-undo.
define shared var _hGloss as handle no-undo.
define shared var s_Glossary as char no-undo.
define stream GlosStream. 
define shared var StopProcessing as logical no-undo.
define shared variable NewWindow as widget-handle.
define shared var _hMeter as handle no-undo.
DEFINE NEW SHARED VAR hMeter AS HANDLE NO-UNDO.
ASSIGN hMeter = _hMeter.   /* Kluge to get aroung _ problem at run-time */


define var FileName as char no-undo.  
define var OKPressed as logical no-undo.
define var Result as logical no-undo.
define var OptionState as logical no-undo init true. 
define var ThisMessage as char no-undo.
define var ErrorStatus as logical no-undo.
define var i as integer no-undo.
define var TempFile as char no-undo.
define var GlossaryList as char no-undo.
define var CodePage as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ContainerRectangle1 BtnOK GlossaryName ~
ReplaceIfExists BtnCancel BtnHelp Rect2 FromLanguage BtnOptions ToLanguage ~
TechGlossary Rect3 CopyFromDB BtnConnect CopyFromGlossary CopyGlossary ~
GlossaryLabel LanguageLabel CopyLabel 
&Scoped-Define DISPLAYED-OBJECTS GlossaryName ReplaceIfExists FromLanguage ~
ToLanguage TechGlossary CopyFromDB CopyFromGlossary CopyGlossary ~
GlossaryLabel LanguageLabel CopyLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnConnect 
     LABEL "Connect...":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOptions 
     LABEL "&Options >>":L 
     SIZE 15 BY 1.12.

DEFINE VARIABLE CopyFromDB AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "None" 
     SIZE 36.14 BY 1 NO-UNDO.

DEFINE VARIABLE CopyLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Copy From Database" 
      VIEW-AS TEXT 
     SIZE 20.57 BY .65 NO-UNDO.

DEFINE VARIABLE FromLanguage AS CHARACTER FORMAT "X(15)":U 
     LABEL "&From (Source)" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE GlossaryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Glossary" 
      VIEW-AS TEXT 
     SIZE 9 BY .65 NO-UNDO.

DEFINE VARIABLE GlossaryName AS CHARACTER FORMAT "x(30)":U 
     LABEL "New &Name" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38 BY 1 NO-UNDO.

DEFINE VARIABLE LanguageLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Languages" 
      VIEW-AS TEXT 
     SIZE 12.57 BY .65 NO-UNDO.

DEFINE VARIABLE ToLanguage AS CHARACTER FORMAT "X(15)":U 
     LABEL "&To (Target)" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38 BY 1 NO-UNDO.

DEFINE RECTANGLE ContainerRectangle1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 2.46.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 3.81.

DEFINE RECTANGLE Rect3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57 BY 4.31.

DEFINE VARIABLE CopyFromGlossary AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     LIST-ITEMS "None" 
     SIZE 36 BY 1.54 NO-UNDO.

DEFINE VARIABLE CopyGlossary AS LOGICAL INITIAL yes 
     LABEL "&Copy Selected Glossary":L 
     VIEW-AS TOGGLE-BOX
     SIZE 43.43 BY .65 NO-UNDO.

DEFINE VARIABLE ReplaceIfExists AS LOGICAL INITIAL yes 
     LABEL "Replace Glossary If &Exists" 
     VIEW-AS TOGGLE-BOX
     SIZE 36.14 BY .65 NO-UNDO.

DEFINE VARIABLE TechGlossary AS LOGICAL INITIAL yes 
     LABEL "Include &Microsoft's Glossary":L 
     VIEW-AS TOGGLE-BOX
     SIZE 38 BY .65 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.65 COL 60
     GlossaryName AT ROW 1.81 COL 17 COLON-ALIGNED
     ReplaceIfExists AT ROW 2.96 COL 19
     BtnCancel AT ROW 3 COL 60
     BtnHelp AT ROW 4.35 COL 60
     FromLanguage AT ROW 4.81 COL 17 COLON-ALIGNED
     BtnOptions AT ROW 5.58 COL 60
     ToLanguage AT ROW 6 COL 17 COLON-ALIGNED
     TechGlossary AT ROW 7.27 COL 19
     CopyFromDB AT ROW 9.42 COL 1 COLON-ALIGNED NO-LABEL
     BtnConnect AT ROW 9.46 COL 42
     CopyFromGlossary AT ROW 10.54 COL 3 NO-LABEL
     CopyGlossary AT ROW 12.19 COL 3
     GlossaryLabel AT ROW 1.31 COL 4 NO-LABEL
     LanguageLabel AT ROW 4.23 COL 4.43 NO-LABEL
     CopyLabel AT ROW 8.54 COL 4.43 NO-LABEL
     ContainerRectangle1 AT ROW 1.54 COL 1
     Rect2 AT ROW 4.54 COL 1
     Rect3 AT ROW 8.85 COL 1
     SPACE(20.19) SKIP(0.35)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Add Glossary"
         DEFAULT-BUTTON BtnOK.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   EXP-POSITION                                                         */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:ROW              = 1
       FRAME Dialog-Frame:COLUMN           = 1.

/* SETTINGS FOR FILL-IN CopyLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN GlossaryLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN LanguageLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Add Glossary */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnConnect Dialog-Frame
ON CHOOSE OF BtnConnect IN FRAME Dialog-Frame /* Connect... */
DO: 
  /* Database Parameters */
  DEFINE VARIABLE PysName    AS CHARACTER    NO-UNDO. /* Physical DB Name */
  DEFINE VARIABLE LogName    AS CHARACTER    NO-UNDO. /* Logical DB Name  */
  DEFINE VARIABLE theType    AS CHARACTER    NO-UNDO. /* DBNameType"PROGRESS" */
  DEFINE VARIABLE Db_Multi_User AS LOGICAL      NO-UNDO.

  /* Addl. Parameters */
  DEFINE VARIABLE network    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE host       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE service    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE uid        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pwd        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE trigloc    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pfile      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE pargs      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE constring  AS CHARACTER    NO-UNDO.
  
  /* Set defaults for the db connect dialog. */
  ASSIGN DB_Multi_User = no
         theType       = "PROGRESS":U.

  run adecomm/_dbconnx.p ( YES,
                          INPUT-OUTPUT PysName,
                          INPUT-OUTPUT LogName,
                          INPUT-OUTPUT theType,       
                          INPUT-OUTPUT Db_Multi_User,
                          INPUT-OUTPUT network,
                          INPUT-OUTPUT host,
                          INPUT-OUTPUT service,
                          INPUT-OUTPUT uid,
                          INPUT-OUTPUT pwd,
                          INPUT-OUTPUT trigloc,
                          INPUT-OUTPUT pfile,
                          INPUT-OUTPUT pargs,
                          OUTPUT       constring ).
  run BuildDBList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran":u,"context":u,{&add_glossary_dialog_box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:  
  run adecomm/_setcurs.p ("wait":u).
  define var GlossaryCount as integer no-undo.
  define var TestName as char no-undo.
  define var DirName as char no-undo.
  define var BaseName as char no-undo. 

  /*
  ** Before doing anything, first test to see if a database name 
  ** exists.
  */    
  if GlossaryName:screen-value = "" then do:
    ThisMessage = "You must enter a glossary name first.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    return no-apply.
  end.   

  /*
  ** OK, it exists, but check to see if we should overwrite this 
  */   
  if search(GlossaryName:screen-value) <> ? and NOT ReplaceIfExists:checked then do:
    ThisMessage = GlossaryName:screen-value + '^Exists.  Try changing the name or specify "Replace If Exists".'. 
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    return no-apply.
  end.  

  /*
  ** apply the leave event to see if the database file name is valid
  */  
  apply "leave":u to GlossaryName in frame {&frame-name}.
                  
  /*
  ** does the database name already exist in the table?
  */      
  if not ReplaceIfExists:checked then do:
    for each xlatedb.XL_Glossary no-lock:
      if xlatedb.XL_Glossary.GlossaryName = GlossaryName:screen-value then do:
        ThisMessage = GlossaryName:screen-value + "^Already exists in the glossary and will not be entered.".
        run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
        GlossaryName:auto-zap = true.
        apply "entry":u to GlossaryName in frame {&frame-name}.
        return no-apply.
      end.
    end.
   end.
   else do:  
     for each xlatedb.XL_GlossDet where 
       xlatedb.XL_GlossDet.GlossaryName = GlossaryName:screen-value exclusive-lock.
         delete xlatedb.XL_GlossDet.
     end.      
     find xlatedb.XL_Glossary where
       xlatedb.XL_Glossary.GlossaryName = GlossaryName:screen-value 
       exclusive-lock no-error.
     if available xlatedb.XL_Glossary then delete xlatedb.XL_Glossary.
    end.   
    
  /*
  ** Check to see if the To and From languages are completed.
  */    
  if ToLanguage:screen-value = "" or FromLanguage:screen-value = "" then do:
    ThisMessage = 'You must enter a "To/From" language name first.'. 
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    apply "entry":u to FromLanguage in frame {&frame-name}.
    return no-apply.
  end.
  
  /*
  ** are the languages the same?
  */
  apply "leave":u to ToLanguage.
  
  
  /*
  ** Load up the technical glossary?
  */  
  s_Glossary = GlossaryName:screen-value.
  if TechGlossary:checked then do:   
    frame {&frame-name}:hidden = true.
    run LoadGlossary (input FileName, output GlossaryCount, output ErrorStatus).
    if ErrorStatus then do:
      frame {&frame-name}:hidden = false.  
      apply "ENTRY":U to frame {&frame-name}.
      return no-apply.
    end.
  end. 
  
  
  /*
  ** Should we copy from a connected databases' glossary?
  */
  if CopyGlossary:checked then do:
    run CopyGlossary.
  end.
       
  /*
  ** Time to update the XL_Glossary record that is a map back to
  ** real glossary table
  */   
  run CountEntries in _hGloss (INPUT GlossaryName:SCREEN-VALUE
                             , OUTPUT GlossaryCount).                      
  create xlatedb.XL_Glossary.
  assign 
    xlatedb.XL_Glossary.GlossaryName    = GlossaryName:screen-value
    xlatedb.XL_Glossary.CreateDate      = today
    xlatedb.XL_Glossary.GlossaryType    = FromLanguage:screen-value + "/":u + 
                                            ToLanguage:screen-value
    xlatedb.XL_Glossary.LinkType        = "S":u
    xlatedb.XL_Glossary.GlossaryCount   = GlossaryCount.  


  /* Create a new language once a glossary is loaded - No need to wait
   * until a language is loaded. We do NOT set the shared variable
   */
  find xlatedb.XL_Language where xlatedb.XL_Language.lang_name = 
  ToLanguage:SCREEN-VALUE
                           no-lock no-error.
  if not available xlatedb.XL_Language then do:  
    create xlatedb.XL_Language.
    assign xlatedb.XL_Language.lang_name = ToLanguage:SCREEN-VALUE.
  end.
  
  run Realize in _hGloss.
  run adecomm/_setcurs.p ("").   
       
  OKPressed = true.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions Dialog-Frame
ON CHOOSE OF BtnOptions IN FRAME Dialog-Frame /* Options >> */
do:
 if OptionState then do:
   frame {&frame-name}:height = 13.65.
   
   assign
     OptionState             = false
     Rect3:hidden            = false
     CopyLabel:hidden        = false
     CopyFromDB:hidden       = false
     BtnConnect:hidden       = false
     CopyFromGlossary:hidden = false
     CopyGlossary:hidden     = false
     BtnOptions:label        = ">> &Options".
     
   apply "entry":u to CopyFromDB.
 end.
 else do:
   assign
     OptionState                = true
     Rect3:hidden               = true
     CopyLabel:hidden           = true
     CopyFromDB:hidden          = true
     BtnConnect:hidden          = true
     CopyFromGlossary:hidden    = true
     CopyGlossary:hidden        = true
     BtnOptions:label           = "&Options >>"  
     frame {&frame-name}:height = 9.    
     
   apply "entry":u to GlossaryName.
 end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CopyFromDB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CopyFromDB Dialog-Frame
ON VALUE-CHANGED OF CopyFromDB IN FRAME Dialog-Frame
DO:
  if self:screen-value = "None":u then return. 

  define var SchemaFile as char no-undo.
  define var SchemaPresent as logical no-undo.    
  
  CopyFromDB = CopyFromDB:screen-value.  

  run adecomm/_tmpfile.p ("t2":u, ".tmp":u, OUTPUT SchemaFile). 
  OUTPUT TO VALUE(SchemaFile).
  put unformatted
    'DEFINE OUTPUT PARAMETER pSchemaOK AS LOGICAL NO-UNDO.':U SKIP(1)
    'IF CAN-FIND(':U + CopyFromDB + '._FILE WHERE _FILE-NAME = "XL_Glossary":U) AND':U SKIP
    '   CAN-FIND(':U + CopyFromDB + '._FILE WHERE _FILE-NAME = "xl_kit":U) THEN pSchemaOK = TRUE.':U.
  OUTPUT CLOSE.
  run value(SchemaFile) (output SchemaPresent). 
  if not SchemaPresent then do: 
    assign CopyFromGlossary:list-items   = "None":u
           CopyFromGlossary:screen-value = CopyFromGlossary:entry(1).
    OS-DELETE VALUE(SchemaFile).
    return.         
  end.
  
  
  /* Now that we know that the proper schema exists, continue  */                       
  run adecomm/_tmpfile.p ("t2":u, ".tmp":u, OUTPUT TempFile). 
  output to value(TempFile).
  put unformatted
    'DEFINE OUTPUT PARAMETER GlossaryList AS CHARACTER NO-UNDO.':U SKIP(1)
    'FOR EACH ':U + CopyFromDB + '.XL_Glossary NO-LOCK:':U SKIP
    '  GlossaryList = IF GlossaryList = "" THEN':U SKIP
    '                   ':U +  CopyFromDB + '.XL_Glossary.GlossaryName':U SKIP
    '                 ELSE':U SKIP
    '                   GlossaryList + ",":u + ':U + CopyFromDB +
                                            '.XL_Glossary.GlossaryName.':U SKIP
    'END.':U SKIP(1)
    'IF GlossaryList = "" THEN GlossaryList = "None":u.':U.
  output close. 

  run value(TempFile) (output GlossaryList).  
  CopyFromGlossary:list-items   = IF GlossaryList = "":U THEN "None":U
                                                         ELSE GlossaryList.
  CopyFromGlossary:screen-value = CopyFromGlossary:ENTRY(1).

  os-delete value(SchemaFile)
  os-delete value(TempFile). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FromLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FromLanguage Dialog-Frame
ON LEAVE OF FromLanguage IN FRAME Dialog-Frame /* From (Source) */
DO:
   if FromLanguage:screen-value <> "":U and
     FromLanguage:screen-value = ToLanguage:screen-value then do:
       ThisMessage = 'The "To/From" languages must be different.'.
       run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
       FromLanguage:auto-zap = true.
       apply "entry":u to FromLanguage.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME GlossaryName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL GlossaryName Dialog-Frame
ON LEAVE OF GlossaryName IN FRAME Dialog-Frame /* New Name */
DO:
  GlossaryName = GlossaryName:screen-value.
  
  /* It is illegal to have a file name be one of the two reserved keywords
     "Untitled" and "None".                                                 */
  IF CAN-DO("UNTITLED,NONE":U,GlossaryName) THEN DO:
    ASSIGN ThisMessage = GlossaryName + 
             " is a reserved keyword and may not be used as a glossary name.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"e*":U, "ok":U, ThisMessage).
    apply "ENTRY":u to GlossaryName in frame Dialog-frame.
    return no-apply.  
  END. 

  if length(GlossaryName,"CHARACTER":u) > 30 then do:
    ThisMessage = GlossaryName:screen-value + "^This table name is not valid.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    GlossaryName:auto-zap = true.
    apply "entry":u to GlossaryName in frame Dialog-frame.
    return no-apply.  
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TechGlossary
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TechGlossary Dialog-Frame
ON VALUE-CHANGED OF TechGlossary IN FRAME Dialog-Frame /* Include Microsoft's Glossary */
DO: 
 if NOT TechGlossary:checked then return.
   
 def button BtnOk     AUTO-GO DEFAULT label "OK":U SIZE 15 BY 1.12.
 def button BtnCancel AUTO-ENDKEY label "Cancel":U SIZE 15 BY 1.12.
 def button BtnDisclaimer label "&Disclaimer..." SIZE 15 BY 1.12.
 
 def rectangle Box edge-pixels 2 graphic-edge no-fill
   size 35 by 4.65. 
   define var GlossaryTypes as char 
   view-as selection-list single scrollbar-vertical
   size 31 by 3.65  sort list-items "".

 def frame TechFrame 
   Box at row 1.5 col 2 skip (.5) 
   GlossaryTypes at row 2 col 3.75 
   " Glossaries " VIEW-AS TEXT AT ROW 1.25 COL 3.5
   BtnOK     AT ROW 1.5 COL 38.5 SKIP (.1)
   BtnCancel AT 38.5 skip (.1)
   BtnDisclaimer AT 38.5 space(1.25)
   with side-labels no-labels default-button BtnOK view-as dialog-box
     three-d font 4 title "Microsoft Glossaries".


  on help of frame TechFrame do:
    run adecomm/_adehelp.p ("tran":u,"context":u,{&add_glossary_dialog_box}, ?).
  end. 
  
  on choose of BtnOK or DEFAULT-ACTION of GlossaryTypes IN FRAME TechFrame do: 
    define var TestValue as char. 

    TestValue = entry(2,GlossaryTypes:screen-value,"/":u).
    case TestValue:  
      when "Czech":u then assign
        FileName = "adetran/data/czech.csv":u
        CodePage = "1250":U.

      when "Danish":U then assign
        FileName = "adetran/data/danish.csv":u
        CodePage = "ISO8859-1":U.

      when "Dutch":U then assign
        FileName = "adetran/data/dutch.csv":u
        CodePage = "ISO8859-1":U.

      when "Finnish":U then assign
        FileName = "adetran/data/finnish.csv":u
        CodePage = "ISO8859-1":U.

      when "French":U then assign
        FileName = "adetran/data/french.csv":u
        CodePage = "ISO8859-1":U.

      when "German":U then assign
        FileName = "adetran/data/german.csv":u
        CodePage = "ISO8859-1":U.

      when "Portuguese":U then assign
        FileName = "adetran/data/port.csv":u
        CodePage = "ISO8859-1":U.

      when "Greek":U then assign
        FileName = "adetran/data/greek.csv":u
        CodePage = "1253":U.
        
      when "Hungarian":U then assign
        FileName = "adetran/data/hungary.csv":u
        CodePage = "1250":U.
        
      when "Italian":U then assign
        FileName = "adetran/data/italian.csv":u
        CodePage = "ISO8859-1":U.         
        
      when "Norwegian":U then assign
        FileName = "adetran/data/norway.csv":u
        CodePage = "ISO8859-1":U.    
        
      when "Portuguese":U then assign
        FileName = "adetran/data/port.csv":u
        CodePage = "ISO8859-1":U.

      when "Russian":U then assign
        FileName = "adetran/data/russian.csv":u
        CodePage = "1251":U.

      when "Spanish":U then assign
        FileName = "adetran/data/spanish.csv":u
        CodePage = "ISO8859-1":U.

      when "Swedish":U then assign
        FileName = "adetran/data/swedish.csv":u
        CodePage = "ISO8859-1":U.
    end case.  
    

    assign
      file-info:filename = FileName
      FileName           = file-info:full-pathname.
    IF LAST-EVENT:LABEL = "DEFAULT-ACTION":U THEN APPLY "GO":U TO FRAME TechFrame.
  end.   
  
  on choose of BtnCancel do:   
    TechGlossary:checked in frame dialog-frame = false.
  end.  
  
  on choose of BtnDisClaimer do: 
    def button BtnOk     AUTO-GO     label "OK":U size 12.29 by .88.
    def rectangle Box edge-pixels 2 graphic-edge no-fill
      size 60 by 8. 

      define var Disclaimer as char view-as editor scrollbar-vertical
      size 56 by 7 no-undo.

    def frame DisclaimerFrame 
     Box at row 1.5 col 2 skip (.5) 
     Disclaimer at row 2 col 3.75 
     " Abstract " VIEW-AS TEXT AT ROW 1.25 COL 3.5
     BtnOK     AT ROW 1.5 COL 63.5 space(1.25)
     with side-labels no-labels default-button BtnOK view-as dialog-box
     three-d font 4 title "Disclaimer".  

    /*
    ** Enable and wait-for for the disclaimer
    */
    enable all with frame DisclaimerFrame.  
    
    assign
      file-info:file-name = "adetran/data/abstract.txt":u.
    
    Result = Disclaimer:read-file(file-info:full-pathname).
    wait-for go of frame DisclaimerFrame.
  end.
   
  enable all with frame TechFrame.
  assign
    GlossaryTypes              = "English/Czech,English/Danish,English/Dutch":u
    GlossaryTypes              = GlossaryTypes + ",English/Finnish,English/French":u
    GlossaryTypes              = GlossaryTypes + ",English/German,English/Greek":U
    GlossaryTypes              = GlossaryTypes + ",English/Hungarian,English/Italian":u
    GlossaryTypes              = GlossaryTypes + ",English/Norwegian,English/Portuguese":u
    GlossaryTypes              = GlossaryTypes + ",English/Russian,English/Spanish":u
    GlossaryTypes              = GlossaryTypes + ",English/Swedish":u
    GlossaryTypes:list-items   = GlossaryTypes.
    
  do i = 1 to GlossaryTypes:num-items:
    if index(ToLanguage:screen-value,entry(2,entry(i,GlossaryTypes:list-items,",":u),"/":u)) > 0 then do:
      GlossaryTypes = entry(i,GlossaryTypes:list-items,",":u).
      leave.
    end.
  end.
  
  if GlossaryTypes <> "" then
    GlossaryTypes:screen-value = GlossaryTypes.
  else
    Glossarytypes:screen-value = GlossaryTypes:entry(1). 
    
  wait-for go of frame TechFrame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToLanguage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToLanguage Dialog-Frame
ON LEAVE OF ToLanguage IN FRAME Dialog-Frame /* To (Target) */
DO:
   if ToLanguage:screen-value <> "" and
     ToLanguage:screen-value = FromLanguage:screen-value then do:
       ThisMessage = 'The "To/From" languages must be different.'. 
       run adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).    
        
       ToLanguage:auto-zap = true.
       apply "entry":u to ToLanguage.
       return no-apply.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
  assign
    GlossaryLabel:screen-value = "Glossary"
    LanguageLabel:screen-value = "Languages"
    CopyLabel:screen-value     = "Copy From Database"
    
    GlossaryLabel:width        = font-table:get-text-width-chars(GlossaryLabel:screen-value,4)
    LanguageLabel:width        = font-table:get-text-width-chars(LanguageLabel:screen-value,4)
    CopyLabel:width            = font-table:get-text-width-chars(CopyLabel:screen-value,4).
    

  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus GlossaryName.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildDBList Dialog-Frame 
PROCEDURE BuildDBList :
do with frame {&frame-name}: 
  CopyFromDB = "". 
  do i = 1 to num-dbs:  
   if ldbname(i) <> ProjectDB then
    CopyFromDB = if CopyFromDB = "" then ldbname(i)
                 else CopyFromDB + ",":u + ldbname(i).
  end.
  
  if CopyFromDB = "" or CopyFromDB = ? then assign
    CopyFromDB:list-items   = "None":u
    CopyFromDB:screen-value = "None":u
    CopyFromDB:sensitive    = false
    CopyGlossary:sensitive  = false.
  else assign
    CopyFromDB:list-items   = CopyFromDB
    CopyFromDB:screen-value = CopyFromDB:entry(1)
    CopyFromDB:sensitive    = true
    CopyGlossary:sensitive  = true.
    
  apply "value-changed":u to CopyFromDB.
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopyGlossary Dialog-Frame 
PROCEDURE CopyGlossary :
do with frame {&frame-name}: 
    frame {&frame-name}:hidden = true.
    define var TempStr as char no-undo.
    run adecomm/_tmpfile.p ("t2":u, ".tmp":u, OUTPUT TempFile). 
    output to value(TempFile).     
    TempStr = CopyFromDB + '.XL_GlossDet':U.     
   
    PUT UNFORMATTED
      'DEFINE INPUT PARAMETER ThisGlossary     AS CHARACTER NO-UNDO.':U SKIP 
      'DEFINE INPUT PARAMETER CopyFromDB       AS CHARACTER NO-UNDO.':U SKIP 
      'DEFINE INPUT PARAMETER CopyFromGlossary AS CHARACTER NO-UNDO.':U SKIP
      'DEFINE SHARED VARIABLE hMeter           AS HANDLE    NO-UNDO.':U SKIP 
      'DEFINE SHARED VARIABLE StopProcessing   AS LOGICAL   NO-UNDO.':U SKIP
      'DEFINE VARIABLE        NumEntries       AS INTEGER   NO-UNDO.':U SKIP
      'DEFINE VARIABLE        ThisString       AS CHARACTER NO-UNDO.':U SKIP
      'DEFINE VARIABLE        ThisEntry        AS INTEGER   NO-UNDO.':U SKIP (1)
      
      'FIND ':U + CopyFromDB + '.XL_Glossary WHERE':U SKIP
      '   ':U + CopyFromDB + '.XL_Glossary.GlossaryName = CopyFromGlossary NO-ERROR.':U SKIP
      'IF AVAILABLE ':U + CopyFromDB + '.XL_Glossary THEN DO:':U SKIP 
      '  NumEntries = ':U + CopyFromDB + '.XL_Glossary.GlossaryCount.':U SKIP
      'END.':U SKIP
      'ELSE DO:':U SKIP
      '  RETURN.':U SKIP
      'END.':U SKIP(1)  
      
      'RUN Realize IN hMeter ("Copying Glossary...").':U SKIP          
      'FOR EACH ':U + TempStr + ' WHERE':U SKIP
      '    ':U + TempStr + '.GlossaryName = "':U CopyFromGlossary:screen-value + '" NO-LOCK:':U SKIP
      '   PROCESS EVENTS.':U SKIP
      '   IF StopProcessing THEN DO:':U SKIP
      '     RUN HideMe IN hMeter.':U SKIP
      '     RETURN.':U SKIP
      '   END.':U SKIP(1)
  
      '   ThisEntry = ThisEntry + 1.':U                                SKIP    
      '   ThisString = XL_GlossDet.SourcePhrase.':U                    SKIP
      '   RUN SetBar IN hMeter (NumEntries, ThisEntry, ThisString).':U SKIP 
      '   FIND xlatedb.XL_GlossDet WHERE':U                SKIP                                             
      '     xlatedb.XL_GlossDet.GlossaryName = ThisGlossary AND':U                       SKIP
      '     xlatedb.XL_GlossDet.ShortSrc     BEGINS ' + TempStr + '.ShortSrc AND':U      SKIP
      '     xlatedb.XL_GlossDet.ShortTarg    BEGINS ' + TempStr + '.ShortTarg AND':U     SKIP
      '     xlatedb.XL_GlossDet.SourcePhrase MATCHES ' + TempStr + '.SourcePhrase AND':U SKIP
      '     xlatedb.XL_GlossDet.TargetPhrase MATCHES ' + TempStr +
                                                             '.TargetPhrase NO-ERROR.':U SKIP
      '   IF NOT AVAILABLE xlatedb.XL_GlossDet THEN DO:':U SKIP
      '     CREATE xlatedb.XL_GlossDet.':U                 SKIP              
      '     ASSIGN':U                                      SKIP   
      '       xlatedb.XL_GlossDet.GlossaryName         = ThisGlossary':U SKIP
      '       xlatedb.XL_GlossDet.GlossaryType         = "D"':U          SKIP
      '       xlatedb.XL_GlossDet.ModifiedByTranslator = FALSE':U        SKIP
      '       xlatedb.XL_GlossDet.SourcePhrase         = ':U + TempStr + '.SourcePhrase':U SKIP
      '       xlatedb.XL_GlossDet.TargetPhrase         = ':U + TempStr + '.TargetPhrase':U SKIP 
      '       xlatedb.XL_GlossDet.ShortSrc             = ':U + TempStr + '.ShortSrc':U     SKIP
      '       xlatedb.XL_GlossDet.ShortTarg            = ':U + TempStr + '.ShortTarg .':U  SKIP 
      '   END.':U                SKIP
      'END.':U                   SKIP
      'RUN HideMe IN hMeter.':U  SKIP (1).

    put unformatted
    'PROCEDURE ADEPersistent:':U SKIP
    '  RETURN "OK".':U SKIP
    'END.':U SKIP (1).

    output close. 

    run value(TempFile) (input s_Glossary,
                         input CopyFromDB,
                         input CopyFromGlossary:screen-value) .  
    os-delete value(TempFile) no-error.   
  end.  /* Do WITH FRAME MainFrame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadGlossary Dialog-Frame 
PROCEDURE LoadGlossary :
def input parameter pFileName as char.
  def output parameter pTransactions as int.
  def output parameter pErrorStatus as logical.

  define var i            AS INTEGER   NO-UNDO.
  DEFINE VAR isDanish     AS LOGICAL   NO-UNDO.  
  define var TotRecs      AS INTEGER   NO-UNDO.
  define var TakeRecs     AS INTEGER   NO-UNDO.
  define var DifRecs      AS INTEGER   NO-UNDO.
  define var Dummy        AS CHARACTER NO-UNDO.  
  define var Dmy2         AS CHARACTER NO-UNDO.  
  define var src          AS CHARACTER NO-UNDO.
  define var targ         AS CHARACTER NO-UNDO.  
  define var Result       AS LOGICAL   NO-UNDO.
  define var FileSize     AS INTEGER   NO-UNDO.    
  define var GlosFileName AS CHARACTER NO-UNDO.
  define var TestCP       AS CHARACTER NO-UNDO.

  ASSIGN GlosFileName = trim(pFileName)
         isDanish     = GlosFileName MATCHES "*DANISH*":U.

  /*
  ** Check to see if the import file has any codepage conversion that will work.
  ** if it fails, ask whether or not we should continue without a conversion.
  */
  run adetran/common/_convert.p (session:charset, CodePage, output ErrorStatus).
  if not ErrorStatus then do:
    ThisMessage = "Continue adding the Microsoft glossary without a codepage conversion?".
    run adecomm/_s-alert.p (input-output Result, "q*":u, "yes-no":u, ThisMessage). 
    if Result then 
      input stream GlosStream from value(GlosFileName).
    else
      return.
  end. 
  else do:
    input stream GlosStream from value(GlosFileName)
           convert source CodePage target session:charset.
  end. 
    
  /* the code page exists  */
  run Realize in hMeter ("Loading " + replace(pFileName,"/":u,"\":u) + "...":u).            
  run adecomm/_setcurs.p ("":U).

  /* Open the file to see how big it is  */  
  seek stream GlosStream to end.
  assign FileSize = seek(GlosStream)
         Result   = yes.

  /* Back the file pointer to the beginning of the file  */
  seek stream GlosStream to 0.
  if not Result or Result = ? then do:
    input stream GlosStream close.
    return.
  end.    

  repeat:      
    process events.
    if StopProcessing then do:
      run HideMe in hMeter.
      return.
    end.

    TotRecs = TotRecs + 1.
    IF NOT isDanish THEN import stream GlosStream delimiter ",":u src dummy targ. 
    ELSE                 import stream GlosStream delimiter ",":u src dummy dmy2 targ. 
    run SetBar in hMeter (FileSize, seek(GlosStream), trim(src)). 

    find xlatedb.XL_GlossDet where 
             xlatedb.XL_GlossDet.GlossaryName = s_Glossary and
             xlatedb.XL_GlossDet.ShortSrc     BEGINS substr(src,1, 63,"RAW":u) and
             xlatedb.XL_GlossDet.ShortTarg    BEGINS substr(targ,1, 63,"RAW":u) and
             xlatedb.XL_GlossDet.SourcePhrase MATCHES src and
             xlatedb.XL_GlossDet.TargetPhrase MATCHES targ  
           no-lock NO-ERROR.   
    
    if not available xlatedb.XL_GlossDet then do:
      create xlatedb.XL_GlossDet.
      assign TakeRecs                                 = TakeRecs + 1  
             xlatedb.XL_GlossDet.GlossaryName         = s_Glossary
             xlatedb.XL_GlossDet.ShortSrc             = SUBSTRING(src, 1, 63, "RAW":U)
             xlatedb.XL_GlossDet.ShortTarg            = SUBSTRING(targ, 1, 63, "RAW":U)
             xlatedb.XL_GlossDet.SourcePhrase         = src
             xlatedb.XL_GlossDet.TargetPhrase         = targ
             xlatedb.XL_GlossDet.GlossaryType         = "D":u
             xlatedb.XL_GlossDet.ModifiedByTranslator = false.
    end.
  end.
  input stream GlosStream close.
  run HideMe in hMeter.


  DifRecs = TotRecs - TakeRecs.
  ThisMessage = string(TotRecs) + " glossary records were read; " + string(DifRecs) + " records were " + " duplicates and were rejected.".
  run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    

  ASSIGN pTransactions = TakeRecs
         pErrorStatus  = false.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame 
PROCEDURE Realize :
frame {&frame-name}:hidden = true.    
  enable 
    GlossaryName    
    ReplaceIfExists
    FromLanguage
    ToLanguage
    TechGlossary 
    CopyFromDB
    BtnConnect
    CopyFromGlossary
    CopyGlossary
    BtnOK
    BtnCancel
    BtnHelp   
    BtnOptions
  with frame dialog-frame.
    
  assign 
    Rect3:hidden                 = true
    CopyLabel:hidden             = true
    CopyFromDB:hidden            = true
    BtnConnect:hidden            = true
    CopyFromGlossary:hidden      = true
    CopyGlossary:hidden          = true
    frame {&frame-name}:height   = 9.   
    
  run BuildDBList.  
  frame {&frame-name}:hidden = false.                                            
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
