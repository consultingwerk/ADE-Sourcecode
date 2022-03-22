&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : _abprefs.i
    Purpose     : Get AppBuilder preferences from Appbuilder if we are able 
                  to share data or from .ini file if not.   
    Syntax      : 

    Description : This is a wrapper that either 
                   runs _abpref1 to get shared data
                  and if that goes wrong it 
                   runs _abpref2 that runs _getpref.p  
Input Parameter : pPreferences - comma separated list of preferences.  
Output Parameter: pValueList  - CHR(3) separated list of corresponding values. 

    Author(s)   : Haavard Danielsen
    Created     : 4/16/98
    Notes       : 
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pPreferences AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pValueList   AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN adeuib/_abpref1.p (pPreferences, OUTPUT pValueList) NO-ERROR.

IF  ERROR-STATUS:ERROR 
AND ERROR-STATUS:GET-NUMBER(1) = 392 THEN
   RUN adeuib/_abpref2.p (pPreferences, OUTPUT pValueList) NO-ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


