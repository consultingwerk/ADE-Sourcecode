 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _imodel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using prodict.misc._query from propath.

interface prodict.pro._imodel: 
    define public property EntityName as character no-undo get. set.
    method public void FetchData(). 
    method public void FetchData(pcQuery as character). 
    method public void FetchData(pcTable as char extent,pcQuery as character extent). 
    method public _query GetQuery(pcTable as char).
    method public _query GetQuery(i as int).
end interface.