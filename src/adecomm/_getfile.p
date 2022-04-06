/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _getfile.p

Description:
    This is the ADE version of the SYSTEM-DIALOG GET-FILE call.
    
    It provides one level of indirection to the SYSTEM-DIALOG in case a 
    ADE user/developer wants to intercept OPEN/SAVEs from ADE applications
    where the source code is not provided.
    
    Not all ADE tools use _getfile.p (because their source code is provided
    and a developer can add custom hooks).  
    
    By modifying _getfile.p, you can intercept or filter all file/open
    or file/save as... actions.  By looking at the combination of input
    parameters p_product and p_action, you can find out the condition that
    this file is requested for: eg.
        p_product = "uib"  p_action = "Save As"
        
    In certain cases this procedure changes the file-filters used by the 
    SYSTEM-DIALOG.  The special cases are for 
       p_product = "uib" and 
                   p_action          Look For
                   ---------         --------
                   "Open"               *.w;*.p;*.i
                   "Insert from File"   *.wx
                   "Copy to File"       *.wx
    
Input Parameters:
    p_Window  : Window in which to display the dialog box.
    p_product : The ADE product code.  eg. "uib" for the UIB, or "Procedure"
                for the Procedure Window.
    p_action  : A string indicating what the intent of this call is.
                eg.  "Open", "Save As", "Export As"
                [This is often identical to the p_title for the dialog].
    p_title   : The title to use for the system-dialog.
    p_mode    : "OPEN" or "SAVE".  This determines which version of
                SYSTEM-DIALOG to use:
                    p_mode  Options
                    ------  -------
                    OPEN -> MUST-EXIT
                    SAVE -> SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE

Input-Output Parameters:
    p_filename: The filename to use as the default, and to return.

Output Parameters:
    p_ok      : TRUE if user successfully choose a file name (the result of the
                SYSTEM-DIALOG GET-FILE...UPDATE p_ok.
   
Side Effects:
    <none>
    
Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992

----------------------------------------------------------------------------*/

DEFINE INPUT        PARAMETER p_Window   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT        PARAMETER p_product  AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_action   AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_title    AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_mode     AS CHAR    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_filename AS CHAR    NO-UNDO.
DEFINE       OUTPUT PARAMETER p_ok       AS LOGICAL NO-UNDO.

DEFINE VAR    cScrap            AS CHAR  INITIAL ?       NO-UNDO.
DEFINE VAR    Filter_NameString AS CHAR  EXTENT 7        NO-UNDO.
DEFINE VAR    Filter_FileSpec   LIKE Filter_NameString   NO-UNDO.
DEFINE VAR    File_Ext          AS CHAR                  NO-UNDO.
DEFINE VAR    lWebLicense       AS LOGICAL               NO-UNDO.

IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
    RUN adeuib/_uibinfo.p (?, "SESSION":U, "ABLicense":U, OUTPUT cScrap) NO-ERROR.
IF cScrap ne ? AND cScrap ne "" THEN 
  lWebLicense = cScrap gt "1":U.

/* Initialize the file filters, for special cases. */
IF p_product = "UIB" THEN
DO:
  CASE p_action:
    WHEN "Open":U OR WHEN "Save":U OR WHEN "Save As":U THEN DO:
      ASSIGN
         Filter_NameString[ 2 ] = "Windows(*.w)"
         Filter_FileSpec[ 2 ]   = "*.w"
         Filter_NameString[ 3 ] = "Procedures(*.p)"
         Filter_FileSpec[ 3 ]   = "*.p"
         Filter_NameString[ 4 ] = "Includes(*.i)"
         Filter_FileSpec[ 4 ]   = "*.i"
         Filter_NameString[ 5 ] = "XML Schema(*.xmc~;*.xmp~;*.xsd)"
         Filter_FileSpec[ 5 ]   = "*.xmc~;*.xmp~;*.xsd".
         
      IF lWebLicense THEN
        ASSIGN
           Filter_NameString[ 1]  = "All Source(*.w~;*.p~;*.i;*.htm*;*.x*)"
           Filter_FileSpec[ 1 ]   = "*.w~;*.p~;*.i;*.htm*;*.x*"
           Filter_NameString[ 6 ] = "HTML(*.htm*)"
           Filter_FileSpec[ 6 ]   = "*.htm*"
           Filter_NameString[ 7 ] = "All Files(*.*)"
           Filter_FileSpec[ 7 ]   = "*.*".
      ELSE
        ASSIGN
           Filter_NameString[ 1]  = "All Source(*.w~;*.p~;*.i)"
           Filter_FileSpec[ 1 ]   = "*.w~;*.p~;*.i"
           Filter_NameString[ 6 ] = "All Files(*.*)"
           Filter_FileSpec[ 6 ]   = "*.*".
    END.
         
    WHEN "Insert from File" OR WHEN "Copy to File" THEN
      ASSIGN
        Filter_NameString[ 1 ] = "Export(*.wx)"
        Filter_FileSpec[ 1 ]   = "*.wx"
        Filter_NameString[ 2 ] = "Windows(*.w)"
        Filter_FileSpec[ 2 ]   = "*.w" 
        Filter_NameString[ 3 ] = "Procedures(*.p)"
        Filter_FileSpec[ 3 ]   = "*.p"
        Filter_NameString[ 4 ] = "All Source(*.w~;*.p~;*.i)"
        Filter_FileSpec[ 4 ]   = "*.w~;*.p~;*.i"
        Filter_NameString[ 5 ] = "All Files(*.*)"
        Filter_FileSpec[ 5 ]   = "*.*".
         
    OTHERWISE p_product = ?. 
  END CASE.
END.
ELSE IF p_product = "TTYRESULTS" THEN
  ASSIGN
         Filter_NameString[ 1 ] = "Configuration Files(*.qc)"
         Filter_FileSpec[ 1 ]   = "*.qc".
ELSE IF p_product = "TTYRESULTSQD" THEN
  ASSIGN
         Filter_NameString[ 1 ] = "Query Directory Files(*.qd)"
         Filter_FileSpec[ 1 ]   = "*.qd".
ELSE IF p_product = "PROSPY" THEN
  ASSIGN
         Filter_NameString[ 1 ] = "Log Files(*.log)"
         Filter_FileSpec[ 1 ]   = "*.log".
ELSE IF p_product = "XMLMAPPING" THEN
  ASSIGN
         Filter_NameString[ 1 ] = "XML Schema(*.xmc~;*.xmp~;*.xsd)"
         Filter_FileSpec[ 1 ]   = "*.xmc~;*.xmp~;*.xsd"
         Filter_NameString[ 2 ] = "All Files(*.*)"
         Filter_FileSpec[ 2 ]   = "*.*".
ELSE p_product = ?. 

/* If p_product is UNKNOWN, then use the default case */
IF p_product eq ? THEN DO:
  ASSIGN
         Filter_NameString[ 2 ] = "Procedures(*.p)"
         Filter_FileSpec[ 2 ]   = "*.p"
         Filter_NameString[ 3 ] = "Windows(*.w)"
         Filter_FileSpec[ 3 ]   = "*.w"
         Filter_NameString[ 4 ] = "Includes(*.i)"
         Filter_FileSpec[ 4 ]   = "*.i".
         
  IF lWebLicense AND p_Window:PRIVATE-DATA = "_ab.p":U THEN
    ASSIGN
           Filter_NameString[ 1]  = "All Source(*.p~;*.w~;*.i;*.htm*;*.x*~;*.cls)"
           Filter_FileSpec[ 1 ]   = "*.p~;*.w~;*.i~;*.htm*~;*.x*~;*.cls"
           Filter_NameString[ 5 ] = "HTML(*.htm*)"
           Filter_FileSpec[ 5 ]   = "*.htm*"
           Filter_NameString[ 6 ] = "Classes(*.cls)"
           Filter_FileSpec[ 6 ]   = "*.cls"
           Filter_NameString[ 7 ] = "All Files(*.*)"
           Filter_FileSpec[ 7 ]   = "*.*".
  ELSE
    ASSIGN
           Filter_NameString[ 1]  = "All Source(*.p~;*.w~;*.i~;*.cls)"
           Filter_FileSpec[ 1 ]   = "*.p~;*.w~;*.i~;*.cls"
           Filter_NameString[ 5 ] = "Classes(*.cls)"
           Filter_FileSpec[ 5 ]   = "*.cls"
           Filter_NameString[ 6 ] = "All Files(*.*)"
           Filter_FileSpec[ 6 ]   = "*.*".
END.
         
/* If not specified, display dialog in active-window. */
IF NOT VALID-HANDLE( p_Window ) THEN ASSIGN p_Window = ACTIVE-WINDOW.

REPEAT ON STOP UNDO, LEAVE:

/* File-names to open must exist */                          
IF p_mode EQ "OPEN" THEN
DO:
     SYSTEM-DIALOG GET-FILE p_filename
      TITLE    p_title 
      FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
               Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
               Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
               Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
               Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
               Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ],
               Filter_NameString[ 7 ]   Filter_FileSpec[ 7 ]
      MUST-EXIST
      UPDATE   p_ok IN WINDOW p_Window.
     IF p_ok <> TRUE THEN LEAVE.
     RUN adecomm/_valpnam.p
        (INPUT  p_filename, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
         OUTPUT p_ok).
     IF p_ok = TRUE THEN LEAVE.
END.
/* File-names to save must be writeable */
ELSE
DO:
    /* Set DEFAULT-EXTENSION and the Filters appropriately. */
    RUN SetDefaultExt.
    
    SYSTEM-DIALOG GET-FILE p_filename
     TITLE   p_title
     FILTERS Filter_NameString[ 1 ]  Filter_FileSpec[ 1 ],
             Filter_NameString[ 2 ]  Filter_FileSpec[ 2 ],
             Filter_NameString[ 3 ]  Filter_FileSpec[ 3 ],
             Filter_NameString[ 4 ]  Filter_FileSpec[ 4 ],
             Filter_NameString[ 5 ]  Filter_FileSpec[ 5 ],
             Filter_NameString[ 6 ]  Filter_FileSpec[ 6 ]
     SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE
             DEFAULT-EXTENSION File_Ext
     UPDATE  p_ok IN WINDOW p_Window.

    IF p_ok <> TRUE THEN LEAVE.
    RUN adecomm/_valpnam.p
       (INPUT  p_filename, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
        OUTPUT p_ok).
    IF p_ok = TRUE THEN LEAVE.
END.
END. /* DO ON STOP */

PROCEDURE SetDefaultExt.

    /* Use the filename's extension as the default extension. */
    RUN adecomm/_osfext.p
        (INPUT  p_filename , OUTPUT File_Ext ).

    /* Now change the filters as needed to place the file's extension first
       if the All Source filter is present. This makes the GET-FILE call
       work with DEFAULT-EXTENSION. */
    IF Filter_NameString[ 1 ] BEGINS "All Source"
       AND NOT Filter_FileSpec[ 1 ] BEGINS "*" + File_Ext THEN
    DO:
        /* What we're doing here is moving the File_Ext to the beginning of the
           All Source list for the NameString and the FileSpec. */
        ASSIGN 
            Filter_NameString[ 1 ] =
                REPLACE(Filter_NameString[ 1 ], Filter_FileSpec[ 1 ], "_REMOVE":U)
            Filter_FileSpec[ 1 ] =
                ("*" + File_Ext + ";") +
                 REPLACE(Filter_FileSpec[ 1 ] , "*" + File_Ext, "")
            Filter_FileSpec[ 1 ] = TRIM(REPLACE(Filter_FileSpec[ 1 ], "~;~;", "~;"), "~;").

        ASSIGN 
            Filter_NameString[ 1 ] =
                REPLACE(Filter_NameString[ 1 ] , "_REMOVE":U, Filter_FileSpec[ 1 ]).
    END.
END PROCEDURE.
