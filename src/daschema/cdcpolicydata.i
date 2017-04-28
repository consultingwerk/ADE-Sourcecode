/*************************************************************/
/* Copyright (c) 2016 by Progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : cdcpolicydata.i
    Author(s)   : mkondra
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define protected temp-table ttCDCPolicyData no-undo serialize-name "cdcpolicies"  {1}  
     field Name       as character serialize-name "Name"   
     {daschema/entity.i}
     index idxName as unique primary Name.
    