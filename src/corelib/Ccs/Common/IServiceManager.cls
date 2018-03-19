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
    File        : IServiceManager
    Purpose     : Base Service Manager interface
    Author(s)   : pjudge@progress.com
    Created     : 2016-09-26 
    Notes       : 
  ----------------------------------------------------------------------*/

interface Ccs.Common.IServiceManager inherits Ccs.Common.IManager:
    /* Returns a usable instance of the requested service.
       
       @param P.L.Class The service name requested
       @return P.L.Object A usable instance 
       @throws P.L.AppError Thrown when no implementation can be found */
    method public Progress.Lang.Object getService(input poService as class Progress.Lang.Class).  
    
    /* Returns a usable instance of the requested service.
       
       @param P.L.Class The service name requested
       @param ILifecycleScope A requested scope. The implementation may choose to ignore this value. 
       @return P.L.Object A usable instance 
       @throws P.L.AppError Thrown when no implementation can be found */
    method public Progress.Lang.Object getService(input poService as class Progress.Lang.Class,
                                                  input poScope as Ccs.ServiceManager.ILifecycleScope).
    
    /* Returns a usable instance of the requested service.
       
       @param P.L.Class The service name requested
       @param character An alias for the service. The implementation may choose to ignore this value.
       @return P.L.Object A usable instance 
       @throws P.L.AppError Thrown when no implementation can be found */
    method public Progress.Lang.Object getService(input poService as class Progress.Lang.Class,
                                                  input pcAlias as character).
    
    /* Destroys and flushes from any cache(s) objects scoped to the argument scope.
       
       @param ILifecycleScope A requested scope for which to stop services. */
    method public void stopServices(input poScope as Ccs.ServiceManager.ILifecycleScope).  
    
end interface.