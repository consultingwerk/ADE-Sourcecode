/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
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
    field Name               as character format "x(24)" label "name" serialize-hidden  
    field FileName           as character format "x(24)" label "FileName" serialize-name "fileName"
    field UseDefaultLocation as logical  init true serialize-name "useDefaultLocation"
    field NoLobs             as logical   serialize-name "noLobs"
    field Directory          as character   serialize-name "directory"
    field TenantDirectory    as character   serialize-name "tenantDirectory"
    field LobDirectory       as character   serialize-name "lobDirectory"
    field TenantLobDirectory as character   serialize-name "tenantLobDirectory"
    field CodePage           as character serialize-name "codePage"
    field NoMap              as logical      serialize-name "noMap"
    field CharacterMap       as character      serialize-name "characterMap"
    /* all,multitenant,shared,list,one*/
    field TableSelection     as character      serialize-name "tableSelection" 
    /* all,list,one*/
    field TenantSelection    as character      serialize-name "tenantSelection" 
    /* all,multitenant,shared*/
    field SequenceSelection  as character      serialize-name "sequenceSelection" 
 
    
/*    {daschema/entity.i}*/
    index idxtask as primary unique Name  . 
 