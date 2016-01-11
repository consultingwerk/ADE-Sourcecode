&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          ab               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
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
/*------------------------------------------------------------------------

  File:  

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

/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES abAttribute

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  Adv attr2UCode brow butt chrData class comb custom dataType descrip dial~
 displaySeq edit fil frm geom imag multiLayout name ocx proc radi rec sele~
 slid sq togg trigCode txt widgSize wind
&Scoped-define ENABLED-FIELDS-IN-abAttribute Adv attr2UCode brow butt ~
chrData class comb custom dataType descrip dial displaySeq edit fil frm ~
geom imag multiLayout name ocx proc radi rec sele slid sq togg trigCode txt ~
widgSize wind 
&Scoped-Define DATA-FIELDS  Adv attr2UCode brow butt chrData class comb custom dataType descrip dial~
 displaySeq edit fil frm geom imag multiLayout name ocx proc radi rec sele~
 slid sq togg trigCode txt widgSize wind
&Scoped-define DATA-FIELDS-IN-abAttribute Adv attr2UCode brow butt chrData ~
class comb custom dataType descrip dial displaySeq edit fil frm geom imag ~
multiLayout name ocx proc radi rec sele slid sq togg trigCode txt widgSize ~
wind 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "adeuib/dabattribute.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH abAttribute NO-LOCK ~
    BY abAttribute.name INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main abAttribute
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main abAttribute


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      abAttribute SCROLLING.
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
     _TblList          = "ab.abAttribute"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "ab.abAttribute.name|yes"
     _FldNameList[1]   > ab.abAttribute.Adv
"Adv" "Adv" ? ? "logical" ? ? ? ? ? ? yes ? no 3.8 yes
     _FldNameList[2]   > ab.abAttribute.attr2UCode
"attr2UCode" "attr2UCode" ? ? "character" ? ? ? ? ? ? yes ? no 18 yes
     _FldNameList[3]   > ab.abAttribute.brow
"brow" "brow" ? ? "logical" ? ? ? ? ? ? yes ? no 4.6 yes
     _FldNameList[4]   > ab.abAttribute.butt
"butt" "butt" ? ? "logical" ? ? ? ? ? ? yes ? no 3.6 yes
     _FldNameList[5]   > ab.abAttribute.chrData
"chrData" "chrData" "Character Data" ? "character" ? ? ? ? ? ? yes ? no 65 yes
     _FldNameList[6]   > ab.abAttribute.class
"class" "class" "Class" ? "integer" ? ? ? ? ? ? yes ? no 4.8 yes
     _FldNameList[7]   > ab.abAttribute.comb
"comb" "comb" ? ? "logical" ? ? ? ? ? ? yes ? no 5.2 yes
     _FldNameList[8]   > ab.abAttribute.custom
"custom" "custom" "Custom" ? "logical" ? ? ? ? ? ? yes ? no 26.6 yes
     _FldNameList[9]   > ab.abAttribute.dataType
"dataType" "dataType" ? ? "character" ? ? ? ? ? ? yes ? no 3 yes
     _FldNameList[10]   > ab.abAttribute.descrip
"descrip" "descrip" ? ? "character" ? ? ? ? ? ? yes ? no 25 yes
     _FldNameList[11]   > ab.abAttribute.dial
"dial" "dial" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[12]   > ab.abAttribute.displaySeq
"displaySeq" "displaySeq" "Display Sequence" ? "integer" ? ? ? ? ? ? yes ? no 10.2 yes
     _FldNameList[13]   > ab.abAttribute.edit
"edit" "edit" ? ? "logical" ? ? ? ? ? ? yes ? no 3.4 yes
     _FldNameList[14]   > ab.abAttribute.fil
"fil" "fil" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[15]   > ab.abAttribute.frm
"frm" "frm" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[16]   > ab.abAttribute.geom
"geom" "geom" ? ? "logical" ? ? ? ? ? ? yes ? no 5.2 yes
     _FldNameList[17]   > ab.abAttribute.imag
"imag" "imag" ? ? "logical" ? ? ? ? ? ? yes ? no 4.4 yes
     _FldNameList[18]   > ab.abAttribute.multiLayout
"multiLayout" "multiLayout" ? ? "logical" ? ? ? ? ? ? yes ? no 7.6 yes
     _FldNameList[19]   > ab.abAttribute.name
"name" "name" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[20]   > ab.abAttribute.ocx
"ocx" "ocx" ? ? "logical" ? ? ? ? ? ? yes ? no 3.4 yes
     _FldNameList[21]   > ab.abAttribute.proc
"proc" "proc" ? ? "logical" ? ? ? ? ? ? yes ? no 4.2 yes
     _FldNameList[22]   > ab.abAttribute.radi
"radi" "radi" ? ? "logical" ? ? ? ? ? ? yes ? no 3.4 yes
     _FldNameList[23]   > ab.abAttribute.rec
"rec" "rec" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[24]   > ab.abAttribute.sele
"sele" "sele" ? ? "logical" ? ? ? ? ? ? yes ? no 3.8 yes
     _FldNameList[25]   > ab.abAttribute.slid
"slid" "slid" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[26]   > ab.abAttribute.sq
"sq" "sq" ? ? "integer" ? ? ? ? ? ? yes ? no 3.6 yes
     _FldNameList[27]   > ab.abAttribute.togg
"togg" "togg" ? ? "logical" ? ? ? ? ? ? yes ? no 4.2 yes
     _FldNameList[28]   > ab.abAttribute.trigCode
"trigCode" "trigCode" ? ? "character" ? ? ? ? ? ? yes ? no 8 yes
     _FldNameList[29]   > ab.abAttribute.txt
"txt" "txt" ? ? "logical" ? ? ? ? ? ? yes ? no 3.2 yes
     _FldNameList[30]   > ab.abAttribute.widgSize
"widgSize" "widgSize" ? ? "character" ? ? ? ? ? ? yes ? no 40 yes
     _FldNameList[31]   > ab.abAttribute.wind
"wind" "wind" ? ? "logical" ? ? ? ? ? ? yes ? no 4.4 yes
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

