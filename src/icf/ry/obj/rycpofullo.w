&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
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
/*---------------------------------------------------------------------------------
  File: rysttasdoo.w

  Description:  Template Astra 2 SmartDataObject Template

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

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

&scop object-name       rycpofullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       ry/obj/rycpologcp.p

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
&Scoped-define INTERNAL-TABLES ryc_page_object ryc_object_instance ~
ryc_smartobject

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  container_smartobject_obj smartobject_obj instance_x instance_y~
 instance_width instance_height attribute_list system_owned layout_position~
 dInstancePageObj dObjectTypeObj iCreateSequence
&Scoped-define ENABLED-FIELDS-IN-ryc_object_instance ~
container_smartobject_obj smartobject_obj instance_x instance_y ~
instance_width instance_height attribute_list system_owned layout_position 
&Scoped-Define DATA-FIELDS  container_smartobject_obj object_instance_obj smartobject_obj~
 object_filename instance_x instance_y instance_width instance_height~
 attribute_list system_owned layout_position object_type_obj page_obj~
 page_object_sequence dInstancePageObj dObjectTypeObj iCreateSequence~
 dObjectInstanceObj
&Scoped-define DATA-FIELDS-IN-ryc_page_object page_obj page_object_sequence 
&Scoped-define DATA-FIELDS-IN-ryc_object_instance container_smartobject_obj ~
object_instance_obj smartobject_obj instance_x instance_y instance_width ~
instance_height attribute_list system_owned layout_position 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename ~
object_type_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycpofullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_page_object NO-LOCK, ~
      EACH ryc_object_instance WHERE ryc_object_instance.container_smartobject_obj = ryc_page_object.container_smartobject_obj ~
  AND ryc_object_instance.object_instance_obj = ryc_page_object.object_instance_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj NO-LOCK ~
    BY ryc_page_object.page_object_sequence INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_page_object ~
ryc_object_instance ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_page_object
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_object_instance
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main ryc_smartobject


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_page_object, 
      ryc_object_instance, 
      ryc_smartobject SCROLLING.
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
         WIDTH              = 57.8.
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
     _TblList          = "icfdb.ryc_page_object,icfdb.ryc_object_instance WHERE icfdb.ryc_page_object ...,icfdb.ryc_smartobject WHERE icfdb.ryc_object_instance ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, FIRST"
     _OrdList          = "icfdb.ryc_page_object.page_object_sequence|yes"
     _JoinCode[2]      = "ryc_object_instance.container_smartobject_obj = ryc_page_object.container_smartobject_obj
  AND ryc_object_instance.object_instance_obj = ryc_page_object.object_instance_obj"
     _JoinCode[3]      = "icfdb.ryc_smartobject.smartobject_obj = icfdb.ryc_object_instance.smartobject_obj"
     _FldNameList[1]   > icfdb.ryc_object_instance.container_smartobject_obj
"container_smartobject_obj" "container_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[2]   > icfdb.ryc_object_instance.object_instance_obj
"object_instance_obj" "object_instance_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[3]   > icfdb.ryc_object_instance.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[4]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[5]   > icfdb.ryc_object_instance.instance_x
"instance_x" "instance_x" ? ? "integer" ? ? ? ? ? ? yes ? no 10.2 yes
     _FldNameList[6]   > icfdb.ryc_object_instance.instance_y
"instance_y" "instance_y" ? ? "integer" ? ? ? ? ? ? yes ? no 10.2 yes
     _FldNameList[7]   > icfdb.ryc_object_instance.instance_width
"instance_width" "instance_width" ? ? "integer" ? ? ? ? ? ? yes ? no 14.4 yes
     _FldNameList[8]   > icfdb.ryc_object_instance.instance_height
"instance_height" "instance_height" ? ? "integer" ? ? ? ? ? ? yes ? no 15 yes
     _FldNameList[9]   > icfdb.ryc_object_instance.attribute_list
"attribute_list" "attribute_list" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[10]   > icfdb.ryc_object_instance.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[11]   > icfdb.ryc_object_instance.layout_position
"layout_position" "layout_position" ? ? "character" ? ? ? ? ? ? yes ? no 15 yes
     _FldNameList[12]   > icfdb.ryc_smartobject.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[13]   > icfdb.ryc_page_object.page_obj
"page_obj" "page_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[14]   > icfdb.ryc_page_object.page_object_sequence
"page_object_sequence" "page_object_sequence" ? ? "integer" ? ? ? ? ? ? no ? no 16.8 yes
     _FldNameList[15]   > "_<CALC>"
"RowObject.page_obj" "dInstancePageObj" "Page" ">>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 24.6 no
     _FldNameList[16]   > "_<CALC>"
"RowObject.object_type_obj" "dObjectTypeObj" "Object Type" ">>>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 25.8 no
     _FldNameList[17]   > "_<CALC>"
"RowObject.page_object_sequence" "iCreateSequence" "Create Sequence" "->>9" "Integer" ? ? ? ? ? ? yes ? no 16.6 no
     _FldNameList[18]   > "_<CALC>"
"RowObject.object_instance_obj" "dObjectInstanceObj" "Object Instance Obj" ">>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? no ? no 24.6 no
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.dInstancePageObj = (RowObject.page_obj)
         rowObject.dObjectInstanceObj = (RowObject.object_instance_obj)
         rowObject.dObjectTypeObj = (RowObject.object_type_obj)
         rowObject.iCreateSequence = (RowObject.page_object_sequence)
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE noTreeFilter dTables  _DB-REQUIRED
PROCEDURE noTreeFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

