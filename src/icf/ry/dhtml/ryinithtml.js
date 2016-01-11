//  File:         ryinithtml.js
//  Description:  Javascript Initialization for default.htm

// Uncomment the following line when *not using* extension mapping
// Maincontrol.prototype.dyn="/scripts/cgiip.exe/WService=wsdynamics1/dhtml"; 
// Uncomment the following line when *using* extension mapping
Maincontrol.prototype.dyn="";

// Extract the menu from the querystring (if there is one)
Maincontrol.prototype.startprog=/\Wicfobj=(.*)\W/i.test(location.search+'&')?RegExp.$1:'afallmencw';  // Default to Progress Dynamics Administration menu

/*************************************/
/** Various html specific code      **/
/*************************************/

main=window;                                                            
maindoc=document;                                                       

maindoc.onclick=function(){
  if(menubar) menubar.fClick();
  if(popup) popup.remove();
}
window.onresize=function(){appcontrol.fixMainSizes();}	

window.onbeforeunload=function(){
  if(appcontrol.aProg[appcontrol.curframe]=='login.icf') return;
  if(action('wbo.close')) return;
  return "Do you really want to exit with changes not saved\n or without knowing the status of your changes?";
}

Maincontrol.prototype.sessionid='';                                                           
Maincontrol.prototype.mainform=maindoc.form;                                                  
Maincontrol.prototype.cInitialLookup='DYN='+document.location;                                
Maincontrol.prototype.aFrame=frames;                              // The frames themselves    
Maincontrol.prototype.aFrameTag=document.getElementsByTagName('IFRAME');     // The frame tags
Maincontrol.prototype.numframes;                                          
Maincontrol.prototype.menuglobal=maindoc.getElementsByName('menu');                           

function fLoad(){
  if(!window.appcontrol) return;
  try{
    window.app=appcontrol.aFrame[appcontrol.curframe];
    window.app.browse=[];
  } catch(e){
    window.app=null;
    appcontrol.fixMainSizes();
  }
  if(window.app){
    pagestart(window.app);
    if(!window.app.wbo) window.app=null;
  }
}	

function Maincontrol(){
  this.numframes=this.aFrameTag.length;
}

Maincontrol.prototype.appFrameChange=function(fcur,fnew){
  this.aFrameTag[fnew].className='show';
  if (fcur>-1){
    this.aFrameTag[fcur].className='hide'; // Hide previous frame
  }
}	

Maincontrol.prototype.appFrameLaunch=function(fcur,prog){
  if (prog.indexOf('.htm')>0 || prog.indexOf(':')>0){
    open(prog+'?sessionid='+this.sessionid,this.aFrameTag[fcur].name,"",false);
  } else {
    this.mainform.action=prog;
    this.mainform.sessionid.value=this.sessionid;
    this.mainform.lookup.value=this.cLookup;
    this.mainform.target=this.aFrameTag[fcur].name;
    this.mainform.submit();
  }
}

Maincontrol.prototype.maintool=function(cmd,evt){
  var e=document.getElementsByName(cmd);
  for(var i=0;i<e.length;i++) tool(e[i],evt);
  
  function tool(e,val){
    if(e.nodeName=='IMG'||e.nodeName=='BUTTON'||e.nodeName=='INPUT') 
    switch(val){
      case 'enable':
      case 'disable':
        if(e.nodeName=='INPUT'){
          if(val=='disable') e.setAttribute('disable','true');
          else e.removeAttribute('disable');
        }
        return e.className=(e.className).split(' ')[0]+' '+val;
      case 'show':
      case 'hide':
        var lbl = app.document.getElementsByTagName('LABEL');
        for (i=0; i<lbl.length; i++){
          if (e.id==lbl[i].htmlFor){
            lbl[i].style.visibility=(val=='show'?'visible':'hidden');
            break;
          }
        }
        return e.style.visibility=(val=='show'?'visible':'hidden');
      case 'check':
        return e.src=e.src.replace('u.gif','c.gif');
      case 'uncheck':
        return e.src=e.src.replace('c.gif','u.gif');
      case 'focus':
        return e.focus();
      default:
    }
    if(e.nodeName=='TD' || e.nodeName=='SPAN' || e.nodeName=='DIV') switch(val){
      case 'enable':
      case 'disable':
        return e.className=val;
      case 'show':
        return e.style.visibility='visible';
      case 'hide':
        return e.style.visibility='hidden';
      default:
    }
  }
}
 
Maincontrol.prototype.fixMainSizes=function(){
  // Resizing application area for bugs in Mozilla
  var IFRAME=this.aFrameTag[this.curframe];
  var TREE=maindoc.getElementById('treeview');

// App height
  var dh=(document.all?document.body.clientHeight-document.body.scrollHeight:window.innerHeight-document.height-10);
  var ih=((IFRAME.style.height).replace('px',''))*1;
// App width
  var dw=(document.all?document.body.clientWidth-TREE.offsetWidth:window.innerWidth-TREE.offsetWidth);

//  alert('fixmainsizes dh='+dh+',ih='+ih+',new='+(dh+ih)+'/'+dw);
  TREE.style.height=(dh+ih)+'px';
  IFRAME.style.height=(dh+ih)+'px';
  IFRAME.style.width=dw+'px';

}



