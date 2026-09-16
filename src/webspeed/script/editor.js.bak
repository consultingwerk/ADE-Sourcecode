/* [WebSpeed dir]/workshop/webedit.js */
  var aboutWindow;
  var bodyBgColor  = "lightgrey";
  var cCoords      = new Array();
  var cDirPath     = "";
  var cDisable     = new String("miCut,miCopy,miPaste,miPrint,miRun,miSyntax," +
                                "miFind,miNext,miPrev,miReplace");
  var cFileName    = "";      
  var cOldFile;
  var cRange       = "";
  var cScrap       = "";
  var cURL;
  var disableColor = "whitesmoke";
  var enableColor  = "black";
  var fileObj;
  var hBarWin;
  var iBegByte;
  var iEndByte;
  var isIE4up, isNav4up;
  var iLoop;
  var iRandom;
  var lCheckSyntax;
  var lDebug       = false;
  var lUntitled    = true;
  var menuActive   = false;
  var menuBgColor  = "lightgrey"; 
  var saveValue    = "";
  function aboutDialog() {
    /*-----------------------------------------------------------------------
      Purpose:     Display the About Editor dialog.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    var aboutWin;
    
    aboutWin = window.open
      ("../webutil/about.w?product=WebSpeed%20Editor","aboutWin", 
       "dependent,height=225,width=325,resizable");
    aboutWin.focus();
  }
    
  function activate(cSubMenu, hMainMenu) {
    /*-----------------------------------------------------------------------
      Purpose:     Activate a drop-down menu.
      Parameters:  cSubMenu  - drop-down menu (string)
                   hMainMenu - main menu (object)
      Notes:       
    -------------------------------------------------------------------------*/
    menuActive = (menuActive == false) ? true : false;
    expand(cSubMenu, hMainMenu);
  }

  function cleanup() {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    if (window.event.srcElement.id == "") 
      hideAll();
  }

  function runFile(cOption) {
    /*-----------------------------------------------------------------------
      Purpose:    check syntax, compile, or run a file
      Parameters: cOption - checkSyntax, compile, or run
      Notes:       
    -------------------------------------------------------------------------*/
    var cAction = "";
    var cArray;
    var cString = new String(cOption);
    var cVerb;
    var hRunWin;
    var iPos;

    /* cOption may be of the form 'compile:okToCompile', so split it apart. */
    cArray  = cString.split(":");
    cOption = cArray[0];
    if (cArray.length > 1)
      cAction = cArray[1];

    if ((getField("txt", "value")) == "") {
      if (cOption == "checkSyntax")
        cOption = "check";
        
      alert("There is nothing to " + cOption + ".");
      return;
    }

    cFileName = getField("fileName", "value");
    saveValue = parent.WS_menu.saveValue;

    if (saveValue != getField("txt", "value") &&
        cOption != "checksyntax" && cOption != "checkSyntax") {
      switch(cOption) {
        case "compile":
          cVerb = "compiling";
          break;
        case "run":
          cVerb = "running";
          break;
      }
      alert("Please save your changes before " + cVerb + ".");
      return;
    }
    
    switch (cOption) {
      case "checkSyntax":
        lCheckSyntax = true;
        fileSave("runFile", cOption);
        break;
      case "run":
        cString = new String(window.location);
        iPos    = cString.indexOf("webedit");  // hack off navmenu.w path
        cURL    = cString.substr(0, iPos) + cFileName;
        hRunWin = window.open(cURL,"runWin");
        hRunWin.focus();
        break;
      default:
        parent.WS_file.location.href = '../webutil/_cpyfile.p' +
                                       '?options=' + cOption + ',editor' +
                                       '&action=' + cAction + 
                                       '&filename=' + cFileName;
    }
  }

  function displayObj(e) {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters:  e - drop-down menu object
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) 
      e.style.display = (e.style.display == "none") ? "" : "none";
    else if (isNav4up) {
      e.visibility    = (e.visibility == "hide") ? "show" : "hidden";
    }
  }
  
  function documentEvent(evt) {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters:  evt - event
      Notes:       
    -------------------------------------------------------------------------*/
    document.routeEvent(evt);
  }
  
  function enableMenu(e) {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters:  e - drop-down menu object
      Notes:       
    -------------------------------------------------------------------------*/
    /* Enable/disable the submenu items. 'e' is the ID of the menu, e.g. mFile,
       mEdit, and represents a <TABLE> object.  Its children <TR> objects need
       to be disabled if not available. */
       
    /* The following are menu items that have not yet been implemented. This 
       needs cleaning up to be dynamic, based on state. */
    if (isIE4up) {
      miPrint.style.color   = disableColor;
      miRun.style.color     = disableColor;
      miSyntax.style.color  = disableColor;
    }
    else if (isNav4up) {
      alert("TBD: [editor.js] enableMenu");
    }
  }
  
  function expand(hSubMenu, hMainMenu) {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters: hSubMenu  - drop-down menu object
                  hMainMenu - main menu object
      Notes:       
    -------------------------------------------------------------------------*/
    hideAll();
    highlight(hMainMenu);

    if (menuActive == false)
      return false;
      
    /* Postion submenu under the main menu. */
    if (isIE4up) {
      displayObj(hSubMenu);
      enableMenu(hSubMenu);

      hSubMenu.style.pixelTop  = toolBar.style.pixelTop - 4;
      hSubMenu.style.pixelLeft = hMainMenu.style.pixelLeft;
    }
    else if (isNav4up) {
      /* Not used
      alert("[expand]\n\nhSubMenu " + hSubMenu + "\n" +
            "hSubMenu.name " + hSubMenu.name + "\n" +
            "new X-Y " + hMainMenu.pageX + "-" + 
            (document.toolBar.document.layers[0].pageY - 4));

      hSubMenu.moveTo(hMainMenu.pageX, 
        document.toolBar.document.layers[0].pageY - 4);

      displayObj(hSubMenu);
      enableMenu(hSubMenu);
      */
    }
    return true;
  }

  function fileChanges(evt, cCaller, cTarget) {
    /*-----------------------------------------------------------------------
      Purpose:     
      Parameters:  evt     - event
                   cCaller - calling function, e.g. fileNew, fileOpen
                   cTarget - destination function, e.g. fileNew, fileOpen
      Notes:       
    -------------------------------------------------------------------------*/
    var cReturn  = false;
    var cText    = getField("txt", "value");
    var cValue   = getField("fileName", "value");
    var hMsgWin;
    var lBeforeUnload;
    var lChanges = (cText != saveValue && cText != "");
    
    cURL     = '../webutil/_webmsgs.w?type=warning&title=Warning' +
               '&context=' + cCaller +
               '&buttons=yes-no-cancel' +
               '&target=' + cTarget +
               '&text=' + escape(cValue + 
               ' has changes which have not been saved.<BR><BR>' +
               'Save changes before closing?');

    if (lChanges) {
      if (isIE4up) {
        if (evt != null) {
          if (evt.type == "beforeunload") 
            return "If you continue you will be prompted to save your changes.";
        }
        else {
          cReturn = window.showModalDialog (cURL, "msgWin", 
             "center=yes;dialogHeight=190px;dialogWidth=325px");
          if (cReturn == "ok" || cReturn == "Ok" || cReturn == "OK" || 
              cReturn == "yes" || cReturn == "Yes")
            fileSave(cCaller, cTarget);
          cReturn = getUnknown(); // 19990724-001
        }
      }
      else if (isNav4up) {
        if (evt != undefined && evt != "") {
          if (evt.type == "unload") 
            return "If you continue, you will be prompted to save your changes.";
        }
        else {
          hMsgWin = window.open(cURL,"msgWin","dependent,height=160,width=325");
          hMsgWin.focus();
          cReturn = getUnknown(); // 19990724-001
        }
      }
    }
    return cReturn;
  }
  
  function fileClose(evt) {
    /*-----------------------------------------------------------------------
      Purpose:     Close the Editor and restore the WebTools splash image.  
      Parameters:  evt   For IE4, evt will be "click".
                         For Nav4, evt will be "undefined" initially, at which 
                         point the "Save your changes?" dialog appears.  The 
                         response to the dialog will appear as the evt value, 
                         i.e. "Yes", "No", "Cancel".
      Notes:       
    -------------------------------------------------------------------------*/
    var cReturn = "";
 
    if (isIE4up) {
      var cReturn = fileChanges(evt, "fileClose", "fileClose");
      if (cReturn != "cancel" && cReturn != "Cancel" && cReturn != null)
        parent.location.href =  "../webtools/welcome.html";
    }
    else if (isNav4up) {
      if (evt == undefined)
        var cReturn = fileChanges(evt, "fileClose", "fileClose");
        
      if (cReturn != getUnknown() && evt != "cancel" && evt != "Cancel")
        parent.location.href = "../webtools/welcome.html";
    }
  }
  
  function fileNew(evt) {
    /*-----------------------------------------------------------------------
      Purpose:     Create a new file.
      Parameters:  evt - event
      Notes:       
    -------------------------------------------------------------------------*/
    var cEvt    = new String(evt);
    var cReturn = "";

    if (cEvt != "ok"  && cEvt != "Ok"  && cEvt != "OK" &&
        cEvt != "yes" && cEvt != "Yes" && 
        cEvt != "no"  && cEvt != "No")
      cReturn = fileChanges(evt, "fileNew", "fileNew");
      
    if (cReturn != "cancel" && cReturn != "Cancel" && cReturn != getUnknown()) {
      cFileName = "Untitled";
      lUntitled = true;
      saveValue = "";
    }
    else return;

    if (isIE4up) {
      parent.WS_edit.form1.reset();
      parent.WS_edit.form1.fileName.value = cFileName;
    }
    else if (isNav4up) {
      formObj = parent.WS_edit.document.layer1.document.form1;
      formObj.elements["txt"].value      = "";
      formObj.elements["fileName"].value = cFileName;
      formObj.elements["dirPath"].value  = "";
    }
    setHeaderTitle();
  }
  
  function fileOpen(cFile) {
    /*-----------------------------------------------------------------------
      Purpose:     Open an existing file.
      Parameters:  cFile - file to open (Netscape Navigator)
      Notes:       
    -------------------------------------------------------------------------*/
    var cReturn = true;
    var hOpenWin;
          
    if (isIE4up) {
      cReturn = fileChanges(event, "fileOpen", "fileOpen");
      if (cReturn == "cancel" || cReturn == "Cancel" || cReturn == null)
        return false;
    }
    else if (isNav4up) {
      if (cFile == undefined)
        cReturn = fileChanges("", "fileOpen", "fileOpen");
        
      if (cReturn == "cancel" || cReturn == "Cancel" || cReturn == undefined)
        return false;      
    }
    cDirPath = getField("dirPath", "value");
    cDirPath = (cDirPath == "  " ? "" : cDirPath);
    cURL     = '../webutil/_osfile.w' +
               '?mode=open' +
               '&directory=' + cDirPath +
               '&title=Open' +
               '&buttons=open-cancel';

    /* File Open dialog */
    if (isIE4up) {
      cFileName = window.showModalDialog(cURL, "fileWin", 
                  "center=yes;dialogHeight=350px;dialogWidth=375px");
      if (cFileName == "" || cFileName == null)
        return false;
        
      parent.WS_edit.form1.fileName.value = cFileName; 
      /* 19990724-004 
         cFileName is returned with "|" separating the directory path from
         the filename, so split it apart and reassemble cFileName without 
         the special character.
      cScrap                              = cFileName.split("|");
      parent.WS_edit.form1.dirPath.value  = cScrap[0];
      parent.WS_edit.form1.fileName.value = cScrap[1];
      cFileName                           = cScrap[0] + cScrap[1];
            
      if (lDebug)
      alert("[editor.js fileOpen\n\n" +
            "cScrap[0] " + cScrap[0] + "\n" +
            "cScrap[1] " + cScrap[1]);
      */
      
      /* Open file to hidden frame. */
      lUntitled                    = false;
      parent.WS_file.location.href = "../webutil/_cpyfile.p" +
                                     "?options=open,editor" +
                                     "&filename=" + cFileName;
    }
    else if (isNav4up) {
      if (cFile == undefined || cFile == "") {
        hOpenWin = window.open(cURL,"openWin","dependent,height=320,width=375");
        if (hOpenWin.opener == undefined) 
          hOpenWin.opener = self;
        hOpenWin.focus();
      }
      else {
        fileObj       = getField("fileName", "object");
        fileObj.value = cFile;
        cFileName     = cFile;
        lUntitled     = false;

        parent.WS_file.location.href = "../webutil/_cpyfile.p" +
                                       "?options=open,editor" +
                                       "&filename=" + cFile;
      }
    }
  }

  function filePrint() {
    /*-----------------------------------------------------------------------
      Purpose:     Print the currently opened file.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    var cValue = getField("txt", "value");
    var hPrintWin;
    
    if (cValue == "") {
      alert("There is nothing to print.");
      return false;
    }

    /* Copy Editor contents to hidden form. */
    var newPage = '<PRE>' + cValue;
    parent.WS_file.document.write(newPage);
    parent.WS_file.document.close();
    parent.WS_file.focus();
    parent.WS_file.print();
  }
  
  function fileSave(cCaller, cTarget) {
    /*-----------------------------------------------------------------------
      Purpose:     Save the file being editted.
      Parameters:  cCaller - calling function, e.g. fileNew, fileOpen, etc.
                   cTarget - destination function, e.g. fileNew, fileOpen
      Notes:       
    -------------------------------------------------------------------------*/
    var cReturn;
    var cString;
    var iLength;
    var lReturn;
 
    if ((getField("txt", "value")) == "") {
      alert("There is nothing to save.");
      return false;
    }
    if (cTarget == getUnknown() || cTarget == "")
      cTarget = "fileSave";
    
    /* File is new, untitled, so prompt for filename. */
    if (lUntitled && !lCheckSyntax &&
        cCaller != "filesaveas" && cCaller != "fileSaveAs") {
      cReturn = fileSaveAs(getUnknown(), cCaller, cTarget);

      if (cReturn == "cancel" || cReturn == "Cancel" || 
          cReturn == false || cReturn == getUnknown())
        return false;
    }

    /* Post to WebSpeed transaction agent in 18K chunks. */
    cString = new String(getField("txt", "value"));
    iLength = cString.length;
    iLoop   = Math.floor(iLength / 18000);
    if ((iLoop % 18000) > 0)
      iLoop++;
    
    iRandom  = Math.round(Math.random() * 99998) + 1;

    postData(1, ((iLoop > 1) ? "first" : "last"), cCaller, cTarget);
  }
  
  function fileSaveAs(cFile, cCaller, cTarget) {
    /*-----------------------------------------------------------------------
      Purpose:     Save the file being editted with a new name.
      Parameters:  cFile   - full path of file to save (Netscape Navigator)
                   cCaller - calling function, e.g. fileNew, fileOpen, etc.
                   cTarget - destination function, e.g. fileNew, fileOpen
      Notes:       
    -------------------------------------------------------------------------*/
    if ((getField("txt", "value")) == "") {
      alert("There is nothing to save.");
      return false;
    }
    cDirPath = getField("dirPath", "value");
    cDirPath = (cDirPath == "  " ? "" : cDirPath);
    cURL     = '../webutil/_osfile.w' +
               '?mode=save' +
               '&directory=' + cDirPath +
               '&title=Save' +
               '&buttons=save-cancel' +
               '&target=' + cTarget;

    /* File Save dialog */
    if (isIE4up) {
      cOldFile  = (lUntitled ? "" : parent.WS_edit.form1.fileName.value);
      cFileName = window.showModalDialog(cURL, cOldFile, 
                  "center=yes;dialogHeight=350px;dialogWidth=375px");
      if (cFileName == "" || cFileName == null)
        return false;

      parent.WS_edit.form1.fileName.value = cFileName; 
      /* 19990724-004 
         cFileName is returned with "|" separating the directory path from
         the filename, so split it apart and reassemble cFileName without 
         the special character.
      cScrap                              = cFileName.split("|");
      parent.WS_edit.form1.dirPath.value  = cScrap[0];
      parent.WS_edit.form1.fileName.value = cScrap[1];
      cFileName                           = cScrap[0] + cScrap[1];
            
      if (lDebug)
      alert("[editor.js fileSaveas\n\n" +
            "cScrap[0] " + cScrap[0] + "\n" +
            "cScrap[1] " + cScrap[1]);
      */
    }
    else if (isNav4up) {
      cOldFile  = (cFile == undefined ? "" : 
        parent.WS_edit.document.layer1.document.form1.elements["fileName"].value);
      
      if (cOldFile == "") {
        cFileName = window.open(cURL, "fileWin", 
                    "dependent,height=320,width=375");
        return;
      }
      else {
        cFileName = cFile;
        parent.WS_edit.document.layer1.document.form1.elements["fileName"].value = cFile;
      }
    }
    lUntitled = false;
    cTarget   = "," + ((cTarget != getUnknown() && cTarget != "") ? 
                        cTarget : "fileSaveAs");
    
    /* Check if it's OK to save the file with the new name. If there are no 
       problems, e.g. file exists, is not writeable, then the save will be 
       triggered remotely by _cpyfile.p. */
    parent.WS_file.location.href = '../webutil/_cpyfile.p' +
                                   '?options=saveAs,editor' + cTarget +
                                   '&action=okToSave' + 
                                   '&fileName=' + cFileName +
                                   '&oldFile=' + cOldFile;
    if (isIE4up)
      return getUnknown();
  }

  function getField(cField, cAttribute) {
    /*-----------------------------------------------------------------------
      Purpose:     Get a field's object handle or value.
      Parameters:  cField     - name
                   cAttribute - object, value, or ""
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      var fieldObj = eval('parent.WS_edit.form1.' + cField);
    else if (isNav4up) {
      var formObj  = parent.WS_edit.document.layer1.document.form1;
      var fieldObj = eval('formObj.elements["' + cField + '"]');
    }
      
    switch(cAttribute) {
      case "object":
        return fieldObj;
        break;
      case "value":
        return fieldObj.value;
        break;
      default:
        return fieldObj;
    }
  }
  
  function getUnknown() {
    /*-----------------------------------------------------------------------
      Purpose:     Return web browser's unknown value
      Parameters:  
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      return null;
    else if (isNav4up)
      return undefined;
  }
  
  function getWinHeight() {
    /*-----------------------------------------------------------------------
      Purpose:     Get the window's height (pixels).
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      return document.body.clientHeight;
    else if (isNav4up)
      return window.innerHeight;
  } 
  
  function getWinWidth() {
    /*-----------------------------------------------------------------------
      Purpose:     Get the window's width (pixels).
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      return document.body.clientWidth;
    else if (isNav4up)
      return window.innerWidth;
  }
  
  function goToLine(newLine) {
    /*-----------------------------------------------------------------------
      Purpose:     Move the cursor to a specific line in the file.
      Parameters:  newLine - line to jump to
      Notes:       
    -------------------------------------------------------------------------*/
    var cArray;
    var cReturn;
    var cSpaces;
    var cString  = getField("txt", "value");
    var hViewWin;
    var iLine    = 0;
    var iPointer = 0;
    var newPage;
    var oldValue = 0;
    
    if (cString == "") {
      alert("The Editor is empty.");
      return;
    }

    if (isIE4up) {
      cURL    = "../webutil/_goto.w?lineNum=" + iLine;
      cReturn = window.showModalDialog(cURL, "goToWin", 
                "center=yes;dialogHeight=160px;dialogWidth=250px");
      if (cReturn == "") return;
      var textObj = parent.WS_edit.form1.txt.createTextRange();
    }
    else if (isNav4up) {
      /* Convert text area to an array,  prefixing line numbers. */
      cArray = cString.split(String.fromCharCode(10));
      for (ix = 0; ix < cArray.length; ix++) {
        cCounter = new String(ix + 1);
        cSpaces  = "";
        
        /* Pad line number with spaces. */
        for (iy = 0; iy < (5 - cCounter.length); iy++) {
          cSpaces += " ";
        }
        cArray[ix] = cSpaces + (ix + 1) + "  " + cArray[ix];
      } 
      
      /* Rebuild text area from array. */
      cString = "";
      for (ix = 0; ix < cArray.length; ix++) {
        cString += cArray[ix] + String.fromCharCode(10);
      } 
      
      /* Write text to a new window as plain text (no rendering) and 
         view it. */
      hViewWin = window.open("", "viewWin");
      newPage  = '<TITLE>' + getField("fileName", "value") + '</TITLE>' +
                 '<PLAINTEXT>\n' + cString;
      
      hViewWin.document.write(newPage);
      hViewWin.document.close();
      hViewWin.focus();

      return;
    }
    
    forLoop:
    for (ix = 1; ix <= (cReturn - 1); ix++) {
      /* Find next carriage return. */
      oldValue = iPointer;
      iPointer = cString.indexOf(String.fromCharCode(13), iPointer) + 1;
      
      if (iPointer >= (cString.length - 3)) {
        iPointer = oldValue;
        break forLoop;
      }
      oldValue = iPointer;
    }
    parent.WS_edit.form1.txt.focus();
    textObj.move("character", iPointer - Math.max(0, (ix - 2)));
    textObj.select();
  }
  
  function hideAll(e) {
    /*-----------------------------------------------------------------------
      Purpose:     Hide all the drop-down menus.
      Parameters:  e - object handle
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) {
      mFile.style.display    = "none";
      mSearch.style.display  = "none";
      mCompile.style.display = "none";
      mHelp.style.display    = "none";

      if (e != null && e.offsetParent != null) { 
        if ((e.offsetParent.className == "subMenu") ||
            (e.offsetParent.className == "toolBar"))
          menuActive = false;
      }
    }
    else if (isNav4up) {
      /*
      for (ix = 0; ix < 6; ix++) {
        document.mMain.document.layers[ix].visibility = "hide";
      }

      if (e != null && e.parentLayer != null) { 
        if ((e.parentLayer.name == "mMain") ||
            (e.parentLayer.name == "toolBar"))
          menuActive = false;
      }

      document.mFile.visibility    = "hidden";
      document.mSearch.visibility  = "hidden";
      document.mCompile.visibility = "hidden";
      document.mHelp.visibility    = "hidden";
      */
    }
  }
  
  function highlight(thisMenu) {
    /*-----------------------------------------------------------------------
      Purpose:     Highlight the menu item - white-on-navy
      Parameters:  thisMenu - menu object handle
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) {
      thisMenu.style.color      = "white";
      thisMenu.style.background = "navy";
    }
    else if (isNav4up) {
      /*
      var cMenu = new String(thisMenu.name);
      cMenu     = cMenu.substr(5);  
      */
      /* Rewrite the menu layer with the highlight foreground color. 
      thisMenu.document.write(setColor(cMenu, "white"));
      thisMenu.document.close();

      thisMenu.bgColor = "navy";
      thisMenu.top     = 68;
      */
    }
  }
  
  function init() {
    /*-----------------------------------------------------------------------
      Purpose:     Initialization routine.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    getBrowser();
    
    if (document.layers) {
      /* Setup mouse event capturing for the Tool Bar for Navigator.
      document.toolBar.document.captureEvents(Event.MOUSEDOWN);
      document.toolBar.document.onmousedown = toolBarEvent;
      */
      /* Setup mouse event capturing for the main menu. The main menu layers 
         would not respond to event capturing. The event.target returned blank.  
         Instead, we record the left-right page coordinates of each main menu 
         item in the layout() function and checking these coordinates when a 
         main menu item is clicked.
      document.mMain.document.captureEvents(Event.MOUSEDOWN);
      document.mMain.document.onmousedown = menuEvent;
      */
    }
    /* layout("init"); */
    setSize("init");
  }
  
  function layout(cCaller) {
    /*-----------------------------------------------------------------------
      Purpose:     Layout the main menu items.
      Parameters:  cCaller - calling function, e.g. init
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) {
      var divs = document.all.tags("DIV");
      
      /* Position the main menu, based on content. */
      for (ix = 1, iy = 0; ix <= (divs.length - 2); ix++, iy++) {
        var thisMenu = divs.item(ix);  // initially, Edit menu
        var prevMenu = divs.item(iy);  // initially, File menu
  
        if (thisMenu.className == "mainMenu") {
          if (iy == 0) {
            thisMenu.style.pixelLeft = 10;
            prevMenu.style.pixelLeft = 0;
          }
          else
            thisMenu.style.pixelLeft = prevMenu.style.pixelLeft + 
                                       prevMenu.style.pixelWidth;
          
          thisMenu.style.pixelTop   = thisMenu.offsetParent.offsetTop;
          thisMenu.style.pixelWidth = (thisMenu.innerText.length * 8);
        }
      }
    }
    
    else if (isNav4up) {
      var iHeight = 23;

      /* Position the six main menus, based on content.
      for (ix = 1, iy = 0; iy < 5; ix++, iy++) {
        var thisMenu = document.mMain.document.layers[ix]; // initially, Edit menu
        var prevMenu = document.mMain.document.layers[iy]; // initially, File menu
        var cMenu;
        
        // Special handling for the first main menu item.
        if (iy == 0) {
          // Rewrite the normal black-on-lightgrey colors.
          cMenu = new String(prevMenu.name);
          cMenu = cMenu.substr(5);  // Strip off "mMain" prefix

          prevMenu.document.write(setColor(cMenu, ""));
          prevMenu.document.close();
          
          prevMenu.moveTo(5, 68);
          if (cCaller == "init")
            prevMenu.clip.width  += 10;
          prevMenu.clip.height  = iHeight;
          cCoords[iy]           = prevMenu.left + ", " +
                                 (prevMenu.left + prevMenu.clip.right);
        }
        // Rewrite the normal black-on-lightgrey colors 
        cMenu = new String(thisMenu.name);
        cMenu = cMenu.substr(5);  // Strip off "mMain" prefix

        thisMenu.document.write(setColor(cMenu, ""));
        thisMenu.document.close();
        
        thisMenu.moveTo(prevMenu.left + prevMenu.clip.width, 68);
        if (cCaller == "init")
          thisMenu.clip.width += 10;
        thisMenu.clip.height  = iHeight;
        cCoords[ix]           = thisMenu.left + ", " +
                               (thisMenu.left + thisMenu.clip.right);
      }
      document.mMain.clip.top    = 65;
      document.mMain.clip.width  = document.mMain.document.layers[5].left +
                                   document.mMain.document.layers[5].clip.width;
      document.mMain.clip.height = iHeight;
      document.mMain.visibility  = "show";
      */
      
      /* Position the Tool Bar images.  The '4' is hard-coded, since there is no
         layer attribute that returns the number of child layers. The alternative
         is to hard-code the x-y coordinates in the editornn.html file.
      for (ix = 0; ix < 4; ix++) {
        var imgLayer = document.toolBar.document.layers[ix];
        imgLayer.moveTo((ix * 34), 0);
        imgLayer.visibility = "show";
      }
      */
    }
  }
  
  function menuEvent(evt) {
    /*-----------------------------------------------------------------------
      Purpose:     Menu event handler for Netscape Navigator.
      Parameters:  evt - event
      Notes:       
    -------------------------------------------------------------------------*/
    var cXY;
    var cString;
    var iLeftLim, iRightLim;
    
    for (ix = 0; ix < 6; ix++) {
      cString   = new String(cCoords[ix]);
      cXY       = cString.split(",");
      iLeftLim  = cXY[0];
      iRightLim = cXY[1];
      
      if (evt.pageX >= iLeftLim && evt.pageX <= iRightLim) {
        cMenu = document.mMain.document.layers[ix];
        break;
      }
    }
    switch(cMenu.name) {
      case "mMainFile":
        activate(document.mFile, cMenu);
        break;
      case "mMainEdit":
        activate(document.mEdit, cMenu);
        break;
      case "mMainSearch":
        activate(document.mSearch, cMenu);
        break;
      case "mMainCompile":
        activate(document.mCompile, cMenu);
        break;
      case "mMainOptions":
        activate(document.mOptions, cMenu);
        break;
      case "mMainHelp":
        activate(document.mHelp, cMenu);
        break;
    }
    return false;
  }
  
  function normal(thisMenu) {
    /*-----------------------------------------------------------------------
      Purpose:     Restore the menu items - black-on-gray
      Parameters:  thisMenu - menu object handle
      Notes:       
    -------------------------------------------------------------------------*/
    /* Display normal menu colors. */
    if (isIE4up) {
      thisMenu.style.color = (cDisable.search(thisMenu.id) != -1) ? 
                                disableColor : enableColor;

      if (thisMenu.className == "mainMenu")
        thisMenu.style.background = bodyBgColor;
      else
        thisMenu.style.backgroundColor = menuBgColor;
    }
    else if (isNav4up) {
      /*
      if (thisMenu.parentLayer.name == "mMain") {
        var cMenu = new String(thisMenu.name);
      
        cMenu            = cMenu.substr(5);  // Strip off "mMain" prefix
        thisMenu.bgColor = bodyBgColor;
        thisMenu.top     = 68;

        // Rewrite the menu layer with the normal foreground color. 
        thisMenu.document.write(setColor(cMenu, ""));
        thisMenu.document.close();
      }
      else {
        thisMenu.bgColor = menuBgColor;
      }
      */
      return false;
    }
  }

  function postData(iSection, cAction, cCaller, cTarget) {
    /*-----------------------------------------------------------------------
      Purpose:     Post data packet (18,000 bytes max.) to the WebSpeed agent.
      Parameters:  iSection - section number, e.g. 1, 2, 3, n
                   cAction  - first, append, last
                   cCaller  - calling function, e.g. init
      Notes:       
    -------------------------------------------------------------------------*/
    var cFile;
    var cOptions;
    var cSegment;
    var cString   = new String(getField("txt", "value"));
    var iBytes;
    var iLength;
    
    /* Update action and check section to see if we're done saving. */
    if (iSection == 1)
      iBegByte = 0;
    else {
      iBegByte = iEndByte + 2;

      if      (iSection < iLoop)  cAction = "append";
      else if (iSection == iLoop) cAction = "last";
      else {
        /* All done, let's cleanup and leave. */
        if (lCheckSyntax)
          lCheckSyntax = false;
        else {
          saveValue = getField("txt", "value");
          lUntitled = false;
          setHeaderTitle();
          saveBar("delete");
        }
        return;
      }
    }
    
    /* Calculate ending byte. Get close by adding 18000 bytes. */
    iEndByte = iBegByte + 18000;
    cSegment = cString.substring(iBegByte, iEndByte);

    /* Find next carriage return. */
    if (cSegment.length >= 18000 && cSegment.charCodeAt(iEndByte) != 13) {
      iEndByte = cString.indexOf(String.fromCharCode(13), iEndByte);
      cSegment = cString.substring(iBegByte, iEndByte);
    }
    /* Strip off trailing carriage return.
    else if (cSegment.length < 18000)
      cSegment = cSegment.substr(0, cSegment.length - 2);
    */

    /* Copy Editor section to hidden form. */
    var newPage = '<HTML>';
    newPage    += '<FORM ID="form0" NAME="form0" METHOD="post">';
    newPage    += '<TEXTAREA ID="txt0" NAME="txt0" WRAP="off"></TEXTAREA>';
    newPage    += '</FORM>';
    newPage    += '</HTML>';
    parent.WS_file.document.write(newPage);
    parent.WS_file.document.close();
   
    /* cFile    = (isIE4up ? parent.WS_edit.form1.fileName.value : cFileName); */
    cFile    = getField("fileName", "value");
    cOptions = (cTarget == "checkSyntax" ? cTarget : 'save') + ',editor';
    
    /* This triggers _cpyfile.p to run fileNew() at the end of the save,
       clearing the Editor and setting the filename to Untitled. */
    if (cAction == "last" && cTarget == "fileNew")
      cOptions += ",fileNew";
      
    cURL     = '../webutil/_cpyfile.p' +
               '?options=' + cOptions +
               '&tempFile=p' + iRandom + 'ws.tmp' +
               '&fileName=' + cFile +
               '&action=' + cAction +
               '&section=' + iSection;
    iLength  = (getField("txt", "value")).length;
    iBytes   = (cAction != "last" ? (iSection * 18000) : iLength);

    /* Display and/or update Save progress bar. */
    saveBar("set", cFile, "", iBytes, iLength);
            
    /* Load hidden form and post to the WebSpeed agent. */
    if (isIE4up) {
      parent.WS_file.form0.txt0.value = cSegment;
      parent.WS_file.form0.action     = cURL;
      parent.WS_file.form0.submit();
    }
    else if (isNav4up) {
      parent.WS_file.document.form0.elements["txt0"].value = cSegment;
      parent.WS_file.document.form0.action                 = cURL;
      parent.WS_file.document.form0.submit();
    }
    if (cAction == "last")
      saveBar("delete");
  }
    
  function saveBar(cMode, cFile, cTarget, iSaved, iLength) {
    /*-----------------------------------------------------------------------
      Purpose:     Set/delete the "Saving..." progress bar dialog.
      Parameters:  cMode   - delete, set [scale]
                   cFile   - name of file to save
                   cTarget - save destination
                   cSaved  - cumulative bytes saved
                   cTotal  - total file byte size
      Notes:       
    -------------------------------------------------------------------------*/
    switch (cMode) {
      case "delete":
        if (hBarWin != getUnknown() && !hBarWin.closed)
          hBarWin.close();
        break;
      case "set":
        var cString = new String(window.location);
        var iPos    = cString.indexOf("webedit");  // hack off navmenu.w path
        var cTarget = cString.substr(0, (iPos - 1));
      
        var cURL    = "../webutil/_savebar.w" +
                      "?fileName=" + cFile +
                      "&target=" + escape(cTarget) +
                      "&bytesSaved=" + iSaved +
                      "&fileSize=" + iLength;

        hBarWin     = window.open(cURL, "barWin", "dependent,height=130,width=400");
        hBarWin.focus();
        break;
    }
  }
  
  function selectText() {
    /*-----------------------------------------------------------------------
      Purpose:     Select all text in the text area.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    (getField("txt", "object")).select();
  }
  
  function setImage(e, fName) {
    /*-----------------------------------------------------------------------
      Purpose:     Reset the Tool Bar image.
      Parameters:  e     - image object
                   fName - file name
      Notes:       
    -------------------------------------------------------------------------*/
    e.src = "../images/" + fName + ".gif";
  }
    
  function setHeaderTitle() {
    /*-----------------------------------------------------------------------
      Purpose:     Set the header title as "Editor - [filename]".
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) 
      parent.WS_hdr.document.all.headerTitle.innerText = 
        "Editor" + ((cFileName != "") ? (" - " + cFileName) : "");
    else if (isNav4up) {
      cFileName     = getField("fileName", "value");
      var cHeader   = "Editor" + ((cFileName != "") ? (" - " + cFileName) : "");
      var newHeader = '<FONT SIZE="+2" COLOR="#660066"><B>' + cHeader + '<\/FONT>';
      
      parent.WS_hdr.document.headerTitle.document.write(newHeader);
      parent.WS_hdr.document.headerTitle.document.close();
    }
  }
  
  function setSize() {
    /*-----------------------------------------------------------------------
      Purpose:     Repostion and resize the text area to fit the available 
                   frame area. 
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    var iAdjust = 0;
    
    if (isIE4up) {
      var tarea   = (getField("txt", "object"));
      var tparent = parent.WS_edit.document.all.tdTxt;
      
      /*
      if (document.all.toolBar.style.display == "none")
        iAdjust = 35;
      tarea.style.top    = tparent.offsetTop + 2 - iAdjust;
      tarea.style.width  = Math.max(20, document.body.clientWidth - 20);
      tarea.style.height = Math.max(20, tparent.offsetHeight - 115 + iAdjust);
      */
      tarea.style.top    = 0;
      tarea.style.left   = 0;
      tarea.style.width  = Math.max(20, document.body.clientWidth);
      tarea.style.height = Math.max(20, document.body.clientHeight);
    }
    else if (isNav4up) {
      /* Width (iCols) is the available frame width divided by the pixels per 
         TEXTAREA COLS attribute.  Height (iRows) is the available frmae height 
         divided by the pixels per TEXTAREA ROWS attribute. */
      var iCols  = Math.round((window.innerWidth - 10) / 8.4);
      var iRows  = Math.floor((window.innerHeight - 10) / 17);
      var tArea  = (getField("txt", "object"));
      var text   = tArea.value;
      
      parent.WS_edit.document.layer1.clip.height = window.innerHeight;
      parent.WS_edit.document.layer1.clip.width  = window.innerWidth;
      /* parent.WS_edit.document.layer1.bgColor     = "cyan"; // debug visual aid */
      parent.WS_edit.document.layer1.document.writeln(setTextArea(iRows, iCols, text));
      parent.WS_edit.document.layer1.document.close();
      parent.WS_edit.document.layer1.visibility  = "show"; 
    }
  }
  
  function setTextArea(iRows, iCols, text) {
    /*-----------------------------------------------------------------------
      Purpose:     Rebuild the text area for Netscape Nagivator.
      Parameters:  iRows - number of rows
                   iCols - number of columns
                   text  - text to display in text area
      Notes:       
    -------------------------------------------------------------------------*/
    cDirPath  = getField("dirPath", "value");
    cDirPath  = (cDirPath == "  " ? "" : cDirPath);
    cFileName = getField("fileName", "value");

    return '<FORM NAME="form1">' + 
           '<TEXTAREA ID="txt" NAME="txt" ROWS="' + iRows + '" COLS="' + iCols + 
             '" WRAP="off">' + text + 
           '<\/TEXTAREA>' +
           '<INPUT NAME="fileName" TYPE="hidden" VALUE="' + cFileName + '">' +
           '<INPUT NAME="dirPath" TYPE="hidden" VALUE="' + cDirPath + '">' +
           '<\/FORM>';
  }

  function showHelp(url) {
    /*-----------------------------------------------------------------------
      Purpose:     Display the Help menu Help Topics item.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    hHelpWin = window.open(url,"helpWin");
    hHelpWin.focus();
  }

  function tbd() {
    /*-----------------------------------------------------------------------
      Purpose:     Display a "...under construction..." alert box.
      Parameters:  <none>
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up)
      alert("Feature under construction for Internet Explorer.");
    else if (isNav4up)
      alert("Feature under construction for Netscape Navigator.");
  }
  
  function visibleObj(e) {
    /*-----------------------------------------------------------------------
      Purpose:     Hide/view the object based on its current state.
      Parameters:  e - object handle
      Notes:       
    -------------------------------------------------------------------------*/
    if (isIE4up) 
      e.style.visibility =
        (e.style.visibility == "visible" || e.style.visibility == "") ?
        "hidden" : "visible";
    else if (isNav4up)
      e.visibility = (e.visibility == "inherit" || 
                      e.visibility == "show" || 
                      e.visibility == "") ? "hidden" : "show";
  }
  
  function windowEvent(evt) {
    /*-----------------------------------------------------------------------
      Purpose:     Window event handler for Netscape Navigator.
      Parameters:  evt - event
      Notes:       
    -------------------------------------------------------------------------*/
    window.routeEvent(evt);
  }
  