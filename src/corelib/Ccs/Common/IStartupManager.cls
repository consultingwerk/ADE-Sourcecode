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
    File        : IStartupManager
    Purpose     : Startup Manager interface
    Author(s)   : pjudge@progress.com
    Created     : 2017-03-13 
    Notes       : 
  ----------------------------------------------------------------------*/
USING Ccs.Common.IManager FROM PROPATH.
USING Ccs.Common.IServiceManager FROM PROPATH.
USING Ccs.Common.ISessionManager FROM PROPATH.

INTERFACE Ccs.Common.IStartupManager INHERITS IManager:
  
  /*------------------------------------------------------------------------------
  Purpose: Retrieve an instance of the specified IManager object.
  Notes: If a manager is not configured, no error should be raised, but if it is
         configured and fails to load, an exception must be raised. 
  @param pServiceType The Progress.Lang.Class repersenting the required service.
  @return IManager implementation of the requested type, or ? if its not configured.
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC IManager getManager ( pServiceType AS Progress.Lang.Class ).

END INTERFACE.
