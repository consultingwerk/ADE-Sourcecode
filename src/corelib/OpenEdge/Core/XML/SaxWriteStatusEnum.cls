/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SaxWriteStatusEnum
    Purpose     : Enumerates the values of the SAX=WRITE WRITE-STATUS attribute 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 22 15:48:43 EST 2010
    Notes       : * See the ABL Help and/or documentation for details 
                  * This program based on the AutoEdge|TheFactory version
                  * The Sax-Write-* versions are added since the underlying
                    values were always those, and the name shortened. Built-in
                    enums don't allow you to set these independently
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Core.XML.SaxWriteStatusEnum: 
    define enum
            /* No writing has occurred. */
            Sax-Write-Idle
            Idle = Sax-Write-Idle
            
            /* The START-DOCUMENT method has been called and writing has begun. */
            Sax-Write-Begin
            Begin = Sax-Write-Begin
             
            /* The writer has written an opening tag. This is the only time that attributes can 
                be inserted with INSERT-ATTRIBUTE and DECLARE-NAMESPACE. */
            Sax-Write-Tag
            Tag = Sax-Write-Tag
            /* The writer is within an element. */
            Sax-Write-Element
            Element = Sax-Write-Element
            
            /* The writer has written the content of an element. In other words, the WRITE-CHARACTERS method has been called. */
            Sax-Write-Content
            Content  = Sax-Write-Content
            
            /* The END-DOCUMENT method has been called and writing is complete.  */
            Sax-Write-Complete
            Complete = Sax-Write-Complete
            
            /* The SAX-writer could not start or could not continue. Likely causes include: SAX-writer 
               could not be loaded, the XML target could not be written to, a method call fails, etc.
               This is the status if there is an invalid XML generated while STRICT is TRUE.
               If the status is SAX-WRITE-ERROR then no attributes can be written and the only
               method that can be called is RESET. */
            Sax-Write-Error
            Error = Sax-Write-Error
            
            Default = Idle.
                
end enum.
