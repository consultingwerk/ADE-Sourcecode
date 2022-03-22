/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : MessageWriterErrorEventArgs
    Purpose     : Event args for the static WriteError event raised by a message writer
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2021-07-19
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.
using Progress.Lang.AppError.

class OpenEdge.Net.HTTP.Filter.Payload.MessageWriterErrorEventArgs
inherits EventArgs:
    /* (required) The writer type from which this error was thrown. This can be used to identify which
        type of conversion was attempted that caused the error to be raised. */
    define public property WriterType as class Progress.Lang.Class no-undo
        get.
        private set.
    
    /* (required) The input data that caused the error. If null, the AllowNullOutput property
       should be set to TRUE */
    define public property SourceData as Progress.Lang.Object no-undo
        get.
        private set.
    
    /* (required) The error that caused the event to be published */
    define public property Error as Progress.Lang.Error no-undo
        get.
        private set.
    
    /* The output data returned by a listener/subscriber. Cannot be equal to the SourceData */
    define public property OutputData as Progress.Lang.Object no-undo
        get.
        set(input pValue as Progress.Lang.Object):
            // first check handles case if both Source and Output are null; second handles values
            if pValue eq this-object:SourceData
            or pValue:Equals(this-object:SourceData)
            then
                return error new AppError('Infinite loop error: source and output data are equal', 0).
            
            assign this-object:OutputData = pValue.
        end set.
    
    /* The number of bytes written during the handling of the error */
    define public property BytesWritten as int64 no-undo
        initial 0
        get.
        set.
    
    /* If TRUE then the OutputData property is a valid value. If FALSE (default), then
       an event handler must add an OutputData object */
    define public property AllowNullOutput as logical no-undo
        initial false
        get.
        set.
    
    /* Constructor.

       @param Progress.Lang.Class The message writer type in which this error was raised.
       @param Progress.Lang.Object The input data causing the error.
       @param Progress.Lang.Error The error raised. */
    constructor public MessageWriterErrorEventArgs(input pWriter as class Progress.Lang.Class,
                                                   input pSource as Progress.Lang.Object,
                                                   input pError  as Progress.Lang.Error):
        Assert:NotNull(pWriter, 'Message writer').
        Assert:NotNull(pError, 'Writer error').
        
        assign this-object:WriterType = pWriter
               this-object:Error      = pError
               this-object:SourceData = pSource
               .
    end constructor.

end class.