&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _wizafld.p
                                       
    Purpose:    A UIB XFTR designed to automatically invoke the table/field
                picker upon openning a window into the UIB (from a template 
                containing this XFTR. After the fields have been picked, it
                adds foreign key support in the "Foreign Keys" XFTR. 
                
                It automatically destroys itself so that it only
                comes up the first time.
                
                If there is an "Foreign Keys" XFTR, then an initial set of
                foreign keys is created and populated in that section.

    Parameters: p_contextID - the context ID of the XFTR section
                p_code       - the XFTR code block itself 

    Notes  :    It does not run itself if the procedure is being
                opened AS A TEMPLATE.

    Authors: Bill Wood
    Date   : 6/6/96
**************************************************************************/
DEFINE INPUT        PARAMETER p_contextID  AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_code       AS CHARACTER NO-UNDO.

/**************************** Local Definitions **************************/
DEFINE VARIABLE cResult    AS CHAR    NO-UNDO.
DEFINE VARIABLE proc-ID    AS INTEGER NO-UNDO.
DEFINE VARIABLE fkey-ID    AS INTEGER NO-UNDO.
DEFINE VARIABLE key-table  AS CHAR    NO-UNDO.

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
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/support/keyprocs.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* What is the ID of this procedure? */
RUN adeuib/_uibinfo.p (p_contextID, ?, "PROCEDURE", OUTPUT cResult).
proc-ID = INTEGER (cResult).

/* Is this being run in a TEMPLATE.  If so, then don't bother doing 
   anything. */
RUN adeuib/_uibinfo.p (proc-ID, ?, "TEMPLATE":U, OUTPUT cResult).
IF cResult NE "yes":U THEN DO:

  /* Run the AutoFields function, that will add fields to this object. */
  RUN adeuib/_autofld.p (p_contextID, INPUT-OUTPUT p_code).
 
  /* What are the external tables? If there are any and if there is a 'Foreign
     Keys' XFTR, then guess at the keys that the first table can supply. */
  RUN adeuib/_uibinfo.p (proc-ID, ?, "EXTERNAL-TABLES":U, OUTPUT key-table).
  IF NUM-ENTRIES(key-table) > 1 THEN key-table = ENTRY(1, key-table).
  
  /* Get the code for the Foreign-Keys XFTR section. */
  fkey-ID = ?.
  RUN adeuib/_accsect.p 
      ('GET':U, proc-ID, 'XFTR:Foreign Keys':U,
       INPUT-OUTPUT fkey-ID,
       INPUT-OUTPUT cResult).
    
  IF fkey-ID ne ? and key-table ne "":U THEN RUN create-foreign-keys (fkey-ID).

  /* Destroy the code section immediately. */
  RUN adeuib/_accsect.p ("DELETE", ?,? , 
                         INPUT-OUTPUT p_contextID,
                         INPUT-OUTPUT p_code).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-foreign-keys Procedure 
PROCEDURE create-foreign-keys :
/*------------------------------------------------------------------------------
  Purpose:     Find all the keys that are relevent to the p_table.  Store
               these in the XFTR with id p_xftrID.  
  Parameters:  
    p_xftrID   - (INTEGER) the context of the Foreign Keys XFTR section.
 ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_xftrID AS INTEGER NO-UNDO.
 
  DEFINE VAR accept-list   AS CHAR          NO-UNDO.
  DEFINE VAR cnt           AS INTEGER       NO-UNDO.
  DEFINE VAR fld_name      AS CHAR          NO-UNDO.
  DEFINE VAR foreign-keys  AS CHAR          NO-UNDO.
  DEFINE VAR i             AS INTEGER       NO-UNDO.
  DEFINE VAR l_answer      AS LOGICAL       NO-UNDO.
  DEFINE VAR key-object    AS CHAR          NO-UNDO.
  DEFINE VAR supply-list   AS CHAR          NO-UNDO.
  DEFINE VAR temp          AS CHAR          NO-UNDO.
  DEFINE VAR xftr-code     AS CHAR          NO-UNDO.
  
  IF key-table ne "" THEN DO:
    /* Set the KEY-OBJECT to "THIS-PROCEDURE" (This is the default for this
       situation. That is, where we are doing keys on external tables in a
       SmartViewer.) */
    key-object = "THIS-PROCEDURE":U.
    
    /* Guess at the keys.  If the key is going to replace an external table
       in THIS-PROCEDURE then accept only unique keys. */
    RUN adeuib/_keygues.p (INPUT  key-table,
                           OUTPUT accept-list,
                           OUTPUT temp,    /* Don't use this one. */
                           OUTPUT supply-list).
                           
    /* Create a list for the foreign-keys. This list is of the form:
           key-name|y(if accepted)|y(if supplied)|key-field
       Assume the key-name is the same as the field-name.
       Also assume that anything accepted can also by supplied. */
    cnt = NUM-ENTRIES(accept-list).
    DO i = 1 TO cnt:
      ASSIGN fld_name     = ENTRY(i, accept-list)
             foreign-keys = foreign-keys + CHR(10)
                           + SUBSTITUTE("&1|y|y|&2.&1":U, /* Accepted & supplied */
                                       fld_name,    /* Key Name     */
                                       key-table).  /* db.tbl */
    END. /* DO i... */
    
    /* Add the supply list to the foreign-keys. */
    cnt = NUM-ENTRIES(supply-list).
    DO i = 1 TO cnt:
      fld_name = ENTRY(i, supply-list).
      IF NOT CAN-DO (accept-list, fld_name) 
      THEN foreign-keys = foreign-keys + CHR(10) 
                         + SUBSTITUTE("&1||y|&2":U,  /* Just supplied */
                                fld_name,            /* Key Name     */
                                key-table + ".":U + fld_name).  /* db.tbl.fld */
    END. /* DO i... */
    
   IF foreign-keys ne "":U THEN DO:
     MESSAGE "This SmartObject can access the following foreign keys:" SKIP
             REPLACE("       - ":U + supply-list, ",":U, CHR(10) + "       - ":U) 
             SKIP (1)
             "Would you like these keys to be supported?"
             VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE l_answer.
     IF l_answer THEN DO:
       /* Build the XFTR section. */
       RUN build-xftr-section (foreign-keys, key-object, OUTPUT xftr-code).
       /* Store the section. */
       RUN adeuib/_accsect.p ('SET':U, ?, ?,
                              INPUT-OUTPUT p_xftrID,
                              INPUT-OUTPUT xftr-code).
                              
       /* Make sure the SmartObject has the correct internal procedures. */
       RUN check-procedures (proc-ID, key-object).  
                              
      END. /* IF l_answer... */
    END. /* IF foreign-keys... */
  END. /* IF key-table ne ""... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


