/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : IStreamFieldHandler
    Purpose     : Used to extends context to generate code for complex/challenging fields that need 
                  context info 
                  Implemented as separate interface mainly because it is needed by very few context classes 
                  (This deals with the fact that the CodeWriter is not the actual visitor, but
                   delegates the visiting to the ContextTree and works on the dataset, handles returned from the 
                   ContextTree) 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Nov 11 19:26:19 EST 2013
    Notes       : Used from CodeWriter to optionally let the context write some fields. 
                  The writer exports all fields not returned from WriteFieldAssignments or StatementFieldNames 
                  if serialize-hidden = false.     
  ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.*.

interface OpenEdge.DataAdmin.Binding.IStreamFieldHandler:
    /* Returns list of fields that need to be exported as separate statements
       This allows the writer to check what to skip from the assign statement 
       (The assumption is that the general assign statement is above the )  */
	define public property StatementFieldNames as character no-undo 
	get.
 

    /* writes field assignments - returns list of field exported so the generator knows what to skip
     . returns blank if no fields written - 
     @param stream handle
     @param name for variable
     @param at position  ? = no pos and no line break 
     @param buffer with current row avail */  
    method public char WriteFieldAssignments(pstream as handle,pcname as char,piAt as int,pbuf as handle).
   
    /* writes field assign statements for cases that cannot be used in assign 
     - StatementFieldNames must return the corresponding list   
      @param stream handle
      @param  name for variable
      @param buffer with current row avail */  
     
    method public void WriteFieldStatements(pstream as handle,pcname as char,pbuf as handle).
    
end interface.