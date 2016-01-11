/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : July 2013 
    Notes       : 
  ----------------------------------------------------------------------*/
define temp-table ttPartitionPolicy no-undo serialize-name "partitionPolicies" {1} before-table ttPartitionPolicyCopy  
     field Name  as character  serialize-name "name" 
     field SchemaName as character  serialize-name "schemaName" format "x(3)" label "Schema" init "PUB"
     field TableName  as character  serialize-name "tableName" 
     field TableUrl as character   serialize-name "table_url" 
     /* currently only exposed in rest - use AddDetailsFromData with parameters from ABL
       (serialize-name is set in code in import) */
     field DetailNameTemplate  as character  serialize-hidden
   
     field Description as character   serialize-name "description"
     field ObjectNumber  as integer  serialize-hidden
/*     field IsDataEnabled as logical serialize-name "isDataEnabled" init true*/
/*     field IsAllocated as logical serialize-name "isAllocated"              */
     field URL   as character                  serialize-name "url"
     field HasRange as logical serialize-name "hasRange" 
     field Type     as character serialize-name "type" 
     field PartitionPolicyDetailsUrl as character   serialize-name "partitionPolicyDetails_url" 
     /* link to list ALL areas for lookup purposes doen't belong here*/ 
/*     field AreasUrl as character  serialize-name "areas_url"*/
     field DefaultDataAreaName as character  serialize-name "defaultDataAreaName" /* Must be valid TII area */
     field DefaultDataAreaUrl as character  serialize-name "defaultDataArea_url"  
     field DefaultIndexAreaName as character  serialize-name "defaultIndexAreaName" /* Must be valid TII area */
     field DefaultIndexAreaUrl as character  serialize-name "defaultIndexArea_url"  
     field DefaultLobAreaName as character  serialize-name "defaultLobAreaName" /* Must be valid TII area */
     field DefaultLobAreaUrl as character  serialize-name "defaultLobArea_url"  
     field DefaultAllocation as character  serialize-name "defaultAllocation" init "None"  
     field NumFields as int serialize-hidden
     field FieldNames as char extent 15 serialize-hidden init ? 
     {daschema/entity.i} 
     index PartitionNameIdx as primary  unique Name
     index TableIdx as unique TableName SchemaName
     
. 