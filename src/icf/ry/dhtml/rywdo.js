//  File:         rywdo.js
//  Description:  Implements Progress SmartDataObject

Wdo.prototype=new Data();
Wdo.prototype.hdata;

Wdo.prototype.elem;
Wdo.prototype.sbo;
Wdo.prototype.id;
Wdo.prototype.childwdo=',';
Wdo.prototype.parentfield=null;
Wdo.prototype.parentval;
Wdo.prototype.objectname='';
Wdo.prototype.childfield;
Wdo.prototype.browse;
Wdo.prototype.filtermode=false;
Wdo.prototype.updatemode='';         // Current update mode
Wdo.prototype.displaymode='';        // Currently displayed update mode
Wdo.prototype.mustinitdata;
Wdo.prototype.remote;
Wdo.prototype.uplink;
Wdo.prototype.selflink=false;
Wdo.prototype.parent;
Wdo.prototype.link;
Wdo.prototype.commit;
Wdo.prototype.wdoinst;


function Wdo(){}

Wdo.prototype.init=function(e){
	with(this){
    this.wdoinst=(e.id).substr(1);
    this.wdo=wdoinst;
    this.elem=e;    
    this.hdata=this;
    this.id=(e.id);
    app[(e.id)]=this;    
    this.sbo=e.getAttribute('sbo');
    this.sbo=(this.sbo>''?this.sbo+'.':'');
    this.remote=e.getAttribute('remote');
    this.uplink=e.getAttribute('uplink');
    this.parent=e.getAttribute('parent');
    this.link=e.getAttribute('link');
    if(uplink){                       // Uplink identifies that this is masterwdo
      app.uplink=(hdata.wdo);
      app['dmaster']=this;
    }
    this.update=e.getAttribute('update');
    this.commit=e.getAttribute('commit');
    if(wdo=='lookup'){
      hdata.wdoreal=wdo;	
      dynlookup();
    } else if(remote>''){
      this.remote=window.action('parent.wbo.uplink');
      if(!remote) return;
      window.sdomaster=this;
      app.dmaster=this;
      elem.id='d'+remote;
      id=elem.id;
      app[id]=this; // deal with load function
      this.hdata        =window.action('parent.'+remote+'.handle').hdata;
      this.objectname   =window.action('parent.app.name');
      this.dlm          =hdata.dlm;
      this.mustinitdata=true;
      this.hdata.uncommitted=false;
//      window.later(wdo+'.refresh');
      this.fieldn=hdata.fieldn;
    } else {
      hdata.wdoreal=wdo;	
      define(
        {fieldname    : elem.getAttribute('fields')
        ,fieldvalidate: elem.getAttribute('validate')
        ,initvals     : elem.getAttribute('initvals')
        ,fieldformat  : elem.getAttribute('format')
        ,fieldenabled : elem.getAttribute('enabled')
        ,fieldfilter  : elem.getAttribute('filter')
        ,fieldsorting : elem.getAttribute('sorting')
        ,filtfrom     : elem.getAttribute('from')
        ,filtto       : elem.getAttribute('to')  
        ,sortdir      : '|0'
        ,sortnum      : '|0'
        });  
    }
    var c='<input type=hidden name='+hdata.id+'._do id='+hdata.id+'._do value="">'
     +'<input type=hidden name='+hdata.id+'._position id='+hdata.id+'._position value="">'
     +'<input type=hidden name='+hdata.id+'._object   id='+hdata.id+'._object   value="">'
     +'<input type=hidden name='+hdata.id+'._first    id='+hdata.id+'._first    value="">'
     +'<input type=hidden name='+hdata.id+'._last     id='+hdata.id+'._last     value="">'
     +'<input type=hidden name='+hdata.id+'._filter   id='+hdata.id+'._filter   value="">'
     +'<input type=hidden name='+hdata.id+'._find     id='+hdata.id+'._find     value="">'
     +'<input type=hidden name='+hdata.id+'._sorting  id='+hdata.id+'._sorting  value="">';
    for(var i=0;i<fieldn;i++)
      c+='\n<input type=hidden num='+i+' name='+hdata.id+'.'+hdata.fieldname[i]+' id='+hdata.id+'.'+hdata.fieldname[i]+' value="">';
    elem.innerHTML=c;

    // Initialize various references
    this.browse=null;
    this.savedata=[];
    this.saverow=[];
    
    if(this.parent=='master'&&app.dmaster==this){
      this.selflink=true;
      this.parent='';  // parent-child but independent 
    }
  }
}



Wdo.prototype.dynlookup=function(){
  with(this){
      define(  
        {fieldname:'rowident|_key|'+window.lookup.lookupcols
        ,fieldvalidate:'||n'
        ,fieldformat  :'|'
        ,fieldenabled :'||n'
        ,fieldfilter  :'||y'
        ,fieldsorting :'||y'
        ,filtfrom     :'|'
        ,filtto       :'|'
        ,sortdir      :'|0'
        ,sortnum      :'|0'
        });
  }
}

// Perform a refresh if WDO comes into display
Wdo.prototype.refresh=function(){
  with(this){
    this.wdo=wdoinst;
    hdata.wdo=wdo;
    if(mustinitdata){
      initdata();
      displayrow=0;
    }
    app.document.form[id+'._object'].value=objectname;
    this.positionok=true;
    initTools();

    if(hdata.updatemode==''){
      if(hdata.update=='auto') hdata.updatemode='view';
      hdata.updatemode=(hdata.update=='on'?'update':'view');
    }
    setMode(displaymode==hdata.updatemode?'':hdata.updatemode);
    // If there are changes then we should not initialize the record.
    if(action('wbo.nochange'))
      pick(0);
  }
}

Wdo.prototype.initdata=function(){
//  alert('initdata='+this.wdo)
  with(this){
    this.mustinitdata=false;
    var ret=false;
    var rowindata=false;

    if(this.parent>'' && !this.parentwdo){
      this.parentwdo=window.action(this.parent+'.handle');
      if(!this.parentwdo) this.parent='';
    }
    if(this.parent>'' && this.parentfield==null)
    {
      if(!(parentwdo.childwdo).match(','+wdo+','))
      {
        parentwdo.childwdo+=wdo+',';
      }
      
      var c=(link+','+link).split(',');

      for(var i=1;i<fieldn;i++)
      {
        if(hdata.fieldname[i]==c[0])
          this.childfield=i;
      }

      for(var i=1;i<parentwdo.hdata.fieldn;i++)
      {
        if(parentwdo.hdata.fieldname[i]==c[1])
          this.parentfield=i;
      }
    }
    
    // Reposition dataset if in parent-child
    if(this.parent>'' && parentwdo.hdata.data.length>0){
      this.parentval=parentwdo.hdata.data[parentwdo.hdata.row-1].split(dlm)[parentfield];
      ret=true;
      hdata.datafirst=0;
      hdata.datalast=0;
      for(var i=0;i<hdata.data.length;i++){
        var test=hdata.data[i].split(dlm)[childfield];
        if(test!=parentval) continue;
        ret=false;
        if(i==hdata.row-1) rowindata=true;
        if(hdata.datafirst==0) hdata.datafirst=i+1;
        hdata.datalast=i+1;
      }
      if(!rowindata) hdata.row=hdata.datafirst;
    }
    if(hdata.data.length>0&&hdata.row==0) hdata.row=1;
    displayrow=0;
    hdata.datafirst =1;
    hdata.datalast  =hdata.data.length;
    // load browse data
    if(browse) browse.load();
    // Clear viewer data
    if(hdata.datafirst>hdata.datalast) for (var i=0;i<fieldn;i++) setViewer(hdata.fieldname[i],'');
    setMode('');
    return ret;
  }
}
 
Wdo.prototype.pick=function(iNew){
  with(this){
//    alert('Pick='+hdata.row+'/'+iNew+',wdo='+wdo+',nav='+hdata.lNav)
    if(iNew>0 && (!hdata.lNav || updatemode=='modify')) return false;
    if(hdata.data.length<1 || hdata.datafirst==0) return false;
    if(iNew==0){
      if(update=='wdo.return'){ // If the lookup needs to be positioned
        for(var i=1;i<hdata.data.length;i++)
          if(hdata.data[i].split(dlm)[1]==window.returnfield.value) iNew=i+1;
      } else iNew=hdata.row;  // if just refreshing
    } else {
      var oldrecs=hdata.data.length;
      if(!action('savechange')){ 
        if(hdata.commit!='true') app.wbo.afterSave(wdo+'.'+iNew+'.pick');
        // HTM5|Do you want to save current changes?
        if(!window.action('info.yesno|HTM5||'+wdo+'.save|'+wdo+'.cancel')) //ok
          return app.wbo.afterSave(wdo+'.'+iNew+'.pick');
      } else action('save');
      iNew+=hdata.data.length-oldrecs;   // Adjust for datasave on add operation
      hdata.refreshMode()
    }
  
    if(iNew<hdata.datafirst) iNew=hdata.datafirst;  // Adjusting if before first record
    if(iNew>hdata.datalast)  iNew=hdata.datalast;   // Adjusting if past last record
   
    displayrow=iNew;
    hdata.row=displayrow;    // Linking hdata
    
    if(app.uplink==wdo && !selflink) 
      app.document.form.lookup.value=hdata.wdo+'.'+hdata.data[row-1].split(dlm)[0]+'.primarySDO';
    
    if(browse) browse.pick(displayrow); //Selecting the new row for browse widgets
    var cur=hdata.data[displayrow-1].split(dlm);        //Setting the viewer fields
    hdata.lAdd=this.lAdd=(cur[0]=='add');
    for(var i=0;i<fieldn;i++){
      markField(hdata.fieldname[i],false);
      setViewer(hdata.fieldname[i],cur[i]);
    }
    hdata.refreshNav();
//    alert('should check child='+app.wbo.committing)
    if(!app.wbo.committing && childwdo!=',' && this.positionok){
      var c=childwdo.split(',');
      var repost=false;
      for(var i=1;i<c.length-1;i++)
        if(window.action(c[i]+'.refreshchild')) repost=true;
      if(repost){
        app.document.form[id+'._position'].value=hdata.data[hdata.row-1].split(dlm)[0];
        window.action('server.'+hdata.sbo+hdata.wdoinst+'.position');
        window.action('wbo.submit');
      }
    }
    custom('view',hdata.updatemode);  // Custom display logic
    return true;
  }
}




Wdo.prototype.action=function(c,prm){
  with(this){
    if(remote==false) return false;  // not initialized remote SDO
    window.status='event:'+c;
    c=c.split('.');
    switch(c[c.length - 1]){
      case 'handle':
        return this;
      case 'locknav':
        hdata.lNav=false;
        return true;
      case 'unlocknav':
        hdata.lNav=(hdata.updatemode!='modify')
        return hdata.lNav;
      case 'pick':
        return pick(c[0]*1);
      case 'refresh':
        return refresh();
      case 'initdata':
        app.document.form[id+'._object'].value=objectname;
        if(!mustinitdata) return false;
        return initdata();
      case 'refreshchild':
//        alert('refresh child='+wdo+'/'+parentval)
        if(parentwdo.hdata.row>0){   // don't refresh children if current value is correct..
          var par=parentwdo.hdata.data[parentwdo.hdata.row-1].split(dlm)[parentfield];
          if(par==parentval) return false;
        }
        if ((parentwdo.hdata.data == 0)||
            (parentwdo.hdata.data[parentwdo.hdata.row-1].split(dlm)[0]=='add'))
        {
          load([],dlm,0);
          initdata();

          var c=childwdo.split(',');
          for(var i=1;i<c.length-1;i++)
          {
            if (c[i] > '')
              window.action(c[i]+'.refreshchild');
          }
          
          return false;
        }

        return initdata();
      case 'nochange':
        if(hdata.data.length==0) return hdata.olddata.length==0;
//        alert('recinput='+recInput()+'\nuncommitted='+hdata.uncommitted+'\ndisplayrow='+(hdata.data[displayrow-1]!=hdata.olddata[hdata.findold(displayrow-1)]))
        return !(hdata.uncommitted||recInput()||hdata.data[displayrow-1]!=hdata.olddata[hdata.findold(displayrow-1)]);
      case 'saveuncommitted':  // False if there's data changed
        if(!hdata.uncommitted) return true;
        // HTM5|Do you want to save current changes?
        return window.action('info.yesno|HTM5||wbo.commit|wbo.undo'); //ok
      case 'savechange':  // False if there's data changed
        if(recInput()) return false;           
        // Check all child WDOs too
        if(childwdo!=',' && positionok){
          var c=childwdo.split(',');
          for(var i=1;i<c.length-1;i++){
            if(!window.action(c[i]+'.savechange')) return false;
            if(!window.action(c[i]+'.saveuncommitted')) return false;
          }
        }
        return true;      
      case 'target':
        if(update && update.split('.').length==2){
          this.mustinitdata=true;
          app.uplink=(hdata.wdo);
          appcontrol.cLookup=hdata.wdo+'.'+hdata.data[row-1].split(dlm)[0]+'.primarySDO';
          return window.action(update);
        }
        return action('update');
      case 'save':
        recSave();
        return false;
      case 'reset':
        pick(0);
        custom('reset');
        if(hdata.data[displayrow-1].split(dlm)[0]=='add') return;
        return setMode(displaymode=='update'?'update':'view');
      case 'update':
        setMode('update');
        return custom('modify');
      case 'modify':
        if(hdata.updatemode!='update') return false;
        setMode('modify');
        return custom('modified');
      case 'cancel':
        if(hdata.data.length==0)
            return;

        // Since delete actually deletes the record from hdata.data even before the server
        // sends a success response.  If the server fails to delete the record we need to 
        // reset the hdata.data from the hdata.olddata.
        if (displayrow > hdata.data.length)
        {
            hdata.data=([]).concat(hdata.olddata);
            initdata();
            refresh();
        }
        else if(hdata.data[displayrow-1].split(dlm)[0]=='add')
        {
          // if add fails we need to remove the last record from hdata
          hdata.data=(hdata.data.slice(0,displayrow - 1)).concat(hdata.data.slice(displayrow));
          initdata();
          hdata.mustinitdata=true;
        }
        
        pick(0);
        app.wbo.savechange='';
        custom('cancel');

        return setMode(displaymode=='update'?'update':'view');
      case 'view':
        if(update!='auto') displaymode='off';     
        if(action('nochange')||hdata.commit!='true') return setMode('view');
        // HTM5|Do you want to save current changes?
        else return window.action('info.yesno|HTM5||'+wdo+'.save|'+wdo+'.cancel'); //ok
      case 'view2':
      case 'update2':
      case 'add2':
      case 'copy2':
        action(c[0].replace('2',''));
        return action('target');
      case 'mark':
        return markField(c[0],true);
      case 'unmark':
        return markField(c[0],false);
      case 'old':
        return hdata.data[displayrow - 1].split(dlm)[lookup(c[0])];
      case 'getdata':
        return hdata.data[displayrow - 1].split(dlm)[lookup(c[0])];
      case 'get':
      case 'getinput':
        return getViewer(c[0],hdata.data[displayrow - 1].split(dlm)[lookup(c[0])]);
      case 'gettype':
        var i=lookup(c[0]);
        return hdata.fieldvalidate[i];
      case 'getvalue':
        var i=lookup(c[0]);
        return window.strip(getViewer(c[0],hdata.data[displayrow - 1].split(dlm)[i]),hdata.fieldvalidate[i]);
      case 'setvalue':
        prm=window.format(prm,hdata.fieldvalidate[lookup(c[0])]);
      case 'set':
        setViewer(c[0],prm);
      case 'setdata':
        if(hdata.fieldenabled[lookup(c[0])]=='y') action('modify');
        var cur=hdata.data[displayrow - 1].split(dlm);
        cur[lookup(c[0])]=prm;
        hdata.data[displayrow - 1]=cur.join(dlm);
        return prm;
      case 'setinput':
        if(hdata.fieldenabled[lookup(c[0])]=='y') action('modify');
        return setViewer(c[0],prm);
      case 'toggle':
        var b=filtermode;    //  Toggles filter for browse widgets
        c[c.length - 1]=b?'disable':'enable';
      case 'focus':
      case 'hide':
      case 'show':
      case 'enable':
      case 'disable':
        if(c[0]!='filter') return window.action('tool.'+wdo+'.'+c.join('.'));
        var b=(c[c.length-1]=='enable');  //  Toggles filter for browse widgets
        this.filtermode=b;
        var inline=false;
        window.returnfield=hdata;
        if(browse && browse.setFilter()) inline=true;
        if(!inline)          // Execute filter dialog unless 'inline' browser present
          if(window.action('util.../dhtml/ryfilter.htm'))
            window.action(wdo+'.filter');
        return initTools();
      case 'filter':
        setFilter();
        if(hdata.commit!='true') action('commitdata');
        return window.actions(['server.'+hdata.sbo+hdata.wdoinst+'.filter','wbo.submit']);
      case 'lookup':
        if(c.length==1){
          window.returnfield=hdata;
          var cFind=window.action('util.../dhtml/ryfind.htm');
          if(cFind>''){
            app.document.form[id+'._find'].value=cFind;
            if(hdata.commit!='true') action('commitdata');
            return window.actions(['server.'+hdata.sbo+hdata.wdo+'.find','wbo.submit']);
          }
          return;
        }
        window.returnfield=app.document.getElementsByName(wdo+'.'+c[0])[0];
        var val=window.returnfield.value;
        if(hdata.data[displayrow-1].split(dlm)[lookup(c[0])]==val) val='';
        app.document.form.lookup.value=val;
        var cParent=window.returnfield.getAttribute('lookupParent');
        if(cParent>'') cParent=window.action(cParent+'.get');
        app.document.form['lookupparent'].value=cParent;
        lookup.lookupval=val;
        app.wbo.editfield(window.returnfield);
        window.action('server.lookup.launch.'+window.returnfield.getAttribute('lookup'));
        return window.action('wbo.submit');
      case 'change':
        var e=prm.split(',');
        for(var i=1;i<e.length;i++) action(e[i]+'.set','');
        break;
      case 'return':
        updatemode='view';
        window.returnfield.value=data[displayrow-1].split(dlm)[1];
        return window.action('app.back');
      case 'util':
        action('modify');
        var e=app.document.getElementsByName(wdo+'.'+c[0])[0];
        if(e && e.getAttribute('lookup')) return action(c[0]+'.lookup');        	
        window.returnfield=e;
        for(var i=1;i<fieldn;i++)
          if(hdata.fieldname[i]==c[0]){
            switch(hdata.fieldvalidate[i]){
              case 'date':
                return window.action('util.../dhtml/rycalendar.htm');
              case 'dec':
              case 'int':
                var el=app.document.getElementsByName(wdo+'.'+hdata.fieldname[i])[0];
                if(el.type=='radio') 
                  return false;
                else
                  return window.action('util.../dhtml/rycalculator.htm');
              default:
            }
          }
        return null;
      case 'export':
        // HTM24|Number of data rows
        var num=window.action('info.prompt|HTM24||100'); //ok
        if(!num) return;
        var ob=(app.location.pathname).split('/');
        var link=(ob[ob.length-1].split('.')[0])+'.'+this.wdo+'.'+appcontrol.sessionid+'.'+num;
    	document.cookie='sessionid='+appcontrol.sessionid;
        return window.open('ryexcel.'+link+'.icf','excelsheet','width=720,height=240,toolbar=1,location=0,menubar=1,status=1,resizable=1',false);
      default:
        return dataAction(c,prm);
    }
  }
}

Wdo.prototype.childAction=function(c,prm){
}

Wdo.prototype.parentAction=function(c,prm){
  if(this.parentwdo && this.parentwdo.action(c,prm)) 
    this.parentwdo.parentAction(c,prm);
}

Wdo.prototype.setFilter=function(){
  with(this){
    var filt='',c='';
    for(var i=1;i<fieldn;i++){
      c=hdata.filtfrom[i];
      if(c>'') filt+='|'+hdata.fieldname[i]+' > '+c;
      c=hdata.filtto[i];
      if(c>'') filt+='|'+hdata.fieldname[i]+' < '+c;
    }
    app.document.form[id+'._sorting'].value=hdata.colSort;
    app.document.form[id+'._filter'].value=filt;
    this.filtermode=false;
  }
}

// Viewer functionality related to Dataset


Wdo.prototype.recInput=function(){      // Assemble data input into cur;
  with(this){
    if(hdata.updatemode!='modify') return false;	
    if(hdata.updatemode=='view' || hdata.data.length==0 || displayrow==0) return false;
    this.cur=hdata.data[displayrow - 1].split(dlm);
    for(var j=0;j<fieldn;j++){
      if(hdata.fieldenabled[j]!='y') continue;
      var a=getViewer(hdata.fieldname[j],cur[j]);
      if(window.strip(a,hdata.fieldvalidate[j])==window.strip(cur[j],hdata.fieldvalidate[j])) continue;
      cur[j]=a;
    }
    // Assemble data from browse widgets
    if(browse) browse.recSave(cur);            //  Getting values from updateble browse widgets
    
    if(hdata.data[displayrow - 1].split(dlm)[0]=='add') return true;
//    alert('recinput:'+(cur.join(dlm)!=hdata.data[displayrow-1])+'\n'+cur.join(dlm)+'\n'+hdata.data[displayrow-1]);
    return (cur.join(dlm)!=hdata.data[displayrow-1]);
  }
}


Wdo.prototype.recSave=function(){    // Save record operation
  with(this){
    if(recInput()){
      if(custom('validate')==false) return false;
      if(!recValidate()) return false;
      hdata.data[displayrow-1]=cur.join(dlm);
      custom('update');
      if(hdata.commit=='true'){
      	if(!app.wbo.committing)	action('commit');
      	return true;
      } else {
        setMode(displaymode=='update'?'update':'view');
        window.action(app.wbo.savechange);
        app.wbo.savechange='';        
      }
    } 
    setMode(displaymode=='update'?'update':'view');	
  }
}



Wdo.prototype.markField=function(field,mark){
  with(this){
    var el=app.document.getElementsByName(wdo+'.'+field);
    for(var i=0;i<el.length;i++){
      if((el[i].className+' ').split(' ')[0]=='field')
        el[i].className=(el[i].className).split(' ')[0]+(mark?' marked':((hdata.updatemode == 'view' || el[i].readOnly) ? ' disable':' enable'));
    }
  }
}

Wdo.prototype.getViewer=function(fld,val){
  with(this){
    var elems=app.document.getElementsByName(wdo+'.'+fld);
    for(var i=0;i<elems.length;i++){
      var e=elems[i];
      if(e.getAttribute('disable')) continue;
      if(e.nodeName=='SELECT') return e.value;                 
      if(e.type=='radio' && e.checked) return e.value;
      if(e.type=='checkbox') return e.checked?'yes':'no';
      if(e.type=='text'||e.type=='hidden'||e.type=='password'||e.nodeName=='TEXTAREA')
        return window.escapedata(e.value);   
      if(e.nodeName=='IMG' && e.getAttribute('tool')=='util') return e.value;
    }
    return val;
  }
}

Wdo.prototype.setViewer=function(fld,val,lInput){
  with(this){
    // Lookup each input element and set its value
    var elem=app.document.getElementsByName(wdo+'.'+fld);
    for(var j=0;j<elem.length;j++){
      var e=elem[j];
      if(lInput&&e.getAttribute('disable')) return;
      if(e.type=='checkbox'){
        e.checked=(val=='yes');
        e.value='yes';
      } else if(e.nodeName=='SELECT'){
      	e.value=val;
      	if(val && (e.value!=val||e.selectedIndex==-1))
      	  // HTM13|Invalid data for &1 = &2
      	  window.action('info.field|HTM13||'+wdo+'.'+fld+'|'+val); //ok
      } else if(e.type=='radio'){
        e.checked=(e.value==val);
      } else {
        e.value=val;
      }
    }
  }
}

// Other viewer functionality

// Displaymode='off/view/update' if update='on/view'
Wdo.prototype.setMode=function(umode){
  with(this){
    var oldmode=hdata.updatemode;	
    if(umode!='' && oldmode!=umode){
      if(umode!='view'||displaymode!='off') displaymode=umode; 
      if(update=='on'&&displaymode!='off') displaymode='update';
      hdata.updatemode=(umode=='modify'?'modify':(displaymode=='update'?'update':'view'));
      if(oldmode=='modify') parentAction('unlocknav');
      if(hdata.updatemode=='modify') parentAction('locknav');
    }
    var enmod=(hdata.updatemode=='view' || hdata.data.length==0 ?'.disable':'.enable');
    // if(!(oldmode=='modify' && hdata.updatemode=='modify') || umode==''){
      for (var i=0;i<fieldn;i++)
        window.action('tool.'+wdo+'.'+hdata.fieldname[i]+(hdata.fieldenabled[i]=='n' ?'.disable':enmod));
      if(browse) browse.pick(displayrow);                //  Selecting row in browse widgets
    // }
    hdata.refreshMode();
    custom('view',hdata.updatemode);
    return true;
  }
}


Wdo.prototype.initTools=function(){
  action('tool.'+this.wdo+'.filter.toggle.'+(this.hdata.filtfrom.join('')+this.hdata.filtto.join('')>''?'check':'uncheck'));
}


Wdo.prototype.custom=function(c,prm){
  if(!app[this.wdo+'_'+c]) return true;
  return app[this.wdo+'_'+c](prm);
}







