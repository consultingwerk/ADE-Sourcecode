/*************************************************************/
/* Copyright (c) 2013,2019 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : Interface for indexField ()
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jun 29  
    Notes       : 
  ----------------------------------------------------------------------*/
 
using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IField from propath. 
using OpenEdge.DataAdmin.IIndex from propath.

interface OpenEdge.DataAdmin.IIndexField inherits IDataAdminElement:
    /** Parent table of the index */
    define public property Index         as IIndex    no-undo get. 
    define public property Field         as IField no-undo get. 
    define public property Number        as int no-undo get. 
    define public property IsAscending   as logical   no-undo get.  
    define public property IsAbbreviate  as logical   no-undo get.  
     
end interface.
