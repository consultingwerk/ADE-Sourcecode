/*------------------------------------------------------------------------
    File        : authtag.i
    Purpose     : 
    Syntax      :
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
  
define  temp-table ttAuthTag no-undo serialize-name "authtags":u {1} before-table btAuthTag
     field Name            as character         serialize-name "tagName":u        format "x(32)":u
     field RoleName        as character         serialize-name "roleName":u       format "x(32)":u
     field Description     as character         serialize-name "description":u    format "x(500)":u
     
     field Id              as integer  init ?   serialize-hidden

     {daschema/entity.i}
     index idxName as primary unique Name RoleName
     index idxId Id
     .
