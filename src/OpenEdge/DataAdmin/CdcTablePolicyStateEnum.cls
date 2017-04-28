 /* ***********************************************************/
 /* Copyright (c) 2016 by Progress Software Corporation       */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : CdcTablePolicyStateEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Jan 25 18:40:27 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

enum OpenEdge.DataAdmin.CdcTablePolicyStateEnum:
    define enum         
               Active       = 0
               Inactive     = 1
               Drop         = 2
               .
end enum.
