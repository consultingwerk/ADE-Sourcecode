/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
  var colLeft   = new Array();
  var colWidth  = new Array();
  var coords    = new Array();
  var cString;
  var lastDate;
  var lastTime;
  var lDblClick;
  var maxWidth  = 0;
  var winWidth  = 0;
  var oldCell;

  function autoGo() {
    /*-----------------------------------------------------------------------
      Purpose:     Redirect the Enter key to the Open or Save button in the
                   bottom OS_fname frame.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    parent.OS_fname.autoGo();
    return false;
  }
  
  function dblClick(e) {
    if (isIE4up)
      parent.OS_fname.defaultBtn.click();
    else if (isNav4up)
      parent.OS_fname.btnClick(parent.OS_fname.document.form1.elements["btnOpen"]);
  }

  function highlight(e) {
    if (isIE4up) {
      e.style.color      = "white";
      e.style.background = "navy";
    }
    else if (isNav4up) {
      /* Rewrite the filename layer with the highlight foreground color. */
      e.document.write(setColor(e.name, "white"));
      e.document.close();

      e.bgColor = "navy";
    }
  }

  function init() {
    getBrowser();
    
    if (isIE4up) {
      var tds = document.all.tags("TD");
      for (ix = 0; ix <= (tds.length - 2); ix++) {
        var e    = tds.item(ix);
        maxWidth = Math.max(maxWidth, e.offsetWidth);
      }
      for (ix = 0; ix <= (tds.length - 2); ix++) {
        var e = tds.item(ix);
        e.style.pixelWidth = maxWidth;
      }
      document.all.fileList.style.cursor = "default";
      setDir();
    }
    else if (isNav4up) {
      setDir();
      setGrid();
      setCoord();

      /* Setup mouse event capturing. */
      document.captureEvents(Event.MOUSEDOWN);
      document.onmousedown = mouseDownEvent;
    }
  }

  function mouseDownEvent(evt) {
    var idx     = 0;
    /* User clicked right mouse button. */
    if (evt.which == 3) 
      return true;

    /* Two consecutive mousedown events very close together count as a dblclick. */
    if (lastTime != undefined) {
      var thisDate = new Date();
      var diffTime = thisDate.getTime() - lastTime;
      if (diffTime <= 250)
        lDblClick = true;
    }
    lastDate = new Date();
    lastTime = lastDate.getTime();
    
    /* Loop through row layers. */
    rowLoop:
    for (iy = 0; iy < document.layers.length; iy++) {
      /* Loop through column layers. */
      colLoop:
      for (ix = 0; ix < document.layers[iy].document.layers.length; ix++) {
        var fileObj = document.layers[iy].document.layers[ix];
        var sCoord  = new String(coords[idx]);
        var aCoord  = sCoord.split(",");
        
        /* We found the filename that was clicked. */
        if (evt.pageX >= aCoord[0] && evt.pageX <= aCoord[2] &&
            evt.pageY >= aCoord[1] && evt.pageY <= aCoord[3]) {
          parent.OS_fname.document.form1.elements["fileName"].value = fileObj.name; 
          break rowLoop;
        }
        idx++;
      }
    }
    updateName(fileObj);
    if (lDblClick) 
      dblClick(fileObj);
      
    return false;
  }

  function normal(e) {
    if (isIE4up) {
      e.style.color      = "black";
      e.style.background = "white";
    }
    else if (isNav4up) {
      /* Rewrite the filename layer with the highlight foreground color. */
      e.document.write(setColor(e.name, "black"));
      e.document.close();

      e.bgColor = "white";
    }
  }

  function resetCell(e) {
    if (isIE4up) {
      if (oldCell != null) 
        normal(oldCell);
    }
    else if (isNav4up) {
      if (oldCell != undefined) 
        normal(oldCell);
    }
    oldCell = e;
  }

  function setCoord() {
    /* Setup coords[] array.  This will help later when the user clicks at a
       X-Y position in the frame and we want to know what layer is there. */
    var idx     = 0;
    var leftCol = 5;
    
    /* Loop through row layers. */
    for (iy = 0; iy < document.layers.length; iy++) {
      /* Loop through column layers, setting X-coordinate. */
      for (ix = 0; ix < document.layers[iy].document.layers.length; ix++) {
        var fileObj  = document.layers[iy].document.layers[ix];
        fileObj.left = colLeft[ix];
        
        /* Setup for mouse event handling. */
        coords[idx]  = fileObj.pageX + "," +
                       fileObj.pageY + "," +
                      (fileObj.pageX + colWidth[ix]) + "," +
                      (fileObj.pageY + 15);
        idx++;
      }
      document.layers[iy].visibility = "inherit";
    }
  }

  function setDir(cDir) {
    /* Update the Directory value in the top frame. */
    if (isIE4up)
      parent.OS_dname.document.all.lDirectory.innerText = cNewDir;
    else if (isNav4up) {
      cString = '<FONT FACE="sans-serif" POINT-SIZE="9"> ' + cNewDir + 
                '<\/FONT>';
      parent.OS_dname.document.lDirectory.document.write(cString);
      parent.OS_dname.document.lDirectory.document.close();
      
    }
  }
  
  function setGrid() {
    /* Assign each directory and/or file to a X-grid position. */
    
    /* Loop through row layers. */
    for (iy = 0; iy < document.layers.length; iy++) {
      var rowObj = document.layers[iy];
      
      /* Loop through column layers, setting the maximum column width. */
      for (ix = 0; ix < rowObj.document.layers.length; ix++) {
        var fileObj  = rowObj.document.layers[ix];
        colWidth[ix] = Math.max(colWidth[ix], fileObj.clip.right);
      }
    }
    
    /* Loop through row layers. */
    for (iy = 0; iy < document.layers.length; iy++) {
      var rowObj = document.layers[iy];
      maxWidth   = 0;
    
      /* Loop through column layers, setting the 'left' coordinate. */
      for (ix = 0; ix < rowObj.document.layers.length; ix++) {
        colLeft[ix] = (ix == 0 ? 5 : colLeft[ix - 1] + colWidth[ix - 1] + 10);
        maxWidth   += colLeft[ix] + colWidth[ix];
      }
      document.layers[iy].clip.right = maxWidth + 10;
    }
    
    /* Resize the file list frame.
    cString = '<TABLE WIDTH=' + 100 + 
              '><TR><TD>&nbsp;</TD></TR></TABLE>';
    document.dummy.document.write(cString);
    document.dummy.clip.width = document.layers[0].clip.width;
    document.dummy.document.close();
    */
  }
  
  function updateName(e) {
    resetCell(e);
    highlight(e);
    if (isIE4up) {
      /* Strip off trailing '&nbsp;' blanks. */
      while ((e.innerText.length > 1) && 
             (e.innerText.charCodeAt(e.innerText.length - 1) == 32)) {
        e.innerText = e.innerText.substr(0, (e.innerText.length - 1));
      }
      parent.OS_fname.form1.fileName.value = e.innerText;
    }
  }
