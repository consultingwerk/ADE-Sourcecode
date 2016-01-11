&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : _abpref.i
    Purpose     : Get AppBuilder preferences.    
    Syntax      : {abpref.i &NEW=NEW}
                  {abpref.i}                     
    Description : AppBuilder preferences are stored in the 
                  temp-tables and variables defined in the includes.
Input Parameter : pPreferences - comma separated list of preferences.  
Output Parameter: pValueList  - CHR(3) separated list of corresponding values. 
 
                                                              
Preposessor Parameter &NEW 
                   NEW   the variables will be defined as NEW
                         and _getpref.w will be run to set the data.    
                   blank the data is shared and are supposedly defined as 
                         new in the Appbuilder and the values are already set.  
    
    Author(s)   : Haavard Danielsen
    Created     : 4/16/98
    Notes       : This is the guts of _abpref1 and _abpref2 procedures.
                  _abpref1 just includes this 
                  _abpref2 defines &new=new and includes this    
                  
                  Both are used in _abpref.p.    
                           
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT  PARAMETER pPreferences AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pValueList   AS CHAR NO-UNDO.

{adeuib/sharvars.i {&new}}
{adeuib/gridvars.i {&new}}
{adeuib/advice.i   {&new}}

DEFINE VARIABLE i          AS INTEGER NO-UNDO.
DEFINE VARIABLE PrefEntry  AS CHAR    NO-UNDO.
DEFINE VARIABLE ValidEntry AS LOG     NO-UNDO.
DEFINE VARIABLE PrefValue  AS CHAR    NO-UNDO.
DEFINE VARIABLE xDelimit   AS CHAR    NO-UNDO.

xDelimit = CHR(3).

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


&IF "{&NEW}" = "NEW" &THEN

RUN adeuib/_getwebp.p ("proAB":U).

&ENDIF 

DO i = 1 to num-entries(pPreferences):
  ASSIGN
    PrefEntry  = ENTRY(i,pPreferences).
  CASE PrefEntry:
     WHEN "WebBroker" THEN 
        PrefValue = _brokerURL.       
     WHEN "OpenNewBrowser" THEN 
        PrefValue = IF _open_new_browse THEN "TRUE" ELSE "FALSE".       
     WHEN "RemoteFileManagement" THEN 
        PrefValue = IF _remote_file THEN "TRUE" ELSE "FALSE".               
     WHEN "WebBrowser" THEN 
        PrefValue = _webbrowser.
     OTHERWISE 
        PrefValue = "<preference: " + PrefEntry + " not found>".            
  END.
  ASSIGN 
    PrefValue  = IF PrefValue = ? THEN "?" ELSE PrefValue 
    pValueList = (IF pValueList = "" 
                  THEN ""
                  ELSE pValueList + xDelimit) 
                  + PrefValue.                   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


