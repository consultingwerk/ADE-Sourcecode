
/*------------------------------------------------------------------------
    File        : securityoptions.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Thu Nov 24 15:46:59 IST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define temp-table ttSecurityOptions no-undo serialize-name "securityOptions" {1} before-table ttAdministratorCopy
         /* this class is keyless as there is only one record, but we need a key 
            for the dataset and context (we keep it blank and use find(""))  */
         field Name           as char serialize-hidden 
         field TrustApplicationDomainRegistry as char serialize-name "trustApplicationDomainRegistry"
         field RecordAuthenticatedSessions as char serialize-name "recordAuthenticatedSessions"
         field DisallowBlankUserid as char serialize-name "disallowBlankUserid"
         field UseRuntimePermissions as char serialize-name "useRuntimePermissions"   
         field CDCUserid as char serialize-name "cdcUserid"      
         {daschema/entity.i}           
         index idxName as primary unique Name. 