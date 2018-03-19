
/***************************************************************************
 * Copyright (c)  2017 by Progress Software Corporation. All rights reserved.
****************************************************************************/

/*--------------------------------------------------------------------------
    File        : UpdateModeEnum
    Purpose     : Update modes supported by abstract BusinessEntity
    Syntax      : 
    Description : 
    Author(s)   : Maura Regan
    Created     : Tue May 23 09:18:45 EST 2017
    Notes       : 
  -------------------------------------------------------------------------*/
  
  
/* BusinessEntity now supports 4 modes on how updates are performed:
 *
 * TRANSACTIONAL_SUBMIT: Entire changeset is processed as single transaction
 * BULK_SUBMIT:          Each row change is processed as a separate transaction
 * CUD:                  Client makes individual call to create, update or delete operation
 * CUD_NOBI:             Client makes individual call to create, update or delete operation, but
 *                       does not send/receive any BI data as part of request/response

 */ 


BLOCK-LEVEL ON ERROR UNDO, THROW.

ENUM OpenEdge.BusinessLogic.UpdateModeEnum:
    DEFINE ENUM         UNDEFINED
                        TRANSACTIONAL_SUBMIT
                        BULK_SUBMIT
                        CUD
                        CUD_NOBI
                        .
END ENUM.
