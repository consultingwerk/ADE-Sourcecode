/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
 /*------------------------------------------------------------------------
    File        : ResponseElementWriter
    Purpose     :  
    Author(s)   : pjudge
    Created     : 2018-05-08
    Notes       :  
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using Progress.Lang.Object.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Net.HTTP.IHttpResponse.

class OpenEdge.Web.DataObject.Writer.ResponseElementWriter abstract
        implements ISupportLogging :
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /** (mandatory) The message entity that's being written to. The values passed 
        in to the Write() methods will be parsed/processed and written to this entity. */  
    define public property Response as IHttpResponse no-undo get. set.
    
    /** Default constructor. */
    constructor protected ResponseElementWriter():
    end constructor.
    
    /** Constructor.
        
        @param IHttpResponse The response being written to */
    constructor protected ResponseElementWriter(input pResponse as IHttpResponse):
        Assert:NotNull(pResponse, 'Response').
        
        assign this-object:Response = pResponse.
    end constructor.
    
    method public void Flush():
    end method.

    /** Opens the writer for output. Open/Close allows us to write the same message multiple
        times without requiring a new writer each time. */
    method public void Open():
    end method.
    
    /**  Closes the writer. */
    method public void Close():
        this-object:Flush().
    end method.
    
    /* Writes message element data to the response
       
       @param Progress.Lang.Object The data to write */
    method abstract public void Write(input pElemValue as Progress.Lang.Object).
    
    /* Writes message element data to the response
       
       @param character The element name 
       @param Progress.Lang.Object The data to write */
    method abstract public void Write(input pElemName as character,
                                      input pElemValue as Progress.Lang.Object).
    
end class.