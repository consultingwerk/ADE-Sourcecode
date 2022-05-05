
/*------------------------------------------------------------------------
    File        : tt-ablapplications.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : isyed
    Created     : Tue Jan 02 09:40:29 EST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

@openapi.openedge.entity.primarykey (fields="ABLAppName").
    @openapi.openedge.entity.required (fields="ABLAppName").
    
DEFINE TEMP-TABLE tt-ABLApplications BEFORE-TABLE btt-ABLApplications
FIELD ABLAppName AS CHARACTER LABEL "ABL app"
INDEX ABLAppIdx IS  PRIMARY  UNIQUE  ABLAppName  ASCENDING . 