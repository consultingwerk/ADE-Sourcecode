//  File:         rybrowse.js
//  Description:  Implements the browser object


/***** Browser construction and local data *******/
Browse.prototype.elem;
Browse.prototype.wdo;
Browse.prototype.id;
Browse.prototype.app;
Browse.prototype.lUpd;

Browse.prototype.fieldname;    // Names row as array
Browse.prototype.fieldnum;     // WDO ref   as array
Browse.prototype.fieldenabled; // Enabled as array
Browse.prototype.fieldlabel;   // Labels as array
Browse.prototype.fieldn;       // Number of elements in header row

Browse.prototype.fields;    
Browse.prototype.labels;    
Browse.prototype.dblclick;    
Browse.prototype.clicksrc;     // Source of the click

Browse.prototype.srtdir;       // Temporary clientsort variables
Browse.prototype.srtcol;    

Browse.prototype.arow=null;    // Array of TR rows
Browse.prototype.hdata;        // handle to WDO datasource
Browse.prototype.data=null;    // current data displayed
Browse.prototype.hcur=null; // handle to current highlighted row
Browse.prototype.erow;         // Event row local
Browse.prototype.datan;        // Number of rows in local data
Browse.prototype.row=0;        // current local dataset-row
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
    app['_'+wdo].browse=this;
    refresh();
  }
}

Browse.prototype.refresh=function(){
  with(this){
    lognote(' Browse init:'+id);
    this.hdata=app['_'+wdo].hdata;
    if(wdo=='lookup'){
      this.wdo='lookup';
      define(
        {fieldname    : '|'+window.lookup.lookupcols
        ,fieldlabel   : '|'+window.lookup.lookuplabels
        ,fieldenabled : '|n'
        });  
    } else {
      define(
        {fieldname    : '|'+elem.getAttribute('fields')
        ,fieldlabel   : '|'+elem.getAttribute('labels')
        ,fieldenabled : '|'+elem.getAttribute('enabled')
        });  
    }
    var c =['<table class="browse" style="display:none;" border="1" cellpadding="0" cellspacing="0"'
          +' ondblclick="window.main.app=window;window.app.'+id+'.ondblclick(event);"'
          +' oncontextmenu="window.main.app=window;window.app.'+id+'.oncontextmenu(event);"'
          +' onclick="window.main.app=window;window.app.'+id+'.click(event);"'
          +'><tr class="browseheader"><th class="browse">'
          +'<img class="tool enable" name="apply" id="apply" src="../img/find.gif" '
          +'style="display:none;" title="Apply_filter"></th>'];
    var d=['<tr class="filter" style="display:none;"><td class="filter" nowrap></td>'];
    for(var i=1;i<fieldn;i++){
      c.push('\n<th nowrap>'+fieldlabel[i]+'<font color="red"></font></th>');
      d.push('<td nowrap><input class="filter" type="text"></td>'); 
    }  
    this.browseempty=c.join('')+'</tr>'+d.join('')+'</tr>'+d.join('')+'</tr>';
    elem.innerHTML=browseempty+'</table>';
    elem.onscroll=function(e){this.getElementsByTagName('TABLE')[0].rows[0].style.top=(this.scrollTop-2)+'px'}
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
  if(!this.clicksrc) this.click(e);
  if(this.erow>0) userAction(this.dblclick>''?this.dblclick:this.wdo+'.view2');  
}

Browse.prototype.oncontextmenu=function(e){  
  var src=window.fixEvent(e).target;
  this.findRow(src);    
  if(this.erow>0) return false; 
  window.action(this.wdo=='lookup'?'wbo.2.changepage':this.wdo+'.filter.toggle');
}

Browse.prototype.load=function(){       // Initializing datarows
  lognote(' browse load:'+this.id);
  with(this){
    this.lUpd=false;
    this.fieldnum=[0];
    for(var j=1;j<fieldn;j++) this.fieldnum[j]=hdata.index[fieldname[j]];

    this.row=0;
    this.hcur=null;
    this.datan=hdata.data.length;  

    var c=[];
    for(var i=0;i<datan;i++) {          // Create HTML
      var cur=hdata.data[i].split(hdata.dlm);
      var val='';
      c.push('<tr class="browse'+(i%2==1?' alt':'')+'"><td></td>');
      for(var j=1;j<fieldn;j++){
        val=cur[fieldnum[j]];
        c.push('<td class="browse" nowrap>'+(val?val:'&nbsp;')+'</td>');
      }
      c.push('</tr>');
    }
    
    lognote(' set innerHTML');
    elem.innerHTML=browseempty+c.join('')+'</table>';
    lognote(' init header');
    
    this.arow = elem.getElementsByTagName('TABLE')[0].rows;
    for(var i=nHeader;i<arow.length;i++){
       arow[i].setAttribute('i',i);            // dataset index for row  
       arow[i].setAttribute('t',i);            // real browse row for data!
    }
    this.datan=arow.length-nHeader;
      
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
    elem.firstChild.style.display='block';
    lognote('Browse done:');

  }
}

Browse.prototype.refreshHeader=function(){
  lognote('Browse Header:'+this.id);
  with(this){
    var j=1;
    hdata.colSort='';
    for(var i=1;i<10;i++){                   // Adjust numbering 
      for(var l=0;l<hdata.fieldn;l++){
        if(hdata.sortnum[l]==i){
          if(j<10){
            hdata.sortnum[l]=j++;
            hdata.colSort+='|'+hdata.fieldname[l]+(hdata.sortdir[l]==2?' DESCENDING':'');
          } else {   
            hdata.sortnum[l]=0;
            hdata.sortdir[l]=0;
          }
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

Browse.prototype.findRow=function(e){
  if (e.nodeName=='INPUT') return false;
  while(e.nodeName!='TR' && e.nodeName!='BODY') e=e.parentNode;
  if(e.nodeName!='TR') return false;
  this.erow = (e.getAttribute('i')?e.getAttribute('i')-this.nHeader+1:null)
  return true;
}

/***** Browser operation *******/
Browse.prototype.click=function(e){
  var src=fixEvent(e).target;
  this.clicksrc=src;
  window.browsesort=this;
  with(this){
    if(appcontrol.busy) return window.status='Please wait, BUSY processing request.';

    hotkey.browsenav=wdo;
    if(src.name=='apply') inlineFilter();
    if(!findRow(src)) return false;
 
    // if in update mode or navigation is disabled then disable sorting and pick 
    if(!hdata.lOK) return;
    if(erow>0)      
      return window.userAction(wdo+'.'+erow+'.pick');

    // Column Sorting
    if (src.nodeName!='TH') src=src.parentNode;
    if (src.nodeName!='TH') src=src.parentNode;
    if(src.getAttribute('sort')!='y' && hdata.batch!=0) return false;  
    
    var j=src.getAttribute('j');
    hdata.sortdir[j]+=1; 
    hdata.sortdir[j]%=3;
    hdata.sortnum[j]=(hdata.sortdir[j]==0)?0:(hdata.sortnum[j]>0?hdata.sortnum[j]:9);
    refreshHeader();
    if(hdata.batch!=0) return;
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
      srtcol[i-1]=hdata.index[srt[i].split(' ')[0]];
    } 
    var dt=[];                                   // Sort data
    for(var i=0;i<datan;i++) dt[i]=i;  
    dt.sort(sortfunc);   
      
    for(var i=0;i<datan;i++){                    // Shuffle browse rows
      var r=arow[i+nHeader];                     
      r.setAttribute('i',dt[i]+nHeader);  // Set real location & data
      var cur=hdata.data[dt[i]].split(hdata.dlm);
      for(var j=1;j<r.cells.length;j++)
        r.cells[j].innerHTML=(cur[fieldnum[j]]>'')?cur[fieldnum[j]]:'&nbsp;';
      arow[r.getAttribute('i')].setAttribute('t',i+nHeader);     // Set back reference
    }
    hcur.className='browse'+(hcur.rowIndex%2==0?' alt':''); // Remove highlight
    this.row=0;
    pick(hdata.row);                      // Redisplay current row
  }
}
Browse.prototype.sortfunc=function(i1,i2){
  with(window.browsesort){
    var r1=hdata.data[i1].split(hdata.dlm);
    var r2=hdata.data[i2].split(hdata.dlm);  
    for(var l=0;l<srtcol.length;l++){
      var v1=r1[srtcol[l]].toUpperCase();
      var v2=r2[srtcol[l]].toUpperCase();
      if(v1>v2) return srtdir[l];   
      if(v1<v2) return -(srtdir[l]);   
    }  
    return 0;
  }
}

Browse.prototype.action=function(a,prm){
  with(this){
    switch(a[0]){
      case 'enable':  case 'disable':
      case 'hide':    case 'show':
      default:
      alert('Browse action:'+elem.id+'/'+a+'/'+prm);
    }
  }
}

Browse.prototype.pick=function(){
  with(this){
    if(!arow) load();    // Parent of DynFrame may accidentally call this prior to load()  
    if(this.row && hcur && row!=hdata.row){ // Remove last highlighting
      var cur=data.split(hdata.dlm);
      hcur.className='browse'+(hcur.rowIndex%2==0?' alt':'');
      for(var i=1;i<fieldn;i++)
        if(hcur.cells[i]) hcur.cells[i].innerHTML=(cur[fieldnum[i]] == '')?'&nbsp;':cur[fieldnum[i]];
    }
    this.row=hdata.row;
    if(!row) return;
    
    this.hcur=arow[arow[row-1+nHeader].getAttribute('t')];
    this.data=hdata.data[row-1];
    var cur=data.split(hdata.dlm);
    hcur.className='select';
    this.lUpd=hdata.lUpd;
    for(var i=1;i<fieldn;i++)
      hcur.cells[i].innerHTML = fieldenabled[i]=='y' && lUpd
        ? '<input type="text" value="'+cur[fieldnum[i]]+'" size="20">'
        : (cur[fieldnum[i]]=='' ? '&nbsp;' : cur[fieldnum[i]]);
    initFocus();
  }
}

Browse.prototype.initFocus=function(){               // Reposition the header row in visible window
  with(this){
    if(hcur.offsetTop-hcur.clientHeight<elem.scrollTop) elem.scrollTop=hcur.offsetTop-hcur.clientHeight; // Top
    if(hcur.offsetTop-elem.clientHeight+hcur.clientHeight>elem.scrollTop) elem.scrollTop=hcur.offsetTop-elem.clientHeight+hcur.clientHeight;  // Bottom
    browsescroll();
    var INPUT=this.hcur.getElementsByTagName('INPUT');
    if(INPUT.length) try{ INPUT[0].focus(); } catch(e){}
  }
}


/*********************************************/
/****** Methods and events          **********/
/*********************************************/

Browse.prototype.browsescroll=function(){               // Reposition the header row in visible window
  if(this.arow&&this.arow.length>0) 
    this.arow[0].style.top=(this.elem.scrollTop-2)+'px';
}

Browse.prototype.recData=function(){
  with(this){
    for(var i=1;i<fieldn;i++){
      var node=hcur.cells[i].firstChild;
      if(node==null) continue;
      if (fieldenabled[i]=='y' && node.nodeName=='INPUT') hdata.cur[fieldnum[i]]=node.value;
    }
  }
}

Browse.prototype.setFilter=function(){
  with(this){
    if(elem.getAttribute('filter')=='inline'){
      var d=hdata.filtermode?'block':'none';
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
