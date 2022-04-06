/*
  File:         rydata.js
  Description:  Implements DataObject, will broker WDO screen logic

  Objectives
    1. Initialization and handling of data
    2. Data input and saving
    3. Run-time data navigation and handling

  Interfaces:
    targets     - Array of controlled WDOs

  There can be multiple Wdo for a shared (hdata) Data object when "remote" Wdo.

  This object contains current "correct" values for a data object
    status      - Collection of toolbar button status
    row,cur     - current displayed data
    lMod,lUpd   - current display mode

*/

Data.prototype.uncommitted=false;
Data.prototype.dlm='|';
Data.prototype.colSort='';       // Sorting sequence
Data.prototype.filtfrom='';      // Storage of filter values
Data.prototype.filtto='';

Data.prototype.row=1;            // Current row
Data.prototype.batch=0;          // Current batch position
Data.prototype.lAdd=false;       // Add mode
Data.prototype.lUpd=false;       // Update/view
Data.prototype.lOK=true;         // Can Navigate
Data.prototype.lMod=false;       // Modify
Data.prototype.lModOld=false;    // Old modify
Data.prototype.lNav=true;        // Navigation OK
Data.prototype.lNavOld=true;     // Navigation OK
Data.prototype.positionok=true;  // whether parent-child positioning should happen
Data.prototype.addfrom=0;        // If cancel from add
Data.prototype.activecomments=false;  // Active comments exist or not

Data.prototype.childRow=null;
Data.prototype.childDS=null;
Data.prototype.parentDS=null;
Data.prototype.parentfield=null;
Data.prototype.objectname='';     // Name of the container where the pass-thru came from

function Data(){}

/*****************************************************************/
/***  Initialization *********************************************/
/****************************************************************
   1. define, configure dataset definitions (metadata)
   2. initParentChild, configure data object relations
   3. load, (data)
   4. initdata/clearchild, configure linking and initialize the dataset

   5. pick, sets and controls the datarow in focus
   6. refreshTools, sets the statuses for data related tools
*/

Data.prototype.init=function(e){
  this.commit=e.getAttribute('commit');
  this.update=e.getAttribute('update');
  this.lUpd=(this.update=='on' || this.update=='add');
  this.id=(e.id);
  this.sbo=e.getAttribute('sbo');
  this.sbo=(this.sbo>''?this.sbo+'.':'');
  this.hsbo=null;  // SBO handle
  this.parent=e.getAttribute('parent');
  this.link=e.getAttribute('link');
  this.childDS=[];
  this.savedata=[];
  this.saverow=[];
}

Data.prototype.define=function(a){
  for(var e in a){
    var c=a[e].split('|');
    if(e=='fieldname') this.fieldn=c.length;
    if(c.length<this.fieldn) for(var i=c.length;i<this.fieldn;i++) c[i]=c[i-1];
    try{this[e]=c;} catch(err){window.fError(err,'wdo.define:'+e+'/c='+c)}
  }
  this.index=new Object();  // Create cross reference object
  for(var i=0;i<this.fieldn;i++) this.index[this.fieldname[i]]=i;
  this.filterOn=(this.filtfrom.join('')+this.filtto.join('')>'');
}

Data.prototype.initParentChild=function(e){
  with(this){
    if(parent>'' && !parentDS){
      this.parentDS=app['_'+parent].hdata;
      if(!parentDS) this.parent='';
    }
    if(parent>'' && !parentfield){
      // Register parent-child data ties
      var found=false;
      this.parentfield=[];
      this.childfield=[];
      for(var i=0;i<parentDS.childDS.length;i++) if(parentDS.childDS[i]==this) found=true;
      if(!found && parentDS!=this) parentDS.childDS.push(this);

      // Setting link fields for parent-child
      var c=link.split(',');
      for(var j=0;j<link.length;j+=2){
        for(var i=1;i<fieldn;i++) if(fieldname[i]==c[j]) this.childfield.push(i);
        for(var i=1;i<parentDS.fieldn;i++) if(parentDS.fieldname[i]==c[j+1]) this.parentfield.push(i);
      }
    }
  }
}


Data.prototype.load=function(d,cdlm,pos){
  lognote('  load:'+this.wdoreal);
  this.mustinitdata=true;
  this.dlm=cdlm;
  this.olddata=[].concat(d);
  this.data=[].concat(d);
  this.batch=pos;
  this.datamerge();
  this.row=(this.data.length?1:0);
  this.childRow=-2;  // Load = Set it to final position
  later(this.wdoreal+'.refresh');
  app.wbo.saveok();
}

Data.prototype.resetData=function(d,r){  // Used to load from Treenodes
  this.data=d;
  this.olddata=[].concat(d);
  this.row=0;
  this.batch=0;
  this.childRow=-2;  // Load = Set it to final position
  this.pick(r);
  this.refreshTools();
}

Data.prototype.initdata=function(){
  with(this){
    lognote('  initdata:'+wdoreal);
    this.cur=data.length? data[row-1].split(dlm) : '||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||'.split('|');
    mustinitdata=false;
    for(var i=0;i<target.length;i++) target[i].initdata();
    latercmd.unshift(wdoreal+'.'+row+'.pick'); // to beginning of array
  }
}

Data.prototype.testChildSync=function(){   // Return true if link in sync.
  with(this){
    for(var i=0;i<parentfield.length;i++)
      if(cur[childfield[i]]!=parentDS.cur[parentfield[i]]) return false;
    return true;
  }
}


Data.prototype.clearchild=function(){   // Recursively clear children.
  with(this){
    // don't clear children if current value is correct..
    if(parentDS.childRow && parentDS.row && testChildSync()) return false;
    if(data.length && !parentDS.childRow){
      load([],dlm,0);
      initdata();
      refreshTools();
    }
    for(var i=0;i<childDS.length;i++) childDS[i].clearchild();
  }
}


Data.prototype.pick=function(iNew){
  with(this){
    if(!data.length) return false;
    lognote('  pick:'+iNew);
    if(iNew>data.length) iNew=data.length;   // Adjusting if past last record

    if(iNew){
      this.cur=data[iNew-1].split(dlm);        //Setting current fields
      this.row=iNew;
      posChild();                              // Checking child data
    }
    for(var i=0;i<this.target.length;i++) this.target[i].refreshRow();  // positioning each Wdo
    refreshTools();
  }
}

Data.prototype.posChild=function(){
  with(this){
// childrow =
// row   when in sync
//  -2   in load situation (ignore)
//  -1   force new child data
//   0   add situation - just empty it

    if(childRow==-2) return;
    if(cur[0]=='add'){  // Copy or add must clear the childrecords
      if(childRow){
        childRow=0;
        this.lAdd=true; // Now make sure the child records don't get ADD enabled
        for(var i=0;i<childDS.length;i++) childDS[i].clearchild();
      }
      return;
    }
    if(childDS.length && childRow!=row){   // Test for child data
      this.childRow=0;
      for(var i=0;i<childDS.length;i++){
        var tgt=childDS[i].target;
        if(!row || childDS[i].testChildSync()) continue; // child data is not different
        for(var j=tgt.length-1;j>-1;j--){  // Reverse order to prefer the parent screens pass-thru WDO
          if(!tgt[j].app.frameObject.active) continue; // active
          if(!tgt[j].app.document.form['_'+wdoreal+'._position']) continue;  // has form fields (dynframes)
          this.childRow=row;
          window.app=tgt[j].app
        }
      }
      if(childRow!=row) return;
      var pDS=this;                        // Set position for All parents
      while(pDS && window.app.document.form['_'+pDS.wdoreal+'._position']){
        window.app.document.form['_'+pDS.wdoreal+'._position'].value=pDS.cur[0];
        window.app.document.form['_'+pDS.wdoreal+'._object'].value=pDS.objectname;
        pDS=pDS.parentDS;
      }
      window.action('server.'+sbo+wdoreal+'.position');  // fetch..
      window.action('wbo.submit');
      window.status='Fetching child data for '+wdoreal;
    }
  }
}

Data.prototype.refreshTools=function(){ // Set appropriate button statuses
  with(this){
    lognote('  tools:'+wdoreal);

    // Navigation needs to be locked for parent chain if in modify
    if(parentDS && ((lMod||lAdd)!=lModOld ||lNav!=lNavOld)){
      parentDS.lNav=!(lMod||lAdd)&&lNav;
      parentDS.refreshTools();
      lModOld=(lMod||lAdd);
      lNavOld=lNav;
    }

    // TableIO
    var lDat=data.length>0;
    var lNew =lNav && !lMod && !lAdd;        // Whether loose, add/copy/del ok!
	uncommitted=(!lAdd && !lMod && testCommit());
	var commitstatus=uncommitted;

    // get SBO commit status
    if(hsbo){
      if(uncommitted && !hsbo.uncommitted){
        hsbo.uncommitted=true;
        app.wbo.sboAction(sbo,'refresh');
      }
	  if(hsbo.uncommitted) commitstatus=true; 
	}
    // Check for uncommitted parents and parent Add mode
    var parentAdd=false;
    var pDS=this;
	while(pDS=pDS.parentDS)
	  if(pDS.lAdd || !pDS.data.length) parentAdd=true;

    // Navigation (Flags used in navigation logic)
    this.lOK=lNav && !lMod && !lAdd && lDat;    // No data or child data has been modified
    this.notfirst=lOK && row>1;                // more records down
    this.notlast =lOK && row<data.length;      // more records up
    this.navprev =lOK && batch && batch!=1;    // more batches down
    this.navnext =lOK && batch && batch!=-1;   // more batches up

    // comments 
    this.activecomments = (this.index['_hascomments']==null)? false : (this.cur[this.index['_hascomments']]=='yes');
   
    // Setting tool statuses
    this.status=
     {add    : lNew && !parentAdd
     ,copy   : lNew && lDat
     ,del    : lNew && lDat
     ,save   : lMod || lAdd
     ,cancel : lAdd
     ,reset  : lMod
     ,view   : lDat && lUpd && !lAdd && !lMod
     ,update : lDat && !lUpd
     ,commit : commitstatus
     ,undo   : commitstatus
     ,first  : notfirst||navprev
     ,prev   : notfirst||navprev
     ,next   : notlast ||navnext
     ,last   : notlast ||navnext
     ,filter : lNav && !lMod && !lAdd && (data.length>1 || filterOn)
     ,comments : this.activecomments
     ,find     : lOK && !parentAdd
     ,lookup   : lOK && !parentAdd
    };
    for(var i=0;i<target.length;i++) target[i].refreshTools();
  }
}


Data.prototype.testCommit=function(){
  with(this){
    if(commit=='true') return false;
    if(data.length!=olddata.length||savedata.length>0) return true;
    for(var j=0;j<data.length;j++)
      if(data[j]!=olddata[j]) return true;
    return false;
  }
}






/*****************************************************************/
/***  Data input and saving   ************************************/
/****************************************************************
   1. recinput, gather input values
   2. recValidate/fieldValidate, validate inputs

   3. datasave, assemble changed data into array of uncommitted data, important for commit-link
   4. datamerge, merge new loads of data with uncommitted changes

   5. datasubmit, put the changes into the FORM fields
   6. saveok/saveconflict, deal with response from save
*/

Data.prototype.recInput=function(){      // Assemble data input into cur;
  with(this){
    if(!lMod && !lAdd) return false;
    if(!lUpd || !data.length || !row) return false;
    this.cur=data[row-1].split(dlm);
    for(var i=0;i<target.length;i++) target[i].recData();
    return cur.join(dlm)!=data[row-1];  // return true if there is new data input
  }
}

Data.prototype.recValidate=function(){           // Validate record
  var lErrors=false;
  var cError;
  with(this){
    for(var j=0;j<fieldn;j++){
      if(fieldvalidate[j]==''||fieldenabled[j]!='y') continue;
      if(cur[j]==data[row-1].split(dlm)[j]) continue;   // Only changed fields
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
    var test=fieldvalidate[j];
    var cErrmsg='||'+this.wdo+'.'+fieldname[j]+'|'+val;
    val=window.strip(val,test);
    switch(test){
      case 'log':
        return;
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
        else alert(window.action('info.get|HTM20||'+test[0]+'|validate|'+test)); //ok
    }
  }
}

Data.prototype.recSave=function(){    // Save record operation
  with(this){
    if(recInput()||lAdd){
      if(custom('validate')==false) return false;
      if(!recValidate()) return false;
      data[row-1]=cur.join(dlm);
      custom('update');
      if(commit=='true'){
        if(!app.wbo.committing) action('commit');
        window.status='Saving changes for '+wdoreal;
        return true;
      } else {
        window.action(app.wbo.savechange);
        this.lAdd=false;
        this.lMod=false;
        app.wbo.savechange='';
        for(var i=0;i<target.length;i++) target[i].displayFields(); 
      }
    }
    if(update=='auto' || update=='view') lUpd=false;
    refreshTools();
  }
}

Data.prototype.dataSave=function(){     // Pack data for submit
  with(this){
    var old;
    var iOld=0;
    var iCur=0;
    for(var i=0;i<savedata.length;i++) if(savedata>0) savedata[i]=-1;  // Set out of batch records

    // Loop through existing records, if new skips then delete, otherwise compare them
    while(iOld<olddata.length || iCur<data.length){
      if(iOld<olddata.length) old=olddata[iOld++].split(dlm);
      else old=null;
      // Added records
      while(iCur<data.length && data[iCur].split(dlm)[0]=='add'){
        var r=data[iCur].split(dlm);
        for(var i=0;i<fieldn;i++)
          r[i]=window.saveformat(r[i],fieldvalidate[i]);
        saverow[savedata.length]=r.join(dlm);
        savedata[savedata.length]=iCur++;
      }

      // Updated records
      if(iCur<data.length){
        if(old[0]==data[iCur].split(dlm)[0]){
          if(olddata[iOld-1]!=data[iCur]){  // See if updated
            var saveval=olddata[iOld-1];
            var r1=olddata[iOld-1].split(dlm);
            var r2=data[iOld-1].split(dlm);
            for(var i=0;i<fieldn;i++)
              saveval+=dlm+(r1[i]==r2[i]?r1[i]:window.saveformat(r2[i],fieldvalidate[i]));
            saverow[savedata.length]=saveval;
            savedata[savedata.length]=iCur;
          }
          iCur++;
          continue;
        }
      }
      if(old){
        saverow[savedata.length]=olddata[iOld-1];
        savedata[savedata.length]=-2;
      }
    }
  }
}

Data.prototype.datamerge=function(){  // merge new values with uncommitted changes
  with(this){
    for(var i=savedata.length-1;i>-1;i--){
      var s=saverow[i].split(dlm);
      if(s[0]=='add') continue;
      for(var j=data.length-1;j>-1;j--) if(s[0]==data[j].split(dlm)[0]){
        if(savedata[i]>-2){
          olddata[j]=s.slice(0,fieldn).join(dlm);
          data[j]=s.slice(fieldn).join(dlm);
        } else {
          olddata[j]=saverow[i];
          data[j]=(data.slice(0,j)).concat(data.slice(j+1));
        }
        savedata=(savedata.slice(0,i)).concat(savedata.slice(i+1));
        saverow=(saverow.slice(0,i)).concat(saverow.slice(i+1));
      }
    }
  }
}

Data.prototype.datasubmit=function(){  // Pack data into the FORM
  with(this){
    for(var i=0;i<savedata.length;i++){
      var r=saverow[i].split(dlm);
      var mod=(savedata[i]==-2?'delete':((r.length>0 && r[0]=='add')?'add':'update'));
      app.document.form['_'+wdoreal+'._do'].value+='|'+mod;
      for(var j=0;j<fieldn;j++){
        var e=app.document.form['_'+wdoreal+'.'+fieldname[j]];
        if(!e) continue;
        e.value+=dlm+r[j];
        if(mod=='update') e.value+=dlm+r[j+fieldn];   // Need two columns, old and new values for update.
      }
    }
  }
}

Data.prototype.saveok=function(d){
  app.wbo.committing=false;
  with(this){
    if(d.length!=savedata.length) return alert(window.action('info.get|HTM19||'+d)); //ok
    if(mainapp.dyntree){
      var last=savedata[savedata.length-1];
      if(last<0){
        mainapp.dyntree.save('delete');
      } else {
        mainapp.dyntree.save(data[last].split(dlm)[0],d[d.length-1]);
      }
    }
    for(var i=0;i<savedata.length;i++) if(savedata[i]>-1) data[savedata[i]]=d[i];
    savedata=[];
    saverow=[];
    uncommitted=false;
    olddata=([]).concat(data); // Copy array
    initdata();
    lMod=false;
    lAdd=false;
    if(update=='auto' || update=='view') lUpd=false;
    custom('saveok');
    refreshTools();
    for(var i=0;i<target.length;i++) target[i].displayFields(); // this forces clean values

    if(this.hsbo && this.hsbo.uncommitted){ // Refresh commitlink
      this.hsbo.uncommitted=false;
      app.wbo.sboAction(this.sbo,'refresh');  
    }
    app.wbo.saveok();
  }
}

Data.prototype.saveconflict=function(d){
  with(this){
    app.wbo.committing=false;
    datamerge();
    var icur=row-1;
    var iold=findold(icur);
    var old=olddata[iold].split(dlm);  // Getting the old fields
    var cur=(data[icur]).split(dlm);  // Getting the input fields
    var chg=d[0].split(dlm)
    olddata[iold]=chg.join(dlm);
    data[icur]=chg.join(dlm);
    lUpd=true;

    if(!window.action('info.confirm|HTM11')){ //ok
      for(var i=1;i<fieldn;i++){            // Merge results
        if(cur[i]==chg[i]) continue;        // Only bother about conflicts
        action(fieldname[i]+'.mark')
        if(old[i]==cur[i]) cur[i]=chg[i];   // not your change
      }
      action('modify');
      for (var i=0; i < fieldn; i++)
        setViewer(fieldname[i],cur[i],true);  // Setting input fields only
      return true;
    }
    for(var i=0;i<target.length;i++) target[i].displayFields(); // this forces clean values
    refreshTools();
    return action('modify');
  }
}


/*****************************************************************/
/***   Run-time data navigation and handling                  ****/
/*****************************************************************/

Data.prototype.action=function(c,prm){
  with(this){
//    window.status='event:'+c;
    c=c.split('.');
    switch(c[c.length - 1]){

// *** Navigation ***
      case 'firstbatch': case 'prevbatch':
      case 'nextbatch':  case 'lastbatch':
        if(action('savechange')){
          app.wbo.afterSave(this.wdo+'.' + c);
          return window.action('info.yesno|HTM5||wbo.commit|wbo.undo|wbo.nosave');
        }
        this.positionok=false;
        // This is needed for navigation after delete in a pass-thru scenario
        app.document.form['_'+wdoreal+'._object'].value=objectname;
        window.actions([wdo+'.packdata','server.'+sbo+wdoreal+'.'+c[0].replace('batch',''),'wbo.submit']);
        window.status='Fetching data for '+wdoreal;
        return;
      case 'first':
        if(navprev) return batchNav(c[0]);
        return pick(1);
      case 'next':
        if(!notlast && navnext) return batchNav(c[0]);
        return pick(row+1);
      case 'prev':
        if(!notfirst && navprev) return batchNav(c[0]);
        return pick(row-1);
      case 'last':
        if(navnext) return batchNav(c[0]);
        return pick(data.length);
      case 'firstcurrent':
        return pick(1);
      case 'lastcurrent':
        return pick(data.length);
      case 'repos':
        prm=prm.split('|');
        if(action(c[0]+'.search',prm[1])) return action(prm[0]);
        return true;
      case 'search':
        var fld=index[c[0]];
        for(var i=0;i<data.length;i++)
          if(data[i].split(dlm)[fld]==prm){
            pick(i+1);
            return true;
          }
        return false;
      case 'pick':
        return pick(c[0]*1);

// *** Table IO ***
      case 'del': case 'del2':
        // HTM4|Do you want to delete this record?
        return window.action('info.confirm|HTM4||'+wdo +'.deleterec'); //ok
      case 'deleterec':
        if(!custom('delete')) return false;
        if(row==data.length){
          data.pop();
          row--;
        } else data.splice(row-1,1);
        initdata();
        for(var i=0;i<target.length;i++) target[i].displayFields(); // this forces clean values
        refreshTools();
        if(commit=='true') return action('commit');
        return true;
      case 'add':
        if(mainapp.dyntree) mainapp.dyntree.beforeAdd();
        return addRec(initvals,'add');
      case 'copy':
        return addRec(data[row-1].split(dlm),'copy');
      case 'copyrec':
        return addRec(prm.split(dlm),'copy');
      case 'undoupdate':
        datamerge();
        if(data[row-1].split(dlm)[0]!='add')
          data[row-1]=olddata[row-1];
        savedata=[];
        saverow=[];
//        alert("later"+window.latercmd)
        return action('modify');
      case 'undo':
        // New commit status needs to refresh all WDOs
        if(hsbo){
          for(var i=0;i<childDS.length;i++) childDS[i].action('cancel');
          hsbo.uncommitted=false;
          app.wbo.sboAction(sbo,'undodata');
          app.wbo.sboAction(sbo,'refresh');
        }
        action('undodata');
        return window.runlater();  // Clear
      case 'undodata':
        savedata=[];
        saverow=[];
        uncommitted=false;
        data=[].concat(olddata);
        row=(data.length?1:0);
        return initdata();
      case 'reset':
        if(!lUpd || !lMod) return false;
        lMod=false;
        if(update=='auto' || update=='view') lUpd=false;
        for(var i=0;i<target.length;i++) target[i].displayFields(); // this forces clean values
        custom('reset');
        refreshTools();
        return window.action('wbo.initfocus');
      case 'update':
        if(lUpd) return false;
        lUpd=true;
        refreshTools();
        return custom('modify');
      case 'modify':
        if(!lUpd || lMod) return false;
        lMod=true;
        refreshTools();
        return custom('modified');
      case 'cancel':
        if(!data.length) return;
        lAdd=false;
        lMod=false;
        if(update=='auto') lUpd=false;
        if(cur[0]=='add'){
          data.splice(row-1,1);
          row=addfrom;
          childRow=-1;   // Make sure children get refreshed
          initdata();
          cur='';
          pick(addfrom);
        }
        custom('cancel');
        refreshTools();
        if(mainapp.dyntree){
          lUpd=false;
          mainapp.dyntree.action('cancel');
        }
        return;
      case 'view':
        if(!action('changes') || commit!='true'){
           lUpd=false;
           return refreshTools();
        }
        else return window.action('info.yesno|HTM5||'+wdo+'.save|'+wdo+'.cancel'); //ok

// *** Data saving ***
      case 'old': case 'getdata':
        return cur[index[c[0]]];
      case 'gettype':
        return fieldvalidate[index[c[0]]];

      case 'save':
        return recSave();
      case 'packdata':
        app.document.form['_'+wdoreal+'._first'].value=data[0].split(dlm)[0];
        app.document.form['_'+wdoreal+'._last'].value=data[data.length-1].split(dlm)[0];
        if(app.wbo.name=='find') return action('commitdata');
        if(lUpd) action('save');
        return dataSave();
      case 'commitdata':
        if(lMod) action('save');
        dataSave();
        if(savedata.length==0) return false;
        datasubmit();
        app.document.form['_'+wdoreal+'._object'].value=objectname;
        app.document.form['do'].value+='|'+sbo+wdoreal+'.save';
        return true;
      case 'commit':
        app.wbo.committing=true;
        if(hsbo) app.wbo.sboAction(sbo,'commitdata');
        else action('commitdata');
        window.action('wbo.submit');
        return;

// *** Parent-child & uncommitted data control ***
      case 'savechange':  // true if there's data changed
        if(recInput()) return true;
        if(childDS.length && positionok){
          for(var i=0;i<childDS.length;i++)    // Check all children WDOs too
            if(childDS[i].action('savechange') || childDS[i].uncommitted) return true;
        }
        return false;
      case 'changes':               // True if data has changed
        if(!data.length) return olddata.length>0;
        return uncommitted||recInput()||data[row-1]!=olddata[findold(row-1)];

      case 'refresh':
        return refreshTools();
        
      default:
        //alert(c+' for Data '+wdo+' not implemented yet!')
        //alert(window.action('info.get|HTM20||'+c+'|WDO')); //ok
    }
  }
}

Data.prototype.batchNav=function(nav){
    // Navigation after the batch-fetch in case it's still in batch (repos will only reposition if record found)
  if(nav=='next'||nav=='prev') window.later(this.wdo+'.rowident.repos|'+nav+'|'+this.cur[0]);
  app.wbo.afterSave(this.wdo+'.'+(nav=='next'||nav=='first'?'firstcurrent':'lastcurrent'));
  this.action(nav+'batch');
}

Data.prototype.findold=function(iNew){   // Find the data corresponding to new record (used for commit link)
  with(this){
    var j=0;
    for(var i=0;i<olddata.length;i++){
      while(data[j].split(dlm)[0]=='add') j++  // Adjust added records in new array
      if(data[j].split(dlm)[0]!=olddata[i].split(dlm)[0]) continue;  // Adjust for found not deleted
      if(iNew==j++) return i;
    }
  }
}



Data.prototype.addRec=function(dt,c){
  with(this){
    this.addfrom=row;  // return fram cancel
    dt[0]='add';
    if(parentDS) {
      for(var i=0;i<parentfield.length;i++){
        var keyval=parentDS.data[parentDS.row-1].split(dlm)[parentfield[i]];
        dt[childfield[i]]=keyval;
        // Also find if there is a lookup for the key field - if so add the value to that field too
        // e.g. The lookup for the key field "custnum" would be "_custnum"
        for (var j=0;j<fieldname.length;j++)
          if(fieldname[j]=='_'+fieldname[childfield[i]]) dt[j]=keyval;
      }
    }
    data.push(dt.join(dlm));
    row=data.length;
    cur=dt;
    custom(c);  // Special initial values have to be initialized before display
    lUpd=true;
    lMod=false; // Resetting in case custom logic have changed the modified status
    for(var i=0;i<target.length;i++) target[i].initdata();  // Need to refresh browsers and viewers
    pick(row);
    lAdd=true;
    for(var i=0;i<target.length;i++) target[i].initFocus();  // Set focus
    return refreshTools();
  }
}


Data.prototype.custom=function(c,prm){
  if(!app[this.id+'_'+c]) return true;
  return app[this.id+'_'+c](prm);
}

