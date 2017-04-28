/*------------------------------------------------------------------------
    File        : dboption.i
    Author(s)   : pjudge
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
  
define temp-table ttDbOption no-undo  serialize-name "dboptions" {1} before-table ttDbOptionCopy
    field Code          as character    serialize-name "code":u         format "x(35)":u
    field OptionType    as integer      serialize-name 'type':u
    field OptionValue   as character    serialize-name 'value':u        format 'x(70)':u
    field IsBuiltin     as logical      serialize-name "isBuiltin":u                        label "Built-in"
    field Description   as character    serialize-name "description":u  format "x(500)":u
    field URL           as character    serialize-name "url":u          format "x(30)":u    label "Url"
         
    {daschema/entity.i}
    index idxName as primary unique Code  
    .