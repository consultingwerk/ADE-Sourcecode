//  File:         ryinithtml.js
//  Description:  Javascript Initialization for default.htm

Maincontrol.prototype.dyn='';

// Extract the menu from the querystring (if there is one)
Maincontrol.prototype.startprog=/\Wicfobj=(.*)\W/i.test(location.search+'&')?RegExp.$1:'afallmencw';  // Default to Progress Dynamics Administration menu

/*************************************/
/** Various html specific code      **/
/*************************************/

main=window;                                                            
maindoc=document;                                                       

maindoc.onclick=function(){
  if(menubar) menubar.fClick();
  if(popup && popup.clickoutside()) return;
}

window.onresize=function(){  /* Resizing the objects in the IFRAME */
  appcontrol.fixMainSizes();
  window.resizeObjects(appcontrol.activeframe.win);
}	

window.onbeforeunload=function(){
  if(!appcontrol || !appcontrol.activeframe || appcontrol.activeframe.src=='login') return;
  if(app && app.wbo && action('wbo.close')) return;
  return "Do you really want to exit with changes not saved\n or without knowing the status of your changes?";
}

Maincontrol.prototype.sessionid='';  
Maincontrol.prototype.lognote=document.getElementById('app').getAttribute('lognote');;
Maincontrol.prototype.timeout=document.getElementById('app').getAttribute('timeout');;
Maincontrol.prototype.encoding=document.getElementById('app').getAttribute('encoding');
Maincontrol.prototype.mainform=maindoc.form;                                                  
Maincontrol.prototype.cInitialLookup='DYN='+document.location;                                
Maincontrol.prototype.activeframe=null;                // currently focused frame                                   
Maincontrol.prototype.cssTheme='#'+document.getElementById('app').getAttribute('css');                                          
Maincontrol.prototype.menuglobal=maindoc.getElementsByName('menu');                           

function fLoad(name){
  if(!window.appcontrol) return;
  try{
    if(/^http/.test(appframes[name].src)){   // Deal with URL launches (have no access to JS on page)
      action('app.cursor|');
      appcontrol.fixMainSizes(); 
      return;
    }
    window.app=appframes[name].win;
    if(!appframes[name].dyntag) window.mainapp=app;
    app.browse=[];
  } catch(e){
    window.app=null;
  }
  if(app){
    app.frameObject=appframes[name];
    app.document.body.setAttribute('win',name);
    pagestart();
  }
}	

function Maincontrol(){
  // Setting up the frame object;
  window.appframes=new Object();
  var tag=document.getElementsByTagName('IFRAME');
  var win=frames;
  var f=appframes['popup']=new Object();
  for(var i=0;i<tag.length;i++){
    if(tag[i].name=='irun') continue;
    f=(appframes[tag[i].name]=new Object());
    f.win=win[i];    // window object
    f.tag=tag[i];    // IFRAME tag
    f.src=null;
    f.app=false;     // whether an application frame and not URL
    f.time=new Date();
    f.active=null;   // currently active
    f.child=null;    // reference to active child
    f.parent=null;   // reference to parent
    f.dyntag=null;   // reference to dynframe tag
    f.top=0;
    f.left=0;
  }
}

Maincontrol.prototype.activate=function(f){
	if(!f) return;
	f.tag.className=f.dyntag?'frame':'show';
	f.tag.style.zIndex=(f.parent?f.parent.tag.style.zIndex*1+1:0);
 	f.active=true;
 	window.app=f.app?f.win:null;
}	

Maincontrol.prototype.framepos=function(name){
  var f=appframes[name];  
//  alert('framepos='+name+'/'+f.dyntag+'/'+f.parent);
  if(!f.active) this.activate(f);
  if(!f) return;
  var from=f.dyntag.parentNode.style;
  var off=f.parent;
  f.top=from.top.replace('px','')*1 +(document.all?0:off.top);  // Recursively storing positions for frames 
  f.left=from.left.replace('px','')*1; //+off.left; 
//  alert('f='+name+'/'+from.top.replace('px','')+'/'+off.top)
  f.tag.style.top=f.top+'px';
  f.tag.style.left=f.left+'px';
  f.tag.style.width=from.width;
  f.tag.style.height=from.height;
  if(!f.dyntag) resizeObjects(f.win);
}

Maincontrol.prototype.deactivate=function(f){ 
  if(!f) return;
  f.tag.className='hide';
  f.active=null;
  for(var c in appframes) if(appframes[c].parent==f) this.deactivate(appframes[c]);
}

Maincontrol.prototype.fetch=function(f){
  var p=f.src;
  f.app=!(p.indexOf(':')>0);
  appcontrol.activeframe.tag.style.height='2000px';   // Fix to IE sizing issue
  if(p.indexOf('.htm')>0 || p.indexOf(':')>0){
    open(appcontrol.dyn+p+'?sessionid='+this.sessionid,f.tag.name,"",false);
  } else {
    this.mainform.action=appcontrol.dyn+p+'.icf';
    this.mainform.sessionid.value=this.sessionid;
    this.mainform.lookup.value=this.cLookup+this.cssTheme;
    this.mainform.target=f.tag.name;
    this.mainform.lognote.value=lognote.logtext;
    this.mainform.submit();
  }
  action('app.cursor|wait');
}

// Recursively hide of show dynamics frames for a Tab-page
Maincontrol.prototype.setFrame=function(frame,state){
  for(var f in appframes)
    if(appframes[f].parent==frame) this.setFrame(appframes[f],state);     
  frame.tag.className=state;
}

Maincontrol.prototype.maintool=function(cmd,evt){
  var e=document.getElementsByName(cmd);
  for(var i=0;i<e.length;i++) tool(e[i],evt);
  
  function tool(e,val){
    if(e.nodeName=='TD') switch(val){
      case 'enable':
      case 'disable':
        return e.className=val;
      case 'show':
        return e.style.visibility='visible';
      case 'hide':
        return e.style.visibility='hidden';
      case 'check':
        return e.firstChild.src=e.firstChild.src.replace('u.gif','c.gif');
      case 'uncheck':
        return e.firstChild.src=e.firstChild.src.replace('c.gif','u.gif');
      default:
    }
  }
}
 
Maincontrol.prototype.fixMainSizes=function(){
  lognote('APP:fixMainSizes');
  if(!appcontrol.activeframe) return;
  var st=appcontrol.activeframe.tag.style;
  if(appcontrol.activeframe.top==0)
    appcontrol.activeframe.top=document.all 
         ? document.body.scrollHeight-st.height.replace('px','')
         : document.height-st.height.replace('px','');
  if(document.all){  //IE 
    st.width=document.body.clientWidth+'px';
    st.height=document.body.clientHeight-appcontrol.activeframe.top+'px';
  } else {      // Mozilla
    var w=window.innerWidth-6;
    var h=window.innerHeight-appcontrol.activeframe.top-4;
    st.width=w+'px';
    st.height=h+'px';
  }
}



