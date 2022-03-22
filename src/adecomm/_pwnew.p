/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwnew.p
    
    Purpose:    Execute Procedure Window File->New command.

    Syntax :    RUN adecomm/_pwnew.p.

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }
{ adecomm/_pwattr.i }

DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE OK_Close     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Old_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE New_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Private_Data AS CHARACTER NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
/* --- End SCM changes ----- */

DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
    
    /* Because _pwclosf.p updates the ed:NAME, store off for later use. */
    ASSIGN Old_Name = pw_Editor:NAME
           New_Name = pw_Editor:NAME.
            
    RUN adecomm/_pwclosf.p ( INPUT pw_Window , INPUT pw_Editor ,
                             INPUT "New" ,
                             OUTPUT OK_Close ) .
    IF OK_Close <> TRUE THEN RETURN.

    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p
        (INPUT  {&PW_NAME} , INPUT "Before-Close",
         INPUT  STRING( pw_Editor ) , INPUT pw_Editor:NAME ,
         OUTPUT scm_ok ).
    IF scm_ok = FALSE THEN RETURN.
    /* --- End SCM changes ----- */
    
    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p 
        (INPUT  {&PW_NAME} , INPUT "Close",
         INPUT  STRING( pw_Editor ) , INPUT pw_Editor:NAME , 
         OUTPUT scm_ok ).
    /* --- End SCM changes ----- */

    /* If file was not Untitled, then get a new Untitled procedure name. */
    IF NOT Old_Name BEGINS {&PW_Untitled}
    THEN RUN adecomm/_pwgetun.p ( OUTPUT New_Name ).

    /* Clear buffer and rename to Untitled. */
    /* Clear the compile filename, in case this buffer previously contained
    ** a compiled file.  We will generate a new compile file name when the
    ** new buffer is run.
    */
    ASSIGN pw_Editor:SCREEN-VALUE = ""
           pw_Editor:NAME         = New_Name
           pw_Window:TITLE        = {&PW_Title_Leader} + New_Name
           
           Private_Data           = pw_Editor:PRIVATE-DATA 
		   ENTRY ( {&PW_Temp_Web_File_Pos}, Private_Data ) = ""
           ENTRY ( {&PW_Broker_URL_Pos},    Private_Data ) = ""
           ENTRY ( {&PW_Compile_File_Pos},  Private_Data ) = ""
           ENTRY ( {&PW_Class_Type_Pos},    Private_Data ) = ""
           ENTRY ( {&PW_Class_TmpDir_Pos},  Private_Data ) = ""
           pw_Editor:PRIVATE-DATA = Private_Data.
    
    APPLY "ENTRY":U TO pw_Editor.
    
    /* --- Begin SCM changes --- */
    RUN adecomm/_adeevnt.p 
        (INPUT  {&PW_NAME} , INPUT "New",
         INPUT STRING( pw_Editor ), INPUT ? , 
         OUTPUT scm_ok ).
    /* --- End SCM changes ----- */

END.
