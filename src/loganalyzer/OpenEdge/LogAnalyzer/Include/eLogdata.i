
 /*------------------------------------------------------------------------
    File        : LogData
    Purpose		:
    Syntax      : 
    Description :
    Author(s)   : isyed
    Created     : Mon Jan 01 23:20:17 EST 2018
    Notes       : 
  ----------------------------------------------------------------------*/
  
  /* ***************************  Definitions  ************************** */
  
  /* ********************  Preprocessor Definitions  ******************** */
  
  /* ***************************  Main Block  *************************** */
  
  /** Dynamically generated schema file **/
   
@openapi.openedge.entity.required (fields="ABLAppName,EntryDatetime,OEABLWebApp,PID").
	
DEFINE TEMP-TABLE ttLogData BEFORE-TABLE bttLogData
FIELD id            AS CHARACTER
FIELD seq           AS INTEGER      INITIAL ?
FIELD EntryDatetime AS DATETIME-TZ LABEL "Datetime"
FIELD LogEntryDetailRef AS CHARACTER LABEL "Log detail reference"
FIELD ABLAppName AS CHARACTER INITIAL "tomcat" LABEL "Appname"
FIELD OEABLWebApp AS CHARACTER LABEL "Webapp"
FIELD EventStatus AS CHARACTER LABEL "Status"
FIELD Component AS CHARACTER INITIAL "n/a" LABEL "Component"
FIELD PID AS INT64 INITIAL "0" LABEL "PID"
FIELD TID AS INT64 INITIAL "0" LABEL "ThreadID"
FIELD SessionID AS CHARACTER INITIAL "n/a" LABEL "SessionID"
FIELD Operation AS CHARACTER LABEL "Operation"
FIELD RequestSize AS INTEGER INITIAL "0" LABEL "Request size"
FIELD ResponseSize AS INTEGER INITIAL "0" LABEL "ResponseSize"
FIELD LogEntryText AS CHARACTER INITIAL "n/a" LABEL "Log text"
INDEX seq IS PRIMARY UNIQUE seq
INDEX QueryByDatetime EntryDatetime  ASCENDING 
INDEX QueryByDatetimeAgentPIDTID  EntryDatetime  ASCENDING  PID  ASCENDING  TID  ASCENDING 
INDEX QueryByDateTimeAppname  EntryDatetime  ASCENDING  ABLAppName  ASCENDING 
INDEX QueryByDatetimeStatus  EntryDatetime  ASCENDING  EventStatus  ASCENDING 
INDEX QueryByDatetimeWebApp  EntryDatetime  ASCENDING  OEABLWebApp  ASCENDING 
INDEX QueryByLogtext  LogEntryText  ASCENDING . 


DEFINE DATASET dsLogData FOR ttLogData.