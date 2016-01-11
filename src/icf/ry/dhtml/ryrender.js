//  File:         ryrender.js
//  Description:  Collection of screen rendering utilities

function fixUtilImages(){
  var elem=app.document.getElementsByTagName('INPUT');
  for(var j=0;j<elem.length;j++){
    var e=elem[j];
    var t='';
    var l=e.getAttribute('lookup');
    if(l) t=(l=='find'?e.id.split('.')[0]:e.id.split('.')[0]+'.'+e.getAttribute('lfield'));
    if(e.getAttribute('util')) t=e.id;
    if(t>''){
      var IMG=app.document.createElement('IMG');
      IMG.className='tool enable';
      IMG.id=t;
      IMG.name=t;
      IMG.src=e.getAttribute('utilimg');
      IMG.title=e.getAttribute('utiltip');
      IMG.style.position='absolute';
      IMG.style.top=e.style.top;
      IMG.style.left=(e.style.left.replace('px','')*1+e.style.width.replace('px','')*1)+'px';
      IMG.style.position='absolute';
      IMG.tabindex='-1';
      if(e.getAttribute('disable')) IMG.setAttribute('disable','');
      IMG.setAttribute('tool',e.id+'.util');
      if(!e.nextSibling) e.parentNode.appendChild(IMG);
      else e.parentNode.insertBefore(IMG,e.nextSibling);
    }
  }
}

var mousedrag;

function fixRectangles(){
  var elem=app.document.getElementsByTagName('DIV');
  for(var j=0;j<elem.length;j++){
    var e=elem[j];
    if(e.getAttribute('resize')){
      var IMG=app.document.createElement('IMG');
      IMG.className='resize';
      IMG.src='../img/ws_resize.gif';
      IMG.tabIndex='-1';
      e.parentNode.appendChild(IMG);
      IMG.onmousedown=function(e){
         var src=window.fixEvent(e?e:window.app.event).target;
      	 window.main.mousedrag=src.parentNode.getElementsByTagName('DIV')[0];
      };
      resizeBrowse(e);
    } else{
      var TD=e.parentNode; 
      if(TD.nodeName=='TD'){
        TD.style.width=(e.offsetWidth*1+2)+'px';
        TD.style.height=(e.offsetHeight*1+2)+'px';
      }
    }	
  }
  app.document.onmousemove=function(e){
    if(window.main.mousedrag && window.main.mousedrag!=true) 
      window.main.resizexy(e?e:window.app.event)
  };
  app.document.onmouseup=function(e){
    if(window.main.mousedrag && window.main.mousedrag!=true){
      window.main.mousedrag=null;
      window.main.resizeObjects();
    }
  };
} 

function resizeBrowse(e){
  e.style.width =(e.style.width.replace('px','')*1)+'px';
  e.style.height=(e.style.height.replace('px','')*1)+'px';
  e.parentNode.lastChild.style.left   =(e.offsetWidth-18)+'px';   // 18
  e.parentNode.lastChild.style.top    =(e.offsetHeight-18)+'px';  // 18
//  e.parentNode.style.width =(e.style.width.replace('px','')*1)+'px';   // Mozilla bugfix
}

function resizeObjects(){
  var bodyx=app.document.body.clientWidth;
  var DIV=app.document.getElementsByTagName('DIV');  // Rows in container layout
  for(var i=0;i<DIV.length;i++){
    if(DIV[i].className!='pager show' && DIV[i].className!='pager') continue;
    var Obj=DIV[i].getElementsByTagName('DIV');
    var num=0;
    var grow=new Array();
    var sizex=0;
    var sizey=0;
    for(var j=0;j<Obj.length;j++){
      var e=Obj[j];
      if(!e.getAttribute('wdo')) continue;
      num++;
      var typ=e.getAttribute('objtype')=='browse'?'browse':'viewer';
      if(typ=='browse'){
        grow[grow.length]=j;    // Objects to grow
          var TABLE=e.getElementsByTagName('TABLE')[0];
          e.setAttribute('maxx',TABLE.scrollWidth+24);
          e.setAttribute('maxy',TABLE.scrollHeight+24);
      }
      if(e.style.width) sizex+=(e.style.width.replace('px','')*1+8)*1;
      if(e.style.height && e.style.height.replace('px','')*1 > sizey) sizey=e.style.height.replace('px','')*1;
    }

    var numgrow=grow.length;
    for(var j=0;j<grow.length;j++){   // Grow/shrink adjustable objects
      if (numgrow<1) break;
      var e=Obj[grow[j]];
      var dx=(bodyx-sizex)/numgrow;
      var x=(e.style.width).replace('px','')*1;
      var newx=x+dx;
      var newy=e.style.height.replace('px','')*1;
      var maxx=e.getAttribute('maxx')*1;
      var maxy=e.getAttribute('maxy')*1;
      var minx=e.getAttribute('minx')*1;
      var miny=e.getAttribute('miny')*1;
      if(newx<minx){    // Adjust minimum X size
        sizex+=x-minx;
        numgrow--;
        newx=minx;
      }
      if(newx>maxx){    // Adjust maximum X size
        sizex+=maxx-x;
        numgrow--;
        newx=maxx;
      }
      if(newy<sizey) newy=sizey;
      if(newy<miny) newy=miny;

      // Assign new sizes
      e.style.width=newx+'px';
      e.style.height=newy+'px';
      e.parentNode.width=newx+'px';
      e.parentNode.style.height=newy+'px';

      var typ=e.getAttribute('objtype');
      var oe=e,ol=0,ot=0;
      while(oe && oe.nodeName!='BODY'){
        ol+=oe.offsetLeft;
        ot+=oe.offsetTop;
        oe=oe.offsetParent;
      }
      e.setAttribute('ol',ol);
      e.setAttribute('ot',ot);
      if(typ=='browse') resizeBrowse(e);
    }
    if(document.all){     // IE has problems with adjusting size of TABLE
      var TABLE=DIV[i].firstChild;
      if(TABLE && TABLE.nodeName=='TABLE'){
        TABLE.style.width=sizex+'px';
        TABLE.style.height=sizey+'px';
      }
    }
  }
}


{
  var IMG=window.document.getElementById('resizex');
  if(IMG){
    IMG.onmousedown=function(e){window.mousedrag=true;};
    IMG.onmousemove=function(e){if(window.mousedrag) window.resizex(e?e:window.event)};
    IMG.onmouseup=function(e){
      if(window.mousedrag){
        window.mousedrag=null;
        window.resizeObjects();
      }
    }
  }
}

function resizex(e){
  window.fixEvent(e); 
  var IMG=document.getElementById('resizex'); 
  var DIV=document.getElementById('treeview');
  DIV.style.width=(e.clientX*1)+'px';
  IMG.style.left=(e.clientX*1-5)+'px';
}	

function resizexy(e){
  e=window.fixEvent(e);
  var BODY=app.document.body;
  var FS=window.main.mousedrag;
  FS.style.height=(e.clientY+BODY.scrollTop-FS.getAttribute('ot')+3)+'px';
  FS.style.width=(e.clientX+BODY.scrollLeft-FS.getAttribute('ol')+3)+'px';
  resizeBrowse(FS);
}

function autofit(DLG){
  window.dialog=DLG;	
  var BODY=DLG.document.getElementById('table');
  if(document.all || !BODY) BODY=DLG.document.getElementById('body');
  var w=BODY.offsetWidth+9;
  var h=BODY.offsetHeight+32; 
  if(document.all){
    DLG.dialogWidth=w+'px';
    DLG.dialogHeight=h+'px';
  } else {
    DLG.resizeTo(w,h);
  }
}

