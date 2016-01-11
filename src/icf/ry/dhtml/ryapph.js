//  File:         ryapph.js
//  Description:  Implements the default application and window handler

var apph=this, menu, app;
var returnfield, returnValue;
var menuobjects=[];      // Contains references to menu objects.
var info,popup,menubar,toolbar,hotkey,treeview,appcontrol;
/**************************/
/** Page initializations **/
/**************************/
var latercmd=[];         // Commands to be executed after run()

function later(a){
  latercmd[latercmd.length]=a;
}

function runlater(){
  actions(latercmd);
  latercmd=[];
}

function actions(a){
  for(var i=0;i<a.length;i++) action(a[i]);
}

/*************************/
/** Application Actions **/
/*************************/

Appcontrol.prototype=new Maincontrol();
Appcontrol.prototype.aProg=[];    // frame handling
Appcontrol.prototype.aBack=[];
Appcontrol.prototype.curframe=-1
Appcontrol.prototype.st=(new Date()).getTime();   // timing
Appcontrol.prototype.aTime=[];        
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

Appcontrol.prototype.app_action=function(hTarget,cmd,prm){
  with(this){
    switch(cmd){
      case 'handle':
        return hTarget;
      case 'name':
        return (aProg[(hTarget==app?curframe:aBack[curframe])]).split('.')[0];
      case 'back':
        if(app && !action('wbo.close')) return false;
      case 'continue':
        return app_launch(aProg[aBack[curframe]],null,curframe);
      case 'exit':
        if(app && !action('wbo.nochange')){
          app.wbo.afterSave('app.exit');                   // in case of yes to save
          if(!action('wbo.close')) return false;           // cancel
          if(app.wbo.savechange) return true;              // yes to save - waiting for server
        } 
        if(aProg[curframe].split('.')[0]!=startprog)       // Check if launch window
          return action(aBack[curframe]>''?'app.continue':'prg.'+startprog);   // Go back      

    	// exit should reset the session id so that the session cannot be hijacked.
        document.cookie='';
        this.mainform.sessionid.value='';   
        this.sessionid='';   

  	close(); //ok
        
      case 'cursor':
        try {
          maindoc.body.style.cursor=prm;
          if(app) app.document.body.style.cursor=prm;
        } catch(e){status=e};
        break;
      case 'debug':
        if(app && app.document.getElementById('irun'))
          app.document.getElementById('irun').className=debugging?'show':'hide';
        break;
      case 'initTools':
        return actions(['main.info.refresh','main.treeview.refresh']);
      case 'helptopics':
        return open(appcontrol.dyn+'../dhtml/ryhelp.icf','help','width=720,height=240,toolbar=0,location=0,menubar=0,status=0,resizable=1',false);
      case 'helpabout':
        return open(appcontrol.dyn+'../dhtml/ryabout.icf','about','width=325,height=220,toolbar=0,location=0,menubar=0,status=0,resizable=1',false);
      case 'debug2':
        return open(appcontrol.dyn+'../dhtml/rydebug.htm','debug','width=325,height=220,toolbar=0,location=0,menubar=0,status=0,resizable=1,scrollbars=1',false);
      case 'refresh':
        return launchFrame(curframe,aProg[curframe]);
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
        //alert(cmd+' not implemented yet!->'+prm);
        alert(window.action('info.get|HTM15||'+cmd+'|'+prm)); //ok
    }
  }
}

Appcontrol.prototype.main_action=function(elm,prm){
    var tool=elm.shift();
    var val=elm.pop();
    var e=maindoc.getElementById(tool);
    if(!e) return;
    var b=e.getAttribute('block');
    if(b) e=maindoc.getElementById(b);
    if(val=='toggle') val=e.className=='show'?'hide':'show';  // toggle
    if(val=='refresh') val=e.className;
    e.className=val;
    action('tool.main.'+tool+'.toggle.'+(val=='hide'?'uncheck':'check'));
    b=e.getAttribute('action');
    if(b) action(b);
    appcontrol.fixMainSizes();
}
    
Appcontrol.prototype.app_launch=function(prog,backto,backfrom){
//    alert('launch='+prog+'/'+backto)
  with(this){
    if(prog==undefined) return false;
    if(prog.indexOf('.')==-1&&prog.indexOf(':')==-1) prog=(appcontrol.dyn=='static') ? prog+'.htm':appcontrol.dyn+prog+'.icf';
    var newframe=-2;
    for(var i=0;i<numframes;i++) if(aProg[i]==prog) newframe=i;  // Find existing page
    if(newframe==curframe) return false;  // Same page

    // Get new frame or open in existing
    if(newframe==-2){
      newframe=0;
      for(var i=0;i<numframes;i++){
        if(!aTime[i]){newframe=i; break;}
        if(aTime[newframe]>aTime[i]) newframe=i;
      }
//      alert(curframe+'->'+newframe);
      appFrameChange(curframe,newframe);   // Change the visible page
      launchFrame(newframe,prog);               // Fetch new page 
      curframe=newframe;
      this.fixMainSizes();

    } else {
//      alert(curframe+'->'+newframe);
      appFrameChange(curframe,newframe);       // Change the visible page
      curframe=newframe;
      window.app=aFrame[curframe];
      try{
        if(backfrom==null && !document.all) later('app.refresh'); // Mozilla fix
        if(app && app.wbo) app.wbo.refresh();    // Refresh page if access
        else {app=null;}
      } catch(e){
      	 app=null;
//   	 alert('app=null run-refresh\n'+fError(e));
      }
      appcontrol.fixMainSizes();
    }
    if(backto!=null) aBack[curframe]=backto;
    aTime[curframe]=new Date();
  }
}   

Appcontrol.prototype.launchFrame=function(fnew,prog){  
  this.aProg[fnew]=prog;
  this.aBack[fnew]=null;
  action('app.cursor|wait');
  this.st=(new Date()).getTime();
  this.appFrameLaunch(fnew,prog);
}

var appcontrol=new Appcontrol();
// action('prg.'+appcontrol.startprog); // Start the default page after initialization

function action(a){     // action handler
  if(!a) return false;
  var prm=a.substr((a+'|').indexOf('|')+1); // Parameters
  var elm=a.split('|')[0].split('.');       // Action part

  var cmd=elm.shift();
  var hTarget=app;
  if(cmd=='parent'){
    cmd=elm.shift();
    var c=appcontrol.aBack[appcontrol.curframe];
    if(c==null) return false;
    hTarget=appcontrol.aFrame[c];
  }
  if(!cmd) return false;
  var agg=elm.join('.');                 // Aggregate of last elements
  if(elm.length==0){      // finding type and value of event to redirect it
    return appcontrol.app_action(hTarget,cmd,prm);
  } else {
    switch(cmd){
      case 'prg':
        return appcontrol.app_launch(agg);
      case 'dlg':
        return appcontrol.app_launch(agg,appcontrol.curframe);
      case 'info':
        return info.action(agg,prm);
      case 'tool':
        return tool_action(agg);
      case 'main':
        return appcontrol.main_action(elm,prm);
      case 'treeview':
        return treeview.action(agg,prm);
      case 'util':
        if(elm[0]==agg) agg+='.icf'; // Assume dynamic if no extension
        if(agg.indexOf('.icf$')>0) agg=appcontrol.dyn+agg;  // Add dynamic path
        if(document.all) showModalDialog(appcontrol.dyn+agg,main,'dialogHeight=50px;dialogWidth=50px;resizeable=0;status=0');
        else             open(appcontrol.dyn+agg,'util','modal=1,height=50,width=50,scrollbars=0,alwaysRaised=1,dependent=1');
        return returnValue;
    }
    if(!hTarget) return;      

    switch(cmd){
      case 'app':
        return appcontrol.app_action(hTarget,elm[0],prm);
      case 'wbo':
        if(!hTarget || !hTarget.wbo) return;
        return hTarget.wbo.action(agg,prm);
      case 'wdo':
        return hTarget.firstwdo.action(agg,prm);
      case 'widget':
        var w=hTarget.document.getElementsByName(elm[0])[0];
        if(!w && hTarget.document.getElementById('d'+elm[0]))   // WDO
            return action(agg+'|'+prm);       
        if(!w) return alert(window.action('info.get|HTM16||'+elm[0])); //ok
        var wdo=app['d'+w.getAttribute('wdo')];
        if(wdo && wdo.browse && wdo.browse.id==w.id) cmd='browse';
        else return viewer_action(w,elm.slice(1),prm);
        elm[0]=w.getAttribute('wdo'); 
      case 'browse':
      case 'viewer':
        var sdo=hTarget['d'+elm[0]];
        if(cmd=='browse'){        
          //if(!sdo||!sdo.browse) return alert('Browse does not exist');
          if(!sdo||!sdo.browse) return alert(window.action('info.get|HTM16||Browse')); //ok
          return sdo.browse.action(elm.slice(1),prm);
        } else {
          var w=hTarget.document.getElementsByTagName('DIV');
          for(var i=0;i<w.length;i++){
            if(w[i].getAttribute('objclass')!='browse' && w[i].getAttribute('wdo')==elm[0])
              viewer_action(w[i],elm.slice(1),prm);	
          }	
          return;
        }
      case 'server':
        return hTarget.document.form['do'].value+='|'+agg;
      default:   // redirect to specified WDO
        var sdo=hTarget['d'+cmd];
        if(!sdo){
          if(app.wbo.name=='find') return false;
          //alert('Cannot find WDO='+cmd+' agg='+agg+' param='+prm);
          alert(window.action('info.get|HTM17||'+cmd+'|'+agg+'|'+prm)); //ok
          window.action();
          return false;
        }
        try{return sdo.action(agg,prm);} 
          catch(e){fError(e,'apph.wdo.action:'+sdo.id+'/'+agg+'/'+prm)}
    }
  }
  
  function viewer_action(t,elm,prm){
    var cmd=elm.pop(), c='';
    c=elm.join('.')+'.'+cmd;
//    alert('ryapph.js] viewer_action\nc='+c+'\nt.id='+t.id+'\nelm='+elm+'\nprm='+prm+'\ncmd='+cmd);
    switch(cmd){
      case 'handle':
        return tool_action(t.getAttribute('wdo')+'.'+c,t);
      case 'get':
      case 'getdata':
      case 'getinput':
      case 'gettype':
      case 'mark':
      case 'unmark':
        return action(t.getAttribute('wdo')+'.'+c);
      case 'set':
      case 'setdata':
      case 'setinput':
        return action(t.getAttribute('wdo')+'.'+c+'|'+prm);
      case 'enable':
      case 'disable':
        cmd=(cmd=='enable'?'unlock':'lock');
        c=elm.join('.')+'.'+cmd;  // reset c with new cmd
      case 'focus':
      case 'hide':
      case 'show':
      case 'switch':
        tool_action(t.getAttribute('wdo')+'.'+c,t);
        return;
      default:
      //alert('Viewer action unknown:'+t.id+'='+elm+'/'+cmd+'/'+prm);
      alert(window.action('info.get|HTM18||'+t.id+'='+elm+'/'+cmd+'/'+prm)); //ok
    }
  }

  function tool_action(func,cont){
    var f=func.split('.');
    var evt=f[f.length-1];

    var cmd=func.replace('.'+evt,'');
    appcontrol.maintool(cmd,evt);
    
    if(!app) return;
    var e=app.document.getElementsByName(cmd);
    if(evt=='handle'){
//      alert('func='+func+'\ncmd='+cmd);
      if(!e[0])  // look for local, non-SDO field
        return app.document.getElementsByName(cmd.split('.')[1])[0];
      return e[0];    
    }
    
    for(var i=0;i<e.length;i++) tool(e[i],evt);

    if(f[0]==app.firstwdoid){
      var cmd2=cmd.replace(f[0]+'.','wdo.')
      e=app.document.getElementsByName(cmd2);
      for(var i=0;i<e.length;i++) tool(e[i],evt);
      appcontrol.maintool(cmd2,evt);
    }
    if(f[0]==app.uplink){
      var cmd2=cmd.replace(f[0]+'.','master.')
      e=app.document.getElementsByName(cmd2);
      for(var i=0;i<e.length;i++) tool(e[i],evt);
      appcontrol.maintool(cmd2,evt);
    }
    
    function tool(e,val){
      if(cont){
      	var el=e.parentNode;
      	while(el!=cont) if((el=el.parentNode).nodeName!='BODY') return;	
      }
      if(e.nodeName=='TD') 
      switch(val){
        case 'enable':
        case 'disable':
          return e.className=val;
        case 'show':
          return e.style.visibility='visible';
        case 'hide':
          return e.style.visibility='hidden';
        default:
          return;
      }

      // Also including labels and popup tools
      var lbl=e.previousSibling;
      while(lbl && lbl.nodeName=='#text') lbl=lbl.previousSibling;
      if(lbl && (lbl.nodeName=='LABEL' )) tool(lbl,val);
      if(e.getAttribute('utilimg')) tool(e.nextSibling,val);

      switch(val){
        case 'lock':
        case 'unlock':
          e.setAttribute('disable',val=='lock'?'true':'false');
        case 'enable':
          if(e.getAttribute('disable')=='true') val='disable'; 
        case 'disable':
          if(e.nodeName=='SELECT'||e.nodeName=='BUTTON') e.disabled=(val=='enable'?null:true);
          if(e.nodeName=='TEXTAREA'||e.type=='text') e.readOnly=(val=='enable'?null:true);
          if(e.getAttribute('tab')) e.tabIndex=(val=='enable'?e.getAttribute('tab'):-1);
          return e.className=(e.className).split(' ')[0]+' '+val;
        case 'show':
        case 'hide':
          e.style.visibility=(val=='show'?'visible':'hidden');
          if(e.nodeName=='SELECT') e.setAttribute('remember',e.style.visibility);
          return; 
        case 'check':
          return e.src=e.src.replace('u.gif','c.gif');
        case 'uncheck':
          return e.src=e.src.replace('c.gif','u.gif');
        case 'focus':
          if(e.nodeName=='LABEL') return;
          e.focus();
          return e.select();
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
    }
  }
}

function ready(win){    // This function will be called from the hidden frame
  var trg=win.parent;
  trg.document.form.loadstart.value=(new Date()).getTime()-appcontrol.st;
  if(trg==app && win.run) win.run(trg);
  trg.document.form.loaddata.value=(new Date()).getTime()-appcontrol.st;
  if(trg==app) trg.wbo.process();
  trg.document.form.loadmenu.value=(new Date()).getTime()-appcontrol.st;
  trg.document.form.loadend.value=(new Date()).getTime()-appcontrol.st;
}

function pagestart(app){
	if(/blank/.test(app.location)) return;
  app.browse=[];
  app.wdo=[];
  var DIV=app.document.getElementsByTagName('DIV');
  for(var i=0;i<DIV.length;i++){     // data objects
    var e=DIV[i];
    var obj=e.getAttribute('objtype');
    if(obj=='wbo' && window.Wbo)    app.wbo=new Wbo(window.app);     // WBO
    if(obj=='wdo' && e.id!='dmaster'){
    	var wdo=new Wdo();   // Wdo
    	app.wdo.push(wdo);
    	wdo.init(e);
    }
  }
  var master=app.document.getElementById('dmaster');
  if(master && app.uplink==null){
    if(appcontrol.aBack[appcontrol.curframe]!=null){      // Pass-thru wdo
      var wdo=new Wdo();
      app.wdo.push(wdo);
      wdo.init(master);
    } else app.uplink=app.firstwdoid;                // Set to current WDO
  }

  for(var i=0;i<DIV.length;i++){        // customizable objects
    var e=DIV[i];
    var obj=e.getAttribute('objtype');
    if(!obj || obj=='wdo' || obj=='wbo') continue;
    var name=obj.substr(0,1).toUpperCase()+obj.substr(1).toLowerCase();
    window.eval('app.'+obj+'= new '+name+'()');            
    app[obj].init(e);
  }
  fixRectangles();
  fixUtilImages();
  
/*** Initialize and run the screen **/
  if(app && app.wbo) app.wbo.init();
}

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

function startApplication(runprog) {
  // Start the run
  window.run();    
  
  // Start the default page after initialization
  apph.action(runprog); 
}
