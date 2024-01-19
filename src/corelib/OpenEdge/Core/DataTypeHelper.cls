/************************************************
Copyright (c)  2013, 2015-2016, 2019, 2021, 2023.  by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : DataTypeHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Apr 09 15:21:48 EDT 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.DataTypeEnum.

class OpenEdge.Core.DataTypeHelper:
    
    /** This method changes a type description or 'mask' if it's an array to 
        return the base datatype and the word Extent, otherwise it returns 
        the datatype enetered.  This allows the user to find out if a particular
        datatype is an array or not through the isArray method.
        
        @param DataTypeEnum The ABL data type
        @return Character The mask of the data type. */
    method static public character GetMask(input poDataType as DataTypeEnum):
        Assert:NotNull(poDataType, 'Data type').
        
        case poDataType:
            when DataTypeEnum:None               then return '':u.
            when DataTypeEnum:CharacterArray     then return 'Character Extent':u.
            when DataTypeEnum:LongCharArray      then return 'Longchar Extent':u.
            when DataTypeEnum:IntegerArray       then return 'Integer Extent':u.
            when DataTypeEnum:Int64Array         then return 'Int64 Extent':u.
            when DataTypeEnum:DecimalArray       then return 'Decimal Extent':u.
            when DataTypeEnum:LogicalArray       then return 'Logical Extent':u.
            when DataTypeEnum:RowidArray         then return 'Rowid Extent':u.
            when DataTypeEnum:RecidArray         then return 'Recid Extent':u.
            when DataTypeEnum:DateArray          then return 'Date Extent':u.
            when DataTypeEnum:DatetimeArray      then return 'Datetime Extent':u.
            when DataTypeEnum:DatetimeTZArray    then return 'Datetime-TZ Extent':u.
            when DataTypeEnum:RawArray           then return 'Raw Extent':u.
            when DataTypeEnum:MemptrArray        then return 'Memptr Extent':u.
            when DataTypeEnum:HandleArray        then return 'Handle Extent':u.
            when DataTypeEnum:ComHandleArray     then return 'Com-Handle Extent':u.
            when DataTypeEnum:Class              then return 'Class &1':u.
            when DataTypeEnum:ClassArray         then return 'Class &1 Extent':u.
            when DataTypeEnum:ProgressLangObject then return 'Progress.Lang.Object':u.
            otherwise                                 return string(poDataType).
        end case.
    end method.

    /** Check to see if the data type is a primitive datatype.
        
        @param DataTypeEnum The ABL data type
        @return logical Is the datatype a primitive. */
    method static public logical IsPrimitive(poDataType as DataTypeEnum):
        define variable lPrimitive as logical no-undo.
        
        case poDataType:
            when DataTypeEnum:Class or
            when DataTypeEnum:ClassArray or
            when DataTypeEnum:ProgressLangObject or
            when DataTypeEnum:Enumeration or
            when DataTypeEnum:None then 
                lPrimitive = false.
            otherwise
                lPrimitive = true.
        end case.
        
        return lPrimitive.
    end method.
    
    /** Check to see if the data type is an array so user knows how to handle extents.
        e.g. CharacterArray - Character is primitive, but the array type makes it so
        the user must handle the extents to get the character data.
        
        @param DataTypeEnum The ABL data type
        @return logical Is the datatype an array. */
    method static public logical IsArray(input poDataType as DataTypeEnum):
        define variable cMask as character no-undo.
        // gets the mask, which is defined in GetMask method and all
        // arrays have extent in the description.
        cMask = GetMask(poDataType).
        return (entry(num-entries(cMask, ' ':u), cMask, ' ':u) eq 'extent':u).
    end method.
    
    /** Mapping from ABL data type to XML Schema supported data types. Taken from 
        the Working With XML book from the documentation set.
        
        Note that the converse is not supported, since there are multiple ABL types
        that map to a single XML schema type.
        
        @param DataTypeEnum The ABL data type
        @return character The XML data type. */
    method static public character ToXmlSchemaType(input poDataType as DataTypeEnum):
        define variable cXmlSchemaType as character no-undo.
        
        {&_proparse_ prolint-nowarn(recidkeyword)}
        case poDataType:
            when DataTypeEnum:BLOB       then assign cXmlSchemaType = 'base64Binary':u.
            when DataTypeEnum:Character  then assign cXmlSchemaType = 'string':u.
            when DataTypeEnum:CLOB       then assign cXmlSchemaType = 'string':u.
            when DataTypeEnum:ComHandle  then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Date       then assign cXmlSchemaType = 'date':u.
            when DataTypeEnum:DateTime   then assign cXmlSchemaType = 'dateTime':u.
            when DataTypeEnum:DatetimeTZ then assign cXmlSchemaType = 'dateTime':u.
            when DataTypeEnum:Decimal    then assign cXmlSchemaType = 'decimal':u.
            when DataTypeEnum:Int64      then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Integer    then assign cXmlSchemaType = 'int':u.
            when DataTypeEnum:Logical    then assign cXmlSchemaType = 'boolean':u.
            when DataTypeEnum:Raw        then assign cXmlSchemaType = 'base64Binary':u.
            {&_proparse_ prolint-nowarn(recidkeyword)}
            when DataTypeEnum:Recid      then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Rowid      then assign cXmlSchemaType = 'base64Binary':u.
            when DataTypeEnum:Handle     then assign cXmlSchemaType = 'long':u.
            /*@todo(task="question", action="decent default?").*/
            otherwise                         assign cXmlSchemaType = poDataType:ToString().
        end case.
        
        return cXmlSchemaType.
    end method.
                
end class.