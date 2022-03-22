/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwattr.i
    
    Purpose:    Preprocessor Defines and Procedures used to manage
                Procedure Window attributes which contain persistent
                Procedure Window data.

    Syntax :    { adecomm/_pwattr.i }

    Parameters:
    
    Description:
        A Procedure Window must keep certain pieces of data persistenly.
        For example, the Find dialog box uses the sames settings as the
        most recent Find each time its invoked, such as the most recently
        searched for "Find Text".
                
        These values cannot be stored in regular variables because Procedure
        Windows are not actively running Progress programs, but rather are
        mere dynamically created widgets living in "screen world."
                
        The persistent data values are stored in dynamically created FILL-IN
        widgets which are in turn contained in a dynamically created FRAME.
        This Frame is a HIDDEN frame and is parented to the Procedure Window.
                
        Procedure Window (PW) Attribute Strings are used to indentify and
        describe certain information about each FILL-IN (persistent data
        value) or PW Attribute, as they are called.
                
        When a FILL-IN is created to store a PW Attribute, we use three
        pieces of information to create it: LABEL, DATA-TYPE, and
        INITIAL-VALUE.  We then store the persistent data in the FILL-IN's
        PRIVATE-DATA attribute.
                
        Additional information is provided in the code comments.
    
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* These defines specify the element within an PW Attribute String where
   each is located.
*/
&GLOBAL-DEFINE  PW_LABEL            1
&GLOBAL-DEFINE  PW_DATA-TYPE        2
&GLOBAL-DEFINE  PW_INITIAL-VALUE    3

/* Procedure Window Attributes (Persistent Data).  Used for preserving
   values of some dialog boxes after dialog box is closed.
   
       Format:  PW_Attribute        "LABEL,DATA-TYPE,INITIAL-VALUE"
   
   The values of each are located using the ENTRY function, such as
   the ENTRY( {&PW_INITIAL-VALUE} , {&PW_Find_Text} ) returns the 
   initial value of a Procedure Window's Find Text field.
   
   The LABEL value is used for programming references only and is not
   used in a displayed manner.
*/

/* These two PW Attributes are stored in dynamic fill-ins because they can hold
   multi-line text and this is difficult to manage with the ENTRY function (what
   should the delimiter be?
*/
&GLOBAL-DEFINE  PW_Find_Text          "Find_Text,CHARACTER,"
&GLOBAL-DEFINE  PW_Replace_Text       "Replace_Text,CHARACTER,"

&GLOBAL-DEFINE  PW_Find_Direction     "Find_Direction,CHARACTER,DOWN"
&GLOBAL-DEFINE  PW_Find_Case          "Find_Case,LOGICAL,NO"
&GLOBAL-DEFINE  PW_Find_Wrap          "Find_Wrap,LOGICAL,YES"
&GLOBAL-DEFINE  PW_Replace_Case       "Replace_Case,LOGICAL,NO"
&GLOBAL-DEFINE  PW_Replace_Wrap       "Replace_Wrap,LOGICAL,YES"
&GLOBAL-DEFINE  PW_Schema_Prefix      "Schema_Prefix,INTEGER,1"

/* _Pos Defines - specify the element position within :PRIVATE-DATA that each PW
   attribute is located. */
&GLOBAL-DEFINE  PW_Find_Direction_Pos   1
&GLOBAL-DEFINE  PW_Find_Case_Pos        2
&GLOBAL-DEFINE  PW_Find_Wrap_Pos        3
&GLOBAL-DEFINE  PW_Replace_Case_Pos     4
&GLOBAL-DEFINE  PW_Replace_Wrap_Pos     5
&GLOBAL-DEFINE  PW_Schema_Prefix_Pos    6
&GLOBAL-DEFINE  PW_Temp_Web_File_Pos    7 
&GLOBAL-DEFINE  PW_Broker_URL_Pos       8 
&GLOBAL-DEFINE  PW_Compile_Prompt_Pos   9 
&GLOBAL-DEFINE  PW_Compile_File_Pos     10
&GLOBAL-DEFINE  PW_Class_Type_Pos       11
&GLOBAL-DEFINE  PW_Class_TmpDir_Pos     12
&GLOBAL-DEFINE  PW_Web_File_Name_Pos    13

&GLOBAL-DEFINE  PW_NUM-ATTRS            13



PROCEDURE InitAttr.
/*-------------------------------------------------------------------------
    Purpose:    Initializes the PW Persistent Attributes initial values in
                Editor widget's PRIVATE-DATA.

    Syntax :    RUN InitAttr ( INPUT p_Editor ).

    Parameters:
    Description:
                
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
-------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE Private_Data AS CHARACTER NO-UNDO.

DO:
    /* Initialize the list to the number of PW attributes less one by filling with
       commas - the delimeter. */
       
    ASSIGN p_Editor:PRIVATE-DATA = FILL( "," , {&PW_NUM-ATTRS} - 1)
           Private_Data = p_Editor:PRIVATE-DATA.
    
    /* Assign PW Initial Attribute values to ED:PRIVATE-DATA. */
    ASSIGN ENTRY( {&PW_Find_Direction_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Find_Direction})
           ENTRY( {&PW_Find_Case_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Find_Case})
           ENTRY( {&PW_Find_Wrap_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Find_Wrap})
           ENTRY( {&PW_Replace_Case_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Replace_Case})
           ENTRY( {&PW_Replace_Wrap_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Replace_Wrap})
           ENTRY( {&PW_Schema_Prefix_Pos} , Private_Data  )
                = ENTRY ({&PW_INITIAL-VALUE} , {&PW_Schema_Prefix})
           ENTRY( {&PW_Compile_Prompt_Pos} , Private_Data  ) = "YES:":U
           p_Editor:PRIVATE-DATA = Private_Data
           .
END.

END PROCEDURE.


PROCEDURE CreateFrameAttr.
/*-------------------------------------------------------------------------
    Purpose:    Creates a FILL-IN field of a specified data-type and
                attaches it to a specified Frame.

    Syntax :    RUN CreateFrameAttr ( INPUT p_Frame , INPUT p_Attr ).

    Parameters:
    Description:
                This procedure extracts the needed information from
                the PW Attribute String p_Attr to create a fill-in field
                for the specified frame.
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
-------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Frame AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p_Attr  AS CHARACTER     NO-UNDO.

DEFINE VARIABLE pw_attr        AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_label       AS WIDGET-HANDLE NO-UNDO.

DO:
    CREATE TEXT pw_label IN WIDGET-POOL {&PW_Pool}
      ASSIGN FORMAT       = "x(50)"
             SCREEN-VALUE = ENTRY( {&PW_LABEL} , p_Attr )
             FRAME        = p_Frame
             HIDDEN       = TRUE
             .
         
    CREATE FILL-IN pw_attr IN WIDGET-POOL {&PW_Pool}
      ASSIGN DATA-TYPE          = ENTRY( {&PW_DATA-TYPE} , p_Attr )
             PRIVATE-DATA       = ENTRY( {&PW_INITIAL-VALUE} , p_Attr )
             SIDE-LABEL-HANDLE  = pw_label
             FRAME              = p_Frame
             HIDDEN             = TRUE
             .
END.

END PROCEDURE.



PROCEDURE GetFrameAttr.
/*-------------------------------------------------------------------------
    Purpose:    Returns the handle of a FILL-IN field specified by a
                Procedure Window Attribute string.

    Syntax :    RUN GetFrameAttr ( INPUT p_Frame , INPUT p_Attr ,
                                   OUTPUT p_Attr_Handle ).

    Parameters:
    Description:
                This procedure extracts the needed information from
                the PW Attribute String p_Attr to find the matching fill-in
                field for the specified frame and returns the fill-in's
                handle.
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
-------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_Frame       AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER p_Attr        AS CHARACTER     NO-UNDO.
DEFINE OUTPUT PARAMETER p_Attr_Handle AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE hWidget AS WIDGET-HANDLE NO-UNDO.

DO:
    /* p_Frame is a Frame, so get down to its first-child. */
    ASSIGN hWidget = p_Frame:FIRST-CHILD    /* Field-Group.        */ 
           hWidget = hWidget:FIRST-CHILD    /* First Field widget. */
           .
    DO WHILE VALID-HANDLE( hWidget ):
        IF hWidget:LABEL = ENTRY( {&PW_LABEL} , p_Attr )
        THEN DO:
            ASSIGN p_Attr_Handle = hWidget.
            RETURN.
        END.
        ELSE ASSIGN hWidget = hWidget:NEXT-SIBLING.
    END.
END.

END PROCEDURE.

/* _pwattr.i - end of file */
