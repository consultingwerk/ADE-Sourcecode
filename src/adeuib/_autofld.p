/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _autofld.p
                                       
    Purpose:    A UIB XFTR designed to automatically invoke the table/field
                picker upon openning a window into the UIB (from a template 
                containing this XFTR. 
                
                It automatically destroys itself so that it only
                comes up the first time.

    Parameters: trg-recid - the recid of the XFTR section
                trg-code  - the code block itself 

    Notes  :Note that it does not run itself if the procedure is being
                opened AS A TEMPLATE.
                
                This was originally developed for use in ADM SmartViewers
                (although it can be used anyplace). 

    Authors: Gerry Seidl
    Date   : 4/5/95
**************************************************************************/
{adeuib/sharvars.i}   
{adeuib/triggers.i}
DEFINE INPUT PARAMETER trg-recid       AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-code AS CHARACTER NO-UNDO.

DEFINE VARIABLE cResult  AS CHAR   NO-UNDO.
DEFINE VARIABLE fcontext AS CHAR   NO-UNDO.
DEFINE VARIABLE flist    AS CHAR   NO-UNDO.
DEFINE VARIABLE ctmp     AS CHAR   NO-UNDO.
DEFINE VARIABLE hframe   AS HANDLE NO-UNDO.


IF TRIM(trg-code) = "/* Destroy on next read */" THEN
  RUN adeuib/_accsect.p("DELETE",?,?,INPUT-OUTPUT trg-recid,INPUT-OUTPUT trg-code).
ELSE DO:
  /* Is this being run in a TEMPLATE.  If so, then don't bother doing 
     anything. */
  RUN adeuib/_uibinfo.p (trg-recid, ?, "TEMPLATE", OUTPUT cResult).
  IF cResult NE STRING(yes) THEN DO:
    /* Get context of frame */
    RUN adeuib/_uibinfo.p(?, "WINDOW ?", "CONTAINS FRAME RETURN CONTEXT", OUTPUT flist).
    IF NUM-ENTRIES(flist) > 1 THEN RUN Get_Frame (OUTPUT ctmp).
    IF ctmp = ? THEN RETURN.    
    /* Get handle of the frame */
    ELSE RUN adeuib/_uibinfo.p(INT(flist), ?, "HANDLE", OUTPUT ctmp).
    ASSIGN hframe = WIDGET-HANDLE(ctmp)
           _frmx = 0
           _frmy = 0
           _second_corner_x = hframe:WIDTH-P
           _second_corner_y = hframe:HEIGHT-P.  
    RUN choose_import_fields in _h_UIB.
    ASSIGN trg-code = "/* Destroy on next read */".
  END.
END.
RETURN.

PROCEDURE Get_Frame:
  DEFINE OUTPUT PARAMETER h     AS CHAR NO-UNDO INITIAL ?.
  
  DEFINE VARIABLE s_frames AS CHARACTER VIEW-AS SELECTION-LIST SIZE 40 BY 5 NO-UNDO.
  DEFINE BUTTON b_ok     LABEL "OK"     AUTO-GO     SIZE 10 BY 1 DEFAULT.
  DEFINE BUTTON b_cancel LABEL "Cancel" AUTO-ENDKEY SIZE 10 BY 1.
  
  FORM SKIP(0.5) s_frames at 3 SKIP(0.5) b_ok AT 12 b_cancel SKIP(0.5) 
      WITH FRAME f_frames NO-LABELS THREE-D  DEFAULT-BUTTON b_ok
      VIEW-AS DIALOG-BOX TITLE "Choose a frame to draw fields onto"
      SIZE 46 BY 9.0.
  
  ON DEFAULT-ACTION OF s_frames DO:
      APPLY "GO" TO FRAME f_frames.
  END.
  
  ON GO OF FRAME f_frames DO:
    ASSIGN s_frames.
    RUN adeuib/_uibinfo.p(?, s_frames, "HANDLE", OUTPUT h).   
  END.  
    
  ASSIGN s_frames:SCROLLBAR-VERTICAL   = yes
         s_frames:SCROLLBAR-HORIZONTAL = yes
         s_frames:LIST-ITEMS           = flist
         s_frames:SCREEN-VALUE         = s_frames:ENTRY(1).
    
  ENABLE s_frames b_ok b_cancel WITH FRAME f_frames. 
  WAIT-FOR GO OF FRAME f_frames.
END PROCEDURE.  
