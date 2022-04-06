&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"Astra 2 Static SmartDataObject Template with wizard.

Use this template to create a new Astra 2 SmartDataObject with the assistance of the SmartDataObject Wizard. When completed, this object can be drawn onto any 'smart' container such as a SmartWindow, SmartDialog or SmartFrame. Non-smart objects, such as web objects, can also access a SmartDataObject by running it persistently and calling its methods."
*/
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rycapfullo.w

  Description:  SDO for ryc_attribute_group

  Purpose:      SDO for ryc_attribute_group

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7754   UserRef:    
                Date:   29/01/2001  Author:     Anthony Swindells

  Update Notes: Attribute Groups Maintenance

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rycapfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_attribute_group

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  attribute_group_name attribute_group_narrative
&Scoped-define ENABLED-FIELDS-IN-ryc_attribute_group attribute_group_name ~
attribute_group_narrative 
&Scoped-Define DATA-FIELDS  attribute_group_name attribute_group_narrative attribute_group_obj
&Scoped-define DATA-FIELDS-IN-ryc_attribute_group attribute_group_name ~
attribute_group_narrative attribute_group_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycapfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_attribute_group NO-LOCK ~
    BY ryc_attribute_group.attribute_group_name INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_attribute_group NO-LOCK ~
    BY ryc_attribute_group.attribute_group_name INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_attribute_group
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_attribute_group


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_attribute_group SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 46.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "ICFDB.ryc_attribute_group"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "rydb.ryc_attribute_group.attribute_group_name|yes"
     _FldNameList[1]   > ICFDB.ryc_attribute_group.attribute_group_name
"attribute_group_name" "attribute_group_name" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[2]   > ICFDB.ryc_attribute_group.attribute_group_narrative
"attribute_group_narrative" "attribute_group_narrative" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
     _FldNameList[3]   > ICFDB.ryc_attribute_group.attribute_group_obj
"attribute_group_obj" "attribute_group_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     To perform validation that requires access to the database but
               that can occur before the transaction has started.
  Parameters:  <none>
  Notes:       Batch up errors using a chr(3) delimiter and be sure not to leave
               the error status raised.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:

  /* ensure object name specified is unique */
  IF (RowObjUpd.RowMod = "U":U AND
      CAN-FIND(FIRST ryc_attribute_group
               WHERE ryc_attribute_group.attribute_group_name = RowObjUpd.attribute_group_name
                 AND ROWID(ryc_attribute_group) <> TO-ROWID(RowObjUpd.ROWIDent))) OR 
     (RowObjUpd.RowMod <> "U":U AND
      CAN-FIND(FIRST ryc_attribute_group
               WHERE ryc_attribute_group.attribute_group_name = RowObjUpd.attribute_group_name))  THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
           {af/sup2/aferrortxt.i 'AF' '8' 'ryc_attribute_group' 'attribute_group_name' "'attribute group name'" RowObjUpd.attribute_group_name "'. Please use a different attribute group name'"}
           .

END.

/* pass back errors in return value and ensure error status not left raised */
ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     This validation will occur client side as it does not require a 
               DB connection and the db-required flag has been disabled.
  Parameters:  <none>
  Notes:       Here we validate individual fields that are mandatory have been
               entered. Checks that require db reads will be done later in one
               of the transaction validation routines.
               This procedure should batch up the errors using a chr(3) delimiter
               so that all the errors can be dsplayed to the user in one go.
               Be sure not to leave the error status raised !!!
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.

IF LENGTH(RowObject.attribute_group_name) = 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'ryc_attribute_group' 'attribute_group_name' "'attribute group name'"}
                        .

RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

