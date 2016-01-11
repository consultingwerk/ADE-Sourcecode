/*************************************************************/
/* Copyright (c) 2011 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : administrator.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : 
    Notes       :
  ----------------------------------------------------------------------*/
define temp-table ttAdministrator no-undo serialize-name "administrators" {1} before-table ttAdministratorCopy
         /* this class is keyless as there is only one record, but we need a key 
            for the dataset and context (we keep it blank and use find(""))  */
         field Name           as char serialize-hidden 
         field Administrators as char serialize-name "administrators"
         {daschema/entity.i}           
         index idxName as primary unique Name. 