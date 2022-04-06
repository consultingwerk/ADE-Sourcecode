&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : adetran\vt\_setpp.w
    Purpose     : Set VT Propath with translation directory in it.

    Syntax      : RUN adetran\vt\_setpp.w.

    Description :

    Author(s)   : Ross Hunter
    Created     : July 1, 1996
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* _UIB-CODE-BLOCK-END */
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
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND FIRST kit.XL_Project NO-LOCK NO-ERROR.
IF AVAILABLE kit.XL_Project AND
   LOOKUP(kit.XL_Project.RootDirectory,PROPATH) = 0 THEN DO:  
  IF ENTRY(1,PROPATH) = "":U
  THEN PROPATH = ",":U + XL_Project.RootDirectory + PROPATH.
  ELSE PROPATH = PROPATH + ",":U + XL_Project.RootDirectory.
END. /* If  project record is found */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


