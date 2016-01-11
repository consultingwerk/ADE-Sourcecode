&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : 
    Purpose     : Update _TT for _P._Data-Object.  
    Syntax      :  

    Description :

    Author(s)   : Haavard Danielsen 
    Created     : 03/19/98
    Notes       : 

    Updated     : 05/18/2000 BSG
                  Added support for SBO temp-table generation.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adeuib/sharvars.i}
{adeuib/uniwidg.i}
{src/adm2/globals.i}

&SCOP temptablename 'RowObject':U

DEFINE INPUT PARAMETER pProcRecid AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE IncludeName       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataObject       AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDataObjectNames  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataObjects      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCount            AS INTEGER    NO-UNDO.
DEFINE VARIABLE hSDO              AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTableName        AS CHARACTER  NO-UNDO.

FIND _P WHERE RECID(_P) = pProcRecid.

hDataObject = DYNAMIC-FUNC("get-sdo-hdl" IN _h_func_lib, 
                                            _P._DATA-OBJECT,
                                            THIS-PROCEDURE).
IF VALID-HANDLE(hDataObject) AND
   DYNAMIC-FUNCTION("getObjectType":U IN hDataObject) = "SmartBusinessObject":U THEN 
DO:
  cDataObjectNames = DYNAMIC-FUNCTION("getDataObjectNames":U IN hDataObject).
  cDataObjects = DYNAMIC-FUNCTION("getContainedDataObjects":U IN hDataObject).
  IF cDataObjectNames NE "":U AND
     cDataObjectNames NE ? THEN
  DO iCount = 1 TO NUM-ENTRIES(cDataObjectNames):
    hSDO = WIDGET-HANDLE(ENTRY(iCount,cDataObjects)).
    IF VALID-HANDLE(hSDO) THEN
    DO:
      IncludeName = DYNAMIC-FUNCTION("getDataFieldDefs":U IN hSDO).
      IncludeName = REPLACE(IncludeName,"~\","~/").
      IF IncludeName = "":U THEN DO:
        /* This must be a dynamic SDO, so ask the repository for it */
        IF _DynamicsIsRunning THEN
          IncludeName = DYNAMIC-FUNCTION("getSDOincludeFile" IN gshRepositoryManager, 
                                         ENTRY(iCount,cDataObjectNames)) + ".i":U.

      END.

      /* Remove X:/ (where X is the MS-DOS drive letter) if it can be found in
         the propath - IZ 9617                                                 */
      IF IncludeName MATCHES ".:*":U THEN DO:
        IF SEARCH(SUBSTRING(IncludeName, 4, -1, "CHARACTER")) NE ? THEN
           IncludeName = SUBSTRING(IncludeName, 4, -1, "CHARACTER").
      END.

      CREATE _TT.
      ASSIGN _TT._P-RECID           = RECID(_P) 
             _TT._TABLE-TYPE        = "D":u
             _TT._SHARE-TYPE        = "":U
             _TT._UNDO-TYPE         = "NO-UNDO":U
             _TT._LIKE-DB           = "":U
             _TT._LIKE-TABLE        = "":U
             _TT._NAME              = ENTRY(iCount,cDataObjectNames) 
             _TT._ADDITIONAL_FIELDS = "~{" + IncludeName + "~}".
    END.
  END.
END.
ELSE
DO:
    /* Gets the names of the tables in the data object,
       and loop through them. SDOs will only have one
     */
    IF VALID-HANDLE(hDataobject) THEN
      {get ViewTables cDataObjects hDataObject}.
    ELSE /* webspeed may need this without a valid SDO */
      cDataObjects = {&temptablename}.

    do iCount = 1 to num-entries(cDataObjects):            
        cTableName = entry(iCount, cDataObjects).
        
      /* If there is an _TT for the DataObject RowObject table but the _P
             record shows the DataObject is blank, then remove the _TT
             record--its not needed anymore. This can occur for WebObjects
             when changing their data source from a DataObject to a database.
             jep 03 April 1998 */
      FIND _TT WHERE _TT._P-RECID = RECID(_P) 
               AND   _TT._NAME    = cTableName NO-ERROR. 
      IF (_P._Data-Object = "":U) THEN
      DO:
        IF (AVAIL _TT) THEN DELETE _TT.
      END.  
      ELSE
      DO: 
        IF NOT AVAIL _TT THEN 
        DO:  
          /* Create the DataObject temp-table record. */  
          CREATE _TT.
          ASSIGN _TT._P-RECID           = RECID(_P) 
                 _TT._TABLE-TYPE        = "D":u
                 _TT._SHARE-TYPE        = "":U
                 _TT._UNDO-TYPE         = "NO-UNDO":U
                 _TT._LIKE-DB           = "":U
                 _TT._LIKE-TABLE        = "":U.
        END.
        
        /* Get the data object include filename. */
        RUN adeuib/_uibinfo.p (INPUT ?, 
                               INPUT "PROCEDURE ?", 
                               INPUT "DATAOBJECT-INCLUDE", 
                               OUTPUT IncludeName).
        /* Remove X:/ (where X is the MS-DOS drive letter) if it can be found in
               the propath - IZ 9617                                                 */
        IF IncludeName MATCHES ".:*":U THEN DO:
          IF SEARCH(SUBSTRING(IncludeName, 4, -1, "CHARACTER")) NE ? THEN
             IncludeName = SUBSTRING(IncludeName, 4, -1, "CHARACTER").
        END.
        ASSIGN 
          _TT._NAME                = cTableName 
          _TT._ADDITIONAL_FIELDS   = "~{" + IncludeName + "~}".
      
      END.
  end.    /* look through tables */
END.    /* non-SBO */

DYNAMIC-FUNC("shutdown-sdo" IN _h_func_lib, THIS-PROCEDURE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


