&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*---------------------------------------------------------------------------------
  File: ryrepmngrp.i

  Description:  Astra Repository Manager Code

  Purpose:      The Astra Repository Manager is a standard procedure encapsulating all
                Repository based access for the building of dynamic objects in the Astra
                environment. Examples include the retrieval of object attribute values,
                reading of toolbar bands and actions, etc.
                This include file contains the common code for both the server and client
                repository manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   02/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        5929   UserRef:    
                Date:   05/06/2000  Author:     Robin Roos

  Update Notes: Implement Repository Cache for Dynamic Objects

  (v:010002)    Task:        6030   UserRef:    
                Date:   15/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

  (v:010003)    Task:        6063   UserRef:    
                Date:   15/06/2000  Author:     Anthony Swindells

  Update Notes: Implement toolbar menus

  (v:010004)    Task:        6146   UserRef:    
                Date:   25/06/2000  Author:     Robin Roos

  Update Notes: Implement local attributes for dynamic containers

  (v:010006)    Task:        6205   UserRef:    
                Date:   30/06/2000  Author:     Robin Roos

  Update Notes: Dynamic Viewer

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   01/05/2001  Author:     Phil Magnay

  Update Notes: Logic changes for new security allocation method

---------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrepmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&global-define astraRepositoryManager  yes

{af/sup2/afglobals.i} /* Astra global shared variables */

/* Temp-Tables of bands/actions from repository to output to caller. These tables will always only
   pass back the selected bands / actions
*/
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}

/* include temp-table definitions */
{ry/app/rycsofetch.i}

DEFINE TEMP-TABLE tt_object_cache NO-UNDO
    FIELD logical_object_name   AS CHARACTER
    FIELD object_instance_obj   AS DECIMAL
    FIELD local_attributes      AS CHARACTER
    INDEX lon IS PRIMARY UNIQUE
        logical_object_name
        object_instance_obj
    .

DEFINE TEMP-TABLE tt_object_name NO-UNDO
    FIELD object_name       AS CHARACTER
    FIELD physical_name     AS CHARACTER
    FIELD logical_name      AS CHARACTER
    FIELD custom_super_procedure    AS CHARACTER
    INDEX primidx IS PRIMARY UNIQUE 
        OBJECT_name
    .

DEFINE TEMP-TABLE cache_object_instance NO-UNDO LIKE tt_object_instance.
DEFINE TEMP-TABLE cache_page            NO-UNDO LIKE tt_page.
DEFINE TEMP-TABLE cache_page_instance   NO-UNDO LIKE tt_page_instance.
DEFINE TEMP-TABLE cache_link            NO-UNDO LIKE tt_link.
DEFINE TEMP-TABLE cacheAttributeValue   NO-UNDO LIKE ttAttributeValue.
DEFINE TEMP-TABLE cacheUiEvent          NO-UNDO LIKE ttUiEvent.

DEFINE TEMP-TABLE ttUser NO-UNDO LIKE gsm_user.

{af/app/afttsecurityctrl.i}

/* temp-table for translations */
{af/app/aftttranslate.i}


DEFINE VARIABLE lSecurityRestricted             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE gcDateFormatMask                AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-FormatAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FormatAttributeValue Procedure 
FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA          AS CHARACTER,
      INPUT pcAttributeValue            AS CHARACTER    )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.19
         WIDTH              = 53.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm/method/attribut.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

&IF DEFINED(server-side) <> 0 &THEN
    {ry/app/rymenufunc.i}
    PROCEDURE rycsonamep:         {ry/app/rycsonamep.p}     END PROCEDURE.
    PROCEDURE rygetmensp:         {ry/app/rygetmensp.p}     END PROCEDURE.
    PROCEDURE rygetitemp:         {ry/app/rygetitemp.p}     END PROCEDURE.
&ENDIF


/* Get the date format mask. We use this in FormatAttributeValue.
 * Default to 99/99/9999                                         */
ASSIGN gcDateFormatMask = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                           INPUT "DateFormat":U,
                                           INPUT YES).
IF gcDateFormatMask EQ ? OR gcDateFormatMask EQ "":U THEN
    ASSIGN gcDateFormatMask = "99/99/9999":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-clearClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearClientCache Procedure 
PROCEDURE clearClientCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               repository maintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               repository data settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
    /*   EMPTY TEMP-TABLE ttUserSecurityCheck. */
        EMPTY TEMP-TABLE cache_object_instance.
        EMPTY TEMP-TABLE cache_page.
        EMPTY TEMP-TABLE cache_page_instance.
        EMPTY TEMP-TABLE cache_link.
        EMPTY TEMP-TABLE cacheAttributeValue.
        EMPTY TEMP-TABLE cacheUiEvent.

        EMPTY TEMP-TABLE tt_object_cache.
        EMPTY TEMP-TABLE tt_object_name.
    END.    /* runnign client side. */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ClearObjectCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearObjectCache Procedure 
PROCEDURE ClearObjectCache :
/*------------------------------------------------------------------------------
  Purpose:     Clears the object cache for one logical obejct.
  Parameters:  pcLogicalObjectName - 
  Notes:       * this procedure is used when a re-read from the Repository is
                 needed for one logical object only.
               * this procedure recursively clears the cache for container objects.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcLogicalObjectName      AS CHARACTER        NO-UNDO.

    DEFINE BUFFER cache_object_instance     FOR cache_object_instance.
    DEFINE BUFFER cache_page                FOR cache_page.
    DEFINE BUFFER cache_page_instance       FOR cache_page_instance.
    DEFINE BUFFER cache_link                FOR cache_link.
    DEFINE BUFFER cacheAttributeValue       FOR cacheAttributeValue.
    DEFINE BUFFER cacheUiEvent              FOR cacheUiEvent.
    DEFINE BUFFER tt_object_cache           FOR tt_object_cache.
    DEFINE BUFFER tt_object_name            FOR tt_object_name.

    IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
        FOR EACH cache_object_instance WHERE cache_object_instance.logical_object_name = pcLogicalObjectName:
            /* If the object instance is a container, then clear the cache for all contained instances,
             * being careful to avoid going into an infinite loop.                                      */
            IF cache_object_instance.instance_is_a_container                                           AND 
               cache_object_instance.instance_object_name NE cache_object_instance.logical_object_name THEN            
                RUN ClearObjectCache ( INPUT cache_object_instance.instance_object_name).

            DELETE cache_object_instance.
        END.    /* Object Instances */

        FOR EACH cache_page WHERE cache_page.logical_object_name = pcLogicalObjectName:   
            DELETE cache_page.
        END.    /* Pages */

        FOR EACH cache_page_instance WHERE cache_page_instance.logical_object_name = pcLogicalObjectName:
            DELETE cache_page_instance.
        END.    /* Page instances */

        FOR EACH cache_link WHERE cache_link.logical_object_name = pcLogicalObjectName:
            DELETE cache_link.
        END.    /* Links */

        FOR EACH cacheAttributeValue WHERE cacheAttributeValue.ContainerLogicalObject = pcLogicalObjectName:
            DELETE cacheAttributeValue.
        END.    /* Attribute Values */

        FOR EACH cacheUiEvent WHERE cacheUiEvent.ContainerLogicalObject = pcLogicalObjectName:
            DELETE cacheUiEvent.
        END.    /* UI events */

        FOR EACH tt_object_cache WHERE tt_object_cache.logical_object_name = pcLogicalObjectName:
            DELETE tt_object_cache.
        END.    /* object cache */

        FOR EACH tt_object_name WHERE tt_object_name.object_name = pcLogicalObjectName:
            DELETE tt_object_name.
        END.    /* object name */
    END.    /* running client side. */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getActions Procedure 
PROCEDURE getActions :
DEFINE INPUT PARAMETER pcCategoryList          AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcActionList            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

DEFINE VARIABLE dUserObj                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj                AS DECIMAL    NO-UNDO.


/* get the current user and organisation */
dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO)) NO-ERROR.
dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentOrganisationObj":U,
                                                     INPUT NO)) NO-ERROR.

&IF DEFINED(server-side) <> 0 &THEN
  RUN rygetitemp (INPUT pcCategoryList,
                  INPUT pcActionList,
                  INPUT dUserObj,
                  INPUT dOrganisationObj,
                  OUTPUT TABLE ttAction,
                  OUTPUT TABLE ttCategory).  
&ELSE
  RUN ry/app/rygetitemp.p ON gshAstraAppserver 
                 (INPUT pcCategoryList,
                  INPUT pcActionList,
                  INPUT dUserObj,
                  INPUT dOrganisationObj,
                  OUTPUT TABLE ttAction,
                  OUTPUT TABLE ttCategory).
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectAttributes Procedure 
PROCEDURE getObjectAttributes :
/*------------------------------------------------------------------------------
  Purpose:     To return temp-tables for selected object attributes.
  Parameters:  input logical object name
               output temp-table for object instance attributes
               output temp-table for pages
               output temp-table for page instances
               output temp-table for links
               output temp-table for attribute values
               output temp-table for UI events
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcLogicalObjectName     AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_object_instance.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_page.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_page_instance.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_link.
    DEFINE OUTPUT PARAMETER TABLE FOR ttAttributeValue.
    DEFINE OUTPUT PARAMETER TABLE FOR ttUiEvent.

    DEFINE VARIABLE hBuffer                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hTableHandle            AS HANDLE                   NO-UNDO.

    /* This cannot be included - it must be run as a separate 
     * procedure because it has internal procedures.          */
    IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
        ASSIGN hBuffer      = TEMP-TABLE tt_object_cache:HANDLE
               hTableHandle = ?
               .
        RUN ry/app/rycsofetch.p ( INPUT  pcLogicalObjectName,
                                  INPUT  hBuffer,
                                  INPUT  TABLE-HANDLE hTableHandle,
                                  OUTPUT TABLE tt_object_instance,
                                  OUTPUT TABLE tt_page,
                                  OUTPUT TABLE tt_page_instance,
                                  OUTPUT TABLE tt_link,
                                  OUTPUT TABLE ttAttributeValue,
                                  OUTPUT TABLE ttUiEvent         ).
    END.
    ELSE
    DO:
        /* Is the required object in the cache? */
        /* Always get container (i.e object instance is zero) */
        IF NOT CAN-FIND(FIRST tt_object_cache WHERE
                              tt_object_cache.logical_object_name = pcLogicalObjectName AND
                              tt_object_cache.object_instance_obj = 0                       ) THEN
        DO:
            /* Only pass the table (table handle) around when actually passing off to A/S */
            IF gshAstraAppServer EQ SESSION:HANDLE THEN
                ASSIGN hBuffer      = TEMP-TABLE tt_object_cache:HANDLE
                       hTableHandle = ?
                       .
            ELSE
                ASSIGN hBuffer      = ?
                       hTableHandle = TEMP-TABLE tt_object_cache:HANDLE
                       .
            RUN ry/app/rycsofetch.p ON gshAstraAppserver ( INPUT  pcLogicalObjectName,
                                                           INPUT  hBuffer,
                                                           INPUT  TABLE-HANDLE hTableHandle,
                                                           OUTPUT TABLE cache_object_instance APPEND,
                                                           OUTPUT TABLE cache_page            APPEND,
                                                           OUTPUT TABLE cache_page_instance   APPEND,
                                                           OUTPUT TABLE cache_link            APPEND,
                                                           OUTPUT TABLE cacheAttributeValue   APPEND,
                                                           OUTPUT TABLE cacheUiEvent          APPEND ).

            /* We need to make sure that all the containing smartObjects within this smartObject
             * also appear visible to the cache.                                                   */
            FOR EACH cache_object_instance WHERE
                     cache_object_instance.object_instance_obj = 0 AND
                     NOT CAN-FIND(FIRST tt_object_cache WHERE
                                        tt_object_cache.object_instance_obj = cache_object_instance.object_instance_obj AND
                                        tt_object_cache.logical_object_name = cache_object_instance.instance_object_name    )
                     :
                CREATE tt_object_cache.
                ASSIGN tt_object_cache.logical_object_name = cache_object_instance.instance_object_name
                       tt_object_cache.object_instance_obj = cache_object_instance.object_instance_obj
                       .
            END.    /* all instances */
        END.    /* not cached yet */

        EMPTY TEMP-TABLE tt_object_instance.
        EMPTY TEMP-TABLE tt_page.
        EMPTY TEMP-TABLE tt_page_instance.
        EMPTY TEMP-TABLE tt_link.
        EMPTY TEMP-TABLE ttAttributeValue.
        EMPTY TEMP-TABLE ttUiEvent.

        FOR EACH cache_object_instance WHERE
                 cache_object_instance.logical_object_name = pcLogicalObjectName :
            CREATE tt_object_instance.
            BUFFER-COPY cache_object_instance TO tt_object_instance.
        END.    /* Object Instances */

        FOR EACH cache_page WHERE cache_page.logical_object_name = pcLogicalObjectName:   
            CREATE tt_page.
            BUFFER-COPY cache_page TO tt_page.
        END.    /* Pages */

        FOR EACH cache_page_instance WHERE cache_page_instance.logical_object_name = pcLogicalObjectName:
            CREATE tt_page_instance.
            BUFFER-COPY cache_page_instance TO tt_page_instance.
        END.    /* Paeg instances */

        FOR EACH cache_link WHERE cache_link.logical_object_name = pcLogicalObjectName:
            CREATE tt_link.
            BUFFER-COPY cache_link TO tt_link.
        END.    /* Links */

        FOR EACH cacheAttributeValue WHERE cacheAttributeValue.ContainerLogicalObject = pcLogicalObjectName:
            CREATE ttAttributeValue.
            BUFFER-COPY cacheAttributeValue TO ttAttributeValue.
        END.    /* Attribute Values */

        FOR EACH cacheUiEvent WHERE cacheUiEvent.ContainerLogicalObject = pcLogicalObjectName:
            CREATE ttUiEvent.
            BUFFER-COPY cacheUiEvent TO ttUiEvent.
        END.    /* UI events */
    END.    /* client side */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectNames Procedure 
PROCEDURE getObjectNames :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcPhysicalName          AS CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcLogicalName           AS CHARACTER        NO-UNDO.

    DEFINE VAR cSuperProcedureName          AS CHARACTER                NO-UNDO.

    IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
        RUN rycsonamep (
            INPUT  pcObjectName,
            OUTPUT pcPhysicalName,
            OUTPUT pcLogicalName ,
            OUTPUT cSuperProcedureName ).
    END.
    ELSE DO:
        /* is the required object in the cache? */

        FIND FIRST tt_object_name 
            WHERE tt_object_name.object_name = pcObjectName
            NO-ERROR.

        IF NOT AVAILABLE tt_object_name THEN
        DO:   
            /* not in cache - fetch it from the server */
            RUN ry/app/rycsonamep.p ON gshAstraAppserver ( INPUT  pcObjectName,
                                                           OUTPUT pcPhysicalName,
                                                           OUTPUT pcLogicalName ,
                                                           OUTPUT cSuperProcedureName ).

            CREATE tt_object_name.
            ASSIGN
                tt_object_name.object_name = pcObjectName
                tt_object_name.physical_name = pcPhysicalName
                tt_object_name.logical_name = pcLogicalName
                tt_object_name.custom_super_procedure = cSuperProcedureName
                .
        END.
        ELSE
            ASSIGN pcPhysicalName       = tt_object_name.physical_name
                   pcLogicalName        = tt_object_name.logical_name                   
                   .
    END.    /* running local */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectSuperProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getObjectSuperProcedure Procedure 
PROCEDURE getObjectSuperProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Returns an objects custom super procedure to a caller.
  Parameters:  pcObjectName      - the object name 
               pcCustomSuperProc - the name of the cusstom super procedure
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName        AS CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER pcCustomSuperProc   AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE cObjectName             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cPhysicalName           AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cLogicalName            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cObjectExtension        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iSlashPosition          AS INTEGER                  NO-UNDO.

    /* Remove the path, if any. This is to cater for the fact that
     * a (relatively or fully) pathed physical object name may be
     * passed in.                                                */
    ASSIGN iSlashPosition = R-INDEX(pcObjectName, "/":U) + 1.

    IF iSlashPosition GT 0 THEN
        ASSIGN pcObjectName     = SUBSTRING(pcObjectName, iSlashPosition)
               cObjectExtension = ENTRY(NUM-ENTRIES(pcObjectName, ".":U), pcObjectName, ".":U)
               pcObjectName     = REPLACE(pcObjectName, (".":U + cObjectExtension), "":U)
               .
    IF (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
    DO:
        RUN rycsonamep ( INPUT  pcObjectName,
                         OUTPUT cPhysicalName,
                         OUTPUT cLogicalName,
                         OUTPUT pcCustomSuperProc ).
    END.    /* remote session */
    ELSE
    DO:
        /* find the object in the cache. */
        FIND FIRST tt_object_name WHERE
                   tt_object_name.object_name = pcObjectName
                   NO-ERROR.
        IF AVAILABLE tt_object_name THEN
            ASSIGN pcCustomSuperProc = tt_object_name.custom_super_procedure.
        ELSE
        DO:        
            /*  This also adds the object to the cache. */
            RUN getObjectNames ( INPUT  pcObjectName,
                                 OUTPUT cPhysicalName,
                                 OUTPUT cLogicalName   ).
            FIND FIRST tt_object_name WHERE
                       tt_object_name.object_name = pcObjectName
                       NO-ERROR.
            IF AVAILABLE tt_object_name THEN
                ASSIGN pcCustomSuperProc = tt_object_name.custom_super_procedure.
        END.    /* */
    END.    /* local session */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getToolbarBandActions Procedure 
PROCEDURE getToolbarBandActions :
/*------------------------------------------------------------------------------
  Purpose:     To return temp-tables of selected bands / actions to caller.
  Parameters:  input comma delimited list of band names
               output temp-table of bands selcted
               output temp-table of actions selected.
  Notes:       These band actions are not cached into a temp-table here as
               they are cached in the toolbar super procedure
               toolbarcustom.p for the current session anyway.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pcToolbar               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectList            AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcBandList              AS CHARACTER  NO-UNDO.

DEFINE OUTPUT PARAMETER TABLE FOR ttToolbarBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttObjectBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBand.
DEFINE OUTPUT PARAMETER TABLE FOR ttBandAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttAction.
DEFINE OUTPUT PARAMETER TABLE FOR ttCategory.

DEFINE VARIABLE dUserObj                        AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dOrganisationObj                AS DECIMAL    NO-UNDO.

/* get the current user and organisation */
dUserObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO)) NO-ERROR.
dOrganisationObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentOrganisationObj":U,
                                                     INPUT NO)) NO-ERROR.

&IF DEFINED(server-side) <> 0 &THEN
  RUN rygetmensp (INPUT pcToolbar,
                  INPUT pcObjectList,
                  INPUT pcBandList, 
                  INPUT dUserObj,
                  INPUT dOrganisationObj,
                  OUTPUT TABLE ttToolbarBand,
                  OUTPUT TABLE ttObjectBand,
                  OUTPUT TABLE ttBand,
                  OUTPUT TABLE ttBandAction,
                  OUTPUT TABLE ttAction,
                  OUTPUT TABLE ttCategory).  
&ELSE
  RUN ry/app/rygetmensp.p ON gshAstraAppserver (INPUT pcToolbar,
                                                INPUT pcObjectList,
                                                INPUT pcBandList, 
                                                INPUT dUserObj,
                                                INPUT dOrganisationObj,
                                                OUTPUT TABLE ttToolbarBand,
                                                OUTPUT TABLE ttObjectBand,
                                                OUTPUT TABLE ttBand,
                                                OUTPUT TABLE ttBandAction,
                                                OUTPUT TABLE ttAction,
                                                OUTPUT TABLE ttCategory).
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-FormatAttributeValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FormatAttributeValue Procedure 
FUNCTION FormatAttributeValue RETURNS CHARACTER
    ( INPUT pcAttributeTypeTLA          AS CHARACTER,
      INPUT pcAttributeValue            AS CHARACTER    ) :
/*------------------------------------------------------------------------------
  Purpose:  Ensures that decimal attribute values have the correct numeric decimal
    Notes:  * DECimal attribute values have a CHR(1) as the decimal point in the
              Repository, which is enforced by the write trigger. This needs to
              be converted to a meaningful decimal point.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAttributeValue         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE tAttributeValue         AS DATE                     NO-UNDO.
    DEFINE VARIABLE iAttributeValue         AS INTEGER                  NO-UNDO.

    /* Convert decimal attribute values to 'proper' numbers. */
    CASE pcAttributeTypeTLA:
        WHEN "DEC":U THEN
            ASSIGN cAttributeValue = REPLACE(pcAttributeValue, ".":U, SESSION:NUMERIC-DECIMAL-POINT).
        WHEN "DAT":U THEN
        DO:
            /* Dates are stored in integer format */
            ASSIGN iAttributeValue = INTEGER(pcAttributeValue) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
                ASSIGN cAttributeValue = pcAttributeValue.
            ELSE
                ASSIGN tAttributeValue = DATE(iAttributeValue)
                       cAttributeValue = STRING(tAttributeValue, gcDateFormatMask)
                       .
        END.    /* DAT */
        OTHERWISE
            ASSIGN cAttributeValue = pcAttributeValue.
    END CASE.   /* attribute type TLA */

    RETURN cAttributeValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

