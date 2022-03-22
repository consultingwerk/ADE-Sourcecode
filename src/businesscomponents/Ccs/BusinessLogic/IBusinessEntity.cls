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
    Mike Fechner, Consultingwerk [2016]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : IBusinessEntity
    Purpose     : CCSBE 1.0 Interface for Business Entities
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 18:49:41 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

INTERFACE Ccs.BusinessLogic.IBusinessEntity
    INHERITS Ccs.Common.IService:

    /*------------------------------------------------------------------------------
        Purpose: Returns an empty instance of the primary ProDataset to the caller
        Notes:   Used for catalog generation or initialization of dynamic user
                 interfaces etc.
        @param phDataset OUTPUT Dataset (not intended to be called BY-REFERENCE)
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID getDataset (OUTPUT DATASET-HANDLE phDataset).

    /*------------------------------------------------------------------------------
        Purpose: Performs a read request
        Notes:
        @param poRequest The IGetDataRequest instance with the getData request parameters
        @param phDataset OUTPUT Dataset
        @return The IGetDataResponse instance
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC Ccs.BusinessLogic.IGetDataResponse getData (poRequest AS Ccs.BusinessLogic.IGetDataRequest,
                                                              OUTPUT DATASET-HANDLE phDataset).

    /*------------------------------------------------------------------------------
        Purpose: Returns the count of the total number of result records or a guess
                 of the result count to the caller
        Notes:
        @param poRequest The IGetDataRequest instance with the getResultCount request parameters
        @return The IGetResultCountResponse instance
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC Ccs.BusinessLogic.IGetResultCountResponse getResultCount (poRequest AS Ccs.BusinessLogic.IGetDataRequest).

END INTERFACE.
