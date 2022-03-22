/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : TraceFormatter
    Purpose     : Converts array of exchange data into a JSON construct
    Syntax      : 
    Description : 
    Author(s)   : Dustin Grau
    Created     : Wed Sep 22 13:56:01 EDT 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Net.HTTP.Trace.ExchangeData.
using OpenEdge.Net.HTTP.Trace.Formatter.ITraceFormatter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Net.HTTP.Trace.Formatter.JsonFormatter implements ITraceFormatter: 
    /* If TRUE the JSON data will be written out formatted aka pretty-printed. Default is FALSE */
    define public property Formatted as logical no-undo initial false
        get.
        set.
    
    /** Formats the array of ExchangeData into JSON, and returns as a Memptr.
       
        @param ExchangeData[] An array of exchange data
        @return IMemptrHolder The formatted representation of the exchange data */
    method public IMemptrHolder Format (input pTraceData as ExchangeData extent):
        define variable oExArr as JsonArray  no-undo.
        define variable iSize  as integer    no-undo.
        define variable iX     as integer    no-undo.
        define variable oData  as memptr     no-undo.

        assign
            iSize  = extent(pTraceData)
            oExArr = new JsonArray()
            .

        if iSize gt 0 then
        DATA-LOOP:
        do iX = 1 to iSize:
            if type-of(pTraceData[iX], IJsonSerializer) then
                oExArr:Add(cast(pTraceData[iX]:ToJsonConstruct(), JsonObject)).
        end.

        oExArr:Write(oData, this-object:Formatted). // Write JsonArray into a memptr.

        return new OpenEdge.Core.Memptr(oData).

        finally:
            set-size(oData) = 0.
        end finally.
    end method.

end class.