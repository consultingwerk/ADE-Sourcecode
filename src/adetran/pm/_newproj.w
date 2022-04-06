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

Procedure:    adetran/pm/_newproj.w
Author:       R. Ryan/G. Seidl
Created:      1/95
Updated:      9/95
                11/96 SLK OPSYS MS-DOS
                        Long filenames (file & db)
Purpose:      Dialog which allows the user to create a project database.

Background:   When a new project database is created, only the
              XL_Project database is populated.  This table has only
              one record, and that record identifies the project, the
              description, when it was created, when it was updated,
              where the root directory is, and so forth.  This project
              database is never identified by name, but instead by
              the alias, 'xlatedb'.  Built-in database triggers update
              the xlatedb.XL_Project.LastUpdate field whenever any
              database activity occurs that involves an update, addition,
              or deletion.  A shared variable, ProjectDB, identifies this
              database.

Called By:    pm/_pmprocs.w
Calls:        common/_dbmgmt.p (creates the project database)
              pm/_alias.p (connects to the database and sets the alias)
              pm/_putproj.p (populates the XL_Project table/record)


*/


define output parameter pOKPressed   as logical no-undo.
define output parameter pErrorStatus as logical no-undo.

{ adetran/pm/tranhelp.i } /* definitions for help context strings */
define shared var ProjectDB  as char   no-undo.
define shared var GlossaryDB as char   no-undo.
define shared var KitDB      as char   no-undo.
define shared var _hMain     as handle no-undo.

define var OKPressed   as logical no-undo.
define var Result      as logical no-undo.
define var OptionState as logical no-undo init true.
define var i           as integer no-undo.
define var TempKit     as char    no-undo.
define var ThisMessage as char    no-undo.
define var ErrorStatus as logical no-undo.
define var ShortHeight as decimal no-undo.
define var FullHeight  as decimal no-undo.

&IF LOOKUP("{&OPSYS}","MSDOS,WIN32":U) > 0 &THEN
    &SCOPED-DEFINE SLASH ~~~\
&ELSE
    &SCOPED-DEFINE SLASH /
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS ContainerRectangle1 BtnOK DatabaseName ~
BtnCancel Comments BtnHelp BtnImage ProjectRevision BtnOptions RepDB ~
ProjectDir SourceDir CopyFromDB BtnFile2 Rect2 Priv1 Priv2 ~
ProjLabel DescLabel ProjDirLbl CopyFromLabel PrivLabel
&Scoped-Define DISPLAYED-OBJECTS DatabaseName Comments ProjectRevision ~
RepDB ProjectDir SourceDir CopyFromDB Priv1 Priv2 ProjLabel DescLabel ~
ProjDirLbl CopyFromLabel PrivLabel

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY DEFAULT
     LABEL "Cancel"
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnFile2
     LABEL "&Files...":L
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnHelp
     LABEL "&Help"
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOK AUTO-GO DEFAULT
     LABEL "OK":L
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnOptions
     LABEL "&Options >>":L
     SIZE 15 BY 1.12.

DEFINE VARIABLE SourceDir AS CHARACTER FORMAT "X(63)":U
     LABEL "&Source Code"
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "",""
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE Comments AS CHARACTER
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 52 BY 1.54 NO-UNDO.

DEFINE VARIABLE CopyFromDB AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN NATIVE
     SIZE 41 BY 1 NO-UNDO.

DEFINE VARIABLE CopyFromLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Copy From Project"
      VIEW-AS TEXT
     SIZE 19 BY .65 NO-UNDO.

DEFINE VARIABLE DatabaseName AS CHARACTER FORMAT "X(256)":U
     LABEL "&Name"
     VIEW-AS FILL-IN NATIVE
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE DescLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Description:"
      VIEW-AS TEXT
     SIZE 11 BY .62 NO-UNDO.

DEFINE VARIABLE PrivLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Translator Privileges"
      VIEW-AS TEXT
     SIZE 21 BY .65 NO-UNDO.

DEFINE VARIABLE ProjDirLbl AS CHARACTER FORMAT "X(256)":U INITIAL "Directories"
      VIEW-AS TEXT
     SIZE 12 BY .65 NO-UNDO.

DEFINE VARIABLE ProjectDir AS CHARACTER FORMAT "X(63)":U
     LABEL "&Project"
     VIEW-AS FILL-IN
     SIZE 52 BY 1 NO-UNDO.

DEFINE VARIABLE ProjectRevision AS CHARACTER FORMAT "X(4)":U INITIAL "1.0"
     LABEL "&Revision"
     VIEW-AS FILL-IN NATIVE
     SIZE 6 BY .96 NO-UNDO.

DEFINE VARIABLE ProjLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Project Database"
      VIEW-AS TEXT
     SIZE 16.57 BY .65 NO-UNDO.

DEFINE IMAGE BtnImage
     FILENAME "adetran\images\vert-inc":U
     SIZE 3 BY 1.42.

DEFINE RECTANGLE ContainerRectangle1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 76 BY 6.

DEFINE RECTANGLE Rect1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 76 BY 1.96.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 76 BY 2.12.

DEFINE RECTANGLE r_projdir
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 76 BY 2.92.

DEFINE VARIABLE Priv1 AS LOGICAL INITIAL no
     LABEL "Must Use &Glossary For Translations"
     VIEW-AS TOGGLE-BOX
     SIZE 44.14 BY .65 NO-UNDO.

DEFINE VARIABLE Priv2 AS LOGICAL INITIAL yes
     LABEL "Can &Modify Default Glossary Entries"
     VIEW-AS TOGGLE-BOX
     SIZE 44.14 BY .65 NO-UNDO.

DEFINE VARIABLE RepDB AS LOGICAL INITIAL yes
     LABEL "Replace If &Exists"
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.77 COL 80
     DatabaseName AT ROW 2.04 COL 18 COLON-ALIGNED
     BtnCancel AT ROW 3.12 COL 80
     Comments AT ROW 3.19 COL 20 NO-LABEL
     BtnHelp AT ROW 4.35 COL 80
     ProjectRevision AT ROW 5.04 COL 18 COLON-ALIGNED
     BtnOptions AT ROW 5.65 COL 80
     RepDB AT ROW 6.46 COL 20
     ProjectDir AT ROW 8.42 COL 18 COLON-ALIGNED
     SourceDir AT ROW 9.65 COL 18 COLON-ALIGNED
     CopyFromDB AT ROW 11.85 COL 18 COLON-ALIGNED NO-LABEL
     BtnFile2 AT ROW 11.96 COL 62
     Priv1 AT ROW 14.35 COL 20
     Priv2 AT ROW 15.04 COL 20
     ProjLabel AT ROW 1.35 COL 3 NO-LABEL
     DescLabel AT ROW 3.38 COL 6 COLON-ALIGNED NO-LABEL
     ProjDirLbl AT ROW 7.65 COL 1 COLON-ALIGNED NO-LABEL
     CopyFromLabel AT ROW 11.12 COL 3 NO-LABEL
     PrivLabel AT ROW 13.62 COL 4 NO-LABEL
     ContainerRectangle1 AT ROW 1.69 COL 2
     BtnImage AT ROW 4.81 COL 26
     r_projdir AT ROW 8 COL 2
     Rect1 AT ROW 11.35 COL 2
     Rect2 AT ROW 13.85 COL 2
     SPACE(17.79) SKIP(0.16)
    WITH VIEW-AS DIALOG-BOX
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE
         FONT 4
         TITLE "New Project"
         DEFAULT-BUTTON BtnOK.



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   L-To-R                                                               */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN CopyFromLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN PrivLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ProjLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR COMBO-BOX SourceDir IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME






/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON ALT-D OF FRAME Dialog-Frame /* New Project */
DO:
  APPLY "ENTRY":U TO Comments IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* New Project */
DO:
  run adecomm/_setcurs.p ("wait":u).

  define var ToDBName    as char no-undo.
  define var FromDBName  as char no-undo.
  define var ProjectRev  as char no-undo.
  define var Comms       as char no-undo.
  define var DispType    as char no-undo.
  define var ReplaceDB   as logical no-undo.
  define var ErrorStatus as logical no-undo.
  define var DirName     as char no-undo.
  define var BaseName    as char no-undo.
  define var ExtName     as char no-undo.

  assign DatabaseName:screen-value = trim(DatabaseName:screen-value)
         ProjectDir:screen-value   = trim(ProjectDir:screen-value)
         . /* end assign */
  /*
  ** Test to see if a database name was entered.
  */
  if DatabaseName:screen-value = "" then do:
    ThisMessage = "You must enter a project database name.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
    apply "entry" to DatabaseName in frame {&frame-name}.
    return no-apply.
  end.

  /* Is it a valid database name. */
  /* Modified for long filenames  */
  run adecomm/_osprefx.p (DatabaseName:screen-value, output DirName, output BaseName).
  if length(BaseName,"RAW":u) > 255 then do:
      ThisMessage = DatabaseName:screen-value + "^Project database name is not a valid.".
      run adecomm/_s-alert.p (input-output ErrorStatus, "w":U,"ok":u, ThisMessage).
      apply "entry":u to DatabaseName in frame Dialog-frame.
      return no-apply.
  end.

  /*
  ** Check to see if we should overwrite this db if it already exists.
  */
  if search(DatabaseName:screen-value) <> ? and NOT RepDB:checked then do:
    ThisMessage = DatabaseName:screen-value + '^Exists. Try changing the name or specify "Replace If Exists".'.
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
    return no-apply.
  end.

  /*
  ** Test to see if a Project Directory name was entered, that its valid, etc.
  */
  run ProjectDir-Validate.
  if return-value = "no-apply":u then return no-apply.

  /*
  ** What about the CopyFrom database? It has to exist - but does it?
  */
  if CopyFromDB:screen-value <> ? and
     CopyFromDB:screen-value <> "" and
     search(CopyFromDB:screen-value) = ? then do:
    ThisMessage = CopyFromDB:screen-value +
                  "^Copy From database does not exist or cannot be located.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
    apply "entry":u to CopyFromDB.
    return no-apply.
  end.

  /*
  ** All the checks passed, so let's set the variables.
  ** Take into account long filenames, UNC, CONNECT and db name limitations
  **    leave filenames in the char case entered, do not caps or lc
  */
  assign
    ProjectDir          = ProjectDir:screen-value
    file-info:file-name = ProjectDir
    ProjectDir          = file-info:full-pathname
    SourceDir           = SourceDir:screen-value
    ToDBName            = entry(1,DatabaseName:screen-value,".":u)

    FromDBName          = if CopyFromDB:screen-value <> "" then
                            CopyFromDB:screen-value
                          else
                            "adetran/data/xlproj.db":u
    file-info:file-name = FromDBName
    FromDBName          = file-info:full-pathname
    ProjectRev          = ProjectRevision:screen-value
    Comms               = Comments:screen-value
    ReplaceDB           = RepDB:checked.

  IF CONNECTED(ToDBName) THEN
    RUN RemoveDBRef (ToDBName).

  /*
  ** Create a new project database
  */
  run adetran/common/_dbmgmt.p (
    input "CREATE":u,
    input ProjectDir + "{&SLASH}" + ToDBName,
    input "xlatedb":U,
    input FromDBName,
    input ReplaceDB,
    output ErrorStatus).

  if ErrorStatus then do:
    apply "entry":u to DatabaseName in frame {&frame-name}.
    return no-apply.
  end.

  assign ProjectDB = ProjectDir + "{&SLASH}" + ToDBName.
  run adetran/common/_alias.p (output ErrorStatus).
  if ErrorStatus then do:
    apply "entry":u to DatabaseName in frame {&frame-name}.
    return no-apply.
  end.

  /*
  ** OK, the database should be created at this point. Time to
  ** update the database
  */
  assign
    ProjectDB           = ToDBName
    file-info:file-name = "adetran/data/xlkit.db":u
    TempKit             = file-info:full-pathname.

  run adetran/pm/_putproj.p (
    input ToDBName,
    input Comms,
    input ProjectRev,
    input ProjectDir,
    input SourceDir,
    input "G":u, /* G=Graphical default */
    input Priv1:checked,
    input Priv2:checked,
    output ErrorStatus).

  /*
  ** Final assigns
  */
  assign
    pOKPressed   = true
    pErrorStatus = ErrorStatus.

  run adecomm/_setcurs.p ("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* New Project */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile2 Dialog-Frame
ON CHOOSE OF BtnFile2 IN FRAME Dialog-Frame /* Files... */
DO:
  DEFINE VARIABLE DBFileName AS CHARACTER NO-UNDO.
  define var OKPressed as logical no-undo.

  SYSTEM-DIALOG GET-FILE DBFileName
     TITLE      "Copy From"
     FILTERS    "Database Files (*.db)" "*.db":u,
                "All Files (*.*)"       "*.*":u
     MUST-EXIST
     USE-FILENAME
     UPDATE OKpressed.

  IF OKpressed = TRUE THEN
    CopyFromDB:screen-value = DBFileName.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("TRAN":U, "CONTEXT":U, {&New_Proj_DB}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnImage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnImage Dialog-Frame
ON MOUSE-SELECT-CLICK OF BtnImage IN FRAME Dialog-Frame
DO:
  def var Rev as decimal.
  def var HalfWay as int.

  assign
    HalfWay = BtnImage:y + (BtnImage:height-p / 2)
    Rev     = decimal(ProjectRevision:screen-value).

  if last-event:y > HalfWay then do:
    Result = BtnImage:load-image("adetran/images/vert-dn2":u).
    Rev = Rev - .1.
    if Rev < 1 then Rev = 1.
  end.
  else do:
    Result = BtnImage:load-image("adetran/images/vert-dn1":u).
    Rev = Rev + .1.
  end.

  if Rev < 10 then
    ProjectRevision:screen-value = string(Rev,"9.9":u).
  else
    ProjectRevision:screen-value = string(Rev,"99.9":u).

  /*
  ** Waste some time for a second
  */
  do i = 1 to 50:
  end.
  Result = BtnImage:load-image("adetran/images/vert-inc":u).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions Dialog-Frame
ON CHOOSE OF BtnOptions IN FRAME Dialog-Frame /* Options >> */
do:
 if OptionState then do:
   frame {&frame-name}:height = FullHeight.

   assign
     Rect1:hidden                 = false
     Rect2:hidden                 = false
     CopyFromDB:hidden            = false
     BtnFile2:hidden              = false
     Priv1:hidden                 = false
     Priv2:hidden                 = false
     OptionState                  = false
     CopyFromLabel:hidden         = false
     PrivLabel:hidden             = false
     BtnOptions:label             = ">> &Options".

   apply "entry":u to CopyFromDB.
 end.
 else do:
   assign
     Rect1:hidden                 = true
     Rect2:hidden                 = true
     CopyFromDB:hidden            = true
     BtnFile2:hidden              = true
     Priv1:hidden                 = true
     Priv2:hidden                 = true
     OptionState                  = true
     CopyFromLabel:hidden         = true
     PrivLabel:hidden             = true
     BtnOptions:label             = "&Options >>"
     frame {&frame-name}:height   = ShortHeight.

   apply "entry":u to DatabaseName.
 end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DatabaseName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DatabaseName Dialog-Frame
ON LEAVE OF DatabaseName IN FRAME Dialog-Frame /* Name */
DO:
  define var TestName as char no-undo.
  define var DirName  as char no-undo.
  define var BaseName as char no-undo.
  define var ExtName  as char no-undo.

  assign DatabaseName:screen-value = trim(DatabaseName:screen-value).
  run adecomm/_osprefx.p (DatabaseName:screen-value,output DirName, output BaseName).
  run adecomm/_osfext.p (input BaseName, output ExtName).
  TestName = trim(entry(1,BaseName,".":u)).

  /* Modified for long filename */
  if length(BaseName,"RAW":U) > 255 then do:
    ThisMessage = DatabaseName:screen-value + "^This filename is not valid.".
    run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u,ThisMessage).
    apply "entry":u to DatabaseName in frame Dialog-frame.
    return no-apply.
  end.

  /* It is illegal to have a filename be one of the two reserved keywords
     "Untitled" and "None".                                                 */
  IF CAN-DO("UNTITLED,NONE":U,TestName)
     OR CAN-DO("UNTITLED,NONE":U,BaseName) THEN DO:
    ASSIGN ThisMessage = TestName +
             " is a reserved keyword and may not be used as a Project Name.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus,"e*":U, "ok":U, ThisMessage).
    apply "entry":u to DatabaseName in frame Dialog-frame.
    return no-apply.
  END.
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
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   ASSIGN
     DescLabel:screen-value        = "&Description:"
     DescLabel:width               = font-table:get-text-width-chars (trim(DescLabel:screen-value),4)
     DescLabel:column              = Comments:column - DescLabel:width
     Priv1:screen-value            = string(Priv1)
     Priv2:screen-value            = string(Priv2)
     ProjLabel:screen-value        = "Project Database"
     ProjLabel:width               = font-table:get-text-width-chars(ProjLabel:screen-value,4)
     CopyFromLabel:screen-value    = CopyFromLabel
     CopyFromLabel:width           = font-table:get-text-width-chars(CopyFromLabel:screen-value,4)
     ProjectRevision:screen-value  = "1" + SESSION:NUMERIC-DECIMAL-POINT + "0"
     PrivLabel:screen-value        = PrivLabel
     PrivLabel:width               = font-table:get-text-width-chars(PrivLabel:screen-value,4)
     ProjDirLbl:screen-value       = ProjDirLbl
     ProjDirLbl:width              = font-table:get-text-width-chars(ProjDirLbl:screen-value,4).

  RUN SourceDir-Init.
  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus DatabaseName.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProjectDir-Validate Dialog-Frame
PROCEDURE ProjectDir-Validate :
/*------------------------------------------------------------------------------
  Purpose:     Test to see if a Project Directory name was entered, that its
               valid, and create it if its not there.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define variable createit as logical no-undo initial yes.
  define variable os-rc    as integer no-undo.

  do with frame {&FRAME-NAME}:
    if ProjectDir:screen-value = "" or
       ProjectDir:screen-value = ?  then
    do:
      ThisMessage = "You must enter a project directory.".
      run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
      apply "entry" to ProjectDir in frame {&frame-name}.
      return "no-apply":u.
    end.

    assign file-info:file-name = ProjectDir:screen-value.
    if file-info:full-pathname eq ? then
    do:
      ThisMessage = "Directory " + "'" + ProjectDir:screen-value + "'" + " does not exist." +
                    CHR(10) + "Do you want to create it?".
      message ThisMessage view-as alert-box question button yes-no update createit.
      if createit then
      do:
        RUN adecomm/_oscpath.p (INPUT ProjectDir:SCREEN-VALUE, OUTPUT os-rc).
        if os-rc NE 0 then
        do:
          message "Directory was not created. Operating System error #"
                   + STRING(os-rc) + "."
            view-as alert-box error.
          apply "entry":u to ProjectDir in frame Dialog-frame.
          return "no-apply":u.
        end.
        else assign file-info:file-name     = ProjectDir:screen-value
                    ProjectDir:screen-value = file-info:full-pathname.
      end.
      else
      do:
        apply "entry":u to ProjectDir in frame Dialog-frame.
        return "no-apply":u.
      end.
    end.
    else if index(file-info:file-type, "D") = 0 then
    do:
      ThisMessage = ProjectDir:screen-value + " is not a valid directory name.".
      run adecomm/_s-alert.p (input-output ErrorStatus, "w":u,"ok":u, ThisMessage).
      apply "entry":u to ProjectDir in frame Dialog-frame.
      return "no-apply":u.
    end.
    assign ProjectDir:screen-value = file-info:full-pathname.
  end. /* with frame */
  return.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame
PROCEDURE Realize :
frame {&frame-name}:hidden = true.
  enable
    DatabaseName
    Comments
    ProjectRevision
    RepDB
    ProjectDir
    SourceDir
    CopyFromDB
    BtnImage
    BtnFile2
    Priv1
    Priv2
    BtnOK
    BtnCancel
    BtnHelp
    BtnOptions
  with frame dialog-frame.

  assign FullHeight = frame {&frame-name}:height.

  assign
     Rect1:hidden                 = true
     Rect2:hidden                 = true
     CopyFromDB:hidden            = true
     BtnFile2:hidden              = true
     Priv1:hidden                 = true
     Priv2:hidden                 = true
     OptionState                  = true
     CopyFromLabel:hidden         = true
     PrivLabel:hidden             = true
     BtnOptions:label             = "&Options >>"
     frame {&frame-name}:height   = r_projdir:row + r_projdir:height + 0.6.

  assign frame {&frame-name}:hidden = false.
  assign ShortHeight = frame {&frame-name}:height.

  run adecomm/_setcurs.p ("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RemoveDBRef Dialog-Frame
PROCEDURE RemoveDBRef :
/*------------------------------------------------------------------------------
  Purpose:     Disconnect and clean up if procedures used db.
  Parameters:  db_name
  Notes:
------------------------------------------------------------------------------*/
  /* This procedure disconnects a db and deletes any procedures
   * which are dependent on it. Doing so will allow us to cleanly
   * disconnect the database.
   */
  DEFINE INPUT PARAMETER db_name AS CHARACTER NO-UNDO.

  DEFINE VARIABLE h            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hh           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE dbentry      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE DelThisOne   AS LOGICAL   NO-UNDO.

  ASSIGN h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    ASSIGN DelThisOne = NO.
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).
      IF db_name = dbentry THEN DO: /* this proc's got to go! */
        ASSIGN DelThisOne = YES.
        LEAVE.
      END.
    END.
    ASSIGN hh = h
            h = h:NEXT-SIBLING.
    IF DelThisOne THEN DELETE PROCEDURE hh.
  END.
  DISCONNECT VALUE(db_name) NO-ERROR.
  IF CONNECTED(db_name) THEN MESSAGE "Could not disconnect database " db_name
    VIEW-AS ALERT-BOX ERROR.
  ELSE DELETE ALIAS xlatedb.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SourceDir-Init Dialog-Frame
PROCEDURE SourceDir-Init :
/*------------------------------------------------------------------------------
  Purpose:     Initialize Source Code Directory Combo-box.
  Parameters:  <none>
  Notes:       Changes dot (.) entry to full-pathname.
------------------------------------------------------------------------------*/
  define var temp-propath as char no-undo.
  define var path-entry   as int  no-undo.

  do with frame {&frame-name}:
    /* Make temp-propath contain PROPATH but with the expanded name of each
       PROPATH directory.
    */
    do path-entry = 1 to num-entries(propath):
      assign file-info:file-name = maximum(".":u , entry(path-entry, propath)).
      assign temp-propath        = temp-propath + "," + file-info:full-pathname
        when file-info:full-pathname <> ?.
    end.

    /* Take off the leading and trailing commas. */
    assign temp-propath = trim(temp-propath, ",").

    /* Initialize to first PROPATH entry. */
    assign SourceDir              = entry(1, temp-propath)
           SourceDir:list-items   = temp-propath
           SourceDir:screen-value = SourceDir.

  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

