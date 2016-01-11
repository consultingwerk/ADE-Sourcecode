//  File:         ryhotkey.js
//  Description:  Implements Hotkey control


Hotkey.prototype.hotkeys='|';
Hotkey.prototype.menu;
Hotkey.prototype.browsenav;

function Hotkey(){
  window.document.onkeydown=function(e){window.hotkey.hotkey(e?e:window.event);}
}

Hotkey.prototype.clear=function(){
  this.hotkeys='|';
}

Hotkey.prototype.start=function(){
  with(this){
    for(var i=0;i<menu.length;i++){
      var k=menu[i].split('|');
      var curr=null;
      if (k[2]=='') continue;
      var h=hotkeys.split('|');
      for(var j=1;j<h.length;j+=2){
        if(h[j]=='#'+k[2]) curr=j;
      }
      if(curr==null){
        hotkeys+='#'+k[2]+'|'+k[1]+'|';
      } else {
        h[curr]='#'+k[2];
        hotkeys=h.join('|');
      }
    }
  }
}

Hotkey.prototype.hotkey=function(e){
  with(this){
    var src=(document.all?e.srcElement:e.target);	
    if(src && src.getAttribute('lookup')) window.action(src.id+'.change|'+src.getAttribute('dfield'));
    var c = '';
    if (e.shiftKey) c+='S';
    if (e.ctrlKey)  c+='C';
    if (e.altKey)   c+='A';
    c+='_';
    if (e.keyCode > 111 && e.keyCode < 124)
      c+='F' + (e.keyCode - 111);     // Function keys
    else                              // Other characters
      c+=String.fromCharCode(e.keyCode).toUpperCase();
    var pos = hotkeys.indexOf('|#' + c + '|');
    if (pos < 0){                     // Check for special characters like cursor & enter by number
      c=c.split('_')[0]+'_'+e.keyCode;
      pos = hotkeys.indexOf('|#' + c + '|')
    }
    if (pos > -1){
      var act=(hotkeys.substr(pos + c.length)).split('|')[1];
      window.status='hotkey ' + c + ' ==> ' + act;
      window.fixEvent(e);
      window.action(act);
    } else {
      var cNav=null;
      if(e.keyCode==40) cNav='next';
      if(e.keyCode==38) cNav='prev';
      if(e.keyCode==35) cNav='last';
      if(e.keyCode==36) cNav='first';
      if(src.nodeName=='INPUT'||src.nodeName=='TEXTAREA'){
      	if(e.keyCode==9) return;
        if(e.keyCode<35||e.keyCode>40) app.wbo.editfield(src);
      	return;
      }
      if(cNav && browsenav){
        window.fixEvent(e);
        window.action(browsenav+'.'+cNav);
      }
//      window.status='hotkey ' + c + ' ' + e.keyCode + ' not found, last nav=' + browsenav;
    }
  }
}

hotkey=new Hotkey();
menuobjects[menuobjects.length]=hotkey;


