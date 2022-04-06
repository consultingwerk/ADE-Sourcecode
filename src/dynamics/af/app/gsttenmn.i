&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Include _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: gsttenmn.i

  Description:  EntityMnemonic cache temp-table

  Purpose:      Defines the ttEntityMnemonic temp-table used for caching the
                gsc_entity_mnemonic table

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000041   UserRef:    
                Date:   20/04/2001  Author:     Ross Hunter

  Update Notes: Created from Template ryteminclu.i

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Astra 2 object identifying preprocessor */
&glob   AstraInclude    yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 9.57
         WIDTH              = 42.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
&IF DEFINED(ttEntityMnemonic) = 0 &THEN
    DEFINE TEMP-TABLE ttEntityMnemonic NO-UNDO
        LIKE gsc_entity_mnemonic        
        FIELD hasAudit       AS LOGICAL
        FIELD hasComment     AS LOGICAL
        FIELD hasAutoComment AS LOGICAL
        INDEX idxMain    AS PRIMARY
            entity_mnemonic
        .
    &GLOBAL-DEFINE ttEntityMnemonic
&ENDIF

&IF DEFINED(ttEntityDisplayField) = 0 &THEN
    DEFINE TEMP-TABLE ttEntityDisplayField NO-UNDO
        LIKE gsc_entity_display_field        
        FIELD display_field_datatype  AS CHARACTER
        INDEX idxMain    AS PRIMARY
            entity_mnemonic
            display_field_name
        .
    &GLOBAL-DEFINE ttEntityDisplayField
&ENDIF

/* Used for retrieving the entity from the DB. */
&IF DEFINED(ttEntityMap) = 0 &THEN
    DEFINE TEMP-TABLE ttEntityMap NO-UNDO
        LIKE ttEntityMnemonic.
    &GLOBAL-DEFINE ttEntityMap
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
