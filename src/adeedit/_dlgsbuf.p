/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/****************************************************************************
    Procedure :  _dlgsbuf.p
    
    Syntax    :  
    
                 RUN adeedit/_dlgsbuf.p 
    		    ( p_Window , p_Title , p_Mod_List , 
    		      OUTPUT p_Save_List ) .
    		        	
    Purpose   :  Dialog box which displays a list of modified editor buffers
    		 from which the user selects buffers to save .
    		 
    INPUT PARAMETERS

    	p_Window	(WIDGET-HANDLE)
    		Handle to window in which dialog box should display.

    	p_Title		(CHAR)
    		Title of dialog box. Defaults to "Save Modified Buffers".
    		
    	p_Mod_List	(CHAR)
    		List of modified editor buffers which user can select to
    		save.  Comma-delimited.
    		
    OUTPUT PARAMETERS
    
    	p_Save_List	(CHAR)
    		List of buffers users selected to be saved.
    		
    		Return Value    Description
    		------------	-------------------------------
    		Comma-List	List of buffers to save.
    		Null ("")	User choose to Save None.
    		Unknown (?)	User presed Cancel button.
    		
    Author:	J. Palazzo
    Created:	11.03.92
    		
****************************************************************************/


DEFINE INPUT  PARAMETER p_Window       AS WIDGET-HANDLE NO-UNDO .
DEFINE INPUT  PARAMETER p_Title        AS CHAR NO-UNDO .
DEFINE INPUT  PARAMETER p_Mod_List     AS CHAR NO-UNDO .
DEFINE OUTPUT PARAMETER p_Save_List    AS CHAR INIT ? NO-UNDO .

&GLOBAL-DEFINE WIN95-BTN YES

/* ADE Standards Include */
{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE Buf_List AS CHAR 
    VIEW-AS SELECTION-LIST MULTIPLE NO-DRAG 
            LIST-ITEMS ""  SIZE 68 BY 6 SCROLLBAR-V SCROLLBAR-H NO-UNDO.

DEFINE VAR hBuf_List AS WIDGET-HANDLE NO-UNDO .

DEFINE VAR Selected_Count AS CHAR FORMAT "x(20)" NO-UNDO.
DEFINE VAR List_Items AS CHAR NO-UNDO .
DEFINE VAR Num_Selected AS CHAR NO-UNDO .
DEFINE VAR Temp_Bool AS LOGICAL NO-UNDO .

DEFINE BUTTON btn_Save_Sel  LABEL "Save &Selected"
    SIZE 16 BY {&H_OKBTN} DEFAULT AUTO-GO.

DEFINE BUTTON btn_Cancel    LABEL "Cancel"
    {&STDPH_OKBTN} AUTO-ENDKEY.
    
DEFINE BUTTON btn_Save_None LABEL "Save &None"
    {&STDPH_OKBTN}.
    
DEFINE BUTTON btn_Help      LABEL "&Help"
    {&STDPH_OKBTN}.

/* Dialog Button Box */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE SB_Btn_Box    {&STDPH_OKBOX}.
&ENDIF

/* Dialog Box */    
DEFINE FRAME FRAME-A
  SKIP( {&TFM_WID} )
       "Select Changed Buffers to Save:" VIEW-AS TEXT {&AT_OKBOX}
  SKIP( {&VM_WID} )
       Buf_List {&AT_OKBOX}
     Selected_Count VIEW-AS TEXT {&AT_OKBOX}
    { adecomm/okform.i
        &BOX    ="SB_Btn_Box"
        &OK     ="btn_Save_Sel"
        &CANCEL ="btn_Cancel"
        &OTHER  ="SPACE( {&HM_BTNG} ) btn_Save_None"
        &HELP   ="btn_Help" 
    }
    WITH OVERLAY NO-LABELS
         VIEW-AS DIALOG-BOX
                 DEFAULT-BUTTON btn_Save_Sel
                 CANCEL-BUTTON  btn_Cancel.
    { adecomm/okrun.i
        &FRAME  = "FRAME FRAME-A"
        &BOX    = "SB_Btn_Box"
        &OK     = "btn_Save_Sel"
        &CANCEL = "btn_Cancel"
        &OTHER  = "btn_Save_None"
        &HELP   = "btn_Help"
    }

ON HELP OF FRAME FRAME-A ANYWHERE
  RUN adeedit/_edithlp.p ( INPUT "Save_Buffers_Dialog_Box" ).
  
ON CHOOSE OF btn_Help IN FRAME FRAME-A
  RUN adeedit/_edithlp.p ( INPUT "Save_Buffers_Dialog_Box" ).

ON VALUE-CHANGED OF Buf_List IN FRAME FRAME-A
DO:
    RUN SelectedCount.
    DISPLAY Selected_Count WITH FRAME FRAME-A.
    
    IF ( hBuf_List:SCREEN-VALUE = "" ) OR ( hBuf_List:SCREEN-VALUE = ? )
    THEN btn_Save_Sel:SENSITIVE IN FRAME FRAME-A = FALSE .
    ELSE btn_Save_Sel:SENSITIVE IN FRAME FRAME-A = TRUE .
END.
  
ON GO OF FRAME FRAME-A
DO:
  p_Save_List = IF    ( hBuf_List:SCREEN-VALUE = ? ) 
                   OR ( hBuf_List:SCREEN-VALUE = "" )
                THEN ""
                ELSE hBuf_List:SCREEN-VALUE .
END.

ON CHOOSE OF btn_Save_None IN FRAME FRAME-A
  p_Save_List = "" .

ON WINDOW-CLOSE OF FRAME FRAME-A
   OR CHOOSE OF btn_Cancel IN FRAME FRAME-A
  p_Save_List = ? .

PROCEDURE SelectedCount .
        Num_Selected =  IF   ( hBuf_List:SCREEN-VALUE = "" ) 
                          OR ( hBuf_List:SCREEN-VALUE = ? )
        THEN "0"
        ELSE STRING( NUM-ENTRIES( hBuf_List:SCREEN-VALUE ) ) .
        Selected_Count = Num_Selected +  List_Items.
END PROCEDURE.  /* SelectedCount */


DO:    /* Main */

  /* ASSIGN RUN TIME ATTRIBUTES */
  ASSIGN
    hBuf_List            = Buf_List:HANDLE IN FRAME FRAME-A
    p_Save_List          = ?
    hBuf_List:LIST-ITEMS = p_Mod_List
    FRAME FRAME-A:TITLE = IF ( p_Title <> "" )
    			     THEN p_Title 
    			     ELSE "Save Changed Buffers"
    .
  
  ENABLE ALL EXCEPT btn_Help WITH FRAME FRAME-A.
  ENABLE btn_Help {&WHEN_HELP} WITH FRAME FRAME-A.

  ASSIGN
    hBuf_List:SCREEN-VALUE = hBuf_List:LIST-ITEMS
    Temp_Bool              = 
            hBuf_List:SCROLL-TO-ITEM( hBuf_List:ENTRY( 1 ) )
    List_Items             = " of " + 
                             STRING( NUM-ENTRIES( p_Mod_List ) ) + 
                             " selected.".
  
  RUN SelectedCount.
  DISPLAY Selected_Count WITH FRAME FRAME-A.
  
  _DLG_SBUF :
  DO ON STOP   UNDO _DLG_SBUF , LEAVE _DLG_SBUF
     ON ENDKEY UNDO _DLG_SBUF , LEAVE _DLG_SBUF
     ON ERROR  UNDO _DLG_SBUF , LEAVE _DLG_SBUF:
     SET Buf_List
	GO-ON( GO , WINDOW-CLOSE, 
               CHOOSE OF btn_Save_None )
        WITH FRAME FRAME-A .
  END.

END.  /* Main */

