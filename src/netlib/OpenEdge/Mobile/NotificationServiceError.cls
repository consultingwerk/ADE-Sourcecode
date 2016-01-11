/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : NotificationServiceError
    Purpose     : Application error for notification service errors. 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 20 14:50:50 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Mobile.NotificationServiceError.
using Progress.Lang.Error.

class OpenEdge.Mobile.NotificationServiceError inherits ApplicationError: 

    constructor static NotificationServiceError ():
        ApplicationError:AddError(
            get-class(NotificationServiceError),
            /* short message */
            'Error code: &2 (status: &1)',
            /* message */
            '&3 (error code: &2)').
    end constructor.
    
    constructor public NotificationServiceError(input pcStatusCode as character,
                                                input pcCode as character,
                                                input pcDescription as character):
        this-object(pcStatusCode,
                    pcCode,
                    pcDescription,
                    ?).
    end constructor.
    
    constructor public NotificationServiceError(input pcStatusCode as character,
                                                input pcCode as character,
                                                input pcDescription as character,
                                                input poInnerError as Error):
        super(poInnerError).
        
        AddMessage(pcStatusCode, 1).
        AddMessage(pcCode, 2).
        AddMessage(pcDescription, 3).
    end constructor.
    
end class.