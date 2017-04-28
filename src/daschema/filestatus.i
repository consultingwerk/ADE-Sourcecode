
/*------------------------------------------------------------------------
    File        : filestatus.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : rkumar
    Created     : Tue Mar 20 17:35:40 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
define protected temp-table ttFileStatus no-undo  serialize-name "files" {1}
    field TableSequence      as integer   serialize-hidden
    field FileName           as character format "x(32)" serialize-name "fileName"
    field TableName          as character format "x(32)" serialize-name "tableName"
    field SchemaName         as character format "x(32)" serialize-name "schemaName"    
    field TableUrl           as character serialize-name "table_url"
    field CDCPolicyName      as character format "x(32)" serialize-name "cdcPolicyName"
    field CDCPolicyUrl       as character serialize-name "cdcPolicy_url"
    field ChangeTableName    as character format "x(32)" serialize-name "changeTableName"
    field Type               as character serialize-name "type"
    field TenantName         as character serialize-name "tenantName"  
    field TenantUrl          as character serialize-name "tenant_url"  
    field TenantGroupName    as character serialize-name "tenantGroupName"  
    field TenantGroupUrl     as character serialize-name "tenantGroup_url"  
    field StartTime          as datetime-tz serialize-name "startTime"
    field EndTime            as datetime-tz serialize-name "endTime"
    field ExpectedNumRows    as int64  serialize-name "expectedNumRows" init ?
    field ProcessedNumRows   as int64   serialize-name "processedNumRows"
    field IsComplete         as logical   serialize-name "isComplete"
    field AnyError           as logical   serialize-name "anyError"
    field ErrorMessage       as character serialize-name "errorMessage"
    field IsAvailable        as logical   serialize-name "isAvailable" init ?
    field CanExport          as logical   serialize-name "canExport"
    field CanImport          as logical   serialize-name "canImport" 
    field Bailed             as logical   serialize-hidden
      {daschema/entity.i}
    index idxtask as primary unique TableSequence
    index idxtask2 as  unique TableName type TenantName TenantGroupName CDCPolicyName
    index idxtask3  TableName type TenantGroupName
    index idxtask4  IsAvailable  
    index idxtask5  CanExport   
    index idxtask6  CanImport.  
    