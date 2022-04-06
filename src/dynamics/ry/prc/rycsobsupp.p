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
  File: rycsobsupp.p

  Description:  RYCSO browser super procedure

  Purpose:      Browser super procedure for rycsofullb.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6978   UserRef:    
                Date:   31/10/2000  Author:     Jenny Bond

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycsobsupp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

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
         HEIGHT             = 6.33
         WIDTH              = 43.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Override window title display to use 2 fields from datasource

  Parameters:  pcRelative AS CHARACTER

  Notes:       

------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

DEFINE VARIABLE hSource             AS HANDLE    NO-UNDO.
DEFINE VARIABLE cWindowTitleField   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWindowTitleColumn  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWindowTitleValue1  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWindowTitleValue2  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWindowName         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cWindowTitle        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hContainerHandle    AS HANDLE       NO-UNDO.
DEFINE VARIABLE hSourceSource       AS HANDLE       NO-UNDO.
DEFINE VARIABLE hContainerSource    AS HANDLE       NO-UNDO.

RUN SUPER(INPUT pcRelative).

{get DataSource hSource}.
IF  VALID-HANDLE(hSource) THEN
    {get DataSource hSourceSource hSource}.

cWindowTitleField = "object_type_code,object_type_description".

IF  VALID-HANDLE(hSourceSource) THEN DO:    
    cWindowTitleColumn = DYNAMIC-FUNCTION ("colValues":U IN hSourceSource, cWindowTitleField).

    IF  NUM-ENTRIES(cWindowTitleColumn, CHR(1)) = 3 THEN DO:
        cWindowTitleValue1 = ENTRY(2,cWindowTitleColumn, CHR(1)).
        cWindowTitleValue2 = ENTRY(3,cWindowTitleColumn, CHR(1)).

        IF  cWindowTitleValue1 <> ? THEN DO:
            {get ContainerSource hContainerSource}.
            IF  VALID-HANDLE(hContainerSource) THEN DO:
                {get WindowName      cWindowName      hContainerSource}.
                {get ContainerHandle hContainerHandle hContainerSource}.
            END.

            IF  INDEX(cWindowName," - ") = 0 THEN
                cWindowTitle = cWindowName.
            ELSE
                cWIndowTitle = SUBSTRING(cWindowName,1,INDEX(cWIndowName," - ") - 1).

            cWindowTitle = cWindowTitle + " - " + cWindowTitleValue1 + IF cWindowTitleValue2 <> "" THEN ": " + cWindowTitleValue2 ELSE "".
            IF  VALID-HANDLE(hContainerHandle) THEN
                hContainerHandle:TITLE = cWindowTitle.           
        END.
    END.
END.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

