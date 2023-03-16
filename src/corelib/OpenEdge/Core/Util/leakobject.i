/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : leakobject.i
    Purpose     : Temp-table definition for the LeakCheck's internal object table
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-02-17
    Notes       : * Holds all of the objects created and deleted in a log or logs
                  * Objects are identified by session, group, type and id. For widget-pools, this is not a unique combo since
                    they are not given an internal identifier by the AVM. For all other groups/types, the combo is unique.
                  * When an object is created, the ACTION is CREATE. When deleted, the action is DELETE.
                  * A leak is indicated when there is a CREATE action without a DELETE action for the object. The RelatedObject
                    field should be used to allow a CREATE to reference a DELETE and a DELETE to reference a CREATE
                  * An ACCESS-LEVEL preprocessor is provided for use in classes: it should be a standard, supported access level
                    for temp-tables
                  * A TABLE-PREFIX preprocessor value may be used to add prefix character(s) to the table name.
                  * A FIELD-PREFIX preprocessor value may be used to add prefix character(s) to all field names.
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
define {&ACCESS-LEVEL} temp-table {&TABLE-PREFIX}Object no-undo     serialize-name 'objects'
    field {&FIELD-PREFIX}SessId        as character           serialize-name 'session'
    field {&FIELD-PREFIX}Grp           as character           serialize-name 'group'    // BLOB|DATA|HANDLE|PLO|PROCEDURE|WIDGET-POOL|XML
    field {&FIELD-PREFIX}Type          as character           serialize-name 'type'
    field {&FIELD-PREFIX}Id            as character           serialize-name 'id'
    field {&FIELD-PREFIX}Info          as character           serialize-name 'info'
    field {&FIELD-PREFIX}RequestId     as character           serialize-name 'req'
    field {&FIELD-PREFIX}Size          as int64 initial ?     serialize-name 'size'
    field {&FIELD-PREFIX}WidgetPool    as character initial ? serialize-name 'pool'
    field {&FIELD-PREFIX}LogAt         as datetime-tz         serialize-name 'at'
    field {&FIELD-PREFIX}LogLine       as int64               serialize-name 'line'
    field {&FIELD-PREFIX}LogName       as character           serialize-name 'log'
    field {&FIELD-PREFIX}Action        as character           serialize-name 'action' // CREATE | DELETE |DELETE-PENDING
    // holds the created or deleted record, depending on which action this record has
    field {&FIELD-PREFIX}RelatedObject as rowid               serialize-hidden
    
    index idx1 {&FIELD-PREFIX}SessId {&FIELD-PREFIX}Grp {&FIELD-PREFIX}Type {&FIELD-PREFIX}Id {&FIELD-PREFIX}LogAt descending
    index idx2 as primary {&FIELD-PREFIX}LogAt
    index idx3 {&FIELD-PREFIX}Grp {&FIELD-PREFIX}LogAt
    index idx4 {&FIELD-PREFIX}SessId {&FIELD-PREFIX}LogAt
    index idx5 as unique {&FIELD-PREFIX}LogName {&FIELD-PREFIX}LogLine
    index idx6 {&FIELD-PREFIX}Type {&FIELD-PREFIX}LogAt
    // to find if a CREATE has a DELETE or vice versa
    index idx7 {&FIELD-PREFIX}Action {&FIELD-PREFIX}RelatedObject
    .
/* EOF */