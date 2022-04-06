&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : saxprop.i  
    Purpose     : Provides basic ADM functionality without including most of 
                  the ADM code.
  
    Syntax      : {src/adm2/saxprop.i}

    Author(s)   : D.M.Adams
    Created     : 02/03/2002
    Notes       : Loosely based on ADM Version 1.0 code
--------------------------------------------------------------------------*/
/*            This .i file was created with Progress Appbuilder           */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/* Custom instance definition file */
{src/adm2/custom/saxdefscustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 12.14
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/saxprto.i}
  &ENDIF
&ENDIF

&GLOBAL-DEFINE xpContextMode
&GLOBAL-DEFINE xpNode      
&GLOBAL-DEFINE xpParentNode
&GLOBAL-DEFINE xpSequence  
&GLOBAL-DEFINE xpPath     

/* Now include the next-level-up property include file. This builds up the 
   property temp-table definition, to which we will add our field definitions. */
{src/adm2/smrtprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('ContextMode':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('Node':U, 'DECIMAL':U, 0, ?, 0.0).
  ghADMProps:ADD-NEW-FIELD('ParentNode':U, 'DECIMAL':U, 0, ?, 0.0).
  ghADMProps:ADD-NEW-FIELD('Sequence':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('Path':U, 'CHARACTER':U, 0, ?, '').
&ENDIF
END.

{src/adm2/custom/saxpropcustom.i}

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


