/* ***********************************************************/
/* Copyright (c) 2015-2016 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : ICdcFieldPolicy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Nov 20 12:36:24 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.IPartitionOwner.
using OpenEdge.DataAdmin.ICdcTablePolicy.
using OpenEdge.DataAdmin.IField.

interface OpenEdge.DataAdmin.ICdcFieldPolicy inherits IPartitionOwner:      
       
    define public property CdcTablePolicy as ICdcTablePolicy  no-undo  get. 
    
    define public property FieldPosition as int no-undo  get. 
    
    define public property FieldRecId as int no-undo  get.
    
    define public property Field as IField  no-undo  get. set.
    
    //define public property FieldName as char  no-undo  get.
    
    define public property CdcPolicyId as char no-undo  get.
    
    define public property CdcTablePolicyName as char no-undo  get.
    
    define public property IdentifyingField as integer  no-undo  get. set.   
    
    define public property Misc as char extent 16 no-undo  get.    
  
end interface.