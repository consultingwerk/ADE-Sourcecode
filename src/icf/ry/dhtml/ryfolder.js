//  File:         ryfolder.js
//  Description:  Implements Paged tabfolders

Folder.prototype.iTab=null;     // Active Tab
Folder.prototype.fimg='../img/ws_tgreyf';   // Image prefix
Folder.prototype.bimg='../img/ws_tgreyb';   // Image prefix
Folder.prototype.coll=[];       // Image prefix
Folder.prototype.enabled;       // Enabled TAB
Folder.prototype.elem;          // DOM reference
Folder.prototype.uimg=null;     // Underneath image

Folder.prototype.fRun=function(iNew){
  with(this){
    var TD=elem.firstChild.rows[0].cells;	
    if (iNew==iTab) return false;
    if (enabled[iNew-1]=='no') return setTab(TD[iTab*3-2],'disable');
    if (iTab!=null) setTab(TD[iTab*3-2],'back');
    iTab=iNew;
    setTab(TD[iTab*3-2],'front');
  }
  return true;
}

Folder.prototype.setTab=function(TD,cl){
  TD.className=cl;
  var img=(cl=='front'?this.fimg:this.bimg);
  TD.previousSibling.firstChild.src=img+'l.gif';
  TD.nextSibling.firstChild.src=img+'r.gif';
}	

Folder.prototype.tabclick=function(e){
  if (e.nodeName!='TD') e=e.parentNode;
  if (e.nodeName!='TD') return;
  var num=Math.floor(e.cellIndex/3)+1;
//  this.fRun(num)
  if (this.fRun(num)) action('wbo.'+num + '.changepage');
}

function Folder(){}

Folder.prototype.init=function(e){
  with(this){
    this.elem=e;
    // Find image settings from stylesheet
    var ss=app.document.styleSheets;
    if(document.all){
      for(var j=0;j<ss.length;j++){
        var s=ss[j].rules;
        for(var i=0;i<s.length;i++){
         	if(/#folder td\.front/.test(s[i].selectorText) &&  /url\((.*)\.gif/.test(s[i].style.backgroundImage)) fimg=RegExp.$1; 
         	if(/#folder td\.back/.test(s[i].selectorText) &&  /url\((.*)\.gif/.test(s[i].style.backgroundImage)) fimg=RegExp.$1; 
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
    enabled=e.getAttribute('enabled').split('|');
    var c='<table class="folder" cellspacing="0" cellpadding="0"><tr>';
    var a = elem.getAttribute('tabs').split('|');
    for(var i=0;i<a.length;i++){
      c+='<td><img src=""></td>';
      c+='<td class=front>&nbsp;'+a[i]+'&nbsp;</td>';
      c+='<td><img src=""></td>';
    }
    elem.innerHTML=c+'</tr></table><img class="under" src="'+fimg+'u.gif">';
    this.uimg=elem.lastChild;



    var TD=elem.firstChild.rows[0].cells;
    for(var i=a.length;i>0;i--) if(fRun(i)) app.page=i;
    var page=app.document.body.getAttribute('startpage');
    if(page && fRun(page)) app.page=page;
    elem.firstChild.onclick=function(e){app.folder.tabclick(main.fixEvent(e?e:window.app.event).target);}

  }  
}

function custom(c){
	with(this){
//	  alert('[ryfolder.js] custom\n'+c);
    if(!this.app[c]) return true;
    return this.app[c]();
  }
}
