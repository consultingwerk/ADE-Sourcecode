/*
  File:         rywdo.js
  Description:  Implements Screen Data Logic

  Interfaces:
    hdata       - rydata.js, Smart Data object
    viewer      - Array of controlled viewers
    browse      - Reference to controlled browse object
    inputField  - Reference to controlled viewer fields

  There can be multiple Wdo for a shared (hdata) Data object when "remote" Wdo.

  This object contains current displayed values for a data object
    status      - Collection of toolbar button status
    row,cur     - current displayed data
    lMod,lUpd   - current display mode

  Controls following in the app object
    app.uplink
    app._master


*/

Wdo.prototype.filtermode=false;
Wdo.prototype.filterOn=false;
Wdo.prototype.selflink=false;
Wdo.prototype.visible=true;
Wdo.prototype.lUpd=true;   // Current display mode (update=true)
Wdo.prototype.row=0;       // Currently displayed row
Wdo.prototype.cur='';      // Currently displayed data


function Wdo(){}

/*****************************************************************/
/***  Initialization *********************************************/
/****************************************************************
   1. init, object initialization
    -- dynLookup, defines a loookup WDO
    -- fieldRegister, builds an array of data associated fields

   2. initdata, initializes screen to use new dataset
   3. refresh, refresh screen to correct values

   4. refreshTools, display current tool status
   5. refreshRow,  display current data row
    -- viewermode, enable/disable fields
    -- displayfields, set field value

   6. initfocus, set focus to field with lowest tabIndex
*/

Wdo.prototype.init=function(e){
  with(this){
    lognote(' WDO init:'+e.id)
    // Initialize various references
    this.browse=null;
    this.viewer=[];
    this.inputField=new Object();
    this.wdoinst=e.id;
    this.wdo=wdoinst;
    this.remote=e.getAttribute('remote');
    this.elem=e;
    this.app=window.app;
    this.id=e.id;
    this.page=new Object();
    app['_'+id]=this;

    // Initial status when page is drawn
    this.status=
     {add   :true
     ,copy  :true
     ,del   :true
     ,save  :true
     ,cancel:true
     ,reset :true
     ,view  :true
     ,update:true
     ,commit:true
     ,undo  :true
     ,first :true
     ,prev  :true
     ,next  :true
     ,last  :true
     ,find  :true
     ,comments :true
     ,filter   :true
     ,lookup   :true
    };

    if(wdo=='lookup'){
      this.hdata=new Data();
      hdata.init(e);
      hdata.wdoreal=wdo;
      dynlookup();
    } else if(remote>'' || (app.frameObject.parent && app.frameObject.parent.uplink)){
      if(!app.frameObject.parent) return;
      if(app.frameObject.dyntag && !app.frameObject.dyntag.getAttribute('uplink')) return; // Not linked dynamic frame such as for treeview security control
      this.remote= app.frameObject.dyntag 
                 ? app.frameObject.parent.win['_'+app.frameObject.dyntag.getAttribute('uplink')].hdata
                 : app.frameObject.parent.win.uplink;
      if(!remote) return;
      app.uplink=remote;
      window.sdomaster=this;
      elem.id=remote.wdo;
      app._master=this;
      id=elem.id;
      this.hdata=this.remote;
      app['_'+hdata.wdoreal]=this; // deal with load function
      hdata.objectname=app.frameObject.parent.src;
      hdata.childRow=hdata.row; // Parent pass-thru only to be updated at refresh 
      this.mustinitdata=true;
      this.hdata.uncommitted=false;
    } else {
      this.hdata=new Data();
      hdata.init(e);
      if(!app.uplink){
        app.uplink=hdata;    // set default uplink target to first WDO
        app._master=this;
      }
      hdata.wdoreal=wdo;
      hdata.wdo=wdo;
      hdata.define(
        {fieldname    : elem.getAttribute('fields')
        ,fieldvalidate: elem.getAttribute('validate')
        ,initvals     : elem.getAttribute('initvals')
        ,fieldlabel   : elem.getAttribute('labels')
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
    initForm();  

    if(this.parent=='master' && app._master==this){
      this.selflink=true;
      this.parent='';  // parent-child but independent
    }
    if(!hdata.target) hdata.target=[];    // Creating a collection of WDO in hdata
    hdata.target.push(this);

  }
}

Wdo.prototype.initForm=function(){
  with(this){
    var c=['<input type=hidden name=_'+id+'._do   id=_'+id+'._do value="">'
     +'<input type=hidden name=_'+id+'._position id=_'+id+'._position value="">'
     +'<input type=hidden name=_'+id+'._object   id=_'+id+'._object   value="">'
     +'<input type=hidden name=_'+id+'._first    id=_'+id+'._first    value="">'
     +'<input type=hidden name=_'+id+'._last     id=_'+id+'._last     value="">'
     +'<input type=hidden name=_'+id+'._filter   id=_'+id+'._filter   value="">'
     +'<input type=hidden name=_'+id+'._find     id=_'+id+'._find     value="">'
     +'<input type=hidden name=_'+id+'._sorting  id=_'+id+'._sorting  value="">'];
    for(var i=0;i<hdata.fieldn;i++)
      c.push('\n<input type=hidden num='+i+' name=_'+id+'.'+hdata.fieldname[i]+' id=_'+id+'.'+hdata.fieldname[i]+' value="">');
    elem.innerHTML=c.join('');
  }
}

Wdo.prototype.dynlookup=function(){
  with(this){
      hdata.define(
        {fieldname:'rowident|_key|'+window.lookup.lookupcols
        ,fieldlabel:'rowident|_key|'+window.lookup.lookuplabels
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
 
Wdo.prototype.fieldRegister=function(){
  with(this){
    for(var view in viewer){
      for(var i=0;i<viewer[view].length;i++){
        var e=viewer[view][i];
        // in case of name not present, i.e rectangle - ignore
        if(!e.name) continue;
        var name=e.name.split('.');
        if(name[0]!=wdo){
		  var val=e.getAttribute('value');
		  if(val) e.setAttribute('initval',val);
          continue;
        } 
        if(e.tagName=='SELECT' && e.getAttribute('comboparent')) fixComboParent(e);
        if(e.type=='radio'){
          if(!inputField[name[1]]) inputField[name[1]]=[];
          inputField[name[1]].push(e);
        } else inputField[name[1]]=e;  //set reference 
      }
    }
  }
}


// Initializes screen objects for new data
Wdo.prototype.initdata=function(){
  with(this){
    this.row=0;
    if(browse) browse.load();  // load browse data
    if(!hdata.data.length) displayFields();  // Empty viewer
  }
}


// Perform a refresh if WDO comes into display
Wdo.prototype.refresh=function(){
  with(this){
    lognote('******* '+id+' ********');
    this.wdo=wdoinst;
    hdata.wdo=wdo;
    if(hdata.mustinitdata) hdata.initdata();
    app.document.form['_'+id+'._object'].value=hdata.objectname;
    hdata.positionok=true;
    this.cur=hdata.data[row-1];
    if(!window.action('wbo.changes')) displayFields();
    hdata.refreshTools();
  }
}

Wdo.prototype.refreshTools=function(){
  with(this){
    if(!app.frameObject.active) return;
    main.app=this.app;
    var tools=app.tools[wdo];
    if(mainapp.dyntree) mainapp.dyntree.refreshTools(hdata.status);
    
    // Setting status
    for(var panel in tools){
      if(!tools[panel] || (tools[panel].page && !visible)) continue; // multiple target toolbar issue
      if(panel=='0' && wdo!=app.firstwdo) continue;   // Only for firstwdo on page 0
      for(var e in status){
        if(hdata.status[e]==status[e] && !tools[panel].page ) continue; // Only changed status
        var elem=tools[panel][e];
        status[e]=hdata.status[e];
        if(e=='comments' && tools[panel].comments !=null){
          tools[panel].comments.innerHTML='<img src="'+tools[panel].comments.getAttribute('img').replace(/ment\.gif/,status[e]?'tick.gif':'ment.gif')+'">';
          continue;
        }
        if(elem) elem.className=status[e]?'enable':'disable';
        if(e=='filter' && this.filterOn!=hdata.filterOn && tools[panel].filter != null && tools[panel].filter != 'undefined'){
          this.filterOn=hdata.filterOn;
          tools[panel].filter.innerHTML='<img src="'+tools[panel].filter.getAttribute('img').replace(/.\.gif/,this.filterOn?'c.gif':'u.gif')+'">';
        }
      }
    }
    // Setting viewer mode
    var newUpd=hdata.lUpd && hdata.data.length>0;
    if(lUpd!=newUpd){
      lognote('  setting viewer mode')
      lUpd=newUpd;
      viewerMode();
      if(browse) browse.pick(row);                //  Selecting row in browse widgets
      hdata.custom('view',lUpd?(hdata.lMod?'modify':'update'):'view');
    }
  }
}

Wdo.prototype.refreshRow=function(){
  with(this){
    main.app=this.app;
    if(!app.frameObject.active) return true;    // Only active frames
    if(this.row && this.row==hdata.row && (!cur || cur==hdata.data[hdata.row-1])) return; // already displayed
    if(app.uplink==hdata && !selflink && hdata.objectname)
      app.document.form.lookup.value=app.frameObject.src+'.'+hdata.sbo+hdata.wdo+'.'+hdata.cur[0];
    displayFields();
  }
}

Wdo.prototype.displayFields=function(){
  with(this){
    this.row=hdata.row;
    this.cur=(hdata.data.length?hdata.data[row-1]:'|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
    if(browse) browse.pick(); //Selecting the new row for browse widgets
    for(var i in inputField){
      var e=inputField[i];
      if(e.length){
        appcontrol.markField(e,'');                  // UNMARK radio sets
      } else {
        var a=e.className.split(' ');
        if(a.length>2) e.className=(a[0]+' '+a[2]);  //UNMARK faster...
      }    
      appcontrol.setField(e,hdata.cur[hdata.index[i]]);  //SET value
    }
    hdata.custom('view',lUpd?(hdata.lMod?'modify':'update'):'view');  // Custom display logic
  }
}

Wdo.prototype.viewerMode=function(){
  with(this){
    var lOn, e;
    for(var i in inputField){
      e=inputField[i];
      if(!e.nodeName){ // radio sets
        for(var j=0;j<e.length;j++)
          e[j].disabled=((lUpd && e[j].getAttribute('disable')!='true')?null:true)
        continue;
      }      
      lOn=lUpd && e.getAttribute('disable')!='true';
      if(e.nodeName=='SELECT'||e.nodeName=='BUTTON'||e.type=='checkbox') e.disabled=(lOn?null:true);
      if(e.nodeName=='TEXTAREA'||e.type=='text') e.readOnly=(lOn?null:true);
      e.tabIndex=(lOn && e.getAttribute('tab'))?e.getAttribute('tab'):-1;
      e.className=e.className.split(' ')[0]+(lOn?' enable':' disable');
      if(e.type=='text' && e.getAttribute('util')) e.nextSibling.className=lOn?'enable':'disable';
    }
  }
}

Wdo.prototype.initFocus=function(){    // Initialize focus
  var el=null;
  for(var name in this.viewer){
    var view=this.viewer[name];
    for(var i=0;i<view.length;i++){
      var e=view[i];
      if(e.tabIndex>0 && (!el || e.tabIndex<el.tabIndex)) el=e;
    }
  }
  if(el && !el.disabled && el.style.visibility!='hidden' && el.nodeName=='INPUT') 
  try{ el.focus(); } catch(e){}
  if(this.browse && this.browse.hcur) this.browse.initFocus();    // Browse focus
}



/*****************************************************************/
/***   Run-time and handling                                  ****/
/*****************************************************************/

Wdo.prototype.action=function(c,prm){
  with(this){
    if(remote==false) return false;  // not initialized remote SDO
//    window.status='event:'+c;
    c=c.split('.');
    switch(c[c.length - 1]){
      case 'handle':
        return inputField[c[0]];
      case 'refresh':
        return refresh();
      case 'copy2':
        window.later(wdo+'.copyrec|'+hdata.data[hdata.row-1]);
        return action('target');
      case 'view2': case 'update2': case 'add2':
        later(wdo+'.'+hdata.row+'.pick');  // Later commands are needed in case of redefinition of WDO due to lookups
        later(wdo+'.'+c[0].replace('2',''));
      case 'target':
        if(hdata.update && hdata.update.split('.').length==2){
          this.mustinitdata=true;
          app.uplink=hdata;
          mainapp.uplink=hdata;  // For pass-thru from a DynFrame 
          action('setpassthru');
          return window.action(hdata.update);
        }
        window.runlater();
        return action('update');
      case 'setpassthru':
        appcontrol.cLookup=app.frameObject.src+'.'+hdata.sbo+hdata.wdo+'.'+hdata.cur[0];
        return;
      case 'comborefresh':
        var name=inputField[c[0]].getAttribute('comboparent');	
        var val=appcontrol.getField(inputField[name.split('.')[1]]);
        app.document.form['lookupparent'].value=val;
        window.action('server.'+wdo+'.'+c[0]+'.combodata');
        return;
      case 'combolookup':
        var name=app.document.getElementById(wdo+"."+c[0]).getAttribute('combochild');	
        var val=hdata.cur[hdata.index[c[0].substring(1)]];
		// Make sure to get updated data if not initial request
        if(window.lookup && window.lookup.lookupdata)
          val= window.lookup.lookupdata[0].split(window.lookup.lookupdlm)[1];
        app.document.form['lookupparent'].value=val;
        window.action('server.'+name+'.combodata');
        return;
      case 'mark':
        return appcontrol.markField(inputField[c[0]],'error');
      case 'unmark':
        return appcontrol.markField(inputField[c[0]],'');
      case 'get':
      case 'getinput':
        return appcontrol.getField(inputField[c[0]],hdata.cur[hdata.index[c[0]]]);
      case 'getvalue':
        return window.strip(appcontrol.getField(inputField[c[0]],hdata.cur[hdata.index[c[0]]]),hdata.fieldvalidate[hdata.index[c[0]]]);
      case 'setvalue':
        prm=window.format(prm,hdata.fieldvalidate[hdata.index[c[0]]]);
      case 'set':
        if(inputField[c[0]]) appcontrol.setField(inputField[c[0]],prm);
      case 'setdata':
        action('modify');
        hdata.cur[hdata.index[c[0]]]=prm;
        hdata.data[hdata.row-1]=hdata.cur.join(hdata.dlm);
        return prm;
      case 'setinput':
        action('modify');
        return appcontrol.setField(inputField[c[0]],prm);
      case 'options':
        if(window.lookup && window.lookup.lookupdata)
          window.lookup.lookupdata=null;
        window.action('tool.'+wdo+'.'+c[0]+'.options|'+prm);
        return appcontrol.setField(inputField[c[0]],hdata.cur[hdata.index[c[0]]]);        
      case 'toggle':
        if(!hdata.status.filter) return;
        var b=filtermode;    //  Toggles filter for browse widgets
        c[c.length - 1]=b?'disable':'enable';
      case 'focus':   case 'options':
      case 'hide':    case 'show':
      case 'enable':  case 'disable':
      case 'lock':    case 'unlock':
        if(c[0]!='filter') return window.action('tool.'+wdo+'.'+c.join('.')+'|'+prm);

        // if in update mode or navigation is disabled then disable filtering too
        if(!hdata.lNav || hdata.lMod) return;

        var b=(c[c.length-1]=='enable');  //  Toggles filter for browse widgets
        this.filtermode=b;
        var inline=false;
        window.returnfield=hdata;
        if(browse && browse.setFilter()) inline=true;
        if(!inline) window.action('util.../dhtml/ryfilter.htm'); // Execute filter dialog unless 'inline' browser present
        return hdata.refreshTools();
      case 'filter':
        setFilter();
        action('commitdata');
        return window.actions(['server.'+hdata.sbo+hdata.id+'.filter','wbo.submit']);
      case 'lookup':
        if(c.length==1){      // FIND
          window.returnfield=hdata;
          action('commitdata');
		  return window.action('util.../dhtml/ryfind.htm');
        }
        var val=window.returnfield.value;
        var att=window.returnfield.getAttribute('select');
        if((att && val==att) ||                 // If something wasn't entered then get all 
           (hdata.cur[hdata.index[c[0]]]==val)) // If same as initial value then get all
          val='';
        app.document.form.lookup.value=val;
        var cParent=window.returnfield.getAttribute('lookupParent');
        if(cParent>'') {
          // Find the last element with the . as the delimiter
          cParent = cParent.split('.').pop();
          cParent = action(cParent+'.get');
        }
        app.document.form['lookupparent'].value=cParent;
		if(window.returnfield.getAttribute('combochild')) later(wdo+'.'+c[0]+'.combolookup');
        lookup.lookupval=val;
        window.action('server.lookup.launch.'+window.returnfield.getAttribute('lookup'));

        return window.action('wbo.submit');
      case 'export':
	return runWindow("ryexcel");
      case 'preview':
	return runWindow("rypreview");
      case 'getloburl':
        return getloburl(prm);
      case 'launchlob':
        return window.open(getloburl(prm),'lob','toolbar=1,menubar=1,status=1,resizable=1',false);
      case 'comments':
        app.uplink=hdata;
        app.comtarget=hdata;
        return showComments();
      default:
        if(!this.hdata) return;
        return hdata.action(c.join('.'),prm);
    }
  }
}

Wdo.prototype.showComments=function(){
  with(this){
    var ob=(app.location.pathname).split('/');
    var sbo = (hdata.sbo !=null)?hdata.sbo.replace(".", "+"):"";
    var link=(ob[ob.length-1].split('.')[0]) +'.'+ sbo +this.wdo+'.'+
             appcontrol.sessionid+'.'+hdata.cur[hdata.index['rowident']];
    document.cookie='sessionid='+appcontrol.sessionid;
    return apph.action('dlg.rycomments.'+link);
  }
}

Wdo.prototype.runWindow=function(name){
  with(this){
    // HTM24|Number of data rows
    var num=window.action('info.prompt|HTM24||500'); //ok
    if(!num) return;
    var ob=(app.location.pathname).split('/');
    var link=(ob[ob.length-1].split('.')[0])+'.'+this.wdo+'.'+appcontrol.sessionid+'.'+num;
    document.cookie='sessionid='+appcontrol.sessionid;
    return window.open(name+'.'+link+'.icf',name+'sheet','width=720,height=240,toolbar=1,location=0,menubar=1,status=1,resizable=1',false);
  }
}

Wdo.prototype.getloburl=function(prm){
  with(this){
    var cContentType = prm.split('|').pop();
    var column = prm.split('|')[0];
    if (cContentType == null || column == null) return '';
    cContentType = cContentType.replace("\/", "+");
    column = column.replace(".", "+");
    var ob=(app.location.pathname).split('/');
    var lon = (ob[ob.length-1].split('.')[0]);
    var sbo = (hdata.sbo !=null)?hdata.sbo.replace(".", "+"):"";
    var sdo = this.wdo;
    if (sdo == 'master') {
     sdo = app._master.id;
     lon = hdata.objectname; 
    }
    var link= lon +'.'+ sbo +sdo+'.'+ column +'.'+ appcontrol.sessionid+'.'+
      hdata.cur[hdata.index['rowident']]+'.'+cContentType;
    document.cookie='sessionid='+appcontrol.sessionid;
    return 'rygetlob.'+ link + '.icf';
  }
}

Wdo.prototype.setFilter=function(){
  with(this){
    var filt='',c='';
    for(var i=1;i<hdata.fieldn;i++){
      c=hdata.filtfrom[i];
      if(c>'') filt+='|'+hdata.fieldname[i]+' > '+c;
      c=hdata.filtto[i];
      if(c>'') filt+='|'+hdata.fieldname[i]+' < '+c;
    }
    app.document.form['_'+id+'._sorting'].value=hdata.colSort;
    app.document.form['_'+id+'._filter'].value=filt;
    hdata.filterOn=(hdata.filtfrom.join('')+hdata.filtto.join('')>'');
    this.filtermode=false;
  }
}

Wdo.prototype.recData=function(umode){
  with(this){
    if(!app.frameObject.active) return;
    for(var e in inputField){                        // Collecting values from input fields
      var j=hdata.index[e];
      hdata.cur[j]=appcontrol.getField(inputField[e],hdata.cur[j]);
    }
    if(browse) browse.recData(hdata.cur);            //  Getting values from updateble browse widgets
  }
}


/*****************************************************************/
/***  Function proxies to the data object     ********************/
/*****************************************************************/


Wdo.prototype.load=function(d,cdlm,pos){
  this.hdata.load(d,cdlm,pos);
}

Wdo.prototype.define=function(a){
  var row=this.hdata.row;
  this.hdata.define(a);
  this.initForm();
  this.hdata.row=row;
}

Wdo.prototype.saveok=function(d){
  this.hdata.saveok(d);
}

Wdo.prototype.saveconflict=function(d){
  this.hdata.saveconflict(d);
}


