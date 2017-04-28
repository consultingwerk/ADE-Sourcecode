 /* ***********************************************************/
 /* Copyright (c) 2016 by Progress Software Corporation       */
 /*                                                           */
 /* All rights reserved.  No part of this program or document */
 /* may be  reproduced in  any form  or by  any means without */
 /* permission in writing from Progress Software Corporation. */
 /*************************************************************/
 /*------------------------------------------------------------------------
    File        : CdcTablePolicyInstanceEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mkondra
    Created     : Mon Jan 25 19:26:04 IST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

enum OpenEdge.DataAdmin.Internal.Util.CdcTablePolicyInstanceEnum:
    define enum         
                Current     = 0
                Previous    = 1
                Pending     = 2
                .
end enum.