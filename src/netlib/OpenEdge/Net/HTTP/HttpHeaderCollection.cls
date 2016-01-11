/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HttpHeaderCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 10 12:00:12 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.HttpHeaderCollection:
    /* Stores header name/value pairs */
    define static protected temp-table Headers no-undo
        field ParentClass as integer
        field HeaderName  as character
        field HttpHeader  as Object
        index idx1 as primary unique ParentClass HeaderName. 

    constructor public HttpHeaderCollection():
    end method.
    
    destructor HttpHeaderCollection():
        this-object:Clear().
    end destructor.
    
    /** Adds header info to this message's collection of headers.
        
        @param character The header name
        @param character The complete header value  */
    method public void Put(input poHeader as HttpHeader):
        Assert:NotNull(poHeader, 'Http Header').
        
        UpdateHeaderRecord(poHeader).
    end method.
    
    /** Internal helper method to perform the find. 
    
        @param handle    The buffer handle of the Headers table.
        @param character The header name
        @return logical True if a header record was found. */ 
    method private logical FindHeaderRecord(input phBuffer as handle, input pcName as character):
        phBuffer:find-unique(substitute('where &1.ParentClass eq &2 and &1.HeaderName eq &3',
                               phBuffer:name,
                               integer(this-object),
                               quoter(pcName))) no-error.
        
        return phBuffer:available.
    end method.

    /** Internal helper method to perform the find. 
    
        @param character The header name
        @return logical True if a header record was found. */ 
    method private logical FindHeaderRecord(input pcName as character):
        return FindHeaderRecord(buffer Headers:handle, pcName).
    end method.
    
    /** Private method for updating the value of a header record
        
        @param character The header name
        @param character the header value. */
    method private void UpdateHeaderRecord(input poHeader as HttpHeader):
        define buffer lbHeader for Headers.
        
        find lbHeader where
             lbHeader.ParentClass eq integer(this-object) and
             lbHeader.HeaderName eq poHeader:Name
             no-error.
        if not available lbHeader then
        do:
            create lbHeader.
            assign lbHeader.ParentClass = integer(this-object)
                   lbHeader.HeaderName = poHeader:Name.
        end.
        assign lbHeader.HttpHeader = poHeader.
    end method.

    /** Private method for removing a header record
        
        @param character The header name  */
    method private void DeleteHeaderRecord(input pcName as character):
        define buffer lbHeader for Headers.
        
        if FindHeaderRecord(buffer lbHeader:handle, pcName) then
            delete lbHeader.
    end method.
    
    /** Returns a named header

        @param  character The name of the header to retrieve
        @return HttpHeader The header object. Null if not exists. */
    method public HttpHeader Get(input pcName as character).
        define buffer lbHeader for Headers.
        
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        if FindHeaderRecord(buffer lbHeader:handle, pcName) then
            return cast(lbHeader.HttpHeader, HttpHeader).
        else
            return ?.
    end method.
    
    /** Returns all the headers (Names and values)
        
        @param HttpHeader[] An array of headers
        @return integer The number of headers returned */
    method public integer GetAll(output poHeaders as HttpHeader extent):
        define variable iCount as integer no-undo.
        define buffer lbHeader for Headers.
        
        define query qryHeader for lbHeader.
        open query qryHeader preselect each lbHeader where 
                                            lbHeader.ParentClass eq integer(this-object).
        
        assign iCount = query qryHeader:num-results.
        if iCount ne 0 then
            assign extent(poHeaders) = iCount.
        
        get first qryHeader.
        do while available lbHeader:
            assign poHeaders[query qryHeader:current-result-row] = cast(lbHeader.HttpHeader, HttpHeader)
                   .
            get next qryHeader.
        end.
        
        return iCount.
        finally:
            close query qryHeader.
        end finally.
    end method.
        
    /** Indicates whether a header exists for this message or not. 
        
        @param character The name of a header to check
        @return logical True if this message contains the header */
    method public logical Has(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        return FindHeaderRecord(pcName).
    end method.
    
    /** Removes a header from the collection of message headers.
        No-op if none exists.
        
        This implementation sets the value of the header to ?/unknown,
        passes it down the filter chain, and then removes it from the 
        header collection.
        
        @param character The name of the header to remove */    
    method public void Remove(input pcName as character):
        Assert:NotNullOrEmpty(pcName, 'Header name').
        
        DeleteHeaderRecord(pcName).
    end method.

    /** Removes all headers from this message */ 
    method public void Clear().
        define buffer lbHeader for Headers.
        
        for each lbHeader where lbHeader.ParentClass eq integer(this-object):
            delete lbHeader.
        end.
    end method.
    
end class.