
/*------------------------------------------------------------------------
    File        : oeablapps.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : isyed
    Created     : Tue Jan 02 09:35:51 EST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
   
@openapi.openedge.entity.primarykey (fields="OEABLAppName,ABLAppName").
    @openapi.openedge.entity.required (fields="OEABLAppName").
    
DEFINE TEMP-TABLE tt-OEABLApps BEFORE-TABLE btt-OEABLApps
FIELD ABLAppName AS CHARACTER LABEL "ABL app"
FIELD OEABLAppName AS CHARACTER LABEL "OE app name"
INDEX OEAppIdx IS  PRIMARY  UNIQUE  OEABLAppName  ASCENDING  ABLAppName  ASCENDING . 