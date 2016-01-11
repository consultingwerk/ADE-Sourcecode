&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER lb_ryc_smartobject FOR ryc_smartobject.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
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

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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
{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brObjectInstance

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ryc_object_instance lb_ryc_smartobject ~
gsc_object_type ryc_smartobject ryc_attribute_value

/* Definitions for BROWSE brObjectInstance                              */
&Scoped-define FIELDS-IN-QUERY-brObjectInstance ~
ryc_object_instance.object_instance_obj lb_ryc_smartobject.object_filename ~
ryc_object_instance.attribute_list 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectInstance 
&Scoped-define OPEN-QUERY-brObjectInstance OPEN QUERY brObjectInstance FOR EACH ryc_object_instance ~
      WHERE ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj NO-LOCK, ~
      EACH lb_ryc_smartobject WHERE TRUE /* Join to ryc_object_instance incomplete */ ~
      AND lb_ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectInstance ryc_object_instance ~
lb_ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectInstance ryc_object_instance
&Scoped-define SECOND-TABLE-IN-QUERY-brObjectInstance lb_ryc_smartobject


/* Definitions for BROWSE brObjectType                                  */
&Scoped-define FIELDS-IN-QUERY-brObjectType ~
gsc_object_type.object_type_description 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjectType 
&Scoped-define OPEN-QUERY-brObjectType OPEN QUERY brObjectType FOR EACH gsc_object_type NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjectType gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-brObjectType gsc_object_type


/* Definitions for BROWSE brSmartObject                                 */
&Scoped-define FIELDS-IN-QUERY-brSmartObject ~
ryc_smartobject.object_filename 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSmartObject 
&Scoped-define OPEN-QUERY-brSmartObject OPEN QUERY brSmartObject FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brSmartObject ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-brSmartObject ryc_smartobject


/* Definitions for BROWSE br_attributevalue                             */
&Scoped-define FIELDS-IN-QUERY-br_attributevalue ~
ryc_attribute_value.attribute_label ryc_attribute_value.constant_value ~
ryc_attribute_value.inheritted_value ryc_attribute_value.attribute_value 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_attributevalue 
&Scoped-define OPEN-QUERY-br_attributevalue OPEN QUERY br_attributevalue FOR EACH ryc_attribute_value ~
      WHERE ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj ~
 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_attributevalue ryc_attribute_value
&Scoped-define FIRST-TABLE-IN-QUERY-br_attributevalue ryc_attribute_value


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brObjectInstance}~
    ~{&OPEN-QUERY-brObjectType}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brObjectType brSmartObject brObjectInstance ~
br_attributevalue fiValue buSet 
&Scoped-Define DISPLAYED-OBJECTS fiValue 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buSet 
     LABEL "Set" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE fiValue AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 78 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brObjectInstance FOR 
      ryc_object_instance, 
      lb_ryc_smartobject SCROLLING.

DEFINE QUERY brObjectType FOR 
      gsc_object_type SCROLLING.

DEFINE QUERY brSmartObject FOR 
      ryc_smartobject SCROLLING.

DEFINE QUERY br_attributevalue FOR 
      ryc_attribute_value SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectInstance C-Win _STRUCTURED
  QUERY brObjectInstance NO-LOCK DISPLAY
      ryc_object_instance.object_instance_obj FORMAT ">>>>>>>>>>>>>>>>>9":U
      lb_ryc_smartobject.object_filename FORMAT "X(20)":U
      ryc_object_instance.attribute_list FORMAT "X(80)":U WIDTH 80
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 39 BY 5 EXPANDABLE.

DEFINE BROWSE brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjectType C-Win _STRUCTURED
  QUERY brObjectType NO-LOCK DISPLAY
      gsc_object_type.object_type_description FORMAT "X(35)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30 BY 5 EXPANDABLE.

DEFINE BROWSE brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSmartObject C-Win _STRUCTURED
  QUERY brSmartObject NO-LOCK DISPLAY
      ryc_smartobject.object_filename FORMAT "X(70)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 23 BY 5 EXPANDABLE.

DEFINE BROWSE br_attributevalue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_attributevalue C-Win _STRUCTURED
  QUERY br_attributevalue NO-LOCK DISPLAY
      ryc_attribute_value.attribute_label FORMAT "X(35)":U
      ryc_attribute_value.constant_value FORMAT "YES/NO":U
      ryc_attribute_value.inheritted_value FORMAT "YES/NO":U
      ryc_attribute_value.attribute_value FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 94 BY 12.38 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     brObjectType AT ROW 1.24 COL 2
     brSmartObject AT ROW 1.24 COL 33
     brObjectInstance AT ROW 1.24 COL 57
     br_attributevalue AT ROW 6.48 COL 2
     fiValue AT ROW 19.1 COL 2 NO-LABEL
     buSet AT ROW 19.1 COL 81
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.8 BY 19.33.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: lb_ryc_smartobject B "?" ? RYDB ryc_smartobject
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Attributes of Object Instances"
         HEIGHT             = 19.33
         WIDTH              = 95.8
         MAX-HEIGHT         = 19.95
         MAX-WIDTH          = 100.8
         VIRTUAL-HEIGHT     = 19.95
         VIRTUAL-WIDTH      = 100.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB brObjectType 1 DEFAULT-FRAME */
/* BROWSE-TAB brSmartObject brObjectType DEFAULT-FRAME */
/* BROWSE-TAB brObjectInstance brSmartObject DEFAULT-FRAME */
/* BROWSE-TAB br_attributevalue brObjectInstance DEFAULT-FRAME */
/* SETTINGS FOR FILL-IN fiValue IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectInstance
/* Query rebuild information for BROWSE brObjectInstance
     _TblList          = "RYDB.ryc_object_instance,lb_ryc_smartobject WHERE RYDB.ryc_object_instance ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "RYDB.ryc_object_instance.container_smartobject_obj = ryc_smartobject.smartobject_obj"
     _Where[2]         = "lb_ryc_smartobject.smartobject_obj = ryc_object_instance.smartobject_obj"
     _FldNameList[1]   = RYDB.ryc_object_instance.object_instance_obj
     _FldNameList[2]   > Temp-Tables.lb_ryc_smartobject.object_filename
"lb_ryc_smartobject.object_filename" ? "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   > RYDB.ryc_object_instance.attribute_list
"RYDB.ryc_object_instance.attribute_list" ? "X(80)" "character" ? ? ? ? ? ? no ? no no "80" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brObjectInstance */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjectType
/* Query rebuild information for BROWSE brObjectType
     _TblList          = "asdb.gsc_object_type"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   = asdb.gsc_object_type.object_type_description
     _Query            is OPENED
*/  /* BROWSE brObjectType */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSmartObject
/* Query rebuild information for BROWSE brSmartObject
     _TblList          = "RYDB.ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "RYDB.ryc_smartobject.object_type_obj = gsc_object_type.Object_Type_Obj"
     _FldNameList[1]   = RYDB.ryc_smartobject.object_filename
     _Query            is NOT OPENED
*/  /* BROWSE brSmartObject */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_attributevalue
/* Query rebuild information for BROWSE br_attributevalue
     _TblList          = "RYDB.ryc_attribute_value"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "ryc_attribute_value.object_instance_obj = ryc_object_instance.object_instance_obj
"
     _FldNameList[1]   = RYDB.ryc_attribute_value.attribute_label
     _FldNameList[2]   = RYDB.ryc_attribute_value.constant_value
     _FldNameList[3]   = RYDB.ryc_attribute_value.inheritted_value
     _FldNameList[4]   > RYDB.ryc_attribute_value.attribute_value
"ryc_attribute_value.attribute_value" ? "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is NOT OPENED
*/  /* BROWSE br_attributevalue */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Attributes of Object Instances */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Attributes of Object Instances */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectInstance
&Scoped-define SELF-NAME brObjectInstance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectInstance C-Win
ON ITERATION-CHANGED OF brObjectInstance IN FRAME DEFAULT-FRAME /* Browse 1 */
DO:
    RUN open-query-attribute-value.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectType
&Scoped-define SELF-NAME brObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjectType C-Win
ON ITERATION-CHANGED OF brObjectType IN FRAME DEFAULT-FRAME
DO:
    RUN open-query-attribute.
    RUN open-query-attribute-value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSmartObject
&Scoped-define SELF-NAME brSmartObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSmartObject C-Win
ON ITERATION-CHANGED OF brSmartObject IN FRAME DEFAULT-FRAME
DO:

    RUN open-query-object-instance.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_attributevalue
&Scoped-define SELF-NAME br_attributevalue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_attributevalue C-Win
ON ITERATION-CHANGED OF br_attributevalue IN FRAME DEFAULT-FRAME
DO:
    IF AVAILABLE ryc_attribute_value THEN
        ASSIGN 

            fiValue    = ryc_attribute_value.attribute_value.
    ELSE 
        ASSIGN

            fiValue    = "".

    DISPLAY fiValue WITH FRAME {&FRAME-NAME}.


    buSet:SENSITIVE = AVAILABLE ryc_attribute_value AND NOT ryc_attribute_value.constant.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSet C-Win
ON CHOOSE OF buSet IN FRAME DEFAULT-FRAME /* Set */
DO:
    ASSIGN FRAME {&FRAME-NAME} fiValue.

    IF AVAILABLE ryc_attribute_value THEN
    DO TRANSACTION ON ERROR UNDO, LEAVE.
        FIND CURRENT ryc_attribute_value EXCLUSIVE-LOCK.
        ASSIGN
            ryc_attribute_value.attribute_value = fiValue
            ryc_attribute_value.inheritted_value = FALSE.
        FIND CURRENT ryc_attribute_value NO-LOCK.
    END.

    {af/sup2/afcheckerr.i &NO-RETURN=YES}

    BROWSE br_AttributeValue:REFRESH().
    BROWSE brObjectInstance:REFRESH().



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjectInstance
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

ON FIND OF ryc_attribute DO:
    IF CAN-FIND(FIRST ryc_attribute_value 
                    WHERE ryc_attribute_value.OBJECT_type_obj = gsc_object_type.OBJECT_type_obj
                    AND   ryc_attribute_value.attribute_label = ryc_attribute.attribute_label) 
        THEN RETURN ERROR.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  APPLY "ITERATION-CHANGED":U TO brObjectType.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiValue 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE brObjectType brSmartObject brObjectInstance br_attributevalue fiValue 
         buSet 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-attribute C-Win 
PROCEDURE open-query-attribute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brSMartObject}
    APPLY "ITERATION-CHANGED":U TO brSmartObject IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-attribute-value C-Win 
PROCEDURE open-query-attribute-value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-br_AttributeValue}
    APPLY "ITERATION-CHANGED":U TO br_AttributeValue IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE open-query-object-instance C-Win 
PROCEDURE open-query-object-instance :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {&OPEN-QUERY-brObjectInstance}
    APPLY "ITERATION-CHANGED":U TO brObjectInstance IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

