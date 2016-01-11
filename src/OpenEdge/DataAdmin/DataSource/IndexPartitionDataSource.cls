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
 
class OpenEdge.DataAdmin.DataSource.IndexPartitionDataSource inherits PartitionDataSource: 
     
     define protected property StorageIndexMap as char no-undo
        init "ttPartition.IndexName,_Index._Index-name"
        get. 
          
    constructor public IndexPartitionDataSource (hchanges as handle ):     
        super (hchanges,"_File,_Index","dictdb._File,dictdb._Index", StorageFileMap + "," + StorageIndexMap).
        BaseQuery = "for each ttIndexChange," 
                  + " each _file where _file._file-name = ttIndexChange.Tablename and " + DatabaseInfo:FileExpression + " no-lock,"
                  + " each _Index of _file  where _index._Index-Name = ttIndexChange.IndexName no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageIndexJoin + " no-lock".
    end constructor.
    
    constructor public IndexPartitionDataSource (hchanges as handle,pfilejoin as char,pStoragejoin as char ):     
        super (hchanges,"_File,_Index","dictdb._File,dictdb._Index", StorageFileMap + "," + StorageIndexMap).
        BaseQuery = "for each " +  hchanges:name + "," 
                  + " each _file where " + pFilejoin + " and " + DatabaseInfo:FileExpression + " no-lock,"
                  + " each _Index of _file no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageIndexJoin + " and " + pStoragejoin + " no-lock".
    end constructor.
    
    constructor public IndexPartitionDataSource (hchanges as handle,pfilejoin as char):     
         this-object(hchanges,pfilejoin,DatabaseInfo:StorageIndexJoin).
    end constructor.
    
	constructor public IndexPartitionDataSource ( ):	    
		super ("_File,_Index","dictdb._File,dictdb._Index",StorageFileMap + "," + StorageIndexMap).
		BaseQuery = "for each _file where " + DatabaseInfo:FileExpression + " no-lock,"
		          + " each _Index of _file no-lock," 
                  + " each _StorageObject where " + DatabaseInfo:StorageIndexJoin + " no-lock".
    end constructor.
    
             
end class.