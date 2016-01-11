/*************************************************************/
/* Copyright (c) 2011-2012 by progress Software Corporation  */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : utilityoptions.i
    Purpose     : import/export (dump/load) options passed to datadmin 
                  utilities 
    Description : 

    Author(s)   : hdaniels
    Created     : Oct 2011
    Notes       :
  ----------------------------------------------------------------------*/

define protected temp-table ttUtilityOptions no-undo serialize-name "utilityOptions" {1}
    field Name                      as character label "name" serialize-hidden  
    field FileName                  as character label "FileName" serialize-name "fileName"
    field UseDefaultLocation        as logical   serialize-name "useDefaultLocation" init true  
    field NoLobs                    as logical   serialize-name "noLobs"
    field Directory                 as character serialize-name "directory"
    field TenantDirectory           as character serialize-name "tenantDirectory"
    field LobDirectory              as character serialize-name "lobDirectory" init "lobs"
    field TenantLobDirectory        as character serialize-name "tenantLobDirectory"
    field GroupDirectory            as character serialize-name "groupDirectory" init "groups"
    field GroupLobDirectory         as character serialize-name "groupLobDirectory"
    field CodePage                  as character serialize-name "codePage"
    field NoMap                     as logical   serialize-name "noMap"
    field AcceptableErrorPercentage as int       serialize-name "acceptableErrorPercentage"    
    field CharacterMap              as character serialize-name "characterMap"
    /* all,tenant,shared,list*/
    field TableSelection            as character serialize-name "tableSelection" init "all"
    /* all,list*/
    field TenantSelection           as character serialize-name "tenantSelection" init "all"
    /* all,tenant,shared*/
    field SequenceSelection         as character serialize-name "sequenceSelection" init "all"
    field GroupSelection            as character serialize-name "groupSelection" init "all"
    field UseGroupSelection         as logical   serialize-name "useGroupSelection"
    field SkipGroups                as logical   serialize-name "skipGroups"
    field SkipSecuredTables         as logical   serialize-name "skipSecuredTables"
    field SkipCodePageValidation    as logical   serialize-name "SkipCodePageValidation"
    field IgnoreMissingDirectories  as logical   serialize-name "ignoreMissingDirectories"
    field IgnoreMissingFiles        as logical   serialize-name "ignoreMissingFiles"
    field OverwriteFiles            as logical   serialize-name "overwriteFiles"
    field LogStatus                 as logical   serialize-hidden  
    field LogType                   as character serialize-hidden /* not in use */
    field TaskName                  as character serialize-hidden  
    field ValidateOnly              as logical   serialize-hidden  
    field StatusFileName            as character serialize-hidden   
    field StatusInterval            as integer   serialize-hidden init 3000 
/*    {daschema/entity.i}*/
    index idxtask as primary unique Name  . 
 