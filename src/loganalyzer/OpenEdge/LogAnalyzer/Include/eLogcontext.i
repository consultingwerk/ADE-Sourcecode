
 /*------------------------------------------------------------------------
    File        : LogContext
    Purpose		:
    Syntax      : 
    Description :
    Author(s)   : isyed
    Created     : Mon Jan 01 23:19:57 EST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
  /* ***************************  Definitions  ************************** */
  
  /* ********************  Preprocessor Definitions  ******************** */
  
  /* ***************************  Main Block  *************************** */
  
  /** Dynamically generated schema file **/
   
@openapi.openedge.entity.primarykey (fields="CustomerName,CaseID,InstanceName").
	@openapi.openedge.entity.required (fields="CaseID,Created,CustomerName,InstanceName").
	
DEFINE TEMP-TABLE ttLogContext BEFORE-TABLE bttLogContext
FIELD CustomerName AS CHARACTER LABEL "Customer"
FIELD CaseID AS CHARACTER LABEL "case"
FIELD InstanceName AS CHARACTER LABEL "Instance"
FIELD Created AS DATETIME LABEL "Created"
INDEX LogCtxIdx IS  PRIMARY  UNIQUE  CustomerName  ASCENDING  CaseID  ASCENDING  InstanceName  ASCENDING . 


DEFINE DATASET dsLogContext FOR ttLogContext.