/* ***********************************************************/
/* Copyright (c) 2010 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _oeidepalette.p
    Purpose     : dump palette and custom to xml for ide 
    
    Syntax      :

    Description : 
    Parameters  : path = directory
                  palette = palette xml file name (blank = no export)
                  custom = custom xml file name (blank = no export)
    Author(s)   : hdaniels
    Created     : Thu Feb 12 23:43:38 EST 2009
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
{adeuib/custwidg.i}
define input parameter pcPath as character     no-undo.
define input parameter pcPalette as character  no-undo.
define input parameter pcCustom as character   no-undo.

define variable exportHandle as handle no-undo.

pcPath = replace(pcPath,"~\":U,"/":U).

if r-index(pcPath,"/":U) <> length(pcPath) then
  pcPath = pcPath + "/":U.


if search(pcPath) = ? then
    os-create-dir value(pcPath).

if pcPalette > "" then 
do:  
    exportHandle = buffer _palette_item:handle.
    exportHandle:write-xml("file", pcPath + pcPalette,false,?,?,false,false).
end.

if pcCustom > "" then 
do:
    exportHandle= buffer _custom:handle.
    exportHandle:write-xml("file", pcPath + pcCustom,false,?,?,false,false).
end. 