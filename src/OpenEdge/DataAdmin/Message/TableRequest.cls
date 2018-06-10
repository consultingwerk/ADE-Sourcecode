 /*************************************************************/
  /* Copyright (c) 2011 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    Purpose     : table request  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Jul 26 14:12:18 EDT 2011
    Notes       : Passive read-only - 
                  Used o n server side to pass properties to the datasource
                  As of current this is not intended used on a client 
                  to set properties of the request before execution. 
                  The FetchRequest has setters with table name to 
                  do that.
                - It should be easy to implement if needed for the case that 
                  recieves the buffer in the constructor. 
                    Store the buffer and fix the setters to assign the 
                    field.
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Message.ITableRequest from propath.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.Message.TableRequest implements ITableRequest: 
    define public property Name   as char no-undo get. private set.
    define public property SearchString as char no-undo get. set.
    
    /** The number of records to return per page or batch */
    define public property PageSize as integer no-undo get. set.
                     
    define public property KeyField as char no-undo get. set.
    define public property KeyValue as char no-undo get. set.
	define public property Lazy     as logical no-undo get. set.
	define public property Start as int no-undo get. set.
	
    define public property QueryString as char no-undo 
       get():
           /* ensure datasources not prepared for keyfield and keyvalue can work also 
              when only keyfield and keyvalue is passed from client */
           
          if (QueryString = "" or QueryString = ?) and KeyField > "" and KeyValue > "" then  
              return subst("for each &1 where &1.&2 = &3",Name,KeyField,quoter(KeyValue)).
          
          return QueryString.
          
       end.     
       set.
	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
		
	constructor public TableRequest (h as handle  ):
		super ().	
		assign
		    Name             = h::TableName
            QueryString      = h::QueryString
            SearchString     = h::SearchString
            PageSize         = h::PageSize
            KeyValue         = h::KeyValue
			KeyField         = h::KeyField
            Lazy             = h::Lazy
            Start            = h::Start.
	
	end constructor.
    
    /* for single row request from client */
    constructor public TableRequest (pTable as char, pField as char, pValue as char,pLazy as logical):
        super ().   
        assign
            Name             = pTable
            KeyValue         = pValue
            KeyField         = pField
            Lazy             = pLazy.        
    end constructor.


end class.