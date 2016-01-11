/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

    File        : _mlref.p

    Syntax      :
        RUN adeuib/_mlref.p ( INPUT p_Dlg_Type ,
                              INPUT-OUTPUT p_File_Spec ,
                              OUTPUT       p_Return_Status ) .

    Description :  Add/Modify Method Library Reference Dialog Box.

  Input Parameters:
      <none>

  VARs:
      p_File_Spec        : File Reference name entered by user.


  Output Parameters:
      p_Return_Status    : Returns YES if user pressed OK; ? if user pressed
                           Cancel.

  Author       : John Palazzo
  Date Created : 03/95

-----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_Dlg_Type      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_Broker-URL    AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_File_Spec     AS CHARACTER  NO-UNDO
  LABEL "File Reference" FORMAT "X(128)":U.
DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL    NO-UNDO.

&GLOBAL-DEFINE WIN95-BTN TRUE
/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds THEN
  RUN adecomm/_adeload.p.

{ adeuib/sharvars.i }
/* Help Context Definitions. */
{ adeuib/uibhlp.i }

DEFINE VARIABLE v_File_Spec  LIKE p_File_Spec  NO-UNDO .
DEFINE VARIABLE Open_Curly   AS CHARACTER  NO-UNDO 
  FORMAT "x(1)":U INITIAL "~{":U.
DEFINE VARIABLE Close_Curly  AS CHARACTER  NO-UNDO 
  FORMAT "x(1)":U INITIAL "~}":U.
DEFINE VARIABLE Help_Id      AS INTEGER    NO-UNDO.

/* Definitions of the field level widgets                             */
DEFINE BUTTON btn_OK LABEL "OK"
  {&STDPH_OKBTN} AUTO-GO.
    
DEFINE BUTTON btn_Cancel LABEL "Cancel"
  {&STDPH_OKBTN} AUTO-ENDKEY.

DEFINE BUTTON btn_Browse LABEL "&Files..."
  {&STDPH_OKBTN}.

DEFINE BUTTON btn_Help  LABEL "&Help"
  {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE FS_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME DIALOG-1
  SKIP( {&TFM_WID} )
  "Include Reference:" VIEW-AS TEXT AT 6
  SKIP( {&VM_WID} )
  Open_Curly NO-LABEL {&AT_OKBOX} SPACE(0)
  p_File_Spec VIEW-AS FILL-IN SIZE 45 BY 1
  SPACE(0) Close_Curly NO-LABEL
        
  { adecomm/okform.i
     &BOX    ="FS_Btn_Box"
     &OK     ="btn_OK"
     &CANCEL ="btn_Cancel"
     &OTHER  ="SPACE( {&HM_BTNG} ) btn_Browse"
     &HELP   ="btn_Help" 
  }
  WITH OVERLAY NO-LABELS TITLE p_Dlg_Type + " Method Library Reference"
    VIEW-AS DIALOG-BOX THREE-D
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel.

ASSIGN FRAME DIALOG-1:PARENT = ACTIVE-WINDOW.

{ adecomm/okrun.i
   &FRAME  = "FRAME DIALOG-1"
   &BOX    = "FS_Btn_Box"
   &OK     = "btn_OK"
   &HELP   = "btn_Help"
}

/******************************************************************/
/*                     UI TRIGGERS                                */
/******************************************************************/

ON CHOOSE OF btn_Help IN FRAME DIALOG-1
  OR HELP OF FRAME DIALOG-1 ANYWHERE DO:
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT" , Help_Id , ? ).
END.

ON GO OF FRAME DIALOG-1 DO:
  DEFINE VARIABLE Focus_Widget AS HANDLE.
    
  Focus_Widget = FOCUS.   
  DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY :    
    IF RETRY THEN DO: 
      RUN ApplyEntry( Focus_Widget ). 
      RETURN NO-APPLY. 
    END.
    ELSE DO:
      RUN PressedOK ( OUTPUT p_Return_Status ).
      IF NOT p_Return_Status THEN
        RUN ApplyEntry( Focus_Widget ).
    END.
  END.
END.

ON WINDOW-CLOSE OF FRAME DIALOG-1
  APPLY "END-ERROR":U TO FRAME DIALOG-1.
    
ON CHOOSE OF btn_Cancel IN FRAME DIALOG-1 DO:
  ASSIGN  
    p_Return_Status = FALSE  /* Cancel */
    p_File_Spec     = v_File_Spec.
END.

ON CHOOSE OF btn_Browse IN FRAME DIALOG-1 DO:
  DEFINE VARIABLE Return_Status AS LOGICAL.
  DEFINE VARIABLE Focus_Widget  AS WIDGET-HANDLE.
    
  Focus_Widget = FOCUS.   
  DO ON STOP UNDO, RETRY :    
    IF RETRY THEN RETURN NO-APPLY.
    ELSE DO:
      RUN BrowseFiles ( OUTPUT Return_Status ).
      IF Return_Status THEN
        APPLY "ENTRY":U TO btn_OK IN FRAME DIALOG-1.
      ELSE 
       APPLY "ENTRY":U TO Focus_Widget.
    END.
  END.
END.

/****************************************************************
* Main Code Section                                             *
****************************************************************/

DO ON STOP UNDO, LEAVE ON ENDKEY UNDO, LEAVE ON ERROR UNDO, LEAVE:    
  STATUS INPUT "".
  ASSIGN  
    p_Return_Status = FALSE  /* Cancel */
    v_File_Spec     = p_File_Spec
    Help_Id         = (IF p_Dlg_Type = "Add"
                       THEN {&Add_Method_Library_Ref_Dlg_Box}
                       ELSE {&Modify_Method_Library_Ref_Dlg_Box}).
            
  ENABLE ALL EXCEPT Open_Curly Close_Curly WITH FRAME DIALOG-1.
  DISPLAY Open_Curly Close_Curly WITH FRAME DIALOG-1.
    
  DO ON STOP UNDO, LEAVE ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE:
    UPDATE p_File_Spec WITH FRAME DIALOG-1.            
  END.

  STATUS INPUT.
END. /* MAIN */
HIDE FRAME DIALOG-1.

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/

PROCEDURE ApplyEntry:
  DEFINE INPUT PARAMETER p_Widget AS WIDGET-HANDLE.

  IF p_Widget:SENSITIVE THEN
    APPLY "ENTRY":U TO p_Widget.
END.

PROCEDURE PressedOK:
  DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL  NO-UNDO.
    
  DEFINE VARIABLE cFile         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempFile     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE Invalid_IsOK  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lNotFound     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ReadOnly_IsOK AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE relPathName   AS CHARACTER  NO-UNDO.
    
  cFile = TRIM( p_File_Spec:SCREEN-VALUE IN FRAME DIALOG-1 ).

  /* Check for file existence. */
  IF _AB_license > 1 AND p_Broker-URL <> "" THEN DO:
    RUN adeweb/_webcom.w (?, _BrokerURL, cFile, "search":U,
      OUTPUT relPathName, INPUT-OUTPUT cTempFile).
    lNotFound = ( relPathName = ? ).
  END.
  ELSE DO:
    FILE-INFO:FILENAME = cFile.
    lNotFound = ( FILE-INFO:FULL-PATHNAME = ? ).
  END.

  IF lNotFound THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT Invalid_IsOK, "warning":u, "yes-no":U,
      SUBSTITUTE("&1^Cannot find Method Library file.^^Check that the file exists and can be found in the PROPATH.  The including file may not compile correctly until the Method Library can be found.^^Do you want to continue?",
      cFile ))).
    IF NOT Invalid_IsOK THEN RETURN ERROR.
  END.
    
  ASSIGN  
    p_Return_Status = TRUE
    INPUT FRAME DIALOG-1 p_File_Spec
    p_File_Spec     = TRIM( p_File_Spec )
    p_File_Spec     = TRIM( p_File_Spec , Open_Curly + " ":U + Close_Curly)
    p_File_Spec     = REPLACE( p_File_Spec , "~\":U , "~/":U ).

  /* If user wants the Invalid File entry, return it exactly as is. */
  IF Invalid_IsOK THEN RETURN.
END.

PROCEDURE BrowseFiles:
  DEFINE OUTPUT PARAMETER p_Return_Status AS LOGICAL  NO-UNDO.
  
  DEFINE VARIABLE cTempFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.  
  DEFINE VARIABLE v_GotFile  AS CHARACTER  NO-UNDO.
  
  IF _AB_license > 1 AND p_Broker-URL <> "" THEN
    RUN adeweb/_webfile.w ("uib":U, "Open":U, "Open":U, "":U,
      INPUT-OUTPUT v_GotFile, OUTPUT cTempFile, OUTPUT p_Return_Status).

  IF _AB_license = 1 OR p_Broker-URL = "" OR RETURN-VALUE = "HTTPFailure":U THEN
    RUN adecomm/_getfile.p
        (INPUT ACTIVE-WINDOW , 
         INPUT ?        /* No Product Name */,
         INPUT "OPEN":U /* Action */,
         INPUT "Files"  /* Title  */,
         INPUT "OPEN":U /* Mode   */,
         INPUT-OUTPUT v_GotFile ,
         OUTPUT p_Return_Status ).
  IF NOT p_Return_Status THEN RETURN.
  
  /* Check to see if the file is in the Propath.  If so, make it relative */
  DO ix = 1 to NUM-ENTRIES(PROPATH):
    FILE-INFO:FILE-NAME = TRIM(ENTRY(ix, PROPATH)).
    IF v_GotFile BEGINS FILE-INFO:FULL-PATHNAME AND
      FILE-INFO:FULL-PATHNAME NE ? THEN
      /* If it's there, chop off the leading part */
      v_GotFile = SUBSTRING(v_GotFile, 
                    LENGTH(FILE-INFO:FULL-PATHNAME) + 2, -1, "CHARACTER":U).
  END.
  
  IF NOT OPSYS = "UNIX":U THEN
    ASSIGN 
      v_GotFile = LC( v_GotFile )
      v_GotFile = REPLACE( v_GotFile , "~\":U , "~/":U).

  ASSIGN p_File_Spec:SCREEN-VALUE IN FRAME DIALOG-1 = v_GotFile.
END.

/* _mlref.p - end of file */
