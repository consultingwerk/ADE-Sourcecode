&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
/* Procedure Description
"Reads the POSSE version from POSSEVersion.XML"
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : _readpossever.p
    Purpose     : Reads the POSSE version currently being run by getting
                  the value associated with the "Version" element in
                  either gui/posseversion.xml or src/posseversion.xml

    Syntax      : RUN _readpossever.p (OUTPUT POSSEVersion).

    Description :

    Author(s)   : Gerry Seidl 
    Created     : May 24,2001
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE OUTPUT PARAMETER PosseVersion AS CHARACTER  NO-UNDO INITIAL "N/A":U. /* Version value read from Version's text Node */
DEFINE VARIABLE         xmlfile      AS CHARACTER  NO-UNDO. /* Name of xml file */
DEFINE VARIABLE         hVersionFile AS HANDLE     NO-UNDO. /* handle to xml doc */
DEFINE VARIABLE         hNodePosse   AS HANDLE     NO-UNDO. /* POSSE node */
DEFINE VARIABLE         hNodeVer     AS HANDLE     NO-UNDO. /* Node of Version Element */
DEFINE VARIABLE         hNodeValue   AS HANDLE     NO-UNDO. /* Node containing the value of Version Element */
DEFINE VARIABLE         ctr          AS INTEGER    NO-UNDO. /* Misc. counter */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Locate posseversion.xml 
   NOTE: This xml file should be found in the Propath. The version of the
   file that is found should verify the version of POSSE you are pointed to 
 */
ASSIGN xmlfile = SEARCH("posseinfo.xml":U). /* is it in "gui" ? */
IF xmlfile = ? OR xmlfile = "" THEN DO:
  ASSIGN xmlfile = SEARCH("wrappers/posseinfo.xml":U). /* is it in src/wrappers? */
  IF xmlfile = ? OR xmlfile = "" THEN RETURN. /* We did not find it */
END.

DO:
  /*Create the xml document and load the file */
  CREATE X-DOCUMENT hVersionFile NO-ERROR. 
  hVersionFile:LOAD("FILE":U,xmlfile,FALSE) NO-ERROR. 
  IF ERROR-STATUS:ERROR THEN DO:
    DELETE OBJECT hVersionFile NO-ERROR.
    RETURN.
  END.

  /* Read POSSE node */
  CREATE X-NODEREF hNodePosse NO-ERROR.
  DO ctr = 1 TO hVersionFile:NUM-CHILDREN:
    hVersionFile:GET-CHILD(hNodePosse,ctr) NO-ERROR.
    IF hNodePosse:NAME = "POSSE":U THEN LEAVE.
  END.

  /* Find the "Version" Element */
  CREATE X-NODEREF hNodeVer NO-ERROR.
  DO ctr = 1 TO hNodePosse:NUM-CHILDREN:
    hNodePosse:GET-CHILD(hNodeVer,ctr) NO-ERROR.
    IF hNodeVer:NAME = "Version":U THEN DO:
        RUN GetPOSSEVersion.
        LEAVE.
    END.
  END.

  /* Release memory */
  DELETE OBJECT hNodeVer NO-ERROR.
  DELETE OBJECT hNodePosse NO-ERROR.
  DELETE OBJECT hVersionFile NO-ERROR.
END.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-GetPosseVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetPosseVersion Procedure 
PROCEDURE GetPosseVersion :
/*------------------------------------------------------------------------------
  Purpose:     Read the POSSE version value of the Version Element
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmpstr AS CHARACTER NO-UNDO. /* temporary string */
  
  CREATE X-NODEREF hNodeValue NO-ERROR.
  hNodeVer:GET-CHILD(hNodeValue,1) NO-ERROR. /* Assume 1 child for "Version" */
  ASSIGN tmpstr = hNodeValue:NODE-VALUE NO-ERROR.
  IF tmpstr <> ? AND tmpstr <> "" THEN posseversion = TRIM(tmpstr).
  DELETE OBJECT hNodeValue NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

