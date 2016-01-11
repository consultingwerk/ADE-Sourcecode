
/*------------------------------------------------------------------------
    File        : groupdata.i
    Purpose     : 

    Syntax      :

    Description : group selection data for export/import

    Author(s)   : rkumar
    Created     : Thu Feb 16 17:57:22 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define protected temp-table ttGroupData no-undo serialize-name "tenantGroups"  {1}  
     field Name       as character serialize-name "Name"   
     {daschema/entity.i}
     index idxName as unique primary Name.
    