&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : sboext.p
    Purpose     : Super procedure for sbo class.
    Purpose     : Support procedure for sbo class.  This is an extension
                  of sbo.p.  The extension is necessary to avoid an overflow
                  of the action segment. This extension file contains
                  all of the get and set property functions. These functions 
                  will be rolled back into sbo.p when segment size increases.
                  (getTargetProcedure is in sbo.p) 
    Syntax      : adm2/dataext.p  

    Modified    : January 22, 2001 -- Version 9.1C
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


&SCOP ADMSuper sbo.p

DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.
  
/* Custom exclude file */

  {src/adm2/custom/sboexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBlockDataAvailable Procedure 
FUNCTION getBlockDataAvailable RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCascadeOnBrowse Procedure 
FUNCTION getCascadeOnBrowse RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedDataColumns Procedure 
FUNCTION getContainedDataColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectNames Procedure 
FUNCTION getDataObjectNames RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataObjectOrdering Procedure 
FUNCTION getDataObjectOrdering RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMasterDataObject Procedure 
FUNCTION getMasterDataObject RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
    () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectMapping Procedure 
FUNCTION getObjectMapping RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBlockDataAvailable Procedure 
FUNCTION setBlockDataAvailable RETURNS LOGICAL
  ( plBlockDataAvailable AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCascadeOnBrowse Procedure 
FUNCTION setCascadeOnBrowse RETURNS LOGICAL
  ( plCascade AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainedDataColumns Procedure 
FUNCTION setContainedDataColumns RETURNS LOGICAL
  ( pcColumns AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataObjectNames Procedure 
FUNCTION setDataObjectNames RETURNS LOGICAL
  ( pcNames AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcSource AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectMapping Procedure 
FUNCTION setObjectMapping RETURNS LOGICAL
  ( pcMapping AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 14.67
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/sboprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the SBO's AutoCommit property, which is false by default,
            but if set to true will do a Commit automatically after any change.
   Params:  <none>
    Notes:  The AutoCommit property for the contained SDOs is always set to
            false in any case, because they never initiate theor own Commit
            when contained in an SBO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCommit AS LOGICAL    NO-UNDO.
  {get AutoCommit lCommit}.
  RETURN lCommit.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBlockDataAvailable Procedure 
FUNCTION getBlockDataAvailable RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Retruns true if DataAvailable messages from contained SDOs are
           to be ignored and not republished 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lBlockDataAvailable AS LOGICAL    NO-UNDO.
  {get BlockDataAvailable lBlockDataAvailable}.
  RETURN lBlockDataAvailable.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCascadeOnBrowse Procedure 
FUNCTION getCascadeOnBrowse RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the property which determines whether data will be retrieved
            from a dependent SDO if the parent SDO has more than one row
            in its current dataset; if true (the default), data will be 
            retrieved for the first row in the parent dataset, otherwise not.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCascade AS LOG    NO-UNDO.
  {get CascadeOnBrowse lCascade}.
  RETURN lCascade.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the Commit Panel or other Commit-Source.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCommitSource AS HANDLE NO-UNDO.
  {get CommitSource hCommitSource}.
  RETURN hCommitSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Commit Panel or other Commit-Source.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedDataColumns Procedure 
FUNCTION getContainedDataColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a delimited list of all the DataColumns of all the Data
            Objects in this SBO.
    Params: <none>
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            with a semicolon between lists for each Data Object (in the same
            order as the ContainedDataObjects property).
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumns AS CHARACTER   NO-UNDO.
  {get ContainedDataColumns cColumns}.
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainedDataObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainedDataObjects Procedure 
FUNCTION getContainedDataObjects RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of the Data Objects contained
            in this SBO.
    Params: <none>
    Notes:  Used by a SDBrowser, for example, to be able to get names and
            column lists from the individual Data Objects at design time.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  {get ContainedDataObjects cObjects}.
  RETURN cObjects.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all the DataColumns of all the Data
            Objects in this SBO, each qualified by the SDO ObjectName.
    Params: <none>
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            and qualified by Object Names, as an alternative to the
            ContainedDataColumns form of the list which divides the list by SDO.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cColumns AS CHARACTER   NO-UNDO.
  {get DataColumns cColumns}.
  RETURN cColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     This SBO version of getDataHandle is run from a browser
               to get the query from the contained Data object.
   Params:     <none>
   Returns:    HANDLE of matching SDO's RowObject query
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataHandle   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceName hRequester} NO-ERROR. /* design time */
  
  IF cSourceName = '':U OR cSourceName = ? THEN
  DO:

    {get DataTarget cTargets} NO-ERROR.     /* design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceName hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      {get DataHandle hDataHandle hMaster} NO-ERROR.
      RETURN hDataHandle.
    END. /* else (no DataTarget) */
  END. /* no cSourceName */

  hSource = {fnarg DataObjectHandle cSourceName}  NO-ERROR.
 
  /* If the caller is the Browse Instance Property Dialog or some other
     procedure that needs to know which SDO we connected to, tell it. 
     This is not really required anymore  (after 91B05 )... */
  RUN assignBrowseQueryObject IN SOURCE-PROCEDURE (hSource) NO-ERROR.
  
  {get DataHandle hDataHandle hSource} NO-ERROR.
  RETURN hDataHandle.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectNames Procedure 
FUNCTION getDataObjectNames RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ordered list of ObjectNames of contained SDOs.
   Params:  <none>
    Notes:  This property is normally changed through the SBO Instance
            Property Dialog. It should not be changed until after the
            Objectnames for the SDOs within the SBO have been set.
            This fn must be run to retrieve the value so that it can check
            whether the value is still valid, which may not be the case if
            objects have been removed, added, or replaced since the SBO
            was last saved. If it no longer matches the list of contained
            SDOs, then it is blanked out so the default value will be
            recalculated.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cNames      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iTarget     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cContained  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL    NO-UNDO.

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataObjectNames':U)
         cNames = ghProp:BUFFER-VALUE.

  IF cNames NE "":U THEN
  DO:
    /* Verify that all the names are in the contained Data Objects
       and vice-versa. */
    {get ContainerTarget cTargets}.
    DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
        {get QueryObject lQuery hTarget} NO-ERROR.
        IF lQuery THEN
          /* QueryObject is considered the definition of an SDO. Verify that
              this is in the list. */
        DO:
            {get ObjectName cObjectName hTarget}.
            cContained = cContained + 
                (IF cContained = "":U THEN "":U ELSE ",":U) +
                  cObjectName.
        END.     /* END DO if lQuery */
    END.         /* END DO iTarget -- gather up the names. */
    IF NUM-ENTRIES(cNames) NE NUM-ENTRIES(cContained) THEN
        cNames = "":U.   /* One's been added or deleted, so start over. */
    ELSE DO iTarget = 1 TO NUM-ENTRIES(cNames):
        IF LOOKUP(ENTRY(iTarget, cNames), cContained) = 0 THEN
        DO:              /* One's been changed or replaced */
            cNames = "":U.
            LEAVE.
        END.      /* END DO IF no Lookup */
    END.          /* END DO iTarget -- compare names. */
  END.            /* END DO IF cNames wasn't already blank */
            
  RETURN cNames.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataObjectOrdering Procedure 
FUNCTION getDataObjectOrdering RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the mapping of the order of Update Tables as generated
            by the AppBuilder to the developer-defined update order.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cOrdering AS CHARACTER  NO-UNDO.
  {get DataObjectOrdering cOrdering}.
  RETURN cOrdering.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Maps the requesting Browser (or other such client object) to the
            SDO whose query it is browsing, and passes back the DataQueryBrowsed
            property value for that SDO.
    Notes:  Uses the ObjectMapping property to map Browsers to their SDOs.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  IF NOT VALID-HANDLE(hRequester) THEN
      RETURN ?.      /* If just design-time call, just bail out. */

  {get ObjectMapping cMapping}.
  
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {get DataQueryBrowsed lBrowsed hDataObject}.
      RETURN lBrowsed.
  END.          /* END DO IF Browser found in list. */
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object class should be subscribed
            to in its Data-Targets.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER  NO-UNDO.
  {get DataTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the ForeignFields property of the SBO
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.
  {get ForeignFields cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  returns the ForeignValues property of the SBO, which holds
            the current values of the Foreign Fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValues AS CHARACTER  NO-UNDO.
  {get ForeignValues cValues}.
  RETURN cValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMasterDataObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMasterDataObject Procedure 
FUNCTION getMasterDataObject RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the "Master" SDO, the one which has
            no data source of its own and is the parent to other SDOs.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMaster AS HANDLE NO-UNDO.
  {get MasterDataObject hMaster}.
  RETURN hMaster.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the Navigation Panel or other 
            Navigation-Source. Multiple Sources are supported, unlike SDOs.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cNavSourceList AS CHARACTER NO-UNDO.
  {get NavigationSource cNavSourceList}.
  RETURN cNavSourceList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Navigation Panel or other Navigation-Source.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
    ():
/*------------------------------------------------------------------------------
  Purpose:     This SBO version of getDataHandle is run from a browser
               to get the query from the contained Data object.
   Params:     <none>
   Returns:    HANDLE of matching SDO's RowObject query
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRequester    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNew          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMapping      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSourceNames  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSource       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMaster       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iObject       AS INTEGER    NO-UNDO.

  /* If the hRequester is a super procedure (e.g. browser.p) 
     then we must ask it for its TARGET-PROCEDURE to identify the
     actual object making the request. Otherwise just use the SOURCE */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE (hRequester) THEN
     hRequester = SOURCE-PROCEDURE.
  
  {get DataSourceNames cSourceNames hRequester} NO-ERROR. /* design time */
  
  IF cSourceNames = '':U OR cSourceNames = ? THEN
  DO:
    {get DataTarget cTargets} NO-ERROR.  /* Avoid errors at design time */
    /* If the requester is a linked DataTarget we addDataTarget. */
    IF CAN-DO(cTargets,STRING(hRequester)) THEN
    DO:
      RUN addDataTarget IN TARGET-PROCEDURE (hRequester).
      /* addDataTarget will set DataSourceNames in the requester, so let's get 
         it for the logic further down */
      {get DataSourceNames cSourceNames hRequester}.
    END. /* can-do(cTargets, ) */
    ELSE DO: /* NOT linked... return the master's DataHandle  */  
      {get MasterDataObject hMaster} NO-ERROR.
      {get NewRow lNew hMaster}.
      RETURN lNew.
    END.
   
  END. /* no cSourceName */
  
  /* The requester may potentially have more than one source.
    (An SDO that are getting foreign fields from different SDOs for example)*/
  DO iObject = 1 TO NUM-ENTRIES(cSourceNames):
    ASSIGN
      cSource  = ENTRY(iObject,cSourceNames) 
      hSource  = {fnarg DataObjectHandle cSource}.
    
    {get NewRow lNew hSource}.
    IF lNew THEN 
      RETURN TRUE.
  END.

  /* if we get here the requester has no new sources */
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectMapping Procedure 
FUNCTION getObjectMapping RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of handles of Navigation-Source objects (panels)
            or other objects which are mapped to contained Data Objects,
            and the SDOs the SBO has connected them up to, per their
            NavigationTargetName property or setCurrentMappedObject request.
   Params:  <none>
    Notes:  Used by queryPosition to identify which Object a queryPosition event
            should get passed on to. 
            Format is hNavSource,hSDOTarget[,...]
            This property is intended for internal use only; application code
            can run getCurrentMappedObject to get back the name of the object
            they are currently linked to.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMapping AS CHAR   NO-UNDO.
  {get ObjectMapping cMapping}.
  RETURN cMapping.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of this property function, which turns around and
            gets the QueryPosition from the SDO to which the caller is mapped.
    Params: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping   AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject    AS INT    NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cPosition  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hrequester AS HANDLE NO-UNDO.

  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  
  IF NOT VALID-HANDLE(hRequester) THEN
     hRequester = SOURCE-PROCEDURE.

  {get ObjectMapping cMapping}.
  iObject = LOOKUP(STRING(hRequester), cMapping).
  IF iObject = 0 THEN
    {get MasterDataObject hObject} NO-ERROR.
  
  ELSE hObject = WIDGET-HANDLE(ENTRY(iObject + 1, cMapping)).
    {get QueryPosition cPosition hObject} NO-ERROR.  
  RETURN cPosition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the property value which signals whether there are
               uncommitted updates in the object.   
  Parameters:  <none>
  Note:        The two possible return values are: 'NoUpdates' and 'RowUpdated'
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cState   AS CHARACTER NO-UNDO.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         cState = ghProp:BUFFER-VALUE NO-ERROR.
 
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Maps the requesting Browser (or other such client object) to the
            SDO whose query it is browsing, and passes back the RowsToBatch
            property value for that SDO.
    Notes:  Uses the ObjectMapping property to map Browsers to their SDOs.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hDataObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester   AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE} NO-ERROR.
  IF NOT VALID-HANDLE(hRequester) THEN
      RETURN ?.      /* If just design-time call, just bail out. */

  {get ObjectMapping cMapping}.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {get RowsToBatch iRowsToBatch hDataObject}.
      RETURN iRowsToBatch.
  END.          /* END DO IF Browser found in list. */
  ELSE RETURN 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of all Updatable Columns of contained
            DataObjects, qualified by their ObjectName.
   Params:  <none>
    Notes:  There is no actual UpdatableColumns property in the SBO;
            the value is derived on the fly by querying the contained SDOs.
------------------------------------------------------------------------------*/
    
  DEFINE VARIABLE cObjectNames AS CHAR   NO-UNDO.
  DEFINE VARIABLE cObjectName  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cObjectHdls  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cSBOColumns  AS CHAR   NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdColumns  AS CHAR   NO-UNDO.
  DEFINE VARIABLE iObject      AS INT    NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE NO-UNDO.
  DEFINE VARIABLE iColumn      AS INT    NO-UNDO.

  {get ContainedDataObjects cObjectHdls}.
  {get DataObjectNames cObjectNames}.
  DO iObject = 1 TO NUM-ENTRIES(cObjectHdls):
      ASSIGN cObjectName = ENTRY(iObject, cObjectNames)
             hObject = WIDGET-HANDLE(ENTRY(iObject, cObjectHdls)).
      {get UpdatableColumns cUpdColumns hObject}. 
      /* This is the form of the column list with SDO Name qualifiers. */
      DO iColumn = 1 TO NUM-ENTRIES(cUpdColumns):
          cSBOColumns = cSBOColumns + 
              (IF cSBOColumns NE "":U THEN ",":U ELSE "":U) +
               cObjectName + ".":U + ENTRY(iColumn, cUpdColumns).
      END.         /* END DO iColumn */
  END.             /* END DO iObject */
  RETURN cSBOColumns.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separeted list of wordindexed fields 
    Notes: Qualifed with object name  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cContained  AS CHAR      NO-UNDO.
  DEFINE VARIABLE hSDO        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iSDO        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iField      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDOFields  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.
  
  DO iSDO = 1 TO NUM-ENTRIES(cContained):
    ASSIGN 
      hSDO        = WIDGET-HANDLE(ENTRY(iSDO,cContained))
      cSDOFields  = {fn getWordIndexedFields hSDO}
      cObjectName = {fn getObjectName hSDO}.

    DO iField = 1 TO NUM-ENTRIES(cSDOFields):
      ASSIGN
        cField = cObjectName + ".":U + ENTRY(iField,cSDOFields)
        ENTRY(iField,cSDOFields) = cField.
    END.

    cFieldList = cFieldList 
                  + (IF cFieldList = '':U THEN '':U ELSE ',':U)
                  + cSDOFields.
    RETURN cFieldList.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SBO's AutoCommit property, which is false by default,
            but if set to true will do a Commit automatically after any change.
   Params:  plCommit AS LOGICAL
    Notes:  The AutoCommit property for the contained SDOs is always set to
            false in any case, because they never initiate theor own Commit
            when contained in an SBO.
------------------------------------------------------------------------------*/

  {set AutoCommit plCommit}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBlockDataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBlockDataAvailable Procedure 
FUNCTION setBlockDataAvailable RETURNS LOGICAL
  ( plBlockDataAvailable AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to block outgoing DataAvailable  
    Notes: Set to temporarily block outgoing messages during updates.     
------------------------------------------------------------------------------*/
 {set BlockDataAvailable plBlockDataAvailable}.
 RETURN TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCascadeOnBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCascadeOnBrowse Procedure 
FUNCTION setCascadeOnBrowse RETURNS LOGICAL
  ( plCascade AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a property which determines whether data will be retrieved
            from a dependent SDO if the parent SDO has more than one row
            in its current dataset; if true (the default), data will be 
            retrieved for the first row in the parent dataset, otherwise not.
   Params:  plCascade AS LOGICAL
------------------------------------------------------------------------------*/

  {set CascadeOnBrowse plCascade}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitSource property to the handle of the Commit Panel
   Params:  phSource AS HANDLE 
------------------------------------------------------------------------------*/

  {set CommitSource phSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainedDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainedDataColumns Procedure 
FUNCTION setContainedDataColumns RETURNS LOGICAL
  ( pcColumns AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a delimited list of all the DataColumns of all the Data
            Objects in this SBO.
    Params: pcColumns AS CHARACTER
    Notes:  The list of columns for each contained Data Object is comma-delimited,
            with a semicolon between lists for each Data Object (in the same
            order as the ContainedDataObjects property).
------------------------------------------------------------------------------*/

  {set ContainedDataColumns pcColumns}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataObjectNames Procedure 
FUNCTION setDataObjectNames RETURNS LOGICAL
  ( pcNames AS CHARACTER ) :
/*------------------------------------------------------------------------------
   Purpose:  Sets the ordered list of ObjectNames of contained SDOs.
   Params:  INPUT pcNames AS CHARACTER
    Notes:  This property is normally changed through the SBO Instance
            Property Dialog. It should not be changed until after the
            Objectnames for the SDOs within the SBO have been set.
            The get and set fns must be run to manipulate the value so that
            the get fn can verify that the current value is still valid.
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataObjectNames':U)
         ghProp:BUFFER-VALUE = pcNames.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SBO version of setDataQueryBrowsed locates the contained SDO
            which matches the calling Browser and sets the corresponding
            property in it. 
   Params:  plBrowsed as LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMapping    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hDataObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRequester  AS HANDLE    NO-UNDO.

  /* First get the handle of the requesting Object. We need to ask the SOURCE
     (which is a super procedure) for its Target-Procedure, using this fn. */
  {get TargetProcedure hRequester SOURCE-PROCEDURE}.

  {get ObjectMapping cMapping}.
  IF cMapping = ? THEN
     RETURN FALSE.

  iEntry = LOOKUP(STRING(hRequester), cMapping).
  IF iEntry NE 0 THEN
  DO:
      hDataObject = 
              WIDGET-HANDLE(ENTRY(iEntry + 1, cMapping)).
      {set DataQueryBrowsed plBrowsed hDataObject}.
      RETURN TRUE.
  END.          /* END DO IF Browser found in list. */
  
  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ForeignFields property
   Params:  pcFields AS CHARACTER
------------------------------------------------------------------------------*/

  {set ForeignFields pcFields}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignValues Procedure 
FUNCTION setForeignValues RETURNS LOGICAL
  ( pcValues AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ForeignValues property
   Params:  pcValues AS CHARACTER
------------------------------------------------------------------------------*/

  {set ForeignValues pcValues}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcSource AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the NavigationSource property to the handle of the Nav Panel.
            Because multiple Navigation-Sources are supported, this is a 
            comma-separated list of strings.
   Params:  pcSource AS CHARACTER
------------------------------------------------------------------------------*/

  {set NavigationSource pcSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectMapping Procedure 
FUNCTION setObjectMapping RETURNS LOGICAL
  ( pcMapping AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a list of handles of Navigation-Source objects (panels)
            or other objects which are mapped to contained Data Objects,
            and the SDOs the SBO has connected them up to, per their
            NavigationTargetName property or setCurrentMappedObject request.
   Params:  pcMapping AS CHARACTER
    Notes:  Used e.g. by queryPosition to identify which Object a 
            queryPosition event should get passed on to. 
            Format is hSource,hSDOTarget[,...]
            This property is intended for internal use only. Application code
            can run get/setCurrentMappedObject to modify or read it.
------------------------------------------------------------------------------*/
  {set ObjectMapping pcMapping}.  

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the RowObjectState property, which keeps track of whether
            there are uncommitted updates in the object. PUBLISHes the
            same event to (e.g.) a Commit Panel to reset itself.
 
  Parameters:
    INPUT pcState - Can only be 'RowUpdated' OR 'NoUpdates'
------------------------------------------------------------------------------*/

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         ghProp:BUFFER-VALUE = pcState.
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).

  /* If this is the end of a Commit, then send the UpdateComplete message
     as well so that, for example, a Navigation panel which was disabled
     throughout the update process will be re-enabled. */
  IF pcState = 'NoUpdates':U THEN
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE ('UpdateComplete':U).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

