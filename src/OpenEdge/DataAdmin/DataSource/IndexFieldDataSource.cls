/*************************************************************/
 /* Copyright (c) 2013 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : IndexDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : July 2013
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataSource.DataSource.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.IndexFieldDataSource inherits DataSource: 
    define protected variable mBuffer as handle no-undo.
    define protected variable mDBRecid as recid no-undo.
 	define private variable mMapping as char
	   init  	   
"IndexName,_Index._Index-name,~
TableName,_File._File-Name,~
FieldName,_Field._Field-Name,~
DataType,_Field._Data-Type,~
Description,_Field._Desc,~
trowid,rowid(_Index-Field),~
Number,_Index-seq,~
IsAbbreviate,_Abbreviate,~
IsAscending,_Ascending"
 no-undo.
    
    /*  The most common access is from _file (it's not common to request this for all indexes ignoring the file) */
	constructor public IndexFieldDataSource ( ):	    
		super ("_File,_Index,_Index-Field,_Field","dictdb._File,dictdb._Index,dictdb._Index-Field,dictdb._Field", mMapping).	
		BaseQuery = "for each _file where " + DatabaseInfo:FileExpression  +  " no-lock, each _index of _file no-lock, each _index-field of _index no-lock, first _Field of _index-field no-lock".
    end constructor.
    
    method public override logical Prepare(phBuffer as handle,pcTargetQuery as char,pcJoin as char):
        phBuffer:set-callback("After-Row-fill","AfterIndexFieldRow").
        super:Prepare(phBuffer,pcTargetQuery,pcJoin).
        mBuffer = phBuffer.
    end method.
    
    method public void AfterIndexFieldRow(dataset-handle hds):
    end method.
    
end class.