&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-------------------------------------------------------------------------
    File        : sbo.i
    Purpose     : Basic Method Library for the ADMClass sbo.
  
    Syntax      : {src/adm2/sbo.i}

    Description :
  
    Modified    : June 12, 2000 -- Version 9.1B
     
-------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass sbo
&ENDIF

&IF "{&ADMClass}":U = "sbo":U &THEN
  {src/adm2/sboprop.i}
&ELSE  
  /* if this is included in an extended class ensure that start-super-proc
     keeps the DataLogicObject started in this main block at the bottom
     of the super-procedure stack */  
   &IF DEFINED(LAST-SUPER-PROCEDURE-PROP) = 0 &THEN
 &SCOPED-DEFINE LAST-SUPER-PROCEDURE-PROP DataLogicObject 
   &ENDIF
&ENDIF

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* This is an array of all the update table handles. */
  DEFINE VARIABLE ghUpdTables          AS HANDLE EXTENT 20    NO-UNDO.

  /* Now define all the actual Upd temp-tables using preprocessors which 
     are used in the SBO. */
  {src/adm2/updtabledef.i 1}
  {src/adm2/updtabledef.i 2}
  {src/adm2/updtabledef.i 3}
  {src/adm2/updtabledef.i 4}
  {src/adm2/updtabledef.i 5}
  {src/adm2/updtabledef.i 6}
  {src/adm2/updtabledef.i 7}
  {src/adm2/updtabledef.i 8}
  {src/adm2/updtabledef.i 9}
  {src/adm2/updtabledef.i 10}
  {src/adm2/updtabledef.i 11}
  {src/adm2/updtabledef.i 12}
  {src/adm2/updtabledef.i 13}
  {src/adm2/updtabledef.i 14}
  {src/adm2/updtabledef.i 15}
  {src/adm2/updtabledef.i 16}
  {src/adm2/updtabledef.i 17}
  {src/adm2/updtabledef.i 18}
  {src/adm2/updtabledef.i 19}
  {src/adm2/updtabledef.i 20}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initDataObjectOrdering Method-Library 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 7.86
         WIDTH              = 48.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Starts super procedure */
  IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  DO:
    RUN start-super-proc("adm2/sbo.p":U).
    RUN start-super-proc("adm2/sboext.p":U).
  /* sboext.p is merely a simple "extension" of sbo.p.  This was necessary
     because functions don't have their own action segement and sbo.p got
     too big and had to be broken up.  All of the functions in sboext.p
     are get and set property functions.  */

    RUN modifyListProperty IN TARGET-PROCEDURE
         ( THIS-PROCEDURE, 'ADD':U, 'DataTargetEvents':U, 'RegisterObject':U).

    RUN modifyListProperty IN TARGET-PROCEDURE
         ( THIS-PROCEDURE, 'ADD':U, 'DataTargetEvents':U, 'unRegisterObject':U).

    RUN modifyListProperty IN TARGET-PROCEDURE
         ( THIS-PROCEDURE, 'ADD':U, 'NavigationSourceEvents':U, 'RegisterObject':U)
        .
    RUN modifyListProperty IN TARGET-PROCEDURE
        ( THIS-PROCEDURE, 'ADD':U, 'NavigationSourceEvents':U, 'unRegisterObject':U).

    RUN modifyListProperty IN TARGET-PROCEDURE
         ( THIS-PROCEDURE, 'ADD':U, 'SupportedLinks':U, 'Filter-Target':U).

    {set QueryObject yes}.               /* True for SBOs as for SDOs. */

    &IF DEFINED(UpdTable1) = 0 &THEN
      {set DynamicData YES}.
    &ENDIF
  END.  /* if not adm-load-from-repos */
  
  {src/adm2/custom/sbocustom.i}
&ENDIF

/* Add and start the datalogic procedure */
&IF '{&DATA-LOGIC-PROCEDURE}':U <> '':U AND '{&DATA-LOGIC-PROCEDURE}':U <> '.p':U &THEN
  {set DataLogicProcedure '{&DATA-LOGIC-PROCEDURE}':U}.
&ENDIF

/* Exclude the static function for a dynamic data object */ 
&IF DEFINED(UpdTable1) = 0 &THEN
   &SCOPED-DEFINE EXCLUDE-remoteCommitTransaction
   &SCOPED-DEFINE EXCLUDE-serverCommitTransaction
   &SCOPED-DEFINE EXCLUDE-initDataObjectOrdering
&ELSE
    DEFINE VARIABLE i_ AS INTEGER    NO-UNDO. /* to avoid conflict with user vars */
    DEFINE VARIABLE c_ AS CHARACTER  NO-UNDO.
    DO i_ = 1 TO 20: /* 20: Hardcoded number of max supported SDOs */
      IF VALID-HANDLE(ghUpdTables[i_]) THEN
        c_ = c_ + (IF c_ = "" THEN "" ELSE ",") + STRING(ghUpdTables[i_]).
      ELSE LEAVE.
    END.
    {set UpdateTables c_}.
    {set DynamicData NO}.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-remoteCommitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remoteCommitTransaction Method-Library 
PROCEDURE remoteCommitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     server-side version of CommitTransaction to receive all
               RowObjUpd table updates and pass them on to server-side SDOs.
  Parameters:  INPUT-OUTPUT -- up to twenty RowObjUpd table references -- 
                  unused tables have dummy placeholder TABLE-HANDLEs;
               OUTPUT pcMessages AS CHARACTER -- error messages
               OUTPUT pcUndoIds  AS CHARACTER -- rowids of error'd rows
------------------------------------------------------------------------------*/ 
  DEFINE INPUT-OUTPUT PARAMETER pccontext AS CHAR NO-UNDO.

  {src/adm2/updparam.i 1 INPUT-OUTPUT}
  {src/adm2/updparam.i 2 INPUT-OUTPUT}
  {src/adm2/updparam.i 3 INPUT-OUTPUT}
  {src/adm2/updparam.i 4 INPUT-OUTPUT}
  {src/adm2/updparam.i 5 INPUT-OUTPUT}
  {src/adm2/updparam.i 6 INPUT-OUTPUT}
  {src/adm2/updparam.i 7 INPUT-OUTPUT}
  {src/adm2/updparam.i 8 INPUT-OUTPUT}
  {src/adm2/updparam.i 9 INPUT-OUTPUT}
  {src/adm2/updparam.i 10 INPUT-OUTPUT}
  {src/adm2/updparam.i 11 INPUT-OUTPUT}
  {src/adm2/updparam.i 12 INPUT-OUTPUT}
  {src/adm2/updparam.i 13 INPUT-OUTPUT}
  {src/adm2/updparam.i 14 INPUT-OUTPUT}
  {src/adm2/updparam.i 15 INPUT-OUTPUT}
  {src/adm2/updparam.i 16 INPUT-OUTPUT}
  {src/adm2/updparam.i 17 INPUT-OUTPUT}
  {src/adm2/updparam.i 18 INPUT-OUTPUT}
  {src/adm2/updparam.i 19 INPUT-OUTPUT}
  {src/adm2/updparam.i 20 INPUT-OUTPUT}

  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER   NO-UNDO.

  RUN setContextAndInitialize IN TARGET-PROCEDURE(pcContext).

  RUN bufferCommitTransaction IN TARGET-PROCEDURE
                 (OUTPUT pcMessages, OUTPUT pcUndoIds). 

  pccontext = {fn obtainContextForClient}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommitTransaction Method-Library 
PROCEDURE serverCommitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     server-side version of CommitTransaction to receive all
               RowObjUpd table updates and pass them on to server-side SDOs.
  Parameters:  INPUT-OUTPUT -- up to twenty RowObjUpd table references -- 
                  unused tables have dummy placeholder TABLE-HANDLEs;
               OUTPUT pcMessages AS CHARACTER -- error messages
               OUTPUT pcUndoIds  AS CHARACTER -- rowids of error'd rows
------------------------------------------------------------------------------*/ 
  {src/adm2/updparam.i 1 INPUT-OUTPUT}
  {src/adm2/updparam.i 2 INPUT-OUTPUT}
  {src/adm2/updparam.i 3 INPUT-OUTPUT}
  {src/adm2/updparam.i 4 INPUT-OUTPUT}
  {src/adm2/updparam.i 5 INPUT-OUTPUT}
  {src/adm2/updparam.i 6 INPUT-OUTPUT}
  {src/adm2/updparam.i 7 INPUT-OUTPUT}
  {src/adm2/updparam.i 8 INPUT-OUTPUT}
  {src/adm2/updparam.i 9 INPUT-OUTPUT}
  {src/adm2/updparam.i 10 INPUT-OUTPUT}
  {src/adm2/updparam.i 11 INPUT-OUTPUT}
  {src/adm2/updparam.i 12 INPUT-OUTPUT}
  {src/adm2/updparam.i 13 INPUT-OUTPUT}
  {src/adm2/updparam.i 14 INPUT-OUTPUT}
  {src/adm2/updparam.i 15 INPUT-OUTPUT}
  {src/adm2/updparam.i 16 INPUT-OUTPUT}
  {src/adm2/updparam.i 17 INPUT-OUTPUT}
  {src/adm2/updparam.i 18 INPUT-OUTPUT}
  {src/adm2/updparam.i 19 INPUT-OUTPUT}
  {src/adm2/updparam.i 20 INPUT-OUTPUT}

  DEFINE OUTPUT PARAMETER pcMessages AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcUndoIds  AS CHARACTER   NO-UNDO.

  RUN bufferCommitTransaction IN TARGET-PROCEDURE (OUTPUT pcMessages, OUTPUT pcUndoIds). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-initDataObjectOrdering) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initDataObjectOrdering Method-Library 
FUNCTION initDataObjectOrdering RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Initializes the mapping of the AppBuilder-generated order of
            Upd tables to the developer-defined update order.
   Params:  <none>
    Notes:  This is used in commitTransaction and serverCommitTransaction
            to order the table parameters properly.  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iOrder         AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDONames       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cOrdering      AS CHARACTER  NO-UNDO INIT "":U.
 DEFINE VARIABLE iEntry         AS INTEGER    NO-UNDO.
  
  {get DataObjectNames cDONames}.
  DO iOrder = 1 TO {&MaxContainedDataObjects}:
      IF VALID-HANDLE(ghUpdTables[iOrder]) THEN
      DO:
          cObjectName = ghUpdTables[iOrder]:NAME.
          iEntry = LOOKUP(cObjectName, cDONames).
          cOrdering = cOrdering + (IF cOrdering NE "":U THEN ",":U ELSE "":U) +
              STRING(iEntry).
      END.
      ELSE LEAVE.
  END.
   
  RETURN cOrdering.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

