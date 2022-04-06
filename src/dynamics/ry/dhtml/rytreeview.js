//  File:         rytreeview.htc
//  Description:  Implements Dynamic Treeview (DynTree)
//------------------------------------------------------------------->

function Treeframe(e){}
Treeframe.prototype.elem;
Treeframe.prototype.init=function(e){ 
  this.elem=e;
}

function Dyntree(e){}
Dyntree.prototype.TABLE;
Dyntree.prototype.elem;
Dyntree.prototype.struct;
Dyntree.prototype.imgdir;
Dyntree.prototype.sortnode='-1';
Dyntree.prototype.autosort=true;
Dyntree.prototype.insertnode=0;
Dyntree.prototype.currentopen=null;
Dyntree.prototype.selected=null;
Dyntree.prototype.currentsort=true;
Dyntree.prototype.addfrom=null;
Dyntree.prototype.currentwdo=null;


 
Dyntree.prototype.init=function(e){ 
  e.innerHTML='<table class="dyntree" border="0" cellpadding="0" cellspacing="0" '
             +'ondblclick="window.dyntree.ondblclick(window.main.fixEvent(event?event:window.mainapp.event).target);"></table>';
  this.elem=e;
  this.imgdir='../img';
  this.TABLE=e.getElementsByTagName('TABLE')[0];
  this.autosort=e.getAttribute('autosort')=='yes';
  e.onclick=function(e){window.mainapp.dyntree.onclick(window.main.fixEvent(e?e:window.mainapp.event).target) }
  mainapp.dyntree=this;
  this.currframe=null;
  this.title=mainapp.document.title;
}

// Empties a treeview childnodes or all if parent unspecified
Dyntree.prototype.clear=function(parent){
  var t=this.TABLE;
  var level= parent?t.rows[parent-1].getAttribute('level'):0;
  var ri=    parent?parent:0;
  while(t.rows[ri] && (!t.rows[ri].getAttribute('level') 
                     || t.rows[ri].getAttribute('level') > level)){
     var row=t.rows[ri];
     if(row==this.selected) this.selected=null;      
     if(row==this.currentopen) this.currentopen=null;      
     t.deleteRow(ri);
  }
}

// Loads the treeview structure as given from the initial request
Dyntree.prototype.structure=function(a){
  this.struct=new Object();
  for(var i=0;i<a.length;i++){
    var s=a[i].split('|');
    this.struct[s.shift()]=s;
  }
  for(var e in this.struct){
    var prop=this.struct[e];
    var parent=this.struct[prop[0]];
    if(parent && e!=prop[0]) parent[11]='more';      // PLUS - Child nodes
    if(prop[6]!=',') prop[11]='more';  // PLUS - Structured nodes
    prop[4]=prop[4].replace(/ry\/img/g,'../img');
    prop[5]=prop[5].replace(/ry\/img/g,'../img');
    if(prop[10]=='sdo'){ // Configure merge fields
      var index=[];
      if(!mainapp['_'+prop[8]]) alert('Error getting datasource '+prop[8]);
      var hdata=mainapp['_'+prop[8]].hdata;
      var fields=prop[3].split(',');
      for(var i=0;i<fields.length;i++)
        index.push(hdata.index[fields[i].split('.').pop()]);
      prop[3]=index;
    }
  }
  this.struct['_more']='_more||...More||../img/treemore.gif|../img/treemore.gif|,|| more|more|mre||||'.split('|');
}

Dyntree.prototype.initTree=function(rootnode){
  this.sortnode=-1;
  this.rootnode=rootnode;
  var str=this.struct[rootnode];
  if(str && str[10]!='prg')
    this.loadData(rootnode,0,1);  
  this.initialize();
  if(this.TABLE.rows.length) this.onclick(this.TABLE.rows[0]);  // Select first node
}

// Loads data for a menu branch
Dyntree.prototype.loadMenu=function(ri,menu){
  this.sortnode=ri;
  var diff=0,last=0;
  if(ri>-1){
    var TR=this.TABLE.rows[ri];
    TR.setAttribute('tree','open');
    this.setImage(TR);
    diff=TR.getAttribute('level')*1;
  }
  
  menu=menu.split(';');
  while(menu.length>0){
    var m=menu.pop().split('|');
    if(m.length<3 || m[1]=='nolink.rule') continue;
    var level=m[0]*1+diff;
    var prefix=this.getPrefix(level);
    var TR=this.TABLE.insertRow(ri+1);
    TR.setAttribute('level',level);
    if(last<=level) TR.id=m[1]; // Launch container
    TR.setAttribute('tree',last>level?'open':'');
    last=level;
    TR.setAttribute('node','_mnu');
    TR.className=m[1].split('.')[0]=='nolink'?'disable':'enable';
    var TD=TR.insertCell(0);
    TD.setAttribute('valign','top');
    TD.innerHTML=prefix+this.getImage(m[3],m[4])+' <font>'+window.formatMenuLabel(m[2])+'</font>';
    if(TR.getAttribute('tree')=='open') this.nodeCollapse(TR);
  }
}
 
// Loads data for an SDO branch
Dyntree.prototype.loadTree=function(ri,nodetype){
  var TR=this.TABLE.rows[ri];
  if(!TR){
    this.loadData(nodetype,0,1);                          // Root nodes
    this.sortnode=ri;
  } else if(TR.getAttribute('node')=='_more'){            // More nodes
    this.loadData(nodetype,ri+1,TR.getAttribute('level')*1);
    this.TABLE.deleteRow(ri);
  } else {                                                // Data nodes
    this.sortnode=ri;
    TR.setAttribute('tree','open');
    this.setImage(TR);
    this.loadData(nodetype,ri+1,TR.getAttribute('level')*1+1); 
  }
}

// Loads data for an Extract Program branch
Dyntree.prototype.loadProg=function(ri,nodename,nodes){
  this.sortnode=ri;
  this.insertnode=ri;
  var prop=this.struct[nodename];
  var level=1;
  if(ri>-1){
    var TR=this.TABLE.rows[ri];
    TR.setAttribute('tree','open');
    this.setImage(TR);
    level=TR.getAttribute('level')*1;
  }
  var cTree=this.getPrefix(level);
  for(var i=0;i<nodes.length;i++){
    var TR=this.TABLE.insertRow(++this.insertnode);
    var str=nodes[i].replace(/ry\/img/g,'../img').split('|');
    str.shift();
    str[11]=prop[11];
    this.createNode(TR,nodename,str,level,cTree,null);
    TR.setAttribute('data',nodes[i]);
  }
}

// Creates nodes from data source or text node
Dyntree.prototype.loadData=function(nodename,ri,level){
  this.insertnode=ri;
  var cTree=this.getPrefix(level);
  var prop=this.struct[nodename];
  var parent=this.TABLE.rows[ri];
  if(prop[10]=='sdo'){
    var hdata=window.mainapp['_'+prop[8]].hdata;
    var last= hdata.batch==-1 ? this.TABLE.rows[ri-1].getAttribute('data') : false;
    for(var i=0;i<hdata.data.length;i++){
      if(last && hdata.data[i]==last) break;
      this.createNode(this.TABLE.insertRow(this.insertnode++),nodename,prop,level,cTree,hdata.data[i]);
    }
    this.currentsort=hdata.batch<1;  // True for when sorting shall be done
    if(hdata.batch>0){
      var more=this.struct['_more'];
      more[1]=nodename+'|'+hdata.batch;
      var TR=this.TABLE.insertRow(this.insertnode++);
      this.createNode(TR,'_more',more,level,cTree,"");
      TR.cells[0].lastChild.setAttribute('title',prop[9]);
      TR.setAttribute('data',hdata.data[hdata.data.length-1]);
    }
  } else {	  
    this.createNode(this.TABLE.insertRow(this.insertnode++),nodename,prop,level,cTree,"");
  }
  if(this.currentopen) this.folderLaunch(this.currentopen.getAttribute('node'),this.currentopen);
}

Dyntree.prototype.getPrefix=function(level){
  var cTree=[];
  for(var i=0;i<level;i++) cTree.push('<img src="../img/ws_tree6.gif" />');
  return cTree.join('');
}

Dyntree.prototype.getLabel=function(prop,data){
  var txt=prop[2];
  if(prop[10]!='sdo') return txt;
  var row=data.split('|');
  for(var j=0;j<prop[3].length;j++) txt=txt.replace('&'+(j+1),row[prop[3][j]]);
  return txt;
}

Dyntree.prototype.getImage=function(img1,img2){
  if(!img1) img1='../img/ws_empty.gif';
  return '<img src="'+img1+'" src2="'+(img2?img2:img1)+'" />';  
}

Dyntree.prototype.createNode=function(TR,nodename,prop,level,prefix,data){
  TR.setAttribute('level',level);
  TR.setAttribute('tree',prop[11]);
  TR.setAttribute('node',nodename);
  TR.id=prop[1];                      // Launch container
  TR.className='enable';
  TR.setAttribute('data',data);
  var TD=TR.insertCell(0);
  TD.setAttribute('valign','top');
  TD.innerHTML=prefix+this.getImage(prop[4],prop[5])+' <font>'+this.getLabel(prop,data)+'</font>';
}

// Fix treeview branching images
Dyntree.prototype.initialize=function(){
  this.sortBranch(this.autosort && this.currentsort);
  var a='|||||||||||||||||||'.split('|');
  var l=this.TABLE.rows.length;
  for(var i=l;i>0;i--){
    var TR=this.TABLE.rows[i-1];
    var level=TR.getAttribute('level');
    var img=TR.getElementsByTagName('IMG');
    for(var j=1;j<a.length;j++){
      if(j==level){
        TR.setAttribute('last',a[j] && l!=i);
        this.setImage(TR);
        a[j]='y';
      } else if(j<level) img[j-1].setAttribute('src',a[j]?'../img/ws_tree3.gif':'../img/ws_tree7.gif');
      else a[j]=null;       // erase larger 	
    }	 
  }  
  mainapp.document.form['do'].value='';
}

// Sort a treeview branch
Dyntree.prototype.sortBranch=function(lSortdata){
  var level=0;
  var ri=0;
  var sort=[];
  var html=[];
  var TR=this.TABLE.rows[ri];
  if(this.sortnode!=-1){
    ri=this.sortnode+1;
    TR=this.TABLE.rows[this.sortnode];
    level=TR.getAttribute('level');
    TR=TR.nextSibling;
  }
  while(TR && TR.getAttribute('level')>level) {
    var nodetype=TR.getAttribute('node');
    html.push(
      [TR.cells[0].innerHTML
      ,TR.getAttribute('node')
      ,TR.getAttribute('tree')
      ,TR.getAttribute('data')
      ,TR.getAttribute('level')
      ,TR.id
      ,TR.className
      ]);
    
    switch(nodetype){
    case '_mnu':   
      sort.push('2'+(100+TR.rowIndex)+' |'+TR.rowIndex);
      break;
    case '_prg':   
      sort.push('3'+TR.cells[0].lastChild.innerHTML.toUpperCase()+' |'+TR.rowIndex);
      break;
    case '_more': 
      sort.push('4|'+TR.rowIndex);
      break;
    default:   
      var prop=this.struct[nodetype];
      switch(prop[10]){
      case 'txt': 
        sort.push('1'+TR.cells[0].lastChild.innerHTML.toUpperCase()+' |'+TR.rowIndex);
        break;
      default:   
        if(this.lSortData){
          sort.push('3'+TR.cells[0].lastChild.innerHTML.toUpperCase()+' |'+TR.rowIndex);
        } else {
          sort.push('3'+(100+TR.rowIndex)+' |'+TR.rowIndex);
        }
        break;
      }
    }
    TR=TR.nextSibling;
  }
  sort.sort();

  // Remember selected row
  var sel=-1, opn=-1;
  if(this.selected) sel=this.selected.rowIndex;
  if(this.currentopen) opn=this.currentopen.rowIndex;
  
  for(var i=0;i<html.length;i++){
    var row=sort[i].split('|')[1]*1;
    var pp=html[row-ri];
    var TR=this.TABLE.rows[ri+i];
    TR.cells[0].innerHTML=pp[0];    
    TR.setAttribute('node',pp[1]);
    TR.setAttribute('tree',pp[2]);
    TR.setAttribute('data',pp[3]);
    TR.setAttribute('level',pp[4]);
    TR.id=pp[5];
    TR.className=pp[6];
    if(row==sel) this.select(TR);     // Reset positions
    if(row==opn) this.currentopen=TR;
  }
}

Dyntree.prototype.flipImage=function(TR){          
  var img=TR.getElementsByTagName('IMG')[TR.getAttribute('level')];
  var old=img.getAttribute('src2');
  img.setAttribute('src2',img.getAttribute('src'));
  img.setAttribute('src',old);
}

Dyntree.prototype.nodeOpen=function(TR){          
  if(this.currentopen) this.flipImage(this.currentopen);
  this.currentopen=TR;
  if(TR) this.flipImage(TR);
}

Dyntree.prototype.select=function(TR){
  hotkey.browsenav='dyntree';
  if(this.selected) this.selected.cells[0].lastChild.className='';
  this.selected=TR;
  if(TR){
    TR.cells[0].lastChild.className='select';
    this.scrollView(TR,this.elem);
  }  
}

Dyntree.prototype.reselect=function(){
  this.select(this.currentopen);
}

Dyntree.prototype.scrollView=function(TR,elem){
  var h=TR.clientHeight*2;
  if(TR.offsetTop-h<elem.scrollTop) elem.scrollTop=TR.offsetTop-h; // Top
  if(TR.offsetTop-elem.clientHeight+h>elem.scrollTop) elem.scrollTop=TR.offsetTop-elem.clientHeight+h;  // Bottom
}

Dyntree.prototype.ondblclick=function(TR){
  while(TR.nodeName!='TR' && TR.nodeName!='BODY') TR=TR.parentNode;
  var tree=TR.getAttribute('tree');  
  if(tree){
    if(tree=='more')      this.folderFetch(TR);
    else if(tree=='open') this.nodeCollapse(TR);
    else                  this.nodeExpand(TR);
  }
}

Dyntree.prototype.onclick=function(TR){
  if(popup.clickoutside() || 
    (this.currentwdo && !this.currentwdo.status.add)) return;
  var testimg=(TR.nodeName=='IMG' && !TR.getAttribute('src2'));
  while(TR.nodeName!='TR' && TR.nodeName!='BODY') TR=TR.parentNode;
  if(TR.nodeName=='BODY') return;
  var tree=TR.getAttribute('tree');  
  if(!testimg){
    if(TR.id && TR.className=='enable'){
      switch(TR.getAttribute('node')){
      case '_mnu':
        this.folderLaunch(TR.getAttribute('node'),TR);
        break;
      case '':
        this.action(TR.id);
        break;
      case '_more':
        var more=(TR.id).split('|');
        this.dataFetch(TR,more.shift(),more.pop());
        action('wbo.submit');
        break;
      default:
        this.folderLaunch(TR.getAttribute('node'),TR);
      }
    } else this.folderLaunch(null,TR);
  } else if(tree){
    if(tree=='more')   this.folderFetch(TR);
    else if(tree=='open') this.nodeCollapse(TR);
    else                  this.nodeExpand(TR);
  }
}

// Change the icon and set status to closed
Dyntree.prototype.nodeCollapse=function(TR){            
  var parent=TR;
  var level=TR.getAttribute('level');
  TR.setAttribute('tree','closed');
  this.setImage(TR);
  TR=TR.nextSibling;
  while(TR && TR.getAttribute('level')>level) {
    TR.style.display='none';  
    if(TR==this.currentopen) this.onclick(parent);
    TR=TR.nextSibling;
  }
  
}

// Change the icon and set status to open
Dyntree.prototype.nodeExpand=function(TR){            
  TR.setAttribute('tree','open');
  this.setImage(TR);
  this.recurseOpen(TR);
}

// Change the folder icon to open
Dyntree.prototype.recurseOpen=function(TR){
  var opt=TR.getAttribute('tree')=='open';
  var level=TR.getAttribute('level');
  var TR=TR.nextSibling;
  while(TR && TR.getAttribute('level')>level) {
    if(opt) TR.style.display='block';  
    if(TR.getAttribute('tree')) TR=this.recurseOpen(TR);
    else TR=TR.nextSibling;
  }
  return TR;
}
 
Dyntree.prototype.setImage=function(TR){
  var level=TR.getAttribute('level');
  if(level==0) return;
  var tree=TR.getAttribute('tree');
  var last=TR.getAttribute('last');
  TR.getElementsByTagName('IMG')[level-1].setAttribute('src', tree ?
    (tree=='open'?'../img/ws_tree8.gif':'../img/ws_tree5.gif'):   // Minus / PLUS
    (last?'../img/ws_tree2.gif':'../img/ws_tree4.gif'));          // None /last    	
}

// Fetch a branch operation
Dyntree.prototype.folderFetch=function(TR){   
  app=mainapp;
  this.sortnode=TR.rowIndex;
  this.insertnode=this.sortnode+1;
  var pnode=TR.getAttribute('node');
  
  // Structured node
  if(this.struct[pnode][6]!=',') this.dataFetch(TR,pnode,'filter');
  
  // Child nodes
  for(var e in this.struct){
    if(this.struct[e][0]==pnode && e!=this.rootnode){ 
      var prop=this.struct[e];
//      alert(prop[6]+'/'+e+'/'+pnode)
      if(e==pnode && prop[6]==',') continue;
      switch(prop[10]){
      case 'txt':
        this.loadData(e,this.insertnode,TR.getAttribute('level')*1+1);
        break;
      case 'mnu':
        action('server.wbo.'+this.sortnode+'.'+prop[8]+'.mnu.dyntree');
        break;
      case 'prg':
        // TODO: Get the parent-child value and set it in _filter for default SDO 
        action('server.wbo.'+this.sortnode+'.'+e+'.prg.dyntree');
        break;
      case 'sdo':
        this.dataFetch(TR,e,'filter');
        break;
      default:
        alert('Unknown nodetype:'+prop[10])  
      }
    }      
  }
  if(mainapp.document.form['do'].value){
    if(mainapp.tvEvent) mainapp.tvEvent('fetch');
    action('wbo.submit');
  } else {
    TR.setAttribute('tree','open');
    this.setImage(TR);
    this.initialize();
  }
}
 
Dyntree.prototype.dataFetch=function(TR,nodename,oper){ 
  app=mainapp;
  var prop=this.struct[nodename];  
  var hdata=window.mainapp['_'+prop[8]].hdata;
  var level = TR.getAttribute('level');
  if(oper!='filter') level--;  // Need one level down for MORE nodes
  var filt=this.setFX(TR,hdata,prop,level);
  if(filt) mainapp.document.form['_'+prop[8]+'._filter'].value=filt;
  if(oper!='filter'){ // More node
    var rowid=TR.getAttribute('data').split(hdata.dlm)[0];
    mainapp.document.form['_'+prop[8]+'._last'].value=rowid;
  }
  action('server.'+prop[8]+(oper=='filter'?'.filter':'.more'));
  action('server.wbo.'+TR.rowIndex+'.'+nodename+'.dyntree');
}

// Synchronization of treeview with SDO operations
Dyntree.prototype.save=function(type,data){
  var TR=this.currentopen;
  // !TR - means adding root node
  // this.addfrom - means ADD popup

  var nodename=(!TR || this.addfrom)?this.addnodename:TR.getAttribute('node');
  var prop=this.struct[nodename];
  if(!mainapp['_'+prop[8]]) return;  // Non-treeview SDOs
  var hdata=mainapp['_'+prop[8]].hdata;
  var level=TR?TR.getAttribute('level'):1;
  switch(type){
  case 'delete':
    var i=TR.rowIndex;
    this.action('prev');
    do {
      if(this.selected==this.TABLE.rows[i]) this.selected=null;
      if(this.currentopen==this.TABLE.rows[i]) this.currentopen=null;
      this.TABLE.deleteRow(i);
    } while(this.TABLE.rows[i] && this.TABLE.rows[i].getAttribute('level')>level);
    this.action('next');
    break;
  case 'add':
    if(this.addfrom && TR){  // Make sure Parent node expands first
      if(this.addfrom.getAttribute('tree')=='more'){
        this.folderFetch(this.addfrom);
        return;
      } else {
        this.nodeExpand(this.addfrom);
        level=this.addfrom.getAttribute('level')*1+1;
      }
    }
    var i=this.addfrom?this.addfrom.rowIndex+1:(TR?TR.rowIndex:0);
    var label=this.getLabel(prop,data);
    TR=this.TABLE.insertRow(i);
    this.createNode(TR,nodename,prop,level,this.getPrefix(level),data);
    this.addfrom=null;
    this.initialize();
    this.folderLaunch(nodename,TR);
    break;
  default: // Updated data
    TR.lastChild.lastChild.innerHTML=this.getLabel(prop,data);
    TR.setAttribute('data',data);
  }
  mainapp.document.form['do'].value='';
}

Dyntree.prototype.folderLaunch=function(nodename,TR){          
  if(TR){
    this.nodeOpen(TR);
    this.select(TR);
  }
  maindoc.title=this.title;
  this.currentwdo=null;

  if(!nodename){
    appcontrol.deactivate(this.currframe);    
    this.currframe=null;
    if(mainapp.tvEvent) mainapp.tvEvent('empty');
    return;
  }

  var prop=this.struct[nodename];
  maindoc.title=this.title+(prop?' - '+prop[9]:''); // Fixing title

  var sdo,prog;
  if(nodename=='_mnu'){
    sdo=null;
    var prg=TR.id.split('.');
    switch(prg.shift()){
    case 'prg':
      if(mainapp.tvEvent) mainapp.tvEvent('extract');
      prog=prg.shift();
      break;
    default:
      var prefix=TR.id.split('.')[0];
      if(prefix=='prg' || prefix=='util') window.action(TR.id);
      return;
    }
  } else {
    prog=prop[1];    
    if(prop[10]=='sdo'){
      sdo=prop[8]; 
      var WDO=window.mainapp['_'+sdo].hdata; 
      WDO.lMod=false;
      WDO.lUpd=false;
      WDO.resetData([TR.getAttribute('data')],1);
      WDO.refreshTools();
      this.currentwdo=WDO;
    }
  }
  this.containerLaunch(prog,sdo);
}



// Launch the Container specified for the node
Dyntree.prototype.containerLaunch=function(prog,sdo){          
  with(appcontrol){
    var treetag=mainapp.document.getElementById('treeframe');
    var parent=mainapp.frameObject;
    var dynframe=getframe(prog);
    var winname=dynframe.tag.getAttribute('name');
    if(this.currframe==dynframe) return runlater();
    if(this.currframe) deactivate(this.currframe);
    if(!prog) return;
    dynframe.dyntag=treetag;
    dynframe.parent=parent;
    if(sdo){
      action(sdo+'.setpassthru');
      treetag.setAttribute('uplink',sdo);
    }
    treetag.setAttribute('frame',winname);
    treetag.parentNode.setAttribute('frame',winname);
    activate(dynframe);
    framepos(winname);
    if(dynframe.src!=prog){
      dynframe.src=prog;
      if(mainapp.tvEvent) mainapp.tvEvent('launch');
      fetch(dynframe);
    } else {
      dynframe.win.wbo.refresh();
      runlater();
    }
    this.currframe=dynframe;
  }
}

Dyntree.prototype.refreshTools=function(status){ 
  if(!mainapp.tvEvent) return;
  // Set custom events such as locking filter viewer
  if(status.add)
    mainapp.tvEvent('view');
  else if(status.cancel) 
    mainapp.tvEvent('add');
  else if(status.reset) 
    mainapp.tvEvent('modify');
  else 
    mainapp.tvEvent('update');
}

// This function gets called when ADD from toolbar
Dyntree.prototype.beforeAdd=function(){ 
  if(this.addfrom || !this.currentopen) return;  // Not for popup ADD 
  var prop=this.struct[this.currentopen.getAttribute('node')];
  var hdata=mainapp['_'+prop[8]].hdata;
  this.setFX(this.currentopen,hdata,prop,
            (this.currentopen.getAttribute('level')*1+1),
             hdata.initvals);
}

// Action API for the treeview prefix
Dyntree.prototype.action=function(c,prm){ 
  c=c.split('.');	
  var cmd=c.pop();
  switch(cmd){
    case 'cancel':
      this.addfrom=null;
      this.reselect();
      if(this.currentopen) this.onclick(this.currentopen);
      return;
    case 'add':
      this.addnodename=c[0];
      var prop=this.struct[c[0]];
      var hdata=window.mainapp['_'+prop[8]].hdata;
      this.currentwdo=hdata;
      hdata.resetData([],0);
      later('dyntree.'+c[0]+'.add2')
      this.containerLaunch(prop[1],prop[8]);
      return;
    case 'add2':
      // Set parent field data
      var prop=this.struct[c[0]];
      var hdata=mainapp['_'+prop[8]].hdata;
      this.setFX(this.addfrom,hdata,prop,
                 (this.addfrom?(this.addfrom.getAttribute('level')*1+1):0),
                 hdata.initvals);
      hdata.action('add');
      this.select(this.addfrom); // Sets selection to source
      return;
  }
  if(this.currentwdo && !this.currentwdo.status.add) return;
  switch(cmd){
    case 'next':
      var TR=this.selected;
      if(TR) TR=TR.nextSibling;
      while(TR && TR.style.display=='none') TR=TR.nextSibling
      if(TR) this.onclick(TR);
      break;
    case 'prev':
      var TR=this.selected;
      if(TR) TR=TR.previousSibling;
      while(TR && TR.style.display=='none') TR=TR.previousSibling
      if(TR) this.onclick(TR);
      break;
    case 'left':
      var TR=this.selected;
      if(TR) this.nodeCollapse(TR);
      break;
    case 'right':
      var TR=this.selected;
      if(TR){ 
        if(TR.getAttribute('tree')=='more'){
          this.folderFetch(TR);
        } else {
          this.nodeExpand(TR);
        }
      }
      break;
    default:
      alert('treeview unknown:'+c);
  }
}

// curr is a pointer to the current data row to set FX fields 
Dyntree.prototype.setFX=function(TR,hdata,prop,level,curr){          
  var parent=TR;
  var data=null;
  var pdata=null;
  var filt='';
  while(parent && (parent.getAttribute('level') > level || !parent.getAttribute('data')))
    parent=parent.previousSibling;
  if(parent){
    data=parent.getAttribute('data').split(hdata.dlm); 
    pdata=window.mainapp['_'+this.struct[parent.getAttribute('node')][8]].hdata;
    this.sortnode=parent.rowIndex;
  }
  if(data && prop[7]){ // Parent-child
    var fx=prop[7].split(','); 
    fx[0]=fx[0].split('.').pop();   // remove wdo part from id
    if(data[11]=='prg'){
      var idx=data[14].split(',');
      var pval=data[15+pdata.index[fx[1].split('.').pop()]];
      for(var i=0;i<idx.length;i++)
        if(idx[i]==fx[1]){
          if(curr) curr[hdata.index[fx[0]]]=pval;
          else filt=fx[0]+' = '+pval;
        }
    } else {
      var pval=data[pdata.index[fx[1].split('.').pop()]];
      if(curr) curr[hdata.index[fx[0]]]=pval;
      else filt+=(filt?'|':'')+fx[0]+' = '+pval;
    }
  }
  if(prop[6]!=','){ // Structured
    if(data){ // Found parent
      var fx=prop[6].split(',');  
      data=TR.getAttribute('data').split(hdata.dlm); 
      if(curr){
        curr[hdata.index[fx[0]]]=data[hdata.index[fx[1].split('.').pop()]];
      } else {
        filt+=(filt?'|':'')+fx[0]+' = '+data[hdata.index[fx[1].split('.').pop()]];
      }
    }
    if(!filt) filt=prop[12];
  }
  return curr?curr:filt;
}

// Popup menu (ADD)
Dyntree.prototype.popup=function(e){          
  if(this.currentwdo && !this.currentwdo.status.add) return;
  var TR=e.target;
  while(TR.nodeName!='TR' && TR.nodeName!='BODY') TR=TR.parentNode;
  if(TR.nodeName=='BODY') TR=null;
  this.addfrom=TR;
  var make=[];
  if(TR){
    var node=TR.getAttribute('node');
    for(var el in this.struct)
      if((this.struct[el][0]==node && el!=this.rootnode && this.struct[el][10]=='sdo')
       ||(el==node && this.struct[el][6]!=',')) 
        make.push('2|dyntree.'+el+'.add|Add '+this.struct[el][9]);	
  } else {
    make.push('2|dyntree.'+this.rootnode+'.add|Add '+this.struct[this.rootnode][9]);	
  }
  if(!make.length) return;
  this.select(TR);
  popup.make(make,e.clientX,e.clientY);
}

  
