&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI adm2
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ab_unmap
       FIELD AddMode AS CHARACTER FORMAT "X(256)":U 
       FIELD cusrowid AS CHARACTER FORMAT "X(256)":U 
       FIELD SearchName AS CHARACTER FORMAT "X(256)":U .
DEFINE TEMP-TABLE RowObject
       {"dcustomer.i"}.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-html 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

&Scoped-define WEB-FILE w-custdir.htm

/* Include file with RowObject temp-table definition */
&Scoped-define DATA-FIELD-DEFS "dcustomer.i"

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Web-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RowObject.Address RowObject.City ~
RowObject.EmailAddress RowObject.Fax RowObject.Name RowObject.Phone ~
RowObject.PostalCode RowObject.SalesRep RowObject.State 
&Scoped-define ENABLED-TABLES RowObject ab_unmap
&Scoped-define FIRST-ENABLED-TABLE RowObject
&Scoped-define SECOND-ENABLED-TABLE ab_unmap
&Scoped-define DISPLAYED-TABLES RowObject ab_unmap
&Scoped-define FIRST-DISPLAYED-TABLE RowObject
&Scoped-define SECOND-DISPLAYED-TABLE ab_unmap
&Scoped-Define ENABLED-OBJECTS ab_unmap.cusrowid ab_unmap.AddMode ~
ab_unmap.SearchName 
&Scoped-Define DISPLAYED-FIELDS RowObject.Address RowObject.City ~
RowObject.EmailAddress RowObject.Fax RowObject.Name RowObject.Phone ~
RowObject.PostalCode RowObject.SalesRep RowObject.State 
&Scoped-Define DISPLAYED-OBJECTS ab_unmap.cusrowid ab_unmap.AddMode ~
ab_unmap.SearchName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_dcustomer AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Web-Frame
     RowObject.Address AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.City AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     ab_unmap.cusrowid AT ROW 1 COL 1 HELP
          "" NO-LABEL FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.EmailAddress AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.Fax AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     ab_unmap.AddMode AT ROW 1 COL 1 HELP
          "" NO-LABEL FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.Name AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.Phone AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.PostalCode AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.SalesRep AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     ab_unmap.SearchName AT ROW 1 COL 1 HELP
          "" NO-LABEL FORMAT "X(256)":U
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
     RowObject.State AT ROW 1 COL 1 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS 
         AT COL 1 ROW 1
         SIZE 69.2 BY 20.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object
   Data Source: "dcustomer.w"
   Allow: Query
   Frames: 1
   Add Fields to: Neither
   Editing: Special-Events-Only
   Events: web.output,web.input
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ab_unmap W "?" ?  
      ADDITIONAL-FIELDS:
          FIELD AddMode AS CHARACTER FORMAT "X(256)":U 
          FIELD cusrowid AS CHARACTER FORMAT "X(256)":U 
          FIELD SearchName AS CHARACTER FORMAT "X(256)":U 
      END-FIELDS.
      TABLE: RowObject D "?" ?  
      ADDITIONAL-FIELDS:
          {dcustomer.i}
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW w-html ASSIGN
         HEIGHT             = 20
         WIDTH              = 69.2.
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
/* SETTINGS FOR FILL-IN ab_unmap.AddMode IN FRAME Web-Frame
   ALIGN-L EXP-LABEL EXP-FORMAT EXP-HELP                                */
/* SETTINGS FOR FILL-IN RowObject.Address IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.City IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN ab_unmap.cusrowid IN FRAME Web-Frame
   ALIGN-L EXP-LABEL EXP-FORMAT EXP-HELP                                */
/* SETTINGS FOR FILL-IN RowObject.EmailAddress IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.Fax IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.Name IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.Phone IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.PostalCode IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN RowObject.SalesRep IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* SETTINGS FOR FILL-IN ab_unmap.SearchName IN FRAME Web-Frame
   ALIGN-L EXP-LABEL EXP-FORMAT EXP-HELP                                */
/* SETTINGS FOR FILL-IN RowObject.State IN FRAME Web-Frame
   ALIGN-L EXP-LABEL                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ab_unmap.cusrowid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ab_unmap.cusrowid w-html web.input
PROCEDURE ab_unmap.cusrowid.input .
/*------------------------------------------------------------------------------
  Purpose:     Assigns form field data value to frame screen value.
  Parameters:  p-field-value
  Notes:       This input trigger of the hidden field cusrowid sets the
               current row to the one in the hidden field to set the context in 
               in preparation for further processing.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-field-value AS CHARACTER NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    setCurrentRowids (p-field-value).
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'dcustomer.wDB-AWARE':U ,
             INPUT  {&WINDOW-NAME} ,
             INPUT  'AppServiceASUsePromptASInfoForeignFieldsRowsToBatch3CheckCurrentChangednoRebuildOnReposyesServerOperatingModeNONEDestroyStatelessnoDisconnectAppServerno':U ,
             OUTPUT h_dcustomer ).
       RUN repositionObject IN h_dcustomer ( 1.00 , 1.00 ) NO-ERROR.
       /* Size in AB:  ( 1.86 , 10.80 ) */

       /* Adjust the tab order of the smart objects. */
    END. /* Page 0 */

  END CASE.

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
    ("AddMode":U,"ab_unmap.AddMode":U,ab_unmap.AddMode:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Address":U,"RowObject.Address":U,RowObject.Address:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("City":U,"RowObject.City":U,RowObject.City:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("cusrowid":U,"ab_unmap.cusrowid":U,ab_unmap.cusrowid:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("EmailAddress":U,"RowObject.EmailAddress":U,RowObject.EmailAddress:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Fax":U,"RowObject.Fax":U,RowObject.Fax:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Name":U,"RowObject.Name":U,RowObject.Name:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("Phone":U,"RowObject.Phone":U,RowObject.Phone:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("PostalCode":U,"RowObject.PostalCode":U,RowObject.PostalCode:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("SalesRep":U,"RowObject.SalesRep":U,RowObject.SalesRep:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("SearchName":U,"ab_unmap.SearchName":U,ab_unmap.SearchName:HANDLE IN FRAME {&FRAME-NAME}).
  RUN htmAssociate
    ("State":U,"RowObject.State":U,RowObject.State:HANDLE IN FRAME {&FRAME-NAME}).
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputFields w-html 
PROCEDURE inputFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:  After standard behavior for this procedure, this procedure-override
        looks at a hidden field called AddMode, and sets flags indicating that
        this record is new, and must be created in the database before the
        fields are assigned.  The AddMode flag is then turned off in preparation 
        for sending the next page.    
------------------------------------------------------------------------------*/
  RUN SUPER.

  /* All other requested actions indicate that the ADD should be discontinued. */
  IF ab_unmap.AddMode:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES":U AND
    ( get-field ("requestedAction":U) = "Save":U OR
      get-field ("requestedAction":U) = "Reset":U)  THEN DO:
    setAddMode (TRUE).
    setUpdateMode ("Add":U).
  END.

  IF ab_unmap.AddMode:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO" THEN DO:
    setAddMode (FALSE).
    setUpdateMode ("").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputFields w-html 
PROCEDURE outputFields :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes: This outputs the current record to the hidden field cusrowid before
         standard behavior for this procedure and outputs the AddMode hidden 
         field.          
------------------------------------------------------------------------------*/
ASSIGN
  ab_unmap.AddMode:SCREEN-VALUE IN FRAME {&FRAME-NAME}  =
    (IF getUpdateMode() = "Add":U THEN "YES":U ELSE "NO":U)
  ab_unmap.cusrowid:SCREEN-VALUE IN FRAME {&FRAME-NAME} = getRowids().
    
RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OutputHeader w-html 
PROCEDURE OutputHeader :
/*------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  
------------------------------------------------------------------------*/
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
  IF REQUEST_METHOD = "POST":U THEN DO:  
    RUN inputFields. 
    RUN findRecords.

    CASE get-field ("requestedAction":U):
      WHEN "First":U THEN 
        RUN fetchFirst.           
      WHEN "Next":U THEN
        RUN fetchNext.          
      WHEN "Prev":U THEN 
        RUN fetchPrev.         
      WHEN "Last":U THEN 
        RUN fetchLast.           
      WHEN "Search for Name":U THEN DO:
        addSearchCriteria('name':U, get-value('searchname':U)).   
        RUN findRecords.    
      END.

      /* Maintenance action selected  */
      WHEN "Save":U THEN DO:
        IF getUpdateMode () <> "add":U THEN
          RUN fetchCurrent. 
        RUN assignFields.
        setAddMode (FALSE).
        setUpdateMode ("").
      END.

      WHEN "Delete":U THEN DO:
        RUN fetchCurrent. 
        deleteRow(). 
      END.

      WHEN "Reset":U THEN
        RUN fetchCurrent.  

      WHEN "Cancel":U THEN DO: 
        RUN fetchCurrent.
        setUpdateMode ("").
      END.

      WHEN "Add":U THEN DO: 
        RUN fetchCurrent.
        setUpdateMode ("Add":U).
      END.
    END CASE.

    RUN displayFields.
    RUN enableFields.
    RUN outputFields.    
  END. /* Form has been submitted. */
 
  /* REQUEST-METHOD = GET */ 
  ELSE DO:   
    RUN findRecords.
    RUN displayFields.
    RUN enableFields.
    RUN outputFields.
  END. 
  
  /* Show error messages */
  IF AnyMessage() THEN
    ShowDataMessages().
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

