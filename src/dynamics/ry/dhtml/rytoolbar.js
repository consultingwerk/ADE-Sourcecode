//  File:         rytoolbar.js
//  Description:  Implements The main screen toolbar


Toolbar.prototype.elem;
Toolbar.prototype.menu;
Toolbar.prototype.imgdir;
Toolbar.prototype.cur;
Toolbar.prototype.wdo='wbo';

Toolbar.prototype.clear=function(){
  this.elem.innerHTML='';
}

Toolbar.prototype.start=function(){
  this.elem.innerHTML=this.render(this.menu,true);
  if(!mainapp.tools) mainapp.tools=new Object();
  for(var e in mainapp.toolbar){   // Register toolbar with appropriate WDOs
    if(!mainapp.tools[e]) mainapp.tools[e]=[];
    if(!app.tools[e]) app.tools[e]=[];
    var buttons=app.wbo.registerMenu(this.elem,true);
    mainapp.tools[e][0]=buttons;
    app.tools[e][0]=buttons;
  }  
}

Toolbar.prototype.render=function(menu,lMain,vertical){
  var cTools=new Object();
  var add=[];
  for(var i=0;i<menu.length;i++){
    if(menu[i]=='') continue;
    var e=(menu[i]+'|||').split('|');
    if(cTools[e[1]]) continue;
    if(e[1]=='break'){
      add.push('<td class="break"></td>');
    } else {
      cTools[e[1]]=true;
      var s=e[1].split('.');
      // When main toolbar then make sure it's getting reset
      if(lMain && s.length>1 && app['_'+s[0]]) app['_'+s[0]].status[s[1]]=true;

      var cImg=this.imgdir?e[3].replace(/\.\.\/img/gi,this.imgdir):e[3];
      add.push('<td class="'+(s.shift()=='nolink'?'nolink':'enable')
          +'" img="'+cImg+'" id="'+e[1]+'" name="'+e[1]+'" title="'+e[2]+'"><img src="'
          +cImg+'"></td>');
    }	
  }
  if(vertical) 
  	return '<table class="panel vertical"'
   +' onmouseover="window.main.app=window;window.main.toolbar.mOver(event)"'
   +' onmouseout="window.main.toolbar.mOut(event)"'
   +' onclick="window.main.app=window;window.main.toolbar.mClick(event)"><tr>'+add.join('</tr><tr>')+'</tr></table>';
  return '<table class="panel horizontal"'
   +' onmouseover="window.main.app=window;window.main.toolbar.mOver(event)"'
   +' onmouseout="window.main.toolbar.mOut(event)"'
   +' onclick="window.main.app=window;window.main.toolbar.mClick(event)"><tr>'+add.join('')+'</tr></table>';
}

Toolbar.prototype.focus=function(e){
  if(this.cur && this.cur.className=='over')
  	this.cur.className='enable';
  if(!e || e.id=='break') return;
  e.className='over';
  this.cur=e;
} 

Toolbar.prototype.mOut=function(e){
  if(document.all && !e) return;   // IE problem with Lookup button
	var src=document.all?e.srcElement:e.target
  if(src.nodeName!='TD'&&src.nodeName!='SPAN') src=src.parentNode;
  if(src==toolbar.cur) toolbar.focus(null);
}
Toolbar.prototype.mOver=function(e){
	var src=document.all?e.srcElement:e.target;
  if(src.nodeName!='TD'&&src.nodeName!='SPAN') src=src.parentNode;
  if(src.className=='enable')  this.focus(src);
  if(src.className=='disable') this.focus(null);
}
Toolbar.prototype.mClick=function(e){
	var src=document.all?e.srcElement:e.target
  if(src.nodeName!='TD'&&src.nodeName!='SPAN') src=src.parentNode;
  if(src.className!='over' && src.className!='enable') return false;
  window.userAction(src.id);
  if(src.className=='enable') src.className='over';
}

function Toolbar(e){
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
}
