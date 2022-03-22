&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"SAX Handler Template

Use this template to create a procedure file containing SAX callback event override procedures."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS saxObject 
/*------------------------------------------------------------------------------
  File: sax.p

  Description:  

  Purpose:

  Parameters:   <none>

  Updated: 03/05/02 adams@progress.com
             Initial version
             
-------------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.            */
/*-----------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created by this procedure. 
   This is a good default which assures that this procedure's triggers and 
   internal procedures will execute in this procedure's storage, and that 
   proper cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SaxHandler
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SaxHandler Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW saxObject ASSIGN
         HEIGHT             = 10.24
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB saxObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/sax.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK saxObject 


/* ***************************  Main Block  *************************** */

/* If testing in the AppBuilder, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
