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
  File: rydesrpobp.p

  Description:  RDM procedure: reorder page objects

  Purpose:      RDM procedure: reorder page objects. This procedure is necessary because
                of the fact that the Repository Design Manager is very near the ecode
                segment limits.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    10361
                Date:   05/19/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydesrpobp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE INPUT PARAMETER pcWhichObject            AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pdContainerSmartObject   AS DECIMAL              NO-UNDO.
DEFINE INPUT PARAMETER pdPageObj                AS DECIMAL              NO-UNDO.
DEFINE INPUT PARAMETER pdObjectInstanceObj      AS DECIMAL              NO-UNDO.
DEFINE INPUT PARAMETER piSequence               AS INTEGER              NO-UNDO.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
    DEFINE VARIABLE iOrder              AS INTEGER                          NO-UNDO.
    
    DEFINE BUFFER ryc_page            FOR ryc_page.
    DEFINE BUFFER ryc_object_instance FOR ryc_object_instance.

    CASE pcWhichObject:
        WHEN "PAGE":U THEN
        DO:
            /* Keep the record we want, out of the way of harm. */
            FIND FIRST ryc_page WHERE
                       ryc_page.page_obj = pdPageObj
                       EXCLUSIVE-LOCK.
    
            ASSIGN iOrder                 = ryc_page.page_sequence
                   ryc_page.page_sequence = -1 * piSequence
                   NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
            /* Set order lower than current */
            IF piSequence LT iOrder THEN
            DO:
                FOR EACH ryc_page WHERE
                         ryc_page.container_smartObject_obj = pdContainerSmartObject AND
                         ryc_page.page_sequence            >= piSequence
                         EXCLUSIVE-LOCK
                         BY ryc_page.page_sequence DESCENDING:
    
                    ASSIGN ryc_page.page_sequence = ryc_page.page_sequence + 1 NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
                        RETURN ERROR {aferrortxt.i 'AF' '40' 'ryc_page' 'page_sequence' '"The page sequence could not be re-ordered."'}.
                END.
            END.        /* reorder; new sequence less than original  */
    
            IF piSequence GT ryc_page.page_sequence THEN
            DO:            
                FOR EACH ryc_page WHERE
                         ryc_page.container_smartObject_obj = pdContainerSmartObject AND
                         ryc_page.page_sequence             >= 0              AND
                         ryc_page.page_sequence             <= piSequence
                         EXCLUSIVE-LOCK
                         BY ryc_page.page_sequence:
                    ASSIGN ryc_page.page_sequence = ryc_page.page_sequence - 1.                
                END.    /* reorder; new sequence more that original */
            END.    /* new sequence > old */
    
            FIND FIRST ryc_page WHERE
                       ryc_page.page_obj = pdPageObj
                       EXCLUSIVE-LOCK.
            ASSIGN ryc_page.page_sequence = piSequence NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
            VALIDATE ryc_page NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.            
        END.    /* page */
        WHEN "PAGE-OBJECT":U THEN
        DO:
            /* Keep the record we want, out of the way of harm. */
            FIND FIRST ryc_object_instance WHERE
                       ryc_object_instance.object_instance_obj = pdObjectInstanceObj
                       EXCLUSIVE-LOCK.
    
            ASSIGN iOrder                              = ryc_object_instance.object_sequence
                   ryc_object_instance.object_sequence = -1 * piSequence
                   NO-ERROR.

            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
            /* Set order lower than current */
            IF piSequence LT iOrder THEN
            DO:            
                FOR EACH ryc_object_instance WHERE
                         ryc_object_instance.container_smartObject_obj = pdContainerSmartObject AND
                         ryc_object_instance.page_obj                  = pdPageObj     AND
                         ryc_object_instance.object_sequence          >= piSequence
                         EXCLUSIVE-LOCK
                         BY ryc_object_instance.object_sequence DESCENDING:
        
                    ASSIGN ryc_object_instance.object_sequence = ryc_object_instance.object_sequence + 1 NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
                END.        /* reorder; new sequence less than original  */
            END.

            IF piSequence GT ryc_object_instance.object_sequence THEN
            DO:            
                FOR EACH ryc_object_instance WHERE
                         ryc_object_instance.container_smartObject_obj = pdContainerSmartObject   AND
                         ryc_object_instance.page_obj                  = pdPageObj AND
                         ryc_object_instance.object_sequence          >= 0                 AND
                         ryc_object_instance.object_sequence          <= piSequence
                         EXCLUSIVE-LOCK
                         BY ryc_object_instance.object_sequence:
        
                    ASSIGN ryc_object_instance.object_sequence = ryc_object_instance.object_sequence - 1 NO-ERROR.
                    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
                END.    /* reorder; new sequence more that original */
            END.

            FIND FIRST ryc_object_instance WHERE
                       ryc_object_instance.object_instance_obj = pdObjectInstanceObj
                       EXCLUSIVE-LOCK.
            ASSIGN ryc_object_instance.object_sequence = piSequence NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
    
            VALIDATE ryc_object_instance NO-ERROR.
            IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR RETURN-VALUE.
        END.    /* page-object */
    END CASE.   /* which object */

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.

    /* - EOF - */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


