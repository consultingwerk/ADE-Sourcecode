/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _drwqry.p

Description:
   Procedure to create a query.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Gerry Seidl

Date Created: 3/26/1995

----------------------------------------------------------------------------*/
{adeuib/uniwidg.i}
{adeuib/layout.i}
{adeuib/sharvars.i}

DEFINE VAR cur-lo   AS CHAR NO-UNDO.

DEFINE BUFFER parent_U FOR _U.
DEFINE BUFFER parent_L FOR _L.

FIND _U WHERE _U._HANDLE = _h_win.

/* Define the minimum size of a widget. If the user clicks smaller than this 
   then use the default size.  */
&Scoped-define min-height-chars 0.2
&Scoped-define min-cols 0.4

/* Get the RECIDs of the parent frame (or window). */
IF VALID-HANDLE(_h_frame)
THEN FIND parent_U WHERE parent_U._HANDLE eq _h_frame.
ELSE FIND parent_U WHERE parent_U._HANDLE eq _h_win.
FIND parent_L WHERE RECID(parent_L)  = parent_U._lo-recid.
ASSIGN cur-lo = parent_U._LAYOUT-NAME.

/* Handle the case when the dictionary is busy */
DO TRANSACTION ON STOP UNDO,LEAVE:
  /* Create a Universal Widget Record and populate it as much as possible. */
  CREATE _U.
  CREATE _L.
  CREATE _C.
  CREATE _Q.
  
  ASSIGN /* TYPE-specific settings */
         _U._NAME             = "QUERY":U
         _U._TYPE             = "QUERY":U
         _U._LABEL            = ? /* Fill this in later if custom widgets do not */
         _U._WINDOW-HANDLE    = _h_win
         _C._q-recid          = RECID(_Q)
         _Q._OpenQury         = NO         /* Not opened */
         _U._x-recid          = RECID(_C)
         /* Standard Settings for Universal and Layout records */
         { adeuib/std_ul.i &SECTION = "DRAW-SETUP" }
         .
    
  /* Are there any custom widget overrides?                               */
  IF _custom_draw ne ? THEN RUN adeuib/_usecust.p (_custom_draw, RECID(_U)).
  
  /* Check the name for uniqueness.  Base any new name on the TYPE. */
  RUN adeshar/_bstname.p (INPUT  _U._NAME, _U._TYPE, ?, ?,  parent_U._WINDOW-HANDLE,
                          OUTPUT _U._NAME).
  
  /* Create the Visualization of the Query object */
  RUN adeuib/_undqry.p (RECID(_U)).
END.

/* Call the Query Builder so that the user can define the query */
RUN adeuib/_callqry.p ("_U":U, RECID(_U), "QUERY-ONLY":U).

/* FOR EACH layout other than the current layout, populate _L records for them */
{adeuib/multi_l.i}
