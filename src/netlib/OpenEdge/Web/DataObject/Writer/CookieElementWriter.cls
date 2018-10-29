/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : CookieElementWriter
    Description : Writes message elements as a cookie
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.KeyValuePair.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using OpenEdge.Web.DataObject.ElementTypeEnum.

class OpenEdge.Web.DataObject.Writer.CookieElementWriter inherits ResponseElementWriter: 
    
    /** Default constructor. */
    constructor public CookieElementWriter():
        super().
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor public CookieElementWriter(input pResponse as IHttpResponse):
        super(pResponse).
    end constructor.
    
    /* Writes message element data to the response
       
       @param character The element name 
       @param Progress.Lang.Object The data to write */
    method override public void Write(input pElemName as character,
                                      input pElemValue as Progress.Lang.Object):
        // we don't care about the name
        this-object:Write(pElemValue).
    end method.
    
    method override public void Write(input pElemValue as Progress.Lang.Object ):
        case true:
            when not valid-object(pElemValue) then
                return.
            
            when type-of(pElemValue, KeyValuePair) then
                this-object:Write(cast(pElemValue, KeyValuePair):Key:ToString(), cast(pElemValue, KeyValuePair):Value).
                //this-object:Write(cast(pElemValue, KeyValuePair):Value).
            
            when type-of(pElemValue, Cookie) then
                this-object:Response:SetCookie(cast(pElemValue, Cookie)).
            
            otherwise
                Logger:Warn(substitute('Cannot convert message element type &1 to &2',
                                pElemValue:GetClass():TypeName,
                                string(ElementTypeEnum:Cookie))).
        end case.
    end method.

end class.