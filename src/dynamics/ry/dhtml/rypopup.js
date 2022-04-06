//  File:         rypopup.js
//  Description:  Implements popup menu

Popup.prototype.elem;
Popup.prototype.imgdir;
Popup.prototype.TABLE;
Popup.prototype.menu;

Popup.prototype.clear=function(){
  this.TABLE.style.visibility = 'hidden';
  if(mainapp && mainapp.dyntree) mainapp.dyntree.reselect();
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
  this.clear();
  action(e.id);
}

Popup.prototype.init=function(e){
  if(this.clickoutside()) return;
  if(e.ctrlKey) return; 
  e=window.fixEvent(e);
  var src=e.target;
  if(src&&(src.nodeName=='TH'||src.parentNode.nodeName=='TH')) return; // Browse
  while(src.nodeName!='BODY' && src.className!='dyntree') src=src.parentNode;
  this.offset=window.main.document.getElementById('app').offsetTop;
  if(src.className=='dyntree') return window.app.dyntree.popup(e);
  this.make(this.menu,e.clientX+app.frameObject.tag.offsetLeft,e.clientY+app.frameObject.tag.offsetTop);
}

Popup.prototype.initmain=function(e){
  if(this.clickoutside()) return;
  if(e.ctrlKey) return; 
  e=window.fixEvent(e);
  this.offset=0;
  this.make(this.menu,e.clientX,e.clientY);
}

Popup.prototype.clickoutside=function(){
  if(this.TABLE.style.visibility=='visible'){
    this.clear();
    return true;
  }
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
        var c='';
        if(e[3]&&this.imgdir!='none') c='<img src="'+(this.imgdir?e[3].replace(/\.\.\/img/gi,this.imgdir):e[3])+'">';
        TD.innerHTML=c+e[2];
      }
    }
    TABLE.style.visibility='visible';
    var top=y-TABLE.rows.length*10+offset;
    if(top<3) top=3;
    TABLE.style.top=(top)+'px';
    TABLE.style.left=(x-20)+'px';
  }
}

Popup.prototype.start=function(){}

function Popup(e){
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
  this.elem.innerHTML='<span></span><span></span><span></span><span></span>';
  this.elem.innerHTML = '<TABLE'
    +' onclick="main.popup.onclick(event)"' 
    +' onmouseover="main.popup.onmouseover(event)"' 
    +' onmouseout="main.popup.onmouseout(event)"' 
    +'></TABLE>';
  this.TABLE=this.elem.getElementsByTagName('TABLE')[0];
  window.document.oncontextmenu=function(e){popup.initmain(e?e:window.event);};
}

