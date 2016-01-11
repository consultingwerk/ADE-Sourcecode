/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* t-q-eng.p - English language definitions for Query module */

{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-s AS INTEGER NO-UNDO.

IF qbf-s < 0 THEN RETURN.
qbf-lang = "".

IF qbf-s = 1 THEN
  ASSIGN
    qbf-lang[ 1] = 'T„ll„ ehdolla ei l”ytynyt yht„„n tietuetta.'
    qbf-lang[ 2] = 'Kaikki,Yhdiste,Osajoukko'
    qbf-lang[ 3] = 'Kaikki esill„,Alussa,Lopussa'
    qbf-lang[ 4] = 'T„ss„ taulussa ei ole lainkaan indeksej„.'
    qbf-lang[ 5] = 'Haluatko varmasti poistaa t„m„n tietueen?'
    qbf-lang[ 6] = '' /* special total message: created from #7 or #8 */
    qbf-lang[ 7] = 'Laskentaoperaatio keskeytyi.'
    qbf-lang[ 8] = 'Nyt selattavien tietueiden yhteism„„r„ on '
    qbf-lang[ 9] = 'Laskenta k„ynniss„...  Paina [' + KBLABEL("END-ERROR")
                 + '] lopetukseksi.'
    qbf-lang[10] = 'yht„ paljon kuin,v„hemm„n kuin,v„hemm„n tai yht„ paljon kuin,'
                 + 'enemm„n kuin,enemm„n tai yht„ paljon kuin,'
                 + 'erisuuri kuin,sopii "maskiin",alkaa'
    qbf-lang[11] = 'Tietueita ei l”ytynyt yht„„n selattavaksi.'
    qbf-lang[13] = 'Olet jo ensimm„isen tietueen kohdalla.'
    qbf-lang[14] = 'Olet jo viimeisen tietueen kohdalla.'
    qbf-lang[15] = 'Kyselylomakkeita ei ole viel„ m„„ritelty.'
    qbf-lang[16] = 'Kysely'
    qbf-lang[17] = 'Valitse lomake taulun kuvauksella, nimell„ tai ohjelmanimell„.' 
    qbf-lang[18] = 'Paina [' + KBLABEL("GO")
                 + '] tai [' + KBLABEL("RETURN")
                 + '] valitaksesi tai [' + KBLABEL("END-ERROR")
                 + '] lopettaaksesi.'
    qbf-lang[19] = 'Kyselylomaketta ladataan...'
    qbf-lang[20] = 'T„st„ ohjelmasta puuttuu k„„nnetty kyselylomake.  '
                 + 'Ongelmana voi olla:^1) PROPATH:sta puuttuu hakemisto,^2) ohjelma'
                 + 'tiedosto (.r) puuttuu, tai^3) ohjelmatiedosto on k„„nt„m„tt„.^(Tarkista '
                 + '<tietokanta>.ql-tiedostosta k„„nn”svirheet).^^Jatkaminen '
                 + 'voi johtaa my”hemp„„n virheilmoitukseen.  '
                 + 'Yrit„tk” jatkaa?'
    qbf-lang[21] = 'Kyselyss„ on WHERE-lauseke, jonka arvo m„„r„ytyisi ajo-'
                 + 'aikaisesti (RUN TIME).  T„t„ piirrett„ ei ole Kysely-'
                 + 'moduulissa.  Sivuutatko WHERE-lausekkeen ja jatkat?'
    qbf-lang[22] = 'Paina [' + KBLABEL("GET")
                 + '] selauskenttien vaihtamiseksi.'.

ELSE

IF qbf-s = 2 THEN
  ASSIGN
    qbf-lang[ 1] = '+,Seuraavaan tietueeseen.'
    qbf-lang[ 2] = '-,Edelliseen tietueeseen.'
    qbf-lang[ 3] = '<,Ensimm„iseen tietueeseen.'
    qbf-lang[ 4] = '>,Viimeiseen tietueeseen.'
    qbf-lang[ 5] = 'Uusi,Lis„t„„n uusi tietue.'
    qbf-lang[ 6] = 'Muuta,Muutetaan nyt lomakkeessa olevaa tietuetta.'
    qbf-lang[ 7] = 'Kopioi,Kopioidaan lomakkeessa oleva tietue uudeksi.'
    qbf-lang[ 8] = 'Poista,Poistetaaan nyt lomakkeessa oleva tietue.'
    qbf-lang[ 9] = 'Vaihda,Vaihdetaan toiseen kyselylomakkeeseen.' 
    qbf-lang[10] = 'Selaa,Valitaan tietue luetteloa selaamalla.' 
    qbf-lang[11] = 'Yhd,Yhdistet„„n viitetietueisiin.' 
    qbf-lang[12] = 'Etsi,Haetaan osajoukko kenttiin sy”tetyn esimerkin perusteella.' 
    qbf-lang[13] = 'Jossa,Tietueiden valintakriteerin (WHERE-lauseen) muokkaaminen.' 
    qbf-lang[14] = 'Lkm,Lasketaan tietueiden lukum„„r„ t„ss„ (osa)joukossa.' 
    qbf-lang[15] = 'Indeksi,Vaihdetaan k„ytett„v„„ lajitteluj„rjestyst„ (indeksi„).'
    qbf-lang[16] = 'R-moduuli,Siirryt„„n toiseen RESULTSin moduuliin.' 
    qbf-lang[17] = 'Tietoa,N„ytet„„n tietoja voimassa olevasta tilanteesta.' 
    qbf-lang[18] = 'Omat,Siirryt„„n itse tehtyihin valintoihin.' 
    qbf-lang[19] = 'X=Paluu,Palataan ylemm„lle valintatasolle.' 
    qbf-lang[20] = ''. /* terminator */

RETURN.
