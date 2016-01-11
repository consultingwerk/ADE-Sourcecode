/*********************************************/
/****** Lookup functionality        **********/
/*********************************************/
Lookup.prototype.lookuptitle;
Lookup.prototype.lookupcols;
Lookup.prototype.lookupdata;
Lookup.prototype.lookupdlm;
Lookup.prototype.lookupbatch;
Lookup.prototype.lookupval;

Lookup.prototype.init=function(title,cols){
  this.lookuptitle=title;
  this.lookupcols=cols;
  app.dlookup=this;
}

Lookup.prototype.load=function(data,dlm,batch){
  this.lookupdata=data;
  this.lookupdlm=dlm;
  this.lookupbatch=batch;
}

Lookup.prototype.launch=function(){
 if(this.lookupdata.length!=1)
   if(this.lookupval>'' || returnfield.value=='') action(returnfield.id+'.mark');
 if(this.lookupdata.length==0) return action(returnfield.id+'.mark');
 if(this.lookupdata.length>1) return action('dlg.../dhtml/rylookup.htm');
 this.returnval();
}

Lookup.prototype.returnval=function(){
  with(this){	
    var e=window.returnfield;
    var disp=(e.getAttribute('dfield')).split(',');
    var cwdo=(e.id).split('.')[0];
    var cur;
    var fld;
    if(lookupdata.length==1){    // Lookupdata is not used in the lookup screen
      cur=lookupdata[0].split(lookupdlm);
      fld=('rowident|_key|'+lookupcols).split('|'); 
    } else {
      var hdata=action('lookup.handle').hdata;
      cur=hdata.data[hdata.displayrow-1].split(hdata.dlm);
      fld=hdata.fieldname;
    }
    var lfield=e.getAttribute('lfield');
    for(var i=0;i<disp.length;i++){
      for(var j=0;j<fld.length;j++){
        if(fld[j]!=disp[i]) continue;
        disp[0]='';
        later(cwdo+'._'+lfield+disp[i]+'.setinput|'+cur[j]); 
      }
    }
    later(cwdo+'._'+e.getAttribute('lfield')+disp[0]+'.unmark'); 
    var win=(lookupdata.length!=1?app:action('parent.handle'));
    var clookup=e.getAttribute('lookup');
    if(win[clookup+'_dynLookup']) win[clookup+'_dynLookup']()
    if(lookupdata.length==1) runlater();   
    else                     action('app.continue');
  }
}
function Lookup(){
}

var lookup = new Lookup();
