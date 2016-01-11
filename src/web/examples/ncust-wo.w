&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI adm2
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ab_unmap
       FIELD Country AS CHARACTER 
       FIELD cust-prompt AS CHARACTER FORMAT "X(256)":U 
       FIELD HasOrders AS LOGICAL  INITIAL no
       FIELD matching-cust-names AS CHARACTER .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-html 
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
/*           This .W file was created with AppBuilder.                  */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object
&Scoped-define DB-AWARE no

&Scoped-define WEB-FILE ncust-wo.htm

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Web-Frame
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Customer

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY QUERY-2 FOR EACH Customer NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 Customer
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 Customer


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS Customer.Comments Customer.Name ~
Customer.Phone 
&Scoped-define ENABLED-TABLES Customer ab_unmap
&Scoped-define FIRST-ENABLED-TABLE Customer
&Scoped-define SECOND-ENABLED-TABLE ab_unmap
&Scoped-define DISPLAYED-TABLES Customer ab_unmap
&Scoped-define FIRST-DISPLAYED-TABLE Customer
&Scoped-define SECOND-DISPLAYED-TABLE ab_unmap
&Scoped-Define ENABLED-OBJECTS ab_unmap.Country ab_unmap.cust-prompt ~
ab_unmap.HasOrders ab_unmap.matching-cust-names 
&Scoped-Define DISPLAYED-FIELDS Customer.Comments Customer.Name ~
Customer.Phone 
&Scoped-Define DISPLAYED-OBJECTS ab_unmap.Country ab_unmap.cust-prompt ~
ab_unmap.HasOrders ab_unmap.matching-cust-names 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      Customer SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Web-Frame
     Customer.Comments AT ROW 1 COL 1 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP
          SIZE 20 BY 4
     ab_unmap.Country AT ROW 1 COL 1 HELP
          "" NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "USA", "USA":U,
"Other", "Other":U
          SIZE 20 BY 3
     ab_unmap.cust-prompt AT ROW 1 COL 1 HELP
          "" NO-LABEL FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     ab_unmap.HasOrders AT ROW 1 COL 1 HELP
          ""
          LABEL "HasOrders"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY 1
     ab_unmap.matching-cust-names AT ROW 1 COL 1 HELP
          "" NO-LABEL
          VIEW-AS SELECTION-LIST SINGLE NO-DRAG 
          SIZE 20 BY 4
     Customer.Name AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     Customer.Phone AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS 
         AT COL 1 ROW 1
         SIZE 60.6 BY 17.05.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object
   Allow: Query
   Frames: 1
   Add Fields to: Neither
   Editing: Special-Events-Only
   Events: web.output,web.input
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ab_unmap W "?" ?  
      ADDITIONAL-FIELDS:
          FIELD Country AS CHARACTER 
          FIELD cust-prompt AS CHARACTER FORMAT "X(256)":U 
          FIELD HasOrders AS LOGICAL  INITIAL no
          FIELD matching-cust-names AS CHARACTER 
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW w-html ASSIGN
         HEIGHT             = 17.05
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-html 
/* *********************** Included-Libraries ************************* */

{src/web2/html-map.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-html
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Web-Frame
   UNDERLINE                                                            */
/* SETTINGS FOR EDITOR Customer.Comments IN FRAME Web-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET ab_unmap.Country IN FRAME Web-Frame
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN ab_unmap.cust-prompt IN FRAME Web-Frame
   ALIGN-L EXP-LABEL EXP-FORMAT EXP-HELP                                */
/* SETTINGS FOR TOGGLE-BOX ab_unmap.HasOrders IN FRAME Web-Frame
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR SELECTION-LIST ab_unmap.matching-cust-names IN FRAME Web-Frame
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN Customer.Name IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN Customer.Phone IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _TblList          = "sports2000.Customer"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME Web-Frame @ ( 1 , 1 )
*/  /* QUERY QUERY-2 */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-html 


/* ************************  Main Code Block  ************************* */

/* Standard Main Block that runs adm-create-objects, initializeObject 
 * and process-web-request.
 * The bulk of the web processing is in the Procedure process-web-request
 * elsewhere in this Web object.
 */
{src/web2/template/hmapmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-html  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFields w-html 
PROCEDURE assignFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE cSubmitVal AS CHARACTER INITIAL ? NO-UNDO.

    IF AVAILABLE customer THEN DO:
      IF get-field("requestedAction") = "Update":U THEN 
        RUN SUPER.

      FIND FIRST order WHERE order.custNum = customer.custNum NO-ERROR.
      ASSIGN
        ab_unmap.HasOrders = AVAILABLE(order)
        ab_unmap.country   = IF customer.country = "USA":U
                             THEN "USA":U ELSE "Other":U.
    END.
                                                                  
    ELSE  IF get-field("requestedAction") = "Update":U THEN
      {&OUT} 
        "<P> No customer " matching-cust-names:SCREEN-VALUE 
        " ... " cSubmitVal.                                      

     ASSIGN matching-cust-names cust-prompt.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findRecords w-html 
PROCEDURE findRecords :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cMCN     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCustNum AS INTEGER   NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    DEFINE VARIABLE lReturn AS LOGICAL NO-UNDO.

    IF cust-prompt:SCREEN-VALUE ne "" THEN DO:
 
      ASSIGN matching-cust-names:LIST-ITEMS = "".

      FOR EACH customer WHERE customer.name
        BEGINS cust-prompt:SCREEN-VALUE NO-LOCK 
        BY customer.name:
        
        ASSIGN 
          cName   = customer.name + " (":U + 
                    STRING(customer.custNum) + ")":U
          lReturn = matching-cust-names:ADD-LAST(cName).
      END.
     /* Select first name */ 
      matching-cust-names:SCREEN-VALUE = matching-cust-names:ENTRY(1). 
    END.

    /* Use selected name if Show Detail or Update selected */
    IF get-field("requestedAction") = "Show Detail" OR
       get-field("requestedAction") = "Update" 
    THEN matching-cust-names:SCREEN-VALUE = get-value("matching-cust-names":U).

    /* Find Selected Name (strip off custnum from list entry) */
    ASSIGN
      cMCN     = matching-cust-names:SCREEN-VALUE
      cMCN     = SUBSTRING(cMCN,INDEX(cMCN,"(":U) + 1,-1,"CHARACTER":U)
      iCustNum = INTEGER(SUBSTRING(cMCN,1,INDEX(cMCN,")":U) - 1,
                                   "CHARACTER":U)).

    FIND FIRST customer WHERE customer.custNum = iCustNum NO-ERROR.

  END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE htmOffsets w-html  _WEB-HTM-OFFSETS
PROCEDURE htmOffsets :
/*------------------------------------------------------------------------------
  Purpose:     Runs procedure to associate each HTML field with its
               corresponding widget name and handle.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  RUN readOffsets ("{&WEB-FILE}":U).
  RUN htmAssociate
    ("Comments":U,"Customer.Comments":U,Customer.Comments:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Country":U,"ab_unmap.Country":U,ab_unmap.Country:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("cust-prompt":U,"ab_unmap.cust-prompt":U,ab_unmap.cust-prompt:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("HasOrders":U,"ab_unmap.HasOrders":U,ab_unmap.HasOrders:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("matching-cust-names":U,"ab_unmap.matching-cust-names":U,ab_unmap.matching-cust-names:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Name":U,"Customer.Name":U,Customer.Name:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Phone":U,"Customer.Phone":U,Customer.Phone:HANDLE IN FRAME {&FRAME-NAME}).
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputHeader w-html 
PROCEDURE outputHeader :
/*------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is 
               a good place to set the WebState and WebTimeout attributes.
------------------------------------------------------------------------*/

  /* To make this a state-aware Web object, pass in the timeout period
   * (in minutes) before running outputContentType.  If you supply a 
   * timeout period greater than 0, the Web object becomes state-aware 
   * and the following happens:
   *
   *   - 4GL variables webState and webTimeout are set
   *   - a cookie is created for the broker to id the client on the return trip
   *   - a cookie is created to id the correct procedure on the return trip
   *
   * If you supply a timeout period less than 1, the following happens:
   *
   *   - 4GL variables webState and webTimeout are set to an empty string
   *   - a cookie is killed for the broker to id the client on the return trip
   *   - a cookie is killed to id the correct procedure on the return trip
   *
   * For example, set the timeout period to 5 minutes.
   *
   *   setWebState (5.0).
   */
    
  /* Output additional cookie information here before running outputContentType.
   *   For more information about the Netscape Cookie Specification, see
   *   http://home.netscape.com/newsref/std/cookie_spec.html  
   *   
   *   Name         - name of the cookie
   *   Value        - value of the cookie
   *   Expires date - Date to expire (optional). See TODAY function.
   *   Expires time - Time to expire (optional). See TIME function.
   *   Path         - Override default URL path (optional)
   *   Domain       - Override default domain (optional)
   *   Secure       - "secure" or unknown (optional)
   * 
   *   The following example sets custNum=23 and expires tomorrow at (about)
   *   the same time but only for secure (https) connections.
   *      
   *   RUN SetCookie IN web-utilities-hdl 
   *     ("custNum":U, "23":U, TODAY + 1, TIME, ?, ?, "secure":U).
   */ 
  output-content-type ("text/html":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request w-html 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------
  Purpose:     Process the web request.
  Notes:       
------------------------------------------------------------------------*/
     
  RUN outputHeader.

  IF REQUEST_METHOD = "POST":U THEN 
    RUN inputFields.
  ELSE /* GET */
    ASSIGN cust-prompt:SCREEN-VALUE in frame {&FRAME-NAME} = "A":U. 

  RUN findRecords.    
  RUN assignFields.
  RUN displayFields.
  RUN enableFields.
  RUN outputFields.
  
  /* Show error messages. */
  IF AnyMessage() THEN 
    ShowDataMessages().
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

