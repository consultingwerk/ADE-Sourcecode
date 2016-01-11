/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : prodict.pro._pro-sel-presenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Feb 21 00:10:09 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

using prodict.pro._imodel from propath.
using prodict.pro._iview from propath.
using prodict.pro._ipresenter from propath.
using prodict.misc._query from propath.

class prodict.pro._pro-presenter abstract implements _ipresenter: 
    
	define public event RowSelected  signature void ( ).
    
    define public property HelpId as integer no-undo 
        get. 
        set.
	
	define public property Title as char no-undo  
        get. 
        set.
    
    define public property Col as decimal no-undo init 1
        get. 
        set.
    
    define public property Row as decimal no-undo init 1
        get. 
        set.
          
    define protected property Model as _imodel no-undo get. set.	
    define protected property View as _iview no-undo get. set.
	
	define public property QueryString as character no-undo 
    	get.
    	set. 
    
    define public property DataView as _query no-undo 
        get.
        set. 
    
    define public property BindingHandle as handle no-undo 
        get.
        set. 
        	
	define variable mLastSort as character no-undo.
	
	constructor protected _pro-presenter ( ):
		super ().
	end constructor. 

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    method public void Selected():
        RowSelected:Publish().
    end method.    
    
    /* implement in subclass to create View and Model */ 
    method abstract protected void Create().
    
    method protected _query GetDataView():
        return Model:GetQuery(1).
    end method.
         
	method public void Init(  ): 
        this-object:Create().
        if QueryString > "" then
            Model:FetchData(QueryString).
        else
            Model:FetchData().
        DataView = GetDataView(). 
        DataView:Init(). 
        BindingHandle = DataView:QueryHandle.
        this-object:View:Init().	 
        return.
    end method.    
    
    method public logical Wait(  ): 
        Init().
        return this-object:View:Wait().
    end.
    
    method public char ValueList (pcColumns as char,pcFormat as char,pcDelimiter as char ):
        return DataView:ValueList(pccolumns,pcFormat,pcDelimiter).       
    end method.    
      
    method public char ColumnValue(pccolumn as char).
        return DataView:ColumnValue(pccolumn).  
    end method.
    
    method public void Sort(pcColumn as char).
        define variable cpos as character extent no-undo.
          /* @TODO sort should be moved to _query */
        if mLastSort = pcColumn then
        do:
            mLastSort = "".
            pcColumn = pccolumn + " descending".
        end.       
        else 
           mLastSort = pcColumn.
        
        cPos = DataView:GetPosition().
        DataView:QueryString = "for each " + DataView:Table + " by " + pcColumn + " indexed-reposition".
        DataView:OpenQuery().
        DataView:SetPosition(cPos).
        /* @TODO change to more generic data refresh event in View */
        this-object:View:ShowSort(pcColumn).
    end method.
    
    method public void ShowHelp( ):  
        if HelpId <> 0 then
            run "adecomm/_adehelp.p" ("admn", 
                                      "CONTEXT", 
                                      HelpId,
                                       ? ). 
    end method.    
         
    method public logical Position(pcWhere as char):  
        define variable hbuffer as handle no-undo.      
        return DataView:SetPosition(pcWhere).  
    end method.    

	/*------------------------------------------------------------------------------
			Purpose: Get rid of dependant objects 																	  
			Notes: As of current the View has a Presenter property that prevents GC 																	  
	------------------------------------------------------------------------------*/
	destructor public _pro-presenter ( ):
        delete object this-object:View no-error.
        delete object this-object:Model no-error.
	end destructor.
      
end class.