/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* std_uf.i :  standard settings for _U and _F records.  These apply to     */
/*             all field-level widgets                                      */
/* Inputs   : SECTION - define which section to use.  The valid sections    */
/*                      are:                                                */
/*                      DRAW-SETUP - use to setup a new _U/_F in _drwXXXX.p */
/*                      These sections are used in the _undXXXX.p           */
/*                      HANDLES    - sets the _U.handle variables and also  */
/*                                   sets _h_cur_widg                       */
/*                      GEOMETRY   - get the geometry from the _U._HANDLE   */
    &IF "{&SECTION}" = "DRAW-SETUP" &THEN 
       _U._x-recid           = RECID(_F)
       _F._AUTO-RESIZE       = FALSE     
       _F._UNDO              = FALSE
    &ENDIF
       /* Standard U/L records */
       {adeuib/std_ul.i &SECTION = "{&SECTION}"}
