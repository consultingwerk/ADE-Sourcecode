/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

    Procedure  :  psysgetf.i

    Syntax     :
                  { adeedit/psysgetf.i }

    Description:

        Generic GET-FILE Procedures. Eg, File Open, File Save As, etc...
        dialog boxes.

    Notes     : Definition file is dsysgetf.i .

    Author    : John Palazzo
    Date      : 02.09.93

*****************************************************************************/

PROCEDURE SysGetFile .
  /*---------------------------------------------------------------------
    Purpose : Runs the appropriate Get-File (Open or Save As) dialog box,
              and returns the file spec and dialog status (ie, did user
              press OK or Cancel?)

    Syntax  :
    
        RUN SysGetFile 
            ( INPUT p_Title ,
              INPUT p_Save_As ,
              INPUT p_Initial_Filter ,
              INPUT-OUTPUT p_File_Spec ,
              OUTPUT p_Return_Status ) .
  ---------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Title            AS CHAR    NO-UNDO.
  DEFINE INPUT  PARAMETER p_Save_As          AS LOGICAL NO-UNDO.
  DEFINE INPUT  PARAMETER p_Initial_Filter   AS INTEGER INIT 1 NO-UNDO .
  DEFINE INPUT-OUTPUT PARAMETER p_File_Spec  AS CHAR    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Return_Status    AS LOGICAL INIT FALSE NO-UNDO.

  DEFINE VARIABLE vOptions     AS CHAR NO-UNDO.
  DEFINE VARIABLE vInitial_Dir AS CHAR NO-UNDO.

  DO: /* Main */
  /*------------------------------------------------------------ 
     If nothing passed for Title, use one of the defaults. 
  ------------------------------------------------------------*/
  IF ( TRIM( p_Title ) = "" ) THEN
      ASSIGN p_Title = IF ( p_Save_As = TRUE )
                       THEN "Save As"
                       ELSE "Open".
  
  RUN InitFilters.
  
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN
  DO:
    REPEAT ON STOP UNDO, LEAVE:
      IF ( p_Save_As = YES ) THEN
      DO:
        SYSTEM-DIALOG GET-FILE p_File_Spec
        FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
                 Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
                 Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
                 Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
                 Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
                 Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ]
        INITIAL-FILTER p_Initial_Filter
        SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE
        TITLE p_Title UPDATE p_Return_Status IN WINDOW ACTIVE-WINDOW.
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
      END.
      ELSE  /* Open Dialog */
      DO:
        SYSTEM-DIALOG GET-FILE p_File_Spec
        FILTERS  Filter_NameString[ 1 ]   Filter_FileSpec[ 1 ],
                 Filter_NameString[ 2 ]   Filter_FileSpec[ 2 ],
                 Filter_NameString[ 3 ]   Filter_FileSpec[ 3 ],
                 Filter_NameString[ 4 ]   Filter_FileSpec[ 4 ],
                 Filter_NameString[ 5 ]   Filter_FileSpec[ 5 ],
                 Filter_NameString[ 6 ]   Filter_FileSpec[ 6 ]
        INITIAL-FILTER p_Initial_Filter
        MUST-EXIST 
        TITLE p_Title UPDATE p_Return_Status IN WINDOW ACTIVE-WINDOW.
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
      END.
    END. /* ON STOP */
  END.
  ELSE DO:
     ASSIGN vOptions = "ASK-OVERWRITE,MUST-EXIST" .
     
     /* Its possible that p_File_Spec is a dir name, so try and
        use it as the p_Dir name (pass in) and blank out the
        p_File_Spec. */
     ASSIGN vInitial_Dir = p_File_Spec
            p_File_Spec  = "".

    REPEAT ON STOP UNDO, LEAVE:
      RUN adecomm/_filecom.p
        ( INPUT "" /* p_Filter */, 
          INPUT vInitial_Dir /* p_Dir */ , 
          INPUT "" /* p_Drive */ ,
          INPUT p_Save_As ,  
          INPUT p_Title ,
          INPUT vOptions , 
          INPUT-OUTPUT p_File_Spec ,
          OUTPUT p_Return_Status ).
        IF p_Return_Status <> TRUE THEN LEAVE.
        RUN adecomm/_valpnam.p
            (INPUT  p_File_Spec, INPUT YES /* Show Msg */, INPUT "_EXTERNAL":U,
             OUTPUT p_Return_Status).
        IF p_Return_Status = TRUE THEN LEAVE.
    END.
  END.

  END. /* Main */
END PROCEDURE.


PROCEDURE InitFilters.
/*----------------------------------------------------------------------------
Syntax:
        RUN InitFilters.

Description:

  Initializes the File Filters for SYSTEM-DIALOG GET-FILE.

Author: John Palazzo

Date Created: 08.14.92
----------------------------------------------------------------------------*/

  DEFINE VARIABLE List_Pos AS INTEGER NO-UNDO.

    ASSIGN Filter_NameString[ 1 ] = IF OPSYS = "UNIX"
                                      THEN "All Source(*.[piw])"
                                      ELSE "All Source(*.p~;*.i~;*.w)"
           Filter_FileSpec[ 1 ]   = IF OPSYS = "UNIX"
                                      THEN "*.[piw]"
                                      ELSE "*.p~;*.i~;*.w"

           Filter_NameString[ 2 ] = "Procedures(*.p)"
           Filter_FileSpec[ 2 ]   = "*.p"

           Filter_NameString[ 3 ] = "Includes(*.i)"
           Filter_FileSpec[ 3 ]   = "*.i"

           Filter_NameString[ 4 ] = "Windows(*.w)"
           Filter_FileSpec[ 4 ]   = "*.w"

           Filter_NameString[ 5 ] = IF OPSYS = "UNIX"
                                      THEN "All Files(*)"
                                      ELSE "All Files(*.*)"
           Filter_FileSpec[ 5 ]   = IF OPSYS = "UNIX"
                                      THEN "*"
                                      ELSE "*.*"
    . /* END-ASSIGN */

    DO List_Pos = 1 TO 6:
      Filter_Desc    = Filter_Desc + Filter_NameString[ List_Pos ] +
                       IF List_Pos = 6
                         THEN ","
                         ELSE "".  /* Omit last comma in list */
      Filter_Pattern = Filter_Pattern + Filter_FileSpec[ List_Pos ] +
                       IF List_Pos = 6
                         THEN ","
                         ELSE "".  /* Omit last comma in list */
    END. /* DO */

END PROCEDURE . /* InitFilters. */
