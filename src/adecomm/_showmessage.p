/*************************************************************/
/* Copyright (c) 2014 by Progress Software Corporation.      */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _showmessage.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Nov 25 14:59:22 EST 2014
    Notes       : This is used internally by _s-alert2.p (and _s-alert.p)
                  Can be used directly, but does not call Eclipse
                - This does not mess with the output to make cancel 
                  return ?  when less than 3 buttons...  
                  (Bad/weird behavior in _s-alert.p)    
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using Progress.Lang.AppError from propath.

define input  parameter pMsgText    as character no-undo. 
define input  parameter pMsgType    as character no-undo.
define input  parameter pMsgTitle   as character no-undo.
define input  parameter pMsgButtons as character no-undo.
define input  parameter pWinHandle  as handle    no-undo.
 
define input-output parameter pValue as logical no-undo.


&scoped-define MessageField pMsgText 
&scoped-define ValueField pValue  
&scoped-define TypeField pMsgType
&scoped-define ButtonsField pMsgButtons
&scoped-define ErrorClass AppError ("Invalid type or button options passed to message procedure.")

if pMsgtitle = ? or pMsgtitle = "?" /* supported by the code that this replaces */ then 
do:
    if valid-handle(pWinHandle) then
    do: 
        {adecomm/messagecases.i &HandleField=pWinHandle}
    end.
    else do:
        {adecomm/messagecases.i}
    end.    
end.
else do:
    if valid-handle(pWinHandle) then
    do: 
        {adecomm/messagecases.i &Titlefield=pMsgtitle &Handlefield=pWinHandle}
    end.
    else do:
        {adecomm/messagecases.i &Titlefield=pMsgtitle}
    end.
end.



 