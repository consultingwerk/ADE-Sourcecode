/*------------------------------------------------------------------------
    File        : role.i
    Purpose     : 
    Syntax      :
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
  
define  temp-table ttGrantedRole no-undo  serialize-name "grants":u {1} before-table ttGrantedRoleCopy
         field Id              as character     serialize-name "id":u               format 'x(28)':u
         field RoleName        as character     serialize-name "roleName":u         format "x(32)":u
         field CustomDetail    as character     serialize-name "customDetail":u     format "x(500)":u
         field Grantor         as character     serialize-name "grantor":u          format "x(32)":u
         field Grantee         as character     serialize-name "grantee":u          format "x(32)":u
         field CanGrant        as logical       serialize-name 'canGrant':u
         field URL             as character     serialize-name "url":u              format "x(30)":u label "Url"
         
         {daschema/entity.i}
         index idxName as primary unique Id  
         index idxId RoleName .
