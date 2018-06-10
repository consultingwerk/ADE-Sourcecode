/* ***********************************************************/
/* Copyright (c) 2015-2018 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 

/*------------------------------------------------------------------------
    File        : cdctablepolicy.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Nov 17 17:15:24 IST 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define temp-table ttCdcTablePolicy no-undo serialize-name "cdcTablePolicies" {1} before-table ttCdcTablePolicyCopy
 
    field Name          as character serialize-name "name" 
    field TableName              as character serialize-name "tableName"
    field SchemaName             as character serialize-name "schemaName"
    field Instance               as integer   serialize-name "instance" init ?
    field CdcPolicyId                     as character   serialize-name "cdcPolicyId"
    field Description            as character serialize-name "description" 
    field FieldPolicyNameTemplate  as character  serialize-hidden
    field State                  as integer   serialize-name "state" init ?
    
    field ChangeTable            as character serialize-name "changeTable" init ?
    field ChangeTableOwner            as character serialize-name "changeTableOwner" init "PUB"
    field SourceTableOwner            as character serialize-name "sourceTableOwner" init "PUB"
    field EncryptPolicy       as logical   serialize-name "encryptPolicy" init yes
    field IdentifyingField       as logical   serialize-name "identifyingField" init no
    //field IdentifyingFieldsUnique as logical   serialize-name "identifyingFieldsUnique" init no
    field Level                  as integer   serialize-name "level" init ?
    field DataAreaName           as character serialize-name "dataAreaName"
    field IndexAreaName          as character serialize-name "indexAreaName"
    field DataAreaNumber         as integer serialize-hidden
    field IndexAreaNumber        as integer serialize-hidden
    field FieldName              as character serialize-hidden 
    field LastModified           as datetime-tz serialize-name "lastModified"
    field ObjectType             as character serialize-hidden 
    field NumFields              as int       serialize-hidden
    field FieldNames             as char      extent 15 serialize-hidden
    field Misc                   as char      extent 16 serialize-hidden  
    
    field url   as character                  serialize-name "url"
    field TableUrl as character   serialize-name "table_url" 
    field CdcFieldPoliciesUrl as character   serialize-name "cdcFieldPolicies_url" 
    field DataAreaUrl as character  serialize-name "dataArea_url"
    field IndexAreaUrl as character  serialize-name "indexArea_url"
                 
    {daschema/entity.i}
    index PartitionNameIdx as primary  unique Name
    //index idxtable as unique  TableName
    .
