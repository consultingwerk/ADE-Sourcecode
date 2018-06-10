/************************************************
Copyright (c) 2015, 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : MultipartEntity
    Purpose     : Entity object representing a multi-part entity or message,
                  per http://www.ietf.org/rfc/rfc2046.txt
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 19 14:50:22 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.ISupportMultipartEntity.
using OpenEdge.Net.MessagePart.
using Progress.Lang.Object.

class OpenEdge.Net.MultipartEntity implements ISupportMultipartEntity:
    
    /** The character string delimiting the parts. Excludes the leading and trailing -- */
    define public property Boundary as character no-undo
        get.
        set(input pBoundary as character):
            Assert:NotNullOrEmpty(pBoundary, 'Multipart boundary').
            assign this-object:Boundary = pBoundary.
        end set.
    
    /** The number of parts */
    define public property Size as integer no-undo get. private set.
    
    /** Preamble text to be discarded/ignored. Kept for info purposes */
    define public property Prologue as character no-undo
        get.
        set(input pcPrologue as character):
            Assert:NotNull(pcPrologue, 'Multipart prologue').
            assign this-object:Prologue = pcPrologue.
        end set.
    
    /** Epilogue text to be discarded/ignored. Kept for info purposes */
    define public property Epilogue as character no-undo
        get.
        set(input pcEpilogue as character):
            Assert:NotNull(pcEpilogue, 'Multipart epilogue').
            assign this-object:Epilogue = pcEpilogue.
        end set.
    
    define private static temp-table ttPart no-undo
        field ParentEntity as integer
        field PartNum as integer
        field Entity as Object  /* OpenEdge.Net.MessagePart */
        index idx1 as primary unique ParentEntity PartNum.
    
    
    constructor MultipartEntity():
        this-object:Boundary = guid.
    end constructor.
        
    destructor MultipartEntity():
        ClearParts().
    end destructor.
    
    /** Clears all the parts from this multipart entity */
    method public void ClearParts():
        define buffer ttPart for ttPart.
        
        for each ttPart where ttPart.ParentEntity eq integer(this-object):
            delete ttPart.
        end.
        
        assign this-object:Size = 0.
    end method.
    
    /** Adds a part to this multi-part entity
        
        @param  integer  The part number being added.
        @param  MessagePart The entity for the part
        @return logical True if the Part has replaced another part  */
    method public logical SetPart(input piPartNum as integer,
                                  input poEntity as MessagePart):
        define variable lExists as logical no-undo.
        define buffer ttPart for ttPart.
        
        Assert:IsPositive(piPartNum, 'Part num').
        Assert:NotNull(poEntity, 'Entity').
        
        assign lExists = can-find(ttPart where
                                  ttPart.ParentEntity eq integer(this-object) and
                                  ttPart.PartNum eq piPartNum). 
        if lExists then
            find ttPart where
                 ttPart.ParentEntity eq integer(this-object) and
                 ttPart.PartNum eq piPartNum
                 no-error.
        else
        do:
            create ttPart.
            assign ttPart.ParentEntity = integer(this-object)
                   ttPart.PartNum     = piPartNum
                   
                   this-object:Size   = this-object:Size + 1.
        end. 
        
        assign ttPart.Entity = poEntity.
        
        return lExists.
    end method.
    
    /** Adds a part to this multi-part entity
        
        @param  MessagePart The entity for the part
        @return integer  The part number being added. */
    method public integer AddPart(input poEntity as MessagePart):
        define variable iPartNum as integer no-undo.
        
        assign iPartNum = this-object:Size + 1.
        SetPart(iPartNum, poEntity).
            
        return iPartNum.
    end method.

    /** Returns a part's content, selected by part number 
        
        @param integer The part number
        @return MessagePart The content */
    method public MessagePart GetPart(input piPartNumber as integer):
        define buffer ttPart for ttPart.
        
        Assert:IsPositive(piPartNumber, 'Part num').
        
        if can-find(ttPart where
                    ttPart.ParentEntity eq integer(this-object) and
                    ttPart.PartNum eq piPartNumber) then 
            find ttPart where
                 ttPart.ParentEntity eq integer(this-object) and
                 ttPart.PartNum eq piPartNumber
                 no-error.
        if available ttPart then
            return cast(ttPart.Entity, MessagePart).
        
        return ?.
    end method.
    
    /* Returns any parts that have the specified content-id.
       
       @param  character A content ID to search by
       @return MessagePart[] An array of parts that have a content ID */
    method public MessagePart extent GetPart(input pcContentId as character):
        define variable oPart as MessagePart extent no-undo.
        define variable iLoop as integer no-undo.
        define variable cParts as character no-undo.
        define variable cDelimiter as character no-undo.
        define variable iMax as integer no-undo.
        
        define buffer ttPart for ttPart.
        
        Assert:NotNull(pcContentId, 'Content ID').
        
        assign cDelimiter = '':u.
        
        for each ttPart where ttPart.ParentEntity eq integer(this-object):
            if cast(ttPart.Entity, MessagePart):ContentID eq pcContentId then
                assign cParts = cParts + cDelimiter + string(ttPart.PartNum)
                       cDelimiter = ',':u.
        end.
        
        assign iMax = num-entries(cParts, cDelimiter)
               extent(oPart) = iMax
               /* in case iMax is 0 then we want to fail */
               no-error.
        
        do iLoop = 1 to iMax:
            find ttPart where
                 ttPart.ParentEntity eq integer(this-object) and
                 ttPart.PartNum eq integer(entry(iLoop, cParts)).
            
            assign oPart[iLoop] = cast(ttPart.Entity, MessagePart).
        end.
        
        return oPart.
    end method.
    
    /** Removes a part (by number) and reorders the parts.
        
        @param integer The part number to remove
        @return logical True if the record was removed */
    method public logical RemovePart(input piPartNumber as integer):
        define variable lExists as logical no-undo.
        define buffer ttPart for ttPart.
        define query qryParts for ttPart.
        
        Assert:IsPositive(piPartNumber, 'Part num').
                    
        assign lExists = can-find(ttPart where
                                  ttPart.ParentEntity eq integer(this-object) and
                                  ttPart.PartNum eq piPartNumber). 
        if lExists then
        do:
            find ttPart where
                 ttPart.ParentEntity eq integer(this-object) and
                 ttPart.PartNum eq piPartNumber
                 no-error.
            
            delete ttPart.
            assign this-object:Size = this-object:Size - 1.
            
            open query qryParts preselect each ttPart where
                           ttPart.ParentEntity eq integer(this-object) and
                           ttPart.PartNum gt piPartNumber.
            get first qryParts.
            do while available ttPart.
                assign ttPart.PartNum = piPartNumber
                       piPartNumber   = piPartNumber + 1.
                get next qryParts.
            end.
            close query qryParts.
        end.
        
        return lExists.
    end method.
    
end class.