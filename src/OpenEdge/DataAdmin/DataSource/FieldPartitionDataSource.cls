/*************************************************************/
/* Copyright (c) 2010,2011 by progress Software Corporation. */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/ 
 /*------------------------------------------------------------------------
    File        : FieldPartitionDataSource
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
 
using OpenEdge.DataAdmin.DataSource.PartitionDataSource from propath.
 
class OpenEdge.DataAdmin.DataSource.FieldPartitionDataSource inherits PartitionDataSource: 
     
    define protected property StorageFieldMap as char no-undo
        init "ttPartition.FieldName,_Field._Field-name"
        get. 
          
    constructor public FieldPartitionDataSource (hchanges as handle ):     
        this-object(hchanges,"_file._file-name = ttFieldChange.Tablename").
        /*
        super (hchanges,"_File,_Field","dictdb._File,dictdb._Field", StorageFileMap + "," + StorageFieldMap).
        BaseQuery = "for each ttFieldChange," 
                  + " each _file where _file._file-name = ttFieldChange.Tablename and " + DatabaseInfo:FileExpression + " no-lock,"
                  + " each _field of _file  where _Field._Field-Name = ttFieldChange.FieldName no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageFieldJoin + " no-lock".
        */
    end constructor.
    
    constructor public FieldPartitionDataSource (hParentBuffer as handle,pfilejoin as char,pStoragejoin as char ):     
         super (hParentBuffer,"_File,_Field","dictdb._File,dictdb._Field", StorageFileMap + "," + StorageFieldMap).
         BaseQuery = "for each " +  hParentBuffer:name + "," 
                  + " each _file where " + pFilejoin + " and " + DatabaseInfo:FileExpression + " no-lock,"
                  + " each _field of _file no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageFieldJoin + " and " + pStoragejoin + " no-lock".
    end constructor.
    
    constructor public FieldPartitionDataSource (hchanges as handle,pfilejoin as char):     
         this-object(hchanges,pfilejoin,DatabaseInfo:StorageFieldJoin).
    end constructor.
    
    
	constructor public FieldPartitionDataSource ( ):	    
		super ("_File,_Field","dictdb._File,dictdb._Field",StorageFileMap + "," + StorageFieldMap).
		BaseQuery = "for each _file where " + DatabaseInfo:FileExpression + " no-lock,"
		          + " each _field of _file where _field._data-type = 'clob' or _field._data-type = 'blob' no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageFieldJoin + " no-lock".
    end constructor.
    
             
end class.