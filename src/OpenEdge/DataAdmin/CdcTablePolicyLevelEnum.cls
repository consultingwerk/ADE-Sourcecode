 /* ***********************************************************/
 /* Copyright (c) 2016 by Progress Software Corporation       */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : CdcTablePolicyLevelEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Jan 25 19:29:25 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

enum OpenEdge.DataAdmin.CdcTablePolicyLevelEnum:
    define enum 
               Minimal        = 0
               MinimalWithBitmap     
               Medium      
               Maximum     
               .
end enum.