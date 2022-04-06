/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  FILE: getobjecti.i

  DESCRIPTION:  Dynamics Runtime Obejct Retrieval temp-table definition include.

  Purpose:      This include file contains all static temp-table definitions that
                  comprise the Dynamics Object Cache.
                  
                  Included are:
                  ttClass (and transportClass)
                  ttEntity
                  cacheObject
                  cachePage
                  cacheLink
                  
                  These temp-tables are inteded only for runtime use. For information
                  on design-time temp-tables etc, see the Design Manager.

  Parameters:   

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                DATE:   07/24/2003  Author:    pjudge 

  UPDATE Notes: INITIAL Implementation


---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* This temp-table stores the names of all the classes (object types) and their associated
   temp-table names and handles to the default buffers of the temp-tables that have been
   created to store each class' default attributes. A seperate temp-table is defined for each class, containg a
   seperate field for every attribute in the class, plus some extra control fields
   The table for each class is called "cache_" + the class name, e.g. "cache_dynview".
   This table is updated in the function createClassCacheRecord in the reposistory manager, which is
   called from the createClassCache procedure which caches the attribute values for an object type.
*/
DEFINE TEMP-TABLE ttClass           NO-UNDO
    FIELD ClassName                 AS CHARACTER        /* The name of the class, e.g. dynview */
    FIELD ClassObj                  AS DECIMAL            /* The object ID of the class. Used by the object retrieval */
    FIELD ClassTableName            AS CHARACTER        /* The name of the class' temp-table, e.g. cache_dynview */
    FIELD ClassBufferHandle         AS HANDLE           /* Handle to the dynamic temp-table's buffer */
    FIELD InheritsFromClasses       AS CHARACTER        /* Stores the class names of all classes that this class inherits from */
    FIELD SuperProcedures           AS CHARACTER        /* Stores the pathed super procedures for this class, and only this class. */
    FIELD SuperProcedureModes       AS CHARACTER        /* Stores super procedures mode 'STATELESS' or 'STATEFUL'  */
    FIELD SuperHandles              AS CHARACTER        /* Stores the started super procedure handles for this class, and only this class. */
    FIELD InstanceBufferHandle      AS HANDLE           /* Stores the started instances. */
    FIELD EventTableName            AS CHARACTER        /* The name of the dynamic TT storing the UI events associated with this class. */
    FIELD EventBufferHandle         AS HANDLE            /* The handle pointing to the above table's default buffer. */
    /* System fields for the management of attributes */
    FIELD SetList                    AS CHARACTER        /* List of ordinal number of override_type 'Set' fields */ 
    FIELD GetList                    AS CHARACTER        /* List of ordinal number of override_type 'Get' fields */ 
    FIELD RuntimeList                AS CHARACTER        /* List of ordinal number of 'runtime_only' fields */
    INDEX idxMain
        ClassName
    INDEX idxTableName          AS PRIMARY UNIQUE
        ClassTableName
    INDEX idxEventTableName     AS UNIQUE
        EventTableName
    INDEX idxObjectId
        ClassObj        
    .
    
/* This temp-table is used to store ttClass information when that information
 * is transported across the AppServer.
 */
DEFINE TEMP-TABLE transportClass NO-UNDO LIKE ttClass.

/* This temp-table stores the names of the cached Entity objects and their associated
 * table buffers. These buffers are temp-tables that have been constructed based on
 * the Entity ryc_smartObject records and their contained instances, using selected attributes
 * to determine those pieces of information that can be stored against buffer fields. This 
 * information will often represent DataField master information, and in this guise will be
 * used by multiple objects on a container (SDO, viewer, browser); this gives a performance 
 * benefit because the information about an entity's contained objects is only ever cached once
 * per session, and can be reused by any object that needs to.
 *
 * Entities cached in this temp-table will be descendents of the Entity class.
 */
DEFINE TEMP-TABLE ttEntity            NO-UNDO
    FIELD EntityName            AS CHARACTER
    FIELD EntityTableName       AS CHARACTER
    FIELD EntityBufferHandle    AS HANDLE
    FIELD LanguageCode          AS CHARACTER 
    INDEX idxEntityName
        EntityName
        LanguageCode
    INDEX idxTableName        AS PRIMARY UNIQUE
        EntityTableName
    .

/* User, language, render type, run attribute implicit */
DEFINE TEMP-TABLE cacheObject       NO-UNDO
    FIELD ObjectName            AS CHARACTER
    FIELD InstanceId            AS DECIMAL
    FIELD ContainerInstanceId   AS DECIMAL
    FIELD ClassName             AS CHARACTER
    FIELD AttrOrdinals          AS CHARACTER    /* comma delimited */
    FIELD AttrValues            AS CHARACTER    /* chr(1) delimited */
    FIELD Order                 AS INTEGER
    FIELD PageNumber            AS INTEGER
    FIELD EventNames            AS CHARACTER    /* comma delimited */
    FIELD EventActions          AS CHARACTER    /* chr(1) delimited */
    /* Field for deciding whether to do translations or not. 
       This field is for temporary local use only.
     */
    FIELD ObjectTranslated      AS LOGICAL      INITIAL ?  
    /* Field for deciding whether to do security or not. 
       This field is for temporary local use only
       and is typically only used for Browsers.
     */
    FIELD ObjectSecured         AS LOGICAL      INITIAL ?
    INDEX idxContainerInstance
        ContainerInstanceId
        ObjectName
    INDEX idxInstance
        InstanceId
    INDEX idxPageObjects
        ContainerInstanceId
        PageNumber
    INDEX idxObjectOrder
        ContainerInstanceId
        Order
    .
       
DEFINE TEMP-TABLE cachePage      NO-UNDO
    FIELD InstanceId            AS DECIMAL
    FIELD PageNumber            AS INTEGER
    FIELD PageLabel             AS CHARACTER
    FIELD LayoutCode            AS CHARACTER
    FIELD SecurityToken         AS CHARACTER
    FIELD TOC                   AS CHARACTER    /* CSV list of instance names contained by this page. */
    FIELD PageReference         AS CHARACTER    /* unique reference; needed for applying customisation */
    INDEX idxContainerPage
        InstanceId
        PageNumber
    INDEX idxPageReference    AS UNIQUE
        InstanceId
        PageReference
    .

DEFINE TEMP-TABLE cacheLink         NO-UNDO
    FIELD InstanceId            AS DECIMAL
    FIELD SourceInstanceName    AS CHARACTER
    FIELD TargetInstanceName    AS CHARACTER  
    FIELD LinkName              AS CHARACTER
    FIELD SourcePage             AS INTEGER
    FIELD TargetPage            AS INTEGER
    INDEX idxMain
        InstanceId        
        SourceInstanceName
        TargetInstanceName
        LinkName
    INDEX idxSourcePage        
        InstanceId
        SourcePage
        LinkName
    INDEX idxTargetPage        
        InstanceId
        TargetPage
        LinkName        
    .
/* This temp table definiton is used by the getEntityFromCacheClient 
   and saveEntitiesToCacheClient API's in repository manager */   
DEFINE TEMP-TABLE ttEntityDump NO-UNDO
  FIELD tEntityName AS CHARACTER
  FIELD tFieldName  AS CHARACTER
  FIELD tDataType   AS CHARACTER
  FIELD tFormat     AS CHARACTER
  FIELD tLabel      AS CHARACTER
  FIELD tColLabel   AS CHARACTER
  FIELD tHelp       AS CHARACTER
  FIELD tInitial    AS CHARACTER
  INDEX idxMain 
    tEntityName
    tFieldName.
