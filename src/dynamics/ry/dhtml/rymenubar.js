//  File:         rymenubar.js
//  Description:  Implements drop down menubar

/*** Functions for the menu section *****/
Menubar.prototype.active=null;
Menubar.prototype.lastHighlight=null;
Menubar.prototype.activeRoot=null;
Menubar.prototype.elem;      // root DIV tag
Menubar.prototype.imgdir; 
Menubar.prototype.stack=[];  // Open Menu stack

Menubar.prototype.fClick=function(TR) {
  with(this){
    if(!TR) return deactivate(this);
    while(TR.nodeName!='TR' && TR.nodeName!='TH' && TR.nodeName!='DIV') TR=TR.parentNode; // Find TR-tag
    if(TR.nodeName=='DIV') return;
    if(active){
      if(TR.nodeName=='TH') return deactivate(this);
      if(TR.getElementsByTagName('TABLE').length>0) return;
      deactivate(this);
      if(appcontrol.busy) return window.status='Please wait, BUSY processing request.';
      if(TR.id && TR.nodeName=='TR' && TR.className=='over' && !TR.getAttribute('child')) userAction(TR.id);
      return;
    } 
    if(TR.nodeName=='TH'){
      if(!active && document.all && mainapp){    // Microsoft bugfix Hide selction tags
        var a=mainapp.document.getElementsByTagName('SELECT');
        for(var i=0;i<a.length;i++){
          if(a[i].style.visibility=='hidden') continue;
        	a[i].setAttribute('hide',a[i].style.visibility=='hidden'?'hidden':'visible');
        	a[i].style.visibility='hidden';
        }
      }
      openMenu(TR,0);
      this.active=TR;
    }
  }
}

Menubar.prototype.deactivate=function() {
  with(this){
    if(active && document.all && mainapp){
      var a=mainapp.document.getElementsByTagName('SELECT');
      for(var i=0;i<a.length;i++) 
        if(a[i].getAttribute('hide')) a[i].style.visibility=a[i].getAttribute('hide');
    }
    openMenu(null,0);
    active=null;
    lastHighlight=null;
    if(activeRoot){
      activeRoot.className='';
      activeRoot=null;  
    }
  }	
}

Menubar.prototype.openMenu=function(TR,num){
  with(this){
    while(stack.length>num){ // Rid childmenues not needed
      stack.pop(); 
      elem.childNodes[stack.length].innerHTML="";
    }  
    if(!TR) return; // Only cleaning up menues !!
    
    this.active=TR;
    if(TR.nodeName=='TH'){
      createMenu(num
       ,menu[TR.cellIndex+1]
       ,TR.offsetLeft-3
       ,TR.offsetTop+TR.offsetHeight-2);          
      TR.className='sink';
    } else { 
      createMenu(num
       ,stack[stack.length-1][TR.getAttribute('child')]
       ,TR.offsetLeft+TR.offsetWidth-5
       ,TR.offsetTop-9);          
    }
  }
}

Menubar.prototype.doHighlight=function(TR) {
  with(this){
    if(TR.offsetParent.nodeName!='TABLE') return;
    while(TR.nodeName!='TR' && TR.nodeName!='TH') TR=TR.parentNode; // Find table-cell
     
    if(TR.nodeName=='TH'){  // Header cell
      if(activeRoot && activeRoot!=TR) activeRoot.className='';
      this.activeRoot=TR
      TR.className=(active?'sink':'raise');
      if(active && active!=TR){
        this.active=TR;
        openMenu(TR,0);
      }
    } else { 
      if(!active) return;
      if(lastHighlight && lastHighlight.className=='over'
         && this.lastHighlight!=TR) lastHighlight.className='enable';   // remove highlight

      this.lastHighlight=TR;         
      if(active!=TR && !TR.getAttribute('child')) openMenu(null,TR.offsetParent.getAttribute('num')); // Close child
      
      if(TR.className=='enable'){  // highlight
        TR.className='over';   
        if(active!=TR && TR.getAttribute('child')) openMenu(TR,TR.offsetParent.getAttribute('num'));     // Open child menu
      }
      this.active=TR;
    }
  }
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
        var idx=active.cellIndex;
        if(idx==getElement(active,'TR').cells.length-2) idx=0;
        else idx++;
        newItem=getElement(active,'TR').cells[idx];
      }
      else newItem=lastHighlight.lastChild.rows[0].cells[0]
      doHighlight(newItem)
      break;
    case 37: //left
      if(lastHighlight==null) {
        var idx=active.cellIndex;
        if(idx==0) idx=getElement(active,'TR').cells.length-2;
        else       idx--;
        newItem=getElement(active,'TR').cells[idx]
      } else {
        newItem=getElement(lastHighlight,'TR')
        while (newItem.nodeName!="TD") newItem=newItem.parentElement
      }
      doHighlight(newItem)
      break;
    case 40: // down
       if(lastHighlight==null) {
         itemCell= active.lastChild;
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
         itemCell=active.lastChild;
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
         curCell=active.lastChild;
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
    var HTML=[];
    for(var i=1;i<menu.length;i++){
      var e=menu[i][0];
      HTML.push('<th id="'+e[1]+'">'+formatMenuLabel(e[2])+'</th>');
    }
    elem.innerHTML='<span></span><span></span><span></span><span></span>'
                  +'<table class="root"><tr>'+HTML.join('')+'</tr></table>';
  }
}

Menubar.prototype.mouseout=function(src){
  if(src.nodeName=='#text') src=src.parentNode;
  with(this){
    if(!active && activeRoot && src.nodeName=='TH'){ 
      activeRoot.className='';  
      this.activeRoot=null;
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

Menubar.prototype.createMenu=function(index,m,x,y){
  with(this){
    var SPAN=elem.childNodes[stack.length];
    stack[index]=m;
    var c=[];
    for(var i=1;i<m.length;i++){
      var e=m[i][0]; 
      var id=(e[1]).split('.');
      var status='enable';
      if(e[2]==''){
        c.push('<tr class="break"><td colspan="3"><hr></td></tr>');
        continue;
      }
      if(mainapp && mainapp.wbo && id.length>1 && mainapp.wbo.status[id[1]]){ // Check for enabled in wdo
        if(id[0]==''||id[0]=='wdo') id[0]=mainapp.firstwdo;   // Multiple target toolbar...
        status=(mainapp.wdo[id[0]] && mainapp.wdo[id[0]].status[id[1]]?'enable':'disable');
      }
      c.push('<tr class="'
           +(id[0]=='nolink'?'nolink':status)
           +(m[i].length>1?'" child="'+i:'')
           +'" name="'+id.join('.')+'" id="'+id.join('.')+'"><td>');
      if(e[3]&&this.imgdir!='none') c.push('<img src="'+(this.imgdir?e[3].replace(/\.\.\/img/gi,this.imgdir):e[3])+'">');
      c.push('</td><td>'+formatMenuLabel(e[2])+'</td><td>');
      if(m[i].length>1) c.push('<img class="arrow" src="../img/ws_menuarrow.gif" align="right">');
      c.push('</td></tr>');
    }
    SPAN.innerHTML='<table cellspacing="0" class="menu" num="'+stack.length+'" style="top:'+Math.round(y)+'px;left:'+Math.round(x)+'px;"'+'>'+c.join('')+'</table>';
  }
}

