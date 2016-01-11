/* ***********************************************************/
/* Copyright (c) 2010 by Progress Software Corporation       */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from Progress Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _oeidewidgets.p
    Purpose     : dump window widgets 
    
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
{adeuib/uniwidg.i}
{adeuib/sharvars.i}

define input parameter pcPath as character no-undo.
define input parameter pcfilename as character no-undo.
define input parameter phWin  as handle    no-undo.

define variable exportHandle as handle no-undo.

define temp-table ttwidget serialize-name "Widgets"
     field ParentName as char
     field Name as char 
     field widgetLabel as char serialize-name "Label" 
     field Type as char
     index idxparent as unique parentname name.
     
define dataset dsWidget for ttWidget
    data-relation for ttwidget,ttwidget  relation-fields(parentname,name) recursive   . 

function findWidgetName return character (WidgetParentrecId as recid) in _h_uib. 
           
pcPath = replace(pcPath,"~\":U,"/":U).

if r-index(pcPath,"/":U) <> length(pcPath) then
  pcPath = pcPath + "/":U.

if search(pcPath) = ? then
    os-create-dir value(pcPath).
run exportU.

procedure exportU:
   define buffer b_u for _u.
   define buffer p_u for _u.
   define buffer b_p for _p.
   define buffer b_f for _F.
   
   define variable cName   as character no-undo.
   
   find b_p where b_P._WINDOW-HANDLE =  phwin.
   
      /* Should use local var instead of _wid-list */
   FOR EACH b_U WHERE (NOT (b_U._NAME BEGINS "_LBL":U
                        OR (b_U._TYPE eq "WINDOW":U AND
                            b_U._SUBTYPE eq "Design-Window":U)))
                AND b_U._STATUS EQ "NORMAL":U
/*                AND CAN-DO(_wid-list,b_U._TYPE)*/
                AND (b_U._WINDOW-HANDLE eq b_P._WINDOW-HANDLE /* _h_win */),
      EACH p_U WHERE RECID(p_U) = b_U._PARENT-RECID:
/*           BY b_U._WINDOW-HANDLE                     */
/*           BY IF b_U._TYPE = "WINDOW":U THEN 1 ELSE 2*/
/*           BY IF CAN-DO("FRAME,DIALOG-BOX",b_U._TYPE)*/
/*                           THEN 1 ELSE 2             */
/*           BY p_U._NAME                              */
/*           BY b_U._NAME:                             */
     
     cName = findWidgetName(recid(b_u)).
     create ttwidget.
     assign
        ttWidget.name = cName
        ttWidget.parentname = p_u._name    
        ttWidget.type = b_u._type
        ttWidget.widgetLabel = b_u._LABEL. 
        
   end. 
   pcfilename = if index(pcFilename,".") > 1 then pcfilename else pcfilename + ".xml":U.

   dataset dsWidget:write-xml("file", pcPath + pcfilename ,false,?,?,false,false).
       
end procedure.     
