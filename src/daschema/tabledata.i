/*************************************************************/
/* Copyright (c) 2012 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : tabledata.i
    Author(s)   : rkumar
    Created     :  
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
 define protected temp-table ttTableData no-undo serialize-name "tables"  {1}  
     field Name       as character serialize-name "Name"   
     {daschema/entity.i}
     index idxName as unique primary Name.
    