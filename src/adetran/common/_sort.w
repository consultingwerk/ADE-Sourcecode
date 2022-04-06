&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-DEFINE WINDOW-NAME CURRENT-WINDOW
&Scoped-DEFINE FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* History:                                                          *
*  kmcintos  June 3, 2005  Added ability to sort by MaxLength field  * 
*                          in Translation Browse for VT 20050523-007.*
*********************************************************************/
{ adetran/vt/vthlp.i }    /* definitions for VT help strings */ 
{ adetran/pm/tranhelp.i } /* definitions for TM help strings */

DEFINE INPUT PARAMETER hSortProcedure     AS HANDLE     NO-UNDO.
DEFINE INPUT PARAMETER CurrentMode        AS INTEGER    NO-UNDO. 
DEFINE INPUT PARAMETER CurrentTool        AS CHARACTER  NO-UNDO. 

DEFINE SHARED VARIABLE s_Glossary         AS CHARACTER  NO-UNDO.
DEFINE SHARED VARIABLE _Lang              AS CHARACTER  NO-UNDO.

DEFINE VARIABLE SortExpr                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE TempFile                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE result                    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE tList                     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Level2Sav                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE Level3Sav                 AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cAddWhereClause           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cWildCardExpr             AS CHARACTER  NO-UNDO.
/*
** Note: Mode2 and Mode3 relate to the tabs 2 and 3 on the main window
**       Mode6 relate to the subset dialog available via
**             scan, extract, load, resources and kit creation
*/     
DEFINE SHARED VARIABLE Mode2              AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE Mode3              AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE Mode6              AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-DEFINE PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-DEFINE FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS L1Label BtnOK RECT-5 Level1Direction Level1 ~
BtnCancel L2Label RECT-7 BtnHelp Level2Direction Level2 L3Label RECT-8 ~
Level3Direction Level3 
&Scoped-Define DISPLAYED-OBJECTS L1Label Level1Direction Level1 L2Label ~
Level2Direction Level2 L3Label Level3Direction Level3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp AUTO-END-KEY 
     LABEL "&Help":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.125.

DEFINE VARIABLE Level1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 28.2 BY 1 NO-UNDO.

DEFINE VARIABLE Level2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 28.2 BY 1 NO-UNDO.

DEFINE VARIABLE Level3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 28.2 BY 1 NO-UNDO.

DEFINE VARIABLE L1Label AS CHARACTER FORMAT "X(256)":U INITIAL "Sort By" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE L2Label AS CHARACTER FORMAT "X(256)":U INITIAL "Then By" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE VARIABLE L3Label AS CHARACTER FORMAT "X(256)":U INITIAL "Then By" 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE Level1Direction AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ascending", "A":U,
"Descending", "D":U
     SIZE 16 BY 1.33 NO-UNDO.

DEFINE VARIABLE Level2Direction AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ascending", "A":U,
"Descending", "D":U
     SIZE 16 BY 1.33 NO-UNDO.

DEFINE VARIABLE Level3Direction AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Ascending", "A":U,
"Descending", "D":U
     SIZE 16 BY 1.33 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.8 BY 1.91.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.8 BY 1.91.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 49.8 BY 1.91.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     L1Label AT ROW 1.29 COL 4 NO-LABEL
     BtnOK AT ROW 1.48 COL 53
     Level1Direction AT ROW 1.76 COL 35 NO-LABEL
     Level1 AT ROW 2.14 COL 2.4 COLON-ALIGNED NO-LABEL
     BtnCancel AT ROW 2.71 COL 53
     L2Label AT ROW 3.52 COL 4 NO-LABEL
     BtnHelp AT ROW 3.95 COL 53
     Level2Direction AT ROW 4.1 COL 35 NO-LABEL
     Level2 AT ROW 4.43 COL 2.4 COLON-ALIGNED NO-LABEL
     L3Label AT ROW 5.86 COL 4 NO-LABEL
     Level3Direction AT ROW 6.43 COL 35 NO-LABEL
     Level3 AT ROW 6.67 COL 2.4 COLON-ALIGNED NO-LABEL
     RECT-5 AT ROW 1.52 COL 2.6
     RECT-7 AT ROW 3.81 COL 2.6
     RECT-8 AT ROW 6.14 COL 2.6
     SPACE(16.32) SKIP(0.44)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Sort":L
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
/* SETTINGS FOR DIALOG-BOX DIALOG-1
   L-To-R                                                               */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN L1Label IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN L2Label IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN L3Label IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-DEFINE SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp DIALOG-1
ON CHOOSE OF BtnHelp IN FRAME DIALOG-1 /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  case CurrentTool:
    when "VT":u then 
      run adecomm/_adehelp.p ("vt":u,"context":u,{&VT_Sort_Rows_Dialog_Box}, ?). 
    otherwise 
    DO:
      /* *** I don't see why there should be a difference... (tomn 1/7/2000)
      IF currentMode = 6 THEN
         RUN adecomm/_adehelp.p ("tran":U,"context":U,666, ?). 
      ELSE
      *** */
         run adecomm/_adehelp.p ("tran":u,"context":u,{&Sort_Rows_Dlgbx}, ?). 
    END.
  end case.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-DEFINE SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK DIALOG-1
ON CHOOSE OF BtnOK IN FRAME DIALOG-1 /* OK */
DO:
  DEFINE VARIABLE L1 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE L2 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE L3 AS CHARACTER NO-UNDO.

  if level1:screen-value = "(None)":u then DO:
    run SortQuery in hSortProcedure ("":U).
    return.
  END.

  case CurrentTool:
    when "VT":u then do:
     assign
       L1 = if Level1:screen-value = "Source Phrase":u          then 
                  (IF CurrentMode = 2 THEN "StringKey":u ELSE "ShortSrc":U)
            else
            if Level1:screen-value = "Target Phrase":u          then "ShortTarg":u     
            else
            if Level1:screen-value = "Procedure Name":u         then "ProcedureName":u    
            else
            if Level1:screen-value = "Type":u                   then "GlossaryType":u    
            else
            if Level1:screen-value = "Last Updated":u           then "UpdateDate":u    
            else
            if Level1:screen-value = "Modified By Translator":u then "ModifiedByTranslator":U 
            ELSE 
            IF Level1:SCREEN-VALUE = "Length":u                 THEN "MaxLength":u
            else
              Level1:screen-value  /* Item */       
              
       L2 = if Level2:screen-value = "Source Phrase":u          then 
                  (IF CurrentMode = 2 THEN "StringKey":u ELSE "ShortSrc":U)
            else
            if Level2:screen-value = "Target Phrase":u          then "ShortTarg":u     
            else
            if Level2:screen-value = "Procedure Name":u         then "ProcedureName":u    
            else
            if Level2:screen-value = "Type":u                   then "GlossaryType":u    
            else
            if Level2:screen-value = "Last Updated":u           then "UpdateDate":u    
            else
            if Level2:screen-value = "Modified By Translator":U then "ModifiedByTranslator":u 
            ELSE 
            IF Level2:SCREEN-VALUE = "Length":u                 THEN "MaxLength":u
            else
              Level2:screen-value    
                   
       L3 = if Level3:screen-value = "Source Phrase":u          then  
                  (IF CurrentMode = 2 THEN "StringKey":u ELSE "ShortSrc":U)
            else
            if Level3:screen-value = "Target Phrase":u          then "ShortTarg":u     
            else
            if Level3:screen-value = "Procedure Name":u         then "ProcedureName":u    
            else
            if Level3:screen-value = "Type":u                   then "GlossaryType":u    
            else
            if Level3:screen-value = "Last Updated":u           then "UpdateDate":u    
            else
            if Level3:screen-value = "Modified By Translator":u then "ModifiedByTranslator":u 
            ELSE 
            IF Level3:SCREEN-VALUE = "Length":u                 THEN "MaxLength":u
            else            
              Level3:screen-value  
              
       /* Prefix the field name  */
       L1 = (IF CurrentMode = 2 THEN "ThisString.":u ELSE "Glossary.":u) + L1
       L2 = (IF CurrentMode = 2 THEN "ThisString.":u ELSE "Glossary.":u) + L2
       L3 = (IF CurrentMode = 2 THEN "ThisString.":u ELSE "Glossary.":u) + L3.        
    end.                            
    
    otherwise do: /* PM */
     IF CurrentMode <> 6 THEN
     DO:
        assign
          L1 = if Level1:screen-value = "Source Phrase":u and CurrentMode = 2
                 then "ThisString.KeyOfString":u 
               else 
               if Level1:screen-value = "Source Phrase":u and CurrentMode = 3
                 then "bXLGloss.ShortSrc":u
               else
               if Level1:screen-value = "Target Phrase":u  then "bXLGloss.ShortTarg":u
               else
               if Level1:screen-value = "Procedure Name":u then "ThisInstance.proc_name":u    
               else
               if Level1:screen-value = "Object Name":u    then "ThisInstance.ObjectName":u       
               else
               if Level1:screen-value = "Line Number":u    then "ThisInstance.line_num":u       
               else
               if Level1:screen-value = "Type":u           then "bXLGloss.GlossaryType":u    
               else
               if Level1:screen-value = "Modified By Translator":u
                                                           then "bXLGloss.ModifiedByTranslator":u 
               else
               if Level1:screen-value = "Length":u         then "ThisInstance.MaxLength":u       
               else            
               if Level1:screen-value = "Occurrences":u    then "ThisInstance.num_occurs":u  
               else   
               if Level1:screen-value = "Comments":u       then "ThisString.comment":u    
               else Level1:screen-value         
                 
          L2 = if Level2:screen-value = "Source Phrase":u and CurrentMode = 2
                 then "ThisString.KeyOfString":u 
               else 
               if Level2:screen-value = "Source Phrase":u and CurrentMode = 3
                 then "bXLGloss.ShortSrc":u
               else
               if Level2:screen-value = "Target Phrase":u  then "bXLGloss.ShortTarg":u
               else
               if Level2:screen-value = "Procedure Name":u then "ThisInstance.proc_name":u    
               else
               if Level2:screen-value = "Object Name":u    then "ThisInstance.ObjectName":u       
               else
               if Level2:screen-value = "Line Number":u    then "ThisInstance.line_num":u       
               else
               if Level2:screen-value = "Type":u           then "bXLGloss.GlossaryType":u    
               else
               if Level2:screen-value = "Modified By Translator":u
                                                           then "bXLGloss.ModifiedByTranslator":u 
               else
               if Level2:screen-value = "Length":u         then "ThisInstance.MaxLength":u       
               else            
               if Level2:screen-value = "Occurrences":u    then "ThisInstance.num_occurs":u       
               else   
               if Level2:screen-value = "Comments":u       then "ThisString.comment":u    
               else Level2:screen-value        
                  
          L3 = if Level3:screen-value = "Source Phrase":u and CurrentMode = 2
                 then "ThisString.KeyOfString":u 
               else 
               if Level3:screen-value = "Source Phrase":u and CurrentMode = 3
                 then "bXLGloss.ShortSrc":u
               else
               if Level3:screen-value = "Target Phrase":u  then "bXLGloss.ShortTarg":U     
               else
               if Level3:screen-value = "Procedure Name":u then "ThisInstance.proc_name":u    
               else
               if Level3:screen-value = "Object Name":u    then "ThisInstance.ObjectName":u       
               else
               if Level3:screen-value = "Line Number":u    then "ThisInstance.line_num":u       
               else
               if Level3:screen-value = "Type":u           then "bXLGLoss.GlossaryType":u    
               else
               if Level3:screen-value = "Modified By Translator":u
                                                           then "bXLGloss.ModifiedByTranslator":u 
               else
               if Level3:screen-value = "Length":u         then "ThisInstance.MaxLength":u       
               else            
               if Level3:screen-value = "Occurrences":u    then "ThisInstance.num_occurs":u       
               else            
               if Level3:screen-value = "Comments":u       then "ThisString.Comment":u       
               else Level3:screen-value.
       END. /* Other than subset */
       ELSE
       DO:
          ASSIGN
             L1 = IF Level1:SCREEN-VALUE = "File Name":U THEN 
                     "ThisSubsetList.FileName":U 
                  ELSE IF Level1:SCREEN-VALUE = "Directory":U THEN 
                     "ThisSubsetList.Directory":U 
                  ELSE Level1:SCREEN-VALUE
             L2 = IF Level2:SCREEN-VALUE = "File Name":U THEN
                     "ThisSubsetList.FileName":U 
                  ELSE IF Level2:SCREEN-VALUE = "Directory":U THEN  
                     "ThisSubsetList.Directory":U
                  ELSE Level2:SCREEN-VALUE
             /* Force 3rd argument to be (None) since only 2 sort fields */
             Level3:SCREEN-VALUE = "(None)":U.
       END. /* Subset */
    end. /* PM */         
  end case.  
                                   
    SortExpr  = "by ":u + L1 + 
                 (if Level1Direction:screen-value = "D":u then " descending ":u else "") + 
                 (if Level2:screen-value <> "(None)":U then " by ":u + L2 + 
                 (if Level2Direction:screen-value = "D":u then " descending ":u else "") else "") +
                 (if Level3:screen-value <> "(None)":U then  " by ":u + L3 + 
                 (if Level3Direction:screen-value = "D":u then " descending ":u else "") else "").

  if SortExpr = "" then return.                                
   
  run adecomm/_setcurs.p ("WAIT":u).
  run adecomm/_tmpfile.p ("t2":U, ".tmp":u, OUTPUT TempFile).      
  
  IF CurrentTool = "PM":U AND CurrentMode = 6 THEN 
     RUN getSWildCardExpr IN hSortProcedure (OUTPUT cWildCardExpr)
.
  output to value (TempFile) NO-ECHO.  
    
  case CurrentTool.
    when "VT":u then do:
     if CurrentMode = 2 then put unformatted 
       'DEFINE SHARED buffer ThisString for kit.XL_Instance.':u skip    
       'DEFINE SHARED query ThisBuffer for ThisString scrolling.':u skip
       'open query ThisBuffer for each ThisString ':u skip 
       SortExpr + ' indexed-reposition':u + '.':u SKIP.        
     else if CurrentMode = 3 then put unformatted 
       'DEFINE SHARED buffer Glossary for kit.XL_GlossEntry.':u skip    
       'DEFINE SHARED query GlossBrowser for Glossary scrolling.':u skip
       'open query GlossBrowser for each Glossary ':u skip 
       SortExpr '.':u SKIP.
    end. /* VT */
     
    when "PM":u then do:
     if CurrentMode = 2 then
     do:
      put unformatted
       'DEFINE VARIABLE cLang AS CHARACTER INITIAL "':U + _Lang + '" NO-UNDO.':U                   skip
       'DEFINE SHARED buffer ThisString for xlatedb.XL_String_Info.':u      skip
       'DEFINE SHARED buffer ThisInstance for xlatedb.XL_Instance.':u       skip     
       'DEFINE SHARED buffer ThisTranslation for xlatedb.XL_Translation.':u skip.
      put unformatted
       'DEFINE SHARED query ThisBuffer for ThisString, ThisInstance, ThisTranslation scrolling.':u skip
       'open query ThisBuffer':u skip
       'for each ThisString, ':u skip
       ' each ThisInstance WHERE':U SKIP
       '      ThisInstance.sequence_num = ThisString.sequence_num, ':u skip
       ' each ThisTranslation WHERE':U SKIP
       '      ThisTranslation.sequence_num = ThisInstance.sequence_num AND':U SKIP
       '      ThisTranslation.instance_num = ThisInstance.instance_num AND':U SKIP
       '      ThisTranslation.lang_name    = cLang':U SKIP
       '          outer-join':u skip
       SortExpr + '  indexed-reposition':u + '.':U SKIP.
     end. /* PM CurrentMode = 2*/
     else if CurrentMode = 3 then put unformatted
        'DEFINE SHARED VARIABLE s_Glossary AS CHARACTER NO-UNDO.':u skip 
        'DEFINE SHARED buffer bXLGloss for xlatedb.XL_GlossDet.':u skip    
        'DEFINE SHARED query GlossBrowser for bXLGloss scrolling.':u skip
        'open query GlossBrowser for each bXLGloss where':U skip
        '  bXLGloss.GlossaryName = "':u + s_Glossary + '"':U skip
        SortExpr '.':u SKIP.                     
     ELSE IF CurrentMode = 6 THEN 
     DO: /* Working with filenames */
  
        /* part of this is from vsubset.i */
        PUT UNFORMATTED
        'DEFINE SHARED TEMP-TABLE bSubsetList':U                       	           SKIP
        '   FIELD Project    AS   CHARACTER':U                         	           SKIP
        '   FIELD Directory  AS   CHARACTER':U                         	           SKIP
        '   FIELD FileName   AS   CHARACTER':U                         	           SKIP
        '   FIELD AllFiles   AS   LOGICAL':U                                       SKIP
        '   FIELD AllSubDirs AS   LOGICAL':U                           	           SKIP
        '   FIELD Active     AS   LOGICAL INITIAL TRUE':U		 	           SKIP
        '   INDEX idxActiveFile    Active Project FileName':U                      SKIP
        '   INDEX idxFile          Project FileName':U                             SKIP
        '   INDEX idxDir           Project Directory':U                            SKIP
        '   INDEX idxActiveDirFile Active Project Directory FileName.':U     	     SKIP
        'DEFINE VARIABLE cAllFiles AS CHARACTER  INITIAL "<All Files>" NO-UNDO.':U SKIP
        'DEFINE SHARED VARIABLE ProjectDB AS CHARACTER NO-UNDO.                ':U SKIP
        'DEFINE SHARED BUFFER ThisSubsetList FOR bSubsetList.                  ':U SKIP    
        'DEFINE SHARED QUERY  ThisSubsetList FOR ThisSubsetList SCROLLING.     ':U SKIP
        .

        /* This is basically oqryproc.i
        */
        PUT UNFORMATTED
        'DEFINE VARIABLE cLookupExpr       AS CHARACTER    EXTENT 4   NO-UNDO.':U            SKIP
        'DEFINE VARIABLE tmpWildCardExpr   AS CHARACTER               NO-UNDO.':U            SKIP(2)
        '/* Need to replace . with ~~. for matching true . */':U                             SKIP
        'ASSIGN tmpWildCardExpr = ':U                                                        SKIP
        '  REPLACE("':U cWildCardExpr '",".":U,"~~.":U). ':U                                 SKIP(2)
        '/* Common Case 1: retrieve both *.p and *.w code  */':U                             SKIP
        'IF "':U cWildCardExpr '" = "*.p,*.w":U THEN DO:':U                                  SKIP
        '  OPEN QUERY ThisSubsetList':U                                                      SKIP
        '    FOR EACH ThisSubsetList NO-LOCK ':U                                             SKIP
        '       WHERE ThisSubsetList.Active = TRUE':U                                        SKIP
        '         AND ThisSubsetList.Project = ProjectDB':U                                  SKIP
        '         AND (ThisSubsetList.FileName MATCHES "*~~.p":U':U                          SKIP
        '              OR ThisSubsetList.FileName MATCHES "*~~.w":U':U                       SKIP
        '              OR ThisSubsetList.FileName = cAllFiles)':U                            SKIP
        '      ':U SortExpr '.':U                                                            SKIP
        'END.':U                                                                             SKIP
        .

        PUT UNFORMATTED
        '/* Common case 2: retrieve anything *.* */':U                                       SKIP
        'ELSE IF "':U cWildCardExpr '" = "*.*":U THEN DO:':U                                 SKIP
        '  OPEN QUERY ThisSubsetList FOR EACH ThisSubsetList NO-LOCK':U                      SKIP
        '       WHERE ThisSubsetList.Active = TRUE':U                                        SKIP
        '         AND ThisSubsetList.Project = ProjectDB':U                                  SKIP
        '      ':U SortExpr '.':U                                                            SKIP
        'END. ':U                                                                            SKIP(2)
        .

        PUT UNFORMATTED
        '/* Last chance case, parse upto 4 entries */':U                                     SKIP
        'ELSE DO:':U                                                                         SKIP
        '  CASE NUM-ENTRIES("':U cWildCardExpr '"):':U                                       SKIP
        '    WHEN 1 THEN DO:':U                                                              SKIP
        '      OPEN QUERY ThisSubsetList FOR EACH ThisSubsetList NO-LOCK':U                  SKIP
        '           WHERE ThisSubsetList.Active = TRUE':U                                    SKIP
        '             AND ThisSubsetList.Project = ProjectDB':U                              SKIP
        '             AND (ThisSubsetList.FileName MATCHES ':U                               SKIP
        '                  REPLACE(tmpWildCardExpr, "?":U , ".":U)':U                        SKIP
        '                  OR ThisSubsetList.FileName = cAllFiles)':U                        SKIP
        '          ':U SortExpr '.':U                                                        SKIP
        '    END. ':U                                                                        SKIP(2)
        .

        PUT UNFORMATTED
        '    WHEN 2 THEN DO: ':U                                                             SKIP
        '      ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U).':U   SKIP
        '      OPEN QUERY ThisSubsetList FOR EACH ThisSubsetList NO-LOCK':U                  SKIP
        '           WHERE ThisSubsetList.Active = TRUE':U                                    SKIP
        '             AND ThisSubsetList.Project = ProjectDB':U                              SKIP
        '             AND (ThisSubsetList.FileName MATCHES cLookupExpr[1]':U                 SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[2]':U              SKIP
        '                  OR ThisSubsetList.FileName = cAllFiles)':U                        SKIP
        '          ':U SortExpr '.':U                                                        SKIP
        '    END. ':U                                                                        SKIP
        .

        PUT UNFORMATTED
        '    WHEN 3 THEN DO: ':U                                                             SKIP
        '      ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[3] = REPLACE(ENTRY(3,tmpWildCardExpr), "?":U, ".":U).':U   SKIP
        '      OPEN QUERY ThisSubsetList FOR EACH ThisSubsetList NO-LOCK ':U                 SKIP
        '           WHERE ThisSubsetList.Active = TRUE':U                                    SKIP
        '             AND ThisSubsetList.Project = ProjectDB':U                              SKIP
        '             AND (   ThisSubsetList.FileName MATCHES cLookupExpr[1]':U              SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[2]':U              SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[3]':U              SKIP
        '                  OR ThisSubsetList.FileName = cAllFiles)':U                        SKIP
        '          ':U SortExpr '.':U                                                        SKIP
        '    END. ':U                                                                        SKIP
        .

        PUT UNFORMATTED
        '    WHEN 4 THEN DO: ':U                                                             SKIP
        '      ASSIGN cLookupExpr[1] = REPLACE(ENTRY(1,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[2] = REPLACE(ENTRY(2,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[3] = REPLACE(ENTRY(3,tmpWildCardExpr), "?":U, ".":U) ':U   SKIP
        '             cLookupExpr[4] = REPLACE(ENTRY(4,tmpWildCardExpr), "?":U, ".":U).':U   SKIP
        '      OPEN QUERY ThisSubsetList FOR EACH ThisSubsetList NO-LOCK':U                  SKIP
        '           WHERE ThisSubsetList.Active = TRUE':U                                    SKIP
        '             AND ThisSubsetList.Project = ProjectDB':U                              SKIP
        '             AND (   ThisSubsetList.FileName MATCHES cLookupExpr[1]':U              SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[2]':U              SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[3]':U              SKIP
        '                  OR ThisSubsetList.FileName MATCHES cLookupExpr[4]':U              SKIP
        '                  OR ThisSubsetList.FileName = cAllFiles)':U                        SKIP
        '          ':U SortExpr '.':U                                                        SKIP
        '    END. ':U                                                                        SKIP(2)
        '  END.  /* CASE */ ':U                                                              SKIP
        'END.  /* Last chance case */ ':U                                                    SKIP
        .
     END. /* PM CurrentMode = 6 Subset Query */
    END. /* PM */
  end case.                   

  put unformatted
    'procedure ADEPersistent:' skip
    '  RETURN "OK".' skip
    'END.' skip (1).
     
  output close.      
  run SortQuery in hSortProcedure (TempFile).
  run adecomm/_setcurs.p ("").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-DEFINE SELF-NAME Level1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Level1 DIALOG-1
ON VALUE-CHANGED OF Level1 IN FRAME DIALOG-1
DO:                                  
 
  assign Level2Sav = Level2:screen-value
         Level3Sav = Level3:screen-value
         Level2:list-items   = "(None),":u + Level1:list-items
         Level3:list-items   = "(None),":u + Level1:list-items   
         result              = Level2:delete(Level1:screen-value)
         result              = Level3:delete(Level1:screen-value)
         Level2:screen-value = if lookup(Level2Sav,Level2:screen-value) > 0 then Level2Sav
                               else entry(1,Level2:list-items)
         Level3:screen-value = if lookup(Level3Sav,Level3:screen-value) > 0 then Level3Sav
                               else entry(1,Level3:list-items).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-DEFINE SELF-NAME Level2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Level2 DIALOG-1
ON VALUE-CHANGED OF Level2 IN FRAME DIALOG-1
DO:                                             
   assign Level3Sav = Level3:screen-value
          Level3:list-items = "(None),":u + Level1:list-items 
          result            = Level3:delete(Level1:screen-value)
          result            = Level3:delete(Level2:screen-value)
          Level3:screen-value = if lookup(Level3Sav,Level3:screen-value) > 0 then Level3Sav
                               else entry(1,Level3:list-items).
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
/* (NOTE: HANDLE ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.


  assign
    L1Label:screen-value = "Sort By":u
    L2Label:screen-value = "Then By":u
    L3Label:screen-value = "Then By":u
    L1Label:width        = font-table:get-text-width-chars(L1Label:screen-value,4)
    L2Label:width        = font-table:get-text-width-chars(L2Label:screen-value,4)
    L3Label:width        = font-table:get-text-width-chars(L3Label:screen-value,4)

    Level1:list-items    = IF      CurrentMode = 2 THEN Mode2 
                           ELSE IF CurrentMode = 6 THEN Mode6
                           ELSE                         Mode3
    Level2:list-items    = IF      CurrentMode = 2 THEN Mode2
                           ELSE IF CurrentMode = 6 THEN Mode6
                           ELSE                         Mode3
    Level3:list-items    = IF      CurrentMode = 2 THEN Mode2
                           ELSE IF CurrentMode = 6 THEN Mode6
                           ELSE                         Mode3
    result               = Level1:delete("(None)":u).
    
    IF CurrentMode <> 6 THEN
    DO:
      ASSIGN
        Level1:screen-value  = "Source Phrase":u        
        result               = Level2:delete("Source Phrase":u)
        Level2:screen-value  = Level2:entry(1)            
        result               = Level3:delete("Source Phrase":u)
        Level3:screen-value  = Level3:entry(1).
    END.
    ELSE
    DO:
      ASSIGN
        Level1:screen-value  = "File Name":U        
        result               = Level2:delete("File Name":u)
        Level2:screen-value  = Level2:entry(1)            
        result               = Level3:delete("File Name":u)
        Level3:screen-value  = Level3:entry(1).

        IF NUM-ENTRIES(Mode6) <= 3 THEN
        DO: /* If there are less than 2 choices of sort fields then
             * disable the last sort option */
           ASSIGN 
              L3Label:SENSITIVE           = FALSE
              Level3:SENSITIVE            = FALSE
              Level3Direction:SENSITIVE   = FALSE
              RECT-8:SENSITIVE            = FALSE.
        END. /* Disable part of UI if necessary */
    END.
    
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
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
  DISPLAY L1Label Level1Direction Level1 L2Label Level2Direction Level2 L3Label 
          Level3Direction Level3 
      WITH FRAME DIALOG-1.
  ENABLE L1Label BtnOK RECT-5 Level1Direction Level1 BtnCancel L2Label RECT-7 
         BtnHelp Level2Direction Level2 L3Label RECT-8 Level3Direction Level3 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


