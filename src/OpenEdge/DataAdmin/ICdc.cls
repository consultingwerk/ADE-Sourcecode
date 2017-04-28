
/*------------------------------------------------------------------------
    File        : ICdc
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Thu Nov 19 17:03:41 IST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.DataAdmin.IDataAdminElement.
using OpenEdge.DataAdmin.ITenantGroup from propath.
using OpenEdge.DataAdmin.ITenant from propath.
using OpenEdge.DataAdmin.ISchemaElement from propath.
using OpenEdge.DataAdmin.IArea from propath.

interface OpenEdge.DataAdmin.ICdc inherits IDataAdminElement:   
    
    /** returns true if the partition belongs to a partition enabled table */
    define public property IsCdcEnabled as logical no-undo  get.
    
    /** The TenantGroup of the partition - unknown if this is a tenant partition */
    define public property TenantGroup as ITenantGroup no-undo get.  
    
    /** The ObjectType of the partition - character expression Table,Index or Field */
    define public property ObjectType as character no-undo get. 
    
    /** The Tenant of the partition - unknown if this is a group partition */
    define public property Tenant        as ITenant        no-undo get. 
    
    /** The SchemaElement (ITable,IField or IIndex) of the partition */
    define public property Element       as ISchemaElement no-undo get.  
    
    /** The Area of the partition - readonly when the partition is allocated */
    define public property Area          as IArea     no-undo get. set.    
    
end interface.