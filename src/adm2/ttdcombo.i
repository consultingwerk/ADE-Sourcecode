&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: ttdcombo.i

  Description:  Dynamic Combo Temp-Table Def Include

  Purpose:      Dynamic Combo Temp-Table Def Include

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:   101000015   UserRef:    
                Date:   08/14/2001  Author:     Mark Davies

  Update Notes: Dynamic Combo Temp-Table Def Include

  (v:010001)    Task:   101000025   UserRef:    
                Date:   08/30/2001  Author:     Mark Davies

  Update Notes: Added new field for KeyFormat
  
  Modified    : 05/09/2002        Mark Davies (MIP)
                Added new field to ttDCombo called hViewer to contain the
                handle a combo is on. Issue #4525

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ttdcombo.i
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-include  yes

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

DEFINE TEMP-TABLE ttDCombo NO-UNDO
FIELD hWidget               AS HANDLE           /* Handle of widget, e.g. coCompany:HANDLE */
FIELD hViewer               AS HANDLE           /* Handle if the viewer that the combo is on */
FIELD cWidgetName           AS CHARACTER        /* Name of widget, e.g. coCompany */
FIELD lRefreshQuery         AS LOGICAL          /* If No then the query has not changed */
FIELD cWidgetType           AS CHARACTER        /* Data Type of widget, e.g. DECIMAL, INTEGER, CHARACTER, DATE, etc. */
FIELD cForEach              AS CHARACTER        /* FOR EACH statement used to retrieve the data, e.g. FOR EACH gsm_user NO-LOCK BY gsm_user.user_login_name */
FIELD cBufferList           AS CHARACTER        /* comma delimited list of buffers used in FOR EACH, e.g. gsm_user */
FIELD cPhysicalTableNames   AS CHARACTER        /* comma delimited list of actual DB Tables names of buffers defined that corresponds with cBufferList */
FIELD cTempTableNames       AS CHARACTER        /* comma delimited list of PLIP names where data for define temp-tables could be retrieved, corresponds with cBufferList */
FIELD cKeyFieldName         AS CHARACTER        /* name of key field as table.fieldname, e.g. gsm_user.user_obj */
FIELD cKeyFormat            AS CHARACTER        /* The Key Field's Format */
FIELD cDescFieldNames       AS CHARACTER        /* comma delimited list of description fields as table.fieldname, e.g. gsm_user.user_login_name */
FIELD cDescSubstitute       AS CHARACTER        /* Substitution string to use when description contains multiple fields, e.g. &1 / &2 */
FIELD cFlag                 AS CHARACTER        /* Flag (N/A) N = <None>, A = <All> to include extra empty entry to indicate none or all */
FIELD cFlagValue            AS CHARACTER        /* Default value for Optional Flags (N/A) */
FIELD cCurrentKeyValue      AS CHARACTER        /* currently selected key field value */
FIELD cListItemDelimiter    AS CHARACTER        /* Delimiter for list item pairs, e.g. , */
FIELD cListItemPairs        AS CHARACTER        /* Found list item pairs */
FIELD cCurrentDescValue     AS CHARACTER        /* If specified cCurrentKeyValue is valid, this field will contain corresponding list-item pair description */
FIELD cKeyValues            AS CHARACTER        /* Contains a Delimited list of key field values in the combo list - the delimired used is that of field cListItemDelimiter */
FIELD cDescriptionValues    AS CHARACTER        /* Contains a Delimited list of description field values (in substituted form) in the combo list - the delimired used is that of field cListItemDelimiter */
FIELD cParentField          AS CHARACTER        /* Comma seperated list of parent dependancy fields */
FIELD cParentFilterQuery    AS CHARACTER        /* A filter query to be applied to combo for parent dependancies */
FIELD iBuildSequence        AS INTEGER          /* The sequence number in which the combo's data should be populated */
FIELD lUseCache             AS LOGICAL          /* When this is set to FALSE and the SDF Cache manager is running then we will not use the cached information */
INDEX keyIndex IS PRIMARY hWidget
INDEX keyCont  hViewer
INDEX keyRefresh  hViewer lRefreshQuery
INDEX key2 cWidgetName.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


