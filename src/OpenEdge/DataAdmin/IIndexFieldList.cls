/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : list of indexfields for an index
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 17 2013
    Notes       : 
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.IIndexField from propath.
using OpenEdge.DataAdmin.Lang.Collections.IList. 
 
interface OpenEdge.DataAdmin.IIndexFieldList inherits IDataAdminCollection, IList:  
   
    /** Add the indexfield to the list  */
    method public logical Add(pfld as IIndexField).
    
 /** Removes the indexfield from the collection. Returns true if the removal was successful.
     Can only be performed if the indexfield is not saved. */
    method public logical Remove(pfld as IIndexField).
    
    /** Get the indexfield with the specified number from the list  */
    method public IIndexField Get(i as int).
   
    /* Returns the index in this list of the specified IIndexField */
    method public integer IndexOf(pfld as IIndexField). 
 
end interface.
