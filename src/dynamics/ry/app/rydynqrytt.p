&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rydynqrytt.p

  Description:  Generic routine to populate dynamic tt

  Purpose:      Generic routine to populate dynamic tt from dynamic query.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6962   UserRef:    
                Date:   07/12/2000  Author:     Jenny Bond

  Update Notes: Created from Template rytemprocp.p

  (v:010001)    Task:        7748   UserRef:    
                Date:   31/01/2001  Author:     Jenny Bond

  Update Notes: Complete Smart Object Maintenance

  (v:010100)    Task:    90000052   UserRef:    POSSE
                Date:   25/04/2001  Author:     Phil Magnay

  Update Notes: ok

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydynqrytt.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010100
&SCOPED-DEFINE maxnum 900000

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE INPUT        PARAMETER pcQuery     AS CHARACTER      NO-UNDO.
DEFINE INPUT        PARAMETER pcAction    AS CHARACTER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER phTTHandle  AS HANDLE         NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getBufferList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBufferList Procedure 
FUNCTION getBufferList RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER )  FORWARD.

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
         HEIGHT             = 9.57
         WIDTH              = 44.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hQuery              AS HANDLE       NO-UNDO.
DEFINE VARIABLE cBufferList         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hBuffer             AS HANDLE       NO-UNDO.
DEFINE VARIABLE iFieldsLoop         AS INTEGER      NO-UNDO.
DEFINE VARIABLE iBuffer             AS INTEGER      NO-UNDO.
DEFINE VARIABLE lOk                 AS LOGICAL      NO-UNDO.
DEFINE VARIABLE hTT                 AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDB                 AS HANDLE       NO-UNDO.
DEFINE VARIABLE httColumn           AS HANDLE       NO-UNDO.
DEFINE VARIABLE hdbColumn           AS HANDLE       NO-UNDO.
DEFINE VARIABLE cBufferHdlList      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hTTBuffer           AS HANDLE       NO-UNDO.
DEFINE VARIABLE hDBBuffer           AS HANDLE       NO-UNDO.
DEFINE VARIABLE hTTBuffer2          AS HANDLE       NO-UNDO.
DEFINE VARIABLE iRowNum             AS INTEGER      NO-UNDO INITIAL {&maxnum}.
DEFINE VARIABLE iBufferLoop         AS INTEGER      NO-UNDO.
DEFINE VARIABLE cRowident           AS CHARACTER    NO-UNDO INITIAL "":u.
DEFINE VARIABLE httColumn2          AS HANDLE       NO-UNDO.
DEFINE VARIABLE iLoop               AS INTEGER      NO-UNDO.
DEFINE VARIABLE hBuffer2            AS HANDLE       NO-UNDO.

/* Call function to extract buffer names from query */
cBufferList = getBufferList(INPUT pcQuery).

IF cBufferList <> "":U AND cBufferList <> ? THEN DO:
    /* Create a query */

    CREATE QUERY hQuery NO-ERROR.

    IF  pcQuery <> "":U THEN DO:
        buffer-loop:
        DO iBufferLoop = 1 TO NUM-ENTRIES(cBufferList):
            CREATE BUFFER hBuffer FOR TABLE ENTRY(iBufferLoop, cBufferList) NO-ERROR.
            IF  ERROR-STATUS:ERROR THEN
                NEXT buffer-loop.
            cBufferHdlList = cBufferHdlList + (IF cBufferHdlList <> "":U THEN ",":U ELSE "":U) + STRING(hBuffer).
            hQuery:ADD-BUFFER(hBuffer) NO-ERROR.
            {af/sup2/afcheckerr.i}
        END. /* buffer-loop */

        lOk = hQuery:QUERY-PREPARE(pcQuery) NO-ERROR.
        {af/sup2/afcheckerr.i}
    END.
    ELSE lOk = NO.    

    IF lOk THEN DO:
        /* Open the query */
        hQuery:QUERY-OPEN() NO-ERROR.
        {af/sup2/afcheckerr.i}
    END.

    hTTBuffer = phTTHandle:DEFAULT-BUFFER-HANDLE.

    QueryLoop:
    REPEAT:
        /*  need to cater for add situation, where we won't have a record, but we still want to
            assign the initial values and  */
        IF  lOk THEN
            hQuery:GET-NEXT().

        /*
        DO  iBufferLoop = 1 TO NUM-ENTRIES(cBufferHdlList):
            ASSIGN
                hBuffer = WIDGET-HANDLE(ENTRY(iBufferLoop, cBufferHdlList)).
            IF  NOT VALID-HANDLE(hBuffer) THEN
                LEAVE QueryLoop.
        END.
        */

        IF  hQuery:QUERY-OFF-END AND pcQuery <> "":U THEN
            LEAVE QueryLoop.

        httBuffer:BUFFER-CREATE.
        cRowident = "":u.

        BufferLoop:
        DO  iBufferLoop = 1 TO hQuery:NUM-BUFFERS:
            hDBBuffer = hQuery:GET-BUFFER-HANDLE(iBufferLoop).

            /*
            IF NOT hDbBuffer:AVAILABLE THEN
                NEXT BufferLoop.
            */

            IF hDBBuffer:AVAILABLE THEN
            DO:

                IF  pcAction BEGINS "A":u THEN
                FieldsLoop:                
                DO iFieldsLoop = 1 TO hTTBuffer:NUM-FIELDS: /* we are adding */
                    httColumn = hTTBuffer:BUFFER-FIELD(iFieldsLoop) NO-ERROR.
                    hdbColumn = hDBBuffer:BUFFER-FIELD(httColumn:NAME) NO-ERROR.

                    IF  httColumn = ? OR hdbColumn = ? THEN
                        NEXT FieldsLoop.

                    /* Assign DB initial values */
                    httColumn:BUFFER-VALUE = IF httColumn:INITIAL = ? THEN "":U
                        ELSE IF httColumn:DATA-TYPE = "DATE":U AND httColumn:INITIAL = "TODAY":U THEN STRING(TODAY)
                        ELSE httColumn:INITIAL NO-ERROR.
                END.
                ELSE DO:
                    hTTBuffer:BUFFER-COPY(hDBBuffer).
                END.
            END.

            ASSIGN
                cRowident = cRowident 
                          + (IF iBufferLoop = 1 THEN "":U ELSE ",")
                          + (IF hDBBuffer:AVAILABLE THEN STRING(hDBBuffer:ROWID) ELSE "":U).
        END.

        hTTColumn = hTTBuffer:BUFFER-FIELD("rowIdent").

        IF  VALID-HANDLE(hTTColumn) THEN
            ASSIGN
                hTTColumn:BUFFER-VALUE = cRowident.

        hTTColumn = hTTBuffer:BUFFER-FIELD("rowNum").

        IF  VALID-HANDLE(hTTColumn) THEN
            ASSIGN
                hTTColumn:BUFFER-VALUE = STRING(iRownum).

        hTTColumn = hTTBuffer:BUFFER-FIELD("rowMod").

        IF  VALID-HANDLE(hTTColumn) THEN
            ASSIGN
                hTTColumn:BUFFER-VALUE = IF pcAction BEGINS "M":u THEN "U":u
                                         ELSE IF pcAction BEGINS "V":u THEN "":u
                                         ELSE IF LENGTH(pcAction) > 0 THEN SUBSTRING(pcAction, 1, 1)
                                         ELSE pcAction.

        iRowNum = iRowNum + 1.

        IF  pcAction BEGINS "M":u
        OR  pcAction BEGINS "U":U THEN DO:
            CREATE BUFFER hBuffer2 FOR TABLE hTTBuffer BUFFER-NAME "buffer2".

            hBuffer2:BUFFER-COPY(hTtbuffer,"rowmod":u). /* exclude 'rowmod' */
            hTTColumn = hBuffer2:BUFFER-FIELD("rowmod":u).
            hTTColumn:BUFFER-VALUE = "":u.
        END.

        IF  pcQuery = "" THEN /* this would indicate we are creating 1 record in an add situation with the initial db values */
        LEAVE QueryLoop.

    END.

    DELETE OBJECT hQuery.

    ASSIGN
        hQuery = ?
        ERROR-STATUS:ERROR = NO.

    delete-buffer-loop:                                        
    DO  iBufferLoop = 1 TO NUM-ENTRIES(cBufferHdlList):               
        hBuffer = WIDGET-HANDLE(ENTRY(iBufferLoop, cBufferHdlList)). 
        DELETE OBJECT hBuffer NO-ERROR.                        
        ASSIGN hBuffer = ?.                                    
    END. /* delete-buffer-loop */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getBufferList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBufferList Procedure 
FUNCTION getBufferList RETURNS CHARACTER
  ( INPUT pcQueryString AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
  Purpose:     Get buffers from query string
  Parameters:  input query string
               output buffer list
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cBufferList AS CHARACTER    NO-UNDO.

DEFINE VARIABLE iStart                            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPosn                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos1                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos2                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos3                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos4                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos5                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos6                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos7                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos8                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos9                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLen                              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBuffer                           AS CHARACTER  NO-UNDO.

ASSIGN iStart = 1.


buffer-loop:
REPEAT WHILE TRUE:

  ASSIGN
    cBuffer = "":U
    iPos1 = INDEX(pcQueryString, " EACH ":U, iStart)
    iPos2 = INDEX(pcQueryString, " FIRST ":U, iStart)
    iPos3 = INDEX(pcQueryString, " LAST ":U, iStart)
    iPos4 = INDEX(pcQueryString, ",EACH ":U, iStart)
    iPos5 = INDEX(pcQueryString, ",FIRST ":U, iStart)
    iPos6 = INDEX(pcQueryString, ",LAST ":U, iStart)
    iPos7 = INDEX(pcQueryString, CHR(10) + "EACH ":U, iStart)
    iPos8 = INDEX(pcQueryString, CHR(10) + "FIRST ":U, iStart)
    iPos9 = INDEX(pcQueryString, CHR(10) + "LAST ":U, iStart)
    iPosn = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iPosn = IF (iPos2 > 0 AND iPos2 < iPosn) THEN iPos2 ELSE iPosn
    iPosn = IF (iPos3 > 0 AND iPos3 < iPosn) THEN iPos3 ELSE iPosn
    iPosn = IF (iPos4 > 0 AND iPos4 < iPosn) THEN iPos4 ELSE iPosn
    iPosn = IF (iPos5 > 0 AND iPos5 < iPosn) THEN iPos5 ELSE iPosn
    iPosn = IF (iPos6 > 0 AND iPos6 < iPosn) THEN iPos6 ELSE iPosn
    iPosn = IF (iPos7 > 0 AND iPos7 < iPosn) THEN iPos7 ELSE iPosn
    iPosn = IF (iPos8 > 0 AND iPos8 < iPosn) THEN iPos8 ELSE iPosn
    iPosn = IF (iPos9 > 0 AND iPos9 < iPosn) THEN iPos9 ELSE iPosn
    .
  IF iPosn = 0 OR iPosn = 999999 THEN LEAVE buffer-loop.

  IF SUBSTRING(pcQueryString,iPosn + 1,1) = "F":U THEN
    ASSIGN iLen = 6.
  ELSE
    ASSIGN iLen = 5.

  ASSIGN iStart = iPosn + iLen.

  /* Found a buffer - get its name, minus the DB reference */
  ASSIGN
    cBuffer = TRIM(SUBSTRING(pcQueryString,iPosn + iLen))
    iPos1 = INDEX(cBuffer, " ":U)
    iPos2 = INDEX(cBuffer, ",":U)
    iLen = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iLen = IF (iPos2 > 0 AND iPos2 < iLen) THEN iPos2 ELSE iLen    
    .
    IF iLen = 0 OR iLen = 999999 THEN ASSIGN iLen = LENGTH(cBuffer) + 1.

  ASSIGN
    cBuffer = SUBSTRING(cBuffer,1,iLen - 1).

  IF NUM-ENTRIES(cBuffer,".":U) = 2 THEN
    ASSIGN cBuffer = ENTRY(2,cBuffer,".":U).  /* strip off DB */

  IF LENGTH(cBuffer) > 0 THEN
    ASSIGN
      cBufferList = cBufferList + (IF cBufferList <> "":U THEN ",":U ELSE "":U) +
                  cBuffer
      .
END.

RETURN cBufferList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

