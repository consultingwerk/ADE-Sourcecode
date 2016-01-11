/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StatusCodeFilterList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 27 13:58:47 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Status.StatusCodeFilterNode.
using OpenEdge.Net.HTTP.HttpResponse.
using OpenEdge.Net.HTTP.StatusActionEnum.

{OpenEdge/Core/Collections/typedlinkedlist.i
    &Package    = OpenEdge.Net.HTTP.Filter.Status
    &ListType   = StatusCodeFilterList
    &NodeType   = StatusCodeFilterNode
    &NoEndClass = true
}
    
    /** Evaluates a HTTP Response's Status Code (ie 400 or whatnot). The filter
        returns a value indicating whether the request should be resubmitted 
        depending on the evaulation.  
    
        @param HttpResponse The response whose status code is being evaulated 
        @param character[] Character array representing the result of the filter. */
    method public StatusActionEnum Filter(input poResponse as HttpResponse):
        define variable iLoop as integer no-undo.
        define variable oNode as StatusCodeFilterNode no-undo.
        define variable iMax as integer no-undo.
        define variable oStatusAction as StatusActionEnum no-undo.
        
        assign oNode         = this-object:First
               oStatusAction = StatusActionEnum:OK.
        
        do while valid-object(oNode):
            assign iMax = extent(oNode:Data:StatusCode).
            do iLoop = 1 to iMax:
                if oNode:Data:StatusCode[iLoop]:Equals(poResponse:StatusCode) then
                do:
                    assign oStatusAction = oNode:Data:EvaluateStatus(input poResponse).
                    leave.
                end.
            end.
            
            if not oStatusAction:Equals(StatusActionEnum:OK) then
                leave.
                            
            /* pass it on */
            assign oNode = oNode:Next.
        end.
        
        return oStatusAction.        
    end method.
end class.
