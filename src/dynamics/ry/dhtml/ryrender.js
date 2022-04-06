//  File:         ryrender.js
//  Description:  Collection of screen rendering utilities

// On page initialization configure lookup/calculator/calendar images
function fixUtilImages(){
  var elem=app.document.getElementsByTagName('SPAN');
  for(var i=0;i<elem.length;i++){
    elem[i].onmouseover=function(e){
      window.app=appframes[(document.all?this.document:this.ownerDocument).body.getAttribute('win')].win;
      window.main.toolbar.mOver(e?e:window.app.event);
    };
    elem[i].onmouseout =function(e){
      window.app=appframes[(document.all?this.document:this.ownerDocument).body.getAttribute('win')].win;
      window.main.toolbar.mOut(e?e:window.app.event);
    };
  }
}

// On page initialization configure combo parent image
function fixComboParent(e){
  var eid=e.getAttribute('id');
  var pid=e.getAttribute('comboparent');
  var parent=app.document.getElementById(pid.replace('.','._'));
  if(parent){
    parent.setAttribute('combochild',eid);
    return;
  }
  parent=app.document.getElementById(pid);
  if(!parent) return; 
  if(parent.getAttribute('util')){
    parent.setAttribute('combochild',eid);
  }

  // Create the Refresh node on a fill-in or combo
  var newNode=app.document.createElement('span');
  if(parent.nextSibling) parent.parentNode.insertBefore(newNode,parent.nextSibling);
  else parent.parentNode.appendChild(newNode);
  parent.setAttribute('util',e.getAttribute('id')+'.comborefresh');
  newNode.className='enable';
  newNode.innerHTML='<img src="../img/refresh.gif" tabindex="-1" />';
  newNode.setAttribute('name',pid);
  newNode.setAttribute('id',pid);
  newNode.setAttribute('title','Refresh combo results');
  newNode.style.position='absolute';
  newNode.style.top=parent.style.top;
  newNode.style.left=(parent.style.left.replace('px','')*1
                     +parent.style.width.replace('px','')*1  )+'px';
  fixUtilImages();
  return newNode;
}

var mousedrag;  // Set to the initial object that is being dragged 

function resizexy(e){   // During resize of browses
  e=window.fixEvent(e);
  var BODY=app.document.body;
  var FS=window.main.mousedrag;
  var LS=FS.parentNode.style;
  var min=(mousedrag.getAttribute('min')).split(',');

  if(mousedrag.getAttribute('resize')!='resizex'){
    var h=e.clientY+BODY.scrollTop -LS.top.replace('px','');
    if(h>min[1]*1) LS.height=(FS.style.height=h+'px');
  }
  var w=e.clientX+BODY.scrollLeft-LS.left.replace('px','');
  if(w>min[0]*1) LS.width=(FS.style.width=w+'px');
}

function resizeStop(){  // Finished resize of browse
	var LAY=mousedrag.parentNode;
  LAY.setAttribute('min',mousedrag.style.width.replace('px','')+','+mousedrag.style.height.replace('px',''));
  LAY.setAttribute('growx','lock');
  if(LAY.getAttribute('resize')!='resizex') LAY.setAttribute('growy','lock');
  mousedrag=null;
  sizeContainer(mainapp);
  resizeObjects(mainapp);
}	

function fixRectangles(){  // Set resize for browses
  var elem=app.document.getElementsByTagName('DIV');
  for(var j=0;j<elem.length;j++){
    var e=elem[j];
    var resize=e.getAttribute('resize');
    if(e.className=='layout' || (resize!='resize' && resize!='resizex')) continue;
    var IMG=app.document.createElement('IMG');
    IMG.className='resize';
    IMG.src='../img/ws_resize.gif';
    IMG.tabIndex='-1';
    e.parentNode.setAttribute('resize',e.getAttribute('resize'));
    e.parentNode.appendChild(IMG);
    IMG.onmousedown=function(e){
       var src=window.fixEvent(e?e:window.app.event).target;
    	 window.main.mousedrag=src.parentNode.getElementsByTagName('DIV')[0];
    }
  }
  app.document.onmousemove=function(e){
    window.app=appframes[this.body.getAttribute('win')].win;
    if(window.main.mousedrag && window.main.mousedrag!=true) 
      window.main.resizexy(e?e:window.app.event)
  };
  app.document.onmouseup=function(e){
    if(window.main.mousedrag && window.main.mousedrag!=true){
      window.main.resizeStop();
    }
  };
} 




// Setting the properties of the objects on initialization
function fixLayout(){
  lognote('APP:Create Layout');
  var layout=(app.layout=new Object());	
  layout.tabs=new Object();	
  layout.row=new Object();	
  layout.tabcell=null;
  var a=app.document.body.childNodes;
  for(var i=0;i<a.length;i++){
    if(!a[i].className || a[i].className.split(' ')[0]!='layout') continue;
    var ch=a[i].firstChild;
    if(!ch) continue;
    if(ch.nodeName=='#text') ch=ch.nextSibling;
    var page=a[i].getAttribute('page');
    var pos=(a[i].getAttribute('pos')).split('');

    // Setting up pages in app.layout[page]
    var lay=(page?layout.tabs[page]:layout);
    if(!lay){
    	lay=(layout.tabs[page]=new Object());
      lay.row=new Object();
    }
    // Setting up rows in layout[page].rows[row]
    var row=lay.row[pos[0]];
    if(!row){
    	row=(lay.row[pos[0]]=new Object());
      row.col=new Object();
    }
    row.col[pos[1]]=a[i];  // Setting elements in layout[page].rows[row].col[col]
    
    // Setting minimum size
    var min=ch.getAttribute('min');
    if(min){
      min=(min+',').split(',');
		  a[i].style.width=min[0]+'px';
		  a[i].style.height=min[1]+'px';
		  a[i].setAttribute('min',min);
    }
    // Setting grow attribute for objects
    if(ch.getAttribute('tabs')) layout.tabcell=a[i];
    a[i].setAttribute('growx',ch.getAttribute('resize')?'yes':'no');
    a[i].setAttribute('growy',ch.getAttribute('resize')=='resize'?'yes':'no');
  }	

  // Sort the rows and columns into a sort arrays per tab and main grid
  for(var p in layout.tabs) sortCells(layout.tabs[p]);
  sortCells(layout);
  
  function sortCells(tab){
    tab.sortrow=[];
    for(var i in tab.row){     // each row
      tab.sortrow.push(i);
      var l=tab.row[i];
      l.sortcol=[];            // each column
      for(var j in l.col) l.sortcol.push(j); 
      l.sortcol.sort();
    }
    tab.sortrow.sort();
  }    
}	

// Resize of the screen area, resizes and repositions contained objects.
function resizeObjects(app){
  if(!app || !app.layout || !app.layout.ready) return;
  lognote('resizeObjects');
  var x=200,y=100;
  if(app.isPopup){
    if(document.all){
      x=app.dialogWidth.replace('px','') - 16;
      y=app.dialogHeight.replace('px','') - 36;
    } else {
      x=app.innerWidth-3;
      y=app.innerHeight-3;
    }
  } else {	
    var st=(app.frameObject.dyntag?app.frameObject.dyntag.parentNode.style:app.frameObject.tag.style);
    if(document.all){
      x=st.width.replace('px','')-3;
      y=st.height.replace('px','')-3;
    } else {
    
    // Max on resizing growing
      x=st.width.replace('px','')-4;
      y=st.height.replace('px','')-4;

      var BODY=app.document.body;
      if(BODY.clientWidth<BODY.scrollWidth) y-=20;
      if(BODY.clientHeight<BODY.scrollHeight) x-=20;

    }
  }
  // compare height and width to figure out if to include space for scrollbars
/*
  var BODY=app.document.body;
  if(BODY.clientWidth<BODY.scrollWidth) y-=20;
  if(BODY.clientHeight<BODY.scrollHeight) x-=20;
*/
  positionPage(app.layout,1,1,x,y,app);    // page, left,top, width,height
  if(app.page>0) changePage(app.page,app);
  if(app.frameObject.dyntag) sizeDynframe(app.frameObject,app.layout);
}


function changePage(page,app){
  lognote('APP:changePage');
  var lay=app.layout;
  var tab=lay.tabs[page];
  if(!tab) return;     // May be a blank tab
  sizePage(tab);
  var st=lay.tabcell.style;
  var min=lay.tabsize?lay.tabsize:lay.tabcell.getAttribute('min');  
  min=min?min.split(','):[0,0];
  sizeContainer(app);
  positionPage(tab,st.left.replace('px',''),st.top.replace('px','')*1+lay.tabcell.getAttribute('height')*1,min[0],min[1]-lay.tabcell.getAttribute('height'),app);
}	

function sizeContainer(app){
  lognote('APP:sizeContainer');
  var lay=app.layout;
  if(!lay) return;
  lay.ready=true;
  if(lay.tabcell){
    var minx=0;
    var miny=0;
    var grow='no';
  	for(e in lay.tabs){
      var page=lay.tabs[e];
      if(page.minx>minx) minx=page.minx;
      if(page.miny>miny) miny=page.miny;
      if(page.grow) grow='yes'; 
    }
    lay.tabcell.setAttribute('min',minx+','+(miny+lay.tabcell.getAttribute('height')*1));
    lay.tabcell.setAttribute('growx',grow);
    lay.tabcell.setAttribute('growy',grow);
  }
	sizePage(lay);

  if(app.frameObject.dyntag && app.frameObject.dyntag.id!='treeframe'){
//    if(confirm('recurse:')) return;
    sizeDynframe(app.frameObject,lay);
    sizeContainer(app.frameObject.parent.win);
    resizeObjects(app.frameObject.parent.win);
  }  
}	

function sizeDynframe(fr,lay){
  fr.dyntag.parentNode.setAttribute('min',(lay.minx+5)+','+(lay.miny+5));
  fr.dyntag.parentNode.setAttribute('growx',lay.grow>0?'yes':'no');
  fr.dyntag.parentNode.setAttribute('growy',lay.grow>0?'yes':'no');
}

function positionPage(lay,posx,posy,sizex,sizey,app){
  var growy=(lay.miny<sizey && lay.grow>0) ? Math.floor((sizey-lay.miny)/lay.grow) : 0;
  var rows=lay.row;
  var layout=app.layout;
  var y=posy*1;

  for(var r in lay.sortrow){          // Loop through rows
  	var row=rows[lay.sortrow[r]];
    var x=posx*1;
    var maxy=row.grow>0?row.miny+growy:row.miny;
    if(!maxy) maxy=0;
    var growx=(row.minx<sizex && row.grow>0) ? Math.floor((sizex-row.minx)/row.grow) : 0;
    for(var i in row.sortcol){     // Loop through columns for row
      var cell=row.col[row.sortcol[i]];
      if(!x) x=0;
      if(!y) y=0;
      cell.style.top=(document.all||cell.lastChild.className!='viewer'?y:y-11)+'px'; // Adjust for Mozilla QUIRKs mode.
      cell.style.left=x+'px';
      var min=cell.getAttribute('min');
//      if(min==null || min==undefined || min=='') alert('undefined='+min+'/'+r+','+i+'\n'+cell.outerHTML)
      var DIV=cell.firstChild;
      if(DIV.nodeName=='#text') DIV=DIV.nextSibling;
      min=(min+',').split(',');
      var grx=cell.getAttribute('growx');
      var gry=cell.getAttribute('growy');
      if(grx=='yes') min[0]=min[0]*1+growx;
      if(gry!='lock') min[1]=maxy;
      if(cell==layout.tabcell){  // Special sizing for Tabfolder cell
      	cell.style.height=(DIV.style.height=(DIV.firstChild.offsetHeight+6)+'px'); 
      	cell.style.width=(DIV.style.width=(DIV.firstChild.offsetWidth+50)+'px'); 
      	cell.setAttribute('height',DIV.firstChild.offsetHeight+6);
        layout.tabsize=min.join(',');
      } else { 
        DIV.style.width=(cell.style.width=min[0]+'px');
        DIV.style.height=(cell.style.height=min[1]+'px');
        
      }
      if(DIV.getAttribute('frame')) appcontrol.framepos(DIV.getAttribute('frame'));
      x+=min[0]*1;
    }	
    y+=maxy;
  }	
}

function sizePage(lay){
  if(!lay) return;     // May be a blank tab
  var row=lay.row;
  lay.minx=0;
  lay.miny=0;
  lay.grow=0;
  for(r in row){
    sizeRow(row[r]);
    lay.miny+=row[r].miny*1;
    if(row[r].minx*1>lay.minx) lay.minx=row[r].minx*1;
    if(row[r].grow>0) lay.grow++;
  }	

  function sizeRow(row){
    row.grow=0;
    row.minx=0;
    row.miny=0;
    for(e in row.col){  // Loop through columns for row
      var cell=row.col[e];
      if(cell.getAttribute('growx')=='yes') row.grow++;   // Find grow for row     
      var min=cell.getAttribute('min');  // Find minimum size
      if(!min){
        var DIV=cell.firstChild;
        if(DIV && DIV.nodeName!='DIV') DIV=DIV.nextSibling;
        if(DIV && DIV.firstChild){
        	min=(DIV.offsetWidth+2)+','+(DIV.offsetHeight+(cell==app.layout.tabcell?6:2));
          cell.setAttribute('min',min);
        }
      }
      if(min){
      	min=(min+',').split(',');
        row.minx+=min[0]*1;                       // Add horizontal size
        if(min[1]*1>row.miny) row.miny=min[1]*1;  // Find highest vertical size
      }
    }
  }	
}	




function autofit(DLG,w,h){
  window.dialog=DLG;	
  if(!w||!h){  // If width and height is not given 
    var BODY=DLG.document.getElementById('table');
    if(document.all || !BODY) BODY=DLG.document.getElementById('body');
    w=BODY.offsetWidth+9;
    h=BODY.offsetHeight+32; 
  }      
  if(document.all){
    DLG.dialogWidth=w+'px';
    DLG.dialogHeight=h+'px';
  } else {
    DLG.resizeTo(w,h);
  }
}

