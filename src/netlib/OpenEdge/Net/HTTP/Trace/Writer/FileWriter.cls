/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : FileWriter
    Purpose     : Simply writes a timestamped file with trace data to disk
    Syntax      :
    Description :
    Author(s)   : Dustin Grau
    Created     : Wed Sep 22 13:56:01 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.File.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Net.HTTP.Trace.Writer.ITraceWriter.
using OpenEdge.Core.StringConstant.

@since(rel='12.5.0').
class OpenEdge.Net.HTTP.Trace.Writer.FileWriter implements ITraceWriter:
    // Private variable to hold the set value (which may be tokenised), as opposed to
    // the resolved value returned by the FileName getter
    var private character mFileName.
    
    /* The name of the file to write to. May be a fixed or tokenised value
       Each 'get' call of this property calls the TokenResolver to deal with
       timestamp-based tokens */
    define public property FileName as character no-undo
        get():
            var File f = new File(TokenResolver:Resolve(this-object:FileName)).
            
            // make sure the folder exists
            f:CreateFolder().
            
            return f:Name.
        end get.
        set(input pName as character):
            Assert:NotNull(pName, 'File name').
            assign mFileName            = pName
                   this-object:FileName = pName
                   .
        end set.
    
    /* Default constructor */
    constructor public FileWriter():
        // default file name
        assign this-object:FileName = "$~{SESSION.TEMP-DIR}/TraceOutput/HttpClient_$~{T.YMD}_$~{T.MTIME}.trace".
    end constructor.
    
    /** Writes formatted trace data to disk, defaulting to the session:temp-dir,
        a dedicated folder, and a timestamped ".trace" file as the final output.
        
        @param IMemptrHolder Formatted data. */
    method public void Write ( input pData as IMemptrHolder ):
        // Write the data out to the expected location.
        copy-lob pData:Value to file(this-object:FileName).
    end method.
    
    method override public character ToString():
        return substitute('&1 [FileName: &2]',
                          super:ToString(),
                          // replace the token 'opener' so that if this message is logged, the tokens won't be converted
                          replace(mFileName, StringConstant:CURLY_OPEN, StringConstant:TILDE + StringConstant:CURLY_OPEN)).
    end method.
    
end class.