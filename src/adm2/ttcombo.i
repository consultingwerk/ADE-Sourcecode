&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: ttcombo.i

  Description:  Combo data build temp-table

  Purpose:      Combo data build temp-table

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   29/05/2000  Author:     Anthony Swindells

  Update Notes: Created from Template afteminclu.i

  (v:010001)    Task:        6010   UserRef:    
                Date:   13/06/2000  Author:     Anthony Swindells

  Update Notes: Add datatypt to temp-table

  (v:010002)    Task:        6421   UserRef:    
                Date:   07/08/2000  Author:     Anthony Swindells

  Update Notes: Change primary key to be on handle and allow duplicate names - to support
                generic code

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ttcombo.i
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

DEFINE TEMP-TABLE ttComboData NO-UNDO
FIELD hWidget               AS HANDLE           /* Handle of widget, e.g. coCompany:HANDLE */
FIELD cWidgetName           AS CHARACTER        /* Name of widget, e.g. coCompany */
FIELD cWidgetType           AS CHARACTER        /* Data Type of widget, e.g. DECIMAL, INTEGER, CHARACTER, DATE, etc. */
FIELD cForEach              AS CHARACTER        /* FOR EACH statement used to retrieve the data, e.g. FOR EACH gsm_user NO-LOCK BY gsm_user.user_login_name */
FIELD cBufferList           AS CHARACTER        /* comma delimited list of buffers used in FOR EACH, e.g. gsm_user */
FIELD cKeyFieldName         AS CHARACTER        /* name of key field as table.fieldname, e.g. gsm_user.user_obj */
FIELD cDescFieldNames       AS CHARACTER        /* comma delimited list of description fields as table.fieldname, e.g. gsm_user.user_login_name */
FIELD cDescSubstitute       AS CHARACTER        /* Substitution string to use when description contains multiple fields, e.g. &1 / &2 */
FIELD cFlag                 AS CHARACTER        /* Flag (N/A) N = <None>, A = <All> to include extra empty entry to indicate none or all */
FIELD cCurrentKeyValue      AS CHARACTER        /* currently selected key field value */
FIELD cListItemDelimiter    AS CHARACTER        /* Delimiter for list item pairs, e.g. , */
FIELD cListItemPairs        AS CHARACTER        /* Found list item pairs */
FIELD cCurrentDescValue     AS CHARACTER        /* If specified cCurrentKeyValue is valid, this field will contain corresponding list-item pair description */
INDEX keyIndex IS PRIMARY hWidget
INDEX key2 cWidgetName
.

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
         HEIGHT             = 5.95
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


