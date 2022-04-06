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
DEFINE SHARED VARIABLE _hMeter          AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE StopProcessing   AS LOGICAL                  NO-UNDO.
DEFINE SHARED VARIABLE s_Glossary       AS CHARACTER                NO-UNDO.
DEFINE SHARED VARIABLE _hTrans          AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE _hGloss          AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE _hMain           AS HANDLE                   NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode      AS INTEGER                  NO-UNDO.

DEFINE        VARIABLE OptionState      AS LOGICAL    INITIAL TRUE  NO-UNDO.
DEFINE        VARIABLE ThisMessage      AS CHARACTER                NO-UNDO.
DEFINE        VARIABLE ErrorStatus      AS LOGICAL                  NO-UNDO.
DEFINE        VARIABLE KitList          AS CHARACTER                NO-UNDO.
DEFINE        VARIABLE GlossaryList     AS CHARACTER                NO-UNDO.
DEFINE        VARIABLE i                AS INTEGER                  NO-UNDO.
DEFINE        VARIABLE TempFile         AS CHARACTER                NO-UNDO.

DEFINE STREAM ThisStream.
DEFINE        VARIABLE RecsRead         AS INTEGER.
DEFINE        VARIABLE Result           AS LOGICAL.
DEFINE        VARIABLE FileSize         AS INTEGER.
DEFINE        VARIABLE NumGLossRecs     LIKE RecsRead.
DEFINE        VARIABLE NumTransRecs     LIKE RecsRead.

DEFINE        VARIABLE fullHeight       AS INTEGER                  NO-UNDO.
DEFINE        VARIABLE shortHeight      AS INTEGER                  NO-UNDO.

DEFINE VARIABLE headerCodePage      AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE headerLanguageName  AS CHARACTER                        NO-UNDO. 
DEFINE VARIABLE headerProjectName   AS CHARACTER                        NO-UNDO. 
DEFINE VARIABLE headerProjectDesc   AS CHARACTER                        NO-UNDO. 

DEFINE VARIABLE dataSequence_Num    LIKE xlatedb.XL_Instance.Sequence_Num  NO-UNDO.
DEFINE VARIABLE dataInstance_Num    LIKE xlatedb.XL_Instance.Instance_Num  NO-UNDO.
DEFINE VARIABLE dataOriginal_String LIKE xlatedb.XL_String_Info.Original_String NO-UNDO.
DEFINE VARIABLE dataTranslation     LIKE xlatedb.XL_Translation.Trans_String NO-UNDO.
DEFINE VARIABLE dataNum_Occurs      LIKE xlatedb.XL_Instance.Num_Occurs    NO-UNDO.
DEFINE VARIABLE dataLine_Num        LIKE xlatedb.XL_Instance.Line_Num      NO-UNDO.
DEFINE VARIABLE dataJustification   AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE dataMaxLength       LIKE xlatedb.XL_Instance.MaxLength     NO-UNDO.
DEFINE VARIABLE dataObjectName      LIKE xlatedb.XL_Instance.ObjectName    NO-UNDO.
DEFINE VARIABLE dataStatement       LIKE xlatedb.XL_Instance.Statement     NO-UNDO.
DEFINE VARIABLE dataItem            LIKE xlatedb.XL_Instance.Item          NO-UNDO.
DEFINE VARIABLE dataComment         LIKE xlatedb.XL_String_Info.Comment    NO-UNDO.

DEFINE VARIABLE RejectTransNew      AS INTEGER                             NO-UNDO.
DEFINE VARIABLE CreateTransNew      AS INTEGER                             NO-UNDO.
DEFINE VARIABLE UpdateTrans         AS INTEGER                             NO-UNDO.
DEFINE VARIABLE DeleteTrans         AS INTEGER                             NO-UNDO.
DEFINE VARIABLE CreateGlossNew      AS INTEGER                             NO-UNDO.
DEFINE VARIABLE ProjString          AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE TransString         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE srcString           AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE TimeDateStamp       AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE ResolveType         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE OKPressed           AS LOGICAL                             NO-UNDO.

DEFINE VARIABLE cShortSrc           AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE cShortTarg          AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE NumGloss            AS INTEGER                             NO-UNDO.
DEFINE VARIABLE validUpdate         AS LOGICAL                             NO-UNDO.
DEFINE VARIABLE cTemp               AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE cTemp2              AS CHARACTER                           NO-UNDO.
{adetran/pm/tranhelp.i}
{adetran/pm/ldtranu.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK BtnCancel FileName BtnFile BtnHelp ~
BtnOptions GlossaryName UpdateGlossary ReconcileType Delim FromLabel ~
FileNameLabel GlossaryLabel ReconcileLabel OptionsLabel DelimLabel Rect-4 ~
Rect1 Rect2 Rect3 
&Scoped-Define DISPLAYED-OBJECTS FileName GlossaryName UpdateGlossary ~
ReconcileType Delim FromLabel FileNameLabel GlossaryLabel ReconcileLabel ~
OptionsLabel DelimLabel 

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
     SIZE 13 BY 1.19.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOptions 
     LABEL "&Options >>" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE GlossaryName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE DelimLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Delimiter:" 
      VIEW-AS TEXT 
     SIZE 22.2 BY .67 NO-UNDO.

DEFINE VARIABLE FileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE FileNameLabel AS CHARACTER FORMAT "X(256)":U INITIAL "File Name:" 
      VIEW-AS TEXT 
     SIZE 35.4 BY .67 NO-UNDO.

DEFINE VARIABLE FromLabel AS CHARACTER FORMAT "X(256)":U INITIAL "From" 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE GlossaryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Glossary" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Options" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE ReconcileLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Reconciliation" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE Delim AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Space &Delimited", "B":U,
"&Comma Delimited", "C":U
     SIZE 53 BY 1.62 NO-UNDO.

DEFINE VARIABLE ReconcileType AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Always Keep &Newer Translations", 1,
"Always Keep &Older Translations", 2,
"&Ask About Each Conflict", 3
     SIZE 52 BY 2.62 NO-UNDO.

DEFINE RECTANGLE Rect-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 3.52.

DEFINE RECTANGLE Rect1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 3.05.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 3.1.

DEFINE RECTANGLE Rect3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 3.29.

DEFINE VARIABLE UpdateGlossary AS LOGICAL INITIAL yes 
     LABEL "&Update Glossary" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     BtnOK AT ROW 1.48 COL 65
     BtnCancel AT ROW 2.71 COL 65
     FileName AT ROW 2.91 COL 7 NO-LABEL
     BtnFile AT ROW 2.91 COL 48
     BtnHelp AT ROW 3.95 COL 65
     BtnOptions AT ROW 5.14 COL 65
     GlossaryName AT ROW 5.76 COL 7 NO-LABEL
     UpdateGlossary AT ROW 6.95 COL 7
     ReconcileType AT ROW 9.33 COL 7 NO-LABEL
     Delim AT ROW 14.1 COL 7 NO-LABEL
     FromLabel AT ROW 1.24 COL 5 NO-LABEL
     FileNameLabel AT ROW 2.19 COL 7 NO-LABEL
     GlossaryLabel AT ROW 4.81 COL 5 NO-LABEL
     ReconcileLabel AT ROW 8.38 COL 5 NO-LABEL
     OptionsLabel AT ROW 12.43 COL 5 NO-LABEL
     DelimLabel AT ROW 13.38 COL 7 NO-LABEL
     Rect-4 AT ROW 8.67 COL 3
     Rect1 AT ROW 5.05 COL 3
     Rect2 AT ROW 1.48 COL 3
     Rect3 AT ROW 12.71 COL 3
     SPACE(18.99) SKIP(0.66)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Import":L
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

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
/* SETTINGS FOR FILL-IN ReconcileLabel IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile DIALOG-1
ON CHOOSE OF BtnFile IN FRAME DIALOG-1 /* Files... */
DO:
  DEFINE VARIABLE ImportFile AS character NO-UNDO.
  DEFINE VARIABLE OKPressed AS LOGICAL NO-UNDO.

  SYSTEM-DIALOG get-file ImportFile
     title      "Import File"
     filters    "Comma-Delimited (*.csv)":u   "*.csv":u,
                "ASCII Text (*.txt)":u        "*.txt":u, 
                "All Files (*.*)":u           "*.*":u
     use-filename
     UPDATE okpressed.      

  IF okpressed = TRUE THEN
  DO:
    FileName:SCREEN-VALUE = ImportFile. 
    APPLY "LEAVE":u TO FileName.
  END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("TRAN":U, "CONTEXT":U, {&Import_Data_Dialog_Box}, ?).      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:      

  DEFINE VARIABLE NewDataSequence_Num AS INTEGER NO-UNDO.
  DEFINE VARIABLE NewDataInstance_Num AS INTEGER NO-UNDO.
  DEFINE VARIABLE ColumnLabels        AS CHARACTER EXTENT 12 FORMAT "X(80)" NO-UNDO.
  
  IF FileName:SCREEN-VALUE = "" THEN
  DO: 
    ThisMessage = "You must enter a file name first.".    
    RUN adecomm/_s-alert.p (input-OUTPUT ErrorStatus, "w*":u, "ok":u, ThisMessage).    
    FileName:auto-zap = TRUE.   
    APPLY "ENTRY":U TO FileName.
    RETURN NO-APPLY.
  END.

  FILE-INFO:FILE-NAME = FileName:SCREEN-VALUE.
  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    ThisMessage = FileName:SCREEN-VALUE +
       "^Cannot FIND this file. Please verify that the path name and file name are correct.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
    FileName:AUTO-ZAP = TRUE.
    RETURN NO-APPLY.
  END.
                          
  /* Look at the 1st line of the file. It contains:
   *  "<codepage>" "<headerLanguageName>" "<headerProjectName>" "<headerProjectDesc>"
   * Only read the codepage - ignore the rest for now since they may actually contain data
   * that may need to be converted.
   */
  INPUT STREAM ThisStream FROM VALUE(FileName:SCREEN-VALUE).
  REPEAT:
    IF Delim:SCREEN-VALUE = "C":U THEN    
       IMPORT STREAM ThisStream DELIMITER ",":U 
            headerCodePage
            headerLanguageName
            headerProjectName
            headerProjectDesc
       NO-ERROR. 
    ELSE
       IMPORT STREAM ThisStream 
            headerCodePage
            headerLanguageName
            headerProjectName
            headerProjectDesc
       NO-ERROR.
    LEAVE.
  END. /* Repeat - do header only */

  /*
  ** Check to see IF the import file has any codepage conversion that will work.
  ** IF it fails, ask whether or not we should continue without a conversion.
  */
  RUN adetran/common/_convert.p (SESSION:CHARSET, headerCodePage, OUTPUT ErrorStatus).
  IF NOT ErrorStatus THEN
  DO:
    ThisMessage = "Continue import without a codepage conversion?".
    RUN adecomm/_s-alert.p (input-OUTPUT Result, "q*":u, "yes-no":u, ThisMessage). 
    IF Result THEN 
      INPUT STREAM ThisStream FROM VALUE(FileName:SCREEN-VALUE).
    ELSE
      RETURN NO-APPLY.
  END. 
  ELSE 
  DO:
    INPUT STREAM ThisStream FROM VALUE(FileName:SCREEN-VALUE) CONVERT SOURCE headerCodePage TARGET SESSION:CHARSET. 
  END.       
    
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.         
   
  SEEK STREAM ThisStream TO END.
  ASSIGN
    FileSize = SEEK(ThisStream)
    Result   = yes.  
   
  SEEK STREAM ThisStream to 0.
  IF NOT Result OR Result = ? THEN
  DO:
    INPUT STREAM ThisStream CLOSE.
    RETURN.
  END.    
   

  /* Process HEADER */
  repeatHeader:
  REPEAT:
       IF Delim:SCREEN-VALUE = "C":U THEN    
         IMPORT STREAM ThisStream DELIMITER ",":U 
            headerCodePage
            headerLanguageName
            headerProjectName
            headerProjectDesc
         NO-ERROR. 
       ELSE
         IMPORT STREAM ThisStream 
            headerCodePage
            headerLanguageName
            headerProjectName
            headerProjectDesc
         NO-ERROR.

       /* Do a quick check to make sure that we are even looking at the right project.
        * Compare that project name 
        */
       FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
       IF headerProjectName <> xlatedb.XL_Project.ProjectName THEN
       DO:
          ThisMessage = "Project Name in import file does not match this project's name. Continue import?".
          RUN adecomm/_s-alert.p (INPUT-OUTPUT Result, "q*":u, "yes-no":u, ThisMessage). 
          IF NOT Result THEN 
          DO:
             INPUT STREAM ThisStream CLOSE.
             RETURN NO-APPLY.
          END. /* Don't continue */
       END. /* If Project Names do not match */

       /* Do a quick check to make sure that the language still exists */
       FIND FIRST xlatedb.XL_Language WHERE xlatedb.XL_Language.Lang_Name = headerLanguageName NO-LOCK NO-ERROR.
       IF NOT AVAILABLE xlatedb.XL_Language THEN
       DO:
          ThisMessage = "Language: " + headerLanguageName + " no longer exists in the project. Import cancelled".
          RUN adecomm/_s-alert.p (INPUT-OUTPUT Result, "w*":u, "ok":U, ThisMessage). 
          INPUT STREAM ThisStream CLOSE.
          RETURN NO-APPLY.
       END. /* If Language does not exist */

       IF UpdateGlossary THEN
       DO:
          /* Do a quick check to make sure that the glossary chosen for update
           * contains the language as a target language */
          RUN adetran/pm/_getProj.p (OUTPUT cTemp, OUTPUT cTemp2, OUTPUT ErrorStatus).
          RUN adetran/pm/_getLangGloss.p
             (INPUT cTemp,
              INPUT headerLanguageName,
              INPUT "TARGET",
              OUTPUT cTemp2,
              OUTPUT ErrorStatus).
          IF LOOKUP(GlossaryName:SCREEN-VALUE IN FRAME {&FRAME-NAME}, cTemp2) = 0 THEN
          DO:
             FIND xlatedb.XL_Glossary WHERE
                xlatedb.XL_Glossary.GlossaryName = 
                GlossaryName:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             NO-LOCK NO-ERROR.
             ASSIGN
                ThisMessage = SUBSTITUTE("You have chosen to import a file which contains translations in &1, but the glossary you have chosen to update has a target language of &2. Continue import?",
                                          headerLanguageName, ENTRY(2, xlatedb.XL_Glossary.GlossaryType, "/":U)
                                         ).
             RUN adecomm/_s-alert.p (INPUT-OUTPUT Result, "q*":u, "yes-no":u, ThisMessage). 
             IF NOT Result THEN 
             DO:
                INPUT STREAM ThisStream CLOSE.
                RETURN NO-APPLY.
             END. /* Don't continue */
          END. /* Glossary does not contain Language */
       END. /* UpdateGlossary */

       LEAVE repeatHeader.
  END. /* REPEAT */

  /* Process Column Labels */
  IF Delim:SCREEN-VALUE = "C":U THEN    
    IMPORT STREAM ThisStream DELIMITER ",":U 
      ColumnLabels
      NO-ERROR. 
  ELSE
    IMPORT STREAM ThisStream 
      ColumnLabels
      NO-ERROR.

  RUN Realize IN _hMeter("Importing...").

  /* Process BODY */
  ASSIGN RecsRead         = 0
         RejectTransNew   = 0
         CreateTransNew   = 0
         UpdateTrans      = 0
         DeleteTrans      = 0
         CreateGlossNew   = 0.

  repeatBody:
  REPEAT:

    ASSIGN dataSequence_Num      = 0
           dataInstance_Num      = 0
           dataTranslation       = "":U
           dataOriginal_String   = "":U.

    IF Delim:SCREEN-VALUE = "C":U THEN    
      IMPORT STREAM ThisStream DELIMITER ",":U 
         dataSequence_Num    
         dataInstance_Num    
         dataOriginal_String 
         dataTranslation     
         dataNum_Occurs      
         dataLine_Num        
         dataJustification
         dataMaxLength       
         dataObjectName      
         dataStatement       
         dataItem            
         dataComment         
      NO-ERROR. 
    ELSE
      IMPORT STREAM ThisStream 
         dataSequence_Num    
         dataInstance_Num    
         dataOriginal_String 
         dataTranslation     
         dataNum_Occurs      
         dataLine_Num        
         dataJustification
         dataMaxLength       
         dataObjectName      
         dataStatement       
         dataItem            
         dataComment         
      NO-ERROR.

    ASSIGN
       RecsRead = RecsRead + 1
       validUpdate = IF    dataOriginal_String = "":U 
                        OR dataTranslation     = "":U 
                        OR dataOriginal_String = ? 
                        OR dataTranslation     = ? THEN NO ELSE YES. 
    
    /* **********************************************************************
     *                               Update Translations  
     * **********************************************************************/

    {adetran/pm/ldtran.i
        &NumTrans             = FileSize 
        &InTargetPhrase       = dataTranslation
        &InSequenceNumber     = dataSequence_Num
        &InInstanceNumber     = dataInstance_Num
        &InLang_Name          = headerLanguageName
        &InReconcileType      = ReconcileType:SCREEN-VALUE
        &RejectNew            = RejectTransNew
        &CreateNew            = CreateTransNew
        &UpdateOld            = UpdateTrans
        &DeleteOld            = DeleteTrans
        &StopProcessingAction = "LEAVE"
        &ThisRec              = RecsRead 
        &ThisRecSeekStream    = SEEK(ThisStream)
        &Src_String           = dataOriginal_String
        &Original_String      = dataOriginal_String
    }

    IF UpdateGlossary AND validUpdate THEN
    DO:
       /* **********************************************************************
        *                               Update Glossary  
        * **********************************************************************/
       {adetran/pm/ldgloss.i
           &InTargetPhrase       = dataTranslation
           &GlossaryName         = GlossaryName:SCREEN-VALUE
           &CreateNew            = CreateGlossNew
           &Original_String      = dataOriginal_String
       }
    END. /* UpdateGlossary */

  END. /* REPEAT Body */
  
  OUTPUT CLOSE.  
  RUN HideMe in _hMeter.

  /* **********************************************************************
   * Since triggers were eliminated, update the summary records 
   * **********************************************************************/
  IF UpdateGlossary AND validUpdate THEN
  DO: /* Count the glossary items */
     RUN CountEntries IN _hGloss (INPUT GlossaryName:SCREEN-VALUE
                               , OUTPUT NumGloss).
     DO:
        FIND xlatedb.XL_Glossary WHERE 
           xlatedb.XL_Glossary.GlossaryName = GlossaryName:SCREEN-VALUE
        EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE xlatedb.XL_Glossary THEN
           xlatedb.XL_Glossary.GlossaryCount = NumGloss.
     END. /* Transaction */.
  END. /* Updated the glossary */
  
  IF CurrentMode = 2 THEN RUN OpenQuery in _hTrans. 
  RUN SetSensitivity in _hMain.
    
  ThisMessage = string(RecsRead) + " records read;"  + CHR(10)
                + string(CreateTransNew) + " Translation entries added; "   + CHR(10)
                + string(UpdateTrans)    + " Translation entries updated; " + CHR(10)
                + string(DeleteTrans)    + " Translation entries deleted; " + CHR(10)
                + string(RejectTransNew) + " Translation entries rejected".  
  IF UpdateGlossary AND validUpdate THEN 
     ThisMessage = ThisMessage + "; ":U + CHR(10) + string(CreateGlossNew) + " Glossary entries added.".
  ELSE 
     ThisMessage = ThisMessage + ".":U.

  RUN adecomm/_s-alert.p (input-OUTPUT ErrorStatus, "i*":u, "ok":u, ThisMessage).    
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOptions DIALOG-1
ON CHOOSE OF BtnOptions IN FRAME DIALOG-1 /* Options >> */
DO:
 IF OptionState THEN
 DO:
   FRAME {&FRAME-NAME}:HEIGHT = FullHEIGHT. 
   ASSIGN
     BtnOptions:LABEL             = "<< &Options"
     OptionState                  = NOT OptionState
     Rect3:HIDDEN                 = FALSE
     OptionsLabel:HIDDEN          = FALSE
     DelimLabel:HIDDEN            = FALSE
     Delim:HIDDEN                 = FALSE
   .
 END.
 ELSE
 DO:
   ASSIGN                                
     BtnOptions:LABEL             = "&Options >>"  
     OptionState                  = NOT OptionState
     Rect3:HIDDEN                 = TRUE
     OptionsLabel:HIDDEN          = TRUE
     DelimLabel:HIDDEN            = TRUE
     Delim:HIDDEN                 = TRUE.
     FRAME {&FRAME-NAME}:HEIGHT   = shortHEIGHT.    
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FileName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FileName DIALOG-1
ON LEAVE OF FileName IN FRAME DIALOG-1
DO:
  DEFINE VARIABLE FileExt AS CHARACTER                                    NO-UNDO.
  IF FileName:SCREEN-VALUE = "" THEN RETURN.

  IF NUM-ENTRIES(FileName:SCREEN-VALUE,".":U) > 1 THEN
    FileExt = ENTRY(2,FileName:SCREEN-VALUE,".":U).
  Delim:SCREEN-VALUE = IF FileExt = "csv":U THEN "C":U ELSE "B":u.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME UpdateGlossary
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UpdateGlossary DIALOG-1
ON VALUE-CHANGED OF UpdateGlossary IN FRAME DIALOG-1 /* Update Glossary */
DO:
  ASSIGN UpdateGlossary
         GlossaryName:SENSITIVE = UpdateGlossary.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, IF there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: HANDLE ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   

  DO WITH FRAME {&FRAME-NAME}:

  FIND FIRST xlatedb.XL_Project NO-LOCK NO-ERROR.
  RUN adetran/pm/_getproj.p (OUTPUT GlossaryList, OUTPUT KitList, OUTPUT ErrorStatus).   
  GlossaryList = left-trim(GlossaryList,", ":u).
  
  ASSIGN       
    FileName                  = xlatedb.XL_Project.ProjectName + ".csv":U
    GlossaryName              = IF GlossaryList <> "" THEN
                                   GlossaryList 
                                ELSE 
                                   "None":U
    GlossaryName:LIST-ITEMS   = GlossaryName
    GlossaryName:SCREEN-VALUE = GlossaryName:ENTRY(1)
    TimeDateStamp             = INTEGER(TODAY) + (TIME / 100000)
    .
   
  RUN Realize.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  WAIT-FOR CLOSE OF THIS-PROCEDURE FOCUS FileName.
  END.
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
FRAME {&FRAME-NAME}:HIDDEN = TRUE.
  ASSIGN shortHeight = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-CHARS.
  DISPLAY 
     FromLabel
     FileNameLabel
     FileName
     GlossaryLabel
     GlossaryName 
     UpdateGlossary 
     ReconcileLabel 
     ReconcileType
     OptionsLabel
     DelimLabel
     Delim
     WITH FRAME {&FRAME-NAME}.
  ENABLE      
    FromLabel
    FileNameLabel
    FileName
    BtnFile
    GlossaryLabel
    GlossaryName
    UpdateGlossary
    ReconcileLabel
    ReconcileType
    OptionsLabel
    DelimLabel
    Delim
    BtnOk
    BtnCancel
    BtnHelp
    BtnOptions
    WITH FRAME {&FRAME-NAME}.
  
  ASSIGN
     FullHeight                   = FRAME {&FRAME-NAME}:HEIGHT
     Rect3:HIDDEN                 = TRUE
     OptionsLabel:HIDDEN          = TRUE
     DelimLabel:HIDDEN            = TRUE
     Delim:HIDDEN                 = TRUE
     FRAME {&FRAME-NAME}:HEIGHT   = Rect-4:ROW + Rect-4:HEIGHT + 0.6
     UpdateGlossary:SCREEN-VALUE  = STRING(UpdateGlossary)
     GlossaryName:SENSITIVE       = UpdateGlossary.
  ASSIGN shortHeight              = FRAME {&FRAME-NAME}:HEIGHT.
     
  FRAME {&FRAME-NAME}:HIDDEN      = FALSE.
  RUN adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

