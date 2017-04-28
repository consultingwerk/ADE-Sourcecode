/*************************************************************/
/* Copyright (c) 2016-201 by Progress Software Corporation   */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/ 

/*------------------------------------------------------------------------ 
    File        : CDCOperation
    Purpose     : Provides an enumeration member for each of the possible 
                  CDC _Operation values.
    Syntax      :
    Description :
    Authors     :
  ----------------------------------------------------------------------*/


ENUM OpenEdge.DataAdmin.Util.CDCOperation:
  DEFINE ENUM 
      Invalid = 0
      Create = 1
      Delete = 2
      BeforeUpdate = 3
      AfterUpdate = 4
      FieldDelete = 5
      PartitionDrop = 6
      PartitionTruncate = 7
      PartitionDeallocate = 8
      MTPartitionDeallocate = 9
      MTPartitionDrop = 10
      MergePartitionDrop = 11
      FieldAdd = 12
      .
END ENUM.
