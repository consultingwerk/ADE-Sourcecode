/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: xmlwidg.i

Description:
    Universal WebSpeed XML temp-table definitions.

Updated: 05/01/00 adams@progress.com
           Initial version
         02/09/02 adams@progress.com
           Modified tNode indexes

----------------------------------------------------------------------------*/

/* tNode - XML schema node structure */
DEFINE TEMP-TABLE tNode NO-UNDO
  FIELD abstract             AS CHARACTER  LABEL "Abstract"
  FIELD attributeFormDefault AS CHARACTER  LABEL "Attribute Form Default"
  FIELD base                 AS CHARACTER  LABEL "Base"
  FIELD blockValue           AS CHARACTER  LABEL "Block"
  FIELD content              AS CHARACTER  LABEL "Content"
  FIELD dataForm             AS CHARACTER  LABEL "Form"
  FIELD dataKey              AS RECID      LABEL "Data Key" /*TV*/
  FIELD dataType             AS CHARACTER  LABEL "Type"
  FIELD dataValue            AS CHARACTER  LABEL "Value"
  FIELD defaultValue         AS CHARACTER  LABEL "Default"
  FIELD derivedBy            AS CHARACTER  LABEL "Derived By"
  FIELD documentPath         AS CHARACTER  LABEL "Document Path"
  FIELD element              AS CHARACTER  LABEL "Element"
  FIELD elementFormDefault   AS CHARACTER  LABEL "Element Form Default"
  FIELD equivClass           AS CHARACTER  LABEL "Equivalent Class"
  FIELD final                AS CHARACTER  LABEL "Final"
  FIELD instance             AS INTEGER    LABEL "Instances"
  FIELD mapConversion        AS CHARACTER  LABEL "Map Conversion Function"
  FIELD mapFile              AS CHARACTER  LABEL "Object Path" /*map*/
  FIELD mapLink              AS CHARACTER  LABEL "SmartLink" /*map*/
  FIELD mapName              AS CHARACTER  LABEL "Map I/O Name" /*map*/
  FIELD mapParameter         AS INTEGER    LABEL "Map I/O Parameter" /*map*/
    INITIAL ?
  FIELD mapType              AS CHARACTER  LABEL "Map I/O Type" /*map*/
    /* source/target: column, function, procedure */
  FIELD mapUpdate            AS CHARACTER  LABEL "Consumer Update" /*map*/
  FIELD maxOccurs            AS CHARACTER  LABEL "Maximum Occurances"
  FIELD minOccurs            AS CHARACTER  LABEL "Minimum Occurances"
  FIELD model                AS CHARACTER  LABEL "Model"
  FIELD nameSpace            AS CHARACTER  LABEL "Namespace"
  FIELD node                 AS INTEGER    LABEL "Node ID"
  FIELD nodeName             AS CHARACTER  LABEL "Name" CASE-SENSITIVE
  FIELD nullable             AS CHARACTER  LABEL "Nullable"
  FIELD objectName           AS CHARACTER  LABEL "Object Name" /*map*/
  FIELD order                AS CHARACTER  LABEL "Order"
  FIELD parentName           AS CHARACTER  LABEL "Parent Name" CASE-SENSITIVE
  FIELD parentNode           AS INTEGER    LABEL "Parent ID"
  FIELD processContents      AS CHARACTER  LABEL "Process Contents"
  FIELD ref                  AS CHARACTER  LABEL "Reference"
  FIELD schemaLocation       AS CHARACTER  LABEL "Schema Location"
  FIELD schemaPath           AS CHARACTER  LABEL "Schema Path"
  FIELD targetNamespace      AS CHARACTER  LABEL "Target Namespace"
  FIELD tvNode               AS COM-HANDLE LABEL "TreeView Node"
  FIELD useValue             AS CHARACTER  LABEL "Use"
  FIELD xNodeRef             AS HANDLE     LABEL "X Node Handle"
  
  INDEX node IS PRIMARY node parentNode /* added parentNode (adams) */
  INDEX xNodeRef xNodeRef
  INDEX parentName parentName nodeName
  INDEX parentNode parentNode element /* used by adm2/b2b.p chambers */
  INDEX tvNode tvNode
  INDEX documentPath documentPath
  /* Both parentName and element are used together with nodeName for
     searching.  Since likelihood of nodeName used more than once is low
     and cost of additional indexes is high, we'll go with single index
     (adams) */
  INDEX nodename nodename /* chambers */
  .
  
/* tSchema - XML schema <SCHEMA> node attributes */
DEFINE TEMP-TABLE tSchema NO-UNDO
  FIELD attrName             AS CHARACTER LABEL "Name"
  FIELD attrValue            AS CHARACTER LABEL "Value"
  index attrname is primary attrname /* chambers */
  .

/* tData - XML node structure as it appears in data file format */
DEFINE TEMP-TABLE tData NO-UNDO LIKE tNode.
  
/* xmlwidg.i - end of file */
