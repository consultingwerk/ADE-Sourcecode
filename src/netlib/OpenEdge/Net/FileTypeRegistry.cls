/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : FileTypeRegistry
   Purpose     : Stores mappings from file extension to mime type
   Syntax      : 
   Description : 
   Author(s)   : mbanks
   Created     : Thu May 19 16:01:33 EDT 2016
   Notes       : 
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.FileTypeRegistry.

/** Registry for mapping file extensions to their Mime types*/
class OpenEdge.Net.FileTypeRegistry: 
    /* Returns the number of mappings in this map.*/
    define public property Size as integer no-undo 
        get. 
        private set.
    
    define static private temp-table Registry no-undo
        field ParentRegistry as int64
        field ExtensionKey   as character 
        field MimeType       as character
        index idx1 as primary unique ParentRegistry ExtensionKey
        index idx2                   ParentRegistry MimeType
        .
    
    /** Default constructor */
    constructor private FileTypeRegistry():
    end constructor.
    
    destructor FileTypeRegistry():
        this-object:Clear().
    end destructor.
    
    define static public property Registry as FileTypeRegistry no-undo
        get():
            define variable registry as FileTypeRegistry no-undo.
            if not valid-object(FileTypeRegistry:Registry) then
            do:
                assign registry = new FileTypeRegistry().
                FileTypeRegistry:InitializeRegistry(registry).
                assign FileTypeRegistry:Registry = registry.
            end.
            return FileTypeRegistry:Registry.
        end get.
        private set.
    
    /** Adds initial values into the registry 
        
        @param BuilderRegistry The registry to populate */
    method static private void InitializeRegistry(input poRegistry as FileTypeRegistry):
        poRegistry:Put('123':u,'application/vnd.lotus-1-2-3':u).
        poRegistry:Put('3dml':u,'text/vnd.in3d.3dml':u).
        poRegistry:Put('3ds':u,'image/x-3ds':u).
        poRegistry:Put('3g2':u,'video/3gpp2':u).
        poRegistry:Put('3gp':u,'video/3gpp':u).
        poRegistry:Put('7z':u,'application/x-7z-compressed':u).
        poRegistry:Put('aab':u,'application/x-authorware-bin':u).
        poRegistry:Put('aac':u,'audio/x-aac':u).
        poRegistry:Put('aam':u,'application/x-authorware-map':u).
        poRegistry:Put('aas':u,'application/x-authorware-seg':u).
        poRegistry:Put('abs':u,'audio/x-mpeg':u).
        poRegistry:Put('abw':u,'application/x-abiword':u).
        poRegistry:Put('ac':u,'application/pkix-attr-cert':u).
        poRegistry:Put('acc':u,'application/vnd.americandynamics.acc':u).
        poRegistry:Put('ace':u,'application/x-ace-compressed':u).
        poRegistry:Put('acu':u,'application/vnd.acucobol':u).
        poRegistry:Put('acutc':u,'application/vnd.acucorp':u).
        poRegistry:Put('adp':u,'audio/adpcm':u).
        poRegistry:Put('aep':u,'application/vnd.audiograph':u).
        poRegistry:Put('afm':u,'application/x-font-type1':u).
        poRegistry:Put('afp':u,'application/vnd.ibm.modcap':u).
        poRegistry:Put('ahead':u,'application/vnd.ahead.space':u).
        poRegistry:Put('ai':u,'application/postscript':u).
        poRegistry:Put('aif':u,'audio/x-aiff':u).
        poRegistry:Put('aifc':u,'audio/x-aiff':u).
        poRegistry:Put('aiff':u,'audio/x-aiff':u).
        poRegistry:Put('aim':u,'application/x-aim':u).
        poRegistry:Put('air':u,'application/vnd.adobe.air-application-installer-package+zip':u).
        poRegistry:Put('ait':u,'application/vnd.dvb.ait':u).
        poRegistry:Put('ami':u,'application/vnd.amiga.ami':u).
        poRegistry:Put('anx':u,'application/annodex':u).
        poRegistry:Put('apk':u,'application/vnd.android.package-archive':u).
        poRegistry:Put('appcache':u,'text/cache-manifest':u).
        poRegistry:Put('application':u,'application/x-ms-application':u).
        poRegistry:Put('apr':u,'application/vnd.lotus-approach':u).
        poRegistry:Put('arc':u,'application/x-freearc':u).
        poRegistry:Put('art':u,'image/x-jg':u).
        poRegistry:Put('asc':u,'application/pgp-signature':u).
        poRegistry:Put('asf':u,'video/x-ms-asf':u).
        poRegistry:Put('asm':u,'text/x-asm':u).
        poRegistry:Put('aso':u,'application/vnd.accpac.simply.aso':u).
        poRegistry:Put('asx':u,'video/x-ms-asf':u).
        poRegistry:Put('atc':u,'application/vnd.acucorp':u).
        poRegistry:Put('atom':u,'application/atom+xml':u).
        poRegistry:Put('atomcat':u,'application/atomcat+xml':u).
        poRegistry:Put('atomsvc':u,'application/atomsvc+xml':u).
        poRegistry:Put('atx':u,'application/vnd.antix.game-component':u).
        poRegistry:Put('au':u,'audio/basic':u).
        poRegistry:Put('avi':u,'video/x-msvideo':u).
        poRegistry:Put('avx':u,'video/x-rad-screenplay':u).
        poRegistry:Put('aw':u,'application/applixware':u).
        poRegistry:Put('axa':u,'audio/annodex':u).
        poRegistry:Put('axv':u,'video/annodex':u).
        poRegistry:Put('azf':u,'application/vnd.airzip.filesecure.azf':u).
        poRegistry:Put('azs':u,'application/vnd.airzip.filesecure.azs':u).
        poRegistry:Put('azw':u,'application/vnd.amazon.ebook':u).
        poRegistry:Put('bat':u,'application/x-msdownload':u).
        poRegistry:Put('bcpio':u,'application/x-bcpio':u).
        poRegistry:Put('bdf':u,'application/x-font-bdf':u).
        poRegistry:Put('bdm':u,'application/vnd.syncml.dm+wbxml':u).
        poRegistry:Put('bed':u,'application/vnd.realvnc.bed':u).
        poRegistry:Put('bh2':u,'application/vnd.fujitsu.oasysprs':u).
        poRegistry:Put('bin':u,'application/octet-stream':u).
        poRegistry:Put('blb':u,'application/x-blorb':u).
        poRegistry:Put('blorb':u,'application/x-blorb':u).
        poRegistry:Put('bmi':u,'application/vnd.bmi':u).
        poRegistry:Put('bmp':u,'image/bmp':u).
        poRegistry:Put('body':u,'text/html':u).
        poRegistry:Put('book':u,'application/vnd.framemaker':u).
        poRegistry:Put('box':u,'application/vnd.previewsystems.box':u).
        poRegistry:Put('boz':u,'application/x-bzip2':u).
        poRegistry:Put('bpk':u,'application/octet-stream':u).
        poRegistry:Put('btif':u,'image/prs.btif':u).
        poRegistry:Put('bz':u,'application/x-bzip':u).
        poRegistry:Put('bz2':u,'application/x-bzip2':u).
        poRegistry:Put('c':u,'text/x-c':u).
        poRegistry:Put('c11amc':u,'application/vnd.cluetrust.cartomobile-config':u).
        poRegistry:Put('c11amz':u,'application/vnd.cluetrust.cartomobile-config-pkg':u).
        poRegistry:Put('c4d':u,'application/vnd.clonk.c4group':u).
        poRegistry:Put('c4f':u,'application/vnd.clonk.c4group':u).
        poRegistry:Put('c4g':u,'application/vnd.clonk.c4group':u).
        poRegistry:Put('c4p':u,'application/vnd.clonk.c4group':u).
        poRegistry:Put('c4u':u,'application/vnd.clonk.c4group':u).
        poRegistry:Put('cab':u,'application/vnd.ms-cab-compressed':u).
        poRegistry:Put('caf':u,'audio/x-caf':u).
        poRegistry:Put('cap':u,'application/vnd.tcpdump.pcap':u).
        poRegistry:Put('car':u,'application/vnd.curl.car':u).
        poRegistry:Put('cat':u,'application/vnd.ms-pki.seccat':u).
        poRegistry:Put('cb7':u,'application/x-cbr':u).
        poRegistry:Put('cba':u,'application/x-cbr':u).
        poRegistry:Put('cbr':u,'application/x-cbr':u).
        poRegistry:Put('cbt':u,'application/x-cbr':u).
        poRegistry:Put('cbz':u,'application/x-cbr':u).
        poRegistry:Put('cc':u,'text/x-c':u).
        poRegistry:Put('cct':u,'application/x-director':u).
        poRegistry:Put('ccxml':u,'application/ccxml+xml':u).
        poRegistry:Put('cdbcmsg':u,'application/vnd.contact.cmsg':u).
        poRegistry:Put('cdf':u,'application/x-cdf':u).
        poRegistry:Put('cdkey':u,'application/vnd.mediastation.cdkey':u).
        poRegistry:Put('cdmia':u,'application/cdmi-capability':u).
        poRegistry:Put('cdmic':u,'application/cdmi-container':u).
        poRegistry:Put('cdmid':u,'application/cdmi-domain':u).
        poRegistry:Put('cdmio':u,'application/cdmi-object':u).
        poRegistry:Put('cdmiq':u,'application/cdmi-queue':u).
        poRegistry:Put('cdx':u,'chemical/x-cdx':u).
        poRegistry:Put('cdxml':u,'application/vnd.chemdraw+xml':u).
        poRegistry:Put('cdy':u,'application/vnd.cinderella':u).
        poRegistry:Put('cer':u,'application/pkix-cert':u).
        poRegistry:Put('cfs':u,'application/x-cfs-compressed':u).
        poRegistry:Put('cgm':u,'image/cgm':u).
        poRegistry:Put('chat':u,'application/x-chat':u).
        poRegistry:Put('chm':u,'application/vnd.ms-htmlhelp':u).
        poRegistry:Put('chrt':u,'application/vnd.kde.kchart':u).
        poRegistry:Put('cif':u,'chemical/x-cif':u).
        poRegistry:Put('cii':u,'application/vnd.anser-web-certificate-issue-initiation':u).
        poRegistry:Put('cil':u,'application/vnd.ms-artgalry':u).
        poRegistry:Put('cla':u,'application/vnd.claymore':u).
        poRegistry:Put('class':u,'application/java':u).
        poRegistry:Put('clkk':u,'application/vnd.crick.clicker.keyboard':u).
        poRegistry:Put('clkp':u,'application/vnd.crick.clicker.palette':u).
        poRegistry:Put('clkt':u,'application/vnd.crick.clicker.template':u).
        poRegistry:Put('clkw':u,'application/vnd.crick.clicker.wordbank':u).
        poRegistry:Put('clkx':u,'application/vnd.crick.clicker':u).
        poRegistry:Put('clp':u,'application/x-msclip':u).
        poRegistry:Put('cmc':u,'application/vnd.cosmocaller':u).
        poRegistry:Put('cmdf':u,'chemical/x-cmdf':u).
        poRegistry:Put('cml':u,'chemical/x-cml':u).
        poRegistry:Put('cmp':u,'application/vnd.yellowriver-custom-menu':u).
        poRegistry:Put('cmx':u,'image/x-cmx':u).
        poRegistry:Put('cod':u,'application/vnd.rim.cod':u).
        poRegistry:Put('com':u,'application/x-msdownload':u).
        poRegistry:Put('conf':u,'text/plain':u).
        poRegistry:Put('cpio':u,'application/x-cpio':u).
        poRegistry:Put('cpp':u,'text/x-c':u).
        poRegistry:Put('cpt':u,'application/mac-compactpro':u).
        poRegistry:Put('crd':u,'application/x-mscardfile':u).
        poRegistry:Put('crl':u,'application/pkix-crl':u).
        poRegistry:Put('crt':u,'application/x-x509-ca-cert':u).
        poRegistry:Put('cryptonote':u,'application/vnd.rig.cryptonote':u).
        poRegistry:Put('csh':u,'application/x-csh':u).
        poRegistry:Put('csml':u,'chemical/x-csml':u).
        poRegistry:Put('csp':u,'application/vnd.commonspace':u).
        poRegistry:Put('css':u,'text/css':u).
        poRegistry:Put('cst':u,'application/x-director':u).
        poRegistry:Put('csv':u,'text/csv':u).
        poRegistry:Put('cu':u,'application/cu-seeme':u).
        poRegistry:Put('curl':u,'text/vnd.curl':u).
        poRegistry:Put('cww':u,'application/prs.cww':u).
        poRegistry:Put('cxt':u,'application/x-director':u).
        poRegistry:Put('cxx':u,'text/x-c':u).
        poRegistry:Put('dae':u,'model/vnd.collada+xml':u).
        poRegistry:Put('daf':u,'application/vnd.mobius.daf':u).
        poRegistry:Put('dart':u,'application/vnd.dart':u).
        poRegistry:Put('dataless':u,'application/vnd.fdsn.seed':u).
        poRegistry:Put('davmount':u,'application/davmount+xml':u).
        poRegistry:Put('dbk':u,'application/docbook+xml':u).
        poRegistry:Put('dcr':u,'application/x-director':u).
        poRegistry:Put('dcurl':u,'text/vnd.curl.dcurl':u).
        poRegistry:Put('dd2':u,'application/vnd.oma.dd2+xml':u).
        poRegistry:Put('ddd':u,'application/vnd.fujixerox.ddd':u).
        poRegistry:Put('deb':u,'application/x-debian-package':u).
        poRegistry:Put('def':u,'text/plain':u).
        poRegistry:Put('deploy':u,'application/octet-stream':u).
        poRegistry:Put('der':u,'application/x-x509-ca-cert':u).
        poRegistry:Put('dfac':u,'application/vnd.dreamfactory':u).
        poRegistry:Put('dgc':u,'application/x-dgc-compressed':u).
        poRegistry:Put('dib':u,'image/bmp':u).
        poRegistry:Put('dic':u,'text/x-c':u).
        poRegistry:Put('dir':u,'application/x-director':u).
        poRegistry:Put('dis':u,'application/vnd.mobius.dis':u).
        poRegistry:Put('dist':u,'application/octet-stream':u).
        poRegistry:Put('distz':u,'application/octet-stream':u).
        poRegistry:Put('djv':u,'image/vnd.djvu':u).
        poRegistry:Put('djvu':u,'image/vnd.djvu':u).
        poRegistry:Put('dll':u,'application/x-msdownload':u).
        poRegistry:Put('dmg':u,'application/x-apple-diskimage':u).
        poRegistry:Put('dmp':u,'application/vnd.tcpdump.pcap':u).
        poRegistry:Put('dms':u,'application/octet-stream':u).
        poRegistry:Put('dna':u,'application/vnd.dna':u).
        poRegistry:Put('doc':u,'application/msword':u).
        poRegistry:Put('docm':u,'application/vnd.ms-word.document.macroenabled.12':u).
        poRegistry:Put('docx':u,'application/vnd.openxmlformats-officedocument.wordprocessingml.document':u).
        poRegistry:Put('dot':u,'application/msword':u).
        poRegistry:Put('dotm':u,'application/vnd.ms-word.template.macroenabled.12':u).
        poRegistry:Put('dotx':u,'application/vnd.openxmlformats-officedocument.wordprocessingml.template':u).
        poRegistry:Put('dp':u,'application/vnd.osgi.dp':u).
        poRegistry:Put('dpg':u,'application/vnd.dpgraph':u).
        poRegistry:Put('dra':u,'audio/vnd.dra':u).
        poRegistry:Put('dsc':u,'text/prs.lines.tag':u).
        poRegistry:Put('dssc':u,'application/dssc+der':u).
        poRegistry:Put('dtb':u,'application/x-dtbook+xml':u).
        poRegistry:Put('dtd':u,'application/xml-dtd':u).
        poRegistry:Put('dts':u,'audio/vnd.dts':u).
        poRegistry:Put('dtshd':u,'audio/vnd.dts.hd':u).
        poRegistry:Put('dump':u,'application/octet-stream':u).
        poRegistry:Put('dv':u,'video/x-dv':u).
        poRegistry:Put('dvb':u,'video/vnd.dvb.file':u).
        poRegistry:Put('dvi':u,'application/x-dvi':u).
        poRegistry:Put('dwf':u,'model/vnd.dwf':u).
        poRegistry:Put('dwg':u,'image/vnd.dwg':u).
        poRegistry:Put('dxf':u,'image/vnd.dxf':u).
        poRegistry:Put('dxp':u,'application/vnd.spotfire.dxp':u).
        poRegistry:Put('dxr':u,'application/x-director':u).
        poRegistry:Put('ecelp4800':u,'audio/vnd.nuera.ecelp4800':u).
        poRegistry:Put('ecelp7470':u,'audio/vnd.nuera.ecelp7470':u).
        poRegistry:Put('ecelp9600':u,'audio/vnd.nuera.ecelp9600':u).
        poRegistry:Put('ecma':u,'application/ecmascript':u).
        poRegistry:Put('edm':u,'application/vnd.novadigm.edm':u).
        poRegistry:Put('edx':u,'application/vnd.novadigm.edx':u).
        poRegistry:Put('efif':u,'application/vnd.picsel':u).
        poRegistry:Put('ei6':u,'application/vnd.pg.osasli':u).
        poRegistry:Put('elc':u,'application/octet-stream':u).
        poRegistry:Put('emf':u,'application/x-msmetafile':u).
        poRegistry:Put('eml':u,'message/rfc822':u).
        poRegistry:Put('emma':u,'application/emma+xml':u).
        poRegistry:Put('emz':u,'application/x-msmetafile':u).
        poRegistry:Put('eol':u,'audio/vnd.digital-winds':u).
        poRegistry:Put('eot':u,'application/vnd.ms-fontobject':u).
        poRegistry:Put('eps':u,'application/postscript':u).
        poRegistry:Put('epub':u,'application/epub+zip':u).
        poRegistry:Put('es3':u,'application/vnd.eszigno3+xml':u).
        poRegistry:Put('esa':u,'application/vnd.osgi.subsystem':u).
        poRegistry:Put('esf':u,'application/vnd.epson.esf':u).
        poRegistry:Put('et3':u,'application/vnd.eszigno3+xml':u).
        poRegistry:Put('etx':u,'text/x-setext':u).
        poRegistry:Put('eva':u,'application/x-eva':u).
        poRegistry:Put('evy':u,'application/x-envoy':u).
        poRegistry:Put('exe':u,'application/octet-stream':u).
        poRegistry:Put('exi':u,'application/exi':u).
        poRegistry:Put('ext':u,'application/vnd.novadigm.ext':u).
        poRegistry:Put('ez':u,'application/andrew-inset':u).
        poRegistry:Put('ez2':u,'application/vnd.ezpix-album':u).
        poRegistry:Put('ez3':u,'application/vnd.ezpix-package':u).
        poRegistry:Put('f':u,'text/x-fortran':u).
        poRegistry:Put('f4v':u,'video/x-f4v':u).
        poRegistry:Put('f77':u,'text/x-fortran':u).
        poRegistry:Put('f90':u,'text/x-fortran':u).
        poRegistry:Put('fbs':u,'image/vnd.fastbidsheet':u).
        poRegistry:Put('fcdt':u,'application/vnd.adobe.formscentral.fcdt':u).
        poRegistry:Put('fcs':u,'application/vnd.isac.fcs':u).
        poRegistry:Put('fdf':u,'application/vnd.fdf':u).
        poRegistry:Put('fe_launch':u,'application/vnd.denovo.fcselayout-link':u).
        poRegistry:Put('fg5':u,'application/vnd.fujitsu.oasysgp':u).
        poRegistry:Put('fgd':u,'application/x-director':u).
        poRegistry:Put('fh':u,'image/x-freehand':u).
        poRegistry:Put('fh4':u,'image/x-freehand':u).
        poRegistry:Put('fh5':u,'image/x-freehand':u).
        poRegistry:Put('fh7':u,'image/x-freehand':u).
        poRegistry:Put('fhc':u,'image/x-freehand':u).
        poRegistry:Put('fig':u,'application/x-xfig':u).
        poRegistry:Put('flac':u,'audio/flac':u).
        poRegistry:Put('fli':u,'video/x-fli':u).
        poRegistry:Put('flo':u,'application/vnd.micrografx.flo':u).
        poRegistry:Put('flv':u,'video/x-flv':u).
        poRegistry:Put('flw':u,'application/vnd.kde.kivio':u).
        poRegistry:Put('flx':u,'text/vnd.fmi.flexstor':u).
        poRegistry:Put('fly':u,'text/vnd.fly':u).
        poRegistry:Put('fm':u,'application/vnd.framemaker':u).
        poRegistry:Put('fnc':u,'application/vnd.frogans.fnc':u).
        poRegistry:Put('for':u,'text/x-fortran':u).
        poRegistry:Put('fpx':u,'image/vnd.fpx':u).
        poRegistry:Put('frame':u,'application/vnd.framemaker':u).
        poRegistry:Put('fsc':u,'application/vnd.fsc.weblaunch':u).
        poRegistry:Put('fst':u,'image/vnd.fst':u).
        poRegistry:Put('ftc':u,'application/vnd.fluxtime.clip':u).
        poRegistry:Put('fti':u,'application/vnd.anser-web-funds-transfer-initiation':u).
        poRegistry:Put('fvt':u,'video/vnd.fvt':u).
        poRegistry:Put('fxp':u,'application/vnd.adobe.fxp':u).
        poRegistry:Put('fxpl':u,'application/vnd.adobe.fxp':u).
        poRegistry:Put('fzs':u,'application/vnd.fuzzysheet':u).
        poRegistry:Put('g2w':u,'application/vnd.geoplan':u).
        poRegistry:Put('g3':u,'image/g3fax':u).
        poRegistry:Put('g3w':u,'application/vnd.geospace':u).
        poRegistry:Put('gac':u,'application/vnd.groove-account':u).
        poRegistry:Put('gam':u,'application/x-tads':u).
        poRegistry:Put('gbr':u,'application/rpki-ghostbusters':u).
        poRegistry:Put('gca':u,'application/x-gca-compressed':u).
        poRegistry:Put('gdl':u,'model/vnd.gdl':u).
        poRegistry:Put('geo':u,'application/vnd.dynageo':u).
        poRegistry:Put('gex':u,'application/vnd.geometry-explorer':u).
        poRegistry:Put('ggb':u,'application/vnd.geogebra.file':u).
        poRegistry:Put('ggt':u,'application/vnd.geogebra.tool':u).
        poRegistry:Put('ghf':u,'application/vnd.groove-help':u).
        poRegistry:Put('gif':u,'image/gif':u).
        poRegistry:Put('gim':u,'application/vnd.groove-identity-message':u).
        poRegistry:Put('gml':u,'application/gml+xml':u).
        poRegistry:Put('gmx':u,'application/vnd.gmx':u).
        poRegistry:Put('gnumeric':u,'application/x-gnumeric':u).
        poRegistry:Put('gph':u,'application/vnd.flographit':u).
        poRegistry:Put('gpx':u,'application/gpx+xml':u).
        poRegistry:Put('gqf':u,'application/vnd.grafeq':u).
        poRegistry:Put('gqs':u,'application/vnd.grafeq':u).
        poRegistry:Put('gram':u,'application/srgs':u).
        poRegistry:Put('gramps':u,'application/x-gramps-xml':u).
        poRegistry:Put('gre':u,'application/vnd.geometry-explorer':u).
        poRegistry:Put('grv':u,'application/vnd.groove-injector':u).
        poRegistry:Put('grxml':u,'application/srgs+xml':u).
        poRegistry:Put('gsf':u,'application/x-font-ghostscript':u).
        poRegistry:Put('gtar':u,'application/x-gtar':u).
        poRegistry:Put('gtm':u,'application/vnd.groove-tool-message':u).
        poRegistry:Put('gtw':u,'model/vnd.gtw':u).
        poRegistry:Put('gv':u,'text/vnd.graphviz':u).
        poRegistry:Put('gxf':u,'application/gxf':u).
        poRegistry:Put('gxt':u,'application/vnd.geonext':u).
        poRegistry:Put('gz':u,'application/x-gzip':u).
        poRegistry:Put('h':u,'text/x-c':u).
        poRegistry:Put('h261':u,'video/h261':u).
        poRegistry:Put('h263':u,'video/h263':u).
        poRegistry:Put('h264':u,'video/h264':u).
        poRegistry:Put('hal':u,'application/vnd.hal+xml':u).
        poRegistry:Put('hbci':u,'application/vnd.hbci':u).
        poRegistry:Put('hdf':u,'application/x-hdf':u).
        poRegistry:Put('hh':u,'text/x-c':u).
        poRegistry:Put('hlp':u,'application/winhlp':u).
        poRegistry:Put('hpgl':u,'application/vnd.hp-hpgl':u).
        poRegistry:Put('hpid':u,'application/vnd.hp-hpid':u).
        poRegistry:Put('hps':u,'application/vnd.hp-hps':u).
        poRegistry:Put('hqx':u,'application/mac-binhex40':u).
        poRegistry:Put('htc':u,'text/x-component':u).
        poRegistry:Put('htke':u,'application/vnd.kenameaapp':u).
        poRegistry:Put('htm':u,'text/html':u).
        poRegistry:Put('html':u,'text/html':u).
        poRegistry:Put('hvd':u,'application/vnd.yamaha.hv-dic':u).
        poRegistry:Put('hvp':u,'application/vnd.yamaha.hv-voice':u).
        poRegistry:Put('hvs':u,'application/vnd.yamaha.hv-script':u).
        poRegistry:Put('i2g':u,'application/vnd.intergeo':u).
        poRegistry:Put('icc':u,'application/vnd.iccprofile':u).
        poRegistry:Put('ice':u,'x-conference/x-cooltalk':u).
        poRegistry:Put('icm':u,'application/vnd.iccprofile':u).
        poRegistry:Put('ico':u,'image/x-icon':u).
        poRegistry:Put('ics':u,'text/calendar':u).
        poRegistry:Put('ief':u,'image/ief':u).
        poRegistry:Put('ifb':u,'text/calendar':u).
        poRegistry:Put('ifm':u,'application/vnd.shana.informed.formdata':u).
        poRegistry:Put('iges':u,'model/iges':u).
        poRegistry:Put('igl':u,'application/vnd.igloader':u).
        poRegistry:Put('igm':u,'application/vnd.insors.igm':u).
        poRegistry:Put('igs':u,'model/iges':u).
        poRegistry:Put('igx':u,'application/vnd.micrografx.igx':u).
        poRegistry:Put('iif':u,'application/vnd.shana.informed.interchange':u).
        poRegistry:Put('imp':u,'application/vnd.accpac.simply.imp':u).
        poRegistry:Put('ims':u,'application/vnd.ms-ims':u).
        poRegistry:Put('in':u,'text/plain':u).
        poRegistry:Put('ink':u,'application/inkml+xml':u).
        poRegistry:Put('inkml':u,'application/inkml+xml':u).
        poRegistry:Put('install':u,'application/x-install-instructions':u).
        poRegistry:Put('iota':u,'application/vnd.astraea-software.iota':u).
        poRegistry:Put('ipfix':u,'application/ipfix':u).
        poRegistry:Put('ipk':u,'application/vnd.shana.informed.package':u).
        poRegistry:Put('irm':u,'application/vnd.ibm.rights-management':u).
        poRegistry:Put('irp':u,'application/vnd.irepository.package+xml':u).
        poRegistry:Put('iso':u,'application/x-iso9660-image':u).
        poRegistry:Put('itp':u,'application/vnd.shana.informed.formtemplate':u).
        poRegistry:Put('ivp':u,'application/vnd.immervision-ivp':u).
        poRegistry:Put('ivu':u,'application/vnd.immervision-ivu':u).
        poRegistry:Put('jad':u,'text/vnd.sun.j2me.app-descriptor':u).
        poRegistry:Put('jam':u,'application/vnd.jam':u).
        poRegistry:Put('jar':u,'application/java-archive':u).
        poRegistry:Put('java':u,'text/x-java-source':u).
        poRegistry:Put('jisp':u,'application/vnd.jisp':u).
        poRegistry:Put('jlt':u,'application/vnd.hp-jlyt':u).
        poRegistry:Put('jnlp':u,'application/x-java-jnlp-file':u).
        poRegistry:Put('joda':u,'application/vnd.joost.joda-archive':u).
        poRegistry:Put('jpe':u,'image/jpeg':u).
        poRegistry:Put('jpeg':u,'image/jpeg':u).
        poRegistry:Put('jpg':u,'image/jpeg':u).
        poRegistry:Put('jpgm':u,'video/jpm':u).
        poRegistry:Put('jpgv':u,'video/jpeg':u).
        poRegistry:Put('jpm':u,'video/jpm':u).
        poRegistry:Put('js':u,'application/javascript':u).
        poRegistry:Put('jsf':u,'text/plain':u).
        poRegistry:Put('json':u,'application/json':u).
        poRegistry:Put('jsonml':u,'application/jsonml+json':u).
        poRegistry:Put('jspf':u,'text/plain':u).
        poRegistry:Put('kar':u,'audio/midi':u).
        poRegistry:Put('karbon':u,'application/vnd.kde.karbon':u).
        poRegistry:Put('kfo':u,'application/vnd.kde.kformula':u).
        poRegistry:Put('kia':u,'application/vnd.kidspiration':u).
        poRegistry:Put('kml':u,'application/vnd.google-earth.kml+xml':u).
        poRegistry:Put('kmz':u,'application/vnd.google-earth.kmz':u).
        poRegistry:Put('kne':u,'application/vnd.kinar':u).
        poRegistry:Put('knp':u,'application/vnd.kinar':u).
        poRegistry:Put('kon':u,'application/vnd.kde.kontour':u).
        poRegistry:Put('kpr':u,'application/vnd.kde.kpresenter':u).
        poRegistry:Put('kpt':u,'application/vnd.kde.kpresenter':u).
        poRegistry:Put('kpxx':u,'application/vnd.ds-keypoint':u).
        poRegistry:Put('ksp':u,'application/vnd.kde.kspread':u).
        poRegistry:Put('ktr':u,'application/vnd.kahootz':u).
        poRegistry:Put('ktx':u,'image/ktx':u).
        poRegistry:Put('ktz':u,'application/vnd.kahootz':u).
        poRegistry:Put('kwd':u,'application/vnd.kde.kword':u).
        poRegistry:Put('kwt':u,'application/vnd.kde.kword':u).
        poRegistry:Put('lasxml':u,'application/vnd.las.las+xml':u).
        poRegistry:Put('latex':u,'application/x-latex':u).
        poRegistry:Put('lbd':u,'application/vnd.llamagraphics.life-balance.desktop':u).
        poRegistry:Put('lbe':u,'application/vnd.llamagraphics.life-balance.exchange+xml':u).
        poRegistry:Put('les':u,'application/vnd.hhe.lesson-player':u).
        poRegistry:Put('lha':u,'application/x-lzh-compressed':u).
        poRegistry:Put('link66':u,'application/vnd.route66.link66+xml':u).
        poRegistry:Put('list':u,'text/plain':u).
        poRegistry:Put('list3820':u,'application/vnd.ibm.modcap':u).
        poRegistry:Put('listafp':u,'application/vnd.ibm.modcap':u).
        poRegistry:Put('lnk':u,'application/x-ms-shortcut':u).
        poRegistry:Put('log':u,'text/plain':u).
        poRegistry:Put('lostxml':u,'application/lost+xml':u).
        poRegistry:Put('lrf':u,'application/octet-stream':u).
        poRegistry:Put('lrm':u,'application/vnd.ms-lrm':u).
        poRegistry:Put('ltf':u,'application/vnd.frogans.ltf':u).
        poRegistry:Put('lvp':u,'audio/vnd.lucent.voice':u).
        poRegistry:Put('lwp':u,'application/vnd.lotus-wordpro':u).
        poRegistry:Put('lzh':u,'application/x-lzh-compressed':u).
        poRegistry:Put('m13':u,'application/x-msmediaview':u).
        poRegistry:Put('m14':u,'application/x-msmediaview':u).
        poRegistry:Put('m1v':u,'video/mpeg':u).
        poRegistry:Put('m21':u,'application/mp21':u).
        poRegistry:Put('m2a':u,'audio/mpeg':u).
        poRegistry:Put('m2v':u,'video/mpeg':u).
        poRegistry:Put('m3a':u,'audio/mpeg':u).
        poRegistry:Put('m3u':u,'audio/x-mpegurl':u).
        poRegistry:Put('m3u8':u,'application/vnd.apple.mpegurl':u).
        poRegistry:Put('m4a':u,'audio/mp4':u).
        poRegistry:Put('m4b':u,'audio/mp4':u).
        poRegistry:Put('m4r':u,'audio/mp4':u).
        poRegistry:Put('m4u':u,'video/vnd.mpegurl':u).
        poRegistry:Put('m4v':u,'video/mp4':u).
        poRegistry:Put('ma':u,'application/mathematica':u).
        poRegistry:Put('mac':u,'image/x-macpaint':u).
        poRegistry:Put('mads':u,'application/mads+xml':u).
        poRegistry:Put('mag':u,'application/vnd.ecowin.chart':u).
        poRegistry:Put('maker':u,'application/vnd.framemaker':u).
        poRegistry:Put('man':u,'text/troff':u).
        poRegistry:Put('mar':u,'application/octet-stream':u).
        poRegistry:Put('mathml':u,'application/mathml+xml':u).
        poRegistry:Put('mb':u,'application/mathematica':u).
        poRegistry:Put('mbk':u,'application/vnd.mobius.mbk':u).
        poRegistry:Put('mbox':u,'application/mbox':u).
        poRegistry:Put('mc1':u,'application/vnd.medcalcdata':u).
        poRegistry:Put('mcd':u,'application/vnd.mcd':u).
        poRegistry:Put('mcurl':u,'text/vnd.curl.mcurl':u).
        poRegistry:Put('mdb':u,'application/x-msaccess':u).
        poRegistry:Put('mdi':u,'image/vnd.ms-modi':u).
        poRegistry:Put('me':u,'text/troff':u).
        poRegistry:Put('mesh':u,'model/mesh':u).
        poRegistry:Put('meta4':u,'application/metalink4+xml':u).
        poRegistry:Put('metalink':u,'application/metalink+xml':u).
        poRegistry:Put('mets':u,'application/mets+xml':u).
        poRegistry:Put('mfm':u,'application/vnd.mfmp':u).
        poRegistry:Put('mft':u,'application/rpki-manifest':u).
        poRegistry:Put('mgp':u,'application/vnd.osgeo.mapguide.package':u).
        poRegistry:Put('mgz':u,'application/vnd.proteus.magazine':u).
        poRegistry:Put('mid':u,'audio/midi':u).
        poRegistry:Put('midi':u,'audio/midi':u).
        poRegistry:Put('mie':u,'application/x-mie':u).
        poRegistry:Put('mif':u,'application/x-mif':u).
        poRegistry:Put('mime':u,'message/rfc822':u).
        poRegistry:Put('mj2':u,'video/mj2':u).
        poRegistry:Put('mjp2':u,'video/mj2':u).
        poRegistry:Put('mk3d':u,'video/x-matroska':u).
        poRegistry:Put('mka':u,'audio/x-matroska':u).
        poRegistry:Put('mks':u,'video/x-matroska':u).
        poRegistry:Put('mkv':u,'video/x-matroska':u).
        poRegistry:Put('mlp':u,'application/vnd.dolby.mlp':u).
        poRegistry:Put('mmd':u,'application/vnd.chipnuts.karaoke-mmd':u).
        poRegistry:Put('mmf':u,'application/vnd.smaf':u).
        poRegistry:Put('mmr':u,'image/vnd.fujixerox.edmics-mmr':u).
        poRegistry:Put('mng':u,'video/x-mng':u).
        poRegistry:Put('mny':u,'application/x-msmoney':u).
        poRegistry:Put('mobi':u,'application/x-mobipocket-ebook':u).
        poRegistry:Put('mods':u,'application/mods+xml':u).
        poRegistry:Put('mov':u,'video/quicktime':u).
        poRegistry:Put('movie':u,'video/x-sgi-movie':u).
        poRegistry:Put('mp1':u,'audio/mpeg':u).
        poRegistry:Put('mp2':u,'audio/mpeg':u).
        poRegistry:Put('mp21':u,'application/mp21':u).
        poRegistry:Put('mp2a':u,'audio/mpeg':u).
        poRegistry:Put('mp3':u,'audio/mpeg':u).
        poRegistry:Put('mp4':u,'video/mp4':u).
        poRegistry:Put('mp4a':u,'audio/mp4':u).
        poRegistry:Put('mp4s':u,'application/mp4':u).
        poRegistry:Put('mp4v':u,'video/mp4':u).
        poRegistry:Put('mpa':u,'audio/mpeg':u).
        poRegistry:Put('mpc':u,'application/vnd.mophun.certificate':u).
        poRegistry:Put('mpe':u,'video/mpeg':u).
        poRegistry:Put('mpeg':u,'video/mpeg':u).
        poRegistry:Put('mpega':u,'audio/x-mpeg':u).
        poRegistry:Put('mpg':u,'video/mpeg':u).
        poRegistry:Put('mpg4':u,'video/mp4':u).
        poRegistry:Put('mpga':u,'audio/mpeg':u).
        poRegistry:Put('mpkg':u,'application/vnd.apple.installer+xml':u).
        poRegistry:Put('mpm':u,'application/vnd.blueice.multipass':u).
        poRegistry:Put('mpn':u,'application/vnd.mophun.application':u).
        poRegistry:Put('mpp':u,'application/vnd.ms-project':u).
        poRegistry:Put('mpt':u,'application/vnd.ms-project':u).
        poRegistry:Put('mpv2':u,'video/mpeg2':u).
        poRegistry:Put('mpy':u,'application/vnd.ibm.minipay':u).
        poRegistry:Put('mqy':u,'application/vnd.mobius.mqy':u).
        poRegistry:Put('mrc':u,'application/marc':u).
        poRegistry:Put('mrcx':u,'application/marcxml+xml':u).
        poRegistry:Put('ms':u,'text/troff':u).
        poRegistry:Put('mscml':u,'application/mediaservercontrol+xml':u).
        poRegistry:Put('mseed':u,'application/vnd.fdsn.mseed':u).
        poRegistry:Put('mseq':u,'application/vnd.mseq':u).
        poRegistry:Put('msf':u,'application/vnd.epson.msf':u).
        poRegistry:Put('msh':u,'model/mesh':u).
        poRegistry:Put('msi':u,'application/x-msdownload':u).
        poRegistry:Put('msl':u,'application/vnd.mobius.msl':u).
        poRegistry:Put('msty':u,'application/vnd.muvee.style':u).
        poRegistry:Put('mts':u,'model/vnd.mts':u).
        poRegistry:Put('mus':u,'application/vnd.musician':u).
        poRegistry:Put('musicxml':u,'application/vnd.recordare.musicxml+xml':u).
        poRegistry:Put('mvb':u,'application/x-msmediaview':u).
        poRegistry:Put('mwf':u,'application/vnd.mfer':u).
        poRegistry:Put('mxf':u,'application/mxf':u).
        poRegistry:Put('mxl':u,'application/vnd.recordare.musicxml':u).
        poRegistry:Put('mxml':u,'application/xv+xml':u).
        poRegistry:Put('mxs':u,'application/vnd.triscape.mxs':u).
        poRegistry:Put('mxu':u,'video/vnd.mpegurl':u).
        poRegistry:Put('n-gage':u,'application/vnd.nokia.n-gage.symbian.install':u).
        poRegistry:Put('n3':u,'text/n3':u).
        poRegistry:Put('nb':u,'application/mathematica':u).
        poRegistry:Put('nbp':u,'application/vnd.wolfram.player':u).
        poRegistry:Put('nc':u,'application/x-netcdf':u).
        poRegistry:Put('ncx':u,'application/x-dtbncx+xml':u).
        poRegistry:Put('nfo':u,'text/x-nfo':u).
        poRegistry:Put('ngdat':u,'application/vnd.nokia.n-gage.data':u).
        poRegistry:Put('nitf':u,'application/vnd.nitf':u).
        poRegistry:Put('nlu':u,'application/vnd.neurolanguage.nlu':u).
        poRegistry:Put('nml':u,'application/vnd.enliven':u).
        poRegistry:Put('nnd':u,'application/vnd.noblenet-directory':u).
        poRegistry:Put('nns':u,'application/vnd.noblenet-sealer':u).
        poRegistry:Put('nnw':u,'application/vnd.noblenet-web':u).
        poRegistry:Put('npx':u,'image/vnd.net-fpx':u).
        poRegistry:Put('nsc':u,'application/x-conference':u).
        poRegistry:Put('nsf':u,'application/vnd.lotus-notes':u).
        poRegistry:Put('ntf':u,'application/vnd.nitf':u).
        poRegistry:Put('nzb':u,'application/x-nzb':u).
        poRegistry:Put('oa2':u,'application/vnd.fujitsu.oasys2':u).
        poRegistry:Put('oa3':u,'application/vnd.fujitsu.oasys3':u).
        poRegistry:Put('oas':u,'application/vnd.fujitsu.oasys':u).
        poRegistry:Put('obd':u,'application/x-msbinder':u).
        poRegistry:Put('obj':u,'application/x-tgif':u).
        poRegistry:Put('oda':u,'application/oda':u).
        poRegistry:Put('odb':u,'application/vnd.oasis.opendocument.database':u).
        poRegistry:Put('odc':u,'application/vnd.oasis.opendocument.chart':u).
        poRegistry:Put('odf':u,'application/vnd.oasis.opendocument.formula':u).
        poRegistry:Put('odft':u,'application/vnd.oasis.opendocument.formula-template':u).
        poRegistry:Put('odg':u,'application/vnd.oasis.opendocument.graphics':u).
        poRegistry:Put('odi':u,'application/vnd.oasis.opendocument.image':u).
        poRegistry:Put('odm':u,'application/vnd.oasis.opendocument.text-master':u).
        poRegistry:Put('odp':u,'application/vnd.oasis.opendocument.presentation':u).
        poRegistry:Put('ods':u,'application/vnd.oasis.opendocument.spreadsheet':u).
        poRegistry:Put('odt':u,'application/vnd.oasis.opendocument.text':u).
        poRegistry:Put('oga':u,'audio/ogg':u).
        poRegistry:Put('ogg':u,'audio/ogg':u).
        poRegistry:Put('ogv':u,'video/ogg':u).
        poRegistry:Put('ogx':u,'application/ogg':u).
        poRegistry:Put('omdoc':u,'application/omdoc+xml':u).
        poRegistry:Put('onepkg':u,'application/onenote':u).
        poRegistry:Put('onetmp':u,'application/onenote':u).
        poRegistry:Put('onetoc':u,'application/onenote':u).
        poRegistry:Put('onetoc2':u,'application/onenote':u).
        poRegistry:Put('opf':u,'application/oebps-package+xml':u).
        poRegistry:Put('opml':u,'text/x-opml':u).
        poRegistry:Put('oprc':u,'application/vnd.palm':u).
        poRegistry:Put('org':u,'application/vnd.lotus-organizer':u).
        poRegistry:Put('osf':u,'application/vnd.yamaha.openscoreformat':u).
        poRegistry:Put('osfpvg':u,'application/vnd.yamaha.openscoreformat.osfpvg+xml':u).
        poRegistry:Put('otc':u,'application/vnd.oasis.opendocument.chart-template':u).
        poRegistry:Put('otf':u,'application/x-font-otf':u).
        poRegistry:Put('otg':u,'application/vnd.oasis.opendocument.graphics-template':u).
        poRegistry:Put('oth':u,'application/vnd.oasis.opendocument.text-web':u).
        poRegistry:Put('oti':u,'application/vnd.oasis.opendocument.image-template':u).
        poRegistry:Put('otp':u,'application/vnd.oasis.opendocument.presentation-template':u).
        poRegistry:Put('ots':u,'application/vnd.oasis.opendocument.spreadsheet-template':u).
        poRegistry:Put('ott':u,'application/vnd.oasis.opendocument.text-template':u).
        poRegistry:Put('oxps':u,'application/oxps':u).
        poRegistry:Put('oxt':u,'application/vnd.openofficeorg.extension':u).
        poRegistry:Put('p':u,'text/x-pascal':u).
        poRegistry:Put('p10':u,'application/pkcs10':u).
        poRegistry:Put('p12':u,'application/x-pkcs12':u).
        poRegistry:Put('p7b':u,'application/x-pkcs7-certificates':u).
        poRegistry:Put('p7c':u,'application/pkcs7-mime':u).
        poRegistry:Put('p7m':u,'application/pkcs7-mime':u).
        poRegistry:Put('p7r':u,'application/x-pkcs7-certreqresp':u).
        poRegistry:Put('p7s':u,'application/pkcs7-signature':u).
        poRegistry:Put('p8':u,'application/pkcs8':u).
        poRegistry:Put('pas':u,'text/x-pascal':u).
        poRegistry:Put('paw':u,'application/vnd.pawaafile':u).
        poRegistry:Put('pbd':u,'application/vnd.powerbuilder6':u).
        poRegistry:Put('pbm':u,'image/x-portable-bitmap':u).
        poRegistry:Put('pcap':u,'application/vnd.tcpdump.pcap':u).
        poRegistry:Put('pcf':u,'application/x-font-pcf':u).
        poRegistry:Put('pcl':u,'application/vnd.hp-pcl':u).
        poRegistry:Put('pclxl':u,'application/vnd.hp-pclxl':u).
        poRegistry:Put('pct':u,'image/pict':u).
        poRegistry:Put('pcurl':u,'application/vnd.curl.pcurl':u).
        poRegistry:Put('pcx':u,'image/x-pcx':u).
        poRegistry:Put('pdb':u,'application/vnd.palm':u).
        poRegistry:Put('pdf':u,'application/pdf':u).
        poRegistry:Put('pfa':u,'application/x-font-type1':u).
        poRegistry:Put('pfb':u,'application/x-font-type1':u).
        poRegistry:Put('pfm':u,'application/x-font-type1':u).
        poRegistry:Put('pfr':u,'application/font-tdpfr':u).
        poRegistry:Put('pfx':u,'application/x-pkcs12':u).
        poRegistry:Put('pgm':u,'image/x-portable-graymap':u).
        poRegistry:Put('pgn':u,'application/x-chess-pgn':u).
        poRegistry:Put('pgp':u,'application/pgp-encrypted':u).
        poRegistry:Put('pic':u,'image/pict':u).
        poRegistry:Put('pict':u,'image/pict':u).
        poRegistry:Put('pkg':u,'application/octet-stream':u).
        poRegistry:Put('pki':u,'application/pkixcmp':u).
        poRegistry:Put('pkipath':u,'application/pkix-pkipath':u).
        poRegistry:Put('plb':u,'application/vnd.3gpp.pic-bw-large':u).
        poRegistry:Put('plc':u,'application/vnd.mobius.plc':u).
        poRegistry:Put('plf':u,'application/vnd.pocketlearn':u).
        poRegistry:Put('pls':u,'audio/x-scpls':u).
        poRegistry:Put('pml':u,'application/vnd.ctc-posml':u).
        poRegistry:Put('png':u,'image/png':u).
        poRegistry:Put('pnm':u,'image/x-portable-anymap':u).
        poRegistry:Put('pnt':u,'image/x-macpaint':u).
        poRegistry:Put('portpkg':u,'application/vnd.macports.portpkg':u).
        poRegistry:Put('pot':u,'application/vnd.ms-powerpoint':u).
        poRegistry:Put('potm':u,'application/vnd.ms-powerpoint.template.macroenabled.12':u).
        poRegistry:Put('potx':u,'application/vnd.openxmlformats-officedocument.presentationml.template':u).
        poRegistry:Put('ppam':u,'application/vnd.ms-powerpoint.addin.macroenabled.12':u).
        poRegistry:Put('ppd':u,'application/vnd.cups-ppd':u).
        poRegistry:Put('ppm':u,'image/x-portable-pixmap':u).
        poRegistry:Put('pps':u,'application/vnd.ms-powerpoint':u).
        poRegistry:Put('ppsm':u,'application/vnd.ms-powerpoint.slideshow.macroenabled.12':u).
        poRegistry:Put('ppsx':u,'application/vnd.openxmlformats-officedocument.presentationml.slideshow':u).
        poRegistry:Put('ppt':u,'application/vnd.ms-powerpoint':u).
        poRegistry:Put('pptm':u,'application/vnd.ms-powerpoint.presentation.macroenabled.12':u).
        poRegistry:Put('pptx':u,'application/vnd.openxmlformats-officedocument.presentationml.presentation':u).
        poRegistry:Put('pqa':u,'application/vnd.palm':u).
        poRegistry:Put('prc':u,'application/x-mobipocket-ebook':u).
        poRegistry:Put('pre':u,'application/vnd.lotus-freelance':u).
        poRegistry:Put('prf':u,'application/pics-rules':u).
        poRegistry:Put('ps':u,'application/postscript':u).
        poRegistry:Put('psb':u,'application/vnd.3gpp.pic-bw-small':u).
        poRegistry:Put('psd':u,'image/vnd.adobe.photoshop':u).
        poRegistry:Put('psf':u,'application/x-font-linux-psf':u).
        poRegistry:Put('pskcxml':u,'application/pskc+xml':u).
        poRegistry:Put('ptid':u,'application/vnd.pvi.ptid1':u).
        poRegistry:Put('pub':u,'application/x-mspublisher':u).
        poRegistry:Put('pvb':u,'application/vnd.3gpp.pic-bw-var':u).
        poRegistry:Put('pwn':u,'application/vnd.3m.post-it-notes':u).
        poRegistry:Put('pya':u,'audio/vnd.ms-playready.media.pya':u).
        poRegistry:Put('pyv':u,'video/vnd.ms-playready.media.pyv':u).
        poRegistry:Put('qam':u,'application/vnd.epson.quickanime':u).
        poRegistry:Put('qbo':u,'application/vnd.intu.qbo':u).
        poRegistry:Put('qfx':u,'application/vnd.intu.qfx':u).
        poRegistry:Put('qps':u,'application/vnd.publishare-delta-tree':u).
        poRegistry:Put('qt':u,'video/quicktime':u).
        poRegistry:Put('qti':u,'image/x-quicktime':u).
        poRegistry:Put('qtif':u,'image/x-quicktime':u).
        poRegistry:Put('qwd':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('qwt':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('qxb':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('qxd':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('qxl':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('qxt':u,'application/vnd.quark.quarkxpress':u).
        poRegistry:Put('ra':u,'audio/x-pn-realaudio':u).
        poRegistry:Put('ram':u,'audio/x-pn-realaudio':u).
        poRegistry:Put('rar':u,'application/x-rar-compressed':u).
        poRegistry:Put('ras':u,'image/x-cmu-raster':u).
        poRegistry:Put('rcprofile':u,'application/vnd.ipunplugged.rcprofile':u).
        poRegistry:Put('rdf':u,'application/rdf+xml':u).
        poRegistry:Put('rdz':u,'application/vnd.data-vision.rdz':u).
        poRegistry:Put('rep':u,'application/vnd.businessobjects':u).
        poRegistry:Put('res':u,'application/x-dtbresource+xml':u).
        poRegistry:Put('rgb':u,'image/x-rgb':u).
        poRegistry:Put('rif':u,'application/reginfo+xml':u).
        poRegistry:Put('rip':u,'audio/vnd.rip':u).
        poRegistry:Put('ris':u,'application/x-research-info-systems':u).
        poRegistry:Put('rl':u,'application/resource-lists+xml':u).
        poRegistry:Put('rlc':u,'image/vnd.fujixerox.edmics-rlc':u).
        poRegistry:Put('rld':u,'application/resource-lists-diff+xml':u).
        poRegistry:Put('rm':u,'application/vnd.rn-realmedia':u).
        poRegistry:Put('rmi':u,'audio/midi':u).
        poRegistry:Put('rmp':u,'audio/x-pn-realaudio-plugin':u).
        poRegistry:Put('rms':u,'application/vnd.jcp.javame.midlet-rms':u).
        poRegistry:Put('rmvb':u,'application/vnd.rn-realmedia-vbr':u).
        poRegistry:Put('rnc':u,'application/relax-ng-compact-syntax':u).
        poRegistry:Put('roa':u,'application/rpki-roa':u).
        poRegistry:Put('roff':u,'text/troff':u).
        poRegistry:Put('rp9':u,'application/vnd.cloanto.rp9':u).
        poRegistry:Put('rpss':u,'application/vnd.nokia.radio-presets':u).
        poRegistry:Put('rpst':u,'application/vnd.nokia.radio-preset':u).
        poRegistry:Put('rq':u,'application/sparql-query':u).
        poRegistry:Put('rs':u,'application/rls-services+xml':u).
        poRegistry:Put('rsd':u,'application/rsd+xml':u).
        poRegistry:Put('rss':u,'application/rss+xml':u).
        poRegistry:Put('rtf':u,'application/rtf':u).
        poRegistry:Put('rtx':u,'text/richtext':u).
        poRegistry:Put('s':u,'text/x-asm':u).
        poRegistry:Put('s3m':u,'audio/s3m':u).
        poRegistry:Put('saf':u,'application/vnd.yamaha.smaf-audio':u).
        poRegistry:Put('sbml':u,'application/sbml+xml':u).
        poRegistry:Put('sc':u,'application/vnd.ibm.secure-container':u).
        poRegistry:Put('scd':u,'application/x-msschedule':u).
        poRegistry:Put('scm':u,'application/vnd.lotus-screencam':u).
        poRegistry:Put('scq':u,'application/scvp-cv-request':u).
        poRegistry:Put('scs':u,'application/scvp-cv-response':u).
        poRegistry:Put('scurl':u,'text/vnd.curl.scurl':u).
        poRegistry:Put('sda':u,'application/vnd.stardivision.draw':u).
        poRegistry:Put('sdc':u,'application/vnd.stardivision.calc':u).
        poRegistry:Put('sdd':u,'application/vnd.stardivision.impress':u).
        poRegistry:Put('sdkd':u,'application/vnd.solent.sdkm+xml':u).
        poRegistry:Put('sdkm':u,'application/vnd.solent.sdkm+xml':u).
        poRegistry:Put('sdp':u,'application/sdp':u).
        poRegistry:Put('sdw':u,'application/vnd.stardivision.writer':u).
        poRegistry:Put('see':u,'application/vnd.seemail':u).
        poRegistry:Put('seed':u,'application/vnd.fdsn.seed':u).
        poRegistry:Put('sema':u,'application/vnd.sema':u).
        poRegistry:Put('semd':u,'application/vnd.semd':u).
        poRegistry:Put('semf':u,'application/vnd.semf':u).
        poRegistry:Put('ser':u,'application/java-serialized-object':u).
        poRegistry:Put('setpay':u,'application/set-payment-initiation':u).
        poRegistry:Put('setreg':u,'application/set-registration-initiation':u).
        poRegistry:Put('sfd-hdstx':u,'application/vnd.hydrostatix.sof-data':u).
        poRegistry:Put('sfs':u,'application/vnd.spotfire.sfs':u).
        poRegistry:Put('sfv':u,'text/x-sfv':u).
        poRegistry:Put('sgi':u,'image/sgi':u).
        poRegistry:Put('sgl':u,'application/vnd.stardivision.writer-global':u).
        poRegistry:Put('sgm':u,'text/sgml':u).
        poRegistry:Put('sgml':u,'text/sgml':u).
        poRegistry:Put('sh':u,'application/x-sh':u).
        poRegistry:Put('shar':u,'application/x-shar':u).
        poRegistry:Put('shf':u,'application/shf+xml':u).
        poRegistry:Put('sid':u,'image/x-mrsid-image':u).
        poRegistry:Put('sig':u,'application/pgp-signature':u).
        poRegistry:Put('sil':u,'audio/silk':u).
        poRegistry:Put('silo':u,'model/mesh':u).
        poRegistry:Put('sis':u,'application/vnd.symbian.install':u).
        poRegistry:Put('sisx':u,'application/vnd.symbian.install':u).
        poRegistry:Put('sit':u,'application/x-stuffit':u).
        poRegistry:Put('sitx':u,'application/x-stuffitx':u).
        poRegistry:Put('skd':u,'application/vnd.koan':u).
        poRegistry:Put('skm':u,'application/vnd.koan':u).
        poRegistry:Put('skp':u,'application/vnd.koan':u).
        poRegistry:Put('skt':u,'application/vnd.koan':u).
        poRegistry:Put('sldm':u,'application/vnd.ms-powerpoint.slide.macroenabled.12':u).
        poRegistry:Put('sldx':u,'application/vnd.openxmlformats-officedocument.presentationml.slide':u).
        poRegistry:Put('slt':u,'application/vnd.epson.salt':u).
        poRegistry:Put('sm':u,'application/vnd.stepmania.stepchart':u).
        poRegistry:Put('smf':u,'application/vnd.stardivision.math':u).
        poRegistry:Put('smi':u,'application/smil+xml':u).
        poRegistry:Put('smil':u,'application/smil+xml':u).
        poRegistry:Put('smv':u,'video/x-smv':u).
        poRegistry:Put('smzip':u,'application/vnd.stepmania.package':u).
        poRegistry:Put('snd':u,'audio/basic':u).
        poRegistry:Put('snf':u,'application/x-font-snf':u).
        poRegistry:Put('so':u,'application/octet-stream':u).
        poRegistry:Put('spc':u,'application/x-pkcs7-certificates':u).
        poRegistry:Put('spf':u,'application/vnd.yamaha.smaf-phrase':u).
        poRegistry:Put('spl':u,'application/x-futuresplash':u).
        poRegistry:Put('spot':u,'text/vnd.in3d.spot':u).
        poRegistry:Put('spp':u,'application/scvp-vp-response':u).
        poRegistry:Put('spq':u,'application/scvp-vp-request':u).
        poRegistry:Put('spx':u,'audio/ogg':u).
        poRegistry:Put('sql':u,'application/x-sql':u).
        poRegistry:Put('src':u,'application/x-wais-source':u).
        poRegistry:Put('srt':u,'application/x-subrip':u).
        poRegistry:Put('sru':u,'application/sru+xml':u).
        poRegistry:Put('srx':u,'application/sparql-results+xml':u).
        poRegistry:Put('ssdl':u,'application/ssdl+xml':u).
        poRegistry:Put('sse':u,'application/vnd.kodak-descriptor':u).
        poRegistry:Put('ssf':u,'application/vnd.epson.ssf':u).
        poRegistry:Put('ssml':u,'application/ssml+xml':u).
        poRegistry:Put('st':u,'application/vnd.sailingtracker.track':u).
        poRegistry:Put('stc':u,'application/vnd.sun.xml.calc.template':u).
        poRegistry:Put('std':u,'application/vnd.sun.xml.draw.template':u).
        poRegistry:Put('stf':u,'application/vnd.wt.stf':u).
        poRegistry:Put('sti':u,'application/vnd.sun.xml.impress.template':u).
        poRegistry:Put('stk':u,'application/hyperstudio':u).
        poRegistry:Put('stl':u,'application/vnd.ms-pki.stl':u).
        poRegistry:Put('str':u,'application/vnd.pg.format':u).
        poRegistry:Put('stw':u,'application/vnd.sun.xml.writer.template':u).
        poRegistry:Put('sub':u,'text/vnd.dvb.subtitle':u).
        poRegistry:Put('sus':u,'application/vnd.sus-calendar':u).
        poRegistry:Put('susp':u,'application/vnd.sus-calendar':u).
        poRegistry:Put('sv4cpio':u,'application/x-sv4cpio':u).
        poRegistry:Put('sv4crc':u,'application/x-sv4crc':u).
        poRegistry:Put('svc':u,'application/vnd.dvb.service':u).
        poRegistry:Put('svd':u,'application/vnd.svd':u).
        poRegistry:Put('svg':u,'image/svg+xml':u).
        poRegistry:Put('svgz':u,'image/svg+xml':u).
        poRegistry:Put('swa':u,'application/x-director':u).
        poRegistry:Put('swf':u,'application/x-shockwave-flash':u).
        poRegistry:Put('swi':u,'application/vnd.aristanetworks.swi':u).
        poRegistry:Put('sxc':u,'application/vnd.sun.xml.calc':u).
        poRegistry:Put('sxd':u,'application/vnd.sun.xml.draw':u).
        poRegistry:Put('sxg':u,'application/vnd.sun.xml.writer.global':u).
        poRegistry:Put('sxi':u,'application/vnd.sun.xml.impress':u).
        poRegistry:Put('sxm':u,'application/vnd.sun.xml.math':u).
        poRegistry:Put('sxw':u,'application/vnd.sun.xml.writer':u).
        poRegistry:Put('t':u,'text/troff':u).
        poRegistry:Put('t3':u,'application/x-t3vm-image':u).
        poRegistry:Put('taglet':u,'application/vnd.mynfc':u).
        poRegistry:Put('tao':u,'application/vnd.tao.intent-module-archive':u).
        poRegistry:Put('tar':u,'application/x-tar':u).
        poRegistry:Put('tcap':u,'application/vnd.3gpp2.tcap':u).
        poRegistry:Put('tcl':u,'application/x-tcl':u).
        poRegistry:Put('teacher':u,'application/vnd.smart.teacher':u).
        poRegistry:Put('tei':u,'application/tei+xml':u).
        poRegistry:Put('teicorpus':u,'application/tei+xml':u).
        poRegistry:Put('tex':u,'application/x-tex':u).
        poRegistry:Put('texi':u,'application/x-texinfo':u).
        poRegistry:Put('texinfo':u,'application/x-texinfo':u).
        poRegistry:Put('text':u,'text/plain':u).
        poRegistry:Put('tfi':u,'application/thraud+xml':u).
        poRegistry:Put('tfm':u,'application/x-tex-tfm':u).
        poRegistry:Put('tga':u,'image/x-tga':u).
        poRegistry:Put('thmx':u,'application/vnd.ms-officetheme':u).
        poRegistry:Put('tif':u,'image/tiff':u).
        poRegistry:Put('tiff':u,'image/tiff':u).
        poRegistry:Put('tmo':u,'application/vnd.tmobile-livetv':u).
        poRegistry:Put('torrent':u,'application/x-bittorrent':u).
        poRegistry:Put('tpl':u,'application/vnd.groove-tool-template':u).
        poRegistry:Put('tpt':u,'application/vnd.trid.tpt':u).
        poRegistry:Put('tr':u,'text/troff':u).
        poRegistry:Put('tra':u,'application/vnd.trueapp':u).
        poRegistry:Put('trm':u,'application/x-msterminal':u).
        poRegistry:Put('tsd':u,'application/timestamped-data':u).
        poRegistry:Put('tsv':u,'text/tab-separated-values':u).
        poRegistry:Put('ttc':u,'application/x-font-ttf':u).
        poRegistry:Put('ttf':u,'application/x-font-ttf':u).
        poRegistry:Put('ttl':u,'text/turtle':u).
        poRegistry:Put('twd':u,'application/vnd.simtech-mindmapper':u).
        poRegistry:Put('twds':u,'application/vnd.simtech-mindmapper':u).
        poRegistry:Put('txd':u,'application/vnd.genomatix.tuxedo':u).
        poRegistry:Put('txf':u,'application/vnd.mobius.txf':u).
        poRegistry:Put('txt':u,'text/plain':u).
        poRegistry:Put('u32':u,'application/x-authorware-bin':u).
        poRegistry:Put('udeb':u,'application/x-debian-package':u).
        poRegistry:Put('ufd':u,'application/vnd.ufdl':u).
        poRegistry:Put('ufdl':u,'application/vnd.ufdl':u).
        poRegistry:Put('ulw':u,'audio/basic':u).
        poRegistry:Put('ulx':u,'application/x-glulx':u).
        poRegistry:Put('umj':u,'application/vnd.umajin':u).
        poRegistry:Put('unityweb':u,'application/vnd.unity':u).
        poRegistry:Put('uoml':u,'application/vnd.uoml+xml':u).
        poRegistry:Put('uri':u,'text/uri-list':u).
        poRegistry:Put('uris':u,'text/uri-list':u).
        poRegistry:Put('urls':u,'text/uri-list':u).
        poRegistry:Put('ustar':u,'application/x-ustar':u).
        poRegistry:Put('utz':u,'application/vnd.uiq.theme':u).
        poRegistry:Put('uu':u,'text/x-uuencode':u).
        poRegistry:Put('uva':u,'audio/vnd.dece.audio':u).
        poRegistry:Put('uvd':u,'application/vnd.dece.data':u).
        poRegistry:Put('uvf':u,'application/vnd.dece.data':u).
        poRegistry:Put('uvg':u,'image/vnd.dece.graphic':u).
        poRegistry:Put('uvh':u,'video/vnd.dece.hd':u).
        poRegistry:Put('uvi':u,'image/vnd.dece.graphic':u).
        poRegistry:Put('uvm':u,'video/vnd.dece.mobile':u).
        poRegistry:Put('uvp':u,'video/vnd.dece.pd':u).
        poRegistry:Put('uvs':u,'video/vnd.dece.sd':u).
        poRegistry:Put('uvt':u,'application/vnd.dece.ttml+xml':u).
        poRegistry:Put('uvu':u,'video/vnd.uvvu.mp4':u).
        poRegistry:Put('uvv':u,'video/vnd.dece.video':u).
        poRegistry:Put('uvva':u,'audio/vnd.dece.audio':u).
        poRegistry:Put('uvvd':u,'application/vnd.dece.data':u).
        poRegistry:Put('uvvf':u,'application/vnd.dece.data':u).
        poRegistry:Put('uvvg':u,'image/vnd.dece.graphic':u).
        poRegistry:Put('uvvh':u,'video/vnd.dece.hd':u).
        poRegistry:Put('uvvi':u,'image/vnd.dece.graphic':u).
        poRegistry:Put('uvvm':u,'video/vnd.dece.mobile':u).
        poRegistry:Put('uvvp':u,'video/vnd.dece.pd':u).
        poRegistry:Put('uvvs':u,'video/vnd.dece.sd':u).
        poRegistry:Put('uvvt':u,'application/vnd.dece.ttml+xml':u).
        poRegistry:Put('uvvu':u,'video/vnd.uvvu.mp4':u).
        poRegistry:Put('uvvv':u,'video/vnd.dece.video':u).
        poRegistry:Put('uvvx':u,'application/vnd.dece.unspecified':u).
        poRegistry:Put('uvvz':u,'application/vnd.dece.zip':u).
        poRegistry:Put('uvx':u,'application/vnd.dece.unspecified':u).
        poRegistry:Put('uvz':u,'application/vnd.dece.zip':u).
        poRegistry:Put('vcard':u,'text/vcard':u).
        poRegistry:Put('vcd':u,'application/x-cdlink':u).
        poRegistry:Put('vcf':u,'text/x-vcard':u).
        poRegistry:Put('vcg':u,'application/vnd.groove-vcard':u).
        poRegistry:Put('vcs':u,'text/x-vcalendar':u).
        poRegistry:Put('vcx':u,'application/vnd.vcx':u).
        poRegistry:Put('vis':u,'application/vnd.visionary':u).
        poRegistry:Put('viv':u,'video/vnd.vivo':u).
        poRegistry:Put('vob':u,'video/x-ms-vob':u).
        poRegistry:Put('vor':u,'application/vnd.stardivision.writer':u).
        poRegistry:Put('vox':u,'application/x-authorware-bin':u).
        poRegistry:Put('vrml':u,'model/vrml':u).
        poRegistry:Put('vsd':u,'application/vnd.visio':u).
        poRegistry:Put('vsf':u,'application/vnd.vsf':u).
        poRegistry:Put('vss':u,'application/vnd.visio':u).
        poRegistry:Put('vst':u,'application/vnd.visio':u).
        poRegistry:Put('vsw':u,'application/vnd.visio':u).
        poRegistry:Put('vtu':u,'model/vnd.vtu':u).
        poRegistry:Put('vxml':u,'application/voicexml+xml':u).
        poRegistry:Put('w3d':u,'application/x-director':u).
        poRegistry:Put('wad':u,'application/x-doom':u).
        poRegistry:Put('wav':u,'audio/x-wav':u).
        poRegistry:Put('wax':u,'audio/x-ms-wax':u).
        poRegistry:Put('wbmp':u,'image/vnd.wap.wbmp':u).
        poRegistry:Put('wbs':u,'application/vnd.criticaltools.wbs+xml':u).
        poRegistry:Put('wbxml':u,'application/vnd.wap.wbxml':u).
        poRegistry:Put('wcm':u,'application/vnd.ms-works':u).
        poRegistry:Put('wdb':u,'application/vnd.ms-works':u).
        poRegistry:Put('wdp':u,'image/vnd.ms-photo':u).
        poRegistry:Put('weba':u,'audio/webm':u).
        poRegistry:Put('webm':u,'video/webm':u).
        poRegistry:Put('webp':u,'image/webp':u).
        poRegistry:Put('wg':u,'application/vnd.pmi.widget':u).
        poRegistry:Put('wgt':u,'application/widget':u).
        poRegistry:Put('wks':u,'application/vnd.ms-works':u).
        poRegistry:Put('wm':u,'video/x-ms-wm':u).
        poRegistry:Put('wma':u,'audio/x-ms-wma':u).
        poRegistry:Put('wmd':u,'application/x-ms-wmd':u).
        poRegistry:Put('wmf':u,'application/x-msmetafile':u).
        poRegistry:Put('wml':u,'text/vnd.wap.wml':u).
        poRegistry:Put('wmlc':u,'application/vnd.wap.wmlc':u).
        poRegistry:Put('wmls':u,'text/vnd.wap.wmlscript':u).
        poRegistry:Put('wmlsc':u,'application/vnd.wap.wmlscriptc':u).
        poRegistry:Put('wmv':u,'video/x-ms-wmv':u).
        poRegistry:Put('wmx':u,'video/x-ms-wmx':u).
        poRegistry:Put('wmz':u,'application/x-msmetafile':u).
        poRegistry:Put('woff':u,'application/x-font-woff':u).
        poRegistry:Put('wpd':u,'application/vnd.wordperfect':u).
        poRegistry:Put('wpl':u,'application/vnd.ms-wpl':u).
        poRegistry:Put('wps':u,'application/vnd.ms-works':u).
        poRegistry:Put('wqd':u,'application/vnd.wqd':u).
        poRegistry:Put('wri':u,'application/x-mswrite':u).
        poRegistry:Put('wrl':u,'model/vrml':u).
        poRegistry:Put('wsdl':u,'application/wsdl+xml':u).
        poRegistry:Put('wspolicy':u,'application/wspolicy+xml':u).
        poRegistry:Put('wtb':u,'application/vnd.webturbo':u).
        poRegistry:Put('wvx':u,'video/x-ms-wvx':u).
        poRegistry:Put('x32':u,'application/x-authorware-bin':u).
        poRegistry:Put('x3d':u,'model/x3d+xml':u).
        poRegistry:Put('x3db':u,'model/x3d+binary':u).
        poRegistry:Put('x3dbz':u,'model/x3d+binary':u).
        poRegistry:Put('x3dv':u,'model/x3d+vrml':u).
        poRegistry:Put('x3dvz':u,'model/x3d+vrml':u).
        poRegistry:Put('x3dz':u,'model/x3d+xml':u).
        poRegistry:Put('xaml':u,'application/xaml+xml':u).
        poRegistry:Put('xap':u,'application/x-silverlight-app':u).
        poRegistry:Put('xar':u,'application/vnd.xara':u).
        poRegistry:Put('xbap':u,'application/x-ms-xbap':u).
        poRegistry:Put('xbd':u,'application/vnd.fujixerox.docuworks.binder':u).
        poRegistry:Put('xbm':u,'image/x-xbitmap':u).
        poRegistry:Put('xdf':u,'application/xcap-diff+xml':u).
        poRegistry:Put('xdm':u,'application/vnd.syncml.dm+xml':u).
        poRegistry:Put('xdp':u,'application/vnd.adobe.xdp+xml':u).
        poRegistry:Put('xdssc':u,'application/dssc+xml':u).
        poRegistry:Put('xdw':u,'application/vnd.fujixerox.docuworks':u).
        poRegistry:Put('xenc':u,'application/xenc+xml':u).
        poRegistry:Put('xer':u,'application/patch-ops-error+xml':u).
        poRegistry:Put('xfdf':u,'application/vnd.adobe.xfdf':u).
        poRegistry:Put('xfdl':u,'application/vnd.xfdl':u).
        poRegistry:Put('xht':u,'application/xhtml+xml':u).
        poRegistry:Put('xhtml':u,'application/xhtml+xml':u).
        poRegistry:Put('xhvml':u,'application/xv+xml':u).
        poRegistry:Put('xif':u,'image/vnd.xiff':u).
        poRegistry:Put('xla':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xlam':u,'application/vnd.ms-excel.addin.macroenabled.12':u).
        poRegistry:Put('xlc':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xlf':u,'application/x-xliff+xml':u).
        poRegistry:Put('xlm':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xls':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xlsb':u,'application/vnd.ms-excel.sheet.binary.macroenabled.12':u).
        poRegistry:Put('xlsm':u,'application/vnd.ms-excel.sheet.macroenabled.12':u).
        poRegistry:Put('xlsx':u,'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':u).
        poRegistry:Put('xlt':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xltm':u,'application/vnd.ms-excel.template.macroenabled.12':u).
        poRegistry:Put('xltx':u,'application/vnd.openxmlformats-officedocument.spreadsheetml.template':u).
        poRegistry:Put('xlw':u,'application/vnd.ms-excel':u).
        poRegistry:Put('xm':u,'audio/xm':u).
        poRegistry:Put('xml':u,'application/xml':u).
        poRegistry:Put('xo':u,'application/vnd.olpc-sugar':u).
        poRegistry:Put('xop':u,'application/xop+xml':u).
        poRegistry:Put('xpi':u,'application/x-xpinstall':u).
        poRegistry:Put('xpl':u,'application/xproc+xml':u).
        poRegistry:Put('xpm':u,'image/x-xpixmap':u).
        poRegistry:Put('xpr':u,'application/vnd.is-xpr':u).
        poRegistry:Put('xps':u,'application/vnd.ms-xpsdocument':u).
        poRegistry:Put('xpw':u,'application/vnd.intercon.formnet':u).
        poRegistry:Put('xpx':u,'application/vnd.intercon.formnet':u).
        poRegistry:Put('xsl':u,'application/xml':u).
        poRegistry:Put('xslt':u,'application/xslt+xml':u).
        poRegistry:Put('xsm':u,'application/vnd.syncml+xml':u).
        poRegistry:Put('xspf':u,'application/xspf+xml':u).
        poRegistry:Put('xul':u,'application/vnd.mozilla.xul+xml':u).
        poRegistry:Put('xvm':u,'application/xv+xml':u).
        poRegistry:Put('xvml':u,'application/xv+xml':u).
        poRegistry:Put('xwd':u,'image/x-xwindowdump':u).
        poRegistry:Put('xyz':u,'chemical/x-xyz':u).
        poRegistry:Put('xz':u,'application/x-xz':u).
        poRegistry:Put('yang':u,'application/yang':u).
        poRegistry:Put('yin':u,'application/yin+xml':u).
        poRegistry:Put('z':u,'application/x-compress':u).
        poRegistry:Put('Z':u,'application/x-compress':u).
        poRegistry:Put('z1':u,'application/x-zmachine':u).
        poRegistry:Put('z2':u,'application/x-zmachine':u).
        poRegistry:Put('z3':u,'application/x-zmachine':u).
        poRegistry:Put('z4':u,'application/x-zmachine':u).
        poRegistry:Put('z5':u,'application/x-zmachine':u).
        poRegistry:Put('z6':u,'application/x-zmachine':u).
        poRegistry:Put('z7':u,'application/x-zmachine':u).
        poRegistry:Put('z8':u,'application/x-zmachine':u).
        poRegistry:Put('zaz':u,'application/vnd.zzazz.deck+xml':u).
        poRegistry:Put('zip':u,'application/zip':u).
        poRegistry:Put('zir':u,'application/vnd.zul':u).
        poRegistry:Put('zirz':u,'application/vnd.zul':u).
        poRegistry:Put('zmm':u,'application/vnd.handheld-entertainment+xml':u).
    end method.
    
    /** Registers type for a key 
    
        @param character The key of the file extension to register
        @param character The mime type of the file content for a file with the extension
        @return logical True if the type was previously registered */
    method logical Put(input pcExtensionKey as character,
                       input pcMimeType as character):
        define variable lExists as logical no-undo.
        define buffer lbRegistry for Registry.
        
        Assert:NotNullOrEmpty(pcExtensionKey, 'Extension key':u).
        Assert:NotNullOrEmpty(pcMimeType, 'Mime type':u).
        
        assign lExists = can-find(lbRegistry where
                                  lbRegistry.ParentRegistry eq int64(this-object) and
                                  lbRegistry.ExtensionKey   eq pcExtensionKey         ).
        if lExists then        
            find lbRegistry where
                 lbRegistry.ParentRegistry eq int64(this-object) and
                 lbRegistry.ExtensionKey   eq pcExtensionKey.
        else
        do:
            create lbRegistry.
            assign lbRegistry.ParentRegistry = int64(this-object)
                   lbRegistry.ExtensionKey   = pcExtensionKey
                   this-object:Size          = this-object:Size + 1.
        end.
        
        assign lbRegistry.MimeType = pcMimeType.
        
        return lExists.                                       
    end method.
    
    /** Deregisters a content type writer 
    
        @param character The name of the content type to register
        @return logical True if the content type was previously registered */
    method logical Remove(input pcExtensionKey as character):
        define variable lExists as logical no-undo.
        define buffer lbRegistry for Registry.
        
        Assert:NotNullOrEmpty(pcExtensionKey, 'Extension key':u).
        
        assign lExists = can-find(lbRegistry where
                                  lbRegistry.ParentRegistry eq int64(this-object) and
                                  lbRegistry.ExtensionKey   eq pcExtensionKey         ).
        if lExists then        
            find lbRegistry where
                 lbRegistry.ParentRegistry eq int64(this-object) and
                 lbRegistry.ExtensionKey   eq pcExtensionKey.
        
        if lExists then
        do:
            delete lbRegistry.
            assign this-object:Size = this-object:Size - 1.
        end.
        
        return lExists.                                       
    end method.    

    /** Indicates whether a content type is registered or not. 
        
        @param character The name of the content type to register
        @return logical True if the content type is registered */
    method logical Has(input pcExtensionKey as character):
        define buffer lbRegistry for Registry.
        
        Assert:NotNullOrEmpty(pcExtensionKey, 'Extension key':u).
        
        return can-find(lbRegistry where
                        lbRegistry.ParentRegistry eq int64(this-object) and
                        lbRegistry.ExtensionKey   eq pcExtensionKey         ).
    end method.
    
    /** Returns a registered type, if it exists. returns null otherwise.
        
        @param character The name of the content type to register
        @return character A valid value if it exists. Null otherwise .*/
    method character Get(input pcExtensionKey as character):
        define buffer lbRegistry for Registry.
        
        Assert:NotNull(pcExtensionKey, 'Extension key':u).
        
        if can-find(lbRegistry where
                    lbRegistry.ParentRegistry eq int64(this-object) and
                    lbRegistry.ExtensionKey   eq pcExtensionKey         ) then
            find lbRegistry where
                 lbRegistry.ParentRegistry eq int64(this-object) and
                 lbRegistry.ExtensionKey   eq pcExtensionKey
                 no-error.
        
        if available lbRegistry then
            return lbRegistry.MimeType.
        
        return ?.
    end method.
    
    /** Clears all the entries from this registry */
    method public void Clear():
        define buffer lbRegistry for Registry.
        
        for each lbRegistry where lbRegistry.ParentRegistry eq int64(this-object):
            delete lbRegistry.
        end.
        assign this-object:Size = 0.
    end method.
    
    /** Returns an array of the file extensions types in this registry, for the given mime type.
        
        @param character The mime-type. ? and * = all; empty = application/octet-stream; otherwise the input value is used
        @return character[] The file extensions. Indeterminate array if empty. */
    method public character extent GetKeys(input pMimeType as character):
        define variable cKeys as character extent no-undo.
        define buffer lbRegistry for Registry.
        define query qryRegistry for lbRegistry.
        
        case pMimeType:
            when ?     or
            when '*':u then
                 open query qryRegistry preselect each lbRegistry.
            
            when '':u then
                open query qryRegistry preselect each lbRegistry where lbRegistry.MimeType eq 'application/octet-stream':u.
            
            otherwise
                open query qryRegistry preselect each lbRegistry where lbRegistry.MimeType eq pMimeType.
        end case.
        
        if query qryRegistry:num-results gt 0 then
            assign extent(cKeys) = query qryRegistry:num-results.
        
        get first qryRegistry.
        do while not query qryRegistry:query-off-end:
            assign cKeys[query qryRegistry:current-result-row] = lbRegistry.ExtensionKey.
            get next qryRegistry.
        end. 
        
        return cKeys.
        finally:
            close query qryRegistry.
        end finally.        
    end method.
    
    /** Returns an array of the key names in this registry.
        
        @return character[] The key values. Indeterminate array if empty. */
    method public character extent GetKeys():
        return GetKeys('*':u).
    end method.
    
end class.
