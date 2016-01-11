var cOwningEntityMnemonic = '';
var lTableHasObjField = false;
var cKeyFields = '';
var cOwningReference = '';
var cDisplayFieldLabel = '';
var cDisplayFieldValue = '';
var cUserId = '';



// Set initial values 
function gsmcmfullow_add() {
  // Set the combo value 
  var val = apph.action('gsmcmfullow.category_obj.get');
  apph.action('gsmcmfullow.category_obj.set|'+val);
  
  gsmcmfullow_update();
}

// Update values
function gsmcmfullow_update() {
  assign_entity_values();
  assign_user_info();
}

function parse_values() {
  var vals = app.entityInfo.split('|')
  if (vals.length > 1) cOwningEntityMnemonic = vals[1];
  if (vals.length > 3) lTableHasObjField = (vals[3] == 'yes');
  if (vals.length > 5) cKeyFields = vals[5];
  if (vals.length > 7) cOwningReference = vals[7];
  if (vals.length > 9) cDisplayFieldLabel = vals[9];
  if (vals.length > 11) cDisplayFieldValue = vals[11];
  if (vals.length > 13) cUserId = vals[13];
}


function assign_user_info() {
  if ( cOwningEntityMnemonic == '')
    parse_values();
    
  apph.action('gsmcmfullow.last_updated_by_user.set|'+cUserId);
  apph.action('gsmcmfullow.last_updated_date.set|'+app.main.format(new Date(),'date'));
}


function assign_entity_values() {
  if ( cOwningEntityMnemonic == '')
    parse_values();
    
  if (apph.action('gsmcmfullow.owning_entity_mnemonic.get') == '')
    apph.action('gsmcmfullow.owning_entity_mnemonic.set|'+cOwningEntityMnemonic);

    apph.action('gsmcmfullow.owning_reference.set|' + cOwningReference);
    apph.action('gsmcmfullow.owning_obj.set|0');
  }

function gsmcmfullow_saveok() {
  // set the parents comments to true
  try {
    var wdo = app.frameObject.parent.win.comtarget;
    wdo.cur[wdo.index['_hascomments']]='yes';
    wdo.olddata[wdo.row-1] =wdo.cur.join(wdo.dlm);
    wdo.data[wdo.row-1]=wdo.cur.join(wdo.dlm);
  } catch(e){}
}

function gsmcmfullow_view() {
  // disable the comments on comments functionality
  apph.action('tool.gsmcmfullow.comments.disable');
  
  if ( cOwningEntityMnemonic == '')
    parse_values();
    
  // Set label and value
  var hdl = apph.action('tool.cOwningEntityKeyField.handle')[0];
  if (hdl != null) {
    var lbl = hdl.previousSibling.previousSibling;
    if (lbl != null)  lbl.innerHTML = cDisplayFieldLabel + ':';
    apph.action('tool.cOwningEntityKeyField.set|' + cDisplayFieldValue);
  }
}