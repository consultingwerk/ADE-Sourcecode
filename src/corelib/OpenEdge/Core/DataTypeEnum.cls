/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : DataTypeEnum
    Purpose     : Enumeration of ABL datatypes
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 16 13:44:09 EDT 2009
    Notes       : * EnumMember numeric values taken from ADE
                  * This version based on the AutoEdgeTheFactory version
  ---------------------------------------------------------------------- */
block-level on error undo, throw.
  
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.DataTypeEnum final serializable inherits EnumMember:
    
    define public static property Default            as DataTypeEnum no-undo get. private set.
    define public static property None               as DataTypeEnum no-undo get. private set.
    
    /* ABL Primitives */
    define public static property Character          as DataTypeEnum no-undo get. private set.
    define public static property CharacterArray     as DataTypeEnum no-undo get. private set.
    define public static property LongChar           as DataTypeEnum no-undo get. private set.
    define public static property LongCharArray      as DataTypeEnum no-undo get. private set.
    define public static property Integer            as DataTypeEnum no-undo get. private set.
    define public static property IntegerArray       as DataTypeEnum no-undo get. private set.
    define public static property Int64              as DataTypeEnum no-undo get. private set.
    define public static property Int64Array         as DataTypeEnum no-undo get. private set.
    define public static property Decimal            as DataTypeEnum no-undo get. private set.
    define public static property DecimalArray       as DataTypeEnum no-undo get. private set.
    define public static property Logical            as DataTypeEnum no-undo get. private set.
    define public static property LogicalArray       as DataTypeEnum no-undo get. private set.
    define public static property Rowid              as DataTypeEnum no-undo get. private set.
    define public static property RowidArray         as DataTypeEnum no-undo get. private set.
    define public static property Recid              as DataTypeEnum no-undo get. private set.
    define public static property RecidArray         as DataTypeEnum no-undo get. private set.
    define public static property Date               as DataTypeEnum no-undo get. private set.
    define public static property DateArray          as DataTypeEnum no-undo get. private set.
    define public static property Datetime           as DataTypeEnum no-undo get. private set.
    define public static property DatetimeArray      as DataTypeEnum no-undo get. private set.
    define public static property DatetimeTZ         as DataTypeEnum no-undo get. private set.
    define public static property DatetimeTZArray    as DataTypeEnum no-undo get. private set.
    define public static property Raw                as DataTypeEnum no-undo get. private set.
    define public static property RawArray           as DataTypeEnum no-undo get. private set.
    define public static property Memptr             as DataTypeEnum no-undo get. private set.
    define public static property MemptrArray        as DataTypeEnum no-undo get. private set.
    define public static property Handle             as DataTypeEnum no-undo get. private set.
    define public static property HandleArray        as DataTypeEnum no-undo get. private set.
    define public static property BLOB               as DataTypeEnum no-undo get. private set.
    define public static property CLOB               as DataTypeEnum no-undo get. private set.
    define public static property ComHandle          as DataTypeEnum no-undo get. private set.
    define public static property ComHandleArray     as DataTypeEnum no-undo get. private set.
    
    /* Data structures */
    define public static property Dataset            as DataTypeEnum no-undo get. private set.
    define public static property Buffer             as DataTypeEnum no-undo get. private set.
    define public static property TempTable          as DataTypeEnum no-undo get. private set.
    
    /* User-defined types */
    define public static property ProgressLangObject as DataTypeEnum no-undo get. private set.
    define public static property Enumeration        as DataTypeEnum no-undo get. private set.
    define public static property Class              as DataTypeEnum no-undo get. private set.
    define public static property ClassArray         as DataTypeEnum no-undo get. private set.

    /* Streams */
    define public static property Stream as DataTypeEnum no-undo get. private set.
    
    /* Query Where clause 'types' */
    define public static property RowState as DataTypeEnum no-undo get. private set.
    
    /* XML */
    define public static property XmlDocument as DataTypeEnum no-undo get. private set.
    define public static property XmlNodeRef as DataTypeEnum no-undo get. private set.
    
    constructor static DataTypeEnum():
        DataTypeEnum:None               = new DataTypeEnum(01, '').
        DataTypeEnum:Character          = new DataTypeEnum(02, 'Character').
        DataTypeEnum:CharacterArray     = new DataTypeEnum(03, 'Character Extent').
        DataTypeEnum:LongChar           = new DataTypeEnum(04, 'Longchar').
        DataTypeEnum:LongCharArray      = new DataTypeEnum(05, 'Longchar Extent').
        DataTypeEnum:Integer            = new DataTypeEnum(06, 'Integer').
        DataTypeEnum:IntegerArray       = new DataTypeEnum(07, 'Integer Extent').
        DataTypeEnum:Int64              = new DataTypeEnum(08, 'Int64').
        DataTypeEnum:Int64Array         = new DataTypeEnum(09, 'Int64 Extent').
        DataTypeEnum:Decimal            = new DataTypeEnum(10, 'Decimal').
        DataTypeEnum:DecimalArray       = new DataTypeEnum(11, 'Decimal Extent').
        DataTypeEnum:Logical            = new DataTypeEnum(12, 'Logical').
        DataTypeEnum:LogicalArray       = new DataTypeEnum(13, 'Logical Extent').
        DataTypeEnum:Rowid              = new DataTypeEnum(14, 'Rowid').
        DataTypeEnum:RowidArray         = new DataTypeEnum(15, 'Rowid Extent').
        DataTypeEnum:Recid              = new DataTypeEnum(16, 'Recid').
        DataTypeEnum:RecidArray         = new DataTypeEnum(17, 'Recid Extent').
        DataTypeEnum:Date               = new DataTypeEnum(18, 'Date').
        DataTypeEnum:DateArray          = new DataTypeEnum(19, 'Date Extent').
        DataTypeEnum:Datetime           = new DataTypeEnum(20, 'Datetime').
        DataTypeEnum:DatetimeArray      = new DataTypeEnum(21, 'Datetime Extent').
        DataTypeEnum:DatetimeTZ         = new DataTypeEnum(22, 'Datetime-TZ').
        DataTypeEnum:DatetimeTZArray    = new DataTypeEnum(23, 'Datetime-TZ Extent').
        DataTypeEnum:Raw                = new DataTypeEnum(24, 'Raw').
        DataTypeEnum:RawArray           = new DataTypeEnum(25, 'Raw Extent').
        DataTypeEnum:Memptr             = new DataTypeEnum(26, 'Memptr').
        DataTypeEnum:MemptrArray        = new DataTypeEnum(27, 'Memptr Extent').
        DataTypeEnum:Handle             = new DataTypeEnum(28, 'Handle').
        DataTypeEnum:HandleArray        = new DataTypeEnum(29, 'Handle Extent').
        DataTypeEnum:Class              = new DataTypeEnum(30, 'Class &1').
        DataTypeEnum:ClassArray         = new DataTypeEnum(31, 'Class &1 Extent').
        DataTypeEnum:ProgressLangObject = new DataTypeEnum(32, 'Progress.Lang.Object').
        DataTypeEnum:BLOB               = new DataTypeEnum(33, 'BLOB').
        DataTypeEnum:CLOB               = new DataTypeEnum(34, 'CLOB').
        DataTypeEnum:ComHandle          = new DataTypeEnum(35, 'Com-Handle').
        DataTypeEnum:ComHandleArray     = new DataTypeEnum(36, 'Com-Handle Extent').
        DataTypeEnum:Dataset            = new DataTypeEnum(37, 'Dataset').
        DataTypeEnum:Buffer             = new DataTypeEnum(38, 'Buffer').
        DataTypeEnum:TempTable          = new DataTypeEnum(39, 'Temp-Table').
        
        DataTypeEnum:Enumeration        = new DataTypeEnum(40, 'Enumeration').
        DataTypeEnum:Stream             = new DataTypeEnum(41, 'Stream').
        DataTypeEnum:RowState           = new DataTypeEnum(44, 'row-state').
        
        DataTypeEnum:XmlNodeRef         = new DataTypeEnum(42, 'x-noderef').
        DataTypeEnum:XmlDocument        = new DataTypeEnum(43, 'x-document').
        
        DataTypeEnum:Default = DataTypeEnum:Character.
    end constructor.

    constructor public DataTypeEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
    method static public DataTypeEnum EnumFromValue(piDataType as integer):
        define variable oMember as DataTypeEnum no-undo.
        
        case piDataType:
            when DataTypeEnum:None:Value               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:Value          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:Value     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:Value           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:Value      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:Value            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:Value       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:Value              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:Value         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:Value            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:Value       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:Value            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:Value       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:Value              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:Value         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:Value              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:Value         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:Value               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:Value          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:Value           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:Value      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:Value         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:Value    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:Value                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:Value           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:Value             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:Value        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:Value             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:Value        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:Value              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:Value         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:Value then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:Value               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:Value               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:Value          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:Value     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:Value            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:Value             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:Value          then oMember = DataTypeEnum:TempTable.
            when DataTypeEnum:Enumeration:Value        then oMember = DataTypeEnum:Enumeration.
            when DataTypeEnum:Stream:Value             then oMember = DataTypeEnum:Stream.
            when DataTypeEnum:RowState:Value           then oMember = DataTypeEnum:RowState.
            when DataTypeEnum:XmlDocument:Value        then oMember = DataTypeEnum:XmlDocument.
            when DataTypeEnum:XmlNodeRef:Value         then oMember = DataTypeEnum:XmlNodeRef.
        end case.
        
        return oMember.        
    end method.
    
    method static public DataTypeEnum EnumFromString(pcDataType as character):
        define variable oMember as DataTypeEnum no-undo.
        
        case pcDataType:
            when DataTypeEnum:None:ToString()               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:ToString()          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:ToString()     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:ToString()           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:ToString()      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:ToString()            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:ToString()       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:ToString()              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:ToString()         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:ToString()            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:ToString()       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:ToString()            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:ToString()       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:ToString()              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:ToString()         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:ToString()              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:ToString()         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:ToString()               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:ToString()          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:ToString()           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:ToString()      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:ToString()         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:ToString()    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:ToString()                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:ToString()           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:ToString()             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:ToString()        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:ToString()             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:ToString()        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:ToString()              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:ToString()         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:ToString() then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:ToString()               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:ToString()               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:ToString()          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:ToString()     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:ToString()            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:ToString()             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:ToString()          then oMember = DataTypeEnum:TempTable.
            when DataTypeEnum:Enumeration:ToString()        then oMember = DataTypeEnum:Enumeration.
            when DataTypeEnum:Stream:ToString()             then oMember = DataTypeEnum:Stream.
            when DataTypeEnum:RowState:ToString()           then oMember = DataTypeEnum:RowState.
            when DataTypeEnum:XmlDocument:ToString()        then oMember = DataTypeEnum:XmlDocument.
            when DataTypeEnum:XmlNodeRef:ToString()         then oMember = DataTypeEnum:XmlNodeRef.
        end case.
                
        return oMember.   
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
        return (entry(num-entries(poDataType:Name, ' '), poDataType:Name, ' ') eq 'extent').
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
            when DataTypeEnum:BLOB then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Character then cXmlSchemaType = 'string'.
            when DataTypeEnum:CLOB then cXmlSchemaType = 'string'.
            when DataTypeEnum:ComHandle then cXmlSchemaType = 'long'.
            when DataTypeEnum:Date then cXmlSchemaType = 'date'.
            when DataTypeEnum:DateTime then cXmlSchemaType = 'dateTime'.
            when DataTypeEnum:DatetimeTZ then cXmlSchemaType = 'dateTime'.
            when DataTypeEnum:Decimal then cXmlSchemaType = 'decimal'.
            when DataTypeEnum:Int64 then cXmlSchemaType = 'long'.
            when DataTypeEnum:Integer then cXmlSchemaType = 'int'.
            when DataTypeEnum:Logical then cXmlSchemaType = 'boolean'.
            when DataTypeEnum:Raw then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Recid then cXmlSchemaType = 'long'.
            when DataTypeEnum:Rowid then cXmlSchemaType = 'base64Binary'.
            when DataTypeEnum:Handle then cXmlSchemaType = 'long'.
            /*@todo(task="question", action="decent default?").*/
            otherwise cXmlSchemaType = poDataType:ToString().
        end case.
        
        return cXmlSchemaType.
    end method.
    
end class.
