/** ------------------------------------------------------------------------
    File        : SaxWriteStatusEnum
    Purpose     : Enumerates the values of the SAX=WRITE WRITE-STATUS attribute 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 22 15:48:43 EST 2010
    Notes       : * See the ABL Help and//or documentation for details 
                  * This program based on the AutoEdge|TheFactory version
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.SaxWriteStatusEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.SaxWriteStatusEnum inherits EnumMember: 
    /* No writing has occurred. */
    define static public property Idle as SaxWriteStatusEnum no-undo get. private set.
    
    /* The START-DOCUMENT method has been called and writing has begun. */
    define static public property Begin as SaxWriteStatusEnum no-undo get. private set.
    /* The writer has written an opening tag. This is the only time that attributes can 
        be inserted with INSERT-ATTRIBUTE and DECLARE-NAMESPACE. */
    define static public property Tag as SaxWriteStatusEnum no-undo get. private set.
    /* The writer is within an element. */
    define static public property Element as SaxWriteStatusEnum no-undo get. private set.
    /* The writer has written the content of an element. In other words, the WRITE-CHARACTERS method has been called. */
    define static public property Content as SaxWriteStatusEnum no-undo get. private set.
    /* The END-DOCUMENT method has been called and writing is complete.  */
    define static public property Complete as SaxWriteStatusEnum no-undo get. private set.
    /* The SAX-writer could not start or could not continue. Likely causes include: SAX-writer 
       could not be loaded, the XML target could not be written to, a method call fails, etc.
       This is the status if there is an invalid XML generated while STRICT is TRUE.
       If the status is SAX-WRITE-ERROR then no attributes can be written and the only
       method that can be called is RESET. */
    define static public property Error as SaxWriteStatusEnum no-undo get. private set.
    
    define static public property Default as SaxWriteStatusEnum no-undo get. private set.              
    
    constructor static SaxWriteStatusEnum():
        SaxWriteStatusEnum:Idle = new SaxWriteStatusEnum(1, 'SAX-WRITE-IDLE').
        SaxWriteStatusEnum:Begin = new SaxWriteStatusEnum(2, 'SAX-WRITE-BEGIN').
        SaxWriteStatusEnum:Tag = new SaxWriteStatusEnum(3, 'SAX-WRITE-TAG').
        SaxWriteStatusEnum:Element = new SaxWriteStatusEnum(4, 'SAX-WRITE-ELEMENT').
        SaxWriteStatusEnum:Content = new SaxWriteStatusEnum(5, 'SAX-WRITE-CONTENT').
        SaxWriteStatusEnum:Complete = new SaxWriteStatusEnum(6, 'SAX-WRITE-COMPLETE').
        SaxWriteStatusEnum:Error = new SaxWriteStatusEnum(7, 'SAX-WRITE-ERROR').
        
        SaxWriteStatusEnum:Default = SaxWriteStatusEnum:Idle.
    end constructor.

    constructor public SaxWriteStatusEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.

    method static public SaxWriteStatusEnum EnumFromString(input pcName as character):
        define variable oEnum as SaxWriteStatusEnum no-undo.
        
        case pcName:
            when SaxWriteStatusEnum:Idle:ToString() then oEnum = SaxWriteStatusEnum:Idle.
            when SaxWriteStatusEnum:Begin:ToString() then oEnum = SaxWriteStatusEnum:Begin.
            when SaxWriteStatusEnum:Tag:ToString() then oEnum = SaxWriteStatusEnum:Tag.
            when SaxWriteStatusEnum:Element:ToString() then oEnum = SaxWriteStatusEnum:Element.
            when SaxWriteStatusEnum:Content:ToString() then oEnum = SaxWriteStatusEnum:Content.
            when SaxWriteStatusEnum:Complete:ToString() then oEnum = SaxWriteStatusEnum:Complete.
            when SaxWriteStatusEnum:Error:ToString() then oEnum = SaxWriteStatusEnum:Error.
        end case.
        
        return oEnum.
    end method.

    method static public SaxWriteStatusEnum EnumFromValue(input piValue as integer):
        define variable oEnum as SaxWriteStatusEnum no-undo.
        
        case piValue:
            when SaxWriteStatusEnum:Idle:Value then oEnum = SaxWriteStatusEnum:Idle.
            when SaxWriteStatusEnum:Begin:Value then oEnum = SaxWriteStatusEnum:Begin.
            when SaxWriteStatusEnum:Tag:Value then oEnum = SaxWriteStatusEnum:Tag.
            when SaxWriteStatusEnum:Element:Value then oEnum = SaxWriteStatusEnum:Element.
            when SaxWriteStatusEnum:Content:Value then oEnum = SaxWriteStatusEnum:Content.
            when SaxWriteStatusEnum:Complete:Value then oEnum = SaxWriteStatusEnum:Complete.
            when SaxWriteStatusEnum:Error:Value then oEnum = SaxWriteStatusEnum:Error.
        end case.
        
        return oEnum.
    end method.

end class.
