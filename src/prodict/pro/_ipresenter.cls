/*************************************************************/
/* Copyright (c) 2011 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : _presenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface prodict.pro._ipresenter: 
    
	define public event RowSelected  signature void ( ).

	/*------------------------------------------------------------------------------
			Purpose:  																	  
			Notes:  																	  
	------------------------------------------------------------------------------*/
    define public property Title as char no-undo get. set.
    define public property Col as decimal no-undo get. set.
    define public property Row as decimal no-undo get. set.
    define public property HelpId as integer no-undo get. set.
    define public property QueryString as character no-undo get. set. 
    define public property BindingHandle as handle no-undo get. set. 
    
    method public void Selected().     
    method public void Init( ).    
    method public logical Wait( ).    
    method public void ShowHelp( ).    
   
    method public logical Position(pcWhere as char).  
    method public void Sort(pcColumn as char).  
    
    method public char ColumnValue(pccolumn as char).  
    
       
end interface.