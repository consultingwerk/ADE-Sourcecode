/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _getprof.p

Description:
  Allows a user to select a standard progress file using the standard
  system-dialog box.

INPUT  Parameters
  p_title   - The title for the dialog box. [if ? then "Open".]
INPUT-OUTPUT Parameters
  p_imagefile   - The name of the image file. Default file extensions for
  		  progess are supported [.[piw] or .xbm for images.
OUTPUT Parameters
  pressed_ok    - TRUE if user pressed OK, FALSE if user cancelled.

Author: Wm.T.Wood

Date Created: 09/02/92
----------------------------------------------------------------------------*/

DEFINE INPUT        parameter p_title     AS CHAR	   NO-UNDO.
DEFINE INPUT-OUTPUT parameter p_imagefile AS CHAR	   NO-UNDO.
DEFINE       OUTPUT parameter pressed_ok  AS LOGICAL	   NO-UNDO.

&SCOPED-DEFINE Max_Filters 7

DEFINE VAR Filter_NameString AS CHAR EXTENT {&Max_Filters} NO-UNDO.
DEFINE VAR Filter_FileSpec   AS CHAR EXTENT {&Max_Filters} NO-UNDO.

ASSIGN     Filter_NameString[ 1 ] = IF OPSYS = "UNIX":U 
                                      THEN "All Source(*.[piw])"
                                      ELSE "All Source(*.p~;*.i~;*.w)"
           Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX":U
                                      THEN "*.[piw]"
                                      ELSE "*.p~;*.i~;*.w"        
          
           Filter_NameString[ 2 ] = "Procedures(*.p)"
           Filter_FileSpec[ 2 ]   = "*.p"           
          
           Filter_NameString[ 3 ] = "Includes(*.i)"
           Filter_FileSpec[ 3 ]   = "*.i"           
          
           Filter_NameString[ 4 ] = "Windows(*.w)"
           Filter_FileSpec[ 4 ]   = "*.w"           

           Filter_NameString[ 5 ] = IF OPSYS = "UNIX":U 
                                      THEN "Bitmaps/Pixmaps"
                                      ELSE "Images (*.bmp~;*.ico)"
           Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX":U
                                      THEN "*.x[bp]m"
                                      ELSE "*.bmp~;*.ico"          
          
           Filter_NameString[ 6 ] = IF OPSYS = "UNIX":U 
                                      THEN "All Files(*)"
                                      ELSE "All Files(*.*)"
           Filter_FileSpec[ 6 ]   = IF OPSYS = "UNIX":U
                                      THEN "*"
                                      ELSE "*.*"
    . /* END-ASSIGN */          
 
/* Get a good title */
IF p_title = ? THEN p_title = "Open".
 
SYSTEM-DIALOG GET-FILE          p_imagefile
       TITLE                    p_title
       FILTERS                  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
                                Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
                                Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
                                Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
                                Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
                                Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ]
       USE-FILENAME
       UPDATE pressed_ok.
return.
