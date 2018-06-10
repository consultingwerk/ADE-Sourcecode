/*************************************************************/
 /* Copyright (c) 2011 by progress Software Corporation.      */
 /*                                                           */
 /* all rights reserved.  no part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from progress Software Corporation. */
 /*************************************************************/
/** ------------------------------------------------------------------------
    Purpose     : Interface for table fetch request  
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Feb 09 18:28:13 EST 2010
    Notes       : This is similar to IPageRequest except that there is 
                  no Add to add child requests   
 ---------------------------------------------------------------------- */

using Progress.Lang.* from propath.
using OpenEdge.DataAdmin.IRequestInfo from propath.
  
interface OpenEdge.DataAdmin.Message.ITableRequest  : 
    define property Name   as char no-undo get.
    define property QueryString as char no-undo get. set.
    define property SearchString as char no-undo get. set.
    
    /** The number of records to return per page or batch */
    define property PageSize as integer no-undo get. set.
                     
    /* single row request use keyfield and keyvalue */
    define property KeyField as char no-undo get. set. 
    define property KeyValue as char no-undo get. set.
    /* Set to true if the client will do a second request 
       to get related data before export 
       This is a cover-up for the fact that (perhaps a design flaw) 
       related one-to-one data is exported as <parent>Name
       (for example AreaName of Table) and thus 
       require the data access/source to resolve those relations
       in cases where the name is not the primary key (99/100% of cases in
       Progress Schema)
       Note that the objects do not suffer from this as they will
       always return the Object (possible exceptions in Cdc because ..??. )
       So to not let pure ABL clients suffer from the overhead of 
       retrieving related data this is passed to the source to allow it 
       to skip those name fields. 
       The DataSource may or may not support this. The support of this need 
       to be implemented both in client and source.    
       */
    
    define property Lazy     as logical no-undo get. set.

    /** context info/key for where to start appending page begin or end */
/*    define property PageContext as char    no-undo get. set.*/
    define property Start      as integer no-undo get. set.
     
end interface.