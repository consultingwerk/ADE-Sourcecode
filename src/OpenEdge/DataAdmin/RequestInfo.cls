/*************************************************************/
 /* Copyright (c) 2011,2019 by Progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/ 
 /*------------------------------------------------------------------------
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Jul 19 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IRequestInfo from propath.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.
using OpenEdge.DataAdmin.Lang.QueryString  from propath.

routine-level on error undo, throw.

class OpenEdge.DataAdmin.RequestInfo implements IRequestInfo : 
    
    define temp-table ttChild 
       field Name as char
       field obj as Object 
       field seq as int
       index idx as unique Name
       index idxObj as unique obj.
       
    /** Name  - must match property in requested class */  
    define public property Name as char no-undo get. set.
    
    /** protected set - not changeable - provide with constructor  */  
    define public property SearchString as char no-undo get. set.
    
    /** The number of records to return per page or batch */
    define public property PageSize as integer no-undo get. set.
                     
    define private property KeyCharValue as char no-undo init ?  get.   set.
    define private property KeyIntValue as int no-undo init ? get.   set.
    
    define public property KeyFields as char no-undo init ? get.   set. 
    
     /** for internal use. Set to true when a named context (different name than context serializename)  
        query has been checked and applied. The Request info is kept in both collection and entity instances 
        and will be used multiple times to AddTreeTo or getChildWithRequestInfo   */
    define public property IsNameChecked as logical no-undo get. set.
    
 
    /**  QueryString   */  
    define public property QueryString as char no-undo   
        get. 
        set(pQuery as char):
            if KeyFields > "" then 
                undo, throw new IllegalArgumentError("Cannot set QueryString. The RequestInfo is defined with keys.").
            QueryString = pQuery.
        end.
       
    define private var mKeyValues as char no-undo extent .
    
    /** default constructor 	   																	  
	*/	
	 
    constructor public RequestInfo ():
        super ().
    end constructor.
    
    constructor public RequestInfo (pName as char):
        super ().
        if pName = "" or pname = ? then
            undo, throw new IllegalArgumentError("No collection name passed to constructor.") .
        if index(pName," ") <> 0 then
        do:
            undo, throw new IllegalArgumentError(pname + " is not a valid collection name.") .
        end.
        Name = pName.
    end constructor.
    
    constructor public RequestInfo (pKey as char, pValue as char):
        super().
        KeyFields = pKey.
        KeyCharValue = pValue.
        extent(mKeyValues) = 1.
        mKeyValues[1] = pValue.
    end constructor.
    
    constructor public RequestInfo (pKeys as char, pkey as char extent):       
        super().
        KeyFields = pKeys.
        mKeyValues = pkey.
    end constructor.
    
    constructor public RequestInfo (pKey as char, pValue as int):
        super().
        KeyFields = pKey.
        KeyIntValue = pValue.
        extent(mKeyValues) = 1.
        mKeyValues[1] = string(pValue).
    end constructor.
     
    method public logical Add(child as IRequestInfo):
        if child:name = "" or child:name = ? then
            undo, throw new AppError("Cannot Add RequestInfo with no name.").  
        return CreateChild( child:name,child).
    end method.    
    
    method private logical CreateChild(pcollname as char,child as IRequestInfo): 
        find ttchild where ttchild.name = pcollname no-error.
        if avail ttchild then 
            undo, throw new AppError("Request info already added for " + quoter(child:name )).  
        create ttchild.
        assign
            ttchild.name = pcollname
            ttChild.obj = child.
        return true.         
    end method.    
    
    method public char extent GetKeyValues():
        define variable cVal as character extent 1 no-undo. 
        
        if extent(mKeyValues) <> ? then 
            return mKeyValues.
        else 
            undo, throw new AppError("Key values not set in Row Request.",?).       
    end method.
    
    method public logical Remove(req as IRequestInfo):
        define variable inst as Object no-undo.
        inst = cast(req,Object).
        find ttchild where ttchild.obj = inst no-error.
        if avail ttchild then
        do: 
            delete ttChild.
        end.
    end method. 
    
    /** returns an IRequestInfo array of all child requests */
    method public IRequestInfo extent GetChildren().
        define buffer bttChild for ttChild.
        define variable children as IRequestInfo extent no-undo.
        define variable i as integer no-undo.
        /* can be improved by keeping count, but probably low number */
        for each bttchild:
            i = i + 1.
        end.
        if i > 0 then
        do:
            extent(children) = i.
            for each bttchild:
                children[i] = cast(bttChild.obj,IRequestInfo).
            end.
        end.
         return children.
    end method. 
    
    method public IRequestInfo Get(pcname as char):
        find ttchild where ttchild.name = pcname no-error.
        if avail ttchild then 
            return cast( ttChild.obj,IRequestInfo).
    end method.    
    
    method public logical MergeQueryExpression(pcQuery as char). 
        QueryString = MergeQueries(pcQuery,QueryString).        
    end method.
    
    /* merge query expressions - only one can have a sort */ 
    method private char MergeQueries(pcQuery1 as char,pcQuery2 as char) :
        define variable queryString  as QueryString no-undo.
        define variable cDummyQuery  as character no-undo.
        define variable cBaseQuery   as character no-undo.
        define variable cQueryNoSort as character no-undo.
        define variable cReturnQuery as character no-undo.
        define variable iPos as integer no-undo.
        
        /* merge if both queries have vakues */
        if pcQuery1 > "" and pcQuery2 > "" then
        do: 
            queryString = new QueryString().
            if index(" " + queryString:MaskQuotes(pcQuery1,"X")," by ") > 0 then
            do:
                if index(" " + queryString:MaskQuotes(pcQuery2,"X")," by ") > 0 then
                do:
                    undo, throw new IllegalArgumentError("Cannot add a sorted query to a QueryString with sort.").            
                end.
                cBaseQuery = pcQuery1.
                cQueryNoSort = pcQuery2.
            end.
            else do:
                cBaseQuery = pcQuery2.
                cQueryNoSort = pcQuery1.
            end.
            cDummyQuery = "for each dummy" 
                        + (if trim(cBaseQuery) begins "by " then "" else " where") 
                        + " " + cBaseQuery.
            cReturnQuery = queryString:InsertExpression(cDummyQuery,cQueryNoSort,"and").
            ipos = index(cReturnQuery,"where").
            cReturnQuery = trim(substr(cReturnQuery,ipos + 5)).
            return cReturnQuery.
        end.
        else if pcQuery1 > "" then
            return pcQuery1.
        else     
            return pcQuery2.
    end.
end class.