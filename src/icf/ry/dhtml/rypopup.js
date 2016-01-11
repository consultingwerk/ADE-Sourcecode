//  File:         rypopup.js
//  Description:  Implements popup menu

Popup.prototype.elem;
Popup.prototype.imgdir;
Popup.prototype.TABLE;
Popup.prototype.APP;
Popup.prototype.menu;

Popup.prototype.clear=function(){
  this.remove();
}

Popup.prototype.remove=function(){
  this.TABLE.style.visibility = 'hidden';
}

Popup.prototype.onmouseout=function(e){
  e=fixEvent(e).target;
  if(e.nodeName!='TD') e=e.parentNode;
  if(e.nodeName=='TD' && e.className=='over') e.className='enable';
}

Popup.prototype.onmouseover=function(e){
  e=fixEvent(e).target;
  if(e.nodeName!='TD') e=e.parentNode;
  if(e.nodeName=='TD' && e.className=='enable') e.className='over';
}

Popup.prototype.onclick=function(e){
  e=fixEvent(e).target;
  if(e.nodeName!='TD') e=e.parentNode;
  if(e.nodeName!='TD') return false;
  this.remove();
  action(e.id);
}

Popup.prototype.init=function(e){
  if(e.ctrlKey) return; 
  if(e.target&&(e.target.nodeName=='TH'||e.target.parentNode.nodeName=='TH')) return; // Browse
  e=window.fixEvent(e);
  this.make(this.menu,e.clientX+this.APP.offsetLeft,e.clientY+this.APP.offsetTop);
}

Popup.prototype.initmain=function(e){
  if(e.ctrlKey) return; 
  e=window.fixEvent(e);
  this.make(this.menu,e.clientX,e.clientY);
}

Popup.prototype.make=function(m,x,y){
  with(this){
    while(TABLE.rows.length>0) TABLE.deleteRow(0);
    for(var i=0;i<m.length;i++){
      var e=(m[i]).split('|');
      if (e[0]*1 > 1 && e[1]>''){
        var TR=TABLE.insertRow(TABLE.length);
        var TD=TR.insertCell(0);
        TD.className=(e[1].split('.')[0]=='nolink'?'nolink':'enable');
        TD.id       =e[1];
        TD.innerHTML=(this.imgdir?(this.imgdir=='none'?e[2].replace(/\<img(.*)\' \/\>/g,''):e[2].replace(/\.\.\/img/gi,this.imgdir)):e[2]);
      }
    }
    TABLE.style.visibility='visible';
    TABLE.style.top=(y-TABLE.rows.length*10)+'px';
    TABLE.style.left=(x-20)+'px';
  }
}

Popup.prototype.start=function(){}

function Popup(e){
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
  this.elem.innerHTML = '<TABLE'
    +' onclick="main.popup.onclick(event)"' 
    +' onmouseover="main.popup.onmouseover(event)"' 
    +' onmouseout="main.popup.onmouseout(event)"' 
    +'></TABLE>';
  this.TABLE=this.elem.getElementsByTagName('TABLE')[0];
  this.APP=window.document.getElementById('app');
  window.document.oncontextmenu=function(e){popup.initmain(e?e:window.event);};
}

popup=new Popup(maindoc.getElementById('popup'));
menuobjects[menuobjects.length]=popup;

