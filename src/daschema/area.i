/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : area.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Apr 03 23:35:34 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
 
define  temp-table ttArea no-undo  serialize-name "areas" {1} before-table ttAreaCopy
         field Name as char format "x(20)" label "Area" serialize-name "name"
         field Number as integer     init ?             serialize-name "number"
         field Type as character                        serialize-name "type" init "Data"
         field BlockSize as integer                     serialize-name "blockSize"
         field isType2   as logical                     serialize-name "isType2"
         field ClusterSize as integer     init 64       serialize-name "clusterSize"
         field RecordsPerBlock as integer init 64       serialize-name "recordsPerBlock"
       
         field URL        as character                  serialize-name "url"
         /* we can use different name since this will never be updated from client */
         field NumExtents as integer                    serialize-name "numExtents"
         field ExtentsURL  as character                 serialize-name "extents_url"
         field PartitionsURL as character               serialize-name "partions_url"
         {daschema/entity.i}
         index idxName as primary unique Name  
         index idxAreaNumber as   unique Number.
          