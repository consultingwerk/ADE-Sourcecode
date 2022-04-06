/*
  File:         rywbo.js
  Description:  Implements Screen Control Logic for a screen
                1. Initialization of menu objects
                2. Initializastion of data objects and other screen logic
                3. Generic screen functionality like paging

  Controls following structures
    app.wdo[wdoname]          - collection of controlled data objects
    app.menuCache[menuobject] - menudata per menuobject
    wdo.page[page]            - data object occurance within each page
    app.toolbar[wdoname]      - collection of toolbars per data object
         -->.buttons          - collection of button status per toolbar

*/

Wbo.prototype.savechange='';
Wbo.prototype.committing=false; // indicator set if currently in commit operataion
Wbo.prototype.status=
     {add   :true
     ,copy  :true
     ,del   :true
     ,save  :true
     ,cancel:true
     ,reset :true
     ,view  :true
     ,update:true
     ,commit:true
     ,undo  :true
     ,first :true
     ,prev  :true
     ,next  :true
     ,last  :true
     ,find  :true
     ,comments :true
     ,filter   :true
     ,lookup   :true
    };

function Wbo(app){
  this.app=app;
  this.page=1;
  this.app.tools=new Object();
  this.app.app=app;
  this.elem=app.document.getElementById('wbo');
  this.elem.innerHTML='<form name="form" method="post" target="irun" action="'+app.location+'">'
    +'<input type="hidden" name="lognote"   id="lognote"   value="">'
    +'<input type="hidden" name="do"        id="do"        value="">'
    +'<input type="hidden" name="lookup"    id="lookup"    value="">'
    +'<input type="hidden" name="lookupparent" id="lookupparent"    value="">'
    +'<input type="hidden" name="sessionid" id="sessionid" value="'+appcontrol.sessionid+'">'
    +'<input type="hidden" name="wscharset" value="'+appcontrol.encoding+'">'
    +this.elem.innerHTML
    +'\n</form>';
  app.main=window;
  app.apph=window;
  hotkey.browsenav=null;
  app.document.onkeydown=function(e){
    window.app=appframes[this.body.getAttribute('win')].win;  // Setting the click source window
    window.hotkey.hotkey(e?e:app.event);
  }
  app.document.oncontextmenu=function(e){
    window.app=appframes[this.body.getAttribute('win')].win;  // Setting the click source window
    if(main.popup) main.popup.init(e?e:app.event);
  }
  app.document.onclick=function(e){
    window.app=appframes[this.body.getAttribute('win')].win;  // Setting the click source window
    if(popup.clickoutside()) return;
    if(document.all) e=app.event;
    if(!e) return;
    if(document.all || e.button!=2) return app.wbo.click(e);
    if(main.popup) main.popup.init(e);
  }
  app.menuCache=new Object();
  app.toolbar=new Object();
  this.sbo=new Object();
}



/*****************************************************************/
/***  Initialization *********************************************/
/****************************************************************
   1. init, runs after all other objects have been constructed controls the further initialization
    -- setMenues, loads the menuCache object and builds the appropriate menu hierarchies
    -- registerMenu, configures the association of menu vs data-object

   2. refresh, runs also when screen is redisplayed refreshes screen according to data
    -- refreshMenues, redisplays the menues when returning to display

   3. process, deals with response from hidden frame

   4. aftersave, buffer command to resume after submit to server
   5. saveok, runs buffered aftersave command
*/

Wbo.prototype.init=function(){   // First time, after all screen elements are finished drawing
  with(this){
    this._complete=false;
    this.buttons=[]; // Array of associated toolbar buttons
    setMenues();     // Load menu arrays
    this._mustsubmit=false;
    this.page=new Object();
    for(var e in app.wdo){
      app.wdo[e].fieldRegister();    // Initialize registering fields in WDOs
      var p=app.wdo[e].page;         // Configure which WDO goes to which tab page
      if(!p[null]) for(var i in p) this.page[i]=e;
    }
	
    app.open('','irun','',false);  // Prepare for requests
    app.document.form['do'].value='';
    if(appcontrol.dyn=='static'){
      app.document.form.action=(app.document.location.pathname).replace('.htm','rsp.htm');
      app.document.form.method='get';
    }

	runRemaining();
	    
    // Execute the embedded RUN
    lognote('Execute RUN');
    custom('run',app);
    refresh();
    lognote('WBO Done');

    // Hide dynframe if part of a tabpage (must first be visible because of toolbar sizing)
    if(app.isFrame &&
       (app.isFrame.parentNode.getAttribute('page') || app.frameObject.parent.tag.className=='hide'))
      app.frameObject.tag.className='hide';

	runRemaining();
    this._complete=true;     // for sequencing;
  }

}

Wbo.prototype.setMenues=function(){
  lognote('set menues:');
  var menulocal=app.document.getElementsByName('menu');
  loadMenu(menulocal);                           // Load local menues
  if(!app.isPopup && !app.isFrame) 
    loadMenu(appcontrol.menuglobal);  // Load global menues
  sizeContainer(app);                            // Panel objects can now be sized
  
  function loadMenu(menu){
    for(var i=0;i<menu.length;i++){
      var m=menu[i];
      var tgt=m.getAttribute('target');
      var wdo=m.getAttribute('wdo');
      var mm=m.getAttribute('menu').split(';');
      if(!wdo) wdo='wbo';
      if(tgt=='panel'){                             // Panel are rendered immediately and buttons registered
        m.innerHTML=window.toolbar.render(mm,false,m.getAttribute('layout')=='vertical');
        if(wdo){
          if(!app.tools[wdo]) app.tools[wdo]=[null];
          app.tools[wdo].push(app.wbo.registerMenu(m,true));
        }
      } else {
        if(tgt!='hotkey') tgt=window[tgt].elem.id;  // Finding real target
        if(!app.menuCache[tgt]) app.menuCache[tgt]=(tgt=='menubar'?[[0,'root']]:[]);  // Hierarchy for menubar
        if(tgt=='toolbar' && wdo!='wbo'){
          wdo=wdo.split(',');
          for(var j=0;j<wdo.length;j++){
            if(wdo[j]) mainapp.toolbar[wdo[j]]=true; // Add all wdo to toolbar object
          }
          // If the main toolbar target is specified, then set the firstwdo
          if(wdo[0]!='wdo') app.firstwdo=wdo[0];
        }
        if(tgt=='menubar') menuHierarchy(app.menuCache[tgt],mm);
        else app.menuCache[tgt]=app.menuCache[tgt].concat(mm);
      }
    }
  }
  function menuHierarchy(node,menu){
    var stack=[];
    while(menu.length){
      var m=menu.shift();
      if(!m) continue;
      var e=m.split('|');
      while(e[0]<=node[0][0]) node=stack.pop(); // reverse the levels
      var p=null; // insert point
      for(var i=1;i<node.length;i++)
        if(node[i][0][1]==e[1] && e[1]!='break' && e[1].split('.').pop()!='rule'){
          stack.push(node)
          p=(node=node[i]);  // Don't repeat branches && entries unless spacer
        }
      if(!p){   // Set it and enter the level
        stack.push(node);
        node.push(node=[e]);
      }
    }
  }
}

Wbo.prototype.registerMenu=function(DIV,page){   // Creates button collection to be controlled by data object
  var buttons=new Object();
  var ch=DIV.getElementsByTagName('TD');
  for(var i=0;i<ch.length;i++){
    var name=ch[i].id.split('.');
    if(name.length<2 || !this.status[name[1].replace('2','')] || name[0]=='nolink') continue;
    buttons[name[1].replace('2','')]=ch[i];
    buttons.page=page;
  }
  return buttons;
}

Wbo.prototype.refresh=function(){   // When coming back into view
  with(this){
    lognote('WBO Refresh');
    this.committing=false;
    this.app.document.form['do'].value='';
    window.action('app.debug');
    if(app.document.title) maindoc.title=app.document.title;
    window.app=this.app;

    if(!app.isPopup) mainapp._master=app._master;
    refreshMenues();
    appcontrol.fixMainSizes();

    for(var e in app.wdo) if(app.wdo[e].hdata) app.wdo[e].filterOn=false;  // Making sure the Filter re-initializes

    // Set SBO commit groups
    for(var e in app.wdo) if(app.wdo[e].hdata){
		var SBO=app.wdo[e].hdata.sbo;    
		if(!SBO) continue;
		if(!sbo[SBO]){
		  sbo[SBO]=new Object();
          sbo[SBO].uncommitted=false;
		  sbo[SBO].sdo=[];
		}
		if(app.wdo[e].hdata.commit=="false"){ 
		  app.wdo[e].hdata.hsbo=sbo[SBO];
		  sbo[SBO].sdo.push(app.wdo[e].hdata);
		}
    }

    // Initialize screen data, Note some pages may not have a datasource so we'll have to check for hdata...
    for(var e in app.wdo) if(app.wdo[e].hdata && app.wdo[e].hdata.mustinitdata) app.wdo[e].hdata.initdata();
    // Show screen data
    for(var e in app.wdo) if(app.wdo[e].hdata) app.wdo[e].refresh();
    // Configure parent-child
    for(var e in app.wdo) if(app.wdo[e].hdata) app.wdo[e].hdata.initParentChild(app.wdo[e].elem);
    // If returning to screen refresh child records of pass-thru
    if(app._master && app._master.hdata) app._master.hdata.posChild();

    custom('refresh',app);
    refreshTab();
    resizeObjects(app);
    this.datasync();
    runRemaining();
    action('initfocus');
  }
}

Wbo.prototype.sboAction=function(sboname,cmd){
  with(this.sbo[sboname]){
    for(var i=0;i<sdo.length;i++) sdo[i].action(cmd);
  }
}

Wbo.prototype.refreshMenues=function(){
  if(app.isPopup||app.isFrame) return;
  lognote('menues refresh');
  for(var i=0;i<window.menuobjects.length;i++)  // Clear all menues
    window.menuobjects[i].clear();
  for(e in app.menuCache){               // Draw current menues
    window[e].menu=app.menuCache[e];
    window[e].start(app.document.title);
  }
  lognote('menues done');
}

Wbo.prototype.process=function(){    // When being run from hidden frame
  this.committing=false;
  this.app.document.form['do'].value='';
  for(var e in app.wdo) if(app.wdo[e].hdata && app.wdo[e].hdata.mustinitdata) app.wdo[e].hdata.initdata(); // Initialize screen data
  this.datasync();
  runRemaining();
}

Wbo.prototype.datasync=function(){    // After data has been readjusted
  window.runlater();
  window.app=this.app;  // actions may have reset the window.app to wrong frame
  for(var e in app.wdo) if(app.wdo[e].hdata){
    var hdata=app.wdo[e].hdata;
    if(hdata.childRow==-2) hdata.childRow=hdata.row;  // After load re-enable parent-child sync
  }
  window.action('app.cursor|');
  if(document.all) app.focus();
}


Wbo.prototype.afterSave=function(a){
  this.savechange=a;
  return false;
}

Wbo.prototype.saveok=function(){
  if(this.savechange>'') later(this.savechange);  // Run "aftersave" commands after data has been refreshed
  this.savechange='';
}

Wbo.prototype.refreshTab=function(){
  with(this){
    if(app.page>0){
      var a=app.document.body.childNodes;
      for(var i=0;i<a.length;i++)
         if(a[i].nodeName=='DIV' && a[i].getAttribute('page')){
           a[i].className='layout '+(a[i].getAttribute('page')==app.page?'show':'hide');
           var f=a[i].getAttribute('frame');
           if(f) appcontrol.setFrame(appframes[f],a[i].getAttribute('page')==app.page?'frame':'hide');
         }
      if(page[app.page] && app.toolbar[page[app.page]]) app.firstwdo=page[app.page];
      var newbrowsenav=null;  // Figuring out navigation target for cursor keys
      for(var wdoname in app.wdo){             // Setting which WDO are visible
        var wdoref=app.wdo[wdoname];
        wdoref.visible=(wdoref.page[null] || wdoref.page[app.page]);
		if(wdoref.visible && wdoref.browse) newbrowsenav=wdoref.id;
		if(!wdoref.visible && hotkey.browsenav==wdoref.id) hotkey.browsenav=null;
      }
	  if(!hotkey.browsenav) hotkey.browsenav=newbrowsenav;
      changePage(app.page,app);
      app.pagecontroller.fRun(app.page);
      custom('pagechange',app.page);
    }
  }
}

/*****************************************************************/
/***   Run-time and handling                                  ****/
/*****************************************************************/

Wbo.prototype.action=function(c,prm){
  with(this){
    var e=c.split('.');
    switch(e[e.length-1]){
    case 'nosave':
      return savechange='';
    case 'close':                   // Assemble changes for submit
      if(!action('changes')) return true;
      committing=false;
      afterSave('app.exit');
      window.action('info.yesno|HTM5||wbo.commit|wbo.undo|wbo.nosave'); // HTM5|Do you want to save currenct changes?
      return false;
    case 'changes':
      for(var w in app.wdo) if(app.wdo[w].action('changes')) return true;
      return false;
    case 'assemble':                // Assemble changes for submit
      committing=true;
      for(var e in app.wdo) app.wdo[e].action('commitdata');
      committing=false;
      return (app.document.form['do'].value > '');
    case 'commit':                  // Assemble changes for submit
      if(committing) return false;
      if(!action('assemble')) return true;
    case 'submit':                  // Submit data
      window.action('app.cursor|wait');
      appcontrol.submitTime=(new Date()).getTime();
      app.document.form.sessionid.value = appcontrol.sessionid;    //SEE IZ: 9926
      if(appcontrol.lognote=='on') app.document.form.lognote.value=lognote.logtext;
      appcontrol.submitapp=app;
      appcontrol.busy=window.setTimeout(function(){window.main.appcontrol.app_timeout()},appcontrol.timeout);
      app.document.form.submit();
      for(var i=0;i<app.document.form.length;i++)     // reset all "." fields so submit doesnt't repeat
        if((app.document.form[i].name).indexOf('.') > 0) app.document.form[i].value='';
      return;
    case 'changepage':            // Change TAB page
      if(e[0]!=0) app.page=e[0];
      refreshTab();
      action('initfocus');
      window.resizeObjects(app);      // Need to resize the objects to fit new tabfolder objects being displayed
    case 'refresh':
      for(var e in app.wdo) if(app.wdo[e].hdata) app.wdo[e].hdata.refreshTools();  // Refresh tools for WDOs
      return;

    case 'init':                // Refresh for Window coming back into display
      return refresh();
    case 'initfocus':
      for(var e in app.wdo) app.wdo[e].initFocus();
      return;
    case 'undo':                   // Undo all changes
      this.app.document.form['do'].value='';  // Making sure this happens even when alert-box
      for(var e in app.wdo){
        app.wdo[e].action('cancel');
        app.wdo[e].action('undodata');
      }
      saveok();
      window.latercmd=[window.latercmd.pop()];   // Avoid finishing stuff after an undo
      return window.runlater();  // Finish queued commands
    case 'lookup':
      return window.lookup.launch();
    default:
      if(app.eval(c) > '') app.eval(c+'("'+prm+'");');
      else alert(window.action('info.get|HTM20||'+c+'|WBO|'+prm)); //ok
    }
  }
}

// Generic click handler for whole screen
Wbo.prototype.click=function(e){
  var src=document.all?e.srcElement:e.target;
  if(menubar) menubar.fClick();                // Need to hide open menu selections and popups
  if(popup && popup.clickoutside()) return;

  if(src.nodeName=='IMG') src=src.parentNode;
  if(src.nodeName=='TD') return;
  var c=src.className;

  // Click on label of Radioset
  if(src.nodeName=='LABEL'&&src.firstChild.type=='radio'&&!src.firstChild.disabled) (src=src.firstChild).checked=true;
  if(src.nodeName=='SELECT'||src.type=='checkbox'||src.type=='radio'){
    if(src.nodeName=='SELECT') src.onchange=function(e){window.app.wbo.editfield(this);}
    else this.editfield(src);
    return;
  }
  if(src.nodeName=='INPUT'&&src.type=='radio') return;
  if(c!='over' && c!='enable') return true;

  if(src.nodeName=='SPAN'&&src.previousSibling.getAttribute('util')){
    window.returnfield=src.previousSibling;
    userAction(src.previousSibling.getAttribute('util'))
  }
}

Wbo.prototype.editfield=function(src){           // Setting 'modify' data-status if applicable
  if(src.parentNode.nodeName=='TD'){
    while(src.nodeName!='DIV') src=src.parentNode;
    window.action(src.getAttribute('wdo')+'.modify');
    return;
  }
  var a=src.id.split('.');
  if(a.length==2 && !src.getAttribute('disable') && !src.readOnly && !src.disabled) window.action(a[0]+'.modify');
}


/*****************************************************************/
/***  Function proxies to the data object     ********************/
/*****************************************************************/

Wbo.prototype.lookup=function(title,cols,labels){  // brokers lookups
  window.lookup.init(title,cols,labels);
}

Wbo.prototype.custom=function(c,prm){
  if(!this.app[c]) return true;
  return this.app[c](prm);
}
