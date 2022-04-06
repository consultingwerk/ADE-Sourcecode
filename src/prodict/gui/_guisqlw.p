/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _guisqlw.p

Description:
   Set up the Adjust Field Width browser for SQL Properties.  This is used
   to modify the _width field that is used exclusively by SQL-92 client.  
   
Author: Mario Brunetti
Date Created: 02/16/99
    Modified: 05/28/99 Added code to prevent unnecessary repopulation of
                       temp-table & browse widget to avoid unnecessary redraw.
		       Made the query dynamic to facilitate different sorts.
              07/01/99 Mario B. Fine tuning + add SwitchTable button
	      07/28/99 Mario B. Support for array data types. BUG 19990716-033.
	      10/14/99 Mario B. 2k width limit now 31995. BUG 19990825-005.  
          06/10/02 D. McMann Added check for new SESSION attribute schema change.  
-----------------------------------------------------------------------------*/

/*----------------------------- Declarations --------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
   &GLOBAL-DEFINE WIN95-BTN YES
   &SCOPED-DEFINE WINDOW_TITLE "Adjust Field Width"
   &SCOPED-DEFINE WINDOW_MAXIMIZED 1

   DEF VAR RunBrowse    AS    LOG NO-UNDO.
   DEF VAR MethodRetval AS LOG NO-UNDO.
   DEF VAR sort-phrase  AS CHAR EXTENT 2
       INIT ["w_Field._Field-Name", "w_Field._Order"]. 
   
   {adedict/dictvar.i    shared}
   {adedict/menu.i       shared}
   {adedict/uivar.i      shared} 
   {adecomm/cbvar.i      shared} 
   {prodict/gui/widthvar.i shared} 
&ELSE
   {prodict/dictvar.i}  /* Automatically shared in character dictionary */
   {prodict/gui/widthvar.i "new shared"}
   {prodict/gui/widttrig.i}
   {prodict/user/uservar.i}
&ENDIF

/*-------------------- Internal Procedures and Functions --------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

   PROCEDURE StatusBar:

      /* Allocate space for the status bar and create it. */
      ASSIGN s_win_Width:HEIGHT-CHARS = s_win_Width:HEIGHT-CHARS + 1.05.   
      RUN adecomm/_status.p (INPUT s_win_Width, 
                             INPUT "36,36", 
                             INPUT TRUE,
                             INPUT ?,
                             OUTPUT s_StatusLineHdl, 
                             OUTPUT s_StatusLineFlds).  

      ASSIGN s_win_Width:WINDOW-STATE = {&WINDOW_MAXIMIZED}.
   
   END PROCEDURE.     

&ENDIF

FUNCTION NoFields RETURNS LOGICAL ().

   /* Are there any fields to look at in the temp table */
   FIND FIRST w_Field NO-ERROR.
   IF NOT AVAIL w_Field THEN
   DO:

      MESSAGE
         "There are no fields in this table to view."
         SKIP
         "This utility is used exclusively with character, decimal and"
         SKIP
         "all database array data types.  Please choose another table."
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK TITLE "No Fields to Modify".
   END.
   ELSE RETURN FALSE.

   RETURN TRUE.
   
END FUNCTION.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/* -------------------- A Local Trigger AND --------------------------------*/
/* This is a good example of how code gets convoluted after a short time    *
 * if it is not re-designed from scratch.  This was an afterthought.  It    *
 * couldn't go in the trigger procedure because user_path isn't at that     *
 * level.  And so it goes...                                                */
ON CHOOSE of s_btn_Switch IN FRAME frm-width
DO:
   user_path = "1=,_usrtget,19=alpha,_guisqlw".
   IF rowsModified THEN
      MESSAGE "Save changes to this table first?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Rows Modified"
      UPDATE saveCurr.
   IF saveCurr THEN
   DO:
      saveCurr = YES.
      APPLY "GO" TO FRAME frm-width.
   END.
   ELSE
      APPLY "END-ERROR" TO FRAME frm-width.
END.
&ENDIF

/*--------------------------- Mainline code ---------------------------------*/

DO ON ERROR UNDO, LEAVE
   ON STOP UNDO, LEAVE:

   find _File where _File._File-name = "_Field"
                and _File._Owner = "PUB" NO-LOCK.
   if NOT can-do(_File._Can-read, USERID("DICTDB")) THEN do:
      message s_NoPrivMsg "see field definitions."
         view-as ALERT-BOX ERROR buttons Ok
	   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
            in window s_win_Browse
       &ENDIF
	 .
     return.
   end.
   IF SESSION:SCHEMA-CHANGE = "New Objects" THEN DO:
     MESSAGE 'You can not change field width when SESSION:SCHEMA-CHANGE = "New Objects".'
       VIEW-AS ALERT-BOX ERROR.
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       ASSIGN user_path = "".
     &ENDIF
     RETURN.
   END.
   
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   s_btn_Close:LABEL IN FRAME frm-width = "Cancel".
   CREATE QUERY qry-width-hdl.   
&ELSE  /* GUI  Only Code */
IF s_win_Width = ? THEN  
   DO:
      /* Don't want Cancel if moving to next table - only when window opens */
      s_btn_Close:label in frame frm-width = "Cancel". 
      /* Open the window if necessary */
      run adedict/_openwin.p
         (INPUT        {&WINDOW_TITLE},
          INPUT        frame frm-width:HANDLE,
          INPUT        {&OBJ_WIDTH},
          INPUT-OUTPUT  s_win_Width).

      /* Clear out the old buffer data that might still be around.        *
       * Need this to make sure refresh code below works right.           */
      FOR EACH w_Field:
         DELETE w_Field.
      END.
      
      CREATE QUERY qry-width-hdl.
      IF FRAME frm-width:PRIVATE-DATA <> "alive" THEN 
      DO:
         ASSIGN
            FRAME frm-width:PARENT       = s_win_Width
            s_win_Width:PARENT           = s_win_Browse 
            frame frm-width:private-data = "alive"
            s_win_Width:WIDTH            = s_win_Width:width + 1.

         {adecomm/okrun.i
            &FRAME  = "frame frm-width"
            &OK     = "s_btn_OK"
            &HELP   = "s_btn_Help"
            &OTHER  = "s_btn_Close
                       s_btn_Prev 
                       s_btn_Next"
            &CANCEL = s_btn_Save  
            
            &OKBOX  = NO
         }
         
         RUN StatusBar IN THIS-PROCEDURE.
      END.
      ELSE
         RUN StatusBar IN THIS-PROCEDURE.
   END.

   /* Determine if screen needs refresh or if someone just selected *
    * the menu to bring it to the forground again, or changed sort. */
   IF s_PreviousSort = s_Order_By THEN
   check-tbl:
   REPEAT:
      FIND NEXT w_Field WHERE w_Field._File-Recid = s_TblRecId NO-ERROR.
         FIND _Field WHERE
              _Field._File-Recid = w_Field._File-Recid AND
              _Field._Field-Name = w_Field._Field-NAME NO-ERROR.
         IF AVAIL w_Field AND AVAIL _Field AND
   	    _Field._Width <> w_Field._Width THEN LEAVE check-tbl.

         /* If we get this far, then nothing has changed and we just need *
          * to bring the window into focus.  We use this method to return *
          * to the currently focused row.  But first make sure we haven't *
          * changed tables in case w_Field was empty and that put us here.*/
          IF s_PreviousTbl <> s_CurrTbl THEN LEAVE check-tbl.

         /* Make sure we have at least one row before trying to select   *
          * it.  else, just apply entry to the OK button                 */
         FIND FIRST w_Field NO-ERROR.
         IF AVAIL w_Field THEN
            MethodRetval = brw-width:SELECT-FOCUSED-ROW().
         IF NOT (s_DB_ReadOnly OR s_Fld_ReadOnly) THEN
            APPLY "entry" TO s_btn_OK IN FRAME frm-width.
         ELSE
            APPLY "entry" TO s_btn_Close IN FRAME frm-width.

	 /* If we get this far, nothing's changed.  We've applied focus.  We *
	  * can go b-bye now.                                                */
         RETURN.

   END.
   
   ASSIGN
      s_PreviousTbl  = s_CurrTbl
      s_PreviousSort = s_Order_By 
      MethodRetval = NO.
          
   RUN adedict/_brwgray.p (INPUT NO).
   
&ENDIF
    
   /* Re-populate the temp-table.  Yes this could be a repeat of what was *
    * done above for GUI, but it always needs to be done and won't hurt   *
    * if it turns out it is unncessary.                                   */
   IF qry-width-hdl:IS-OPEN THEN
      qry-width-hdl:QUERY-CLOSE.

   FOR EACH w_Field:
      DELETE w_Field.
   END.

   qry-width-hdl:SET-BUFFERS(BUFFER w_field:HANDLE).
   
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   FIND _File WHERE RECID(_File) = drec_file NO-LOCK NO-ERROR. 
&ELSE
   FIND _FIle WHERE RECID(_File) = s_TblRecId NO-LOCK NO-ERROR. 
&ENDIF
   IF AVAIL _File THEN
      FOR EACH _Field OF _File WHERE 
         LOOKUP(_Field._Data-Type,"character,decimal,raw") > 0 OR
         _Field._Extent > 0: 

         CREATE w_Field.
         BUFFER-COPY _Field TO w_Field.
      END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
   b-test = qry-width-hdl:QUERY-PREPARE("FOR EACH w_field").

&ELSE
   b-test = qry-width-hdl:QUERY-PREPARE("FOR EACH w_field" + " BY " +
            sort-phrase[s_Order_By]).
&ENDIF

ASSIGN
   b-test = qry-width-hdl:QUERY-OPEN.
   BROWSE brw-width:QUERY = qry-width-hdl.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN

   IF NoFields() THEN
   DO:
       user_path = "1=,_usrtget,19=alpha,_guisqlw".
       RETURN.
   END.
    
   FIND _File WHERE RECID(_File) = drec_file NO-LOCK NO-ERROR.
   IF _File._Frozen THEN
   ASSIGN
      BROWSE brw-width:READ-ONLY = TRUE
      s_btn_Close:LABEL          = "Close".
      
   UPDATE brw-width 
          s_btn_Save  WHEN NOT _File._Frozen
          s_btn_OK    WHEN NOT _File._Frozen
          s_btn_Close
	  s_btn_Switch
   WITH FRAME frm-width NO-ERROR.

   HIDE FRAME frm-width NO-PAUSE.
&ELSE

  ENABLE brw-width 
          s_btn_Save 
          s_btn_OK 
          s_btn_Close 
          s_btn_Prev 
          s_btn_Next 
          s_btn_Help 
   WITH FRAME frm-width IN WINDOW s_win_Width. 

   ASSIGN s_StatusLineHdl:VISIBLE = TRUE.
   
   RUN adecomm/_statdsp.p (INPUT s_StatusLineHdl, 1, "Database: " + s_CurrDb).
   RUN adecomm/_statdsp.p (INPUT s_StatusLineHdl, 2, "Table: " + s_CurrTbl).
                                
   /* Is this a read only DB, table or session */
   FIND _File WHERE RECID(_File) = s_TblRecId NO-LOCK NO-ERROR.
   ASSIGN
      s_Fld_ReadOnly = (S_ReadOnly OR s_DB_ReadOnly)
      s_Fld_ReadOnly = (IF AVAIL _File AND _File._Frozen THEN
                           TRUE
			ELSE
			   s_Fld_ReadOnly).
   IF (s_DB_ReadOnly OR s_Fld_ReadOnly) THEN
      ASSIGN
         BROWSE brw-width:READ-ONLY = TRUE
         s_btn_Save:SENSITIVE       = FALSE
         s_btn_OK:SENSITIVE         = FALSE
         s_btn_Close:LABEL          = "Close".
   ELSE /* Might be coming back from readonly to not readonly */
      ASSIGN
         s_btn_Close:LABEL          = "Cancel"
	 BROWSE brw-width:READ-ONLY = FALSE.

   NoFields(). 
   
   APPLY "entry" TO s_btn_OK IN FRAME frm-width.
   
&ENDIF

END.

