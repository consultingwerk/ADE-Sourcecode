&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/************************************************************************
* Copyright (C) 2005-2013,2020 by Progress Software Corporation.  All rights *
* reserved.  Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                              *
************************************************************************/
/*--------------------------------------------------------------------------
    File        : adeuib/_abfuncs.w
    Purpose     : A library of functions that can be called anywhere in the
                  AppBuilder.  It is run persistently at the start of the
                  AppBuilder and shutdown when the AppBuild is shutdown.

    Syntax      : RUN adeuib/_abfuncs.w PERSISTENT SET _h_func_lib.

    Description : _h_func_lib is declared in sharvars.i.
                  Developers may call the functions defined in this procedure
                  one of two ways:
                    1) As dynamic-functions
                       Advantages:  No need to prototype the function
                       Disadvantages: Awkward syntax
                                      Function doesn't show up in the
                                      procedures signature.
                    2) Prototype the function then use normal syntax
                       Advantages: Easier calling syntax
                                   Function appears in the procedures .r code
                                   signature
                       Disadvantage: Requires the developer to write a 
                                     Protoype of the function.
 
    Author(s)   : Ross Hunter
    Created     : 2/11/98
    Notes       : Developers should edit this file in the AppBuilder and
                  add new functions as needed.
    Updated     : 3/23/98 jep
                  Removed updating of procname with SEARCH function result.
                  This was overriding the filename passed by the calling
                  routine and this is undesirable. Leave it as caller
                  passes it in.
    Updated     : 3/24/98 HD
                  Don't create _PDP if the procedure does not start.
                  Because the _PDP is UNDO the record was created even if 
                  it did not compile. The existence of the _PDP record prevented 
                  a restart.     
    Updated     : 4/7/98 HD
                  Added functions for SDO management. 
                  The current _PDP logic based on name recognition could not
                  work for SDO's because: 
                  1. Sharing.
                     There was a problem to have more than one persistent procedures 
                     share the same _PDP, deciding who should delete it. 
                  2. Fresh SDO.
                     It is important to get the newest SDO whenever you 
                     start an object that requires SDO information. 
                  3. Remote SDO info
                     For remote SDO info I use a "pretender" that always has the
                     same name.     
                  
                  However the _PDP logic is important to keep as is for 
                  future unique design time objects. 
                  As for example _abfuncs.w itself. 
                                     
    Updated     : 6/9/98 DRH
                  Added db-fld-name.  A function to generate a field name for output
                  purposes.  This function takes an _U or _BC RECID as input (along
                  with an indicator of which type it is) and considers
                  if database names are to be suppressed and if the field is from
                  a temp-table or not.
                  Also added db-tbl-name.  A function that takes a db.tbl combination
                  and strips off the db if _suppress_dbname or a temp-table.

    Updated     : 8/6/98 DRH
                  Enhanced db-fld-name to use the buffer name if present instead of
                  the table name.  This allows people to create procedures that use
                  both tables and buffers for the table in the same procedure.
                  
    Updated     : 8/28/98 jep (Update of fix on 4/23/98 jep)
                  Changed searching of procname from SEARCH function to call
                  to adecomm/_rsearch.p, which searches for both the source
                  file and its .r code in the same manner as a RUN statement. If it
                  can't find either, it returns ?. This is in FUNCTION
                  get-proc-hdl Fixes bug 98-04-23-045.
 
    Updated     : 8/28/98 gfs 
                  Added function called validate-list-item-pairs

    Updated     : 2/1/99 hd 
                  Added check of objtype in get-sdo-hdl
                  
    Updated     : 2/23/00 adams
                  Added decode-url and x-2-c functions, providing
                  WEB-CONTEXT:URL-DECODE functionality for local compiling of 
                  HTML files on the AppBuilder client.  Patterned after
                  unescape_url() and x2c() functions, respectively, found in
                  $RDLC/web/cgihtml/cgi-lib.c.
                  
    Updated     : 4/25/00 bsg
                  Added dbtt-fld-name to cater for field naming for
                  temp-tables in SDOs

    Updated     : 5/18/00 bsg
                  Added support for createObjects call in get-sdo-hdl and
                  get-proc-hdl.
                  Changed is-sdo to check the QueryObject property to 
                  support any data object.
    Updated     : 07/24/20 tm
                  Added a message to check even list-item-pairs for combo-box  

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adeuib/sharvars.i}  /* AppBuilder shared variables                    */
{adeuib/uniwidg.i}   /* AppBuilder widget temp-tables definitions      */
{adeuib/custwidg.i}  /* AppBuilder custom widgets temp-table defs      */
{adeuib/layout.i}    /* AppBuilder layout temp-table defs              */
{adeuib/brwscols.i}  /* Definitions for _BC records                    */
{adecomm/_adetool.i} /* Mark this file as an ADE Tool                  */
{adecomm/adestds.i}
{src/adm2/globals.i}  /* Dynamics global variables */
/***
Keep track of SmartDataObject handles or remote SDO info handles.
This does NOT belong in sharvars.i 
The procedures that  uses this have the responsibiliy to shutdown-sdo 
See also comments in get-sdo-hdl 
*/  
      
DEFINE TEMP-TABLE _SDO  NO-UNDO
  FIELD _Hdl        AS HANDLE 
  FIELD _FileName   AS CHARACTER
  FIELD _OwnerHdl   AS HANDLE
  INDEX _FileName IS PRIMARY UNIQUE _OwnerHdl _FILename
  .

DEFINE BUFFER ip_tmp_bc FOR _BC.
DEFINE BUFFER ip_tmp_f  FOR _F.
DEFINE BUFFER ip_tmp_u  FOR _U.
DEFINE BUFFER ip_tmp_p  FOR _P.
DEFINE BUFFER ip_tmp_tt FOR _TT.

DEFINE STREAM TempStream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignMappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignMappedEntry Procedure 
FUNCTION assignMappedEntry RETURNS CHARACTER
   (pcEntryNames  AS CHAR,
    pcList        AS CHAR,
    pcEntryValues AS CHAR,
    pcDelimiter   AS CHAR,
    plFirst       AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-center-frame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD center-frame Procedure 
FUNCTION center-frame RETURNS LOGICAL
  ( phFrame AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-change-data-type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD change-data-type Procedure 
FUNCTION change-data-type RETURNS LOGICAL
  (P_UHandle    AS HANDLE,
   pNewDataType AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compile-userfields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD compile-userfields Procedure 
FUNCTION compile-userfields RETURNS CHARACTER
 (p_P_Urecid AS RECID /* _U or _P recid */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-db-fld-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD db-fld-name Procedure 
FUNCTION db-fld-name RETURNS CHARACTER
  ( rec-type AS CHARACTER,  tbl-recid AS RECID)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-db-tbl-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD db-tbl-name Procedure 
FUNCTION db-tbl-name RETURNS CHARACTER
  ( db-tbl AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbtt-fld-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbtt-fld-name Procedure 
FUNCTION dbtt-fld-name RETURNS CHARACTER
    (tbl-recid AS RECID)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decode-url) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD decode-url Procedure 
FUNCTION decode-url RETURNS CHARACTER
  ( INPUT pURL AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-proc-hdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-proc-hdl Procedure 
FUNCTION get-proc-hdl RETURNS HANDLE
  ( proc-file-name AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-sdo-hdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-sdo-hdl Procedure 
FUNCTION get-sdo-hdl RETURNS HANDLE
  (pName     AS CHAR,    
   pOwnerHdl AS HANDLE   /* The procedure handle to the pocedure that owns 
                            the SDO. 
                            The owner has the right and responsibility 
                            to delete it.  */
   ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-url-host) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-url-host Procedure 
FUNCTION get-url-host RETURNS CHARACTER
  ( phSearch AS LOGICAL,  /* TRUE -  get URL from _P._Broker-URL
                             FALSE - URL is passed in phValue  */
    phValue  AS CHARACTER /* Window handle or URL (see above) */
  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferHandle Procedure 
FUNCTION getBufferHandle RETURNS HANDLE
  ( pcTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNativeDynamicClasses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNativeDynamicClasses Procedure 
FUNCTION getNativeDynamicClasses RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuppressDbname) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSuppressDbname Procedure 
FUNCTION getSuppressDbname RETURNS LOGICAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-sdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-sdo Procedure 
FUNCTION is-sdo RETURNS LOGICAL
  ( pObjectHdl AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-sdo-proxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-sdo-proxy Procedure 
FUNCTION is-sdo-proxy RETURNS LOGICAL
  ( pObjectHdl AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDynamicClassNative) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDynamicClassNative Procedure 
FUNCTION isDynamicClassNative RETURNS LOGICAL
  ( pcClass AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER
  (pcEntry     AS CHAR,
   pcList      AS CHAR,
   plFirst     AS LOG,
   pcDelimiter AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nextFrameWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD nextFrameWidgetID Procedure 
FUNCTION nextFrameWidgetID RETURNS INTEGER
  ( phWin AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nextWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD nextWidgetID Procedure 
FUNCTION nextWidgetID RETURNS INTEGER
  ( prParent AS RECID,
    prWidget AS RECID )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositoryDynamicClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD repositoryDynamicClass Procedure 
FUNCTION repositoryDynamicClass RETURNS CHARACTER
  ( pType AS CHARACTER  /* Procedure Type */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD run-datasource Procedure 
FUNCTION run-datasource RETURNS HANDLE PRIVATE
  ( pcName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicProcData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDynamicProcData Procedure 
FUNCTION setDynamicProcData RETURNS LOGICAL
  ( prPRecid AS RECID,                /* Recid of _P to update     */
    pcObjectFileName AS CHARACTER,    /* New Object Filename       */
    pcObjectDescription AS CHARACTER, /* New Object Description    */
    pcProductModule AS CHARACTER,     /* New Object Product Module */
    pcProductModulePath AS CHARACTER  /* New object relative path  */
 )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shutdown-proc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD shutdown-proc Procedure 
FUNCTION shutdown-proc RETURNS CHARACTER
  ( proc-file-name AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shutdown-sdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD shutdown-sdo Procedure 
FUNCTION shutdown-sdo RETURNS LOGICAL
  ( pOwnerHdl AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-format) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validate-format Procedure 
FUNCTION validate-format RETURNS LOGICAL
  (pFormat   AS CHAR,
   pDataType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-list-item-pairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validate-list-item-pairs Procedure 
FUNCTION validate-list-item-pairs RETURNS LOGICAL
  (p_Uhandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-list-items) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validate-list-items Procedure 
FUNCTION validate-list-items RETURNS LOGICAL
  (p_Uhandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-radio-buttons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validate-radio-buttons Procedure 
FUNCTION validate-radio-buttons RETURNS LOGICAL
  (p_Uhandle AS HANDLE /*  _U._handle */)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIDConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIDConflict Procedure 
FUNCTION widgetIDConflict RETURNS LOGICAL
  ( prParent   AS RECID,
    piWidgetID AS INTEGER,
    prWidget   AS RECID )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIDFrameConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIDFrameConflict Procedure 
FUNCTION widgetIDFrameConflict RETURNS LOGICAL
  ( phWin      AS HANDLE,
    piWidgetID AS INTEGER,
    prFrame    AS RECID )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WSAError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD WSAError Procedure 
FUNCTION WSAError RETURNS CHARACTER
  (pErrorNum AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-x-2-c) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD x-2-c Procedure 
FUNCTION x-2-c RETURNS CHARACTER
  (INPUT pHex AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Compile into: 
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 21.71
         WIDTH              = 54.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Enter this procedure into table of persistent procedures to be
   shutdown when the AppBuilder shuts down                              */
   CREATE _PDP.
   ASSIGN _PDP._procFileName = SEARCH(THIS-PROCEDURE:FILE-NAME)
          _PDP._hInstance    = THIS-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignMappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignMappedEntry Procedure 
FUNCTION assignMappedEntry RETURNS CHARACTER
   (pcEntryNames  AS CHAR,
    pcList        AS CHAR,
    pcEntryValues AS CHAR,
    pcDelimiter   AS CHAR,
    plFirst       AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Assign a value to a mapped entry list. This is the analog of the
           mappedEntry function copied from smart.p
           Returns the updated list.
              
Parameters:  INPUT pcEntryNames  - entry names to set (pcDelimiter delimited).  
             INPUT pcList        - Delimited Name<deL>Value string to assign new values to.
             INPUT pcEntryValues - New values to assign (pcDelimiter delimited).
             INPUT pcDelmiter    - Delimiter of 1st 3 parameters    
             INPUT plFirst       - TRUE  - Name first, value second.
                                   FALSE - Value first, Name second.
                                          
    Notes: Assigns the value to all occurances of pcEntry in the pcList     
           If it can't find the pcEntry, it adds the pcEntry <DEL> pcValue at the end.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cName       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLookUp     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNumEntries AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lAssigned   AS LOGICAL    NO-UNDO.

  /* Find out how many name/values need to be set */
  iNumEntries = NUM-ENTRIES(pcEntryNames, pcDelimiter).
  /* Make sure that we have the correct number of values */
  IF NUM-ENTRIES(pcEntryValues, pcDelimiter) NE iNumEntries THEN DO:
    RETURN ?.  /* Names and values don't match, return ? */
  END.

  DO iEntry = 1 TO iNumEntries:
    ASSIGN lAssigned = NO
           cName     = ENTRY(iEntry, pcEntryNames,  pcDelimiter)
           cValue    = ENTRY(iEntry, pcEntryValues, pcDelimiter).

    /* Find all occurances */
    DO iLookUp = IF plFirst THEN 1 ELSE 2 TO NUM-ENTRIES(pcList, pcDelimiter) BY 2:
      IF ENTRY(iLookup, pcList, pcDelimiter) = cName THEN DO:
         ENTRY(iLookup + (IF plFirst THEN 1 ELSE -1), pcList, pcDelimiter) = cValue.
         lAssigned = YES.
      END.
    END. /* Look to find all occurances */

    IF NOT lAssigned THEN DO: /* Couldn't find at least one instance,
      create the name value pair at the end */
      pcList = pcList + (IF pcList = "":U THEN "" ELSE pcDelimiter) +
                        (IF plFirst THEN cName + pcDelimiter + cValue
                                    ELSE cValue + pcDelimiter + cName).
    END. /* If we can't find the pcEntry */
  END.  /* Loop through all name/value pairs to be assigned */

  RETURN pcList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-center-frame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION center-frame Procedure 
FUNCTION center-frame RETURNS LOGICAL
  ( phFrame AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Center dialog box in the middle of the screen. The ROW and COLUMN
            attributes are relative to its parent, so adjust.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hParent AS HANDLE NO-UNDO.

  ASSIGN
    hParent        = phFrame:PARENT
    phFrame:ROW    = ROUND(MAXIMUM(1, (SESSION:HEIGHT 
                       - phFrame:HEIGHT) / 2) - hParent:ROW, 0)
    phFrame:COLUMN = ROUND(MAXIMUM(1, (SESSION:WIDTH 
                       - phFrame:WIDTH) / 2) - hParent:COLUMN, 0) NO-ERROR.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-change-data-type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION change-data-type Procedure 
FUNCTION change-data-type RETURNS LOGICAL
  (P_UHandle    AS HANDLE,
   pNewDataType AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Logic for new format, initial values and list-items when a datatype 
           is changed.
  
     Note: This is used in adeuib/_prpobj.p and adeuib/_attr_ed.    
   
Author: D. Ross Hunter
Date Created: 1994     

Modified:
  hdaniels : Made to a function and moved out of _prpobj.p
             in order to use the logic in _attr_ed.w.  
---------------------------------------------------------------------------*/   
  DEFINE VAR i             AS INTEGER                 NO-UNDO.
  DEFINE VAR raw-value     AS CHAR                    NO-UNDO.
  DEFINE VAR lbl-value     AS CHAR                    NO-UNDO.
  DEFINE VAR tmp-strng     AS CHAR                    NO-UNDO.
  DEFINE VAR tmp-value     AS CHAR                    NO-UNDO.
  DEFINE VAR datatypes     AS CHAR                    NO-UNDO
   INIT "character,longchar,date,datetime,datetime-tz,decimal,logical,integer,INT64,recid".
  DEFINE VAR formats       AS CHAR                    NO-UNDO
   INIT "X(256)||99/99/99|99/99/99 HH:MM:SS|99/99/99 HH:MM+HH:MM|->>,>>9.99|yes/no|->,>>>,>>9|->,>>>,>>9|>>>>>>9":U.
     
  /* The FORMATS variable store the format to use for each DATA-TYPE.  Store   */
  /* the existing format in the ENTRY of the existing data-type.  Then set the */
  /* new DATA-TYPE and get the default value for the format again.  Formats is */
  /* a CHR(10) delimited list of formats to use for each data-type.            */
  
  FIND _U WHERE _U._HANDLE = p_Uhandle.
 
  FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
 
  IF NOT AVAIL _F THEN DO:
    /* This should not happen for users */
    Message "Could not find _F recod for " _u._name 
    view-as alert-box error.
    RETURN FALSE.
  END.
                         
  ASSIGN formats       = REPLACE(formats,"|":U,CHR(10))
         _F._DATA-TYPE = pNewDataType
         i             = LOOKUP(_F._DATA-TYPE, datatypes)
         _F._FORMAT    = ENTRY(i,formats,CHR(10)).

  CASE _F._DATA-TYPE:
    WHEN "CHARACTER" OR WHEN "LONGCHAR" THEN
      ASSIGN _F._INITIAL-DATA = IF _F._INITIAL-DATA = ? THEN "" ELSE _F._INITIAL-DATA.
    WHEN "LOGICAL"   THEN 
      ASSIGN _F._INITIAL-DATA = "No".
    WHEN "DECIMAL"   THEN DO:
      ASSIGN _F._INITIAL-DATA = STRING(DECIMAL(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR OR _F._INITIAL-DATA = ? THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "INTEGER"   THEN DO:
      ASSIGN _F._INITIAL-DATA = STRING(INTEGER(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR OR _F._INITIAL-DATA = ? THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "INT64" THEN DO:
      ASSIGN _F._INITIAL-DATA = STRING(INT64(TRIM(_F._INITIAL-DATA))) NO-ERROR.
      IF ERROR-STATUS:ERROR OR _F._INITIAL-DATA = ? THEN _F._INITIAL-DATA = "0".
    END.
    WHEN "RECID" THEN
      ASSIGN _F._INITIAL-DATA = "?".
    OTHERWISE                             
     ASSIGN _F._INITIAL-DATA = ?.
  END CASE.

  IF _U._TYPE NE "RADIO-SET" THEN DO:
    IF _U._TYPE = "COMBO-BOX" THEN DO:
      tmp-strng = "".
      IF _F._LIST-ITEMS NE "" AND _F._LIST-ITEMS NE ? THEN DO: /* process LIST-ITEMS */
        DO i = 1 to NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
          ASSIGN raw-value = TRIM(ENTRY(i,_F._LIST-ITEMS,CHR(10))).
          CASE _F._DATA-TYPE:
            WHEN "CHARACTER" THEN
              ASSIGN tmp-value = raw-value + CHR(10).
            WHEN "LOGICAL" THEN
              ASSIGN tmp-value = (IF i = 1 THEN "Yes" ELSE
                                  IF i = 2 THEN "No"  ELSE "") + CHR(10).
            WHEN "INTEGER" THEN DO:
              ASSIGN tmp-value = STRING(INTEGER(raw-value),_F._FORMAT) NO-ERROR.
              IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
                tmp-value = tmp-value + CHR(10).
              ELSE tmp-value = "" + CHR(10).
            END.
            WHEN "INT64" THEN DO:
              ASSIGN tmp-value = STRING(INT64(RAW-VALUE),_F._FORMAT) NO-ERROR.
              IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
                tmp-value = tmp-value + CHR(10).
              ELSE tmp-value = "" + CHR(10).
            END.
            WHEN "DECIMAL" THEN DO:
              ASSIGN tmp-value = STRING(DECIMAL(raw-value),_F._FORMAT) NO-ERROR. 
              IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
                tmp-value = tmp-value + CHR(10).
              ELSE tmp-value = "" + CHR(10).
            END.
            WHEN "DATE" THEN
              ASSIGN tmp-value = (IF i = 1 THEN STRING(TODAY,_F._FORMAT) ELSE "") + 
                                 CHR(10).    
          END CASE.
          tmp-strng = tmp-strng + tmp-value.
        END.
        IF TRIM(tmp-strng,CHR(10)) = "" THEN 
          ASSIGN tmp-strng = IF _F._DATA-TYPE = "CHARACTER" THEN "Item 1" ELSE
                             IF _F._DATA-TYPE = "DATE"      THEN STRING(TODAY) ELSE
                             IF _F._DATA-TYPE = "LOGICAL"   THEN "No" ELSE
                             "0".
        ASSIGN  _F._LIST-ITEMS   = TRIM(tmp-strng,CHR(10))
                /* {&NewListItems} = _F._LIST-ITEMS 
                */ .
      END. /* IF _F._LIST-ITEMS NE "" */
      ELSE IF _F._LIST-ITEM-PAIRS NE "" AND _F._LIST-ITEM-PAIRS NE ? THEN DO: /* Process LIST-ITEM-PAIRS */
        DO i = 1 to NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
          ASSIGN raw-value = TRIM(ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))))
                 lbl-value = TRIM(ENTRY(1,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))))
                 tmp-value = ?.
          CASE _F._DATA-TYPE:
            WHEN "CHARACTER":U THEN
              ASSIGN tmp-value = lbl-value + ",":U + raw-value.
            WHEN "LOGICAL":U THEN
              ASSIGN tmp-value = lbl-value + ",":U + STRING(no,_F._FORMAT).
            WHEN "INTEGER":U THEN DO:
              ASSIGN tmp-value = lbl-value + ",":U + STRING(INTEGER(raw-value),_F._FORMAT) NO-ERROR.
              IF ERROR-STATUS:ERROR AND (tmp-value = ? OR tmp-value = "") THEN
                tmp-value = lbl-value + ",":U + STRING(0,_F._FORMAT).
            END.
            WHEN "INT64":U THEN DO:
              ASSIGN tmp-value = lbl-value + ",":U + STRING(INT64(RAW-VALUE),_F._FORMAT) NO-ERROR.
              IF ERROR-STATUS:ERROR AND (tmp-value = ? OR tmp-value = "") THEN
                tmp-value = lbl-value + ",":U + STRING(0,_F._FORMAT).
            END.
            WHEN "DECIMAL":U THEN DO:
              ASSIGN tmp-value = lbl-value + ",":U + STRING(DECIMAL(raw-value),_F._FORMAT) NO-ERROR. 
              IF ERROR-STATUS:ERROR AND (tmp-value = ? OR tmp-value = "") THEN
                tmp-value = lbl-value + ",":U + STRING(0,_F._FORMAT).
            END.
            WHEN "DATE":U THEN
              ASSIGN tmp-value = lbl-value + ",":U + STRING(TODAY,_F._FORMAT).    
          END CASE.
          ASSIGN tmp-strng = tmp-strng + tmp-value + 
            (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) THEN ",":U ELSE "") + CHR(10).
        END.
        IF TRIM(tmp-strng,CHR(10)) = "" THEN 
          ASSIGN tmp-strng = IF _F._DATA-TYPE = "CHARACTER":U THEN "Item 1,Item 1":U ELSE
                             IF _F._DATA-TYPE = "DATE":U      THEN STRING(TODAY,_F._FORMAT) + ",":U + STRING(TODAY,_F._FORMAT) ELSE
                             IF _F._DATA-TYPE = "LOGICAL":U   THEN "No,No":U ELSE
                             "0,0":U.
        ASSIGN  _F._LIST-ITEM-PAIRS = TRIM(tmp-strng,CHR(10)).
      END. /* IF _F._LIST-ITEM-PAIRS NE "" */
    END. /* IF _U._TYPE = "COMBO-BOX" */
  END.
  ELSE DO:  /* A radio set - try to morph the values */
    _F._INITIAL-DATA = TRIM(_F._INITIAL-DATA).
    tmp-strng = "".
    DO i = 1 to NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
      ASSIGN raw-value = TRIM(TRIM(ENTRY(2,ENTRY(i,_F._LIST-ITEMS,CHR(10)))),"~"").
      CASE _F._DATA-TYPE:
        WHEN "CHARACTER" THEN
          ASSIGN tmp-value = "~"" + raw-value + "~"," + CHR(10).
        WHEN "LOGICAL" THEN
          ASSIGN tmp-value = (IF i = 1 THEN "Yes," ELSE
                              IF i = 2 THEN "No,"  ELSE "?,") + CHR(10).
        WHEN "INTEGER" THEN DO:
          ASSIGN tmp-value = STRING(INTEGER(raw-value)) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "INT64" THEN DO:
          ASSIGN tmp-value = STRING(INT64(RAW-VALUE)) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "DECIMAL" THEN DO:
          ASSIGN tmp-value = STRING(DECIMAL(raw-value)) NO-ERROR. 
          IF NOT ERROR-STATUS:ERROR AND tmp-value NE ? THEN
            tmp-value = tmp-value + "," + CHR(10).
          ELSE tmp-value = "?," + CHR(10).
        END.
        WHEN "RECID" THEN 
          ASSIGN tmp-value = "?," + CHR(10).   
        WHEN "DATE" THEN
          ASSIGN tmp-value = (IF i = 1 THEN STRING(TODAY) ELSE "?") + "," + CHR(10).
         
      END CASE.
      tmp-strng = tmp-strng + ENTRY(1,ENTRY(i,_F._LIST-ITEMS,CHR(10))) + ", " +
                              tmp-value.
   END. /* DO i = 1 to NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)) */
   ASSIGN _F._LIST-ITEMS       = TRIM(TRIM(tmp-strng,CHR(10)),",")
          tmp-strng            = _F._INITIAL-DATA
          _F._INITIAL-DATA     = ?.
   
   DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
     IF tmp-strng = ENTRY(2,ENTRY(i,_F._LIST-ITEMS,CHR(10)))
        THEN _F._INITIAL-DATA = tmp-strng.
   END. 
  END.  /* radio set */
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compile-userfields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION compile-userfields Procedure 
FUNCTION compile-userfields RETURNS CHARACTER
 (p_P_Urecid AS RECID /* _U or _P recid */) :
/*------------------------------------------------------------------------------  
  Purpose: Check if userfields are compilable.
           compile _UF._definitions and each _U._defined-by ="user" field.       
           Change _F._data-type according to user definition.         
  Desc:    Notes: This check is done to avoid that user fields are defined 
           in the definitions section. User fields must be defined in a special 
           user field section in order to make the file readable by the AppBuilder. (ANALYZE does not compile the definition section)
           Callers:
           - adeuib/_attr-ed.w where fields are marked as "user".
           - adeuib/_ufmaint.w where the definitons are stored.
           
  NOTE:    Its important to not have any NO-ERROR statements AFTER compile
           because the caller may want to read error-status.              
------------------------------------------------------------------------------*/
  DEF VAR cTempFile     AS CHAR      NO-UNDO.  
  DEF VAR i             AS INTEGER   NO-UNDO.
  DEF VAR lNodef        AS LOG       NO-UNDO.
  DEF VAR cMsg          AS CHAR      NO-UNDO.       
  DEF VAR cFldDataTypes AS CHAR      NO-UNDO.       
  DEF VAR cRecids       AS CHAR      NO-UNDO.
  DEF VAR cNewDataType  AS CHAR      NO-UNDO.
  
  &SCOP returndatatype " 
    
  FIND _U WHERE RECID(_U) = p_P_Urecid NO-ERROR. 
  IF AVAIL _U THEN
    FIND _P WHERE _P._WINDOW-HANDLE = _U._WINDOW-HANDLE NO-ERROR.
  ELSE  
    FIND _P WHERE RECID(_P)  = p_P_Urecid NO-ERROR.   
   
  FIND _UF WHERE _UF._p-recid = RECID(_P) NO-ERROR. 
    
  RUN adecomm/_tmpfile.p
      ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT cTempFile).
    
  OUTPUT STREAM TempStream TO VALUE(cTempFile) {&NO-MAP}.
  
  PUT STREAM TempStream UNFORMATTED
     "DEFINE OUTPUT PARAMETER pFieldDataTypes AS CHAR   NO-UNDO.":U SKIP
     "DEFINE VARIABLE hdl                     AS HANDLE NO-UNDO.":U SKIP
     IF AVAIL _UF THEN _UF._DEFINITIONS ELSE "":U SKIP
     "IF FALSE THEN DISPLAY":U SKIP.
  
  /* just check the _u if that was used as input. */
  IF AVAIL _U THEN 
  DO:
    PUT STREAM TempStream UNFORMATTED
     _U._NAME  SKIP. 
    cRecids = STRING(RECID(_U)).
  END.
  ELSE
  FOR EACH _U WHERE _U._WINDOW-HANDLE = _P._WINDOW-HANDLE
              AND   _U._DEFINED-BY    = "User":U:
    PUT STREAM TempStream UNFORMATTED
     _U._NAME  SKIP. 
    cRecids = cRecids + (IF cRecids = "" THEN "" ELSE ",") + STRING(RECID(_U)).
  END.
  
  PUT STREAM TempStream UNFORMATTED
    "WITH FRAME x.":U SKIP.
  
  PUT STREAM TempStream UNFORMATTED
    "ASSIGN HdL = Frame x:FIRST-CHILD":U SKIP
    "       Hdl = Hdl:FIRST-CHILD.":U SKIP
    "DO WHILE VALID-HANDLE(Hdl):":U SKIP
    "  pFieldDataTypes = pFieldDataTypes + HDL:DATA-TYPE + ~",~"." SKIP
    "  Hdl = Hdl:NEXT-SIBLING.":U skip
    "END.":U SKIP
    "pFieldDataTypes = RIGHT-TRIM(pFieldDataTypes,~",~").":U SKIP.
  OUTPUT STREAM TempStream CLOSE.

  COMPILE VALUE(cTempFile) NO-ERROR.  

  IF COMPILER:ERROR THEN 
    cMsg = ERROR-STATUS:GET-MESSAGE(1).  

  ELSE
  DO: 
    RUN VALUE(cTempFile) (OUTPUT cFldDataTypes).  
  
    DO i = 1 TO NUM-ENTRIES(cRecids):
      FIND _U WHERE RECID(_U) = INTEGER(ENTRY(i,cRecids)) NO-ERROR.                                     
      FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
      ASSIGN 
        cNewDataType = LC(ENTRY(i,cFldDataTypes))
        SUBSTRING(cNewDataType,1,1) = CAPS(SUBSTRING(cNewDataType,1,1)).
      IF _F._DATA-TYPE <> cNewDataType THEN
      DO:

        IF _U._TYPE = "TOGGLE-BOX" 
        AND cNewDataType <> "LOGICAL":U THEN 
          cMsg = "Data type for " + LC(_U._TYPE) + " ":U + _U._NAME 
               + " must be logical.". 

        ELSE 
        IF CAN-DO("SELECTION-LIST,EDITOR",_U._TYPE) 
        AND cNewDataType <> "CHARACTER":U THEN 
          cMsg = "Data type for " + LC(_U._TYPE) + " ":U + _U._NAME 
               + " must be character.".   
        ELSE     
          change-data-type(_U._HANDLE,cNewDataType).

      END.
    END.  
  END.
  OS-DELETE VALUE(cTempFile).   

  RETURN cMsg. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-db-fld-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION db-fld-name Procedure 
FUNCTION db-fld-name RETURNS CHARACTER
  ( rec-type AS CHARACTER,  tbl-recid AS RECID) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  CASE rec-type:
    WHEN "_U":U THEN DO:
      FIND ip_tmp_u WHERE RECID(ip_tmp_u) = tbl-recid.
      FIND ip_tmp_f WHERE RECID(ip_tmp_f) = ip_tmp_u._x-recid.
      RETURN (IF NOT _suppress_dbname AND 
               NOT CAN-DO(_tt_log_name, ip_tmp_u._DBNAME) THEN
                 ip_tmp_u._DBNAME + "." ELSE "") +
               (IF ip_tmp_u._BUFFER NE ? THEN ip_tmp_u._BUFFER
                ELSE ip_tmp_u._TABLE) + "." +
               (IF ip_tmp_f._DISPOSITION = "LIKE" AND
                   ip_tmp_f._LIKE-FIELD NE "" THEN ip_tmp_f._LIKE-FIELD
                ELSE ip_tmp_u._NAME).
    END.  /* When record type is _U */
    WHEN "_BC":U THEN DO:
      FIND ip_tmp_bc WHERE RECID(ip_tmp_bc) = tbl-recid.
      RETURN (IF NOT _suppress_dbname AND 
               NOT CAN-DO(_tt_log_name, ip_tmp_bc._DBNAME) THEN
                 ip_tmp_bc._DBNAME + "." ELSE "") +
                 ip_tmp_bc._TABLE + "." + ip_tmp_bc._NAME.
    END.  /* When record type is _U */
  END CASE.  /* Case on rec-type */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-db-tbl-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION db-tbl-name Procedure 
FUNCTION db-tbl-name RETURNS CHARACTER
  ( db-tbl AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN (IF (_suppress_dbname OR
           CAN-DO(_tt_log_name,ENTRY(1,db-tbl,".":U))) AND
          NUM-ENTRIES(db-tbl,".":U) > 1 THEN
            ENTRY(2, db-tbl,".":U) ELSE db-tbl).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbtt-fld-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbtt-fld-name Procedure 
FUNCTION dbtt-fld-name RETURNS CHARACTER
    (tbl-recid AS RECID) :
  /*------------------------------------------------------------------------------
    Purpose:  Used to define temp-table fields like the parent database fields.
      Notes:  This function replaces the behaviour of db-fld-name in that it
              replaces the _BC._DBNAME with _TT._LIKE-DB and _BC._TABLE with 
              _TT._LIKE-TABLE so that the LIKE clause is derived from the database
              field, not a TEMP-TABLE field.
              This function was specifically written to be called by 
              "put_query_preproc_vars" in "genproc" where it replaces a call 
              to db-fld-nam.

  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

    /* This function ONLY deals with _BC type records */
    FIND ip_tmp_bc WHERE RECID(ip_tmp_bc) = tbl-recid.
    IF NOT CAN-DO(_tt_log_name, ip_tmp_bc._DBNAME) THEN
    DO:
      cRetVal = (IF NOT _suppress_dbname THEN ip_tmp_bc._DBNAME + "." ELSE "")
              + ip_tmp_bc._TABLE + ".".
    END.
    ELSE
    DO:
      FIND ip_tmp_u  WHERE RECID(ip_tmp_u)  = ip_tmp_bc._x-recid.
      FIND ip_tmp_p  WHERE ip_tmp_p._WINDOW-HANDLE  = ip_tmp_u._WINDOW-HANDLE.
      FOR EACH ip_tmp_tt 
        WHERE ip_tmp_tt._p-recid = RECID(ip_tmp_p)
          AND ip_tmp_tt._NAME = ip_tmp_bc._TABLE:
          cRetVal = (IF NOT _suppress_dbname THEN ip_tmp_tt._LIKE-DB + "." ELSE "")
                  + ip_tmp_tt._LIKE-TABLE + ".".
          LEAVE.
      END.
    END.

    cRetVal = cRetVal + ip_tmp_bc._NAME.

    RETURN cRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-decode-url) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION decode-url Procedure 
FUNCTION decode-url RETURNS CHARACTER
  ( INPUT pURL AS CHARACTER ):
  /* Adapted from unescape_url() in $RDLC/web/cgihtml/cgi-lib.c */

  DEFINE VARIABLE cChar AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cURL  AS CHARACTER NO-UNDO. /* RETURN string */
  DEFINE VARIABLE cX    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cY    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix    AS INTEGER   NO-UNDO.  
  DEFINE VARIABLE iy    AS INTEGER   NO-UNDO INITIAL 1.

  DO ix = 1 TO LENGTH(pURL, "CHARACTER":U):
    ASSIGN
      cY = SUBSTRING(pURL, iy, 1, "CHARACTER":U)
      cX = cY.
      
    IF cX = "%":U THEN 
      ASSIGN
        cChar = x-2-c(SUBSTRING(pURL, iy + 1, 2, "CHARACTER":U))
        iy    = iy + 2.
    ELSE 
      cChar = cX.
    
    ASSIGN
      cURL = cURL + cChar
      iy   = iy + 1.
  END.
  
  RETURN cURL.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-proc-hdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-proc-hdl Procedure 
FUNCTION get-proc-hdl RETURNS HANDLE
  ( proc-file-name AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Looks up the proc-file-name in the _PDP temp-table to see if
            it is already running.  If it is, get-proc-hdl returns the
            procedures handle.  If it is not currently running, it is started
            persitently, an entry is made in the table and its handle is
            returned.

    Notes:  Currently we only start persistent procedures that have no
            parameters
          - primarily for static objects, but will call startdataobject in the 
            repository manger (run-datasource) if no static object exists and 
            the object is in repository.  
          - although this also works for SDOs one should rather use 
            get-sdo-hdl for SDO start up           
------------------------------------------------------------------------------*/
  DEF VAR Hdl           AS HANDLE     NO-UNDO.
  DEF VAR search-file   AS CHAR       NO-UNDO.  
  DEF VAR cType         AS CHARACTER  NO-UNDO.
  DEF VAR lRepos        AS LOG        NO-UNDO.
  DEF VAR lIsInRepos    AS LOG        NO-UNDO.
  DEF VAR hReposSDO     AS HANDLE     NO-UNDO.
  DEF VAR hRepDesignManager AS HANDLE NO-UNDO.

  /* See if the procedure source or .r file is in the PROPATH somewhere. */
  RUN adecomm/_rsearch.p (INPUT proc-file-name , OUTPUT search-file).
  
  /* Check whether specified proc-filename is a repository object if Dynamics is running*/
  IF _DynamicsIsRunning AND search-file = ? THEN 
  DO:
    ASSIGN hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
    lIsInrepos = DYNAMIC-FUNCTION("ObjectExists":U IN hRepDesignManager, INPUT proc-file-name ) .
    IF NOT lIsInrepos THEN 
      RETURN ?.
  END.

  /* The file exists, so look up its name in the table */
  FIND FIRST _PDP WHERE _PDP._procFileName = proc-file-name NO-ERROR.
  /* Not there, start it up */
  IF NOT AVAILABLE _PDP THEN 
  DO:   
    /* start the object*/
    IF NOT search-file = ? THEN
    DO:
      DO ON STOP UNDO, LEAVE:
        RUN VALUE(proc-file-name) PERSISTENT SET Hdl.
      END.
      cType = DYNAMIC-FUNCTION('getObjectType':U IN Hdl) NO-ERROR.
      IF cType <> 'SUPER':U AND NOT VALID-HANDLE(hreposSDO) THEN
        RUN createObjects IN Hdl NO-ERROR.
    END.
    ELSE IF lIsInrepos THEN
      hdl = run-datasource(proc-file-name).

    /** Don't create _PDP until we know its started (_PDP is UNDO ) */
    IF VALID-HANDLE(Hdl) THEN 
    DO:
      CREATE _PDP.
      ASSIGN _PDP._procFileName = proc-file-name
             _PDP._hInstance    = IF VALID-HANDLE(hReposSDO) THEN hReposSDO ELSE Hdl.

    END.
  END.  /* If not avail _PDP */

  RETURN IF AVAIL _PDP THEN _PDP._hInstance ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-sdo-hdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-sdo-hdl Procedure 
FUNCTION get-sdo-hdl RETURNS HANDLE
  (pName     AS CHAR,    
   pOwnerHdl AS HANDLE   /* The procedure handle to the pocedure that owns 
                            the SDO. 
                            The owner has the right and responsibility 
                            to delete it.  */
   ): 
/*------------------------------------------------------------------------------
   Purpose: Start a SmartDataObject or a SmartDataObject "pretender" or 
           get the handle if it is already started in this contect.
Parameters: pName - data definition source name
                    SDO name or include name,table (_P._data-object )
            pOwnerHdl - requestor. other objects uses this to share it 
                        requestor is responsible of calling shutdown-sdo  
                        with the same handle to clean up.
                              
     Notes: Objects that require column info from SmartDataObject should
            call this .
               
            Objects that need to share a SDO must get the handle 
            from the one they share it with and use that as an input parameter.
                         
            Make sure that that handle also is used as input to shutdown-sdo.
                  
            Difference from get-proc-hdl 
            ---------------------------- 
            call to startDataObject has presedence when running in dynamics.
           
            Supports include 
            The _PDP in get-proc-hdl is based on name recognition. 
           
            If several persistent objects should share the same SDO, none of them 
            could delete it, because they would not know if any other was using it. 
            If the SDO never got deleted it would hang around forever making it 
            impossible to restart when changes was done.
                  
------------------------------------------------------------------------------*/
  DEF VAR Hdl             AS HANDLE NO-UNDO.
  DEF VAR Ok              AS LOG    NO-UNDO.
  DEF VAR lWeb            AS LOG    NO-UNDO.
  DEF VAR cCurrentObjType AS CHAR   NO-UNDO.
  DEF VAR hReposSDO       AS HANDLE NO-UNDO.
  DEF VAR search-file     AS CHAR   NO-UNDO.

  FIND _SDO WHERE _SDO._FileName = pName 
            AND   _SDO._OwnerHdl = pOwnerHdl NO-ERROR.

  IF NOT AVAIL _SDO THEN 
  DO:
    
    /* We need to check the procedure type of the design object,
       because only web objects should start the SDO remotely  */
    RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U, OUTPUT cCurrentObjType).

    ASSIGN 
      lWeb = cCurrentObjType BEGINS "WEB":U 
      Hdl  = ?.
    
    IF lweb AND _remote_file THEN
    DO ON STOP UNDO, LEAVE:
      /* 
      This procedure can read the remote SDO info. 
      Because it have the same signature (for columns) as of a regular SDO,
      whoever needs an SDO's columns properties can use the same functions
      */ 
           
      RUN web2/support/_rmtsdo.p PERSISTENT SET HDL.
      
      /*     
      The adeweb/_rmtsdo.p calls a procedure 
      that uses the Crescents HTTP OCX.  
      Because the HTTP protocol needs WAIT-FOR it 
      cannot be initialized here ! 
      */        
      
      DYNAMIC-FUNCTION ("setSDOName":U in Hdl, pName).
     
    END. /* if web object and remote development */ 
    ELSE 
      hdl = run-datasource(pName).
    
    IF VALID-HANDLE(hdl) THEN 
    DO:
      CREATE _SDO.
      ASSIGN _SDO._Hdl      = Hdl
             _SDO._FileName = pName 
             _SDO._OwnerHdl = pOwnerHdl.
    END. /* if valid-handle(hdl) */    
  END. /* if not avail _sdo */
  
  RETURN IF AVAIL _SDO THEN _SDO._Hdl ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-url-host) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-url-host Procedure 
FUNCTION get-url-host RETURNS CHARACTER
  ( phSearch AS LOGICAL,  /* TRUE -  get URL from _P._Broker-URL
                             FALSE - URL is passed in phValue  */
    phValue  AS CHARACTER /* Window handle or URL (see above) */
  ):
/*------------------------------------------------------------------------------
  Purpose: Extract and return the host machine name from a valid URL.
    Notes: This code has been duplicated in adeuib/_uibinfo because the host 
           name is needed by the procedure window for remote file save 
           functionality.  If this code is changed, _uibinfo need to change 
           as well.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBrokerURL AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cHostName  AS CHARACTER NO-UNDO.

  IF phSearch THEN DO:
    FIND _P WHERE _P._WINDOW-HANDLE = WIDGET-HANDLE(phValue) NO-ERROR.
    cBrokerURL = IF AVAILABLE _P THEN
                   (IF _P._Broker-URL NE "" THEN _P._Broker-URL 
                    ELSE IF _P._SAVE-AS-FILE EQ ? AND _remote_file THEN _BrokerURL
                    ELSE "")
                 ELSE "".
  END.
  ELSE
    ASSIGN cBrokerURL = phValue.
  IF cBrokerURL = "" THEN RETURN "".
  
  ASSIGN
    cHostName = IF TRIM(cBrokerURL) BEGINS "http://":U THEN
                  SUBSTRING(TRIM(cBrokerURL), 8, -1, "CHARACTER":U)
                ELSE TRIM(cBrokerURL)
    cHostName = REPLACE(cHostName, "~\":U, "/":U)
    cHostName = " (":U + SUBSTRING(cHostName, 1, INDEX(cHostName,"/":U) - 1,
                         "CHARACTER":U) + ")":U.
  RETURN cHostName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferHandle Procedure 
FUNCTION getBufferHandle RETURNS HANDLE
  ( pcTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the buffer handle of the specified AppBuilder temp table
    Notes:  
------------------------------------------------------------------------------*/
/* Set handles to the temp table buffers */
 CASE pcTable:
   WHEN "_BC":U THEN
       RETURN  BUFFER _BC:HANDLE.   
   WHEN "_C":U THEN
       RETURN  BUFFER _C:HANDLE.
   WHEN "_F":U THEN
       RETURN  BUFFER _F:HANDLE.
   WHEN "_L":U THEN
       RETURN  BUFFER _L:HANDLE.
   WHEN "_M":U THEN
       RETURN  BUFFER _M:HANDLE.
   WHEN "_P":U THEN
       RETURN  BUFFER _P:HANDLE.
   WHEN "_PDP":U THEN
       RETURN  BUFFER _PDP:HANDLE.
   WHEN "_Q":U THEN
       RETURN  BUFFER _Q:HANDLE.
   WHEN "_S":U THEN
       RETURN  BUFFER _S:HANDLE.
   WHEN "_TT":U THEN
       RETURN  BUFFER _TT:HANDLE.
   WHEN "_U":U THEN
       RETURN  BUFFER _U:HANDLE.
   WHEN "_UF":U THEN
       RETURN  BUFFER _UF:HANDLE.
   WHEN "_vbx2ocx":U THEN
       RETURN  BUFFER _vbx2ocx:HANDLE.
   WHEN "_RyObject":U THEN
       RETURN  BUFFER _RyObject:HANDLE.
   WHEN "_custom":U THEN
       RETURN  BUFFER _custom:HANDLE.
   WHEN "_palette_item":U THEN
       RETURN  BUFFER _palette_item:HANDLE.
 END CASE.
 
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNativeDynamicClasses) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNativeDynamicClasses Procedure 
FUNCTION getNativeDynamicClasses RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the list of natively supported dynamic classes 
    Notes:     
------------------------------------------------------------------------------*/

  RETURN "DynView,DynBrow,DynDataView,DynSDO":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSuppressDbname) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSuppressDbname Procedure 
FUNCTION getSuppressDbname RETURNS LOGICAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------    
  Purpose:  Returns the AppBuilder's preference to caller.
    Notes:  * This function will typically be called from Repository Design Manager.
------------------------------------------------------------------------------*/
    RETURN _suppress_dbname.
END FUNCTION.   /* getSuppressDbname */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-sdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-sdo Procedure 
FUNCTION is-sdo RETURNS LOGICAL
  ( pObjectHdl AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Return true if persistent object is an sdo.
    Notes: 
------------------------------------------------------------------------------*/

    DEFINE VAR valid-sdo AS LOGICAL NO-UNDO.
    
    valid-sdo = VALID-HANDLE(pObjectHdl) AND
                /* (LOOKUP("getQueryObject":U , pObjectHdl:INTERNAL-ENTRIES) > 0) AND */
                DYNAMIC-FUNCTION("getQueryObject":U IN pObjectHdl).

    RETURN valid-sdo. 
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-sdo-proxy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-sdo-proxy Procedure 
FUNCTION is-sdo-proxy RETURNS LOGICAL
  ( pObjectHdl AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Return true if an SDO is the proxy SDO.
    Notes: 
------------------------------------------------------------------------------*/

    DEFINE VARIABLE proxy-sdo     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cASDivision   AS CHARACTER  NO-UNDO.

    cASDivision = DYNAMIC-FUNCTION ("getASDivision":U IN pObjectHdl) NO-ERROR.
    ASSIGN proxy-sdo = IF cASDivision = "Client":U THEN TRUE ELSE FALSE.

    RETURN proxy-sdo.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDynamicClassNative) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDynamicClassNative Procedure 
FUNCTION isDynamicClassNative RETURNS LOGICAL
  ( pcClass AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the class is dynamic and natively supported in the 
           AppBuilder. 
    Notes: Natively supported means the object can be built and opened in 
           the AppBuilder similar to a static object.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iClass AS INTEGER    NO-UNDO.
  cClasses = getNativeDynamicClasses().  
  DO iClass = 1 TO NUM-ENTRIES(cClasses):
    IF DYNAMIC-FUNC("ClassIsA":U IN gshRepositoryManager, pcClass, ENTRY(iClass,cClasses)) THEN
      RETURN TRUE. 
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER
  (pcEntry     AS CHAR,
   pcList      AS CHAR,
   plFirst     AS LOG,
   pcDelimiter AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the 'other' entry in a separated list of paired entries.
           This is required to ensure that the lookup does not find a matching
           entry in the wrong part of the pair.  
              
Parameters:  INPUT pcEntry    - entry to lookup.  
             INPUT pcList     - comma separated list with paired entries. 
             INPUT plFirst    - TRUE  - lookup first and RETURN second.
                                FALSE - lookup second and RETURN first.
             INPUT pcDelmiter - Delimiter of pcList               
    Notes: Used to find mapped RowObject or database column in assignList.  
           In other cases, such as the ObjectMapping property of SBOs, an
           entry may occur more than once in the list, in which case a list
           of matching values is returned, using the same delimiter as the list.
        -  Returns ? if no entry is found          
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLookUp AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.

  /* We use a work list so we are free to remove entries from it without
     risking to remove the value that we eventually want to return */
  ASSIGN
    cValues = ? /* Set to ? to identify not found (Blank may be found) */
    cList   = pcList.
  DO WHILE TRUE:
    iLookup = LOOKUP(pcEntry,cList,pcDelimiter).
    
    /* The entry is no longer in the list or not at all, so return any values 
       we have found in earlier passes; if none found unknown will be returned.*/
    IF iLookup = 0 OR iLookup = ? THEN 
      RETURN cValues.

    /* If this is the correct half of the pair add the other part from the
       original list to the list of values to return. */
    IF iLookup MODULO 2 = (IF plFirst THEN 1 ELSE 0) THEN
      cValues = (IF cValues <> ? THEN cValues + pcDelimiter ELSE '':U)
              + ENTRY(IF plFirst THEN (iLookup + 1) ELSE (iLookup - 1),
                      pcList,
                      pcDelimiter).
    
    /* We remove this entry (right or wrong) from the work list to be able 
       to lookup the next. (Setting it to blank if we are looking for blank
       will cause an endless loop so we set it to '?' in that case )*/ 
    ENTRY(iLookup,cList,pcDelimiter) = IF pcEntry <> '':U THEN '':U ELSE '?':U.
  END. /* do while true */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nextFrameWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION nextFrameWidgetID Procedure 
FUNCTION nextFrameWidgetID RETURNS INTEGER
  ( phWin AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the next widget id for a design window
            phWin AS HANDLE - handle of the design window
    Notes:  - Browse widgets are treated like frames by the 4GL syntax
            even though widget ids are not yet supported for browse columns
------------------------------------------------------------------------------*/
DEFINE VARIABLE iWidgetID AS INTEGER    NO-UNDO.

DEFINE BUFFER f_U FOR _U.
  
  /* TTY Window */
  IF NOT _cur_win_type THEN RETURN ?.

  FOR EACH f_U WHERE f_U._window-handle = phWin AND
    LOOKUP(f_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) > 0:  

    IF f_U._WIDGET-ID > iWidgetID THEN                          
      iWidgetID = f_U._WIDGET-ID.     
  END.  /* for each frame or browse of window */

  iWidgetID = IF iWidgetID = 0 THEN _widgetid_start          
              ELSE iWidgetID + _widgetid_increment.          
  
  /* Return next frame widget ID */
  RETURN iWidgetID.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-nextWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION nextWidgetID Procedure 
FUNCTION nextWidgetID RETURNS INTEGER
  ( prParent AS RECID,
    prWidget AS RECID ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the next widget ID for a frame
            prParent AS RECID - _U recid of a frame
            prWidget AS RECID - _U recid of widget being added to frame
    Notes:  - The function finds the largest widget id of the frame and
            returns it plus 2 for the next widget id for the frame
            - The widget being added to a frame should not looked at to 
            determine what the next widget id should be for copy/import
            cases when the widget id is already set and has been found
            to conflict with another widget on the frame.
            - Browse widgets are treated like frames by the 4GL syntax
            even though widget ids are not yet supported for browse columns
------------------------------------------------------------------------------*/
DEFINE VARIABLE iNumButtons AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWidgetID   AS INTEGER    NO-UNDO.

DEFINE BUFFER PARENT_U FOR _U.
DEFINE BUFFER WIDGET_U FOR _U.
DEFINE BUFFER WIDGET_F FOR _F.

  /* TTY Window */
  IF NOT _cur_win_type THEN RETURN ?.

  FIND PARENT_U WHERE RECID(PARENT_U) = prParent NO-ERROR.
  IF AVAILABLE PARENT_U THEN
  DO:
    FOR EACH WIDGET_U WHERE WIDGET_U._parent-recid = prParent AND 
      LOOKUP(WIDGET_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) = 0 AND 
      RECID(WIDGET_U) NE prWidget AND 
      WIDGET_U._WIDGET-ID NE ? BY WIDGET_U._WIDGET-ID:

      /* Each radio set button has its own widget id so the next
         widget id must take into account the number of buttons */
      IF WIDGET_U._TYPE = 'RADIO-SET':U THEN
      DO:
        FIND WIDGET_F WHERE RECID(WIDGET_F) = WIDGET_U._x-recid NO-ERROR.
        IF AVAILABLE WIDGET_F THEN
          iNumButtons = NUM-ENTRIES(WIDGET_F._LIST-ITEMS,WIDGET_F._DELIMITER) / 2.

        iWidgetID = IF iNumButtons MODULO 2 NE 0 THEN
                      WIDGET_U._WIDGET-ID + iNumButtons - 1
                    ELSE 
                      WIDGET_U._WIDGET-ID + iNumButtons.
      END.  /* radio set */
      ELSE IF WIDGET_U._WIDGET-ID > iWidgetID THEN
        iWidgetID = WIDGET_U._WIDGET-ID.

    END.  /* for each _U of frame */
  END.  /* if avail frame _U */

  /* Return largest widget id of frame plus 2 */
  RETURN iWidgetID + 2.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositoryDynamicClass) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION repositoryDynamicClass Procedure 
FUNCTION repositoryDynamicClass RETURNS CHARACTER
  ( pType AS CHARACTER  /* Procedure Type */ ) :

/*------------------------------------------------------------------------------
  Purpose: To return the dynamic class (Currently DynView, DynBrow, DynSDO or 
           DynSBO) that the input type extends.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDynClass      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNativeClasses AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iClass         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cClass         AS CHARACTER  NO-UNDO.
  IF _DynamicsIsRunning THEN 
  DO:
    CASE pType:
        WHEN "SmartDataViewer":U     THEN cDynClass = "DynView":U.
        WHEN "SmartViewer":U         THEN cDynClass = "DynView":U.  /* V8 */
        WHEN "SmartDataBrowser":U    THEN cDynClass = "DynBrow":U.
        WHEN "SmartBrowser":U        THEN cDynClass = "DynBrow":U.  /* V8 */
        WHEN "SmartDataObject":U     THEN cDynClass = "DynSDO":U.
        WHEN "SmartBusinessObject":U THEN cDynClass = "DynSBO":U.
        OTHERWISE DO:

          cNativeClasses = getNativeDynamicClasses() + ",DynSBO":U.
          DO iClass = 1 TO NUM-ENTRIES(cNativeClasses):
            cClass = ENTRY(iClass,cNativeClasses).
            IF DYNAMIC-FUNC("ClassIsA":U IN gshRepositoryManager,pType,cClass) THEN
              RETURN cClass.
          END.
        END.
    END CASE.
  END.

  RETURN cDynClass.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-datasource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION run-datasource Procedure 
FUNCTION run-datasource RETURNS HANDLE PRIVATE
  ( pcName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Starts a datasource  
  Parameters: pName - data definition source name
                    SDO name or include name,table (_P._data-object )
    Notes: private. 
           called from get-sdo-hdl and from get-proc-hdl if in not on disk
           and found in repository.
        -  will run from file if not found in repos for backwards compatibility
           of visual objects that have been built with static datasources.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSearch     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInclude    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hDesignMngr AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lInRepos    AS LOGICAL    NO-UNDO.
  define variable cObjectType as character no-undo.
  IF NUM-ENTRIES(pcName) > 1 THEN
  DO:
    ASSIGN
      lInclude = TRUE
      cTable   = ENTRY(2,pcname)
      pcName   = ENTRY(1,pcname).
  END.
  IF lInclude THEN
    RUN adeuib/_rundsinclude.p (INPUT pcName, INPUT cTable, OUTPUT hDataSource).

  ELSE DO:
    /* See if the source or .r file is in the PROPATH somewhere. */
    IF _DynamicsIsRunning THEN 
    DO ON ERROR UNDO,LEAVE: /*startdataobject throws ERROR if not exists */
      /* Repository has presedence */ 
      RUN startDataObject IN gshRepositoryManager (pcName, OUTPUT hDataSource). 
      lInRepos = TRUE.
      DYNAMIC-FUNCTION("setUIBMode":U IN hDataSource, 'Design':U) NO-ERROR.
    END. /* dynamics */

    RUN adecomm/_rsearch.p (INPUT pcName , OUTPUT cSearch).
    /* if found and not in repository then run it */
    IF cSearch <> ? AND NOT lInRepos THEN
    DO ON STOP UNDO, LEAVE on error undo,leave :
      RUN VALUE(pcName) PERSISTENT SET hDataSource NO-ERROR. 
      /* this is called from get-proc-hld, check objecttype */
      cObjectType = ?.
      cObjectType = {fn getObjectType hDataSource} NO-ERROR.
      /* this may not be a good place to give an error 
         but it used to fail on getObjectType so keeping old behavior
         with better message  */
      if cObjectType = ? then
          message pcName + " is not a SmartObject." view-as alert-box error.
      else IF VALID-HANDLE(hDataSource) AND cObjectType <> 'SUPER' THEN
          RUN createObjects IN hDataSource NO-ERROR.
    END.
  END.
  
  RETURN hDataSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDynamicProcData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDynamicProcData Procedure 
FUNCTION setDynamicProcData RETURNS LOGICAL
  ( prPRecid AS RECID,                /* Recid of _P to update     */
    pcObjectFileName AS CHARACTER,    /* New Object Filename       */
    pcObjectDescription AS CHARACTER, /* New Object Description    */
    pcProductModule AS CHARACTER,     /* New Object Product Module */
    pcProductModulePath AS CHARACTER  /* New object relative path  */
 ) :
/*------------------------------------------------------------------------------
  Purpose: When creating new dynamic objects, wizzards need to initialize the current
           procedure temp-table (_P) with user specified data.  This procedure does this.
       
     
------------------------------------------------------------------------------*/
  FIND _P WHERE RECID(_P) = prPRecid NO-ERROR.

  IF AVAILABLE _P THEN DO:
    ASSIGN _P.object_filename     = pcObjectFileName
           _P.object_description  = pcObjectDescription
           _P.product_module_code = pcProductModule
           _P.object_path         = pcProductModulePath.
    RETURN TRUE.
  END.
  ELSE
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shutdown-proc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION shutdown-proc Procedure 
FUNCTION shutdown-proc RETURNS CHARACTER
  ( proc-file-name AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This procedure attempts to find a procedure by name in the
            _PDP (Persistent Design Procedures) temp-table, shut it down,
            then remove the entry from the temp-table.
            It returns one of three messages:
            "Stopped"         if the procedure was found and stopped.
            "Was not running" if the procedure was found in the table but
                              the handle wasn't valid. (The entry is also
                              deleted from the table.)
            "Cannot find"     if the procedure wasn't in the table
    Notes:  
------------------------------------------------------------------------------*/

  /* Look it up in the table. */
  FIND _PDP WHERE _PDP._procFileName = proc-file-name NO-ERROR.
  IF NOT AVAILABLE _PDP THEN  /* Not there, return "Cannot find" */
    RETURN "Cannot find".

  ELSE IF NOT VALID-HANDLE(_PDP._hInstance) THEN DO:
    DELETE _PDP.
    RETURN "Was not running".
  END.
  
  ELSE DO:
    RUN DestroyObject IN _PDP._hInstance NO-ERROR.
    IF VALID-HANDLE(_PDP._hInstance) THEN
       DELETE PROCEDURE _PDP._hInstance.
    DELETE _PDP.
    RETURN "Stopped".
  END.  /* Have started the procedure */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-shutdown-sdo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION shutdown-sdo Procedure 
FUNCTION shutdown-sdo RETURNS LOGICAL
  ( pOwnerHdl AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Shutdown the running sdo or sdo info object if any.  
    Notes: See comments where _SDO is defined.
------------------------------------------------------------------------------*/
  DEF VAR lDeleted AS log NO-UNDO.
  FOR EACH _SDO WHERE _SDO._OwnerHdl = pOwnerHdl:
    IF VALID-HANDLE(_SDO._HDL) THEN
       RUN destroyObject IN _SDO._HDL no-error .
    
    IF VALID-HANDLE(_SDO._HDL) THEN
       DELETE PROCEDURE _SDO._HDL.
       
    DELETE _SDO.
    ASSIGN lDeleted = TRUE.
  END.
  
  RETURN lDeleted. /* True  - if any sdo was deleted (usually one).
                      False - if none was found. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-format) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validate-format Procedure 
FUNCTION validate-format RETURNS LOGICAL
  (pFormat   AS CHAR,
   pDataType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Test if a format is valid for a specific data-type.  
    Notes: The PROGRESS default message will be shown.                  
------------------------------------------------------------------------------*/
  DEF VAR test AS CHAR.

  /*If the numeric format does not have at least a nine at the end of its format, the STRING function will
    return "" causing the validation to fail. So we replace the last > with a nine at the end for the
    format string.*/
  IF CAN-DO("INTEGER,INT64,DECIMAL":U, pDataType) AND SUBSTRING(pFormat, LENGTH(pFormat), 1) = ">"
    THEN ASSIGN SUBSTRING(pFormat, LENGTH(pFormat), 1) = "9".

  DO ON ERROR UNDO,LEAVE:
    CASE pDataType:
      WHEN "logical":U THEN
      DO:
        IF NUM-ENTRIES(pFormat,"/":U) NE 2 THEN 
        DO:
          MESSAGE "'":U _F._FORMAT "' is an invalid logical format." SKIP
                  "Use a format of the form 'yes/no' or 'true/false'."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          RETURN FALSE.
        END.
        test = STRING(yes,pFormat).
      END.
      WHEN "character":U THEN       
         test = STRING('a',pFormat). 
      WHEN "longchar":U THEN       
         test = STRING('a',pFormat). 
      WHEN "decimal":U THEN 
        test = STRING(0.0,pFormat).
      WHEN "integer":U THEN 
        test = STRING(0,pFormat).
      WHEN "int64":U THEN 
        test = STRING(0,pFormat).     
      WHEN "date":U THEN 
        test = STRING(1/1/99,pFormat).
      WHEN "datetime":U THEN
        test = STRING(NOW,pFormat).
      WHEN "datetime-tz":U THEN
        test = STRING(NOW,pFormat).
      WHEN "recid":U THEN 
        test = STRING(0,pFormat).
      WHEN "clob" or WHEN "blob" THEN
        test = "ok". /* no format needed/used */  
    END CASE.         
  END.
  RETURN test <> "":U.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-list-item-pairs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validate-list-item-pairs Procedure 
FUNCTION validate-list-item-pairs RETURNS LOGICAL
  (p_Uhandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: validate list-item-pairs for combo-boxes  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cTempFile AS CHAR NO-UNDO.
  DEF VAR lError    AS LOG  NO-UNDO.
  DEF VAR i         AS INT  NO-UNDO.
  
  FIND _U WHERE _U._HANDLE = p_Uhandle.
 
  FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
 
  IF NOT AVAIL _F THEN DO:
    /* This should not happen for users */
    Message "Could not find list-item-pairs for " _u._name 
    view-as alert-box error.
    RETURN FALSE.
  END.
  
  IF NUM-ENTRIES(_F._LIST-ITEM-PAIRS,",") MODULO 2 > 0 THEN DO:
    Message "Unable to save changes." SKIP
            "LIST-ITEM-PAIRS must contain an even number of entries to specify label/value pairs for " _u._name  + "."             
    view-as alert-box error.
    RETURN FALSE.
  END.

  /* There's no restrictions for list-items if  data-type is character */  
  IF _F._DATA-TYPE = "Character":U THEN RETURN TRUE.
     
  RUN adecomm/_tmpfile.p
      ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT cTempFile).
  
  OUTPUT STREAM tempStream TO VALUE(cTempFile) {&NO-MAP}.

  PUT STREAM tempStream UNFORMATTED
    "DEFINE VARIABLE aComboBox AS ":U + _F._DATA-TYPE SKIP.
  PUT STREAM tempStream UNFORMATTED
    "     VIEW-AS COMBO-BOX LIST-ITEM-PAIRS ":U SKIP "     ".
  IF _F._DATA-TYPE = "DATE":U AND _F._LIST-ITEM-PAIRS = ? THEN
    PUT STREAM tempStream UNFORMATTED '" "':U.
  ELSE 
  DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
    PUT STREAM tempStream UNFORMATTED """"  + /* first item of pair (quoted) */
            ENTRY(1,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),_F._DELIMITER) + '",' +
            /* Quote the second item only if it's a CHAR field */
            (IF _F._DATA-TYPE = "Character":U THEN '"' + 
              ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),_F._DELIMITER) + '"'
             ELSE ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)),_F._DELIMITER)) +
            (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) THEN ",":U + CHR(10)
             ELSE "").
  END.  /* DO i = 1 to Num-Entries */
  PUT STREAM tempStream UNFORMATTED "." SKIP.
  OUTPUT STREAM tempStream CLOSE.
  COMPILE VALUE(cTempFile) NO-ERROR.
  IF COMPILER:ERROR THEN DO:
    MESSAGE "Invalid List Item Pairs definition or datatype for" SKIP
  
            "COMBO-BOX":U _U._NAME VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    lError = TRUE.  
    /*
    ASSIGN new_btns      = FALSE
          l_error_on_go = TRUE.
    */
  END. /* compiler error */
  
  OS-DELETE VALUE(cTempFile) NO-ERROR.
 
  RETURN NOT lError. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-list-items) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validate-list-items Procedure 
FUNCTION validate-list-items RETURNS LOGICAL
  (p_Uhandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Validate list-items   
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR cTempFile AS CHAR NO-UNDO.
  DEF VAR lError    AS LOG  NO-UNDO.
  
  FIND _U WHERE _U._HANDLE = p_Uhandle.
 
  FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
 
  IF NOT AVAIL _F THEN DO:
    /* This should not happen for users */
    Message "Could not find list-items for " _u._name 
    view-as alert-box error.
    RETURN FALSE.
  END.
  
  /* There's no restrictions for list-items if data-type is character */  
  IF _F._DATA-TYPE = "Character":U THEN RETURN TRUE.
     
  RUN adecomm/_tmpfile.p
      ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT cTempFile).
  
  OUTPUT STREAM tempStream TO VALUE(cTempFile) {&NO-MAP}.

  PUT STREAM tempStream UNFORMATTED
    "DEFINE VARIABLE aComboBox AS ":U + _F._DATA-TYPE SKIP.
  PUT STREAM tempStream UNFORMATTED
    "     VIEW-AS COMBO-BOX LIST-ITEMS":U SKIP "     ".
  IF _F._DATA-TYPE = "DATE":U AND _F._LIST-ITEMS = ? THEN
    PUT STREAM tempStream UNFORMATTED '" "':U.
  ELSE PUT STREAM tempStream UNFORMATTED
    REPLACE(_F._LIST-ITEMS,CHR(10),",").
  PUT STREAM tempStream UNFORMATTED "." SKIP.
  OUTPUT STREAM tempStream CLOSE.
  COMPILE VALUE(cTempFile) NO-ERROR.
  IF COMPILER:ERROR THEN DO:
    MESSAGE "Invalid List Items(s) definition or datatype for" SKIP
  
            "COMBO-BOX":U _U._NAME VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    lError = TRUE.  
    /*
    ASSIGN new_btns      = FALSE
          l_error_on_go = TRUE.
    */
  END. /* compiler error */
  
  OS-DELETE VALUE(cTempFile) NO-ERROR.
 
  RETURN NOT lError. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validate-radio-buttons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validate-radio-buttons Procedure 
FUNCTION validate-radio-buttons RETURNS LOGICAL
  (p_Uhandle AS HANDLE /*  _U._handle */) :
/*------------------------------------------------------------------------------
  Purpose: Validate if _F._list-items has a set of valid radio-buttons.              
    Notes: This logic used to be in _prpobj.p   
------------------------------------------------------------------------------*/
  DEF VAR cTempFile AS CHAR      NO-UNDO.
  DEF VAR lError    AS LOG       NO-UNDO.
  
  DEF VAR i         AS INTEGER   NO-UNDO.
  DEF VAR tmp-label AS CHARACTER NO-UNDO.
  
  FIND _U WHERE _U._HANDLE = p_Uhandle.
  FIND _F WHERE RECID(_F)  = _U._x-recid NO-ERROR.
 
  IF NOT AVAIL _F THEN DO:
    /* This should not happen for users */
    Message "Could not find radio-set information for " _u._name 
    view-as alert-box error.
    RETURN FALSE.
  END.
  
  IF _F._LIST-ITEMS  <> "" 
  AND _F._LIST-ITEMS <> ? 
  /* AND NUM-ENTRIES(_F._LIST-ITEMS) MOD 2 eq 0 */ THEN 
  DO:
    /* Commas are allowed by the compiler within a radio-item label, but
       that blows the 'NUM-ENTRIES() BY 2' test.  Let the compiler do the
       checking below.  Removed for 19990909-002.
    DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS) BY 2:
       tmp-label = TRIM(ENTRY(i,_F._LIST-ITEMS)).
       IF NOT tmp-label BEGINS "~"":U AND NOT tmp-label BEGINS "~'":U
       THEN ENTRY(i,_F._LIST-ITEMS) = (IF i > 1 THEN CHR(10) ELSE "":U) +
          '~"':U + tmp-label + '~"':U.
    END.    
    */
    RUN adecomm/_tmpfile.p
      ({&STD_TYP_UIB_COMPILE}, {&STD_EXT_UIB}, OUTPUT cTempFile).
    
    OUTPUT STREAM TempStream TO VALUE(cTempFile) {&NO-MAP}.
    PUT STREAM TempStream UNFORMATTED
      "DEFINE VARIABLE aRadioSet AS ":U + _F._DATA-TYPE SKIP.
    PUT STREAM TempStream UNFORMATTED
      "     VIEW-AS RADIO-SET RADIO-BUTTONS":U SKIP "     ".
    PUT STREAM TempStream UNFORMATTED _F._LIST-ITEMS.
    PUT STREAM TempStream UNFORMATTED "." SKIP.
    OUTPUT STREAM TempStream CLOSE.
    COMPILE VALUE(cTempFile) NO-ERROR. 
    IF COMPILER:ERROR THEN DO:
      MESSAGE "Invalid Radio-Button(s) definition or datatype:" SKIP
        ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      lError = TRUE.
    END. /* compiler error */
    OS-DELETE VALUE(cTempFile) NO-ERROR.

  END. /* valid radio list */
  ELSE DO:
    MESSAGE "Invalid definition of Radio-Button(s)."
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    lError = TRUE.
  END.
   
  RETURN NOT lError. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIDConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIDConflict Procedure 
FUNCTION widgetIDConflict RETURNS LOGICAL
  ( prParent   AS RECID,
    piWidgetID AS INTEGER,
    prWidget   AS RECID ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks a widget's widget id for a conflict with other widgets of a 
            frame
            prParent   AS RECID   - _U recid of a frame
            piWidgetID AS INTEGER - widget id to check
            prWidget   AS RECID   - _U for widget being checked
    Notes:  - As soon as a conflict is found, checking is stopped and  
            TRUE is returned
            - Browse widgets are treated like frames by the 4GL syntax
            even though widget ids are not yet supported for browse columns
------------------------------------------------------------------------------*/
DEFINE VARIABLE iButtonID         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iNumButtons       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWidgetNumButtons AS INTEGER    NO-UNDO.
DEFINE VARIABLE lConflict         AS LOGICAL    NO-UNDO.

DEFINE BUFFER PARENT_U FOR _U.
DEFINE BUFFER WIDGET_F FOR _F.
DEFINE BUFFER WIDGET_U FOR _U.
DEFINE BUFFER other_U  FOR _U.
DEFINE BUFFER other_F  FOR _F.

  FIND PARENT_U WHERE RECID(PARENT_U) = prParent NO-ERROR.
  IF AVAILABLE PARENT_U THEN
  DO:
    /* Find _U for widget being checked to determine whether it is a 
       radio set */
    FIND WIDGET_U WHERE RECID(WIDGET_U) = prWidget NO-ERROR.
    IF AVAILABLE WIDGET_U THEN
    DO:
      IF WIDGET_U._TYPE = 'RADIO-SET':U THEN
      DO:
        /* If widget being checked is a radio set determine its number of
           buttons */
        FIND WIDGET_F WHERE RECID(WIDGET_F) = WIDGET_U._x-recid NO-ERROR.
        IF AVAILABLE WIDGET_F THEN
          iWidgetNumButtons = NUM-ENTRIES(WIDGET_F._LIST-ITEMS,WIDGET_F._DELIMITER) / 2.

        /* Check other widgets on the frame to determine whether there
           is a conflict with the widget being checked or its number of buttons */
        FOR EACH other_U WHERE other_U._parent-recid = prParent AND
          LOOKUP(other_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) = 0 AND
          RECID(other_U) NE prWidget:

          /* Also need to check for buttons of existing radio sets on the frame */
          IF other_U._TYPE = 'RADIO-SET':U THEN
          DO:
            FIND other_F WHERE RECID(other_F) = other_U._x-recid NO-ERROR.
            IF AVAILABLE other_F THEN
              iNumButtons = NUM-ENTRIES(other_F._LIST-ITEMS,other_F._DELIMITER) / 2.

            DO iButtonID = piWidgetID TO piWidgetID + iWidgetNumButtons:
              IF iButtonID >= other_U._WIDGET-ID AND 
                 iButtonID <= (other_U._WIDGET-ID + iNumButtons) THEN RETURN TRUE.
            END.
          END.  /* if widget on frame is radio set */
          ELSE DO: 
            IF other_U._WIDGET-ID >= piWidgetID AND
               other_U._WIDGET-ID <= (piWidgetID + iWidgetNumButtons) THEN 
              RETURN TRUE.
          END.  /* else do - not radio set */
        END.  /* for each _U - other widgets on frame */
      END.  /* widget being checked is radio set */
      ELSE DO:  /* widget being checked is not a radio set */
        FOR EACH other_U WHERE other_U._parent-recid = prParent AND
          LOOKUP(other_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) = 0 AND
          RECID(other_U) NE prWidget:

          /* Need to check for buttons of existing radio sets on the frame */
          IF other_U._TYPE = 'RADIO-SET':U THEN
          DO:
            FIND other_F WHERE RECID(other_F) = other_U._x-recid NO-ERROR.
            IF AVAILABLE other_F THEN
              iNumButtons = NUM-ENTRIES(other_F._LIST-ITEMS,other_F._DELIMITER) / 2.

            IF piWidgetID >= other_U._WIDGET-ID AND 
               piWidgetID <= (other_U._WIDGET-ID + iNumButtons) THEN 
              RETURN TRUE.
          END.  /* if widget on frame is radio set */
          ELSE DO: 
            IF piWidgetID = other_U._WIDGET-ID THEN 
              RETURN TRUE.
          END.  /* else do - not radio set */                         
        END.  /* for each _U - other widgets on frame */
      END.  /* else do - widget being checked not radio set */
    END.  /* if available widget_U */
  END.  /* if available parent_U */
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIDFrameConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIDFrameConflict Procedure 
FUNCTION widgetIDFrameConflict RETURNS LOGICAL
  ( phWin      AS HANDLE,
    piWidgetID AS INTEGER,
    prFrame    AS RECID ) :
/*------------------------------------------------------------------------------
  Purpose:  Checks a frame's or browse's widget id for a conflict with other 
            frames and browse widgets of a design window
            phWin      AS HANDLE  - handle of the design window
            piWidgetID AS INTEGER - widget id to check
            prFrame    AS RECID   - _U for frame/browse being checked
    Notes:  - Browse widgets are treated like frames by the 4GL syntax
            even though widget ids are not yet supported for browse columns
------------------------------------------------------------------------------*/
DEFINE BUFFER f_U FOR _U.

  FIND FIRST f_U WHERE f_U._window-handle = phWin AND
      f_U._WIDGET-ID = piWidgetID AND
      LOOKUP(f_U._TYPE,'FRAME,DIALOG-BOX,BROWSE':U) > 0 AND 
      RECID(f_U) NE prFrame NO-ERROR.
  IF AVAILABLE f_U THEN RETURN TRUE.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-WSAError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION WSAError Procedure 
FUNCTION WSAError RETURNS CHARACTER
  (pErrorNum AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: Return the WinSocket error message for a given error number     
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE pMessage AS CHARACTER NO-UNDO.
  
  RUN adeweb/_wsaerr.p (pErrorNum, OUTPUT pMessage).
  RETURN pMessage.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-x-2-c) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION x-2-c Procedure 
FUNCTION x-2-c RETURNS CHARACTER
  (INPUT pHex AS CHARACTER):
  /* Adapted from x2c() in $RDLC/web/cgihtml/cgi-lib.c */
  
  DEFINE VARIABLE cChar1  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChar2  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cString AS CHARACTER NO-UNDO INITIAL "ABCDEF":U.
  DEFINE VARIABLE iDigit  AS INTEGER   NO-UNDO.  

  ASSIGN
    cChar1 = SUBSTRING(pHex, 1, 1, "CHARACTER":U)
    iDigit = (IF INDEX(cString, cChar1) = 0 THEN INTEGER(cChar1)
              ELSE INDEX(cString, cChar1) + 10)
    iDigit = iDigit * 16
    cChar2 = SUBSTRING(pHex, 2, 1, "CHARACTER":U)
    iDigit = (IF INDEX(cString, cChar2) = 0 THEN INTEGER(cChar2)
              ELSE INDEX(cString, cChar2) + 10) + iDigit.

  RETURN CHR(iDigit).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

