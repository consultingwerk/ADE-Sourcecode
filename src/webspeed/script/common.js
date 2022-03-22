/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  var isIE4up, isNav4up;
  
  function getBrowser() {
    /*-----------------------------------------------------------------------
      Purpose:     Sets a flag indicating the web browser type.
      Parameters:  
      Notes:       
    -------------------------------------------------------------------------*/
    if (parseInt(navigator.appVersion) >= 4) {
      if (document.all)
        isIE4up  = true;
      else if (document.layers)
        isNav4up = true;
    }
  }
  
  function getUnknown() {
    /*-----------------------------------------------------------------------
      Purpose:     Return web browser's unknown value.
      Parameters:  
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      return null;
    else if (isNav4up)
      return undefined;
  }
  
  function setColor(cFile, cColor) {
    /*-----------------------------------------------------------------------
      Purpose:     Rebuilds the File Open/Save filelist for Netscape Navigator.
      Parameters:  
      Notes:       
    -------------------------------------------------------------------------*/
    if (cColor == "") cColor = "black";
    
    return '<BODY TEXT="' + cColor + '">' +
           '<FONT FACE="sans-serif" POINT-SIZE="9"> ' + cFile + 
           ' <\/FONT><\/BODY>';
  }
  
