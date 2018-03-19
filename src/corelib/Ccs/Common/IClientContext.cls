/*------------------------------------------------------------------------
  This Software is licensed by Progress Software Corporation (licensor)
  under the Progress Software Common Component Specification Project
  Release License Agreement available at
  https://community.progress.com/products/directions/common_component/p/releaselicenseagreement

  The Interface definition is part of the Common Component Specification [CCSBE01]. The
  file is considered as a Specification Implementation Condition as described
  in section 2.1.1.1: If Licensor has made Specification Implementation
  Conditions available as of the date Licensee completes its Independent
  Implementation, then Licensee must, prior to making any claim that its
  Independent Implementation complies with the Specification, ensure that
  the Independent Implementation satisfies all of the Specification
  Implementation Conditions. If Licensor subsequently makes available or
  updates, from time to time, the Specification Implementation Conditions,
  then Licensee will verify that its Independent Implementation satisfies the
  latest version of the Specification Implementation Conditions within ninety
  (90) days following Licensor's release thereof.

  Contributors:
    Peter Judge, Progress Software Corp [2017]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : IClientContext
    Purpose     : Session Management Client Context interface
    Author(s)   : pjudge@progress.com
    Created     : 2017-03-02 
    Notes       : * The Client Context object represents the client context data for the client making the request.  
                    The current Client Context object is instantiated and made available by the Session Manager.
                    The Session Manager must allow for the application to supply the implementation of the Ccs.Common.IClientContext interface
  ----------------------------------------------------------------------*/
USING Ccs.Common.IService.

INTERFACE Ccs.Common.IClientContext:

    /* A unique ID for the Client Context object. */
    DEFINE PUBLIC PROPERTY contextID AS CHARACTER NO-UNDO GET.
    
    /* The handle to the client's Client Principal object */
    DEFINE PUBLIC PROPERTY clientPrincipal AS HANDLE NO-UNDO GET.
  
    /* Initialize the context data for the Client Context object 
       
       @param handle The handle to the Client Principal object for the client request
       @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID initializeConext( INPUT phClientPrincipal AS HANDLE ).

    /* Initialize the context data for the Client Context object 
       
       @param character The known Session ID for the client request
       @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID initializeConext( INPUT pcSessionID AS CHARACTER ).

    /* Save the context data to a persistent store 
       
       @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID saveContext( ).

END INTERFACE.
