//  File:         rydata.js
//  Description:  Implements DataObject


Data.prototype.data;
Data.prototype.olddata;

Data.prototype.datafirst;
Data.prototype.datalast;
Data.prototype.savedata; // Uncommitted records number within batch
Data.prototype.saverow;  // Uncommitted records data
Data.prototype.fieldn;
Data.prototype.fieldname;
Data.prototype.fieldvalidate;
Data.prototype.fieldformat;
Data.prototype.fieldfilter;
Data.prototype.fieldsorting;
Data.prototype.fieldenabled;
Data.prototype.uncommitted=false;
Data.prototype.row=1;            // Current row
Data.prototype.batch=0;          // Current batch position
Data.prototype.displayrow=0;     // Currently displayed row
Data.prototype.dlm='|';
Data.prototype.colSort='';       // Sorting sequence

Data.prototype.filtfrom;         // Storage of filter values
Data.prototype.filtto;
Data.prototype.sortdir;          // and sorting options
Data.prototype.sortnum;

Data.prototype.notfirst;           // Navigation variables
Data.prototype.notlast;
Data.prototype.navnext;
Data.prototype.navprev;
Data.prototype.lNav=true;
Data.prototype.lAdd=false;
Data.prototype.lAll=true;
Data.prototype.lDat=false;
Data.prototype.positionok;  // indicates whether parent-child positioning should happen 

Data.prototype.parentwdo=null;
Data.prototype.cur;                // Input row
Data.prototype.wdo;                // Used for navigation and screen stuff
Data.prototype.wdoreal;            // Used for sending to server
Data.prototype.lastrowid;

function Data(){
}

Data.prototype.load=function(d,cdlm,pos){
  this.mustinitdata=true;
  if(this.remote>'') return this.hdata.load(d,cdlm,pos);
  this.dlm=cdlm;
  this.olddata=[].concat(d);
  this.data=[].concat(d);
  this.lastrowid = "";
  if(this.uplink) app.uplink=this.wdo;
  this.batch=pos;
  
//if(window.app!=window) window.action('wdo.handle').mustinitdata=true;  // Also for the current window in case of FIND
  this.datamerge();
  this.lDat=this.data.length>0;
  this.lAll=this.batch==0;

//  if(this.row==0) this.row=1;
  this.row=1;
  if(this.data.length==0) this.row=0;
  this.displayrow=0;
  later(this.wdo+'.refresh');
  app.wbo.saveok();
}

Data.prototype.lookup=function(fld){
  for(var i=0;i<this.fieldn;i++) if(this.hdata.fieldname[i]==fld) return i;
}

Data.prototype.define=function(a){
  for(var e in a){
    var c=a[e].split('|');
    if(e=='fieldname') this.fieldn=c.length;	
    if(c.length<this.fieldn) for(var i=c.length;i<this.fieldn;i++) c[i]=c[i-1];
    try{this[e]=c;} catch(err){window.fError(err,'wdo.define:'+e+'/c='+c)} 
  }
}

Data.prototype.tool=function(c,l){
  window.action('tool.'+this.wdo+'.'+c+'.'+(l?'enable':'disable'));
}

Data.prototype.refreshMode=function(){  // Refresh the record manipulation tools
  with(this)
  {
    uncommitted=hdata.testCommit();
    var lMod=updatemode=='modify';    // Data or child data has been modified

    // previously we were checking to see whether the parent is in add mode.
    // we acutally need to check weather any of the ancestors are in add mode.
    var ancesterAdd = false;
    var tempParentWdo = parentwdo;
    while (tempParentWdo)
    {
      ancesterAdd = (ancesterAdd || tempParentWdo.lAdd);
      tempParentWdo = tempParentWdo.parentwdo;
    }

    tool('add',   lNav && !lMod && (!ancesterAdd));
    tool('copy',  lNav && lDat && !lMod);
    tool('delete',lNav && lDat && !lMod);
    tool('save',  lMod);
    tool('cancel',lAdd);
    tool('reset', lMod);
    tool('view',  lDat && updatemode=='update');
    tool('update',lDat && updatemode=='view');
    tool('commit',uncommitted);
    tool('undo',  uncommitted);
    hdata.refreshNav();
  } 
}   


Data.prototype.refreshNav=function(){  // Set the navigation buttons
  with(this){
    var lOK=lNav && updatemode!='modify';    // Data or child data has been modified
    this.notfirst=row > this.datafirst && lDat && lOK;
    this.notlast =row < this.datalast  && lDat && lOK;
    this.navnext =batch!=-1 && !lAll && lOK;
    this.navprev =batch!=1  && !lAll && lOK;
    tool('prev' ,notfirst||navprev);
    tool('next' ,notlast ||navnext);
    tool('first',notfirst||navprev);
    tool('last' ,notlast ||navnext);
  }
}

Data.prototype.testCommit=function(){
  with(this){  
    if(commit=='true') return false;
    if(hdata.data.length!=hdata.olddata.length||hdata.savedata.length>0) return true;
    for(var j=0;j<hdata.data.length;j++)
      if(hdata.data[j]!=hdata.olddata[j]) return true;
    return false;
  }
}  
   
Data.prototype.findold=function(iNew){   // Find the data corresponding to new record
  with(this){  
    var j=0;
    for(var i=0;i<hdata.olddata.length;i++){
      while(hdata.data[j].split(dlm)[0]=='add') j++  // Adjust added records in new array
      if(hdata.data[j].split(dlm)[0]!=hdata.olddata[i].split(dlm)[0]) continue;  // Adjust for found not deleted
      if(iNew==j++) return i;
    }
  }
}

// Pack data for submit
Data.prototype.dataSave=function(){
  with(this){
    var old;
    var iOld=0;
    var iCur=0;
    for(var i=0;i<savedata.length;i++) if(savedata>0) savedata[i]=-1;  // Set out of batch records
    
    // Loop through existing records, if new skips then delete, otherwise compare them
    while(iOld<hdata.olddata.length || iCur<hdata.data.length){
      if(iOld<hdata.olddata.length) old=hdata.olddata[iOld++].split(dlm);
      else old=null;
      // Added records
      while(iCur<hdata.data.length && hdata.data[iCur].split(dlm)[0]=='add'){
        var r=hdata.data[iCur].split(dlm);
        for(var i=0;i<fieldn;i++)
          r[i]=window.strip(r[i],hdata.fieldvalidate[i]);
        saverow[savedata.length]=r.join(dlm);
        savedata[savedata.length]=iCur++;
      }
    
      // Updated records
      if(iCur<hdata.data.length){
        if(old[0]==hdata.data[iCur].split(dlm)[0]){
          if(hdata.olddata[iOld-1]!=hdata.data[iCur]){  // See if updated
            var saveval=hdata.olddata[iOld-1];
            var r1=hdata.olddata[iOld-1].split(dlm);
            var r2=hdata.data[iOld-1].split(dlm);
            for(var i=0;i<fieldn;i++)
              saveval+=dlm+(r1[i]==r2[i]?r1[i]:window.strip(r2[i],hdata.fieldvalidate[i]));
            saverow[savedata.length]=saveval;
            savedata[savedata.length]=iCur;
          }
          iCur++;
          continue;
        }
      }
      if(old){
        saverow[savedata.length]=hdata.olddata[iOld-1];
        savedata[savedata.length]=-2;
      }
    }
  }
}

Data.prototype.datasubmit=function(){
  with(this){
    for(var i=0;i<savedata.length;i++){
      var cur=saverow[i].split(dlm);
      app.document.form[hdata.id+'._do'].value+=(savedata[i]==-2?'|delete':(cur.length>fieldn?'|update':'|add'));
      for(var j=0;j<fieldn;j++){
        var e=app.document.form[hdata.id+'.'+hdata.fieldname[j]];
        if(!e) continue;
        e.value+=dlm+cur[j];
        if(cur.length>fieldn) e.value+=dlm+cur[j+fieldn];
      }
    }
  }
}

Data.prototype.datamerge=function(){  // merge new values with uncommitted changes
  with(this){
    for(var i=savedata.length-1;i>-1;i--){
      var s=saverow[i].split(dlm);
      if(s[0]=='add') continue;
      for(var j=hdata.data.length-1;j>-1;j--) if(s[0]==hdata.data[j].split(dlm)[0]){
        if(savedata[i]>-2){
          hdata.olddata[j]=s.slice(0,fieldn).join(dlm);
          hdata.data[j]=s.slice(fieldn).join(dlm);
        } else {
          hdata.olddata[j]=saverow[i];
          hdata.data[j]=(hdata.data.slice(0,j)).concat(hdata.data.slice(j+1));
        }
        savedata=(savedata.slice(0,i)).concat(savedata.slice(i+1));
        saverow=(saverow.slice(0,i)).concat(saverow.slice(i+1));
      }
    }
  }
}


Data.prototype.addRec=function(dt,c){
  with(this){
    dt[0]='add';
    if(this.parent>'') dt[childfield]=parentwdo.hdata.data[parentwdo.hdata.row-1].split(dlm)[parentfield];
    if (hdata.lastrowid == '' && hdata.data.length > 0)
      hdata.lastrowid = hdata.data[hdata.data.length-1].split(dlm)[0];
    if(c=='add'){        
      hdata.data[hdata.data.length]=dt.join(dlm);
      hdata.row=hdata.data.length;        
    } else {
      hdata.data=(hdata.data.slice(0,displayrow)).concat(hdata.data.slice(displayrow-1));
      hdata.data[displayrow]=dt.join(dlm);
      hdata.row=displayrow+1;
    }
    mustinitdata=true;
    refresh();
    pick(0);
    custom(c);
    setMode('update');
    return action('modify');
  }
}

Data.prototype.saveok=function(d){
  app.wbo.committing=false;
  with(this){
    //if(d.length!=savedata.length) return alert('Data synchronization warning:'+savedata+'=>'+d);
    if(d.length!=savedata.length) return alert(window.action('info.get|HTM19||'+d)); //ok
    for(var i=0;i<savedata.length;i++)
      if(savedata[i]>-1) hdata.data[savedata[i]]=d[i];
    savedata=[];
    saverow=[];
    uncommitted=false;
    hdata.olddata=([]).concat(hdata.data);
    initdata();
    setMode(displaymode=='update'?'update':'view');

    // reset the data states that apply to the add action
    hdata.lAdd=false;
    this.lDat=(hdata.data.length>0);

    hdata.refreshMode();
    pick(0);
    app.wbo.saveok();
  }
}

Data.prototype.saveconflict=function(d){
  with(this){
    app.wbo.committing=false;
    datamerge();
    var icur=displayrow-1;
    var iold=findold(icur);
    var old=hdata.olddata[iold].split(dlm);  // Getting the old fields
    var cur=(hdata.data[icur]).split(dlm);  // Getting the input fields
    var chg=d[0].split(dlm)
    hdata.olddata[iold]=chg.join(dlm);
    hdata.data[icur]=chg.join(dlm);
    setMode(displaymode=='update'?'update':'view');
    
    if(!window.action('info.confirm|HTM11')){ //ok
      for(var i=1;i<fieldn;i++){            // Merge results
        if(cur[i]==chg[i]) continue;        // Only bother about conflicts
        action(hdata.fieldname[i]+'.mark')
        if(old[i]==cur[i]) cur[i]=chg[i];   // not your change
      }
      action('modify');
      for (var i=0; i < fieldn; i++)
        setViewer(hdata.fieldname[i],cur[i],true);  // Setting input fields only
      return true;
    } 
    pick(0);
    return action('modify');
  }
}

Data.prototype.recValidate=function(){           // Validate record 
  var lErrors=false;
  var cError;
  with(this){
    for(var j=0;j<fieldn;j++){
      if(hdata.fieldvalidate[j]==''||hdata.fieldenabled[j]!='y') continue;
      if(cur[j]==hdata.data[displayrow-1].split(dlm)[j]) continue;   // Only changed fields
      if(cError=fieldValidate(cur[j],j)){
      	lErrors=true;
      	window.action('info.field|'+cError);
      }
    }
    return !lErrors;
  }
}

Data.prototype.fieldValidate=function(val,j){     // Validate field 
  with(this){
    var test=hdata.fieldvalidate[j];
    var cErrmsg='||'+this.wdo+'.'+hdata.fieldname[j]+'|'+val;
    val=window.strip(val,test);
    switch(test){
      case 'dec':
      case 'int':
        if(isNaN(val)) return 'HTM2'+cErrmsg+'|'+appcontrol.numformat; //ok
        else if(test[0]=='int' && Math.round(val)!=val) return 'HTM1'+cErrmsg; //ok
        return;
      case 'date':
        if(val.replace(' ','')=='') break;   // No input is OK
        if(val=='error') return 'HTM3'+cErrmsg+'|'+appcontrol.dateformat; //ok
        var dt=new Date(val);
        val=val.split('/');
        if((val[0]-1)!=dt.getMonth() || val[2]!=(val[2].length==4?dt.getFullYear():dt.getYear()))
          return 'HTM3'+cErrmsg+'|'+appcontrol.dateformat; //ok
        return;
      default:
        if(app.validate) return app.validate(val,test);
        //else alert(test[0]+' test for WBO not implemented yet!->'+test);
        else alert(window.action('info.get|HTM20||'+test[0]+'|WBO|'+test)); //ok
    }
  }
}

Data.prototype.batchNav=function(nav){
	if(nav=='next'||nav=='prev')
	  window.later(this.wdo+'.rowident.repos|'+nav+'|'+this.action('rowident.get'));
  this.positionok=false;
  app.wbo.afterSave(this.wdo+'.'+(nav=='next'||nav=='first'?'firstcurrent':'lastcurrent'));
  this.action(nav+'batch');
}

Data.prototype.dataAction=function(c,prm){
  with(this){
    window.status='event:'+c;
    switch(c[c.length - 1]){
      case 'firstbatch':
      case 'prevbatch':
      case 'nextbatch':
      case 'lastbatch':
        if(!action('wbo.nochange')){
          window.action('info.yesnocancel|HTM5');
          switch(window.returnValue) {
            case 'yes':
              app.wbo.afterSave(this.wdo+'.' + c);
              return window.action('wbo.commit');
            case 'no':
              window.action('wbo.undo');
              break;
            default:
              return true;
          }
        }
        app.document.form[id+'._object'].value=objectname;
        return window.actions([wdo+'.packdata','server.'+hdata.sbo+hdata.wdoreal+'.'+c[0].replace('batch',''),'wbo.submit'])
      case 'first':
        if(hdata.navprev) return batchNav(c[0]);
        return pick(hdata.datafirst);
      case 'next':
        if(!hdata.notlast && hdata.navnext) return batchNav(c[0]);
        return pick(displayrow+1);
      case 'prev':
        if(!hdata.notfirst && hdata.navprev) return batchNav(c[0]);
        return pick(displayrow-1);
      case 'last':
        if(hdata.navnext) return batchNav(c[0]);
        return pick(hdata.datalast);
      case 'firstcurrent':
        return pick(hdata.datafirst);
      case 'lastcurrent':
        return pick(hdata.datalast);

      case 'delete2':
      case 'delete':
        // HTM4|Do you want to delete this record?
        return window.action('info.confirm|HTM4||'+wdo +'.deleterec'); //ok
      case 'deleterec':
        if(!custom('delete')) return false;
        hdata.data.splice(displayrow-1,1);
        if(hdata.commit=='true') return action('commit');
        initdata();
        pick(0);
        hdata.refreshMode();
        return true;
      case 'copy':
        return addRec(hdata.data[hdata.row - 1].split(dlm),'copy');
      case 'add':
        return addRec(hdata.initvals,'add');
      case 'undoupdate':
        datamerge();
        if(hdata.data[displayrow-1].split(dlm)[0]!='add')
          hdata.data[displayrow-1]=hdata.olddata[displayrow-1];
        savedata=[];  
        saverow=[];  
        action('modify');
        return;
      case 'undo':
        savedata=[];
        saverow=[];
        hdata.uncommitted=false;
        hdata.data=([]).concat(hdata.olddata);
        initdata();
        refresh();
        break;

      case 'search':
        var fld=lookup(c[0]);
        for(var i=0;i<hdata.data.length;i++)
          if(hdata.data[i].split(dlm)[fld]==prm){
            pick(i+1);
            return true;
          }
        return false;
      case 'repos':
        prm=prm.split('|');
        if(action(c[0]+'.search',prm[1])) return action(prm[0]);
        return true;

      case 'packdata':
        app.document.form[id+'._first'].value=hdata.data[0].split(dlm)[0];
        if (hdata.lastrowid > '')
          app.document.form[id+'._last'].value=hdata.lastrowid;
        else 
          app.document.form[id+'._last'].value=hdata.data[hdata.data.length-1].split(dlm)[0];
        if(app.wbo.name=='find') return hdata.action('commitdata');
        if(hdata.updatemode!='view') action('save');
        return dataSave();
      case 'commitdata':
        if(app.wbo.name=='find') return hdata.action('commitdata');
        if(hdata.updatemode=='modify') action('save');
        dataSave();
        if(savedata.length==0) return false;
        datasubmit();
        app.document.form['do'].value+='|'+hdata.sbo+hdata.wdoreal+'.save';
        return true;
      case 'commit':
        app.wbo.committing=true;
        action('commitdata');
        return window.action('wbo.submit');

      default:
        //alert(c+' for WDO '+wdo+' not implemented yet!')
        alert(window.action('info.get|HTM20||'+c+'|WDO')); //ok
    }
  }
}

