/*************************************************************/
/* Copyright (c) 2013 by progress Software Corporation.      */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
/*------------------------------------------------------------------------
    Purpose     : data source for field as child of index-field
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Jul 2013
    Notes       : extended to have _field first. 
                  (probably not important at all performance wise...)
----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.DataSource.FieldDataSource.
routine-level on error undo, throw.

class OpenEdge.DataAdmin.DataSource.FieldChildDataSource inherits FieldDataSource: 

    define variable mreplaced as logical no-undo.

     /* child of index - this is already filtered by parent so DatabaseInfo:FileExpression is not really necessary   */
    constructor public FieldChildDataSource ():
        super ("_Field,_File","dictdb._Field,dictdb._File",GetMappingHack()).  
        BaseQueryTemplate = "for each _field&1no-lock, each _file of _field where " + DatabaseInfo:FileExpression  +  " no-lock".
    end constructor.

    /* The dataset gives error if the paret join is mapped across multiple source tables when 
       this is a child relation, because the fill-string generation requires that all fields in the parent  
       relation is mapped to the source, so temporarily map the Tablename to the FieldName
       The columnSource override below fixes this back again so the query returns correct data */     
    method private char GetMappingHack (): 
        define variable i as integer no-undo.
        define variable cMap as character no-undo.
        cMap = mMapping.
        i = lookup("TableName",cMap).
        if i > 0 then 
           entry(i + 1,cMap) = "_field-Name".
        return cMap.    
    end method.
        
     /* undo the GetMappingHack in the query expression 
       (blind assumption that the first one is the tablename - defined by dataset relation)*/
    method public override character ColumnSource(pcColumn as char):
        if not mreplaced and pcColumn = "_Field._Field-Name" then
        do:
            mReplaced = true.
            return "_File._File-Name".
        end.
        else
            return super:ColumnSource(pcColumn).    
    end method.
    
    /* override to set replaced false in case prepare is called again (not very common... ) */
    method protected override void PrepareBuffer(phBuffer as handle):
        mreplaced = false.
        super:PrepareBuffer(phBuffer).
    end method.

    method public override void AfterFieldRow(dataset-handle hds):
        define variable iSource as integer no-undo.
        super:AfterFieldRow(dataset-handle hds).
        iSource = lookup("_File",Tables).
        mBuffer::TableName  = DataSourceHandle:get-source-buffer(iSource)::_file-Name.
/*                find dictdb._file of _field no-lock.  */
/*        mBuffer::TableName =  dictdb._File._file-Name.*/
    end method.    
 
end class.