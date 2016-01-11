//  File:         rywbo.js
//  Description:  Implements Web Business Object


/*********************************************/
/****** Menu handler functionality  **********/
/*********************************************/

Wbo.prototype.refreshMenues=function(){
  var menulocal=app.document.getElementsByName('menu');
  for(var i=0;i<window.menuobjects.length;i++){
    window.menuobjects[i].menu=[];
    window.menuobjects[i].clear();
  }
  loadMenu(menulocal);
  loadMenu(appcontrol.menuglobal);
  for(var i=0;i<window.menuobjects.length;i++) 
    window.menuobjects[i].start(app.document.title);
  window.resizeObjects();
  window.action('initTools');
  
  function loadMenu(menu){
    for(var i=0;i<menu.length;i++){
      var m=menu[i];
      var tgt=m.getAttribute('target');
      var tgtmenu=(tgt=='panel'?window.toolbar.panel:window[tgt].menu);
      var lev=(m.getAttribute('level')).split('|');
      var act=(m.getAttribute('actions')).split('|');
      var lab=(m.getAttribute('labels')).split('|');
      for(var j=0;j<lev.length;j++)
        if(lev[j]+act[j]+lab[j]>'') tgtmenu[tgtmenu.length]=lev[j]+'|'+act[j]+'|'+lab[j];
      if(tgt=='panel')window.toolbar.initPanel(m);
    }
  }
}



/*********************************************/
/******* Wbo object, one per screen **********/
/*********************************************/
Wbo.prototype.elem;
Wbo.prototype.app;
Wbo.prototype.apph;

Wbo.prototype.wdolist='';
Wbo.prototype.pages;
Wbo.prototype.tabwdo='';
Wbo.prototype.savechange='';
Wbo.prototype.committing=false; // indicator set if currently in commit operataion

function Wbo(app){
  this.app=app;
  this.apph=window;
  window.app=app;
  this.app.app=app;
  this.elem=app.document.getElementById('wbo');
  this.elem.innerHTML='<form name="form" method="post" target="irun" action="">'
    +'<input type="hidden" name="loadstart" id="loadstart" value="'+((new Date()).getTime()-appcontrol.st)+'">'
    +'<input type="hidden" name="loaddata"  id="loaddata"  value="">'
    +'<input type="hidden" name="loadmenu"  id="loadmenu"  value="">'
    +'<input type="hidden" name="loadend"   id="loadend"   value="">'
    +'<input type="hidden" name="submitend" id="submitend" value="">'
    +'<input type="hidden" name="do"        id="do"        value="">'
    +'<input type="hidden" name="lookup"    id="lookup"    value="">'
    +'<input type="hidden" name="lookupparent" id="lookupparent"    value="">'
    +'<input type="hidden" name="sessionid" id="sessionid" value="'+appcontrol.sessionid+'">'
    +'<input type="hidden" name="wscharset" value="UTF-8">'
    +this.elem.innerHTML
    +'\n</form>';
  app.document.body.innerHTML+='<iframe id="irun" name="irun" application="yes" class="hide" style="position:absolute;z-index:10;top:50px;left:10px;width:400px;height:100px;"></iframe>';  
  app.main=window;
  app.status='';
  app.apph=window;
  hotkey.browsenav=null;
  app.onresize=window.resizeObjects;
  app.document.onkeydown=function(e){window.hotkey.hotkey(e?e:window.app.event);}
  app.document.oncontextmenu=function(e){if(main.popup) main.popup.init(e?e:window.app.event);}
  app.document.onclick=function(e){
    if(document.all) e=window.app.event;	
    if(!e) return;
    if(document.all || e.button!=2) return app.wbo.click(window.fixEvent(e).target);
    if(main.popup) main.popup.init(e);
  }
  app.onbeforeunload=window.onunload;
//  toolbar.initMouseOver(app.document);

  app.document.onmouseover=function(e){
  	e=e?e:window.app.event;
  	if(!e) return;
    var src=window.fixEvent(e?e:window.app.event).target;
    if(src && src.className=='tool enable' && !src.disabled) src.className='tool over';
  }
  app.document.onmouseout=function(e){
    e=e?e:window.app.event;
    if(!e) return;
    var src=window.fixEvent(e).target;
    if(src && src.className=='tool over' && !src.disabled) src.className='tool enable';
  }

}



Wbo.prototype.init=function(){   // First time, after all screen elements are finished drawing
  with(this){
    if(app.wdo.length>0){
      app.firstwdo=app.wdo[0];
      app.firstwdoid=(app.firstwdo.id).substr(1);
      hotkey.browsenav=app.firstwdoid;
    }
    this.wdolist='master';
    for(var i=0;i<app.wdo.length;i++) wdolist+=(wdolist>'' ? ',' : '')+(app.wdo[i].id).substr(1);


    // ********************************************
    // Figure out which WDOs goes to which tab page
    // ********************************************
    app.pager=[];
    var a=app.document.getElementsByTagName('DIV');
    for(var i=0;i<a.length;i++){    
      if(a[i].getAttribute('page')) app.pager[app.pager.length]=a[i];
    }
    this.pages=new Array(app.pager.length+1);
    pages[0]='';
    
    // Scan browses for WDOs on each page
    var e=app.document.getElementsByName('browse');
    for(var i=0;i<elem.length;i++){
      if(e[i].getAttribute('objclass')!='browse') continue;
      if((','+wdolist+',').indexOf(','+ids[0]+',')>-1) 
        tabPage(e[i],e[i].name.substr(1))
    }
    // Scan elements for a WDOs on each page
    e=app.document.getElementsByTagName('INPUT');
    for(var i=0;i<e.length;i++){
      if(!e[i].name || e[i].type=='hidden') continue;
      var ids=e[i].name.split('.');
      if(ids.length!=2) continue;
      if((','+wdolist+',').indexOf(','+ids[0]+',')>-1) 
        tabPage(e[i],ids[0])
    }



    // Remove page0 instances from other pages on list
    if(!pages[0]) pages[0]='';
    for(var i=1;i<pages.length;i++){
      if(!pages[i]) continue;
      var a=pages[i].split(';');
      var c='';
      for(var j=0;j<a.length;j++){
        if((';'+pages[0]+';').indexOf(';'+a[j]+';')==-1) c+=';'+a[j];
      }
      pages[i]=c;
    }

    enableTool(app.document.getElementsByTagName('IMG'));
    enableTool(app.document.getElementsByTagName('BUTTON'));
    app.document.form.loadmenu.value=(new Date()).getTime()-appcontrol.st;
    
    app.open('','irun','',false);  // Prepare for requests
    app.document.form['do'].value='';
    if(appcontrol.dyn=='static'){
      app.document.form.action=(app.document.location.pathname).replace('.htm','rsp.htm');
      app.document.form.method='get';
    }
    app.document.form.loaddata.value=(new Date()).getTime()-appcontrol.st;

    // Execute the embedded RUN
    custom('run',app);
    refresh();
    window.resizeObjects();
    initFocus();  // Initialize focus
    app.document.form.loadend.value=(new Date()).getTime()-appcontrol.st;
  }

  function enableTool(e){
    for(var i=0;i<e.length;i++)
      if(e[i].className=='tool') e[i].className='tool enable';
  }

}

Wbo.prototype.tabPage=function(e,c){  // Configure page for WDO reference
  var e2=e.id; 
  while(e.nodeName!='DIV' || !e.getAttribute('page')){
    if(e.nodeName=='BODY') return;
    e=e.parentNode;
  }	
  var i=e.getAttribute('page');
  if((';'+this.pages[i]+';').indexOf(';'+c+';')==-1)
    this.pages[i]=(this.pages[i]>''?this.pages[i]+';':'')+c;
//  alert('pe='+e2+'/'+c+'='+this.pages+',page='+i)
}

Wbo.prototype.refresh=function(){   // When coming back into view
  this.committing=false;
  this.app.document.form['do'].value='';
  action('app.debug');
  with(this){
    maindoc.title=app.document.title
    window.app=this.app;
    refreshMenues();
//    alert('pages='+pages)
    if(app.pager.length>0) action('0.changepage');
    custom('refresh',app);
    wdoaction('refresh');
  }

  window.runlater();
  window.action('app.cursor|');
  this.initFocus();
}


Wbo.prototype.initFocus=function(){    // Initialize focus
  var ef=null;      
  var max=1000;
  var el=this.app.document.forms[0].elements;
  for(var i=0;i<el.length;i++){
//    alert('e='+el[i].nodeName+','+el[i].id+'='+el[i].tabIndex+','+max)	
    if(el[i].tabIndex && el[i].id && el[i].tabIndex>0 && el[i].tabIndex<max){
      ef=el[i];
      max=ef.tabIndex;
    }  
  }
  try{
    if(ef){ef.focus();}
  } catch(e){
//    alert('cannot focus:'+e+',ef='+ef.nodeName);
  }   
}


Wbo.prototype.process=function(){    // When being run from hidden frame
  this.committing=false;
  this.app.document.form['do'].value='';
//  this.wdoaction('refresh');        // Initialize data that has changed..
  window.runlater();
  window.action('app.cursor|');
  app.focus()
}

Wbo.prototype.afterSave=function(a){
  this.savechange=a;
  return false;
}
Wbo.prototype.saveok=function(){
//	alert('saveok->'+this.savechange)
  if(this.savechange>'') window.later(this.savechange);
  this.savechange='';  
}

Wbo.prototype.wdoaction=function(c){
  with(this){
    for(var i=0;i<app.wdo.length;i++){
      if(app.wdo[i].id=='dmaster') continue;
      var a=(app.wdo[i].id).substr(1)+'.'+c;
      if(!window.action(a)&&(c=='init'||c=='nochange')) return false;
    }
    return true;
  }
}

Wbo.prototype.action=function(c,prm){
  with(this){
    var e=c.split('.');
    switch(e[e.length-1]){
    case 'nochange':
      return wdoaction('nochange');
    case 'assemble':                // Assemble changes for submit
      committing=true;
      wdoaction('commitdata');
      committing=false;
      return (app.document.form['do'].value > '');
    case 'close':                   // Assemble changes for submit
      if(action('nochange')) return true;
      committing=false;
      // HTM5|Do you want to save currenct changes?
      return window.action('info.yesno|HTM5||wbo.commit|wbo.undo'); //ok
    case 'commit':                  // Assemble changes for submit
      if(committing) return false;
      if(!action('assemble')) return true;
    case 'submit':                  // Submit data
      if(name=='find') return window.action('parent.wbo.submit');
      window.action('app.cursor|wait');
      appcontrol.st=(new Date()).getTime();
      app.document.form['sessionid'].value = appcontrol.sessionid;    //SEE IZ: 9926
      app.document.form.submit();
      app.document.form.submitend.value=(new Date()).getTime()-appcontrol.st;
      for(var i=0;i<app.document.form.length;i++)     // reset all "." fields so submit doesnt't repeat
        if((app.document.form[i].name).indexOf('.') > 0) app.document.form[i].value='';
      app.document.form['do'].value='';
      return false;
    case 'changepage':            // Change TAB page
      if(e[0]!=0) app.page=e[0];
      if(app.page>0){
        for(var i=0;i<app.pager.length;i++)
          app.pager[i].className='pager '+(app.pager[i].getAttribute('page')==app.page?'show':'hide');
        tabwdo='';
        if(pages[0] && pages[0]!='undefined') tabwdo+=pages[0];
        if(pages.length>0) tabwdo+=(pages[app.page]);
        var c=tabwdo.split(';');
        if(c.length>1){ 
          app.firstwdoid=c[1];
          app.firstwdo  =c[1]=='master'?window.sdomaster:app['d'+c[1]];
        }
        custom('pagechange',app.page); 
      }
      resizeObjects();
    case 'refresh':             // Refresh for pages
      var c=tabwdo.split(';');
      for(var i=1;i<c.length;i++) if(c[i]>'') app['d'+c[i]].hdata.refreshMode();
      return;
    case 'init':                // Refresh for Window coming back into display
      return refresh();
    case 'undo':                   // Undo all changes
      wdoaction('cancel');
      wdoaction('undo');
      return true;
    case 'uplink':
      return app.uplink;
    case 'lookup':
      return window.lookup.launch();
    case 'returnval':
      return window.lookup.returnval();
    default:
      if(app.eval(c) > '') app.eval(c+'("'+prm+'");');
      //else alert(c+' for WBO not implemented yet!->'+prm);
      else alert(window.action('info.get|HTM20||'+c+'|WBO|'+prm)); //ok
    }  
  }
}


Wbo.prototype.click=function(e){
  if(menubar) menubar.fClick();
  if(popup) popup.remove();
  var c=e.className;
  // Click on label of Radioset
  if(e.nodeName=='LABEL'&&e.firstChild.type=='radio'){
    e.firstChild.checked=true;
    this.editfield(e);
  }
  if(e.nodeName=='SELECT'||e.type=='checkbox'||e.type=='radio'){
    this.editfield(e);
  }
  if(c!='tool over' && c!='tool enable') return true;
  var t=e.getAttribute('tool');
//  alert('action='+t?t:e.id)
  window.action(t?t:e.id);
  if(e.className=='tool enable') e.className='tool over';
}

Wbo.prototype.lookup=function(title,cols){
  window.lookup.init(title,cols);
}

Wbo.prototype.editfield=function(src){
  var a=src.id.split('.');
  if(a.length==2 && !src.getAttribute('disable') && !src.readOnly && !src.disabled)  // && !cNav
    action(a[0]+'.modify');	
}

Wbo.prototype.custom=function(c,prm){
  if(!this.app[c]) return true;
  return this.app[c](prm);
}
