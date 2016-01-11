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
  File:         fixstoreattrdflt.p

  Description:  Stores the attributes for all object types into a text file
                that will be read later.

  Purpose:      Stores the attributes for all object types into a text file
                that will be read later.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/11/2002  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       fixstoreattrdflt.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* object identifying preprocessor */
&glob   AstraProcedure    yes

/* ttAttrDefault contains a list of all the attributes that have to be added
   to an object type to extend it. */
DEFINE TEMP-TABLE ttAttrDefault NO-UNDO
  FIELD cObjectTypeCode    AS CHARACTER
  FIELD cAttributeLabel    AS CHARACTER
  FIELD constant_value     LIKE ryc_attribute_value.constant_value
  FIELD character_value    LIKE ryc_attribute_value.character_value
  FIELD logical_value      LIKE ryc_attribute_value.logical_value
  FIELD integer_value      LIKE ryc_attribute_value.integer_value
  FIELD date_value         LIKE ryc_attribute_value.date_value
  FIELD decimal_value      LIKE ryc_attribute_value.decimal_value
  FIELD raw_value          LIKE ryc_attribute_value.raw_value
  INDEX pudx IS PRIMARY UNIQUE
    cObjectTypeCode
    cAttributeLabel
.

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
         HEIGHT             = 27.81
         WIDTH              = 53.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* Add the object type attributes into the temp-table */
RUN loadOTAttributes.

/* Export the attributes to be loaded later. */
RUN exportAttributes.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-exportAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exportAttributes Procedure 
PROCEDURE exportAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Exports the contents of the attributes table to a text file
               to be loaded later.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.

    cFile = REPLACE(SESSION:TEMP-DIRECTORY,"~\","/":U).
    IF SUBSTRING(cFile,LENGTH(cFile),1) <> "/":U THEN
      cFile = cFile + "/":U.

    cFile = cFile + "storeattrdflt.d":U.

    OUTPUT TO VALUE(cFile).
    FOR EACH ttAttrDefault:
      EXPORT ttAttrDefault.
    END.
    OUTPUT CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadOTAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadOTAttributes Procedure 
PROCEDURE loadOTAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bgsc_object_type     FOR gsc_object_type.
  DEFINE BUFFER bryc_attribute_value FOR icfdb.ryc_attribute_value.
  DEFINE BUFFER bttAttrDefault       FOR ttAttrDefault.

  /* Loop through all the object types in pcTypes */
  FOR EACH bgsc_object_type NO-LOCK:

    FOR EACH bryc_attribute_value NO-LOCK
      WHERE bryc_attribute_value.object_type_obj           = bgsc_object_type.object_type_obj
        AND bryc_attribute_value.smartobject_obj           = 0.0 
        AND bryc_attribute_value.container_smartobject_obj = 0.0
        AND bryc_attribute_value.object_instance_obj       = 0.0:

      FIND FIRST bttAttrDefault 
        WHERE bttAttrDefault.cObjectTypeCode = bgsc_object_type.object_type_code
          AND bttAttrDefault.cAttributeLabel = bryc_attribute_value.attribute_label
        NO-ERROR.
      IF NOT AVAILABLE(bttAttrDefault) THEN
      DO:
        CREATE bttAttrDefault.
        ASSIGN
          bttAttrDefault.cObjectTypeCode = bgsc_object_type.object_type_code
          bttAttrDefault.cAttributeLabel = bryc_attribute_value.attribute_label
        .
        BUFFER-COPY bryc_attribute_value
          USING bryc_attribute_value.constant_value 
                bryc_attribute_value.character_value
                bryc_attribute_value.logical_value  
                bryc_attribute_value.integer_value  
                bryc_attribute_value.date_value     
                bryc_attribute_value.decimal_value  
                bryc_attribute_value.raw_value      
          TO bttAttrDefault.
      END.


    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

