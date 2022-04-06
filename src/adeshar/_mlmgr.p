/*********************************************************************
* Copyright (C) 2000,2014 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/************************************************************************

Procedure: _mlmgr.p

Syntax   : RUN adeshar/_mlmgr.p PERSISTENT SET _h_mlmgr.

Purpose  : ADE Method Library Manager Object.

Description:

       
Parameters:

Notes :

Author: John Palazzo

Date  : 02/01/95 jep    Created
        05/20/99 jep    Support for custom ADM method libraries
                        (containing custom start-super-procedure calls)
        12/15/00 adams  Remote File Management support
        02/24/14 rkumar remove extra ) when running _s-alert.p
*************************************************************************/

/* ********************  Standard Includes         ******************** */
{ adeuib/sharvars.i }
{ adeuib/uniwidg.i }

/* ********************  Preprocessor Definitions  ******************** */
/* Standard End-of-line character */
&GLOBAL-DEFINE EOL CHR(10)
/* Define a SKIP for alert-boxes that only exists under Motif */
&GLOBAL-DEFINE SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

/* ***************************  Temp-Tables  ************************** */
/* _LIB-OWNER - Procedure File and Library Include Cross Reference table. */ 
DEFINE NEW SHARED TEMP-TABLE _LIB-OWNER
   FIELD _PARENT-ID           AS CHAR     LABEL "ID of Parent Object"
   FIELD _ORDER               AS INTEGER  LABEL "Order"
   FIELD _LIB-FILE-NAME       AS CHAR     LABEL "Library File Name" FORMAT "x(20)"
   
   INDEX _PARENT-ORDER        IS PRIMARY _PARENT-ID _ORDER
   INDEX _LIB-FILE-NAME                  _LIB-FILE-NAME
  .

/* _LIB - Library Table
          Contains fields related to a Method Library.
*/ 
DEFINE NEW SHARED TEMP-TABLE _LIB
   FIELD _FILE-NAME           AS CHAR     LABEL "File Name"       FORMAT "x(20)"
   FIELD _FULL-PATHNAME       AS CHAR     LABEL "Full Pathname"   FORMAT "x(20)"
   FIELD _SAVED-SMART-METHODS AS CHAR     LABEL "Saved SmartMethods"
   FIELD _SAVED-ALL-METHODS   AS CHAR     LABEL "Saved All Methods"
   FIELD _SAVED-ALL-FUNCTIONS AS CHAR     LABEL "Saved All Functions"
   FIELD _SAVED-SMART-FUNCTIONS AS CHAR   LABEL "Saved All SmartFunctions"
   FIELD _LOCAL-TEMPLATE      AS CHAR     LABEL "Local Template Code Block"
   FIELD _METHOD-TEMPLATE     AS CHAR     LABEL "Method Template Code Block"
   FIELD _SUPER-PROCS         AS CHAR     LABEL "Run Super Procedure List"
   
   INDEX _FILE-NAME           IS PRIMARY UNIQUE _FILE-NAME
  .

/* _CODE-SECTION - Code Section  Table
          Contains fields related to a Method Library Code Section, such
          as a METHOD code block or Definitions code block.
*/ 
DEFINE NEW SHARED TEMP-TABLE _CODE-SECTION
   FIELD _LIB-RECID           AS RECID    LABEL "Library Recid" 
   FIELD _ORDER               AS INTEGER  LABEL "Order"
   FIELD _PARENT-NAME         AS CHAR     LABEL "Parent Block Name"
   FIELD _TYPE                AS CHAR     LABEL "Type"
   FIELD _NAME                AS CHAR     LABEL "Name"
   FIELD _CODE-BLOCK          AS CHAR     LABEL "Code Text"
   
   INDEX _LIB-ORDER           IS PRIMARY UNIQUE _LIB-RECID _ORDER
   INDEX _LIB-NAME            IS UNIQUE         _LIB-RECID _NAME
   INDEX _LIB-PARENT-NAME                       _LIB-RECID _PARENT-NAME
  .

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE Tag_Start       AS CHAR
                                   INITIAL "&ANALYZE-SUSPEND _UIB-CODE-BLOCK":U NO-UNDO.
DEFINE VARIABLE Tag_End         AS CHAR     INITIAL "/* _UIB-CODE-BLOCK-END */":U NO-UNDO.
DEFINE VARIABLE Tag_Version     AS CHAR     INITIAL "_VERSION-NUMBER"  NO-UNDO.
DEFINE VARIABLE Tag_EndTemplate AS CHAR     INITIAL "/* _PRO-TEMPLATE-END */"
                                                                       NO-UNDO.
DEFINE VARIABLE Tag_Pro_ID      AS CHAR     INITIAL "_PRO"             NO-UNDO.
DEFINE VARIABLE Tag_Parent_ID   AS CHAR     INITIAL "_FILE"            NO-UNDO.
DEFINE VARIABLE Tag_Incl_Libs   AS CHAR     INITIAL "Included-Libraries" NO-UNDO.
DEFINE VARIABLE Tag_RunSuper    AS CHAR     INITIAL "RUN start-super-proc"  NO-UNDO.
DEFINE VARIABLE Tag_Adm_Start   AS CHAR     INITIAL "/* _ADM-CODE-BLOCK-START" NO-UNDO.
DEFINE VARIABLE Tag_Adm_End     AS CHAR     INITIAL "/* _ADM-CODE-BLOCK-END */" NO-UNDO.

DEFINE VAR Type_Definitions AS CHARACTER INIT "_DEFINITIONS"            NO-UNDO.
DEFINE VAR Type_Trigger     AS CHARACTER INIT "_CONTROL"                NO-UNDO.
DEFINE VAR Type_Main_Block  AS CHARACTER INIT "_MAIN-BLOCK"             NO-UNDO.
DEFINE VAR Type_Procedure   AS CHARACTER INIT "_PROCEDURE"              NO-UNDO.
DEFINE VAR Type_Function    AS CHARACTER INIT "_FUNCTION"               NO-UNDO.
DEFINE VAR Type_Include_Lib AS CHARACTER INIT "_INCLUDED-LIB"           NO-UNDO.
DEFINE VAR Type_InclLib_Cust AS CHARACTER INIT "_INCLUDED-LIB-CUSTOM"   NO-UNDO.

DEFINE VARIABLE Tag_CodeBlock   AS CHAR     INITIAL "_CODE-BLOCK"      NO-UNDO.
DEFINE VARIABLE Tag_Procedure   AS CHAR     INITIAL "_PROCEDURE"       NO-UNDO.
DEFINE VARIABLE Tag_SmartName   AS CHAR     INITIAL "_SMART-METHOD"    NO-UNDO.
DEFINE VARIABLE Tag_LocalPrefix AS CHAR     INITIAL "local-"           NO-UNDO.
DEFINE VARIABLE Tag_SmartPrefix AS CHAR     INITIAL "adm-"             NO-UNDO.
DEFINE VARIABLE Tag_TemplSec    AS CHAR     INITIAL "Templates"        NO-UNDO.
DEFINE VARIABLE Tag_ProcTempl   AS CHAR     INITIAL "_PROCEDURE-TEMPLATE"
                                                                       NO-UNDO.
DEFINE VARIABLE Tag_Local_Temp  AS CHAR     INITIAL "Local-Template"   NO-UNDO.
DEFINE VARIABLE Tag_Method_Temp AS CHAR     INITIAL "Method-Template"  NO-UNDO.
DEFINE VARIABLE Blank_Char      AS CHAR     INITIAL " "                NO-UNDO.
DEFINE VARIABLE Nul             AS CHAR     INITIAL ""                 NO-UNDO.
DEFINE VARIABLE Period          AS CHAR     INITIAL "."                NO-UNDO.
DEFINE VARIABLE Comma           AS CHAR     INITIAL ","                NO-UNDO.
DEFINE VARIABLE Colon-Mark      AS CHAR     INITIAL ":"                NO-UNDO.
DEFINE VARIABLE Open_Curly      AS CHAR     INITIAL "~{"               NO-UNDO.
DEFINE VARIABLE Curly_Braces    AS CHAR     INITIAL "~{~}"             NO-UNDO.

DEFINE VARIABLE Tag_Pos         AS INTEGER  INITIAL 1   NO-UNDO.
DEFINE VARIABLE Type_Pos        AS INTEGER  INITIAL 3   NO-UNDO.
DEFINE VARIABLE Name_Pos        AS INTEGER  INITIAL 4   NO-UNDO.
DEFINE VARIABLE Parent_Pos      AS INTEGER  INITIAL 5   NO-UNDO.

DEFINE VARIABLE Delim           AS CHAR  INIT " "   NO-UNDO.
DEFINE VARIABLE read_file       AS CHAR             NO-UNDO.
DEFINE VARIABLE valid_code      AS LOGICAL          NO-UNDO.
DEFINE VARIABLE end_block       AS LOGICAL          NO-UNDO.
DEFINE VARIABLE full_pathname   AS CHAR             NO-UNDO.
DEFINE VARIABLE input_line      AS CHAR             NO-UNDO.
DEFINE VARIABLE output_line     AS CHAR             NO-UNDO.
DEFINE VARIABLE lib_recid       AS RECID            NO-UNDO.
DEFINE VARIABLE lib_own_order   AS INTE   INIT 10   . /* Leave as UNDO. */
DEFINE VARIABLE sec_order       AS INTE   INIT 10   . /* Leave as UNDO. */
DEFINE VARIABLE order_inc       AS INTE   INIT 10   . /* Leave as UNDO. */
DEFINE VARIABLE inclib_order    AS INTE   INIT 10   . /* Leave as UNDO. */

/* ***************************  Main Block  *************************** */

MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN init-object.
    RETURN.
END.


/* **********************  Internal Procedures  *********************** */

/* This reference prevents the adecomm/_runcode.p procedure from deleting
   this persistent procedure.
*/
{adecomm/_adetool.i}

/*********************************************************************/
PROCEDURE init-object:
  RETURN.
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-local-template:
  DEFINE INPUT  PARAMETER p_Method_Name     AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Code_Block      AS CHAR NO-UNDO.
  
  RUN adeshar/_coddflt.p (INPUT "_LOCAL-METHOD" , INPUT ? , OUTPUT p_Code_Block ).
  IF ( p_Method_Name BEGINS Tag_LocalPrefix ) THEN
    ASSIGN p_Method_Name = REPLACE( p_Method_Name ,
                                    Tag_LocalPrefix , Nul ).
  ASSIGN p_Code_Block = REPLACE( p_Code_Block , Tag_SmartName , p_Method_Name ) .
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-method-template .
  DEFINE OUTPUT PARAMETER p_Code_Block      AS CHAR NO-UNDO.
  
  RUN adeshar/_coddflt.p (INPUT "_PROCEDURE" , INPUT ? , OUTPUT p_Code_Block ).
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-saved-methods .
  /* Keep this in synch with get-saved-funcs. */
  DEFINE INPUT        PARAMETER p_Parent_Id       AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_All_Methods     AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Smart_Methods   AS CHAR  NO-UNDO.

  DEFINE BUFFER _xLIB-OWNER     FOR _LIB-OWNER.
  DEFINE BUFFER _xLIB           FOR _LIB.
  DEFINE BUFFER _xCODE-SECTION  FOR _CODE-SECTION.
  
  FOR EACH _xLIB-OWNER WHERE _xLIB-OWNER._PARENT-ID = p_Parent_ID :
    FIND _xLIB WHERE _xLIB._FILE-NAME = _xLIB-OWNER._LIB-FILE-NAME.

    /* Skip adding if no methods or duplicate methods. */
    IF _xLIB._SAVED-ALL-METHODS <> Nul AND
       INDEX(p_All_Methods, _xLIB._SAVED-ALL-METHODS) = 0 THEN
    DO:
      RUN list-add-item ( INPUT-OUTPUT p_All_Methods ,
                          INPUT _xLIB._SAVED-ALL-METHODS ). 

      IF _xLIB._SAVED-SMART-METHODS <> Nul THEN
      RUN list-add-item ( INPUT-OUTPUT p_Smart_Methods ,
                          INPUT _xLIB._SAVED-SMART-METHODS ). 
    END.

    RUN get-saved-methods ( INPUT STRING( RECID( _xLIB-OWNER ) ) ,
                            INPUT-OUTPUT p_all_Methods ,
                            INPUT-OUTPUT p_smart_methods ) .
  END.
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-saved-funcs:
  /* Keep this in synch with get-saved-methods. */
  DEFINE INPUT        PARAMETER p_Parent_Id       AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_All_Funcs       AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Smart_Funcs     AS CHAR  NO-UNDO.

  DEFINE BUFFER _xLIB-OWNER     FOR _LIB-OWNER.
  DEFINE BUFFER _xLIB           FOR _LIB.
  DEFINE BUFFER _xCODE-SECTION  FOR _CODE-SECTION.
  
  FOR EACH _xLIB-OWNER WHERE _xLIB-OWNER._PARENT-ID = p_Parent_ID :
    FIND _xLIB WHERE _xLIB._FILE-NAME = _xLIB-OWNER._LIB-FILE-NAME.

    /* Skip adding if no methods or duplicate methods. */
    IF _xLIB._SAVED-ALL-FUNCTIONS <> Nul AND
       INDEX(p_All_Funcs, _xLIB._SAVED-ALL-FUNCTIONS) = 0 THEN
    DO:
      RUN list-add-item ( INPUT-OUTPUT p_All_Funcs ,
                          INPUT _xLIB._SAVED-ALL-FUNCTIONS ). 

      IF _xLIB._SAVED-SMART-FUNCTIONS <> Nul THEN
      RUN list-add-item ( INPUT-OUTPUT p_Smart_Funcs ,
                          INPUT _xLIB._SAVED-SMART-FUNCTIONS ). 
    END.

    RUN get-saved-funcs ( INPUT STRING( RECID( _xLIB-OWNER ) ) ,
                          INPUT-OUTPUT p_all_funcs ,
                          INPUT-OUTPUT p_smart_funcs ) .
  END.
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-super-procedures:
  /* Returns comma-delimited lists of super procedure names and handles
     run by an object. */
  DEFINE INPUT        PARAMETER p_Parent_Id       AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Super_Procs     AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Super_Handles   AS CHAR  NO-UNDO.

  DEFINE BUFFER _xLIB-OWNER     FOR _LIB-OWNER.
  DEFINE BUFFER _xLIB           FOR _LIB.
  DEFINE BUFFER _xCODE-SECTION  FOR _CODE-SECTION.

  DEFINE VARIABLE Super_Proc    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hSuper_Proc   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iItem         AS INTEGER NO-UNDO.
      
  FOR EACH _xLIB-OWNER WHERE _xLIB-OWNER._PARENT-ID = p_Parent_ID :
    FIND _xLIB WHERE _xLIB._FILE-NAME = _xLIB-OWNER._LIB-FILE-NAME.

    /* Process and start the super procs. Could be a list of them. */
    DO iItem = 1 TO NUM-ENTRIES(_xLIB._SUPER-PROCS):
        Super_Proc = ENTRY(iItem , _xLIB._SUPER-PROCS ).
        /* Skip if its a duplicate of one in the list already. */
        IF INDEX(p_Super_Procs, Super_Proc) <> 0 THEN NEXT.

        /* Start the super proc. If we can't, don't add it to the list. */
        hSuper_Proc = DYNAMIC-FUNC("get-proc-hdl":U IN _h_func_lib, INPUT Super_Proc).
        IF NOT VALID-HANDLE( hSuper_Proc ) THEN NEXT.
        RUN list-add-item ( INPUT-OUTPUT p_Super_Procs ,
                            INPUT Super_Proc ).
        RUN list-add-item ( INPUT-OUTPUT p_Super_Handles ,
                            INPUT hSuper_Proc ).
    END.

    RUN get-super-procedures ( INPUT STRING( RECID( _xLIB-OWNER ) ) ,
                               INPUT-OUTPUT p_Super_Procs ,
                               INPUT-OUTPUT p_Super_Handles) .
  END.
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-super-procs:
  /* Returns comma-delimited lists of all super procedure internal procedures
     for one or more super procedures. */
  DEFINE INPUT        PARAMETER p_Super_Handles   AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Super_Entries   AS CHAR  NO-UNDO.

  DEFINE VARIABLE Super_Proc    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hSuper_Proc   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iItem         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER NO-UNDO.
      
  DO iItem = 1 TO NUM-ENTRIES(p_Super_Handles):
    ASSIGN hSuper_Proc = WIDGET-HANDLE(ENTRY(iItem, p_Super_Handles )).
    IF NOT VALID-HANDLE( hSuper_Proc ) THEN NEXT.
    DO iEntry = 1 TO NUM-ENTRIES(hSuper_Proc:INTERNAL-ENTRIES):
        ASSIGN Super_Proc = ENTRY(iEntry, hSuper_Proc:INTERNAL-ENTRIES).
        IF ENTRY(2, hSuper_Proc:GET-SIGNATURE(Super_Proc)) = "":U AND
           NOT CAN-DO(p_Super_Entries, Super_Proc) THEN
          ASSIGN p_Super_Entries = TRIM( (p_Super_Entries + "," + Super_Proc ) , ",":U).
    END.
  END.

END PROCEDURE.

/*********************************************************************/
PROCEDURE get-super-funcs:
  /* Returns comma-delimited lists of all super procedure user functions
     for one or more super procedures. */
  DEFINE INPUT        PARAMETER p_Super_Handles   AS CHAR  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_Super_Entries   AS CHAR  NO-UNDO.

  DEFINE VARIABLE Super_Proc    AS CHAR    NO-UNDO.
  DEFINE VARIABLE hSuper_Proc   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iItem         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER NO-UNDO.
      
  DO iItem = 1 TO NUM-ENTRIES(p_Super_Handles):
    ASSIGN hSuper_Proc = WIDGET-HANDLE(ENTRY(iItem, p_Super_Handles )).
    IF NOT VALID-HANDLE( hSuper_Proc ) THEN NEXT.
    DO iEntry = 1 TO NUM-ENTRIES(hSuper_Proc:INTERNAL-ENTRIES):
        ASSIGN Super_Proc = ENTRY(iEntry, hSuper_Proc:INTERNAL-ENTRIES).
        IF ENTRY(2, hSuper_Proc:GET-SIGNATURE(Super_Proc)) <> "":U AND
           NOT CAN-DO(p_Super_Entries, Super_Proc) THEN
          ASSIGN p_Super_Entries = TRIM( (p_Super_Entries + "," + Super_Proc ) , ",":U).
    END.
  END.

END PROCEDURE.

/*********************************************************************/
PROCEDURE get-inclib-names:
  DEFINE INPUT  PARAMETER p_Parent_ID           AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_List                AS CHAR NO-UNDO.
  
  FOR EACH _LIB-OWNER WHERE _LIB-OWNER._PARENT-ID = p_Parent_ID:
    RUN list-add-item ( INPUT-OUTPUT p_List ,
                        INPUT _LIB-OWNER._LIB-FILE-NAME ). 
  END.
  
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-inclib-list:
/* Given a list with its delimiter, return a comma-delimited list
   of included library file names.
*/

  DEFINE INPUT  PARAMETER p_Item        AS CHAR     NO-UNDO.
  DEFINE INPUT  PARAMETER p_Delim       AS CHAR     NO-UNDO.
  DEFINE OUTPUT PARAMETER p_List        AS CHAR     NO-UNDO.

  DEFINE VARIABLE item_entry            AS INTEGER  NO-UNDO.
  DEFINE VARIABLE item_line             AS CHAR     NO-UNDO.
  DEFINE VARIABLE include_name          AS CHAR     NO-UNDO.
        
  DO item_entry = 1 TO NUM-ENTRIES( p_Item , p_Delim ):
    /* Trim the leading and trailing white space.  */
    ASSIGN item_line = TRIM(ENTRY( item_entry , p_Item , p_Delim )).
    /* If the item is not an include reference, skip it. */
    IF NOT item_line BEGINS Open_Curly THEN NEXT.
    
    /* Its an include reference, so remove the Open and Close Curly Braces. */
    ASSIGN include_name = TRIM( item_line , Curly_Braces ) .
    /* Add the item to the end of the comma-delimited list of include names. */
    RUN list-add-item ( INPUT-OUTPUT p_List , INPUT include_name ).
  END.

END PROCEDURE.

/*********************************************************************/
PROCEDURE open-lib:
  DEFINE INPUT  PARAMETER p_Parent_Id  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_File_List  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Broker-URL AS CHARACTER  NO-UNDO.

  DEFINE BUFFER _xLIB-OWNER FOR _LIB-OWNER.
  DEFINE BUFFER _xLIB       FOR _LIB.
  
  DEFINE VARIABLE Code_Block    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempFile     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE File_Name     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE Lib_Own_Recid AS RECID      NO-UNDO INITIAL ?.
  DEFINE VARIABLE Lib_Recid     AS RECID      NO-UNDO INITIAL ?.
  DEFINE VARIABLE lNotFound     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lReturn       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE ml_inclibs    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE name_entry    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE relPathName   AS CHARACTER  NO-UNDO.
  
  /* MAIN */
  DO name_entry = 1 TO NUM-ENTRIES( p_File_List ) :
    ASSIGN 
      File_Name = ENTRY( name_entry , p_File_List )
      lNotFound = FALSE.
    
    /* Can we find the specified os file? If not, error and return. */
    IF _AB_license > 1 AND p_Broker-URL <> "" THEN DO:
      RUN adeweb/_webcom.w (?, p_Broker-URL, File_Name, "search":U,
        OUTPUT relPathName, INPUT-OUTPUT cTempFile).
      lNotFound = ( relPathName = ? ).
    END.
    ELSE DO:
      FILE-INFO:FILENAME = File_Name.
      lNotFound = ( FILE-INFO:FULL-PATHNAME = ? ).
    END.

    IF lNotFound THEN
    WARNING_BLOCK:
    DO ON STOP UNDO WARNING_BLOCK, LEAVE WARNING_BLOCK:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lReturn, "warning":u, "ok":U,
        SUBSTITUTE("&1^Cannot find Method Library file.^^Check that the file exists and can be found in the PROPATH.  The including file may not compile correctly until the Method Library can be found.",
        File_Name )).
    END.
    
    /* See if the cross reference record exists. If no, create it. */
    FIND FIRST _xLIB-OWNER WHERE _xLIB-OWNER._PARENT-ID     = p_Parent_Id
                           AND   _xLIB-OWNER._LIB-FILE-NAME = File_Name
                           NO-ERROR.
    IF NOT AVAILABLE( _xLIB-OWNER ) THEN
      RUN create-lib-owner ( INPUT p_Parent_Id , INPUT File_Name ,
                             OUTPUT Lib_Own_Recid ).
        
    /* See if the _LIB record exists. If yes, do not re-open. */
    FIND _xLIB WHERE _xLIB._FILE-NAME = File_Name NO-ERROR.
    IF NOT AVAILABLE( _xLIB ) THEN DO:
      RUN create-lib ( INPUT File_Name , OUTPUT Lib_Recid ).
      RUN read-lib ( INPUT Lib_Recid ).
    END.

    /* Get this Library's Included Libs and add them to the list
       of Library's to open.
    */
    RUN get-code-block ( INPUT  File_Name , INPUT  Type_Include_Lib ,
                         OUTPUT Code_Block  ).
    RUN get-inclib-list ( INPUT  Code_Block , INPUT  {&EOL} ,
                          OUTPUT ml_inclibs ).
    IF ml_inclibs <> Nul THEN
      RUN open-lib ( STRING( Lib_Own_Recid ), ml_inclibs, p_Broker-URL ).

    /* Get this Library's Custom Included Libs and add them to the list
       of Library's to open.
    */
    RUN get-code-block ( INPUT  File_Name , INPUT  Type_InclLib_Cust ,
                         OUTPUT Code_Block  ).
    RUN get-inclib-list ( INPUT  Code_Block , INPUT  {&EOL} ,
                          OUTPUT ml_inclibs ).
    IF ml_inclibs = Nul THEN NEXT.
    RUN open-lib ( STRING( Lib_Own_Recid ), ml_inclibs, p_Broker-URL ).
    
  END. /* MAIN */

END PROCEDURE.

/*********************************************************************/
PROCEDURE reopen-lib:
  DEFINE INPUT  PARAMETER p_File_Name  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER p_Broker-URL AS CHARACTER  NO-UNDO.
    
  DEFINE BUFFER _aLIB       FOR _LIB.
  DEFINE BUFFER _aLIB-OWNER FOR _LIB-OWNER.
    
  DEFINE VARIABLE Parent_List AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Order_List  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE nItem       AS INTEGER   NO-UNDO.
    
  FIND FIRST _aLIB WHERE _aLIB._FULL-PATHNAME = p_File_Name
    NO-LOCK NO-ERROR.
  IF NOT AVAILABLE _aLIB THEN RETURN.

  ASSIGN p_File_Name = _aLIB._FILE-NAME.
  /* Find all occurrances of modified Method Library */
  FOR EACH _aLIB-OWNER 
    WHERE _aLIB-OWNER._LIB-FILE-NAME = p_File_Name NO-LOCK:
    RUN list-add-item (INPUT-OUTPUT Parent_List, _aLIB-OWNER._PARENT-ID).
    /* Save order for rebuild below */
    RUN list-add-item (INPUT-OUTPUT Order_List,
                       INPUT STRING(_aLIB-OWNER._ORDER)).
    /* Delete all decendants */
    RUN delete-children (INPUT STRING(RECID(_aLIB-OWNER))).
    /* Delete the link with its parent - it will be regenerated below */
    DELETE _aLIB-OWNER.
  END.

  RUN clear-libraries (TRUE /* Delete _LIB records. */).
  DO nItem = 1 TO NUM-ENTRIES( Parent_List ):
    RUN open-lib ( ENTRY(nItem, Parent_List), p_File_Name, p_Broker-URL ).
    /* Set back to original order */
    FIND FIRST _aLIB-OWNER 
      WHERE _aLIB-OWNER._LIB-FILE-NAME = p_File_Name AND
            _aLIB-OWNER._PARENT-ID = ENTRY( nItem , Parent_List) NO-ERROR.
    IF AVAILABLE _aLIB-OWNER THEN
      _aLIB-OWNER._ORDER = INTEGER(ENTRY( nItem , Order_List)).
  END.     
     
  RETURN.
     
END PROCEDURE.
     
/*********************************************************************/
PROCEDURE destroy:
  DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/*********************************************************************/
PROCEDURE close-parent:
  DEFINE INPUT  PARAMETER p_Parent_Id     AS CHAR  NO-UNDO.
  
  /* Delete the Parent Library Owner records. */
  RUN delete-children ( INPUT p_Parent_ID ).
  
  /* Clear libraries that have no parent records. Leave the _LIB record.
     Improves performance. See bug 95-05-22-038. */
  RUN clear-libraries (INPUT FALSE /* Delete _LIB record. */).
END PROCEDURE.

/*********************************************************************/
PROCEDURE delete-children:
  DEFINE INPUT  PARAMETER p_Parent_Id     AS CHAR  NO-UNDO.
  
  DEFINE BUFFER _xLIB-OWNER FOR _LIB-OWNER.
  
  /* Delete all the Parent's Library Ownership records. */
  FOR EACH _xLIB-OWNER WHERE _xLIB-OWNER._PARENT-ID = p_Parent_ID :
    RUN delete-children ( INPUT STRING(RECID( _xLIB-OWNER )) ) .
    DELETE _xLIB-OWNER.
  END.
END PROCEDURE.  

/*********************************************************************/
PROCEDURE clear-libraries:
  /* Delete _LIB and _CODE-SECTION records for Libraries with no 
     owner records. */

  DEFINE INPUT PARAMETER p_Del_Lib AS LOGICAL NO-UNDO.

  IF p_Del_Lib = FALSE THEN RETURN.

  FOR EACH _LIB:
    FIND FIRST _LIB-OWNER WHERE _LIB-OWNER._LIB-FILE-NAME = _LIB._FILE-NAME
                          NO-LOCK NO-ERROR.
    IF AVAILABLE _LIB-OWNER THEN NEXT.
    FOR EACH _CODE-SECTION WHERE _CODE-SECTION._LIB-RECID = RECID( _LIB ):
        DELETE _CODE-SECTION.
    END.
    DELETE _LIB.
  END.
END PROCEDURE.

/*********************************************************************/
PROCEDURE create-lib-owner:
    DEFINE INPUT  PARAMETER p_Parent_Id     AS CHAR  NO-UNDO.
    DEFINE INPUT  PARAMETER p_File_Name     AS CHAR  NO-UNDO.
    DEFINE OUTPUT PARAMETER p_Recid         AS RECID NO-UNDO.
    
    ASSIGN FILE-INFO:FILE-NAME = p_file_name .

    CREATE _LIB-OWNER .
    ASSIGN _LIB-OWNER._PARENT-ID     = p_Parent_Id
           _LIB-OWNER._ORDER         = lib_own_order
           _LIB-OWNER._LIB-FILE-NAME = p_File_Name
           lib_own_order             = lib_own_order + order_inc 
           p_Recid                   = RECID( _LIB-OWNER ).
           
END PROCEDURE.

/*********************************************************************/
PROCEDURE create-lib:
    DEFINE INPUT  PARAMETER p_file_name     AS CHAR  NO-UNDO.
    DEFINE OUTPUT PARAMETER p_lib_recid     AS RECID NO-UNDO.
    
    ASSIGN FILE-INFO:FILE-NAME = p_file_name .

    CREATE _LIB.
    ASSIGN _LIB._FULL-PATHNAME  = IF FILE-INFO:FULL-PATHNAME <> ?
                                  THEN FILE-INFO:FULL-PATHNAME
                                  ELSE p_file_name
           _LIB._FILE-NAME      = p_file_name
           p_lib_recid          = RECID(_LIB) .
           
END PROCEDURE.

/*********************************************************************/
PROCEDURE change-pid:
    DEFINE INPUT  PARAMETER p_old_pid LIKE _LIB-OWNER._PARENT-ID.
    DEFINE INPUT  PARAMETER p_new_pid LIKE _LIB-OWNER._PARENT-ID.
    
    FOR EACH _LIB-OWNER WHERE _LIB-OWNER._PARENT-ID = p_old_pid:
        ASSIGN _LIB-OWNER._PARENT-ID = p_new_pid.
    END.

END PROCEDURE.

/*********************************************************************/
PROCEDURE read-lib:
    DEFINE INPUT PARAMETER p_Lib_Recid      AS RECID NO-UNDO.
    
    DEFINE VARIABLE Block_Type              AS CHAR NO-UNDO.
    DEFINE VARIABLE Block_Name              AS CHAR NO-UNDO.
    DEFINE VARIABLE Block_Parent            AS CHAR NO-UNDO.
    
    DEFINE BUFFER _xLIB FOR _LIB.
    
    FIND _xLIB WHERE RECID( _xLIB ) = p_Lib_Recid .
    
    ASSIGN FILE-INFO:FILE-NAME = _xLIB._FULL-PATHNAME.
    IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN.

    INPUT FROM VALUE( _xLIB._FULL-PATHNAME ) NO-ECHO .
    READ_SECTION :
    REPEAT ON END-KEY UNDO READ_SECTION, LEAVE READ_SECTION :

        IMPORT UNFORMATTED input_line.
        ASSIGN input_line = TRIM(input_line).

        /* Determine if the code line is:
           
               RUN start-super-proc ("adm2/smart.p":U).
          
           If so, strip out super procedure filename and add it to the
           library's super procedure list. The super proc filename must be
           enclosed in single or double quotes for this to work.
           jep-code 03/98
        */
        IF (/*TRIM(input_line)*/ input_line BEGINS Tag_RunSuper) THEN
        DO:
            ASSIGN /*input_line = TRIM(input_line)*/
                   Block_Name = "":U.  /* 5/20/1999 tomn */
            ASSIGN Block_Name = ENTRY(2, input_line, '"':U) NO-ERROR.
            IF (Block_Name = "":U) THEN
                ASSIGN Block_Name = ENTRY(2, input_line, "'":U) NO-ERROR.
            /* Skip duplicate super procedure names. */
            IF CAN-DO(_xLIB._SUPER-PROCS, Block_Name) THEN
                NEXT READ_SECTION.
                
            /* Add Name to Super Procs list in in _LIB record. */
            RUN list-add-item (INPUT-OUTPUT _xLIB._SUPER-PROCS,
                               INPUT Block_Name).
            NEXT READ_SECTION.
        END.

        IF (NOT input_line BEGINS Tag_Start) AND
           (NOT input_line BEGINS Tag_Adm_Start) THEN
            NEXT READ_SECTION.

        ASSIGN Block_Type   = ENTRY(Type_Pos , input_line , Delim)
               Block_Name   = ENTRY(Name_Pos , input_line , Delim)
               Block_Parent = ENTRY(Parent_Pos , input_line , Delim) .
               
        IF ( Block_Type = Type_Procedure ) THEN DO:
            
            /* Skip duplicate procedure names. */
            IF CAN-DO(_xLIB._SAVED-ALL-METHODS, Block_Name) THEN
                NEXT READ_SECTION.
                
            /* Add Name to All Method Name list in _LIB record. */
            RUN list-add-item (INPUT-OUTPUT _xLIB._SAVED-ALL-METHODS,
                               INPUT Block_Name).
                    
            /* Add Name to SmartMethod Name list in _LIB record. */
            IF Block_Name BEGINS Tag_SmartPrefix THEN
            RUN list-add-item (INPUT-OUTPUT _xLIB._SAVED-SMART-METHODS,
                               INPUT Block_Name).

            NEXT READ_SECTION.
        END.

        IF ( Block_Type = Type_Function ) THEN DO:
            /* Skip duplicate function names. */
            IF CAN-DO(_xLIB._SAVED-ALL-FUNCTIONS, Block_Name) THEN
                NEXT READ_SECTION.
                
            /* Add Name to All Function Name list in _LIB record. */
            RUN list-add-item (INPUT-OUTPUT _xLIB._SAVED-ALL-FUNCTIONS,
                               INPUT Block_Name).
            /* Add Name to SmartFunction Name list in _LIB record. */
            IF Block_Name BEGINS Tag_SmartPrefix THEN
            RUN list-add-item (INPUT-OUTPUT _xLIB._SAVED-SMART-FUNCTIONS,
                               INPUT Block_Name).

            NEXT READ_SECTION.
        END.

        IF ( Block_Name = Type_Include_Lib ) OR
           ( Block_Name = Type_InclLib_Cust) THEN DO:
            CREATE _CODE-SECTION.
            ASSIGN _CODE-SECTION._LIB-RECID = p_Lib_Recid
                   _CODE-SECTION._ORDER     = sec_order
                   _CODE-SECTION._PARENT-NAME = Block_Parent
                   _CODE-SECTION._TYPE      = Block_Type
                   _CODE-SECTION._NAME      = Block_Name
                   sec_order                = sec_order + order_inc .
        
            /* Now read the rest of the current code block. */
            IF (input_line BEGINS Tag_Start) THEN
              /* Standard Included Lib Block. */
              RUN read-code ( INPUT p_Lib_Recid , INPUT Tag_End).
            ELSE
              /* ADM Custom Included Lib Block */
              RUN read-code ( INPUT p_Lib_Recid , INPUT Tag_Adm_End).
            NEXT READ_SECTION.
        END.

    END. /* REPEAT read-code */
    INPUT CLOSE.
    
END PROCEDURE.

/*********************************************************************/
PROCEDURE read-code:
    DEFINE INPUT PARAMETER p_Lib_Recid     AS RECID NO-UNDO.
    DEFINE INPUT PARAMETER p_Tag_End       AS CHAR  NO-UNDO.

    read-code :
    REPEAT ON END-KEY UNDO read-code , RETRY read-code :
        /*---------------------------------------------------------------
           If Progress encounters a period (.) alone on a line, it
           thinks thats the EOF and generates the END-KEY condition.
           This IF RETRY detects this and sets input_line to a period
           instead of attempting to read the input again.
        ----------------------------------------------------------------*/
        IF RETRY THEN
            ASSIGN input_line = Period.
        ELSE
            IMPORT UNFORMATTED input_line.

        IF input_line BEGINS p_Tag_End OR
           TRIM(input_line) BEGINS p_Tag_End THEN
        DO:
          /* We add an {&EOL} to the CODE BLOCK, so remove one from here. */
          ASSIGN _CODE-SECTION._CODE-BLOCK =
            SUBSTRING(_CODE-SECTION._CODE-BLOCK,1,
              LENGTH(_CODE-SECTION._CODE-BLOCK,"CHARACTER":u) - 1,"CHARACTER":u) 
              NO-ERROR.
          LEAVE read-code.
        END.
        
        ASSIGN _CODE-SECTION._CODE-BLOCK = _CODE-SECTION._CODE-BLOCK +
                                            input_line + {&EOL} .
    END. /* REPEAT read-code */
END PROCEDURE.

/*********************************************************************/
PROCEDURE get-code-block:
  DEFINE INPUT  PARAMETER p_File_Name           AS CHAR NO-UNDO.
  DEFINE INPUT  PARAMETER p_Name                AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Code_Block          AS CHAR NO-UNDO.
  
  DEFINE BUFFER _xLIB FOR _LIB.

  FIND _xLIB WHERE _xLIB._FILE-NAME = p_File_Name.
  FIND FIRST _CODE-SECTION WHERE _CODE-SECTION._LIB-RECID = RECID( _xLIB )
                           AND   _CODE-SECTION._NAME      = p_Name
                           NO-ERROR.
  ASSIGN p_Code_Block = _CODE-SECTION._CODE-BLOCK NO-ERROR.
    
END PROCEDURE.

/*********************************************************************/
PROCEDURE list-set-item:
  DEFINE INPUT-OUTPUT PARAMETER p_List      AS CHAR NO-UNDO.
  DEFINE INPUT        PARAMETER p_Value     AS CHAR NO-UNDO.

  ASSIGN p_List = p_Value .

END PROCEDURE.

/*********************************************************************/
PROCEDURE list-add-item:
  DEFINE INPUT-OUTPUT PARAMETER p_List AS CHARACTER  NO-UNDO.
  DEFINE INPUT        PARAMETER p_Item AS CHARACTER  NO-UNDO.

  ASSIGN  p_List = IF p_List = Nul THEN p_Item
                   ELSE p_List + Comma + p_Item .

END PROCEDURE.

/*********************************************************************/
PROCEDURE debug-disp:
  DEFINE VARIABLE p_File_Name AS CHARACTER  NO-UNDO.

  FOR EACH _LIB-OWNER WITH TITLE "_LIB-OWNER" :
    DISPLAY _LIB-OWNER IN WINDOW DEFAULT-WINDOW.
  END.
  PAUSE IN WINDOW DEFAULT-WINDOW.

  FOR EACH _LIB WHERE _LIB._FILE-NAME BEGINS p_File_Name WITH TITLE "_LIB" :
    DISPLAY RECID( _LIB ) IN WINDOW DEFAULT-WINDOW.
    DISPLAY _LIB IN WINDOW DEFAULT-WINDOW.

    FOR EACH _CODE-SECTION WHERE _CODE-SECTION._LIB-RECID = RECID( _LIB ) :
      DISPLAY _CODE-SECTION._LIB-RECID _CODE-SECTION._ORDER
              _CODE-SECTION._PARENT-NAME FORMAT "X(10)"
              _CODE-SECTION._TYPE FORMAT "x(15)" _CODE-SECTION._NAME
              IN WINDOW DEFAULT-WINDOW.
    END.
    PAUSE IN WINDOW DEFAULT-WINDOW.
  END.
  PAUSE IN WINDOW DEFAULT-WINDOW.

  RETURN.

END PROCEDURE.

/* _mlmgr.p - end of file */
