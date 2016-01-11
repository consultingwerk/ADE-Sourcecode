&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _set-map.p

Description:
    Sets up the _P file as an HTML Mapping file. Here is were we check
    for:
       * "Html-Mapping" in the type-list
       * a HTM-offsets procedure
       * a Workshop-Definitions section

Input Parameters:
    p_proc-id:   RECID of the associated file _P record

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: February 14, 1997

Modified:
---------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id AS INTEGER NO-UNDO. /* RECID of _P for .w  */

/* Shared variables --                                                       */
{ workshop/code.i }         /* Code Section TEMP-TABLE definition            */
{ workshop/htmwidg.i }      /* Design time Web _HTM TEMP-TABLE.              */
{ workshop/objects.i }      /* Web Objects TEMP-TABLE definition             */
{ workshop/uniwidg.i }      /* Universal Widget TEMP-TABLE definition        */

/* Local variables --                                                        */

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
         HEIGHT             = 2
         WIDTH              = 40.
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***********************  Other Definitions  ************************ */ 
DEFINE VARIABLE cd-recid AS RECID NO-UNDO.
DEFINE VARIABLE pp-recid AS RECID NO-UNDO.

/* ***************************  Main Block  *************************** */
IF CAN-FIND (FIRST _HTM WHERE _HTM._P-recid eq p_proc-id) THEN DO:
 
  /* Get the current procedure file */
  FIND _P WHERE RECID(_P) eq p_proc-id.
  /* Set the type list correctly. */
  IF LOOKUP("Html-Mapping":U, _P._type-list) eq 0
  THEN _P._type-list = _P._type-list + ",Html-Mapping":U.  
  
  /* Add the HTM-OFFSET procedure. */
  FIND FIRST _code WHERE _code._p-recid eq RECID(_P) 
                     AND _code._section eq "_PROCEDURE" 
                     AND _code._name    eq  "htm-offsets"
                    NO-ERROR. 
            
  /* Create the trigger section, if necessary */
  IF NOT AVAILABLE _code THEN DO:
    RUN workshop/_find_cd.p (p_proc-id, "LAST":U, "":U, OUTPUT cd-recid).
    RUN workshop/_ins_cd.p 
         (cd-recid,             /* Previous code section */
          RECID(_P),            /* Associated procedure */
          RECID(_P),            /* Associated object (same as procedure) */
          "_PROCEDURE":U,       /* Section */ 
          "_WEB-HTM-OFFSETS":U, /* Special Handler */   
          "htm-offsets":U,      /* Name */
          OUTPUT cd-recid).     /* RECID of code block created. */  
    FIND _code WHERE RECID(_code) eq cd-recid NO-ERROR.
  END.
  
  /* Make sure the existing section is a special section. */
  ASSIGN _code._special = "_WEB-HTM-OFFSETS".   
  
  /* Make sure there is only one of these procedure. (Because we
     read it when you suck the file back into the UIB and we don't want to
     create multiple copies.) */
  cd-recid = RECID(_code).
  FOR EACH _code WHERE _code._p-recid = RECID(_P) 
                   AND _code._section = "_PROCEDURE" 
                   AND _code._special = "_WEB-HTM-OFFSETS"
                   AND RECID(_code) ne cd-recid:
    RUN workshop/_del_cd.p (RECID(_code)).
  END.   
  
  
  /* Make sure there is a "_PREPROCESSOR-BLOCK" section */
  FIND _code WHERE _code._p-recid eq RECID(_P) 
               AND _code._special eq "_PREPROCESSOR-BLOCK"
             NO-ERROR.                
  IF AVAILABLE(_code) THEN pp-recid = RECID(_code).
  ELSE DO:   
    /* Place this after the _VERSION-NUMBER section.  */
    FIND _code WHERE _code._p-recid eq RECID(_P) 
                 AND _code._special eq "_VERSION-NUMBER"
               NO-ERROR. 
    cd-recid = IF AVAILABLE (_code) THEN RECID(_code) ELSE ?.
    RUN workshop/_ins_cd.p 
         (cd-recid,                /* Previous code section */
          RECID(_P),               /* Associated procedure */
          RECID(_P),               /* Associated object (same as procedure) */
          "_HIDDEN":U,             /* Section */ 
          "_PREPROCESSOR-BLOCK":U, /* Special Handler */   
          "_PREPROCESSOR-BLOCK":U, /* Name */
          OUTPUT pp-recid).        /* RECID of code block created. */
    
  END.
             
  /* Make sure there is a "_WORKSHOP" "_Form-Buffer" section */
  FIND _code WHERE _code._p-recid eq RECID(_P) 
               AND _code._section eq "_WORKSHOP" 
               AND _code._special eq "_FORM-BUFFER"
             NO-ERROR. 
  IF NOT AVAILABLE (_code) THEN DO:   
    /* Place this after the _WORKSHOP _PREPROCESSOR section.  */
    RUN workshop/_ins_cd.p 
         (pp-recid,                /* Previous code section */
          RECID(_P),               /* Associated procedure */
          RECID(_P),               /* Associated object (same as procedure) */
          "_WORKSHOP":U,           /* Section */ 
          "_FORM-BUFFER":U,        /* Special Handler */   
          "_FORM-BUFFER":U,        /* Name */
          OUTPUT cd-recid).        /* RECID of code block created. */   
  END.
END. 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


