//  File:         rymenubar.js
//  Description:  Implements drop down menubar

/*** Functions for the menu section *****/
Menubar.prototype.childActive=null;
Menubar.prototype.menuActive=null;
Menubar.prototype.lastHighlight=null;
Menubar.prototype.active=null;
Menubar.prototype.elem;
Menubar.prototype.imgdir;


Menubar.prototype.fClick=function(TD) {
  with(this){
    if(!TD) return deactivate(this);
    while(TD.nodeName!='TD' && TD.nodeName!='TH' && TD.nodeName!='DIV') TD=TD.parentNode; // Find TD-tag
    if(TD.nodeName=='DIV') return;
    if(active){
      if(TD.nodeName=='TH') return deactivate(this);
      if(TD.getElementsByTagName('TABLE').length>0) return;
      deactivate(this);
      if(TD.id && TD.nodeName=='TD' && TD.className=='over') action(TD.id);
      return;
    } 
    if(TD.nodeName=='TH'){
      openMenu(TD);
      this.active=TD;
    }
  }
  function deactivate(tgt){
    with(tgt){
      cleanupMenu(menuActive);
      if(menuActive) menuActive.className=menuActive.nodeName=='TH'?'':'enable';
      if(childActive) childActive.className='enable';
      tgt.menuActive=null;
      tgt.childActive=null;
      tgt.active=false;
      tgt.lastHighlight=null;
    }
    if(!document.all || !app) return;
    var a=app.document.getElementsByTagName('SELECT');
    for(var i=0;i<a.length;i++)	
      if(a[i].getAttribute('remember')) 
        a[i].style.visibility=a[i].getAttribute('remember');
  }	
}



Menubar.prototype.openMenu=function(TD) {
  with(this){
    if(document.all && !active && app){    // Microsoft bugfix
      var a=app.document.getElementsByTagName('SELECT');
      for(var i=0;i<a.length;i++){
      	a[i].setAttribute('remember',a[i].style.visibility!='hidden'?'visible':'hidden');
      	a[i].style.visibility='hidden';
      }
    }
    var TABLE=TD.lastChild;
    if(TABLE && "||raise|sink|over|".indexOf('|'+TD.className+'|')>-1) {
      if(TABLE.className!='root'){
        TABLE.style.display='block';
        TABLE.cellspacing=0;
        TABLE.cellpadding=0;
        TABLE.style.top =( TD.offsetTop  +(TD.nodeName=='TH'?TD.offsetHeight-2:-9))+'px';
        TABLE.style.left=((document.all?0:TD.offsetLeft)+(TD.nodeName=='TH'?-3:TD.offsetWidth-5))+'px';
      }
      if(TD.nodeName=='TH') {
        TD.className='sink';
        this.menuActive=TD;
      } else 
        this.childActive=TD;
    }
  }
}


Menubar.prototype.doHighlight=function(TD) {
  with(this){
    while(TD.nodeName!='TD' && TD.nodeName!='TH' && TD.nodeName!='DIV') TD=TD.parentNode; // Find table-cell
    if(TD.nodeName=='DIV') return;
    if(TD.nodeName=='TH') {
      if(menuActive && menuActive!=TD) menuActive.className=menuActive.nodeName=='TH'?'':'enable';
      TD.className=(active?'sink':'raise');
      if(active && menuActive!=TD) {
        cleanupMenu(menuActive);
        active=TD;
        openMenu(TD);
      }
      this.menuActive=TD;
      return;
    } 
    if(TD.nodeName!='TD' || !active) return;

    if(childActive){
      var f=fContains(childActive,TD);
      if(!f){   // Cleanup child
        cleanupMenu(childActive)
        childActive=null;      
      }
    }
    if(TD.nodeName=="TD") {
      if(active && active.className=='over' && active!=childActive) active.className='enable';   // remove highlight
      this.active=TD;
      this.lastHighlight=TD;         
      if(active.className=='enable'){
        active.className='over';         // highlight
        if(active.lastChild && active.lastChild.nodeName=='TABLE') openMenu(active);     // Open child menu
      }
    }
  }
  function fContains(outer,ch){
    while (ch.nodeName!='BODY') {
      if(ch==outer) return true;
      ch=ch.parentNode;
    }
    return false;
  }
}

Menubar.prototype.cleanupMenu=function(el) {
  if(el==null) return;
  var TABLE=el.getElementsByTagName('TABLE');
  for (var i=0;i<TABLE.length; i++) TABLE[i].style.display='none';
}


/*******************************/
/**  Keyboard handler        ***/
/*******************************/

Menubar.prototype.onkeydown=function() {
  with(this){
    if(!active) return;
    switch (event.keyCode) {
    case 13: lastHighlight.click(); break;
    case 39:  // right
      if((lastHighlight==null) || (lastHighlight.lastChild==null && lastHighlight.lastChild.nodeName=='TABLE')) {
        var idx=menuActive.cellIndex;
        if(idx==getElement(menuActive,'TR').cells.length-2) idx=0;
        else idx++;
        newItem=getElement(menuActive,'TR').cells[idx];
      }
      else newItem=lastHighlight.lastChild.rows[0].cells[0]
      doHighlight(newItem)
      break;
    case 37: //left
      if(lastHighlight==null) {
        var idx=menuActive.cellIndex;
        if(idx==0) idx=getElement(menuActive,'TR').cells.length-2;
        else       idx--;
        newItem=getElement(menuActive,'TR').cells[idx]
      } else {
        newItem=getElement(lastHighlight,'TR')
        while (newItem.nodeName!="TD") newItem=newItem.parentElement
      }
      doHighlight(newItem)
      break;
    case 40: // down
       if(lastHighlight==null) {
         itemCell= menuActive.lastChild;
         curCell=0;
         curRow =0;
       }
       else {
         itemCell=getRootTable(lastHighlight)
         if(lastHighlight.cellIndex==getElement(lastHighlight,'TR').cells.length-1) {
           curCell=0
           curRow=getElement(lastHighlight,'TR').rowIndex+1
           if(getElement(lastHighlight,'TR').rowIndex==itemCell.rows.length-1)
             curRow=0
         } else {
           curCell=lastHighlight.cellIndex+1
           curRow=getElement(lastHighlight,'TR').rowIndex
         }
       }
       doHighlight(itemCell.rows[curRow].cells[curCell])
       break;
    case 38: // up
       if(lastHighlight==null) {
         itemCell=menuActive.lastChild;
         curRow=itemCell.rows.length-1;
         curCell= itemCell.rows[curRow].cells.length-1;
        }
       else {
         itemCell=getRootTable(lastHighlight)
         if(lastHighlight.cellIndex==0) {
           curRow=getElement(lastHighlight,'TR').rowIndex-1
           if(curRow==-1)
             curRow=itemCell.rows.length-1
           curCell=itemCell.rows[curRow].cells.length-1
          } else {
           curCell=lastHighlight.cellIndex - 1
           curRow=getElement(lastHighlight,'TR').rowIndex
         }
       }
       doHighlight(itemCell.rows[curRow].cells[curCell])
       break;
      if(lastHighlight==null) {
         curCell=menuActive.lastChild;
         curRow=curCell.rows.length-1
       }
       else {
         curCell=getRootTable(lastHighlight)
         if(getElement(lastHighlight,'TR').rowIndex==0)
           curRow=curCell.rows.length-1
         else
           curRow=getElement(lastHighlight,'TR').rowIndex-1
       }
       doHighlight(curCell.rows[curRow].cells[0])
       break;
    }
  } 
  function getRootTable(el) {
    el=el.offsetParent;
    if(el.nodeName=='TR'){
      el=el.offsetParent;
    }
    return el;
  }
  
  function getElement(el,nodeName) {
    while(el && el.nodeName!=nodeName) el=el.parentElement;
    return el;
  }
}


/*******************************/
/**  Menubar construction    ***/
/*******************************/

Menubar.prototype.clear=function(){
  this.innerHTML='';
}

Menubar.prototype.start=function(){
  with(this){
    var arr=[];                        // Creating collection of root menues
    var root;
    for(var i=0;i<menu.length;i++){
      var e=(menu[i]).split('|');
//      if(e[1]=='') continue;
      if(e[0]<2){
      	 root=e[1];
      	 if(!arr[root]) arr[root]=[e[2]];
      } else 
        arr[root][arr[root].length]=menu[i];
    }

    var HTML='';
    for(var a in arr){
      var add='', last=1;
      add+='\n  <th id="'+a+'">'+arr[a][0];     // Root menu
      for(var i=1;i<arr[a].length;i++){         // Menu-entries
        var e=(arr[a][i]).split('|');
        add+=closeTag(last,e[0])+'\n    <tr><td class="';
        add+=(e[2]==''?'break"><hr>':(e[1].split('.')[0]=='nolink'?'nolink':'enable')+'" name="'+e[1]+'" id="'+e[1]+'">'
           +(this.imgdir?(this.imgdir=='none'?e[2].replace(/\<img(.*)\' \/\>/g,''):e[2].replace(/\.\.\/img/gi,this.imgdir)):e[2]));
        last=e[0]*1;
      }
      add+=closeTag(last,1);
      HTML+=add;
    }
    if(HTML>'') HTML='<table class="root"><tr>'+HTML+'</tr></table>';
    elem.innerHTML=HTML;

    /*** Initialization of menu tags and positioning ***/
    a=elem.getElementsByTagName('TD');
    for(var i=0;i<a.length;i++) a[i].noWrap=true;

    /*** Initializing table props ***/
    var a=elem.getElementsByTagName('TABLE');
    for(var i=1; i<a.length;i++){
      a[i].style.display='none'
//      a[i].style.visibility='hidden'
    }
  }  
  function closeTag(last,i){
    var add='';
    var close=(i>last?'':(i>1?'</td></tr>':'</th>'));
    while(last<i){   // up level
      last++;
      if(i>2) add+='<img class="arrow" src="../img/ws_menuarrow.gif">';
      add+='<table class=menu>';
    }
    while(last>i){   // down level
      last--;
      add+='\n</td></tr></table>';
    }
    return add+close;
  }	
  
}

Menubar.prototype.mouseout=function(src){
  if(src.nodeName=='#text') src=src.parentNode;
  with(this){
    if(!active && menuActive && src.nodeName=='TH'){ 
      menuActive.className='';  
      this.menuActive=null;
    }
  }
}


function Menubar(e){
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
  e.onmouseover=function(e){menubar.doHighlight(fixEvent(e?e:window.event).target);}
  e.onmouseout=function(e){menubar.mouseout(fixEvent(e?e:window.event).target);}  
  e.onclick=function(e){menubar.fClick(fixEvent(e?e:window.event).target);}
//  e.onkeydown=this.onkeydown;
}

var menubar=new Menubar(document.getElementById('menubar'));
menuobjects[menuobjects.length]=menubar;

