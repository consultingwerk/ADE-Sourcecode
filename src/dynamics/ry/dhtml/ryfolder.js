//  File:         ryfolder.js
//  Description:  Implements Paged tabfolders

Folder.prototype.iTab=null;     // Active Tab
Folder.prototype.fimg='../img/ws_tgreyf';   // Image prefix
Folder.prototype.bimg='../img/ws_tgreyb';   // Image prefix
Folder.prototype.coll=[];       // Image prefix
Folder.prototype.uimg=null;     // Underneath image
Folder.prototype.enabled;       // Enabled pages list

function Folder(){app.folder=this;}


Folder.prototype.init=function(e){
  with(this){
    this.elem=e;
    app.pagecontroller=this;
    // Find image settings from stylesheet
    var ss=app.document.styleSheets;
    if(document.all){
      for(var j=0;j<ss.length;j++){
        var s=ss[j].rules;
        for(var i=0;i<s.length;i++){
         	if(/td\.front/i.test(s[i].selectorText) &&  /url\((.*)\.gif/.test(s[i].style.backgroundImage)) fimg=RegExp.$1; 
         	if(/td\.back/i.test(s[i].selectorText) &&  /url\((.*)\.gif/.test(s[i].style.backgroundImage)) bimg=RegExp.$1; 
        }	
      }
    } else {
      for(var j=0;j<ss.length;j++){
        var s=ss[j].cssRules;
        for(var i=0;i<s.length;i++){
         	if(/#folder td\.front(.*) background-image: url\((.*)\.gif/.test(s[i].cssText)) fimg=RegExp.$2; 
       	  if(/#folder td\.back(.*) background-image: url\((.*)\.gif/.test(s[i].cssText)) bimg=RegExp.$2; 
        }	
      }
    }		
    this.enabled=e.getAttribute('enabled').split('|');
    var c='<table class="folder" cellspacing="0" cellpadding="0"><tr>';
    var a = elem.getAttribute('tabs').split('|');
    for(var i=0;i<a.length;i++){
      c+='<td></td>';
      c+='<td class=front>&nbsp;'+a[i]+'&nbsp;</td>';
      c+='<td></td>';
    }
    elem.innerHTML=c+'</tr></table><img class="under" src="'+fimg+'u.gif">';
    this.uimg=elem.lastChild;

    var TD=elem.firstChild.rows[0].cells;
    for(var i=0;i<a.length;i++) setTab(i+1,enabled[i]=='no'?'disable':'back');
    app.page=app.document.body.getAttribute('startpage');
    if(!app.page) app.page=1;
    fRun(app.page);
    elem.firstChild.onclick=function(e){app.folder.tabclick(main.fixEvent(e?e:window.app.event).target);}
  }  
}


Folder.prototype.fRun=function(iNew){
  with(this){
    if (iNew==iTab) return false;
    if (iTab) setTab(iTab,'back');
    iTab=iNew;
    setTab(iTab,'front');
  }
  return true;
}

Folder.prototype.setTab=function(tab,cl){
  var TD=this.elem.firstChild.rows[0].cells;	
  tab=tab*3-3;
  var img=(cl=='front'?this.fimg:this.bimg);
  TD[tab].innerHTML='<img src="'+img+'l.gif">';
  TD[tab+1].className=cl;
  TD[tab+2].innerHTML='<img src="'+img+'r.gif">';
}	

Folder.prototype.tabclick=function(e){
  if (e.nodeName!='TD') e=e.parentNode;
  if (e.nodeName!='TD') return;
  var num=Math.floor(e.cellIndex/3)+1;
  if (this.enabled[num-1]!='no' && this.fRun(num)) action('wbo.'+num + '.changepage');
}

