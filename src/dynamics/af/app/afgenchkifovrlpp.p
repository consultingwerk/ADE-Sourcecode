&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "CreateWizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* New Program Wizard
Destroy on next read */
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
/*---------------------------------------------------------------------------------
  File: afgenchkifovrlpp.p

  Description:  checkIfOverlap AppServer Proxy

  Purpose:      checkIfOverlap AppServer Proxy

  Parameters:  INPUT  pcTable             - Name of table to do search on
               INPUT  pcKeyField          - Name of the keyfield to use in search (Most probably foreign-key)
               INPUT  ptFromField         - Name of the 'from field', i.e. from_date / admission_date
               INPUT  ptToField           - Name of the 'to field',   i.e. to_date   / discharge_date
               INPUT  pdCurrentRecordObj  - Obj value of current record - just to ensure that you don't compare
                                            values to the same record when modifying
               INPUT  pdKeyValue          - Value of the keyfield,    i.e. obj number
               INPUT  ptFromValue         - Value to compare from
               INPUT  ptToValue           - Value to compare to
               INPUT  pcAdditionalWhere   - Addtional where clause that can be added to the query if needed
                      *** REMEMBER: It creates a buffer for pcTable, thus if you passed in gsm_person, the created
                                    buffer will be bgsm_person. In pcAdditionalWhere remember to use the prefixed
                                    'b' in your criteria specification
               OUTPUT plOverlap           - Logical value specifying if overlapping was found
               OUTPUT ptOverlapFrom       - Null(?) if no overlapping, otherwise from date of overlapping record
               OUTPUT ptOverlapTo         - Null(?) if no overlapping, otherwise to   date of overlapping record


  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTable             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcKeyField          AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFromField         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcToField           AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdCurrentRecordObj  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdKeyValue          AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER ptFromValue         AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER ptToValue           AS DATE       NO-UNDO.
DEFINE INPUT  PARAMETER pcAdditionalWhere   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plOverlap           AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER ptOverlapFrom       AS DATE       NO-UNDO.
DEFINE OUTPUT PARAMETER ptOverlapTo         AS DATE       NO-UNDO.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afgenchkifovrlpp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000




/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

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
         HEIGHT             = 12.76
         WIDTH              = 46.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    RUN checkIfOverlaps IN gshGenManager
    	(INPUT pcTable,
    	 INPUT pcKeyField,
    	 INPUT pcFromField,
    	 INPUT pcToField,
    	 INPUT pdCurrentRecordObj,
    	 INPUT pdKeyValue,
    	 INPUT ptFromValue,
    	 INPUT ptToValue,
    	 INPUT pcAdditionalWhere,
    	 OUTPUT plOverlap,
    	 OUTPUT ptOverlapFrom,
    	 OUTPUT ptOverlapTo) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
    	RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
    			ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


