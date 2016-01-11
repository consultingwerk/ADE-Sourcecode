//  File:         rybrowse.js
//  Description:  Implements the browser object


/***** Browser construction and local data *******/
Browse.prototype.elem;
Browse.prototype.wdo;
Browse.prototype.id;
Browse.prototype.app;

Browse.prototype.fieldname;    // Names row as array
Browse.prototype.fieldnum;     // WDO ref   as array
Browse.prototype.fieldenabled; // Enabled as array
Browse.prototype.fieldlabel;   // Labels as array
Browse.prototype.fieldn;       // Number of elements in header row

Browse.prototype.fields;    
Browse.prototype.labels;    
Browse.prototype.dblclick;    

Browse.prototype.srtdir;       // Temporary clientsort variables
Browse.prototype.srtcol;    

Browse.prototype.arow;         // Array of TR rows
Browse.prototype.hdata;        // handle to WDO datasource
Browse.prototype.hcur;         // handle to current highlighted row
Browse.prototype.erow;         // Event row local
Browse.prototype.datan;        // Number of rows in local data
Browse.prototype.offset;       // Data offset for section
Browse.prototype.row;          // current local dataset-row
Browse.prototype.browseempty;  // skeleton browse without rows
Browse.prototype.nHeader=3;    // Rows to subtract for header section

if(document.all)
  Browse.prototype.sorting=new Array(''
    ,'<font color="red"><img src="../img/ws_sorting.gif" style="filter:flipv(enabled=1)">&</font>'
    ,'<font color="red"><img src="../img/ws_sorting.gif">&</font>')
else
  Browse.prototype.sorting=new Array(''
    ,'<font color="red"><img src="../img/ws_sorting.gif">&</font>'
    ,'<font color="red"><img src="../img/ws_sortingd.gif">&</font>')

function Browse(e){}

Browse.prototype.init=function(e){
  with(this){
    this.elem=e;
    elem.setAttribute('obj',this);
    this.id=elem.id;
    window.app[id]=this;    
    this.app=window.app;
    this.dblclick=e.getAttribute('dblclick');
    this.wdo=e.getAttribute('wdo');
    window.app['d'+wdo].browse=this;
    refresh();
  }
}

Browse.prototype.refresh=function(){
  with(this){
    if(wdo=='master'){
      this.hdata=window.action('master.handle').hdata;
      var fields=hdata.fieldname.slice(1).join('|');
      define(
        {fieldname    : '|'+fields
        ,fieldlabel   : '|'+fields
        ,fieldenabled : '|n'
        });  
    } else if(wdo=='lookup'){
      this.hdata=window.action('lookup.handle');
      this.wdo='lookup';
      define(
        {fieldname    : '|'+window.lookup.lookupcols
        ,fieldlabel   : '|'+window.lookup.lookupcols
        ,fieldenabled : '|n'
        });  
    } else {
      this.hdata=window.action(wdo+'.handle');
      define(
        {fieldname    : '|'+elem.getAttribute('fields')
        ,fieldlabel   : '|'+elem.getAttribute('labels')
        ,fieldenabled : '|'+elem.getAttribute('enabled')
        });  
    }
    var c ='<table class="browse" border="1" cellpadding="0" cellspacing="0"'
          +' ondblclick="window.app.'+id+'.ondblclick(event);"'
          +' oncontextmenu="window.app.'+id+'.oncontextmenu(event);"'
          +' onclick="window.app.'+id+'.click(main.fixEvent(event).target);"'
          +'><tr class="browseheader"><th class="browse">'
          +'<img class="tool enable" name="apply" id="apply" src="../img/find.gif" '
          +'style="display:none;" title="Apply_filter"></th>';
    var d='<tr class="filter" style="display:none;"><td class="filter" nowrap></td>';
    for(var i=1;i<fieldn;i++){
      c+='\n<th nowrap>'+fieldlabel[i]+'<font color="red"></font></th>';
      d+='<td nowrap><input class="filter" type="text"></td>' 
    }  
    this.browseempty=c+'</tr>'+d+'</tr>'+d+'</tr>';
    elem.innerHTML=browseempty+'</table>';
    sizeBrowse(elem.parentNode);
    
    elem.onscroll=function(e){
      var src=window.fixEvent(e?e:window.app.event).target;
      var tgt=src.getElementsByTagName('TABLE')[0].rows[0].style;	
      tgt.top=(src.scrollTop-2)+'px'; 
//      hotkey.browsenav=wdo;
//      browsescroll();
    }
  }
}

Browse.prototype.define=function(a){
  for(var e in a){
    var c=a[e].split('|');
    if(e=='fieldname') this.fieldn=c.length;	
    if(c.length<this.fieldn) for(var i=c.length;i<this.fieldn;i++)c[i]=c[i-1];
    this[e]=c; 
  }
}
Browse.prototype.ondblclick=function(e){  
  var src=window.fixEvent(e).target;
//  alert('src='+src.nodeName)
//  if(src.nodeName=='#text') src=src.nodeParent;
  this.click(src);
  if (this.erow>0) window.action(this.dblclick>''?this.dblclick:this.wdo+'.target');  
}

Browse.prototype.oncontextmenu=function(e){  
  var src=window.fixEvent(e).target;
  this.findRow(src);    
  if(this.erow>0) return false; 
  window.action(this.wdo+'.filter.toggle');
}

Browse.prototype.load=function(){       // Initializing datarows
  with(this){
    this.hdata=window.action(wdo + '.handle').hdata;
    var e=hdata.fieldname;
    var m=e.length;
    this.fieldnum=[];
    this.fieldnum[0]=0;
    for(var j=1;j<fieldn;j++)
      for(var i=0;i<m;i++)          // Create column index
        if(fieldname[j]==e[i]) this.fieldnum[j]=i;
    this.row=0;
    this.hcur=null;
    var c='';
    var n=0;
    this.offset=hdata.datafirst-1;
    this.datan=hdata.datalast-offset;  
    if(hdata.datafirst>0&&hdata.datafirst<=hdata.datalast)
     for(var i=0;i<datan;i++) {          // Fill tables with rows
      var cur=hdata.data[i+offset].split(hdata.dlm);
      c+='<tr class="browse'+(i%2==1?' alt':'')+'"><td></td>';
      for(var j=1;j<fieldn;j++)          // Fill rows with data cells
       c+='<td class="browse" nowrap>' + (cur[fieldnum[j]] > '' ? cur[fieldnum[j]] : '&nbsp;') + '</td>';
      c+='</TR>';
     } else window.status='Browser '+wdo+'says no data';
    
    elem.innerHTML=browseempty+c+'</table>';
    
    this.arow = elem.getElementsByTagName('TABLE')[0].rows;
    for(var i=nHeader;i<arow.length;i++){
       arow[i].setAttribute('i',i);            // dataset index for row  
       arow[i].setAttribute('t',i);            // real browse row for data!
    }
    datan=arow.length-nHeader;
      
    // Configure sorting & filtering headers 
    var n=arow[0].cells.length;
    for(var i=1;i<n;i++){  
      var j=fieldnum[i]; 
      arow[0].cells[i].setAttribute('sort',hdata.fieldsorting[j]);
      arow[0].cells[i].setAttribute('i',i);
      arow[0].cells[i].setAttribute('j',j);
      if(hdata.fieldfilter[j]!='y'){
        arow[1].cells[i].innerHTML='';  
        arow[2].cells[i].innerHTML='';
      } else {
        arow[1].cells[i].firstChild.value=hdata.filtfrom[j];  
        arow[2].cells[i].firstChild.value=hdata.filtto[j];
      }
    }
    // HTM23|From:;To:
    var msg=window.action('info.get|HTM23').split(';'); // ok
    arow[1].cells[0].innerHTML=msg[0];  
    arow[2].cells[0].innerHTML=msg[1];
    refreshHeader();
  }
}

Browse.prototype.refreshHeader=function(){
  with(this){
    var j=1;
    hdata.colSort='';
    for(var i=1;i<10;i++){                   // Adjust numbering 
      for(var l=0;l<hdata.fieldn;l++){
        if(hdata.sortnum[l]==i){
          hdata.sortnum[l]=j++;
          hdata.colSort+='|'+hdata.fieldname[l]+(hdata.sortdir[l]==2?' DESCENDING':'');
        } 
      }      
    }
    var cols=arow[0].cells;
    for(var i=1;i<cols.length;i++){
      var e=cols[i];
      var j=e.getAttribute('j');
      if(j>'') e.innerHTML=fieldlabel[i]+(sorting[hdata.sortdir[j]]).replace('&',hdata.sortnum[j]);
    }
  }
}

Browse.prototype.findRow=function(rNew){
  if (rNew.nodeName=='INPUT') return false;
  if (rNew.nodeName=='#text') rNew=rNew.parentNode;
  if (rNew.nodeName!='TR') rNew=rNew.parentNode;
  if (rNew.nodeName!='TR') rNew=rNew.parentNode;
  if (rNew.nodeName!='TR') return false;
  this.erow = (rNew.getAttribute('i')?rNew.getAttribute('i')-this.nHeader+1:null)
  return true;
}

/***** Browser operation *******/
Browse.prototype.click=function(rNew){
  window.browsesort=this;
  with(this){
    hotkey.browsenav=wdo;
    if(rNew.name=='apply') inlineFilter();
    if(!findRow(rNew)) return false;
    if(erow>0) return window.action(wdo+'.'+(erow+hdata.datafirst-1)+'.pick');
    
    // Column Sorting
    if (rNew.nodeName!='TH') rNew=rNew.parentNode;
    if (rNew.nodeName!='TH') rNew=rNew.parentNode;
    if(rNew.getAttribute('sort')!='y' && !hdata.complete) return false;  

    var j=rNew.getAttribute('j');
    hdata.sortdir[j]+=1; 
    hdata.sortdir[j]%=3;
    hdata.sortnum[j]=(hdata.sortdir[j]==0)?0:(hdata.sortnum[j]>0?hdata.sortnum[j]:9);
    refreshHeader();
    if(!hdata.complete) return;
    clientsort();
  }
}

Browse.prototype.clientsort=function(){
  with(this){
    this.srtdir=[];
    this.srtcol=[];
    var srt=hdata.colSort.split('|');
    for(var i=1;i<srt.length;i++){               // Set the data column numbers to sort
      srtdir[i-1]=(srt[i].indexOf('DESCENDING')>0?-1:1);
      srtcol[i-1]=hdata.lookup(srt[i].split(' ')[0]);
    } 
      
    var dt=[];                                   // Sort data
    for(var i=0;i<datan;i++) dt[i]=i+offset;  
    dt.sort(sortfunc);   
      
    for(var i=0;i<datan;i++){                    // Shuffle browse rows
      var r=arow[i+nHeader];                     
      r.setAttribute('i',dt[i]-offset+nHeader);  // Set real location & data
      var cur=hdata.data[dt[i]].split(hdata.dlm);
      for(var j=1;j<r.cells.length;j++)
        r.cells[j].innerHTML=(cur[fieldnum[j]]>'')?cur[fieldnum[j]]:'&nbsp;';
      arow[r.getAttribute('i')].setAttribute('t',i+nHeader);     // Set back reference
    }  
    pick(hdata.displayrow);                      // Redisplay current row
  }
}
Browse.prototype.sortfunc=function(i1,i2){
  with(window.browsesort){
    var r1=hdata.data[i1].split(hdata.dlm);
    var r2=hdata.data[i2].split(hdata.dlm);  
    for(var l=0;l<srtcol.length;l++){
      var v1=r1[srtcol[l]];
      var v2=r2[srtcol[l]];
      if(v1>v2) return srtdir[l];   
      if(v1<v2) return -(srtdir[l]);   
    }  
    return 0;
  }
}

Browse.prototype.action=function(a,prm){
  with(this){
    switch(a[0]){
      case 'enable':
      case 'disable':
      case 'hide':
      case 'show':
      default:
      alert('Browse action:'+elem.id+'/'+a+'/'+prm);
    }
  }
}

Browse.prototype.pick=function(newrow){
//  alert('browse pick')
  with(this){
    if(hdata.datafirst<1||hdata.datafirst>hdata.datalast) return false;
    var cur;
    if(row>0&&hcur && (cur=hdata.data[hcur.getAttribute('i')-nHeader+offset])){                            // Remove last highlighting
      if(cur){
        cur=cur.split(hdata.dlm);
        hcur.className='browse'+(hcur.rowIndex%2==0?' alt':'');
        for(var i=1;i<fieldn;i++)
          if(hcur.cells[i]) hcur.cells[i].innerHTML=(cur[fieldnum[i]] == '')?'&nbsp;':cur[fieldnum[i]];
      }
    }
    row=newrow;
    hcur=arow[arow[row+nHeader-hdata.datafirst].getAttribute('t')];
    if(row>0){
      cur  = hdata.data[row+offset-1].split(hdata.dlm);
      hcur.className = 'select';
      for(var i=1;i<fieldn;i++)
        hcur.cells[i].innerHTML = fieldenabled[i]=='y' && hdata.updatemode == 'update'
          ? '<input type=text value="'+cur[fieldnum[i]]+'" size='+(fieldname[i].offsetWidth/6)+'>'
          : (cur[fieldnum[i]]=='' ? '&nbsp;' : cur[fieldnum[i]]);
    }
    
    if(!hcur) return;
//    alert('1sh='+elem.scrollHeight+'/st='+elem.scrollTop+'/ch='+elem.clientHeight+'/rt='+hcur.offsetTop);
    if(hcur.offsetTop-16<elem.scrollTop) elem.scrollTop=hcur.offsetTop-16;
    if(hcur.offsetTop-elem.clientHeight+16>elem.scrollTop) elem.scrollTop=hcur.offsetTop-elem.clientHeight+16;
    browsescroll();
//    alert('2sh='+elem.scrollHeight+'/st='+elem.scrollTop+'/ch='+elem.clientHeight+'/rt='+hcur.offsetTop);
  }
}


/*********************************************/
/****** Methods and events          **********/
/*********************************************/

Browse.prototype.browsescroll=function(){               // Reposition the header row in visible window
  if(this.arow&&this.arow.length>0) 
    this.arow[0].style.top=(this.elem.scrollTop-2)+'px';
}

/*
Browse.prototype.onresize=function(e){
  var src=(document.all?e.srcElement:e.target);
  if(document.all) e.returnValue=false;
  else             e.stopPropagation();
  sizeBrowse(src.parentNode);
}
*/

Browse.prototype.sizeBrowse=function(e){      
//  alert('size='+e.style.width+'/'+e.style.height)	
  e.setAttribute('minx',(e.style.width).replace('px',''));
  e.setAttribute('miny',(e.style.height).replace('px',''));
  e.setAttribute('maxx',0);
  e.setAttribute('maxy',0);
}

Browse.prototype.recSave=function(cur){
  with(this){
    for(var i=1;i<fieldn;i++){
      var node=hcur.cells[i].firstChild;
      if(node==null) continue;
      if (fieldenabled[i]=='y' && node.nodeName=='INPUT') cur[fieldnum[i]]=node.value;
    }
  }
}

Browse.prototype.setFilter=function(){
  with(this){
    if(elem.getAttribute('filter')=='inline'){
      var d=hdata.filtermode?'block':'none';
//      alert(arow[0].cells[0].innerHTML)
      arow[0].cells[0].firstChild.style.display=d;
      arow[1].style.display=d;
      arow[2].style.display=d;
      return true;
    }
  }
}

Browse.prototype.inlineFilter=function(){
  with(this){
    var n=arow[0].cells.length;
    for(var i=1;i<n;i++){  
      var j=fieldnum[i]; 
      hdata.filtfrom[j]=arow[1].cells[i].firstChild.value;  
      hdata.filtto[j]=arow[2].cells[i].firstChild.value;
    }
    return window.action(wdo+'.filter');
  }
}

Browse.prototype.lookup=function(c){
  for(var i=1;i<this.fieldname.length;i++) if(c==this.fieldname[i]) return i;
}
