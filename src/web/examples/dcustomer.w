&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_asbroker1                AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
DEF VAR X AS CHAR.

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
&Scoped-define INTERNAL-TABLES Customer

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  Address Address2 Balance City Comments Contact Country CreditLimit CustNum~
 Discount EmailAddress Fax Name Phone PostalCode SalesRep State Terms
&Scoped-define ENABLED-FIELDS-IN-Customer Address Address2 Balance City ~
Comments Contact Country CreditLimit CustNum Discount EmailAddress Fax Name ~
Phone PostalCode SalesRep State Terms 
&Scoped-Define DATA-FIELDS  Address Address2 Balance City Comments Contact Country CreditLimit CustNum~
 Discount EmailAddress Fax Name Phone PostalCode SalesRep State Terms
&Scoped-define DATA-FIELDS-IN-Customer Address Address2 Balance City ~
Comments Contact Country CreditLimit CustNum Discount EmailAddress Fax Name ~
Phone PostalCode SalesRep State Terms 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "dcustomer.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH Customer NO-LOCK ~
    BY Customer.Name INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main Customer
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main Customer


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      Customer SCROLLING.
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
         WIDTH              = 63.4.
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
     _TblList          = "sports2000.Customer"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "sports2000.Customer.Name|yes"
     _FldNameList[1]   > sports2000.Customer.Address
"Address" "Address" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[2]   > sports2000.Customer.Address2
"Address2" "Address2" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[3]   > sports2000.Customer.Balance
"Balance" "Balance" ? ? "decimal" ? ? ? ? ? ? yes ? no 13.2 yes
     _FldNameList[4]   > sports2000.Customer.City
"City" "City" ? ? "character" ? ? ? ? ? ? yes ? no 25 yes
     _FldNameList[5]   > sports2000.Customer.Comments
"Comments" "Comments" ? ? "character" ? ? ? ? ? ? yes ? no 80 yes
     _FldNameList[6]   > sports2000.Customer.Contact
"Contact" "Contact" ? ? "character" ? ? ? ? ? ? yes ? no 30 yes
     _FldNameList[7]   > sports2000.Customer.Country
"Country" "Country" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[8]   > sports2000.Customer.CreditLimit
"CreditLimit" "CreditLimit" ? ? "decimal" ? ? ? ? ? ? yes ? no 10.2 yes
     _FldNameList[9]   > sports2000.Customer.CustNum
"CustNum" "CustNum" ? ? "integer" ? ? ? ? ? ? yes ? no 9.2 yes
     _FldNameList[10]   > sports2000.Customer.Discount
"Discount" "Discount" ? ? "integer" ? ? ? ? ? ? yes ? no 8.4 yes
     _FldNameList[11]   > sports2000.Customer.EmailAddress
"EmailAddress" "EmailAddress" ? ? "character" ? ? ? ? ? ? yes ? no 50 yes
     _FldNameList[12]   > sports2000.Customer.Fax
"Fax" "Fax" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[13]   > sports2000.Customer.Name
"Name" "Name" ? ? "character" ? ? ? ? ? ? yes ? no 30 yes
     _FldNameList[14]   > sports2000.Customer.Phone
"Phone" "Phone" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[15]   > sports2000.Customer.PostalCode
"PostalCode" "PostalCode" ? ? "character" ? ? ? ? ? ? yes ? no 11.4 yes
     _FldNameList[16]   > sports2000.Customer.SalesRep
"SalesRep" "SalesRep" ? ? "character" ? ? ? ? ? ? yes ? no 9.8 yes
     _FldNameList[17]   > sports2000.Customer.State
"State" "State" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[18]   > sports2000.Customer.Terms
"Terms" "Terms" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
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

