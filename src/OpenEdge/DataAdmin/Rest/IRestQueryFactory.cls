/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : returns named queires as pagerequests  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Aug 06 19:32:20 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IRequestInfo.
using OpenEdge.DataAdmin.Rest.PageRequest.
using OpenEdge.DataAdmin.Rest.IPageRequest.
interface OpenEdge.DataAdmin.Rest.IRestQueryFactory:  
    /* returns null if not named */
    method public IPageRequest GetNamedRequest(pcCollection as char).
    /* return named or default if no named found */
    method public IPageRequest GetRequest(pcCollection as char).
end interface.