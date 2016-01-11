
/*------------------------------------------------------------------------
    File        : change.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sun Sep 26 18:02:21 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

define temp-table ttTableChange no-undo serialize-name "actions" {1}
    field TableName  as char format "x(20)" label "Table name" serialize-name "tableName"
    field Seq as int format ">>>>>>>9" label "Parse order" serialize-hidden
    field Name as char format "x(12)" label "Name" serialize-name "name"
    field Rename as char format "x(12)" label "Rename" serialize-name "rename"
    field IsMultitenantChange   as logical   serialize-name "isMultitenantChange"
/*    field isKeepDefaultAreaChange as logical   serialize-hidden serialize-name "keepDefaultArea"*/
    {daschema/entity.i}
    index idxTableName as primary unique TableName Seq
    index idxRename Rename. 

define temp-table ttSequenceChange no-undo serialize-name "actions" {1}
    field SequenceName  as char format "x(20)" label "Sequence name" serialize-name "sequenceName"
    field Seq as int format ">>>>>>>9" label "Parse order" serialize-hidden
    field Name as char format "x(12)" label "Name" serialize-name "name"
    field Rename as char format "x(12)" label "Rename" serialize-name "rename"
    field IsMultitenantChange   as logical   serialize-name "isMultitenantChange"
     {daschema/entity.i}
    index idxTableName as primary unique SequenceName Seq
    index idxRename Rename. 

define temp-table ttIndexChange no-undo serialize-name "actions" {1}
    field TableName  as char format "x(20)" label "Table name" serialize-name "tableName"
    field IndexName  as char format "x(20)" label "Index name" serialize-name "indexName"
    field Seq as int format ">>>>>>>9" label "Parse order" serialize-hidden
    field Name as char format "x(12)" label "Name" serialize-name "name"
    field Rename as char format "x(12)" label "Rename" serialize-name "rename"
    field IsMultitenantChange   as logical   serialize-name "isMultitenantChange"
    {daschema/entity.i}
    index idxIndex as primary unique TableName IndexName Seq
    index idxRename TableName Rename. 
 
define temp-table ttFieldChange no-undo serialize-name "actions" {1}
    field TableName  as char format "x(20)" label "Table name" serialize-name "tableName"
    field FieldName  as char format "x(20)" label "Field name" serialize-name "fieldName"
    field Seq as int format ">>>>>>>9" label "Parse order" serialize-hidden
    field Name as char format "x(12)" label "Name" serialize-name "name"
    field Rename as char format "x(12)" label "Rename" serialize-name "rename"
    field IsMultitenantChange   as logical   serialize-name "isMultitenantChange"
    {daschema/entity.i}
    index idxIndex as primary unique TableName FieldName Name
    index idxRename TableName Rename. 
  