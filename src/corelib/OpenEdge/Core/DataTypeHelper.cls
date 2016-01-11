/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
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
    
    method static public character GetMask(input poDataType as DataTypeEnum):
        Assert:NotNull(poDataType, 'Data type').
        
        case poDataType:
            when DataTypeEnum:None               then return '':u.
            when DataTypeEnum:Character          then return 'Character':u.
            when DataTypeEnum:CharacterArray     then return 'Character Extent':u.
            when DataTypeEnum:LongChar           then return 'Longchar':u.
            when DataTypeEnum:LongCharArray      then return 'Longchar Extent':u.
            when DataTypeEnum:Integer            then return 'Integer':u.
            when DataTypeEnum:IntegerArray       then return 'Integer Extent':u.
            when DataTypeEnum:Int64              then return 'Int64':u.
            when DataTypeEnum:Int64Array         then return 'Int64 Extent':u.
            when DataTypeEnum:Decimal            then return 'Decimal':u.
            when DataTypeEnum:DecimalArray       then return 'Decimal Extent':u.
            when DataTypeEnum:Logical            then return 'Logical':u.
            when DataTypeEnum:LogicalArray       then return 'Logical Extent':u.
            when DataTypeEnum:Rowid              then return 'Rowid':u.
            when DataTypeEnum:RowidArray         then return 'Rowid Extent':u.
            when DataTypeEnum:Recid              then return 'Recid':u.
            when DataTypeEnum:RecidArray         then return 'Recid Extent':u.
            when DataTypeEnum:Date               then return 'Date':u.
            when DataTypeEnum:DateArray          then return 'Date Extent':u.
            when DataTypeEnum:Datetime           then return 'Datetime':u.
            when DataTypeEnum:DatetimeArray      then return 'Datetime Extent':u.
            when DataTypeEnum:DatetimeTZ         then return 'Datetime-TZ':u.
            when DataTypeEnum:DatetimeTZArray    then return 'Datetime-TZ Extent':u.
            when DataTypeEnum:Raw                then return 'Raw':u.
            when DataTypeEnum:RawArray           then return 'Raw Extent':u.
            when DataTypeEnum:Memptr             then return 'Memptr':u.
            when DataTypeEnum:MemptrArray        then return 'Memptr Extent':u.
            when DataTypeEnum:Handle             then return 'Handle':u.
            when DataTypeEnum:HandleArray        then return 'Handle Extent':u.
            when DataTypeEnum:Class              then return 'Class &1':u.
            when DataTypeEnum:ClassArray         then return 'Class &1 Extent':u.
            when DataTypeEnum:ProgressLangObject then return 'Progress.Lang.Object':u.
            when DataTypeEnum:BLOB               then return 'BLOB':u.
            when DataTypeEnum:CLOB               then return 'CLOB':u.
            when DataTypeEnum:ComHandle          then return 'Com-Handle':u.
            when DataTypeEnum:ComHandleArray     then return 'Com-Handle Extent':u.
            when DataTypeEnum:Dataset            then return 'Dataset':u.
            when DataTypeEnum:Buffer             then return 'Buffer':u.
            when DataTypeEnum:TempTable          then return 'Temp-Table':u.
            
            when DataTypeEnum:Enumeration        then return 'Enumeration':u.
            when DataTypeEnum:Stream             then return 'Stream':u.
            when DataTypeEnum:RowState           then return 'row-state':u.
            
            when DataTypeEnum:XmlNodeRef         then return 'x-noderef':u.
            when DataTypeEnum:XmlDocument        then return 'x-document':u.
        end.        
    end method.
          
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
    
    method static public logical IsArray(input poDataType as DataTypeEnum):
        return (entry(num-entries(string(poDataType), ' ':u), string(poDataType), ' ':u) eq 'extent':u).
    end method.
    
    /** Mapping from ABL data type to XML Schema supported data types. Taken from 
        the Working With XML book from the documentation set.
        
        Note that the converse is not supported, since there are multiple ABL types
        that map to a single XML schema type.
        
        @param DataTypeEnum The ABL data type
        @return character The XML data type. */
    method static public character ToXmlSchemaType(input poDataType as DataTypeEnum):
        define variable cXmlSchemaType as character no-undo.
        
        case poDataType:
            when DataTypeEnum:BLOB      then assign cXmlSchemaType = 'base64Binary':u.
            when DataTypeEnum:Character then assign cXmlSchemaType = 'string':u.
            when DataTypeEnum:CLOB      then assign cXmlSchemaType = 'string':u.
            when DataTypeEnum:ComHandle then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Date      then assign cXmlSchemaType = 'date':u.
            when DataTypeEnum:DateTime  then assign cXmlSchemaType = 'dateTime':u.
            when DataTypeEnum:DatetimeTZ then assign cXmlSchemaType = 'dateTime':u.
            when DataTypeEnum:Decimal   then assign cXmlSchemaType = 'decimal':u.
            when DataTypeEnum:Int64     then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Integer   then assign cXmlSchemaType = 'int':u.
            when DataTypeEnum:Logical   then assign cXmlSchemaType = 'boolean':u.
            when DataTypeEnum:Raw       then assign cXmlSchemaType = 'base64Binary':u.
            when DataTypeEnum:Recid     then assign cXmlSchemaType = 'long':u.
            when DataTypeEnum:Rowid     then assign cXmlSchemaType = 'base64Binary':u.
            when DataTypeEnum:Handle    then assign cXmlSchemaType = 'long':u.
            /*@todo(task="question", action="decent default?").*/
            otherwise                        assign cXmlSchemaType = poDataType:ToString().
        end case.
        
        return cXmlSchemaType.
    end method.
                
end class.