
 /*------------------------------------------------------------------------
    File        : LogDetail
    Purpose		:
    Syntax      : 
    Description :
    Author(s)   : isyed
    Created     : Mon Jan 01 23:20:35 EST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
  /* ***************************  Definitions  ************************** */
  
  /* ********************  Preprocessor Definitions  ******************** */
  
  /* ***************************  Main Block  *************************** */
  
  /** Dynamically generated schema file **/
   
@openapi.openedge.entity.primarykey (fields="LogEntryDetailRef").
	@openapi.openedge.entity.required (fields="DetailLine,LogEntryDetailRef").
	
DEFINE TEMP-TABLE ttLogDetail BEFORE-TABLE bttLogDetail
FIELD id            AS CHARACTER
FIELD seq           AS INTEGER      INITIAL ?
FIELD LogEntryDetailRef AS CHARACTER LABEL "Log entry detail ref"
FIELD DetailLine AS CHARACTER LABEL "Log detail line"
INDEX seq IS PRIMARY UNIQUE seq
INDEX LogDetRefIdx LogEntryDetailRef  ASCENDING . 


DEFINE DATASET dsLogDetail FOR ttLogDetail.