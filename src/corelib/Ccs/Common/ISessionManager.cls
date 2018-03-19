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
    Peter Judge, Progress Software Corp [2016]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : ISessionManager
    Purpose     : Base Session Manager interface
    Author(s)   : pjudge@progress.com
    Created     : 2017-03-02 
    Notes       : 
  ----------------------------------------------------------------------*/
USING Ccs.Common.IManager.
USING Ccs.Common.IClientContext.

INTERFACE Ccs.Common.ISessionManager INHERITS IManager:
    
    /* Holds the reference to the current ClientContext object. This property will be unknown unless there is a valid client request. */
    DEFINE PUBLIC PROPERTY CurrentClientContext AS IClientContext NO-UNDO GET.
    
    /* Establish the server session runtime.
       
       @param handle The handle to the Client Principal object representing the client’s session identity 
       @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID establishRequestEnvironment( INPUT phClientPrincipal AS HANDLE ).
    
    /* Establish the server session runtime.
       
       @param character A known string representing the client’s session identity 
       @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID establishRequestEnvironment( INPUT pcSessionID AS CHARACTER ).

    /* “End” the server session runtime and return it to a “safe” state.
        
        @throws Progress.Lang.SysError, Progress.Lang.AppError */
    METHOD PUBLIC VOID endRequestEnvironment( ).

END INTERFACE.
