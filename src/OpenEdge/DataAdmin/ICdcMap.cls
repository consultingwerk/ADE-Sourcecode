
/*------------------------------------------------------------------------
    File        : ICdcMap
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Fri Nov 20 12:47:27 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.DataAdmin.IDataAdminElement from propath.
using OpenEdge.DataAdmin.IDataAdminCollection from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.ICdc from propath.
using OpenEdge.DataAdmin.ISchemaElement from propath.
using OpenEdge.DataAdmin.ITable from propath.
using OpenEdge.DataAdmin.IIndex from propath.
using OpenEdge.DataAdmin.IField from propath.

interface OpenEdge.DataAdmin.ICdcMap inherits IDataAdminCollection:  
    method public logical ContainsKey(obj as ISchemaElement).  
    method public logical ContainsValue(CdcPolicy as ICdc).  
    method public ICdc Get(obj as ISchemaElement).  
    
    method public ICdc FindTable(pcTable as char).  
    method public ICdc FindField(pcTable as char,pcField as char).  
    method public ICdc FindIndex(pcTable as char,pcIndex as char,pcCollation as char). 
  
end interface.