//  File:         ryapph.js
//  Description:  Implements the default application and window handler

var apph=this, menu, app, mainapp, appframes;
var returnfield, returnValue;
var menuobjects=[];      // Contains references to menu objects.
var info,popup,menubar,toolbar,hotkey,appcontrol;
var latercmd=[];         // Commands to be executed after run()

/*****************************************************************/
/***  Global initialization     **********************************/
/****************************************************************
   1. initializeObjects, when all has loaded it initializes the objects
   2. startApplication, then starts the initial application frame
*/


function initializeObjects() {
  appcontrol=new Appcontrol();  //Construct the AppControl which in turn will start the Main Control.

  hotkey=new Hotkey();
  menuobjects[menuobjects.length]=hotkey;

  menubar=new Menubar(document.getElementById('menubar'));
  menuobjects[menuobjects.length]=menubar;

  toolbar=new Toolbar(maindoc.getElementById('toolbar'));
  menuobjects[menuobjects.length]=toolbar;

  popup=new Popup(maindoc.getElementById('popup'));
  menuobjects[menuobjects.length]=popup;

  // Now that we are done creating all the objects, start the application
  appcontrol.dyn=document.getElementById('app').getAttribute('dyn');
  if(!appcontrol.dyn) appcontrol.dyn='';
  window.run();         // Start the run
  apph.action('prg.'+appcontrol.startprog); // Start the default page after initialization
}


/*****************************************************************/
/***  Application page initialization     ************************/
/****************************************************************
   1. pagestart, controls initialization of objects on a new screen
   2. ready, will be called from hidden frame
*/

function pagestart(){
  window.status='Done';    
  if(/blank/.test(app.location)) return;
  lognote_begin();
  lognote('APP WBO/WDO:'+app.location);
  app.wdo=new Object();
  var DIV=app.document.getElementsByTagName('DIV');
  for(var i=0;i<DIV.length;i++){     // data objects
    var e=DIV[i];
    var obj=e.getAttribute('objtype');
    if(obj=='wbo' && window.Wbo)    app.wbo=new Wbo(window.app);     // WBO
    if(obj=='wdo' && e.id!='master'){
      var wdo=new Wdo();   // Wdo
      app.wdo[e.id]=wdo;
      wdo.init(e);
    }
  }
  if(!window.app.wbo) return window.app=null;
  if(app.frameObject.dyntag && app.frameObject.dyntag.id!='treeframe') window.app.isFrame=app.frameObject.dyntag;

  lognote('APP:Pass-thru');
  var master=app.document.getElementById('master');
  if(master){
    if(!app._master || app.frameObject.parent){      // Pass-thru wdo or no wdo
      var wdo=new Wdo();
      app.wdo['master']=wdo;
      wdo.init(master);
    } else app.uplink=app._master;                // Set to current WDO
  }
  
  lognote('APP:Widgets');
  for(var i=0;i<DIV.length;i++){        // customizable objects
    var e=DIV[i];
    var obj=e.getAttribute('objtype');
    var wdo=e.getAttribute('wdo');
    if(!obj || obj=='wdo' || obj=='wbo' || obj=='dynframe') continue;
    if(wdo && wdo!=''){
      // There could be multiple instance of data sources for viewer hence the loop i.e 1-1 dynSBO
      var temp=wdo.split(',');
      for (var j=0;j<temp.length;j++)
        app['_'+temp[j]].page[e.parentNode.getAttribute('page')]=true;
      if(!app.firstwdo && !e.parentNode.getAttribute('page')) app.firstwdo=temp[0];
    }

    if(obj=='viewer'){                  // Register viewers with WDO
      e=e.firstChild;
      if(e.nodeName=='#text') e=e.nextSibling;
      if(wdo) {
        // There could be multiple instance of data sources for viewer hence the loop i.e 1-1 dynSBO
        var temp = wdo.split(',');
        for (var j=0; j<temp.length;j++)
          app['_'+temp[j]].viewer.push(e);
      }
      continue;
    }
    var name=obj.substr(0,1).toUpperCase()+obj.substr(1).toLowerCase();
    var widget=window.eval('new '+name+'()');
    widget.init(e);
  }

  lognote('APP:FixRender');
  fixRectangles();
  fixUtilImages();
  fixLayout();

/*** Initialize and run the screen **/
  window.status='Initializing data'; 
  lognote('APP:WBO Init');
  if(app && app.wbo) app.wbo.init();

  lognote('APP:DynFrames');
  var parentFrame=app.frameObject;
  for(var i=0;i<DIV.length;i++){        // customizable objects
    var e=DIV[i]; 
    var obj=e.getAttribute('objtype');
    if(obj!='dynframe') continue; 
    with(appcontrol){
      action(e.getAttribute('uplink')+'.setpassthru');
      var framename=DIV[i].getAttribute('name');
      var dynframe=getframe(framename);
      var winname=dynframe.tag.getAttribute('name');
      dynframe.dyntag=DIV[i];
      dynframe.dyntag.setAttribute('frame',winname);
      dynframe.dyntag.parentNode.setAttribute('frame',winname);
      dynframe.parent=parentFrame;
      framepos(winname);
      activate(dynframe);
      if(dynframe.src!=framename){
        dynframe.src=framename;
        fetch(dynframe);
      }
    }
  }
  lognote('APP:refreshing sizes');
  appcontrol.fixMainSizes();
  lognote('***** DONE *******');
  window.status='Done';  // This will stop the progres-bar.
}

function ready(win){    // This function will be called from the hidden frame
  if(!appcontrol) return;
  lognote_begin();
  window.status='Processing';
  window.app=appcontrol.submitapp;
  appcontrol.clearTimer();
  if(win.run) win.run(app);
  lognote('APP: Run Hidden Data');
  if(app && app.wbo) app.wbo.process();
  lognote('APP: Hidden Done');
  if(mainapp.dyntree) window.app=mainapp;
  window.status='Done';   
}

function userAction(cmd){    // This function should be called for user generated events
  if(appcontrol.busy) return window.status='Please wait, BUSY processing request.';
  window.action(cmd); 
  runRemaining();
}

function runRemaining(){    // This function should be called for user generated events
  if(app && app.wbo && app.wbo._mustsubmit){
    app.wbo._mustsubmit=false;
    later('wbo.submit');
    runlater();
  }
}


/**************************/
/**   Global Utilities   **/
/**************************/

function fError(e,c){
  if(document.all){
    alert('Error:'+e.message
     +'\nDebug:'+c
     +'\nWhere:'+e.description+' in '+e.name
     );
  } else {
    alert('Error:'+e.message
     +'\nDebug:'+c
     +'\nWhere:'+e.lineNumber+' in '+e.fileName
     );
  }
}

function lognote(msg){
  if(appcontrol.lognote=='on') lognote.logtext+='|'+((new Date()).getTime()-lognote.logtime)+' '+msg;
}

function lognote_begin(){
  lognote.logtime=new Date();
  lognote.logtext='0 New request:'+lognote.logtime.toGMTString();
  lognote.logtime=lognote.logtime.getTime();
  if(appcontrol.submitTime){
    lognote('Time-Server='+(appcontrol.startTime-appcontrol.submitTime));
    lognote('Time-Loading='+(appcontrol.endTime-appcontrol.startTime));
    lognote('Time-onLoad='+(lognote.logtime-appcontrol.endTime));
  }
}

function later(a){
  latercmd[latercmd.length]=a;
}

function runlater(){
  var a=[].concat(latercmd);
  latercmd=[];
  actions(a);
}

function test_cont(e,cont){
  var el=e.parentNode;
  while(el!=cont) if((el=el.parentNode).nodeName=='BODY') return false;
  return true;
}


/**************************/
/**   Action API         **/
/**************************/

function actions(a){   // Run multiple actions
  for(var i=0;i<a.length;i++) action(a[i]);
}

function action(a){     // action handler
  if(!a) return false;
  var prm=a.substr((a+'|').indexOf('|')+1); // Parameters
  var elm=a.split('|')[0].split('.');       // Action part

  var cmd=elm.shift();
  if(app==window) app=mainapp;
  var hTarget=app;
  if(cmd=='parent'){
    cmd=elm.shift();
    var c=app.frameObject.parent;
    if(c==null) return false;
    hTarget=c.win;
  }
  if(!cmd) return false;
  var agg=elm.join('.');                 // Aggregate of last elements
  if(elm.length==0){      // finding type and value of event to redirect it
    return appcontrol.app_action(hTarget,cmd,prm);
  } else {
    switch(cmd){
      case 'g':
        return;     // A submenu should not be processed
      case 'app':
        return appcontrol.app_action(hTarget,elm[0],prm);
      case 'prg':
        return appcontrol.runframe(agg);
      case 'dlg':
        var oldframe=appcontrol.activeframe;
        appcontrol.runframe(agg);
        oldframe.child=appcontrol.activeframe;
        return appcontrol.activeframe.parent=oldframe;
      case 'info':
        return info.action(agg,prm);
      case 'tool':
        return tool_action(elm,prm);
      case 'dyntree':
        return mainapp.dyntree.action(agg,prm);
      case 'main':
        return appcontrol.main_action(elm,prm);
      case 'util':
        if(agg.indexOf('upload')>0) prm='resize';
        if(elm[0]==agg) agg+='.icf'; // Assume dynamic if no extension
        if(agg.indexOf('.icf$')>0) agg=appcontrol.dyn+agg;  // Add dynamic path
        if(document.all) showModalDialog(appcontrol.dyn+agg,main,'dialogHeight=50px;dialogWidth=50px;status=0;resizable='+(prm=='resize'?'1':'0'));
        else             open(appcontrol.dyn+agg,'util','modal=1,height=50,width=50,scrollbars=0,alwaysRaised=1,dependent=1,resizable='+(prm=='resize'?'1':'0'));
        if(app && app.isPopup) app.onunload=function(e){window.main.app=window.app.isPopup;runlater();};
        return returnValue;
    }
    if(!hTarget) return;

    switch(cmd){
      case 'wbo':
        if(!hTarget || !hTarget.wbo) return;
        return hTarget.wbo.action(agg,prm);
      case 'wdo':
        return hTarget['_'+hTarget.firstwdo].action(agg,prm);  // Multi-target toolbar
      case 'widget':
        var w=hTarget.document.getElementsByName(elm[0])[0];
        if(!w && hTarget.document.getElementById(elm[0]))   // WDO
            return action(agg+'|'+prm);
        if(!w) return alert(window.action('info.get|HTM16||'+elm[0])); //ok
        var wdo=app[w.getAttribute('wdo')];
        if(wdo && wdo.browse && wdo.browse.id==w.id) cmd='browse';
        else return viewer_action(w,elm[1],elm[2],prm);
        elm[0]=w.getAttribute('wdo');
      case 'browse':
      case 'viewer':
        var sdo=hTarget[elm[0]];
        if(cmd=='browse'){
          //if(!sdo||!sdo.browse) return alert('Browse does not exist');
          if(!sdo||!sdo.browse) return alert(window.action('info.get|HTM16||Browse')); //ok
          return sdo.browse.action('_'+elm.slice(1),prm);
        } else {
          var w=hTarget.document.getElementsByTagName('DIV');
          for(var i=0;i<w.length;i++){
            if(w[i].getAttribute('objclass')!='browse' && w[i].getAttribute('wdo')==elm[0])
              viewer_action(w[i],elm[1],elm[2],prm);
          }
          return;
        }
      case 'server':
        return hTarget.document.form['do'].value+='|'+agg;
      default:   // redirect to specified WDO
        var sdo=hTarget['_'+cmd];
        
         // Pass it on to parent screen since screen UI in meantime may have assigned it to dynframe
        if(!sdo && hTarget.frameObject.dyntag){   
          window.app=hTarget.frameObject.parent.win;
          return action(a);
        }
         // Test for dyntree main page if not found
        if(!sdo && hTarget.dyntree && hTarget.dyntree.currframe){ 
          hTarget=hTarget.dyntree.currframe.win;
          var sdo=hTarget['_'+cmd];
        }
        if(sdo) return sdo.action(agg,prm);
    }
  }

  function viewer_action(viewer,name,val,prm){
    var form='_'+viewer.getAttribute('name');
    var wdo=viewer.getAttribute('wdo').split(',');
    for(var i=0;i<wdo.length;i++)       // Check datasources first
      if(app.document.forms[form][wdo[i]+'.'+name])
        return action(wdo[i]+'.'+name+'.'+val+'|'+prm);
    if(app.document.forms[form][name])  // Also check local fields if no DS is found
      return appcontrol.doField(app.document.forms[form][name],val,prm);
  }

  function tool_action(f,prm){
    var cmd=f.pop();
    var elm=f.join('.');
    var ret=[];
    if(!app) return;
    if(!app.isPopup) appcontrol.maintool(elm,cmd);
    var e=app.document.getElementsByName(elm);
    if(e.length==1 && e[0].nodeName=='IMG'){   // Deal with Lookups
      elm=elm.replace('.','._'); 
      e=app.document.getElementsByName(elm);      
    }   
    for(var i=0;i<e.length;i++) ret.push(appcontrol.doField(e[i],cmd,prm));

    if(app.uplink && f[0]==app.uplink.id){
      var elm2=elm.replace(f[0]+'.','master.');
      e=app.document.getElementsByName(elm2);
      for(var i=0;i<e.length;i++) ret.push(appcontrol.doField(e[i],cmd,prm));
      if(!window.app.isPopup) ret.push(appcontrol.maintool(elm2,cmd));
    }
    return (cmd=='handle'?ret:ret.join(','));
  }
}




/*****************************************************************/
/***      Appcontrol Object     **********************************/
/****************************************************************
   Extends the Maincontrol defined in ryinithtml.js

   Appcontrol deals with the application frame whereas Maincontrol deals with the surrounding "default.htm".
   Such this file remains the same even if XUL is used for the surrounding framework

   1. probeRegional, finds the regional settings of the browser
   2. getframe/runframe, deals with the "appframes" IFRAME control objects
   3. app_timeout/clearTimer, implements a server-timeout

   4. app_action/main_action, implements actions for prefixes "main" and "app"
   5. getField/setField, implements generic functionality for dealing with HTML inputs

*/

Appcontrol.prototype=new Maincontrol();
Appcontrol.prototype.debugging=false;
Maincontrol.prototype.cLookup='';

function Appcontrol(){
  this.probeRegional();
}

Appcontrol.prototype.probeRegional=function(){
  // time format & timezone
  var dt=new Date(2001,10,26,13,14,15);
  var a=dt.toLocaleString().toLowerCase();
  this.timeformat=(a.indexOf('PM')>0?'std':'mil');
  var zone=dt.getTimezoneOffset() / -60;

  // Date format
  a=a.replace(',',' ').split(' ');
  var dmy='';
  for(var i=0;i<a.length;i++){
    if(a[i].indexOf('2001')>-1) dmy+='y';
    if(a[i].indexOf('nov' )>-1) dmy+='m';
    if(a[i].indexOf('nop' )>-1) dmy+='m';
    if(a[i].indexOf('noi' )>-1) dmy+='m';
    if(a[i].indexOf('lis' )>-1) dmy+='m';
    if(a[i].indexOf('11'  )>-1) dmy+='m';
    if(a[i].indexOf('26'  )>-1) dmy+='d';
  }
  var m=dmy;
  if(dmy.length!=3) dmy=dmy.replace('d',((a.join('')).indexOf('26')<10?'dm':'md'));
  this.dateformat=dmy;

  // Numeric format
  this.numformat=(16/5).toLocaleString().charAt(1);

  this.cLookup=this.cInitialLookup+'#'+this.numformat+'#'+this.timeformat+'#'+this.dateformat+'#'+zone;
  return this.cLookup;
}

Appcontrol.prototype.getframe=function(src){
  var lru=null;  // least recently used frame
  for(var e in appframes){
    if(e=='popup') continue;
    var f=appframes[e];
    if(f.src==src) return f;
    if(f.active||f.child) continue;
    if(!lru || lru.time>f.time) lru=f;
  }
  lru.time=new Date();
  return lru;
}

Appcontrol.prototype.runframe=function(src){
  with(this){
    deactivate(activeframe);
    activate(activeframe=getframe(src));
    if(activeframe.src!=src){
      activeframe.src=src;
      activeframe.parent=null;
      activeframe.dyntag=null;
      activeframe.child=null;
      this.submitTime=(new Date()).getTime();
      fetch(activeframe);
    } else {
      window.mainapp=(activeframe.app?app:null);
      if(app && app.wbo) app.wbo.refresh();
    }
  }
}

Appcontrol.prototype.app_timeout=function(){
  if(!this.busy || !this.busy.clearTimer ) return;
  this.busy.clearTimer();
  this.busy=null;
  alert('server timeout');
}

Appcontrol.prototype.clearTimer=function(){
  if(this.busy){
    window.clearTimeout(this.busy);
    this.busy=null; // clear busy timer
  }
}

Appcontrol.prototype.setStart=function(){
  this.startTime=(new Date()).getTime();
}
Appcontrol.prototype.setEnd=function(){
  this.endTime=(new Date()).getTime();
}

Appcontrol.prototype.main_action=function(elm,prm){
  var tool=elm.shift();
  var val=elm.pop();
  var e=maindoc.getElementById(tool);
  if(!e) return;
  var b=e.getAttribute('block');
  if(b) e=maindoc.getElementById(b);
  if(val=='toggle')  val=e.className=='show'?'hide':'show';  // toggle
  if(val=='refresh') val=e.className;
  e.className=val;
  action('tool.main.'+tool+'.toggle.'+(val=='hide'?'uncheck':'check'));
  b=e.getAttribute('action');
  if(b) action(b);
  appcontrol.fixMainSizes();
}

Appcontrol.prototype.app_action=function(hTarget,cmd,prm){
  with(this){
    switch(cmd){
      case 'handle':
        return hTarget;
      case 'back':
        if(app) return action('wbo.close');
      case 'continue':
        var parent=activeframe.parent;
        deactivate(activeframe);
        activate(activeframe=parent);
        window.mainapp=app;
        if(app && app.wbo) app.wbo.refresh();
        return true;
      case 'exit':
        if(app && app.wbo && !action('wbo.close')) return false;
        if(activeframe.src!=startprog) {      // Check if launch window
          window.runlater();
          return action(activeframe.parent>''?'app.continue':'prg.'+startprog);   // Go back
        }

      // exit should reset the session id so that the session cannot be hijacked.
        document.cookie='';
        this.mainform.sessionid.value='';
        this.sessionid='';

        close(); //ok

      case 'cursor':
        try {
          maindoc.body.style.cursor=prm;
          if(app) app.document.body.style.cursor=prm;
          if(mainapp) mainapp.document.body.style.cursor=prm;
        } catch(e){status=e};
        break;
      case 'debug':
        document.getElementById('irun').className=debugging?'show':'hide';
        break;
      case 'initTools':
        return actions(['main.info.refresh']);
      case 'helptopics':
        return open(appcontrol.dyn+'../dhtml/ryhelp.icf','help','width=720,height=240,toolbar=0,location=0,menubar=0,status=0,resizable=1',false);
      case 'helpabout':
        return open(appcontrol.dyn+'../dhtml/ryabout.icf','about','width=400,height=250,toolbar=0,location=0,menubar=0,status=0,resizable=1',false);
      case 'debug2':
        return open(appcontrol.dyn+'../dhtml/rydebug.htm','debug','width=325,height=220,toolbar=0,location=0,menubar=0,status=0,resizable=1,scrollbars=1',false);
      case 'refresh':
        return fetch(activeframe);
      case 'sessionid':
        return this.mainform.sessionid.value=(this.sessionid=prm);
      case 'timeformat':
        return this.timeformat=prm;
      case 'dateformat':
        return this.dateformat=prm;
      case 'numformat':
        return this.numformat=prm;
      default:
        if(main[cmd]) main[cmd](prm);
      else
        alert(cmd+' not implemented yet!->'+prm);
        // alert(window.action('info.get|HTM15||'+cmd+'|'+prm)); //ok
    }
  }
}

function dialogClose(win){
  if(window.appframes.popup.active==null) return;
  window.app=win.isPopup;
  window.appframes.popup.active=null;
  win.close();
  runRemaining();
}

/** Viewer functionality to be reused in rylogic.js and rywdo.js **/
Appcontrol.prototype.setField=function(e,val){
  if (val == null || val == 'undefined') return;
  if(e.getAttribute && e.getAttribute('combochild')){
	if(e.getAttribute('combovalue')!=val){
	  e.setAttribute('combovalue',val);
      apph.later(e.id+(e.getAttribute('dfield')?'.combolookup':'.comborefresh'));
      mainapp.wbo._mustsubmit=true;
	}  
  }
  if(e.length && e.nodeName!='SELECT'){        // Radio sets
    // loose the case sensitivity for combo, radios and checkboxes
    val=val.toLowerCase();
    for(var i=0;i<e.length;i++) e[i].checked=(e[i].value==val);
  } else if(e.type=='checkbox'){
    e.checked=(val.toLowerCase()=='yes');
    e.value='yes';
  } else if(e.nodeName=='SELECT'){
    var found = false;
    val=val.toLowerCase();
    var options=e.options;
    for (var x=0;x<options.length;x++){
      if(options[x].value.toLowerCase()==val){
        options[x].selected=true;
        found=true;
        break;
      }
    }
    if(val && (!found||e.selectedIndex==-1) && !e.getAttribute('comboparent'))
      window.action('info.field|HTM13||'+e.id+'|'+val); 
  } else {
    e.value=val;
  }
}

Appcontrol.prototype.getField=function(e,val){     
  // Get value from any input element or return 'val'
  if (e == null) return val;
  if(e.length && e.nodeName!='SELECT'){             // Radio sets
    for(var i=0;i<e.length;i++) if(e[i].checked) return e[i].value;
    return val;
  }
  if(e.getAttribute('disable')) return val;
  if(e.nodeName=='SELECT') return e.value;
  if(e.type=='checkbox') return e.checked?'yes':'no';
  if(e.type=='text'||e.type=='hidden'||e.type=='password'||e.nodeName=='TEXTAREA')
    return window.escapedata(e.value);
  if(e.nodeName=='IMG' && e.getAttribute('tool')=='util') return e.value;
  return val;
}

Appcontrol.prototype.markField=function(e,val){    
  if(e.length){         // Radio sets
    for(var i=0;i<e.length;i++) this.markField(e[i],val);
    return;
  }
  if(e.nodeName=='SPAN') return;
  var a=e.className.split(' ');
  var out=(val>''?[val]:[]);
  out.push(a.pop());
  out.unshift(a.shift());
  e.className=out.join(' ');
}

Appcontrol.prototype.doField=function(e,val,prm){    
  if(e.nodeName=='TD')
  switch(val){
    case 'enable':
    case 'disable':
      return state(e,val);
    case 'show':
      return e.style.visibility='visible';
    case 'hide':
      return e.style.visibility='hidden';
    case 'check':
      return e.firstChild.src=e.firstChild.src.replace('u.gif','c.gif');
    case 'uncheck':
      return e.firstChild.src=e.firstChild.src.replace('c.gif','u.gif');
    default:
      return;
  }
  switch(val){
    case 'handle':
      return e;
    case 'getdata':  // Initial value is used for local fields
      var val=e.getAttribute('initval');
      if(val) return val;
      return '';  
    case 'set': 
      return this.setField(e,prm);
    case 'get':
      return this.getField(e,'');
    case 'mark':
      return this.markField(e,prm);
    case 'focus':
      try{
        e.focus();
        e.select();
      } catch(e){};
      return;
    case 'options':
      if(e.nodeName!='SELECT') return;
      prm=prm.split('|');
      for(var i=0;i<e.options.length;i++) e.options[i]=null;
      var i=0;
      var key = '';
      while(prm.length>0) {
        key = prm.shift();
        e.options[i++]=new Option(prm.shift(),key);
      }
      return;
    case 'lock': 
    case 'unlock':    // Precursor to enable/disable
      if(val=='lock')
        e.setAttribute('disable','true');
 	  else 
        e.removeAttribute('disable');
    case 'enable': 
    case 'disable':
      val=e.getAttribute('disable') ? 'disable':'enable';
      if(e.nodeName=='SELECT'||e.nodeName=='BUTTON'||e.type=='radio'||e.type=='checkbox') e.disabled=(val=='enable'?null:true);
      if(e.nodeName=='TEXTAREA'||e.type=='text') e.readOnly=(val=='enable'?null:true);
      if(e.getAttribute('tab')) e.tabIndex=(val=='enable'?e.getAttribute('tab'):-1);
      return state(e,val);
  }
  
  // Also including labels and popup tools for some commands
  var lbl=e.previousSibling;
  while(lbl && lbl.nodeName=='#text') lbl=lbl.previousSibling;
  if(lbl && (lbl.nodeName=='LABEL' )) this.doField(lbl,val);

  switch(val){
    case 'show':
    case 'hide':
      if(e.type=='radio') e=e.parentNode;
      e.style.visibility=(val=='show'?'visible':'hidden');
      if(e.nodeName=='SELECT') e.setAttribute('remember',e.style.visibility);
      return;
    case 'switch':
      if(e.nodeName=='LABEL') return;
      if(action(e.id+'.gettype')=='log'){
        var v=action(e.id+'.getinput');
        return action(e.id+'.set|'+(v=='yes'?'no':'yes'));
      }
      else
        if(e.type=='checkbox') return e.checked=e.checked?false:true;
      break;
    default:
  }
  function state(e,val){
    var a=e.className.split(' ');
    var c=a.pop();
    if(c!='enable'&&c!='over'&&c!='disable'&&c!='marked'){
      a.push(c);
      c='enable';
    }
    if(!val) return c;
    a.push(val);
    e.className=a.join(' ');
  }
}

