/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : connection.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
 
define temp-table ttConnection no-undo  serialize-name "connections" {1} before-table ttDomainCopy
    field Name as char                               serialize-name "name"        format "x(25)"
    field AreasUrl        as character               serialize-name "areas_url" format "x(40)" label "Areas url"
    field DomainsUrl      as character               serialize-name "domains_url" format "x(40)" label "Domains url"
    field GroupsUrl       as character               serialize-name "groups_url" format "x(40)" label "Groups url"
    field SequencesUrl    as character               serialize-name "sequences_url" format "x(40)" label "Sequences url"
    field SchemasUrl      as character               serialize-name "schemas_url" format "x(40)" label "Schemas url"
    field TablesUrl       as character               serialize-name "tables_url" format "x(40)" label "Tables url"
    field TenantsUrl      as character               serialize-name "tenants_url" format "x(40)" label "Tenants url"
    field UsersUrl        as character               serialize-name "users_url" format "x(40)" label "Users url"
    field NumAreas        as int                     serialize-name "numAreas" format "zzzzzzzzz" label "Num areas"
    field NumDomains      as int                     serialize-name "numDomains" format "zzzzzzzzz" label "Num domains"
    field NumGroups       as int                     serialize-name "numGroups" format "zzzzzzzzz" label "Num groups"
    field NumSequences    as int                     serialize-name "numSequences" format "zzzzzzzzz" label "Num sequences"
    field NumSchemas      as int                     serialize-name "numSchemas" format "zzzzzzzzz" label "Num schemas"
    field NumTables       as int                     serialize-name "numTables" format "zzzzzzzzz" label "Num tables"
    field NumTenants      as int                     serialize-name "numTenants" format "zzzzzzzzz" label "Num tenants"
    field NumUsers        as int                     serialize-name "numUsers" format "zzzzzzzzz" label "Num users"
    field URL             as character               serialize-name "url" format "x(40)" label "Url"

    {daschema/entity.i}
    index idxName as primary unique Name  .
          
