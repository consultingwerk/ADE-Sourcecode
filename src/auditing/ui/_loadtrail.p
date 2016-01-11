&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005,2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _loadtrail.p
    Purpose     : This is similar to the _loadtrail procedure used in
                  the prodict project. This is only used for the import
                  .d option in the events maintenance window.
                  All we care really is the number of records, and the codepage
                  information

    Syntax      :

    Description :Receive the .d file name and extract some info for the caller
                 iRecs = number of records as defined in the trail
                 maptype = map type defined in the trail
                 codepage = codepage defined in the trail
                 
                 Returns: "Conversion-error" conversion needed but NOT possible
                           "no-convert"      conversion not needed

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
    
    History:
    fernando    06/20/07   Support for large files
    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT  PARAMETER pcFileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER irecs      AS INT64     NO-UNDO.
DEFINE OUTPUT PARAMETER maptype    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER codepage   AS CHARACTER NO-UNDO.


DEFINE VARIABLE lvar     AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#    AS INTEGER             NO-UNDO.
DEFINE VARIABLE c        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cerror   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE cerrors  AS INTEGER   INITIAL 0 NO-UNDO.

/* i is used in _lodtrail.i */
DEFINE VARIABLE i        AS INT64               NO-UNDO.

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

ASSIGN codepage = "UNDEFINED":U.

{auditing/include/_lodtrail.i
    &file    = "pcFileName"
    &entries = "IF lvar[i] BEGINS ""records=""
                  THEN irecs     = INT64(SUBSTRING(lvar[i],9,-1,""character"")).
                IF lvar[i] BEGINS ""map=""       
                  THEN maptype   = SUBSTRING(lvar[i],5,-1,""character"").
               "   }
                   
IF cerror = ? THEN
    DO:  /* conversion needed but NOT possible */
    RETURN "Conversion-error":U.
END.
ELSE DO:  /* conversion not needed OR needed and possible */
    IF maptype BEGINS "MAP:":U THEN
        ASSIGN maptype = SUBSTRING(maptype,5,-1,"character":U).
    ELSE
        ASSIGN maptype ="NO-MAP":U.

    IF cerror = "no-convert" THEN
        ASSIGN CODEPAGE = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


