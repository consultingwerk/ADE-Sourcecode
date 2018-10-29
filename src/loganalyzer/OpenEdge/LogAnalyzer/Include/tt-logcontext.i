
/*------------------------------------------------------------------------
    File        : tt-logcontext
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : isyed
    Created     : Tue Jan 02 09:39:12 EST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

@openapi.openedge.entity.primarykey (fields="CustomerName,CaseID,InstanceName").
    @openapi.openedge.entity.required (fields="CaseID,Created,CustomerName,InstanceName").
    
DEFINE TEMP-TABLE tt-LogContext BEFORE-TABLE btt-LogContext
FIELD CustomerName AS CHARACTER LABEL "Customer"
FIELD CaseID AS CHARACTER LABEL "case"
FIELD InstanceName AS CHARACTER LABEL "Instance"
FIELD Created AS DATETIME LABEL "Created"
INDEX LogCtxIdx IS  PRIMARY  UNIQUE  CustomerName  ASCENDING  CaseID  ASCENDING  InstanceName  ASCENDING .