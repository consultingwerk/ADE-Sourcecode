 /*************************************************************/
  /* Copyright (c) 2010 by progress Software Corporation.      */
  /*                                                           */
  /* all rights reserved.  no part of this program or document */
  /* may be  reproduced in  any form  or by  any means without */
  /* permission in writing from progress Software Corporation. */
  /*************************************************************/
 /*------------------------------------------------------------------------
    File        : _iview
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface prodict.pro._iview: 
    method public void View(  ).
    method public void Hide(  ).
    method public void Enable(  ).
    method public void Disable(  ).
    method public void Display(  ).    
    method public void Init(  ).
    method public void Close():
    method public void Cancel():
    method public void Ok():
    method public void ShowSort(pccolumn as char  ).    
      
  
    method public logical Wait(  ).  
end interface.