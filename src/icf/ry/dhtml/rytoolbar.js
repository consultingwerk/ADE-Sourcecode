//  File:         rytoolbar.js
//  Description:  Implements The main screen toolbar


Toolbar.prototype.elem;
Toolbar.prototype.menu;
Toolbar.prototype.panel=[];
Toolbar.prototype.imgdir;
Toolbar.prototype.cur;


Toolbar.prototype.clear=function(){
  var e=this.elem;
  while(e.hasChildNodes()) 
    e.removeChild(e.lastChild);
}

Toolbar.prototype.initPanel=function(m){
  this.render(this.panel,m);
  this.panel=[];  
}

Toolbar.prototype.start=function(){
  this.render(this.menu,this.elem);
}

Toolbar.prototype.render=function(menu,DIV){
  var cTools='';
  var add='';
  for(var i=0;i<menu.length;i++){
    var e=(menu[i]+'||').split('|');
    if(cTools.indexOf('|'+e[1]+'|')>-1 && e[1]>'') continue;
    if(e[2]!=''){
      cTools+='|'+e[1]+'|';
      add=(e[2]).replace('&'," class='tool "+(e[1].split('.')[0]=='nolink'?'nolink':'enable')+"' id='"+e[1]+"' name='"+e[1]+"'");
    }
    var c=add.split("'");
    var IMG=DIV.appendChild(document.createElement('img'))
    IMG.className=c[1];
    IMG.id=c[3];
    IMG.name=c[5];
    IMG.src=(this.imgdir?c[7].replace(/\.\.\/img/gi,this.imgdir):c[7]);
    IMG.title=c[9];
//    var span=document.createElement('span');
//    elem.appendChild(span);
    ;
  }
}

Toolbar.prototype.focus=function(e){
  if(this.cur && this.cur.className=='tool over') this.cur.className='tool enable';
  if(!e) return;
  e.className='tool over';
  this.cur=e;
}

Toolbar.prototype.initMouseOver=function(e){
  e.onmouseover=function(e){
    var src=window.fixEvent(e?e:window.event).target;
//    if(src.nodeName=='IMG') src=src.parentNode;    
    if(src.className=='tool enable') toolbar.focus(src);
    if(src.className=='tool disable') toolbar.focus(null);
  }
  e.onmouseout=function(e){
    var src=window.fixEvent(e?e:window.event).target;
    if(src==toolbar.cur) toolbar.focus(null);
  }
}

function Toolbar(e){
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
  this.initMouseOver(e);
  e.onclick=function(e){
    var src=window.fixEvent(e?e:window.event).target;
//    if(src.nodeName=='IMG') src=src.parentNode;    
    if(src.className!='tool over' && src.className!='tool enable') return false;
    window.action(src.id);
    if(src.className=='tool enable') src.className='tool over';
  }
}

toolbar=new Toolbar(maindoc.getElementById('toolbar'));
menuobjects[menuobjects.length]=toolbar;
