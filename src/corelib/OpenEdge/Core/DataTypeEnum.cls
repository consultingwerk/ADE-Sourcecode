/************************************************
Copyright (c)  2013, 2015-2016, 2018-2019 by Progress Software Corporation. All rights reserved.
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
  
enum OpenEdge.Core.DataTypeEnum:
    define enum       None
                      
                      /* ABL Primitives */
                      Character          
                      CharacterArray     
                      LongChar           
                      LongCharArray      
                      Integer            
                      IntegerArray       
                      Int64              
                      Int64Array         
                      Decimal            
                      DecimalArray       
                      Logical            
                      LogicalArray       
                      Rowid              
                      RowidArray         
                      Recid              
                      RecidArray         
                      Date               
                      DateArray          
                      Datetime           
                      DatetimeArray      
                      Datetime-TZ
                      DatetimeTZ         = Datetime-TZ
                      DatetimeTZArray    
                      Raw                
                      RawArray           
                      Memptr             
                      MemptrArray        
                      Handle             
                      HandleArray        
                      BLOB               
                      CLOB               
                      Com-Handle
                      ComHandle          = Com-Handle
                      ComHandleArray     
                      
                      /* Data structures */
                      Dataset            
                      Buffer             
                      Temp-Table
                      TempTable          = Temp-Table   
                      Client-Principal
                      ClientPrincipal    = Client-Principal       
                      
                      /* User-defined types */
                      ProgressLangObject 
                      Enumeration
                      Enum               = Enumeration
                      Class
                      ClassArray
                      
                      /* Streams */
                      Stream
                      
                      /* Query Where clause 'types' */
                      Row-State
                      RowState          = Row-State
                      
                      /* XML */
                      X-Document
                      XmlDocument       = X-Document
                      X-Noderef
                      XmlNodeRef        = X-Noderef
                      
                      Default = Character.  
end enum.
