
 /*------------------------------------------------------------------------
    File        : ABLApplications
    Purpose		:
    Syntax      : 
    Description :
    Author(s)   : isyed
    Created     : Mon Jan 01 23:18:55 EST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
  /* ***************************  Definitions  ************************** */
  
  /* ********************  Preprocessor Definitions  ******************** */
  
  /* ***************************  Main Block  *************************** */
  
  /** Dynamically generated schema file **/
   
@openapi.openedge.entity.primarykey (fields="ABLAppName").
	@openapi.openedge.entity.required (fields="ABLAppName").
	
DEFINE TEMP-TABLE ttABLApplications BEFORE-TABLE bttABLApplications
FIELD ABLAppName AS CHARACTER LABEL "ABL app"
INDEX ABLAppIdx IS  PRIMARY  UNIQUE  ABLAppName  ASCENDING . 


DEFINE DATASET dsABLApplications FOR ttABLApplications.