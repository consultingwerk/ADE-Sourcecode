/* ***********************************************************/
/* Copyright (c) 2013 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    Purpose     : dataset and temp-table for dump of window widgets  
                  
    Description : 
    Author(s)   : hdaniels
    Created     : June 19 2013
    Notes       : must use no-undo - keep track of what is sent to PDS
                  auto mapping uses undo to cancel and will loose the 
                  info sent during the transaction            
               
               -  Dataset write-xml is supported format in pds 
                  
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define temp-table ttwidget no-undo serialize-name "Widgets" 
     field ParentName as char
     field Id  as int64 serialize-hidden init ?
     field Name as char 
     field widgetLabel as char serialize-name "Label" 
     field Type as char
     index idxparent as unique primary parentname name
     index idxname   name
     index idxid as unique id.
     
define dataset dsWidget for ttWidget
    data-relation for ttwidget,ttwidget  relation-fields(parentname,name) recursive   . 
           
 