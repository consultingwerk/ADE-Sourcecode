/************************************************
Copyright (c)  2013, 2015-2016 by Progress Software Corporation. All rights reserved.
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
                      DatetimeTZ         
                      DatetimeTZArray    
                      Raw                
                      RawArray           
                      Memptr             
                      MemptrArray        
                      Handle             
                      HandleArray        
                      BLOB               
                      CLOB               
                      ComHandle          
                      ComHandleArray     
                    
                      /* Data structures */
                      Dataset            
                      Buffer             
                      TempTable   
                      ClientPrincipal       
                    
                      /* User-defined types */
                      ProgressLangObject 
                      Enumeration        
                      Class              
                      ClassArray         
                
                      /* Streams */
                      Stream 
                    
                      /* Query Where clause 'types' */
                      RowState 
                    
                      /* XML */
                      XmlDocument 
                      XmlNodeRef
                      
                      
                      Default = Character.  
end enum.
