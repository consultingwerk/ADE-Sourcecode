&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          temp-db          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tmp_propsheet_brow NO-UNDO LIKE rym_propsheet_brow.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000-2001 by Progress Software Corporation ("PSC"),  *
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
/*------------------------------------------------------------------------

  File:  dynbrwfullo.w

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Shared Variable Definitions ---                                      */
{adeuib/uniwidg.i}

/* Local Variable Definitions ---                                       */
DEFINE BUFFER local_P FOR _P.
DEFINE VARIABLE hContainer  AS HANDLE     NO-UNDO.
DEFINE VARIABLE Precid      AS RECID      NO-UNDO.

{src/adm2/globals.i}

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
&Scoped-define INTERNAL-TABLES tmp_propsheet_brow

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  custom_super_procedure launch_container object_description object_name~
 product_module_code propsheet_brow_obj sdo_name selected_fields
&Scoped-define ENABLED-FIELDS-IN-tmp_propsheet_brow custom_super_procedure ~
launch_container object_description object_name product_module_code ~
propsheet_brow_obj sdo_name selected_fields 
&Scoped-Define DATA-FIELDS  custom_super_procedure launch_container object_description object_name~
 product_module_code propsheet_brow_obj sdo_name selected_fields
&Scoped-define DATA-FIELDS-IN-tmp_propsheet_brow custom_super_procedure ~
launch_container object_description object_name product_module_code ~
propsheet_brow_obj sdo_name selected_fields 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "adm2/support/dynbrwfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH tmp_propsheet_brow NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH tmp_propsheet_brow NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main tmp_propsheet_brow
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main tmp_propsheet_brow


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      tmp_propsheet_brow SCROLLING.
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
   Temp-Tables and Buffers:
      TABLE: tmp_propsheet_brow T "?" NO-UNDO temp-db rym_propsheet_brow
   END-TABLES.
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
         HEIGHT             = 2.1
         WIDTH              = 58.
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
     _TblList          = "Temp-Tables.tmp_propsheet_brow"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.tmp_propsheet_brow.custom_super_procedure
"custom_super_procedure" "custom_super_procedure" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[2]   > Temp-Tables.tmp_propsheet_brow.launch_container
"launch_container" "launch_container" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[3]   > Temp-Tables.tmp_propsheet_brow.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[4]   > Temp-Tables.tmp_propsheet_brow.object_name
"object_name" "object_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[5]   > Temp-Tables.tmp_propsheet_brow.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? yes ? no 20.6 no
     _FldNameList[6]   > Temp-Tables.tmp_propsheet_brow.propsheet_brow_obj
"propsheet_brow_obj" "propsheet_brow_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 no
     _FldNameList[7]   > Temp-Tables.tmp_propsheet_brow.sdo_name
"sdo_name" "sdo_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[8]   > Temp-Tables.tmp_propsheet_brow.selected_fields
"selected_fields" "selected_fields" ? ? "character" ? ? ? ? ? ? yes ? no 3000 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 3.6 )
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE paction               AS CHARACTER NO-UNDO.
DEFINE VARIABLE pproductmodulecode    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cobject_filename      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cerror                AS CHARACTER NO-UNDO.
                                      
DEFINE VARIABLE fieldnames            AS CHARACTER NO-UNDO.
DEFINE VARIABLE fieldvalues           AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpindex              AS INTEGER   NO-UNDO.
DEFINE VARIABLE tmpdisplayedfields    AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpenabledfields      AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmplaunchcontainer    AS CHARACTER NO-UNDO.
DEFINE VARIABLE selectedfields        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iloop                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE enableflag            AS LOGICAL   NO-UNDO.
DEFINE VARIABLE sdoname               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCustomSuperProcedure AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectDescription    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectFilename       AS CHARACTER NO-UNDO.
DEFINE VARIABLE dProductModuleObj     AS DECIMAL    NO-UNDO.
    /* Code placed here will execute PRIOR to standard behavior. */

    {get ContainerSource hContainer}.
    ASSIGN Precid = DYNAMIC-FUNCTION("getPrecid" IN hContainer).
    FIND local_P WHERE RECID(local_P) = Precid NO-ERROR.
    
    CREATE tmp_propsheet_brow.
    
    IF AVAILABLE(local_P) THEN
    DO:
        
        IF local_P.object_filename <> ? THEN
              tmp_propsheet_brow.object_name = local_P.object_filename.
        ELSE tmp_propsheet_brow.object_name = "".
    END.
   
    /* Check if Dynamics is running */
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN ry/prc/rymbrwprocp.p (INPUT  tmp_propsheet_brow.object_name,
                                OUTPUT tmpdisplayedfields,
                                OUTPUT tmpenabledfields,
                                OUTPUT tmplaunchcontainer,
                                OUTPUT sdoname,
                                OUTPUT cCustomSuperProcedure,
                                OUTPUT cObjectDescription,
                                OUTPUT cObjectFilename,
                                OUTPUT dProductModuleObj,
                                OUTPUT cError).


      IF cError = "":U THEN DO:
         selectedfields = "".     
         DO iloop = 1 TO NUM-ENTRIES(tmpdisplayedfields):
            IF LOOKUP(ENTRY(iloop,tmpdisplayedfields),tmpenabledfields) = 0 THEN
              ASSIGN enableflag = FALSE.
            ELSE
              ASSIGN enableflag = TRUE.

            ASSIGN  selectedfields =  selectedfields +  CHR(3) +
                                      STRING(iLoop) + CHR(4) +
                                      STRING(ENTRY(iloop,tmpdisplayedfields)) + CHR(4) +
                                      STRING(enableflag).
         END. /*iloop*/
    
         fieldnames =
           "customsuperprocedure" + CHR(2) +
           "launchcontainer" + CHR(2) +
           "objectdescription" + CHR(2 )+
           "objectname" + CHR(2) +
           "productmodulecode" + CHR(2) +
           "sdoname" + CHR(2) +
           "selectedfields" .
 

         fieldvalues =  cCustomSuperProcedure + CHR(2) +
                        tmplaunchcontainer + CHR(2) +
                        cObjectDescription + CHR(2) +
                        cObjectFilename + CHR(2) +
                        STRING(dProductModuleObj) + CHR(2) +
                        sdoname  + CHR(2) + selectedfields.
    END. /*if avail ryc_object*/ 

 
    IF fieldnames <> "" THEN DO:
       /*tmpindex tests if the index is > 0 so that if the entry is missing form the list it will not
       error*/

       tmpindex = LOOKUP("productmodulecode",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
        tmp_propsheet_brow.product_module_code =  ENTRY(tmpindex, fieldvalues,CHR(2)).

       tmpindex = LOOKUP("objectname",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
        tmp_propsheet_brow.object_name = ENTRY(tmpindex, fieldvalues,CHR(2)).

       tmpindex = LOOKUP("objectdescription",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
       tmp_propsheet_brow.object_description =  ENTRY(tmpindex, fieldvalues,CHR(2)).

       tmpindex = LOOKUP("customsuperprocedure",fieldnames, CHR(2)).
       IF tmpindex > 0 THEN
        tmp_propsheet_brow.custom_super_procedure =  ENTRY(tmpindex, fieldvalues,CHR(2)).

       tmpindex =  LOOKUP("launchcontainer",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
       tmp_propsheet_brow.launch_container =  ENTRY(tmpindex, fieldvalues,CHR(2)).

       tmpindex = LOOKUP("selectedfields",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
       tmp_propsheet_brow.selected_fields =   ENTRY(tmpindex, fieldvalues,CHR(2)).
       
       
       tmpindex = LOOKUP("sdoname",fieldnames,CHR(2)).
       IF tmpindex > 0 THEN
       tmp_propsheet_brow.sdo_name =   ENTRY(tmpindex, fieldvalues,CHR(2)).
    END.

    RUN SUPER.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE savechanges dTables  _DB-REQUIRED
PROCEDURE savechanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAM cerror AS CHAR NO-UNDO.

DEFINE VAR fieldnames   AS CHAR NO-UNDO.
DEFINE VAR fieldvalues  AS CHAR NO-UNDO.
DEFINE VAR cprocname    AS CHAR NO-UNDO.
DEFINE VAR etest        AS CHAR NO-UNDO.

FIND FIRST tmp_propsheet_brow NO-LOCK NO-ERROR.

IF  tmp_propsheet_brow.object_name = "" THEN DO:
    ASSIGN cerror = "Please enter an object name.".
    RETURN.
END.
IF  tmp_propsheet_brow.sdo_name  = "" THEN DO:
    ASSIGN cerror = "Please enter a valid SDO name.".
    RETURN.
END.
IF tmp_propsheet_brow.selected_fields = "" THEN DO:
    ASSIGN cerror = "Please add at least one field to the browser".
    RETURN.
END.
  fieldnames =
           "customsuperprocedure" + CHR(2) +
           "launchcontainer" + CHR(2) +
           "objectdescription" + CHR(2)+
           "objectname" + CHR(2) +
           "productmodulecode" + CHR(2) +
           "sdoname" + CHR(2) +
           "selectedfields" .

  fieldvalues =
           tmp_propsheet_brow.custom_super_procedure + CHR(2) +
           tmp_propsheet_brow.launch_container + CHR(2) +
           tmp_propsheet_brow.object_description  + CHR(2) +
           tmp_propsheet_brow.object_name   + CHR(2) +
           STRING(tmp_propsheet_brow.product_module_code) + CHR(2) +
           tmp_propsheet_brow.sdo_name  + CHR(2) +
           tmp_propsheet_brow.selected_fields.
 
cProcName = "storebrowser".

/* Check if Dynamics is running */
IF VALID-HANDLE(gshSessionManager) THEN DO:
{launch.i &IProc = cProcName
          &PLIP ='ry/app/ryreposobp.p'
          &PList = "(INPUT tmp_propsheet_brow.object_name , ~
          INPUT fieldnames, INPUT fieldvalues, OUTPUT etest)"
          &OnApp = 'no'
          &Autokill = YES}
END.

ASSIGN local_P.object_filename = tmp_propsheet_brow.object_name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatechanges dTables  _DB-REQUIRED
PROCEDURE validatechanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM cerror AS CHAR NO-UNDO.
FIND FIRST tmp_propsheet_brow NO-LOCK NO-ERROR.

IF  tmp_propsheet_brow.object_name = "" THEN DO:
    ASSIGN cerror = "Please enter an object name.".
    RETURN.
END.
IF  tmp_propsheet_brow.sdo_name  = "" THEN DO:
    ASSIGN cerror = "Please enter a valid SDO name.".
    RETURN.
END.
IF tmp_propsheet_brow.selected_fields = "" THEN DO:
    ASSIGN cerror = "Please add at least one field to the browser".
    RETURN.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

