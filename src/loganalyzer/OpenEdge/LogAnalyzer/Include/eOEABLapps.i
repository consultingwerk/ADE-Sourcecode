
 /*------------------------------------------------------------------------
    File        : OEABLApps
    Purpose		:
    Syntax      : 
    Description :
    Author(s)   : isyed
    Created     : Mon Jan 01 23:21:42 EST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
  /* ***************************  Definitions  ************************** */
  
  /* ********************  Preprocessor Definitions  ******************** */
  
  /* ***************************  Main Block  *************************** */
  
  /** Dynamically generated schema file **/
   
@openapi.openedge.entity.primarykey (fields="OEABLAppName,ABLAppName").
	@openapi.openedge.entity.required (fields="OEABLAppName").
	
DEFINE TEMP-TABLE ttOEABLApps BEFORE-TABLE bttOEABLApps
FIELD ABLAppName AS CHARACTER LABEL "ABL app"
FIELD OEABLAppName AS CHARACTER LABEL "OE app name"
INDEX OEAppIdx IS  PRIMARY  UNIQUE  OEABLAppName  ASCENDING  ABLAppName  ASCENDING . 


DEFINE DATASET dsOEABLApps FOR ttOEABLApps.