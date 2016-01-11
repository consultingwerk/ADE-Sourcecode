/*************************************************************/
/* Copyright (c) 2010 by progress Software Corporation       */
/*                                                           */
/* all rights reserved.  no part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : area.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : hdaniels
    Created     : Sat Apr 03 23:35:34 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
define temp-table ttSchema no-undo serialize-name "schemas" {1}
         field Name       as char format "x(20)" label "Name" serialize-name "name"
         field TablesUrl  as char serialize-name "tables_url"
        /* field HRef as integer */
         {daschema/entity.i}
           
         index idxName as primary unique Name. 