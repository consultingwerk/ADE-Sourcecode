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
    File        : Ccs.Common.Application
    Purpose     : Provides a well-known point to find references to specific CCS Manager components.
    Author(s)   : pjudge@progress.com
    Created     : 2017-03-13 
    Notes       : 
  ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.Common.IServiceManager FROM PROPATH.
USING Ccs.Common.ISessionManager FROM PROPATH.
USING Ccs.Common.IStartupManager FROM PROPATH.

CLASS Ccs.Common.Application FINAL:

  /*------------------------------------------------------------------------------
   Purpose: Provides access to the injected IStartupManager.
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE STATIC PUBLIC PROPERTY StartupManager AS IStartupManager NO-UNDO GET. SET.

  /*------------------------------------------------------------------------------
   Purpose: Provides access to the injected IServiceManager.
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE STATIC PUBLIC PROPERTY ServiceManager AS IServiceManager NO-UNDO GET. SET.

  /*------------------------------------------------------------------------------
   Purpose: Provides access to the injected ISessionManager.
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE STATIC PUBLIC PROPERTY SessionManager AS ISessionManager NO-UNDO GET. SET.

  /*------------------------------------------------------------------------------
   Purpose: Version of the Common Component Specification implementation.
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE STATIC PUBLIC PROPERTY Version AS CHARACTER NO-UNDO
    INITIAL '1.0.0':u
    GET.

  /*------------------------------------------------------------------------------
   Purpose: Prevent creation of instances.
   Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PRIVATE Application ():
    SUPER ().
  END CONSTRUCTOR.

END CLASS.
