/***********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights      *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------
    File        : dswid.i
    Purpose     : 

    Syntax      :

    Description : Temp-Tables and ProDataSet definitions for the
                  implementation of the WIDGET-ID support.

    Author(s)   : Marcelo Ferrante
    Created     : Tue May 08 16:31:22 EDT 2007
    Notes       : The ProDataSet definitions matchs the definition of the
                  XML file that stores the widget-id values.
                  WRITE-XML and READ-XML can then be used to synchronize
                  values between the XML file and ProDataSet.
 
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE Container NO-UNDO BEFORE-TABLE before_Container
FIELD contName   AS CHARACTER XML-NODE-NAME "Name":U XML-NODE-TYPE "ATTRIBUTE":U
FIELD contPath   AS CHARACTER XML-NODE-NAME "Path":U XML-NODE-TYPE "ATTRIBUTE":U
FIELD ObjectType AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
INDEX containerID AS UNIQUE contPath contName.

DEFINE TEMP-TABLE Instances NO-UNDO
FIELD contName AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contPath AS CHARACTER XML-NODE-TYPE "HIDDEN":U
INDEX parentid AS UNIQUE contPath contName.

DEFINE TEMP-TABLE Instance NO-UNDO BEFORE-TABLE before_Instance
FIELD ID         AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD contPath   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contName   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD ObjectType AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD WidgetID   AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U
INDEX ckey       AS PRIMARY UNIQUE contPath contName ID
INDEX cWidgetID  contPath contName WidgetID.

DEFINE TEMP-TABLE InstanceChildren NO-UNDO BEFORE-TABLE before_InstanceChildren
FIELD ID               AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD contPath         AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contName         AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD parentInstanceID AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD ObjectType       AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD WidgetID         AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U
INDEX ckey             AS PRIMARY UNIQUE contPath contName parentInstanceID ID.

DEFINE TEMP-TABLE ParentPages NO-UNDO XML-NODE-NAME "Pages":U
FIELD contName AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contPath AS CHARACTER XML-NODE-TYPE "HIDDEN":U
INDEX parentid AS PRIMARY UNIQUE contPath contName.

DEFINE TEMP-TABLE Pages NO-UNDO XML-NODE-NAME "Page":U BEFORE-TABLE before_Pages
FIELD contPath   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contName   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD pageNumber AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U XML-NODE-NAME "ID":U
FIELD pageLabel  AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U XML-NODE-NAME "Label":U
FIELD WidgetID   AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U
INDEX pageNumber AS PRIMARY UNIQUE contPath contName PageNumber.

DEFINE TEMP-TABLE Actions NO-UNDO XML-NODE-NAME "ToolbarButtons":U
FIELD contName AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contPath AS CHARACTER XML-NODE-TYPE "HIDDEN":U
INDEX parentid AS PRIMARY UNIQUE contPath contName.

DEFINE TEMP-TABLE Action NO-UNDO XML-NODE-NAME "Button":U BEFORE-TABLE before_Action
FIELD contPath    AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contName    AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD actionID    AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U XML-NODE-NAME "ID":U
FIELD actionLabel AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U XML-NODE-NAME "Label":U
FIELD WidgetID    AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U
INDEX actionID AS PRIMARY UNIQUE contPath contName actionID.

DEFINE TEMP-TABLE TreeNodes NO-UNDO XML-NODE-NAME "TreeViewNodes":U
FIELD contName AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contPath AS CHARACTER XML-NODE-TYPE "HIDDEN":U
INDEX parentid AS UNIQUE contPath contName.

DEFINE TEMP-TABLE TreeNode NO-UNDO BEFORE-TABLE before_TreeNode
FIELD ID         AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD cLabel     AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U XML-NODE-NAME "Label":U
FIELD contPath   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD contName   AS CHARACTER XML-NODE-TYPE "HIDDEN":U
FIELD ObjectType AS CHARACTER XML-NODE-TYPE "ATTRIBUTE":U
FIELD WidgetID   AS INTEGER   XML-NODE-TYPE "ATTRIBUTE":U
INDEX ckey       AS PRIMARY UNIQUE contPath contName ID
INDEX cWidgetID  contPath contName widgetID.

DEFINE DATASET dsWidgetID     FOR Container, parentPages, Pages, Actions, Action,
                                  Instances, Instance, instanceChildren,
                                  TreeNodes, TreeNode
    DATA-RELATION contAction  FOR Container, parentPages    
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION contPage    FOR parentPages, Pages
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION contAction  FOR Container, Actions    
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION Action      FOR Actions, Action    
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION contInst    FOR Container, Instances
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION contInst    FOR Instances, Instance
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION relInstance FOR Instance, instanceChildren
        RELATION-FIELDS(ID,parentInstanceID,contPath,contPath,contName,contName) NESTED
    DATA-RELATION contTrees   FOR Container, TreeNodes
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
    DATA-RELATION contTree    FOR TreeNodes, TreeNode
        RELATION-FIELDS(contPath,contPath,contName,contName) NESTED
        .

DEFINE TEMP-TABLE ttObjectNames NO-UNDO
FIELD lImport  AS LOGICAL INITIAL TRUE
FIELD cName    AS CHARACTER
FIELD isStatic AS LOGICAL
FIELD hHandle  AS HANDLE
INDEX lImport limport
INDEX cname cname.