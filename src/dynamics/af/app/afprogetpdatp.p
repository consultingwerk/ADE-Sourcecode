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
  File: afprogetpdatp.p

  Description:  afgetpdatp AppServer Proxy

  Purpose:      Get User Profile Data from Database
                Called from getProfileData
                Must always check for session data first, then permanent data.
                If a rowid is passed in, then this will be used to find the record.
                If the next flag is set to yes, then a FIND NEXT will be done to
                retrieve the record after the record passed in.

  Parameters:   input profile type code
                input profile code
                input profile data key
                input get next record flag YES/NO
                input-output rowid of record found or ? if not found
                output profile data value if found
                output context id if found session data else blank if found permanent data
                output user object number of profile data found
                output profile type object number of profile data found
                output profile code object number of profile data found
                output flag for server profile type YES/NO

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/24/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER        pcProfileTypeCode       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER        pcProfileCode           AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER        pcProfileDataKey        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER        plNextRecordFlag        AS LOGICAL    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER prRowid                 AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER       pcProfileDataValue      AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER       pcContextId             AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER       pdUserObj               AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER       pdProfileTypeObj        AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER       pdProfileCodeObj        AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER       plServerProfileType     AS LOGICAL    NO-UNDO.

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afprogetpdatp.p
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
         HEIGHT             = 20.52
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

  RUN afgetpdatp IN gshProfileManager
    (INPUT        pcProfileTypeCode,    
     INPUT        pcProfileCode,        
     INPUT        pcProfileDataKey,     
     INPUT        plNextRecordFlag,     
     INPUT-OUTPUT prRowid,            
     OUTPUT       pcProfileDataValue, 
     OUTPUT       pcContextId,        
     OUTPUT       pdUserObj,          
     OUTPUT       pdProfileTypeObj,   
     OUTPUT       pdProfileCodeObj,   
     OUTPUT       plServerProfileType) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
      RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


