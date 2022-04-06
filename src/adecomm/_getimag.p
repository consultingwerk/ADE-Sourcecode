/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _getimag.p

Description:
  Allows a user to select an image file as a standard dialog box.

INPUT Parameters
  p_filter   - special cases.  The only non-blank case will be
                  ICON which is used to show only the .ico files under Windows.
                  
INPUT-OUTPUT Parameters
  p_imagefile   - The name of the image file. Default file extensions for
  		  progess bitmaps (eg. ".xbm" on Motif and ".bmp" or ".ico"
  		  on Windows are not returned.
  icon_dir      - THe directory the look for the icons. Can be unknown.
                  the directory will not be changed if the user
                  cancels out of the dialog box.
OUTPUT Parameters
  pressed_ok    - TRUE if user pressed OK, FALSE if user cancelled.

Author: Wm.T.Wood

Date Created: 09/02/92
----------------------------------------------------------------------------*/

DEFINE INPUT        parameter p_filter    AS CHAR	   NO-UNDO.
DEFINE INPUT-OUTPUT parameter p_imagefile AS CHAR	   NO-UNDO.
DEFINE INPUT-OUTPUT parameter icon_dir    AS CHAR          NO-UNDO.
DEFINE       OUTPUT parameter pressed_ok  AS LOGICAL	   NO-UNDO.

DEFINE VAR filename AS CHAR                                NO-UNDO.

DEFINE VAR delim    AS CHAR				   NO-UNDO.

IF OPSYS  = "UNIX"
THEN
	delim = "/".
ELSE
        delim = "~\~\".

/* Make sure the filename is valid (by using the search command) */
filename = SEARCH (p_imagefile).

IF OPSYS = "UNIX"
THEN SYSTEM-DIALOG GET-FILE    filename
       TITLE                   "Image File"
       FILTERS                 "Motif Bitmaps" "*.x[bp]m"
       DEFAULT-EXTENSION       ".xbm"
       INITIAL-DIR             icon_dir
       MUST-EXIST
       USE-FILENAME
       RETURN-TO-START-DIR
       UPDATE pressed_ok.
ELSE IF p_filter eq "ICON" 
THEN SYSTEM-DIALOG GET-FILE    filename
       TITLE                   "Image File"
       FILTERS                 "Icons (*.ico)"	        "*.ico",
                               "All Files (*.*)" 	"*.*"
       INITIAL-FILTER          0
       DEFAULT-EXTENSION       ".bmp"
       INITIAL-DIR             icon_dir
       MUST-EXIST
       USE-FILENAME
       RETURN-TO-START-DIR
       UPDATE pressed_ok.
ELSE SYSTEM-DIALOG GET-FILE    filename
       TITLE                   "Image File"
       FILTERS                 "Images (*.bmp~;*.ico)"	"*.bmp~;*.ico",
                               "Bitmaps Only (*.bmp)"  	"*.bmp",
                               "Icons Only (*.ico)"    	"*.ico",
                               "All Files (*.*)" 	"*.*"
       INITIAL-FILTER          0
       DEFAULT-EXTENSION       ".bmp"
       INITIAL-DIR             icon_dir
       MUST-EXIST
       USE-FILENAME
       RETURN-TO-START-DIR
       UPDATE pressed_ok.
    

/* Change the icondir, if the user did not abort */
IF pressed_ok THEN DO:
  /* Return the guts of the chosen value */
  p_imagefile = TRIM(filename).
        
  /* Base the icon dir off the name. Strip off the name
   * and return the directory.
   */
  icon_dir = SUBSTRING(p_imagefile,1,R-INDEX(p_imagefile,delim),"CHARACTER":u).
END.

RETURN.

/* _getimag.p - end of file */

