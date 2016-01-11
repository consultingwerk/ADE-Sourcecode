/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SaxReaderfacade.p
    Purpose     : XML SAX parser facade procedure.
    Syntax      :
    Description : 
    @author pjudge
    Created     : Tue Jul 13 09:40:09 EDT 2010
    Notes       : * This procedure acts as a facade object for the SaxReader
                    class, since classes can't be subscribed as event listeners
                    for the ABL SAX-READER.
                  * The individual procedures here are as documented in the
                    ABL documentation set. 
                  * This program based on the AutoEdge|TheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.XML.SaxReader.

/* ***************************  Definitions  ************************** */
/** The facade object that handles the callbacks from the SAX parser, and which
    publishes them as typed events. */
define input parameter poSaxReader as SaxReader no-undo.

create widget-pool.

/* ***************************  Main Block  *************************** */
procedure ParseMemptr:
    define input parameter pmXML as memptr no-undo.
    
    define variable hSaxReader as handle no-undo.
    define variable hSaxAttributes as handle no-undo.
    
    create sax-reader hSaxReader.
    hSaxReader:handler = this-procedure.
    
    create sax-attributes hSaxAttributes.
    
    hSaxReader:set-input-source('memptr', pmXML).
    hSaxReader:sax-parse().
    
    finally:
        delete object hSaxAttributes no-error.
        delete object hSaxReader no-error.
        set-size(pmXML) = 0.
    end finally.
end procedure.

procedure ParseDocument:
    define input parameter pcXML as longchar no-undo.
    
    define variable hSaxReader as handle no-undo.
    define variable hSaxAttributes as handle no-undo.
    
    create sax-reader hSaxReader.
    hSaxReader:handler = this-procedure.
    
    create sax-attributes hSaxAttributes.
    
    hSaxReader:set-input-source('longchar', pcXML).
    hSaxReader:sax-parse().
    
    finally:
        delete object hSaxAttributes no-error.
        delete object hSaxReader no-error.
    end finally.
end procedure.

/* ***************************  Callbacks  *************************** */

/* Tell the parser where to find an external entity. */
procedure ResolveEntity:
    define input  parameter publicID   as character no-undo.
    define input  parameter systemID   as character no-undo.
    define output parameter filePath   as character no-undo.
    define output parameter memPointer as longchar no-undo.
    
    poSaxReader:ResolveEntity(publicID, systemID, output filePath, output memPointer).
end procedure.

/** Process various XML tokens. */
procedure StartDocument:
    poSaxReader:StartDocument().
end procedure.

procedure ProcessingInstruction:
    define input parameter target as character no-undo.
    define input parameter data   as character no-undo.
    
    poSaxReader:ProcessingInstruction(target, data).
end procedure.

procedure StartPrefixMapping:
    define input parameter prefix as character no-undo.
    define input parameter uri    as character no-undo.
    
    poSaxReader:StartPrefixMapping(prefix, uri).
end procedure.

procedure EndPrefixMapping:    
    define input parameter prefix as character no-undo.
    
    poSaxReader:EndPrefixMapping(prefix).
end procedure.

procedure StartElement:
    define input parameter namespaceURI as character no-undo.
    define input parameter localName    as character no-undo.
    define input parameter qName        as character no-undo.
    define input parameter attributes   as handle no-undo.
    
    poSaxReader:StartElement(namespaceURI, localName, qName, attributes).
end procedure.

procedure Characters:
    define input parameter charData as longchar no-undo.
    define input parameter numChars as integer no-undo.
    
    poSaxReader:Characters(charData, numChars).
end procedure.

procedure IgnorableWhitespace:
    define input parameter charData as character no-undo.
    define input parameter numChars as integer.
    
    poSaxReader:IgnorableWhitespace(charData, numChars).
end procedure.

procedure EndElement:
     define input parameter namespaceURI as character no-undo.
     define input parameter localName    as character no-undo.
     define input parameter qName        as character no-undo.
     
     poSaxReader:EndElement(namespaceURI, localName, qName).
end procedure.

procedure EndDocument:
    poSaxReader:EndDocument().
end procedure.

/** Process notations and unparsed entities.*/
procedure NotationDecl:
    define input parameter name     as character no-undo.
    define input parameter publicID as character no-undo.
    define input parameter systemID as character no-undo.
    
    poSaxReader:NotationDecl(name, publicID, systemID).
end procedure.

procedure UnparsedEntityDecl:
    define input parameter name         as character no-undo.
    define input parameter publicID     as character no-undo.
    define input parameter systemID     as character no-undo.
    define input parameter notationName as character no-undo.
    
    poSaxReader:UnparsedEntityDecl(name, publicID, systemID, notationName).
end procedure.

/*Handle errors.*/
procedure Warning:
    define input parameter errMessage as character no-undo.
    
    poSaxReader:Warning(errMessage).
end procedure.

procedure Error:
    define input parameter errMessage as character no-undo.
     
    poSaxReader:Error(errMessage).
end procedure.

procedure FatalError:
    define input parameter errMessage as character no-undo.
    
    poSaxReader:FatalError(errMessage).
end procedure.

/** EOF **/
