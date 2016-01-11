&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE tt_object_instance    NO-UNDO
    FIELD object_instance_obj       AS DECIMAL          /* 0 record for container and master details */
    FIELD object_pathed_filename    AS CHARACTER
    FIELD object_instance_handle    AS HANDLE
    FIELD object_frame_handle       AS HANDLE
    FIELD object_type_code          AS CHARACTER
    FIELD db_aware                  AS LOGICAL
    FIELD instance_attribute_list   AS CHARACTER
    FIELD layout_position           AS CHARACTER
    FIELD logical_object_name       AS CHARACTER        /* This is the container logical object name */
    FIELD custom_super_procedure    AS CHARACTER
    FIELD custom_super_handle       AS HANDLE 
    FIELD destroy_custom_super      AS LOGICAL  
    FIELD instance_order            AS INTEGER
    FIELD page_number               AS INTEGER

    /* Any object which contains object instances will be a container.
     * So the dynamic container is a container; the dynamic viewer
     * is also a container.                                           */
    FIELD instance_is_a_container   AS LOGICAL          INITIAL NO
    FIELD instance_object_name      AS CHARACTER        /* The ryc_smartObject object filename of the contained instance. 
                                                         * This is used when the object is a container object             */
    INDEX lon IS PRIMARY
        logical_object_name
        object_instance_obj
    INDEX key2 object_instance_obj
    INDEX key3 object_type_code layout_position
    INDEX key4 PAGE_number instance_order
    INDEX key5 destroy_custom_super
    INDEX idxContainer
        instance_is_a_container
    .

DEFINE TEMP-TABLE tt_page               NO-UNDO
    FIELD page_number               AS INTEGER
    FIELD page_label                AS CHARACTER
    FIELD logical_object_name       AS CHARACTER
    FIELD layout_code               AS CHARACTER
    FIELD page_initialized          AS LOGICAL INITIAL NO
    INDEX lon IS PRIMARY LOGICAL_object_name
    INDEX key2 page_number.    

DEFINE TEMP-TABLE tt_page_instance      NO-UNDO
    FIELD page_number               AS INTEGER
    FIELD object_instance_obj       AS DECIMAL
    FIELD OBJECT_instance_handle    AS HANDLE
    FIELD OBJECT_type_code          AS CHARACTER
    FIELD layout_position           AS CHARACTER
    FIELD logical_object_name       AS CHARACTER
    INDEX lon IS PRIMARY LOGICAL_object_name
    INDEX key2 page_number    
    INDEX key3 object_instance_obj.    

DEFINE TEMP-TABLE tt_link               NO-UNDO
    FIELD source_object_instance_obj AS DECIMAL
    FIELD target_object_instance_obj AS DECIMAL
    FIELD link_name                  AS CHARACTER
    FIELD logical_object_name        AS CHARACTER
    FIELD link_created               AS LOGICAL INITIAL NO
    INDEX lon IS PRIMARY LOGICAL_object_name
    INDEX key2 link_created.

DEFINE TEMP-TABLE ttAttributeValue      NO-UNDO
    FIELD ContainerLogicalObject    AS CHARACTER
    FIELD ObjectInstanceObj         AS DECIMAL
    FIELD AttributeGroup            AS CHARACTER
    FIELD AttributeType             AS CHARACTER
    FIELD AttributeLabel            AS CHARACTER
    FIELD AttributeValue            AS CHARACTER
    INDEX idxMain           AS PRIMARY  /* Use to find instances of an object. */
        ObjectInstanceObj
        AttributeLabel
    INDEX idxAttributeGroup
        ObjectInstanceObj
        AttributeGroup
        AttributeLabel
    .

DEFINE TEMP-TABLE ttUiEvent         NO-UNDO
    FIELD ContainerLogicalObject        AS CHARACTER
    FIELD ObjectInstanceObj             AS DECIMAL
    FIELD EventName                     AS CHARACTER
    FIELD ActionType                    AS CHARACTER
    FIELD ActionTarget                  AS CHARACTER
    FIELD EventAction                   AS CHARACTER
    FIELD EventParameter                AS CHARACTER
    FIELD EventDisabled                 AS LOGICAL
    INDEX idxMain           AS PRIMARY  /* Use to find instances of an object. */
        ObjectInstanceObj        
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


