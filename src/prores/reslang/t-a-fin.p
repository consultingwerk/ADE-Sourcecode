/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/* t-a-fin.p - Finnish language definitions for Admin module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

/*--------------------------------------------------------------------------*/
/*results.p,s-module.p*/
IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'K. Kyselyt'
    qbf-lang[ 2] = 'R. Raportit'
    qbf-lang[ 3] = 'T. Tarrat'
    qbf-lang[ 4] = 'S. Tiedon siirto'
    qbf-lang[ 5] = 'O. Omat'
    qbf-lang[ 6] = 'J. J„rj. hoito'
    qbf-lang[ 7] = 'X. Lopetus'
    qbf-lang[ 8] = 'F. FAST TRACK'
    qbf-lang[10] = 'Tiedostoa' /*DBNAME.qc*/
    qbf-lang[11] = 'ei l”ytynyt.  T„m„ edellytt„„ tietokannan RESULTS-'
                 + 'm„„ritysten uudelleen konfigurointia.  Teetk” sen nyt?'
    qbf-lang[12] = 'Valitse uusi moduuli, [' + KBLABEL("END-ERROR")
                 + ']-n„pp„imell„ pysyt t„ss„ moduulissa.'
    qbf-lang[13] = 'Et ole hankkinut RESULTS-tuotetta.  Ohjelma p„„ttyi.'
    qbf-lang[14] = 'Haluatko varmasti lopettaa istunnon "~{1~}" nyt?'
    qbf-lang[15] = 'MANUAAL.,P-AUTOM.,AUTOM.'
    qbf-lang[16] = 'Yht„„n tietokantaa ei ole kytketty istuntoon.'
    qbf-lang[17] = 'Toiminta ei onnistu tietokannalla, jonka looginen nimi '
                 + 'alkaa: "QBF$".'
    qbf-lang[18] = 'Lopetus'
    qbf-lang[19] = '** RESULTSilla tulkintavaikeuksia **^^Hakemistosta ~{1~} '
                 + 'ei l”ydy ~{2~}.db- eik„ ~{2~}.qc-tiedostoa.  ~{3~}.qc '
                 + 'l”ytyi PROPATH:sta, mutta se n„ytt„„ kuuluvan '
                 + '~{3~}.db:hen.  Korjaa hakemistot PROPATH:ssa tai poista/'
                 + 'nime„ toiseksi ~{3~}.db ja .qc.'
    /* 24,26,30,32 available if necessary */
    qbf-lang[21] = '         Kyselylomakkeiden tekemiseen on kolme tapaa '
                 + 'PROGRESS'
    qbf-lang[22] = '         RESULTSissa.  Joka kerralla voit manuaalisesti '
                 + 'muokata'
    qbf-lang[23] = '         RESULTSin kyselylomakkeita.'
    qbf-lang[25] = 'Voit manuaalisesti m„„r„t„ kunkin kyselylomakkeen.'
    qbf-lang[27] = 'Poimittuasi istuntoon kytketyist„ tietokannoista '
    qbf-lang[28] = 'haluamasi taulut, RESULTS tuottaa kyselylomakkeet '
    qbf-lang[29] = 'noille valituille tauluille.'
    qbf-lang[31] = 'RESULTS tuottaa kaikki kyselylomakkeet automaattisesti.'.


/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-user.p*/
IF qbf-s = 2 THEN
  /* format x(72) for 1,2,9-14,19-22 */
  ASSIGN
    qbf-lang[ 1] = 'Anna liitetiedoston (include) nimi, jota k„ytet„„n'
    qbf-lang[ 2] = 'Kysely-moduulissa Selaa-valinnassa.'
    qbf-lang[ 3] = '   Oletus-liitetiedosto:' /*format x(24)*/

    qbf-lang[ 8] = 'Ohjelmaa ei l”ydy'

    qbf-lang[ 9] = 'Anna kirjoittautumisohjelman nimi.  Ohjelma voi olla '
                 + 'vaikka '
    qbf-lang[10] = 'yksinkertainen logo tai t„ydellinen "login.p":n korvaava'
                 + ' ohjelma.'
    qbf-lang[11] = 'Login.p on "DLC"-hakemistossa.  Ohjelma k„ynnistyy, kun '
                 + '"signon"'
    qbf-lang[12] = '"-rivi luetaan DBNAME.qc-tiedostosta.'
    qbf-lang[13] = 'Anna tuotteen nimi, jos haluat sellaisen tulostuvan '
    qbf-lang[14] = 'p„„valikossa.'
    qbf-lang[15] = '    Sis„„nkirj. ohjelma:' /*format x(24)*/
    qbf-lang[16] = '          Tuotteen nimi:' /*format x(24)*/
    qbf-lang[17] = 'Oletukset:'

    qbf-lang[18] = 'Oma PROGRESS-ohjelma:'
    qbf-lang[19] = 'T„m„ ohjelma k„ynnistyy, kun "Omat"-vaihtoehto valitaan '
                 + 'jostain valikosta.'

    qbf-lang[20] = 'T„ll„ otetaan k„ytt””n itse tehty tiedonsiirto-ohjelma.'
    qbf-lang[21] = 'Sy”t„ sek„ ohjelman nimi ett„ sen kuvaus '
    qbf-lang[22] = '"Tiedon siirto - Muuta" valikossa.'
    qbf-lang[23] = 'Ohjelma:'
    qbf-lang[24] = 'Kuvaus:'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/*a-load.p:*/
IF qbf-s = 3 THEN
  ASSIGN
    /* menu strip for d-main.p,l-main.p,r-main.p */
    qbf-lang[ 1] = 'Hae,Otetaan esille aiemmin m„„ritelty ~{1~}.'
    qbf-lang[ 2] = 'Tall,Talletetaan esill„ oleva ~{1~}m„„rittely.'
    qbf-lang[ 3] = 'Aja,K„ynnistet„„n esill„ oleva ~{1~}ohjelma.'
    qbf-lang[ 4] = 'Valitse,Valitaan tarvittavat taulut ja kent„t.'
    qbf-lang[ 5] = 'Muuta,Muutetaan esill„ olevan m„„rityksen muotoa, layout:ia yms.'
    qbf-lang[ 6] = 'Jossa,Tietueiden valintakriteerien (WHERE-lauseen) muokkaaminen.'
    qbf-lang[ 7] = 'Laj,Muutetaan tulostettavien tietueiden lajitteluj„rjestyst„.'
    qbf-lang[ 8] = 'Poista,Poistetaan esill„ oleva tai muu m„„rittely.'
    qbf-lang[ 9] = 'Info,N„ytet„„n tietoja esill„ olevasta m„„rityksest„.'
    qbf-lang[10] = 'R-moduuli,Siirryt„„n toiseen RESULTSin moduuliin.'
    qbf-lang[11] = 'Omat,Siirryt„„n omiin valintoihin.'
    qbf-lang[12] = 'X=Paluu,Palataan ylemm„lle valikkotasolle.'
    qbf-lang[13] = '' /* terminator */
    qbf-lang[14] = 'siirto,tarra,raportti'

    qbf-lang[15] = 'Asetuksia ladataan...'

    /* system values for CONTINUE Must be <= 12 characters */
    qbf-lang[18] = '     Jatka' /* for error dialog box */
    qbf-lang[19] = 'Finnish' /* this name of this language */
    /* word "of" for "xxx of yyy" on scrolling lists */
    qbf-lang[20] = '/'
    /* standard product name */
    qbf-lang[22] = 'PROGRESS RESULTS'
    /* system values for descriptions of calc fields */
    qbf-lang[23] = ',Kumulat.summa,Prosentteja,Lukum„„r„,Teksti-lauseke,'
                 + 'Pvm-lauseke,Numeerinen,Looginen,Taulukko'
    /* system values for YES and NO.  Must be <= 8 characters each */
    qbf-lang[24] = ' Kyll„ ,  En  ' /* for yes/no dialog box */

    qbf-lang[25] = 'Automaattinen luonti oli k„ynniss„ ja keskeytyi.  '
                 + 'K„ynnistet„„nk” uudestaan?'

    qbf-lang[26] = '* VAROITUS - Versiot eiv„t t„st„„ *^^Nykyversio on '
                 + '<~{1~}> ja .qc-tiedoston versio on <~{2~}>.  Saattaa '
                 + 'tulla ongelmia siin„ vaiheessa, kun kyselylomakkeita '
                 + 'luodaan "Sovelluksen generoinnissa".'

    qbf-lang[27] = '* VAROITUS - Tietokannat puuttuvat *^^Seuraavat '
                 + 'tietokannat tarvittaisiin, muttei niihin ole yhteytt„:'

    qbf-lang[32] = '* VAROITUS - Tietokantaa muutettu *^^Tietokannan rakennetta '
                 + 'on muutettu siit„, kun viimeksi on tehty lomakkeita.  '
                 + 'Aja "Sovelluksen generointi" J„rjestelm„n hoito-valikosta '
                 + 'mahdollisimman pian.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-main.p */
IF qbf-s = 4 THEN
  ASSIGN
    qbf-lang[ 1] = " G. Sovelluksen generointi"
    qbf-lang[ 2] = " Q. Kyselylomakkeiden m„„ritykset"
    qbf-lang[ 3] = " R. Taulujen v„liset relaatiot"

    qbf-lang[ 4] = " H. Oman hakemiston sis„lt”"
    qbf-lang[ 5] = " X. RESULTSin p„„tt„minen"
    qbf-lang[ 6] = " M. Moduulien k„ytt”oikeudet"
    qbf-lang[ 7] = " O. Oikeudet kyselytoimintoihin"
    qbf-lang[ 8] = " L. Kirjoittautuminen / Tuote"

    qbf-lang[11] = " K. Kieli"
    qbf-lang[12] = " P. Tulostusten asetukset"
    qbf-lang[13] = " V. P„„tev„rien asetukset"

    qbf-lang[14] = " S. Kyselyjen selausohjelma"
    qbf-lang[15] = " D. Raporttien oletukset"
    qbf-lang[16] = " I. Itsem„„ritelty siirtomuoto"
    qbf-lang[17] = " T. Tarrakenttien tunnistus"
    qbf-lang[18] = " O. Omat-valinta"

    qbf-lang[21] = 'Valitse muutettava valikosta, [' + KBLABEL("END-ERROR")
                 + ']:ll„ muutokset tallentuvat.'
    /* these next four have a length limit of 20 including colon */
    qbf-lang[22] = 'Taulut:'
    qbf-lang[23] = 'Konfigurointi:'
    qbf-lang[24] = 'Suojaukset:'
    qbf-lang[25] = 'Moduulit:'

    qbf-lang[26] = 'J„rjestelm„n hoito'
    qbf-lang[27] = 'Versio'
    qbf-lang[28] = 'Asetuksia ladataan...'
    qbf-lang[29] = 'Haluatko varmasti luoda koko RESULTS-sovelluksen uudestaan?'
/* QUIT and RETURN are the PROGRESS keywords and cannot be translated */
    qbf-lang[30] = 'Kun k„ytt„j„ poistuu p„„valikosta, pit„isik” lopettaa '
                 + 'istunto (Quit) vai ohjelma (Return)?'
    qbf-lang[31] = 'Haluatko varmasti poistua J„rjestelm„n hoito-moduulista '
                 + 'nyt?'
    qbf-lang[32] = 'Tutkitaan asetukset ja talletetaan '
                 + 'tehdyt muutokset.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 5 THEN
  ASSIGN
/*a-perm.p, 1..7 also used by a-form.p and a-print.p*/
    qbf-lang[ 1] = 'K„ytt”luvat'
    qbf-lang[ 2] = '    *                   - K„ytt” sallittu kaikille.'
    qbf-lang[ 3] = '    <user>,<user>,etc.  - Sallittu vain mainituille.'
    qbf-lang[ 4] = '    !<user>,!<user>,*   - Sallittu kaikille paitsi '
                 + 'mainituille'
    qbf-lang[ 5] = '    acct*               - Sallittu vain k„ytt„jille, '
                 + 'jotka alkavat "acct"'
    qbf-lang[ 6] = 'Luettele k„ytt„j„t heid„n tunnuksillaan; erotinmerkki '
                 + 'on pilkku.'
    qbf-lang[ 7] = 'Tunnuksissa t„hti (*) korvaa kaikki merkit, huutomerkill„ '
                 + 'k„ytt” kiellet„„n.'
                   /* from 8 thru 13, format x(30) */
    qbf-lang[ 8] = 'Valitse moduuli vasemmalla'
    qbf-lang[ 9] = 'olevasta luettelosta ja'
    qbf-lang[10] = 'aseta sille k„ytt”luvat.'
    qbf-lang[11] = 'Valitse toiminto vasemmalla'
    qbf-lang[12] = 'olevasta luettelosta ja'
    qbf-lang[13] = 'aseta sille k„ytt”luvat.'
    qbf-lang[14] = 'Paina [' + KBLABEL("END-ERROR")
                 + '] kun p„„t„t muutosten teon.'
    qbf-lang[15] = 'Paina [' + KBLABEL("GO") + '] kun talletat, ['
                 + KBLABEL("END-ERROR") + '] kun perut muutokset.'
    qbf-lang[16] = 'Et voi kielt„„ itselt„si J„rjestelm„n hoitoa!'
/*a-print.p:*/     /*21 thru 26 must be format x(16) and right-justified */
    qbf-lang[21] = '      Alustukset'
    qbf-lang[22] = '                '
    qbf-lang[23] = 'Normaali tuloste'
    qbf-lang[24] = '     Tiivistetty'
    qbf-lang[25] = '       Paksunnos'
    qbf-lang[26] = '  Ei paksunnosta'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 6 THEN
  ASSIGN
/*a-write.p:*/
    qbf-lang[ 1] = 'Lataa moduulin asetuksia'
    qbf-lang[ 2] = 'Lataa v„riasetuksia'
    qbf-lang[ 3] = 'Lataa tulostusasetuksia'
    qbf-lang[ 4] = 'Lataa katseltavien taulujen luetteloa'
    qbf-lang[ 5] = 'Lataa taulujen v„listen relaatioiden luetteloa'
    qbf-lang[ 6] = 'Lataa postitarroihin valittavien kenttien luetteloa'
    qbf-lang[ 7] = 'Lataa kyselytoimintojen k„ytt”lupien luetteloaa'
    qbf-lang[ 8] = 'Lataa k„ytt„j„kohtaisia tietoja'
    qbf-lang[ 9] = 'Lataa raporttien oletustietoja'

/* a-color.p*/
                 /* 12345678901234567890123456789012 */
    qbf-lang[11] = '                    P„„tetyyppi:' /* must be 32 */
                 /* 1234567890123456789012345 */
    qbf-lang[12] = 'Valikko:        Normaali:' /* must be 25 */
    qbf-lang[13] = '              Korostettu:'
    qbf-lang[14] = 'Kysymyslomake:  Normaali:'
    qbf-lang[15] = '              Korostettu:'
    qbf-lang[16] = 'Selauslista:    Normaali:'
    qbf-lang[17] = '              Korostettu:'

/*a-field.p*/    /*"----- ----- ----- ----- ----"*/
    qbf-lang[30] = 'N„yt„?Muuta?Kysy? Selaa? J„r'
    qbf-lang[31] = 'Pit„„ olla v„lilt„ 1 -- 9999.'
    qbf-lang[32] = 'Haluatko tallettaa „sken tekem„si muutokset '
                 + 'taulujen luetteloon?'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
IF qbf-s = 8 THEN
/*a-label.p*/
  ASSIGN            /* 1..8 use format x(78) */
                    /* 1 and 8 are available for more explanation, in */
                    /*   case the translation won't fit in 2 thru 7.  */
    qbf-lang[ 2] = 'Sy”t„ kenttien nimet, joissa on osoitetiedot. '
                 + 'K„yt„ CAN-DO-muotoa.'
    qbf-lang[ 3] = '(Kentt„nimiss„ "*" tarkoittaa vaihtelevaa m„„r„„ '
                 + 'mit„ merkkej„ tahansa, '
    qbf-lang[ 4] = '"." tarkoittaa mit„ tahansa yht„ merkki„).  T„t„ '
                 + 'tietoa k„ytet„„n'
    qbf-lang[ 5] = 'postitustarrojen oletustietoina.  Ota huomioon, '
                 + 'ett„ jotkut tiedot'
    qbf-lang[ 6] = 'voivat tulla kahdesti - esim. jos aina talletat postitoi'
                 + 'mipaikan '
    qbf-lang[ 7] = 'ja postinumeron eri kenttin„, et tarvitse "Pt-Pn"-rivi„.'
                  /* each entry in list must be <= 5 characters long */
                  /* but may be any portion of address that is applicable */
                  /* in the target country */
    qbf-lang[ 9] = 'Nimi,Oso-1,Oso-2,Oso-3,Posti,P-nro,Pt-Pn,Maa,Lis-1,Lis-2'
    qbf-lang[10] = 'Kentt„ jossa on vastaanottajan nimi'
    qbf-lang[11] = 'Osoitteen ensimm„isen rivin kentt„ (esim. katuosoite)'
    qbf-lang[12] = 'Osoitteen toisen rivin kentt„ (esim. postilokero)'
    qbf-lang[13] = 'Osoitteen kolmas rivi (valinnainen, esim. jakoalue)'
    qbf-lang[14] = 'Postinumeron kentt„ '
    qbf-lang[15] = 'Postitoimipaikan kentt„'
    qbf-lang[16] = 'Yhdistetty kentt„: postinumero - postitoimipaikka'
    qbf-lang[17] = 'Kentt„, jossa on vastaanottajan maa'
    qbf-lang[18] = 'Valinnainen lis„kentt„'
    qbf-lang[19] = 'Valinnainen lis„kentt„'

/*a-join.p*/
    qbf-lang[23] = 'Taulusta itseen-yhdisteit„ ei viel„ sallita.'
    qbf-lang[24] = 'Maksimi m„„r„ yhdisterelaatiota saavutettu.'
    qbf-lang[25] = 'Relaatio, mist„' /* 25 and 26 are automatically */
    qbf-lang[26] = 'mihin'          /*   right-justified           */
    qbf-lang[27] = 'Sy”t„ WHERE tai OF-lause; tyhj„ksi j„tt” poistaa relaation)'
    qbf-lang[28] = 'Paina [' + KBLABEL("END-ERROR") + '] kun p„ivitys on valmis.'
    qbf-lang[30] = 'Lauseen pit„„ alkaa WHERE- tai OF-sanalla.'
    qbf-lang[31] = 'Sy”t„ relaation ensimm„inen taulu lis„tt„vksi tai poistettavaksi.'
    qbf-lang[32] = 'Sy”t„ sitten relaation toinen taulu.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-form.p */
IF qbf-s = 9 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' U. Uusi kyselylomake'
    qbf-lang[ 2] = ' M. Muuta kyselylomaketta '
    qbf-lang[ 3] = ' Y. Yleispiirteit„ '
    qbf-lang[ 4] = ' T. Toimintojen kentti„ '
    qbf-lang[ 5] = ' K. K„ytt”lupia '
    qbf-lang[ 6] = ' P. Poista kyselylomake '
    qbf-lang[ 7] = '  Valitse:' /* format x(10) */
    qbf-lang[ 8] = '    Muuta:' /* format x(10) */
                 /* cannot changed width of 9..16 from defined below */
    qbf-lang[ 9] = '      Tietokannan taulu' /* right-justify 9..14 */
    qbf-lang[10] = '       Lomakkeen tyyppi'
    qbf-lang[11] = 'Kyselyohjelman tiedosto'
    qbf-lang[12] = ' Lomakkeen tiedostonimi'
    qbf-lang[13] = '  Ohjelmatiedoston nimi'
    qbf-lang[14] = '                 Kuvaus'
    qbf-lang[15] = '(.p oletettu)    ' /* left-justify 15 and 16 */
    qbf-lang[16] = '(p.o. jatko-osa) '
    qbf-lang[18] = 'Lomake on ~{1~} rivi„ pitk„.  Koska RESULTS varaa '
                 + 'viisi rivi„ omaan k„ytt””ns„, t„m„ ylitt„„ 24x80 merkin '
                 + 'kuvaruudun koon.  Haluatko varmasti m„„ritell„ lomakkeen '
                 + 'koon n„in suureksi?'
    qbf-lang[19] = 'T„m„n niminen kyselyohjelma on jo olemassa.'
    qbf-lang[20] = 'T„m„n lomakkeen pit„isi jo olla olemassa tai nimen loppuun '
                 + 'tulee liitt„„ .f, niin se tuotetaaan automaattisesti.'
    qbf-lang[21] = '4GL-lomakkeen nimeksi ei voi ottaa varattua sanaa.  '
                 + 'Valitse joku toinen.'
    qbf-lang[22] = ' Valitse tarvittavat taulut '
    qbf-lang[23] = 'Paina [' + KBLABEL("END-ERROR") + '] kun p„ivitys on valmis'
    qbf-lang[24] = 'Kyselylomakkeen tietoja tallennetaan...'
    qbf-lang[25] = 'Olet muuttanut v„hint„„n yht„ kyselylomaketta.  Voit '
                 + 'joko k„„nt„„ muutetun lomakkeen nyt tai tehd„ '
                 + '"Sovelluksen generoinnin" my”hemmin. K„„nnet„„nk” nyt?'
    qbf-lang[26] = 'Kyselylomaketta "~{1~}" ei l”ydy.  Haluatko, ett„ '
                 + 'se luodaan?'
    qbf-lang[27] = 'Kyselylomake "~{1~}" on jo olemassa.  K„yt„ kentti„ t„st„ '
                 + 'lomakkeesta?'
    qbf-lang[28] = 'Haluatko varmasti poistaa kyselylomakkeen'
    qbf-lang[29] = '** Kyselyohjelma "~{1~}" poistettu. **'
    qbf-lang[30] = 'Kirjoittaa kyselylomaketta...'
    qbf-lang[31] = 'Kyselylomakkeiden maksimim„„r„ on saavutettu.'
    qbf-lang[32] = 'T„lle taululle ei voi luoda kyselylomaketta.^^Kyselylomakkeen '
                 + 'muodostamiseksi tietokannan t„ytyy tukea tietueosoittimia '
                 + '(RECID) tai taululla pit„„ olla yksiselitteinen indeksi.'.

/*--------------------------------------------------------------------------*/

ELSE

/*--------------------------------------------------------------------------*/
/* a-print.p */
IF qbf-s = 10 THEN
  ASSIGN           /* 1..6 format x(45) */
    qbf-lang[ 1] = ' U. Uusi tulostuslaite '
    qbf-lang[ 2] = ' M. Muuta tulostuslaitetta '
    qbf-lang[ 3] = ' Y. Laitteiden yleispiirteet '
    qbf-lang[ 4] = ' O. Kirjoittimien ohjausmerkit '
    qbf-lang[ 5] = ' K. Kirjoitinoikeudet '
    qbf-lang[ 6] = ' P. Poista tulostuslaite '
    qbf-lang[ 7] = '  Valitse:' /* format x(10) */
    qbf-lang[ 8] = '    Muuta:' /* format x(10) */
    qbf-lang[ 9] = 'V„hint„„n 256 mutta enemm„n kuin 0'
    qbf-lang[10] = 'Tyypin pit„„ olla term, thru, to, view, file, page tai prog'
    qbf-lang[11] = 'Tulostuslaitteiden maksimim„„r„ on saavutettu.'
    qbf-lang[12] = 'Vain "term"-laitetyyppi voi tulostaa p„„tteelle.'
    qbf-lang[13] = 'Ohjelman nime„ ei l”ydy PROPATH:n hakemistoista.'
                  /*17 thru 20 must be format x(16) and right-justified */
    qbf-lang[17] = 'Tulosteen kuvaus'
    qbf-lang[18] = '   Laitteen nimi'
    qbf-lang[19] = '   Maksimileveys'
    qbf-lang[20] = '          Tyyppi'
    qbf-lang[21] = 'katso alla'
    qbf-lang[22] = 'P„„tteelle, kuten OUTPUT TO TERMINAL PAGED'
    qbf-lang[23] = 'Laitteeseen, kuten OUTPUT TO PRINTER'
    qbf-lang[24] = 'UNIX tai OS/2 prosessille (THROUGH)'
    qbf-lang[25] = 'L„het„ tulostus tiedostoon, suorita sitten t„m„ ohjelma'
    qbf-lang[26] = 'Kysy k„ytt„j„lt„ tulostuksen kohdetiedoston nimi'
    qbf-lang[27] = 'Kuvaruudulle sivuttain selattavaksi'
    qbf-lang[28] = 'Kutsu 4GL-ohjelmaa tulostusvirran avaamiseksi/sulkemiseksi'
    qbf-lang[30] = 'Paina [' + KBLABEL("END-ERROR") + '] kun p„ivitys on valmis'
    qbf-lang[31] = 'V„hint„„n yksi tulostuslaite pit„„ olla!'
    qbf-lang[32] = 'Haluatko varmasti poistaa t„m„n tulostuslaitteen?'.

/*--------------------------------------------------------------------------*/

RETURN.
