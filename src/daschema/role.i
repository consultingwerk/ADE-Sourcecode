/*------------------------------------------------------------------------
    File        : role.i
    Purpose     : 
    Syntax      :
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
  
define  temp-table ttRole no-undo  serialize-name "roles":u {1} before-table ttRoleCopy
     field Name            as character               serialize-name "roleName":u       format "x(32)":u
     field Description     as character               serialize-name "description":u    format "x(500)":u
     field IsBuiltin       as logical                 serialize-name "isBuiltin"        label "Built-in":u
     field IsDDM           as logical                 serialize-name "isDDM":u          label "DDM":u
     field Creator         as character               serialize-name "creator":u        format "x(32)":u
     field CustomDetail    as character               serialize-name "customDetail":u   format "x(500)":u
     field URL             as character               serialize-name "url":u            format "x(30)":u label "Url"
     field GrantsUrl       as character               serialize-name "granted_roles_url":u  format "x(30)" label "Granted roles url"

     field Id              as integer  init ?         serialize-hidden
     
     {daschema/entity.i}
     index idxName as primary unique Name  
     index idxId Id
     .
