 /************************************************
Copyright (c) 2013,2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SaxReader
    Purpose     : Wrapper OpenEdge/Core/XML/SaxReaderfacade.p which handles SAX
                  parser events.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 13 09:50:23 EDT 2010
    Notes       : * The strongly-typed events in this class correspond to the
                    SAX-READER events, as documented in the ABL documentation
                    set. This class basically acts as a wrapper around a .P 
                    since classes can't be specified as listeners for the SAX-
                    READER object. This class then re-publishes the events as
                    strongly typed events.
                  * The strongly-typed events in this class follow the ABL convention,
                    and not the sender,eventargs convention otherwise used in
                    this reference code.
                  * This class based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.
using OpenEdge.Core.XML.SaxReader.

class OpenEdge.Core.XML.SaxReader:
    
    /* SAX Events from SAX-READER callbacks */
    define public event SaxReaderStartDocument signature void(input phReader as handle).
     
    define public event SaxReaderProcessingInstruction signature void (input phReader as handle, 
                                                                       input pcTarget as character,
                                                                       input pcData as character).    
    define public event SaxReaderResolveEntity signature void (input phReader as handle,
                                                               input pcPublicID as character,
                                                               input pcSystemID as character,
                                                               output pcFilePath as character,
                                                               output pcMemPointer as longchar).
    define public event SaxReaderStartPrefixMapping signature void (input phReader as handle,
                                                                    input pcPrefix as character,
                                                                    input pcURI as character).    
    define public event SaxReaderEndPrefixMapping signature void (input phReader as handle,
                                                                  input pcPrefix as character).    
    define public event SaxReaderStartElement signature void (input phReader as handle,
                                                              input pcNamespaceURI as character,
                                                              input pcLocalName as character,
                                                              input pcQName as character,
                                                              input phAttributes as handle ).
    define public event SaxReaderCharacters signature void (input phReader as handle,
                                                            input pcCharData as longchar,
                                                            input piNumChars as integer).
    define public event SaxReaderIgnorableWhitespace signature void (input phReader as handle,
                                                                     input pcCharData as character,
                                                                     input piNumChars as integer).
    define public event SaxReaderEndElement signature void (input phSaxReader as handle,
                                                            input pcNamespaceURI as character,
                                                            input pcLocalName as character,
                                                            input pcQName as character).
    define public event SaxReaderEndDocument signature void (input phReader as handle).
    define public event SaxReaderNotationDecl signature void (input phReader as handle,
                                                              input pcName  as character,
                                                              input pcPublicID as character,
                                                              input pcSystemID as character).
    define public event SaxReaderUnparsedEntityDecl signature void (input phReader as handle,
                                                                    input pcName as character,
                                                                    input publicID     as character,
                                                                    input systemID     as character,
                                                                    input pcNotationName as character).
    define public event SaxReaderWarning signature void (input phReader as handle,
                                                         input pcErrMessage as character).
    define public event SaxReaderError signature void (input phReader as handle,
                                                       input pcErrMessage as character).
    define public event SaxReaderFatalError signature void (input phReader as handle,
                                                            input pcErrMessage as character).
    
    define private variable mhParserProc as handle no-undo.
    
    constructor public SaxReader():
    end constructor.
    
    destructor public SaxReader():
        delete procedure mhParserProc no-error.
    end destructor.
    
    /* Parses the XML contained in the input longchar
       
       @param longchar The XML data to parse. */
    method public void ParseDocument(input pcXML as longchar):
        /* run the facade.p for each  document run, since we set up a circular dependency
           and GC cannot clean it up */
        run OpenEdge/Core/XML/saxreaderfacade.p persistent set mhParserProc (this-object).        
        
        run ParseDocument in mhParserProc (pcXML).
        
        finally:
            delete object mhParserProc no-error.
        end finally.
    end method.
    
    /* Parses the XML contained in the input memptr
       
       @param memptr The XML data to parse. */
    method public void ParseDocument(input pmXML as memptr):
        /* run the facade.p for each  document run, since we set up a circular dependency
           and GC cannot clean it up */
        run OpenEdge/Core/XML/saxreaderfacade.p persistent set mhParserProc (this-object).
                
        run ParseMemptr in mhParserProc (pmXML).
        finally:
            set-size(pmXML) = 0.
            delete object mhParserProc no-error.
        end finally.
    end method.

    /* Parses the XML contained in the input file
       
       @param character The name of the file to parse. */
    method public void ParseFile(input pcFilename as character):
        /* run the facade.p for each  document run, since we set up a circular dependency
           and GC cannot clean it up */
        run OpenEdge/Core/XML/saxreaderfacade.p persistent set mhParserProc (this-object).
                
        run ParseFile in mhParserProc (pcFilename).
        finally:
            delete object mhParserProc no-error.
        end finally.
    end method.
    
    /* Tell the parser where to find an external entity. */
    method public void ResolveEntity (input pcPublicID as character,
                                      input pcSystemID as character,
                                      output pcFilePath as character,
                                      output pcMemPointer as longchar):
        SaxReaderResolveEntity:Publish(self:handle, pcPublicID, pcSystemID, output pcFilePath, output pcMemPointer).                                          
    end method.
    
    /** Process various XML tokens. */
    method public void StartDocument():
        SaxReaderStartDocument:Publish(self:handle).
    end method.

    method public void ProcessingInstruction(input pcTarget as character,
                                             input pcData as character):
        SaxReaderProcessingInstruction:Publish(self:handle, pcTarget, pcData).
    end method.
    
    method public void StartPrefixMapping(input pcPrefix as character,
                                          input pcURI as character):
        SaxReaderStartPrefixMapping:Publish(self:handle, pcPrefix, pcURI).                                              
    end method.

    method public void EndPrefixMapping(input pcPrefix as character):
        SaxReaderEndPrefixMapping:Publish(self:handle, pcPrefix).
    end method.

    method public void StartElement(input pcNamespaceURI as character,
                                    input pcLocalName as character,
                                    input pcQName as character,
                                    input phAttributes as handle ):
        SaxReaderStartElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName, phAttributes).                                        
    end method.

    method public void Characters(input pcCharData as longchar,
                                  input piNumChars as integer):
        SaxReaderCharacters:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void IgnorableWhitespace(input pcCharData as character,
                                           input piNumChars as integer):
        SaxReaderIgnorableWhitespace:Publish(self:handle, pcCharData, piNumChars).
    end method.

    method public void EndElement(input pcNamespaceURI as character,
                                  input pcLocalName as character,
                                  input pcQName as character):
        SaxReaderEndElement:Publish(self:handle, pcNamespaceURI, pcLocalName, pcQName).                                      
    end method.

    method public void EndDocument():
        SaxReaderEndDocument:Publish(self:handle).
    end method.

    /** Process notations and unparsed entities.*/
    method public void NotationDecl(input pcName  as character,
                                    input pcPublicID as character,
                                    input pcSystemID as character):
        SaxReaderNotationDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID).                                        
    end method.

    method public void UnparsedEntityDecl(input pcName as character,
                                          input pcPublicID as character,
                                          input pcSystemID as character,
                                          input pcNotationName as character):
        SaxReaderUnparsedEntityDecl:Publish(self:handle, pcName, pcPublicID, pcSystemID, pcNotationName).                                              
    end method.

    /*Handle errors.*/
    method public void Warning(input pcErrMessage as character):
        SaxReaderWarning:Publish(self:handle, pcErrMessage).
    end method.

    method public void Error(input pcErrMessage as character):
        SaxReaderError:Publish(self:handle, pcErrMessage).
    end method.
    
    method public void FatalError(input pcErrMessage as character):
        SaxReaderFatalError:Publish(self:handle, pcErrMessage).
    end method. 
    
end class.
