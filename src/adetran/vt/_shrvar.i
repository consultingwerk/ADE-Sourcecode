/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*                                                                   *
* History:                                                           *
*   kmcintos  June 3, 2005  Added 'Length' field to sort field lists *
*                           20050523-007.                            *
*********************************************************************/
DEFINE {&NEW} SHARED VARIABLE tPrevh         AS WIDGET-HANDLE          NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE KitDB          AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE pFileName      AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED TEMP-TABLE tTblObj NO-UNDO
  FIELD ObjWName  AS CHARACTER /* Procedure Name */
  FIELD ObjName   AS CHARACTER /* Object Name    */
  FIELD ObjType   AS CHARACTER /* Object Type    */
  FIELD ObjNLbl   AS CHARACTER /* TargetPhrase   */
  FIELD ObjOLbl   AS CHARACTER /* SourcePhrase   */
  FIELD FoundIn   AS CHARACTER /* Where this info came from - INST or GLOSS */
  INDEX ProcObjTyp IS PRIMARY ObjWName ObjName ObjType.

DEFINE {&NEW} SHARED VARIABLE hMain          AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hProcs         AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE MainWindow     AS WIDGET-HANDLE          NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE PropsWindow    AS WIDGET-HANDLE          NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hProps         AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hFind          AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hReplace       AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hResource      AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hLkup          AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hLongStr       AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hMeter         AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE CurWin         AS WIDGET-HANDLE          NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE CurObj         AS WIDGET-HANDLE          NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE TotFrame       AS INTEGER                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE TotObject      AS INTEGER                NO-UNDO.

DEFINE {&NEW} SHARED VARIABLE CurrentTool    AS CHARACTER INITIAL "VT" NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE PropsOnTop     AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE GlossaryOnTop  AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE CurLanguage    AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE AutoTrans      AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE ConfirmAdds    AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE Priv1          AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE Priv2          AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE Priv3          AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hFileMenu      AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hWinMenu       AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hWinMgr        AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE CurrentMode    AS INTEGER INITIAL 1      NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE StopProcessing AS LOGICAL                NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE s_glossary     AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE FullPathFlag   AS LOGICAL INITIAL TRUE   NO-UNDO.

/* sort only */
DEFINE {&NEW} SHARED VARIABLE Mode2          AS CHARACTER INITIAL
    "(None),Source Phrase,Target Phrase,Procedure Name,Length,Last Updated"   NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE Mode3          AS CHARACTER INITIAL
    "(None),Source Phrase,Target Phrase,Modified By Translator,Length,Type"   NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE Mode6          AS CHARACTER INITIAL 
  "(None),File Name,Directory,Length"                                         NO-UNDO.
/* order only */
DEFINE {&NEW} SHARED VARIABLE OrdMode2       AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE OrdMode3       AS CHARACTER              NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hTrans         AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hGloss         AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE tInstRec       AS RECID                  NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE tGlssRec       AS RECID                  NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE hSort          AS HANDLE                 NO-UNDO.
DEFINE {&NEW} SHARED VARIABLE tModFlag       AS LOGICAL INITIAL FALSE  NO-UNDO.
