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
    File        : IUpdatableBusinessEntity
    Purpose     : CCSBE 1.0 Interface for Business Entities with support to
                  update data
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 18:49:41 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.BusinessLogic.* FROM PROPATH .

INTERFACE Ccs.BusinessLogic.IUpdatableBusinessEntity
    INHERITS IBusinessEntity:

    /*------------------------------------------------------------------------------
        Purpose: Stores data modifications in the persistent storage (typically a
                 database)
        Notes:   The output dataset will contain validation error messages in the
                 ERROR-STRING attributes of the record buffers. Records with Errors
                 will also have the ERROR attribute set to TRUE. When at least a single
                 record has a validation error, the ERROR attribute of the ProDataset
                 is assigned to TRUE as well
        @param phDataset INPUT-OUTPUT Dataset containing modified records to be processed (should be passed BY-REFERENCE)
        @param poUpdateDataRequest The optional request object that allows to provide custom instructions to the method
        @return An optional response object returned by the method
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC Progress.Lang.Object updateData (INPUT-OUTPUT DATASET-HANDLE phDataset,
                                                   poUpdateDataRequest AS IUpdateDataRequest).

END INTERFACE.
