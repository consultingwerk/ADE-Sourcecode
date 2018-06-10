 
 /*------------------------------------------------------------------------
    File        : Compare
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Mar 11 22:17:20 EDT 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.Error.IllegalArgumentError from propath.

block-level on error undo, throw.

class OpenEdge.DataAdmin.Util.CompareHelper: 
    method public static char CompareBuffers(phbuffer1 as handle, phBuffer2 as handle,pcExclude as char,pcOption as char):
        define variable iVar           as integer    no-undo.
        define variable cChangedFlds   as character  no-undo.
        define variable lChanged       as logical    no-undo.
        define variable cName          as character  no-undo.
        define variable cDataType      as character  no-undo.
         
        /** if not lookup > 0 covers unknown */   
        if not lookup(pcOption, "RAW,CASE-SENSITIVE,CASE-INSENSITIVE":U) > 0 then
            undo, throw new IllegalArgumentError("Invalid option " + quoter(pcoption) + " passed to CompareBuffers."
                                             + " Valid values are ~"RAW~", ~"CASE-SENSITIVE~" or ~"CASE-INSENSITIVE~"").
            
        do iVar = 1 to phBuffer1:num-fields: 
            cName = phBuffer1:buffer-field(iVar):NAME.
    
            if lookup(cName, pcExclude) > 0 then 
               next.
            cDataType = phBuffer1:buffer-field(iVar):DATA-TYPE.
            
            if cDataType = 'CHARACTER':U then
                lChanged = compare(phBuffer1:buffer-field(iVar):BUFFER-VALUE, 
                                '<>':U, 
                                phBuffer2:buffer-field(cName):BUFFER-VALUE,
                                pcOption).
            else if cDataType = 'CLOB' then
                lChanged = CompareClobValues(phBuffer1:buffer-field(iVar), 
                                          '<>':U, 
                                          phBuffer2:buffer-field(cName),
                                          pcOption).
            else 
                lChanged = phBuffer1:buffer-field(iVar):BUFFER-VALUE 
                        <> phBuffer2:buffer-field(cName):BUFFER-VALUE.
         
            if lChanged then
                cChangedFlds = cChangedFlds 
                             + (if cChangedFlds > "" then "," else "") 
                             + cName.
        end.
        return cChangedFlds.
    end method.
  
    method private static logical CompareClobValues ( phColumn1  as handle,pcOperator as char,phcolumn2  as handle,pcStrength as char) :
        define variable cLong1    as longchar   no-undo.
        define variable cLong2    as longchar   no-undo.
        define variable lUnknown1 as logical    no-undo.
        define variable lUnknown2 as logical    no-undo.
        define variable lEqual    as logical    no-undo.
        define variable lCompare  as logical    no-undo.
    
        assign
           lEqual    = pcOperator = "=" or pcOperator = "EQ"
           lUnknown1 = (phColumn1:buffer-value = ?)
           lUnknown2 = (phColumn2:buffer-value = ?).
    
        if lUnknown1 and lUnknown2 then
           lCompare = lEqual.
        else if lUnknown1 or lUnknown2 then
           lCompare = not lEqual.
        else if length(phColumn1:buffer-value) <> LENGTH(phColumn2:buffer-value) then
           lCompare = not lEqual.
    
        else do:
            copy-lob from phColumn1:buffer-value to cLong1.
            copy-lob from phColumn2:buffer-value to cLong2.
            lCompare = compare(cLong1,pcOperator,cLong2,pcStrength).
        end.
    
        return lCompare.

    end method.
end class.