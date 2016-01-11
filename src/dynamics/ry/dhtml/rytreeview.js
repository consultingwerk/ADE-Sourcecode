//  File:         rytreeview.htc
//  Description:  Implements Treeview menu
//------------------------------------------------------------------->

Treeview.prototype.TABLE;
Treeview.prototype.elem;
Treeview.prototype.imgdir;
Treeview.prototype.menu;
Treeview.prototype.ds;
Treeview.prototype.staticmenu;
Treeview.prototype.staticload='|';
Treeview.prototype.staticbegin=0;


Treeview.prototype.clear=function(){
  var t=this.TABLE;
  while(t.rows.length>this.staticbegin && !t.rows[t.rows.length-1].getAttribute('node')) 
    t.deleteRow(t.rows.length-1);
}

Treeview.prototype.start=function(rootname){
  if(this.TABLE.rows.length==0 && this.menu.length==0) action('main.treeview.hide');
  if(this.menu.length==0) return;
  if(this.staticload.indexOf('|'+rootname+'|')>-1) return;
  with(this){
    var TR=TABLE.insertRow(TABLE.rows.length);
    TR.setAttribute('level',0);
    var TD=TR.insertCell(0);
    TD.id=rootname.replace(/ /g,'');
    TD.className='enable';
    TD.innerHTML='<img src="../img/folderclosed.gif" />'+rootname;
    var level=0;
    for(var i=0;i<menu.length;i++){
      var lastTR=TR;
      var e=(menu[i]+'||').split('|');
      if(e[2]=='') continue;
      TR=TABLE.insertRow(TABLE.rows.length);
      var cTree='';
      for(var j=0;j<e[0];j++) cTree+='<img src="../img/ws_tree6.gif" />';
      TR.setAttribute('level',e[0]);
      if(e[0]>level) lastTR.setAttribute('tree',level==0?'open':'closed');

      var TD=TR.insertCell(0);
      TD.id=e[1];
      TD.className=(e[1].split('.')[0]=='nolink'?'nolink':'enable');
      if(TD.className=='nolink') TR.className='nolink';
      TD.innerHTML=cTree+(e[3] ? '<img src="'+(this.imgdir?(e[3].replace(/\.\.\/img/gi,this.imgdir)):e[3])+'">':'<img src="../img/folderclosed.gif" />')+window.formatMenuLabel(e[2]);
      TR.style.display=e[0]>1?'none':'block';
      level=e[0];
    }
    initialize();
  }
  if(this.staticmenu.indexOf('|'+rootname+'|')>-1){
    this.staticload+=rootname+'|';	
    this.staticbegin=this.TABLE.rows.length;
  }
  if(this.TABLE.rows.length>0) action('main.treeview.show');
}


Treeview.prototype.initialize=function(){
  var a=new Array(10);
  var l=this.TABLE.rows.length;
  for(var i=l;i>0;i--){
    var TR=this.TABLE.rows[i-1];
    var level=TR.getAttribute('level');
    var img=TR.cells[0].getElementsByTagName('IMG');
    for(var j=1;j<a.length;j++){
      if(j==level){
        TR.setAttribute('last',a[j]);
        this.setImage(TR);
        a[j]=true;
      } else if(j<level) img[j-1].setAttribute('src',a[j]?'../img/ws_tree3.gif':'../img/ws_tree7.gif');
      else a[j]=null;       // erase larger 	
    }	 
  }  
}

Treeview.prototype.onclick=function(e){
  var testimg=(e.nodeName=='IMG');
  while(e.nodeName!='TR') e=e.parentNode;
  var tree=e.getAttribute('tree');  
  if(!testimg){
    if(e.cells[0].id && e.cells[0].className=='enable'){
      if(e.getAttribute('node')) this.folderLaunch(e);
      else                       action(e.cells[0].id);
    }
    return;
  }
  if(tree){
    if(tree=='unknown')   this.folderFetch(e);
    else if(tree=='open') this.folderCollapse(e);
    else                  this.folderExpand(e);
  }
}

Treeview.prototype.folderCollapse=function(e){            // Change the icon and set status to closed
  var level=e.getAttribute('level');
  e.setAttribute('tree','closed');
  this.setImage(e);
  e=e.nextSibling;
  while(e && e.getAttribute('level')>level) {
    e.style.display='none';  
    e=e.nextSibling;
  }
}

Treeview.prototype.folderExpand=function(e){            // Change the icon and set status to open
  e.setAttribute('tree','open');
  this.setImage(e);
  this.openNode(e);
}

Treeview.prototype.openNode=function(e){
  var opt=e.getAttribute('tree')=='open';
  var level=e.getAttribute('level');
  var e=e.nextSibling;
  while(e && e.getAttribute('level')>level) {
    if(opt) e.style.display='block';  
    if(e.getAttribute('tree')) e=this.openNode(e);
    else                       e=e.nextSibling;
  }
  return e;
}

Treeview.prototype.setImage=function(e){
  var level=e.getAttribute('level');
  if(level==0) return;
  var tree=e.getAttribute('tree');
  var last=e.getAttribute('last');
  e.cells[0].getElementsByTagName('IMG')[level-1].setAttribute('src', tree ?
    (tree=='open'?'../img/ws_tree8.gif':'../img/ws_tree5.gif'):   // Minus / PLUS
    (last?'../img/ws_tree2.gif':'../img/ws_tree4.gif'));          // None /last    	
}

Treeview.prototype.branch=function(name,key,ds,ch){
//  alert('br='+name+'/'+key+'/'+ds)
  action('main.treeview.show');
  if(!key){
    var TR=this.TABLE.insertRow(this.TABLE.rows.length);
    TR.setAttribute('level',0);
    TR.setAttribute('node',name);
    TR.setAttribute('ds',ds);   // Datasources
    var TD=TR.insertCell(0);
    TR.id='tvroot';
    TD.className='enable';
    TD.innerHTML='<img src="../img/folderclosed.gif" />'+window.app.document.title;
    this.fillBranch(TR,ch,ds);
  } else {
    this.fillBranch(this.TABLE.rows[key],ch,ds);
  }		
}

Treeview.prototype.fillBranch=function(node,ch,ds){
  var ri=node.rowIndex;
  var level=node.getAttribute('level')*1+1;
  if(!ch) node.removeAttribute('tree');
  this.setImage(node);
  var cTree='';
  node.setAttribute('tree','open');
  node.setAttribute('ds',ds);
  var img=node.cells[0].getElementsByTagName('IMG');
  for(var i=0;i<level-1;i++)
    cTree+='<img src="'+img[i].getAttribute('src')+'" />';
  cTree+='<img src="../img/ws_tree6.gif" />';
  for(var i=0;i<ch.length;i++){
    var e=(ch[i].replace(/ry\/img/g,'../img')).split('|');
    var TR=this.TABLE.insertRow(++ri);
    TR.setAttribute('level',level);
    TR.setAttribute('tree',e[5]);
    TR.setAttribute('node',e[0]);
    var TD=TR.insertCell(0);
    TR.id=e[6];                      // Rowid
    TD.id=e[1];                      // Launch container
    TD.className='enable';
    TD.innerHTML=cTree+'<img src="'+(this.imgdir?e[3].replace(/\.\.\/img/gi,this.imgdir):e[3])
                +'" src2="'+(this.imgdir?e[4].replace(/\.\.\/img/gi,this.imgdir):e[4])+'" />'+window.formatMenuLabel(e[2]);
  }	  
  this.initialize();
}

Treeview.prototype.folderFetch=function(e){           
  var level=e.getAttribute('level');  
  var prog=e.cells[0].id;  
  var lookup=e.getAttribute('node')+'|'+e.id+'|'+e.rowIndex;  // container|node|rowid|rowindex
  window.app.document.form.lookup.value='|'+lookup;   
  action('server.wbo.treeview');
  action('wbo.submit');
//  alert('Branch:'+lookup+'='+e.getAttribute('ds'))
}

Treeview.prototype.folderLaunch=function(e){          
  var prog=e.cells[0].id;  
  var lookup=e.getAttribute('node')+'|'+e.id+'|'+e.rowIndex;  // container|node|rowid|rowindex
  appcontrol.cLookup='TREE='+lookup;   
  action('prg.'+prog)
//  alert('Container:'+prog+'|'+lookup+'='+e.getAttribute('ds'))
}

Treeview.prototype.action=function(c,prm){ 
  c=c.split('.');	
  if(c[c.length-1]=='add'){
    alert('Add '+c[0])
  }
}

Treeview.prototype.popup=function(e){          
  e=window.fixEvent(e);
  var src=e.target;
  while(src.nodeName!='TR') src=src.parentNode;
  var a=src.getAttribute('ds');
  if(!a) return;
  a=a.split('|');
  var make=[];
  for(var i=0;i<a.length;i++){
    make[i]='2|treeview.'+a[i]+'.add|Add '+a[i];	
  }	
  popup.make(make,e.clientX,e.clientY);
}

function Treeview(e){
  this.ds=new Array();
  this.elem=e;
  this.imgdir=e.getAttribute('imgdir');
  this.TABLE=e.getElementsByTagName('TABLE')[0];
  this.staticmenu='|'+e.getAttribute('static')+'|';
  e.onclick=function(e){treeview.onclick(window.fixEvent(e?e:window.event).target) }
  e.oncontextmenu=function(e){treeview.popup(e?e:window.event);};
}

