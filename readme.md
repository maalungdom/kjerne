Høgnorskkjernen – nettbasert samskapingssystem (Kvitbok)

Dette dokumentet skildrar eit heilskapleg design for eit nettbasert samskapingssystem for Høgnorskkjernen. Systemet gjer det mogleg for språkinteresserte og maskinar å samarbeide om å byggje ei digital kjelde for høgnorsk språkdata (ordbok og grammatikk) på ein strukturert måte. Planen følgjer samskapingsprotokollen sine fem fasar – Såfrø, Spire, Greiner, Blomstring og Høsting – slik at utviklingsprosessen speglar naturleg vekst frå idé til ferdig produkt. Kvar modul av systemet er spesifisert som ei pseudokode-basert .jaml-fil (JAMl-format), med mål om at ein utviklar seinare kan omsetje dei til faktisk kode. Kommentarar (#) er inkluderte for å forklare prosessar og symbolikk der det er naudsynt.

🟢 Såfrø – Initiativ og innsikt

I såfrø-fasen vert grunnidéen sådd og dei sentrale behova avklåra. Me definerer rammene for prosjektet – filstruktur, dataskjema og kjelder. Dette utgjer jordsmonnet der Høgnorskkjernen kan slå rot. Under finn du stig.jaml, som skildrar grunnstrukturen i prosjektet (filstruktur, dataskjema) og sikrar at Høgnorsk står i sentrum frå starten.

# Fil: stig.jaml
Programmeringsspråk: N/A  # Strukturell konfigurasjon (filsystem, YAML-manifest)
Objektiv: >
  Etablere grunnstrukturen for Høgnorskkjernen-prosjektet. Definerer filstruktur 
  og YAML-basert dataskjema for språkdata, med høgnorsk som kjerne. Legg til rette 
  for vidare modular ved å planta nødvendige filer og mapper.
Avhengigheiter:
  - "Ordredataskjema (YAML) for lemma, bøyingar, grammatikk, relasjonar"
  - "Versjonskontrollsystem (Git) for lagring av YAML-filer"
Datagropkartlegging:
  Kva data krevst:
    - Definisjon av alle datatypar: lemma, bøyingsformer, grammatikkreglar, relasjonar
    - Eit sett med kjeldeordbøker som skal integrerast (identifiserte domenekjelder)
  Kva data manglar:
    - Fullstendig YAML-skjema (manifest) som dekker alle felt for ordbokoppføringane
    - Unik ID eller nøkkel for kvart lemma på tvers av kjelder
  Kvar data må hentast frå:
    - Eksisterande ordbøker (t.d. ordbokene.no, ivaraasen.no, ordboki.no, norsk-ordbok.no) for å avgjera nødvendige felt
    - Høgnorsk ekspertkunnskap for å stadfeste kjernelemma og normative former
Implementasjonssteg:
  - "Opprett prosjektstruktur (mapper for kvar modul: `kjeldeflette/`, `yaml2cypher/`, `api/`, `frontend/`, `infra/`, `docs/` osv.)"
  - "Definer YAML-skjema (`docs/lemma.yml`, `docs/forms.yml`, `docs/grammar.yml`, `docs/relations.yml`) for å standardisera alle språkdata"
  - "Sett Høgnorsk som kjerne i skjema: kvar YAML-lemmafil representerer éi høgnorsk grunnform. Variantar (bokmål, dialekt, andre nordiske språk) skal leggjast under eit eige `fletting:` felt, utan å endre sjølve grunnlemma"
  - "Initialiser Git-repositorium for prosjektet og legg inn tomme YAML-filer/mapper i tråd med strukturen (klar for datafylling). Versjonskontroller alle manifest"
  - "Dokumenter intensjonar (#) i YAML-filene: forklar at Høgnorsk er primær norm, alle modellar og prosessar byggjer rundt høgnorsk språkform"

🔵 Spire – Strukturell underdeling og grotid

I spire-fasen begynner idéen å slå rot og strekkje seg mot lyset. Me deler opp oppgåvene i handterlege modular og startar innsamling og foredling av data. Eit solid grunnlag vert lagt ved å hente inn rådata frå kjeldene og transformere dei til det felles formatet. Nedenfor er kjeldeflette.jaml, hovudmodulen som handterer innhenting (webcrawling), parsing og samanlikning/fletting av kjeldedata til høgnorsk YAML. Denne modulen gjev spiren næring ved å fylle systemet med innhald.

# Fil: kjeldeflette.jaml
Programmeringsspråk: Go + Python  # Go for WARC-handsaming, Python for prototyping av heuristikk
Objektiv: >
  Samle inn ordboksdata frå fleire kjelder og konvertere dei til eit felles YAML-format 
  for Høgnorskkjernen. Identifisere duplikat eller tilsvarande oppføringar på tvers 
  av kjelder (fletting) med høgnorsk grunnform som fasit.
Avhengigheiter:
  - "Nettkjelder: ordbokene.no (bokmål, nynorsk), ivaraasen.no, ordboki.no, norsk-ordbok.no"
  - "Bibliotek: HTTP-klient for web crawling, WARC-verktøy for arkivering"
  - "Parser for kvart kjeldeformat (HTML/XML/JSON-spesifikke rutinar)"
  - "Heuristisk flettemotor (Python modul) for duplikatdeteksjon"
Datagropkartlegging:
  Kva data krevst:
    - Rå ordbokinnhald frå kvar nett-kjelde (HTML-sider, XML-API eller liknande)
    - Metadata per oppslagsord (definisjonar, bøyingsparadigme, kjeldenamn)
    - Reglar for bøying og formatering frå kjeldene (for å forstå data)
  Kva data manglar:
    - Felles unike ID-ar: Oppføringar frå ulike kjelder manglar kanskje ein felles identifikator for same lemma
    - Full oversikt over høgnorske ekvivalentar av bokmålsord (for fletting)
    - Konsistente markørar for grammatikk (t.d. kode for genus, tal, kasus) på tvers av kjelder
  Kvar data må hentast frå:
    - Råtekst/HTML frå nettsidene (via crawling) – lagrast lokalt som WARC-arkiv for sporbarheit
    - Eventuelle offentlege API-ar eller datadump’ar dersom tilgjengeleg (for betre kvalitet enn scraping)
    - Manuelle innspel: høgnorsk ekspertise for å avgjera om to oppføringar faktisk samsvarer
Implementasjonssteg:
  - "Crawl alle kjelder periodisk og lagre rådata (HTML/XML) i WARC-format lokalt (`data/warc/`). **(Røter)**"
  - "Parse kvar kjeldeformat: bygg parserfunksjonar som les WARC/HTML og trekk ut oppslagsord, tydingar, bøyingsinformasjon m.m., og eksporter til eit intermediært JSON/YAML-aktig AST. **(Stengel)**"
  - "Konverter AST til YAML i samsvar med skjema definert i `docs/lemma.yml` etc. Kvar oppslagsord frå kjelda blir til ein YAML-fil eller oppføring. Merk alle oppføringar med kjelde. **(Lauv)**"
  - "Køyr heuristisk flette-algoritme på tvers av nye YAML-oppføringar: samanlikn lemmatekst, definisjonsnøkkelord, bøyingstabellar for å finne potensielle duplikat/variantar."
  - "Prioriter høgnorsk ved fletting: om eit bokmålslemma tilsvarar eit høgnorsk lemma, knyt bokmålslemma inn under høgnorsk `fletting` i YAML. Endre aldri ei høgnorsk grunnform basert på andre variantar utan manuell godkjenning."
  - "Generer flettesuggesjonar: for kvar kandidatduplikat, lag eit forslag (t.d. som ei liste i ein logg eller database) som markerer: 'Ordet X (bm) kan flettast med X (hn)'."
  - "UI for manuell gjennomgang: Tilby eit enkelt grensesnitt (t.d. kommandolinja eller ein liten webside) der redaktørar kan gjennomgå flettesuggesjonane og godkjenne/avslå. **(⏳ Grotid)**"
  - "Når fletting er stadfesta: oppdater den relevante YAML-fila: legg til variantform under `fletting:`-feltet med referanse (kjeldenamn, kvalitetsindikator). Høgnorsk lemma forblir hovudnøkkel."
  - "Valider at den samanslåtte YAML-en er gyldig mot skjema (t.d. via JSON-schema-validering) før lagring i master-datasettet."

🟡 Greiner – Forgreining og tilpassing

I greiner-fasen veks prosjektet i fleire retningar samstundes, men alle delar same rot. Her utvidar me funksjonaliteten og tilpassar systemet for skalering og nye behov, samstundes som alt heng saman med den høgnorske kjernen. Parallelt med kvarandre implementerer me versjonskontroll for data, databasen for relasjonar, eit API for tilgang, og modular for utvida språkstøtte. Desse greinene styrkar treet utan å bryte med røtene.

Versjonskontrollmodulen (oppstig.jaml) sørgjer for historikk og sporbarheit i YAML-databasen. Konverteringsmotoren (yaml2cypher.jaml) lastar dataene inn i ein grafdatabase (Neo4j) for komplekse søk og relasjonar. Samstundes opnar me dataflyten utover ved å lage API-et (api.jaml) som eksterne tenester og frontend kan nytte. Til slutt i denne fasen introduserer me ein nordisk normaliseringsmodul (nordisk.jaml) for å flette inn andre nordiske språkvariantar – ei ekstra grein som opnar for breiare samarbeid, men alltid på høgnorsk sine premissar.

# Fil: oppstig.jaml
Programmeringsspråk: Python  # Lite script eller integrert modul for YAML-versjonering
Objektiv: >
  Handtere "oppstig" – versjonskontroll av språkdata på YAML-format. 
  Hald orden på endringar i kvar YAML-fil ved å leggje til historikk eller tidsstempel 
  i filene sine metadata, slik at ein kan spore utviklinga av kvart lemma over tid.
Avhengigheiter:
  - "Git for versjonskontroll av filer generelt (lagring av diffs over tid)"
  - "Intern datastruktur for å legge inn versjonsinfo (f.eks. `endra_dato` i YAML-header)"
  - "Dokumentasjonsmodul (`forklar.jaml`) for å beskrive endringshistorikk"
Datagropkartlegging:
  Kva data krevst:
    - Metadatafelt i YAML for versjon/dato (t.d. siste endringsdato, versjonsnummer)
    - Unik identifikator per endring (t.d. commit hash eller autogen ID for endring)
  Kva data manglar:
    - Automatisert måte å oppdatere desse felta kvar gong ei fil endrast (utan å gjere det manuelt)
    - Kopling mot eit sentralt endringslogg (om me vil ha oversikt over alle endringar i ei fil)
  Kvar data må hentast frå:
    - Systemklokke (for tidsstempel), miljøvariablar (kven som gjorde endringa)
    - Git-logg eller commit-meldingar kan nyttast som supplement for å hente ut endringsdetaljar
Implementasjonssteg:
  - "Utvid YAML-skjema: legg til felt som `oppretta_dato` og `endra_dato` i alle YAML-filer. Dette vert vår enkle versjonsindikator. **(Beskjæring av greiner som skal loggast)**"
  - "Implementer ein hook eller skript som køyrer ved kvar endring/commit: oppdater `endra_dato` i YAML-header automatisk til nåværande tidspunkt."
  - "Loggfør endringar: enten gjennom Git commits (som allereie fangar diff) eller ved å append’e ein enkel changelog-kommentar i fila (t.d. `# [2025-04-22] endra definisjon for X`)."
  - "Sørg for at `forklar.jaml`-modulen (dokumentasjon) kan lese desse metadata for å vise historikken til brukarar."
  - "Test versjonskontrollflyten: endre nokre YAML-filer for lemma, og kontroller at dato-felta oppdaterast korrekt og at Git-loggen fanger opp innhaldsendringane."

# Fil: yaml2cypher.jaml
Programmeringsspråk: Go  # For yting og integrasjon med Neo4j-driver
Objektiv: >
  Konvertere YAML-ordboksfiler til Cypher-spørringar for import i Neo4j grafdatabase. 
  Mogleggjer at alle lemma og relasjonar vert indekserte som noder/kanter for effektive søk 
  og analysar (t.d. finn alle synonymer, slektskap mellom ord, statistikk).
Avhengigheiter:
  - "Neo4j database (køyrande instans) med passende skjema for noder og relasjonar"
  - "Neo4j Go-driver (eller HTTP API) for å sende Cypher-spørringar"
  - "YAML-parser modul for å lese YAML-filene inn i Go-strukturar"
Datagropkartlegging:
  Kva data krevst:
    - Komplett sett av YAML-filer (lemma, inkludert alle felt som definisjonar, bøyingar, relasjonar)
    - Mapping/reglar for korleis kvart YAML-felt skal representerast i grafen (t.d. node-type for lemma, relasjonstype for synonym)
  Kva data manglar:
    - Evt. nøkkelord for relasjonstypar dersom ikkje definert (t.d. etikettar i grafen for ulike relasjonar må definerast)
    - Unike ID-ar for kvar node i grafen (bruk lemma-id eller generer nye dersom trong)
  Kvar data må hentast frå:
    - YAML-filene sjølve (inneheld all nødvendig informasjon for innhald)
    - Definisjon av graf-modell (må utleidast frå YAML-skjema: t.d. at `relasjonar` i YAML vert kantar i grafen)
Implementasjonssteg:
  - "Les alle YAML-filer frå lagringsområdet (f.eks. `data/lemma/` katalogen) og parse dei til interne datastrukturar."
  - "For kvart lemma-objekt, bygg tilsvarande Cypher CREATE/MERGE-setning:
      - Opprett node for lemma med eigenskapar (ord, språk, definisjonar, osv.).
      - Opprett node(r) for alle bøyingsformer eller grammatikkreglar om nødvendig, eller representer dei som eigenskapar."
  - "Opprett relasjonar mellom noder basert på YAML:
      - t.d. lemma -> synonym (RELTYPE: SYNONYM),
      - lemma -> avleiingar (RELTYPE: AVLEIDD),
      - lemma -> variant (RELTYPE: FLETTING, frå høgnorsk lemma til variant).
    Bruk Høgnorsk lemma som referansenode; andre variantar peikar til denne."
  - "Utfør batchede spørringar: send ei rekke med Cypher-setningar til Neo4j (for eksempel 500 om gongen) via Go-driveren for høg effektivitet."
  - "Verifiser at alle noder og relasjonar er oppretta: for eksempel, kør ein testspørring i Neo4j for å hente eit kjent lemma og sjå at relasjonane (synonym, variantar osv.) stemmer."

# Fil: api.jaml
Programmeringsspråk: Go  # Web-API med Go (Gin web framework eller net/http)
Objektiv: >
  Tilby eit HTTP API som gjev tilgang til dataene i Høgnorskkjernen. Mogleggjer søk, innsyn 
  og endringar (CRUD) av lemma i databasen, samt fletting av dublettar, med tilgangskontroll. 
  API-et er bindeleddet mellom frontend/brukarar og bakgrunnsdata (YAML/Neo4j).
Avhengigheiter:
  - "Neo4j-databasen (via yaml2cypher-data) for lese-/skriveoperasjonar"
  - "Firebase Authentication (JWT) for autentisering og rollestyring"
  - "Bibliotek: Web-framework (f.eks. Gin) og JWT-mellomvare"
  - "Andre .jaml-modular: `yaml2cypher.jaml` (data må vere lasta), `oppstig.jaml` (for å hente ev. historikk)"
Datagropkartlegging:
  Kva data krevst:
    - Tilgjengeleg grafdatabase med oppdaterte data (alle lemma-noder og relasjonar)
    - Brukaropplysningar for autentisering/autorisasjon (JWT-token med rolla til brukar)
    - Inndata frå klient (søkestringar, nye oppføringar eller flettingsforespørslar)
  Kva data manglar:
    - Reglar for kva slags søk som skal støttast (t.d. prefix-søk, fulltekst på definisjonar?)
    - Mekanisme for å handtere konfliktar når fleire oppdaterer same lemma (treng kanskje låsing eller versjonskontroll – kan hente info frå `oppstig`)
  Kvar data må hentast frå:
    - Innloggingssystemet (Firebase) for å verifisere brukarar sine token og roller
    - YAML-filene ved behov for rådata (kan hende enkelte endepunkt vil returnere rå YAML, elles hovudsakleg frå Neo4j)
    - Konfigurasjon for rollestyring (definisjon av kven som er skribent, redaktør, admin)
Implementasjonssteg:
  - "Set opp HTTP-server med nødvendige endepunkt:
      - GET `/lemma?q={søkeord}`: returner treff (lemma og ev. nøkkelinfo).
      - GET `/lemma/{id}`: detalj for eitt lemma (inkl. relasjonar, bøyingar).
      - POST `/lemma` (krever innlogging som *skribent*): opprett nytt lemma (tar JSON/YAML i body).
      - PUT `/lemma/{id}` (skribent eller betre): oppdater eksisterande lemma.
      - PUT `/lemma/{id}/merge` (redaktør/admin): flett saman variant inn i eit lemma (marker at lemma {id} absorberer annan oppføring)."
  - "Integrer Firebase JWT-autentisering:
      - Legg til middleware som validerer JWT-token på alle skrivande endepunkt.
      - Hent ut brukarrolle frå token (f.eks. custom claim eller mapping) og avgrens tilgang (t.d. berre admin kan slette eit lemma)."
  - "Søkefunksjonalitet:
      - Enkelt søk i Neo4j: f.eks. MATCH (l:Lemma) WHERE l.ord STARTS WITH '?' RETURN l.
      - Om nødvendig, supplementer med eit søkeindeks for rask fritekstsøk i definisjonar."
  - "Historikk-endepunkt:
      - GET `/lemma/{id}/history`: returner endringshistorikk for lemma (basert på `oppstig` data, t.d. liste av endringsdatoar og kven som gjorde det).
      - Dette gjev brukarar innsikt i kva som er endra (jamfør versjonskontrollmodulen)."
  - "Test API-et grundig:
      - Ulike brukarar (med JWT-ar for skribent, redaktør) prøver å lese/endre, verifiser at tilgangskontroll fungerer.
      - Prøv fletting via API: send PUT `/lemma/{id}/merge` med ein annan lemma-ID og sjå at dataene vert samanslått i databasen og YAML oppdatert."

# Fil: nordisk.jaml
Programmeringsspråk: Python  # Kan implementerast som eiga teneste eller script
Objektiv: >
  Normalisere og flette inn nordiske språkvariantar (dansk, svensk, færøysk, islandsk) 
  inn i Høgnorskkjernen sitt format. Denne modulens mål er å gjere det lett å utvide 
  databasen med beslekta språkdata utan å kompromittere høgnorsk som kjerne.
Avhengigheiter:
  - "Tilgang til eksterne nordiske ordboksressursar (API eller datafiler for da/sv/fo/is)"
  - "Regelsett for korleis nordiske ord kan tilpassast høgnorsk (f.eks. staveendringar, avleiingsmønster)"
  - "`kjeldeflette.jaml` (for gjenbruk av parser/flette-logikk på nye datakjelder)"
Datagropkartlegging:
  Kva data krevst:
    - Lister av ord og definisjonar frå dei nordiske språka vi støttar
    - Kartlegging av kva for høgnorsk lemma kvar utanlandsk ord svarar til (tilnærma oversetting/tilsvarande tyding)
    - Metadata om språk for kvar oppføring (slik at vi kan merke variantane korrekt)
  Kva data manglar:
    - Eit fullgodt system for automatisk å matche t.d. danske ord til høgnorsk – kan krevje språkvitar-hjelp eller semi-automatisk mapping
    - Støtte for spesielle teikn eller bøyingar som ikkje finst i høgnorsk (t.d. svensk pluralbøying) i datastrukturen
  Kvar data må hentast frå:
    - Offentlege termbaser eller ordbøker for kvart språk (statische datadump eller API)
    - Eksisterande oversetterverkty eller ordlister som koplar ord mellom språk (for innledande mapping)
Implementasjonssteg:
  - "Skaff nordiske data: last ned eller hent via API ordlister for dei aktuelle språka. Konverter dei til eit kompatibelt format (f.eks. JSON)."
  - "For kvart utanlandsk oppslagsord, prøv å finne tilsvarande høgnorsk lemma:
      - Bruk enkel nøkkel: same tyding og liknande skrivemåte, eller 
      - Språkspesifikke reglar (t.d. 'aa' -> 'å', svensk 'ä' -> 'e' etc.). **(🔄 Endre perspektiv)**"
  - "Dersom treff: legg den utanlandske varianten til som ein fletting under det høgnorske lemma (som ein ekstra variant med språklabel, i YAML-fila)."
  - "Dersom ikkje direkte treff:
      - **Opne for fleire stemmer:** Flagge desse tilfella for manuell gjennomgang av språkvitarar som kan avgjere om det finst eit samsvarande høgnorsk ord, eller om det må leggjast til som eit nytt lemma.
      - Opprett eventuelt nye lemma for ord som ikkje finst frå før, med merknad om opphavspråk. **(🌍 Opne for fleire stemmer)**"
  - "Køyr validering av heile YAML-dataset etter fletting, for å sikre at nye variantar ikkje brot på skjema eller konsistens (t.d. sjekk at kvar utanlandsk variant har ein referanse til eit høgnorsk ord)."
  - "Etter integrasjon: marker i systemet (t.d. i dokumentasjonen via `forklar.jaml`) at nordiske variantar er med, og at høgnorsk framleis er fasiten (dvs. vis kor fletting skjer berre som tillegg)."

🟠 Blomstring – Synleggjering og deling

I blomstringsfasen blømer prosjektet og vert synleg for omverda. No skal fruktene delast – me lagar eit brukargrensesnitt der alle kan sjå og bidra, og me sørgjer for god dokumentasjon. Frontend-appen gjev liv til dataene, medan dokumentasjon gjer kunnskapen tilgjengeleg. Under er frontend.jaml for den nettbaserte klienten og forklar.jaml for dokumentasjonsdelen.

# Fil: frontend.jaml
Programmeringsspråk: HTML/JS (HTMX) + Go-template  # Frontend som køyrer i nettlesar, server-side render
Objektiv: >
  Gjere Høgnorskkjernen sine data tilgjengelege og interaktive for brukarane gjennom eit 
  nettbasert grensesnitt. Frontenden lèt brukarar søkje i ordboka, sjå grammatikkgreiner 
  i ein oversiktleg struktur, samt bidra med endringar og fletting i sanntid (med 
  tilbakerapportering frå serveren).
Avhengigheiter:
  - "`api.jaml` – API-et som frontenden kallar for data"
  - "HTMX bibliotek for å handtere asynkrone oppdateringar utan full sideinnlasting"
  - "CSS/rammeverk for responsivt design (valfritt, kan bruke enkel CSS for å halde det lettvekt)"
  - "Autentisering (Firebase Auth UI) for innlogging av bidragsytarar"
Datagropkartlegging:
  Kva data krevst:
    - Endepunkta frå API-et (lista over søk, detaljdata for eit lemma, etc.)
    - Maler for visning av data (t.d. korleis ein lemma-post skal presenterast med alle detaljar)
    - Tilbakemeldingar på endringar (API svar som viser ny verdi etter redigering)
  Kva data manglar:
    - Brukartilpassa visning for dialektvariantar (kva om brukaren berre vil sjå høgnorsk vs. alle variantar?)
    - Full i18n/oversetting av grensesnittet (for no er alt på høgnorsk, men kanskje engelsk UI for internasjonale?)
  Kvar data må hentast frå:
    - API-kall (JSON/YAML) ved søk eller navigering
    - Lokale lagringsmekanismar for preferansar (t.d. cookie om brukaren vil filtrere ut visse variantar)
Implementasjonssteg:
  - "Design brukargrensesnittet:
      - Lag ei søkebar øvst for fritekstsøk i ord.
      - Vis søkeresultat som ei liste av lemma (grunnform) treff."
  - "Trestruktur-vising:
      - Når ein lemma er valt, vis full detalj: definisjon, bøyingsformer og tilknytte variantar/relasjonar.
      - Vis grammatikkreglar i ein hierarkisk trestruktur (lauv/greiner) for oversikt."
  - "Inline redigering:
      - For innlogga brukarar, gjer felta (definisjon, eksempel, etc.) redigerbare direkte i nettlesaren.
      - Bruk HTMX til å sende endringar (PATCH/PUT) til API-et og få oppdatert vising utan sideinnlasting."
  - "Flettesuggesjonar i UI:
      - Når API-et melder om potensielle duplikat (fletting), vis desse som notifikasjon eller modal.
      - Gje redaktørar moglegheit til å slå saman med eit klikk (som kallar API `/merge`)."
  - "Live-synk:
      - Implementer SSE eller websockets/HTMX-tricks slik at når nokon flettar eller endrar, ser andre brukarar det oppdatert umiddelbart (real-time oppdatering av dei viste dataene)."
  - "Test i ulike nettlesarar og skjermstorleikar for å sikre responsiv design og at alle interaktive funksjonar fungerer jamnt."

# Fil: forklar.jaml
Programmeringsspråk: Markdown/JAMl  # Dokumentasjon og manifestfiler
Objektiv: >
  Dokumentere systemet og gje innsikt i struktur og prosessar til alle bidragsytarar. 
  "Forklar" fungerer som ei levande handbok i JAMl-format: kvar funksjon og datastruktur 
  vert forklåra, og viktig historikk eller avgjersler vert loggført. Skal senke terskelen 
  for nye deltakarar og sikre kunnskapsdeling.
Avhengigheiter:
  - "Alle andre .jaml-filer (for innhald): forklaringsmodulen trekker inn objektiv, avhengigheiter osv. frå desse"
  - "Statisk sidegenerator eller portal for å vise JAMl/Markdown-filer på nett"
  - "Creative Commons-lisensdokument for innhaldslisensiering"
Datagropkartlegging:
  Kva data krevst:
    - Beskriving av kvar modul (formål, bruk) – finst i .jaml-filene som me utviklar (denne kvitboka fungerer òg som grunnlag)
    - Endringshistorikk (frå `oppstig.jaml`) for å dokumentere korleis data og funksjonar har utvikla seg
    - Bidragsreglar og retningsliner (for dei som skal bidra med data eller kode)
  Kva data manglar:
    - Samla oversikt over alle avgjersler tatt under utvikling (må skrives manuelt basert på erfaringane i prosjektet)
    - Eit systematisk format for å hente ut kommenterte delar av kode/spesifikasjon (kan delvis skriptast, delvis manuelt)
  Kvar data må hentast frå:
    - Utviklingsprosessen (designavgjersler, møtereferat – dersom nokon)
    - Git-historikk og `oppstig`-metadata for tekniske endringar
    - Samskapingsprotokollen for å halde språket og metaforane gjennomgåande i dokumentasjonen
Implementasjonssteg:
  - "Opprett ein `docs/` katalog som lagrar all dokumentasjon i Markdown eller JAMl format. Denne fila (kvitboka) inngår her."
  - "For kvar modul (.jaml-fil), lag ein seksjon i dokumentasjonen som automatisk kan hentast frå filene:
      - F.eks. generer ei HTML-side per .jaml-fil der felt som Objektiv, Datagropkartlegging osv. vert presentert pent. **(🎨 Formidling)**"
  - "Inkluder historikk: utvikle eit script som les YAML-header i alle lemma-filer og lagar ei endringsloggside (kven gjorde kva når). **(🪞 Spegling)**"
  - "Forklar symbolikk: dokumenter samanhengen mellom funksjonane og samskapingsmetaforane (frø, spire osv.) slik at bidragsytarar forstår den underliggjande filosofien."
  - "Lisensier innhaldet: Legg ved informasjon om at alt innhald og data er delt under Creative Commons BY-SA eller liknande fri lisens, slik at alle kan ta det i bruk fritt. **(🌼 Frø seg vidare)**"
  - "Publiser dokumentasjonen på nett (t.d. GitHub Pages eller liknande) og hald henne oppdatert når systemet utviklar seg vidare."

🔴 Høsting – Evaluering og nye frø

I høstingsfasen samlar me fruktene av arbeidet, evaluerer og legg grunnlag for nye syklusar. Systemet er no i drift, og me fokuserer på å hente ut verdi av det og leggje til rette for vidare vekst. Me etablerer eit oppgåvesystem (oppgåvesystem.jaml) som dagleg genererer dugnadsoppgåver – dette gjev fellesskapet høve til å bidra (dvs. me haustar innsatsen deira). Samstundes set me opp drift/infrastruktur (infra.jaml) for kontinuerleg drift, overvaking og forbetring av systemet. Innsiktene frå bruk og overvakning vert sådde attende som nye idéfrø for framtidige iterasjonar.

# Fil: oppgåvesystem.jaml
Programmeringsspråk: Go (cron-job eller Cloud Function)  # Kan integrerast i API-server
Objektiv: >
  Opprette eit system for dugnadsoppgåver som automatisk identifiserer "hol" i databasen 
  og foreslår daglege oppgåver til bidragsytarar. Målet er å halde engasjement oppe og 
  samstundes fylle inn manglande data (ei form for kontinuerleg hausting av kunnskap).
Avhengigheiter:
  - "Databasen (via API) for å finne manglar – t.d. lemma utan bøyingstabell, eller utan synonymer"
  - "`api.jaml` – for å poste nye oppgåver eller merknader (hvis API får endepunkt for oppgåver)"
  - "Notifikasjonssystem (epost, Discord webhook etc.) for å varsle om nye oppgåver (valfritt)"
  - "Poeng-/badgesystem for motivasjon (kun internt, ingen ekstra dataavhengigheit anna enn lagring av poeng)"
Datagropkartlegging:
  Kva data krevst:
    - Oversikt over alle lemma og deira status (komplett vs. ufullstendig data). Dette kan samlast via ein spørring til Neo4j eller ved å lese gjennom YAML-filene.
    - Reglar for prioritering: kva type manglar er mest kritiske? (f.eks. manglande bøyingsformer for vanlege ord)
    - Brukarinfo for aktive bidragsytarar (kven som skal få tildelt oppgåver, og eventuelt kor mykje dei har gjort frå før for poengutrekning)
  Kva data manglar:
    - Eit poengsystemdefinisjon (kor mange poeng per oppgåve, nivå etc., må designast)
    - Metadata i databasen som markerer at "dette lemma treng gjennomgang" (kan leggast til som eit felt eller eigen node-type under import)
    - Eventuell liste over "ferdige oppgåver" for å unngå duplikat eller gjentaking (treng lagring av oppgavelogg)
  Kvar data må hentast frå:
    - Spørringar mot Neo4j: f.eks. finn alle Lemma-noder der bøyingsfelt er tomt eller manglar bestemte former
    - YAML-filer (for kryssvalidering, t.d. om det finst lemma som ikkje er importert rett i grafen)
    - Brukaradministrasjonssystem (Firebase for å vite kven som er registrerte bidragsytarar)
Implementasjonssteg:
  - "Definer typar dugnadsoppgåver:
      - Legg til bøyingar for lemma som manglar det.
      - Verifiser fletting for kandidatar som framleis ikkje er godkjent.
      - Registrer nye synonymer/antonym der feltet er tomt.
    Prioriter desse og eventuelt lag ei kø."
  - "Lag ein plan for utsending:
      - Éi oppgåve per dag per brukar (justerbart). **(🔄 Kva lærte me?)**
      - Køyre som ein dagleg tidsstyrt jobb (cron) som tek ut ei oppgåveliste."
  - "Implementer henting av manglar:
      - Spørr Neo4j etter kriterier (t.d. MATCH (l:Lemma) WHERE l.bøyingar = [] RETURN l).
      - Alternativt, hald ein enkel oversikt i ein tabell `oppgaveTabell` (f.eks. i Firestore/NoSQL) som oppdaterast ved kvar endring i API."
  - "Generer oppgåver:
      - For kvart funn, konstruer ein oppgavetekst (t.d. 'Legg til bunden form for "#{lemma}"').
      - Registrer oppgåva i ein oppgavelogg (for historikk og unngå repetisjon for same lemma før det er løyst).
      - Tildel til ein aktiv bidragsytar (eventuelt roter ansvar eller la det vere åpent for alle)."
  - "Varsle og vis:
      - Send e-post eller anna varsel til utvalde bidragsytarar med dagens oppgåve.
      - Vis også oppgåva i frontend (eige 'Dugnad' seksjon) med knapp for å levere løysing."
  - "Belønn innsats:
      - Når ei oppgåve er utført (ny data sendt inn via API), oppdater bidragsstatistikk (f.eks. +1 poeng, kanskje vis leaderboard). **(🌾 Kva frø vil me så vidare?)**"
  - "Evaluer:
      - Med jamne mellomrom, gå gjennom oppgåvestatistikk: kva oppgåver vert gjort, kva står att? Juster prioriteringar for neste syklus med oppgåver. **(🏺 Lagre delar til seinare bruk)**"

# Fil: infra.jaml
Programmeringsspråk: YAML/Docker/CI  # Infrastruktur som kode (Dockerfile, Kubernetes YAML, CI-skript)
Objektiv: >
  Sikre stabil drift, skalering og vidare utvikling av systemet. Infrastrukturmodulen 
  dekkjer containerisering av alle tenester, oppsett av kontinuerlig integrasjon/utrulling, 
  samt overvaking og logging. Dette legg til rette for at systemet kan køyre døgnet rundt 
  og at utvikling/forbetringar kan høstast kontinuerleg.
Avhengigheiter:
  - "Docker - for å pakke kvar modul (API, frontend, flettemotor) inn i containerar"
  - "Kubernetes - kluster for å køyre containerane (med manifests for Deployment/Service/Ingress)"
  - "CI/CD-plattform (GitHub Actions) for automatisert bygging, testing og deploy"
  - "Overvakingssystem: Prometheus (metrikkinnsamling) og Grafana (dashboard) for innsikt"
Datagropkartlegging:
  Kva data krevst:
    - Docker-konfigurasjon for alle komponentar (base images, porteksponering, avhengigheiter)
    - Kubernetes-manifest som skildrar ønsket tilstand (antall replika, ressursar, nettverksoppsett)
    - CI-skript som definerer bygg/test/trigg steg for alle pushes til repoet
    - Metrikker å spore (f.eks. antal oppslag per tidsperiode, responstid for API, feilratar)
  Kva data manglar:
    - Detaljert driftslogg for feilsøking (må leggast til via logging-system, f.eks. Elasticsearch/Fluentd, om ein utvidar)
    - Definisjon av larmar (kva tersklar av ressursbruk eller feil skal utløse varsling til utviklarar)
    - Sikkerhetsnøklar og secret-håndtering for tenester (f.eks. Firebase private key) – må setjast i kluster som hemmeligheter, ikkje i koden
  Kvar data må hentast frå:
    - Utviklingsmiljøet: skrive Dockerfile basert på appane slik dei er utvikla (f.eks. Go-app med FROM golang:1.17 baseimage)
    - GitHub Actions marketplace for malar eller steg for bygg/test (yaml-konfigurasjon)
    - Prometheus-klientbibliotek integrert i Go-API for å eksportere metrikk (f.eks. teller for requests)
Implementasjonssteg:
  - "Skriv Dockerfile for kvar modul:
      - API: bygg Go-binæren, pakk den i ein liten image.
      - Frontend: statiske filer eller Go-template-server; pakkast tilsvarande.
      - Kjeldeflette: kan køyre som batch-jobb, men lag eigen container for å kunne køyre i kluster ved behov."
  - "Opprett Kubernetes manifest:
      - Deployment for API (replicas = 2 for høg tilgjengeligheit), Service for intern adressering, og Ingress for å eksponere API-et utad.
      - Deployment for frontend (evt. serve statisk via nginx container), Ingress for web.
      - CronJob for oppgåvesystemet (køyr dagleg).
      - ConfigMaps/Secrets for å legge inn konfig (f.eks. Firebase API-nøklar som secret)."
  - "Sett opp CI/CD (GitHub Actions):
      - Lag workflow yaml som på kvar push kjører: byggetestar for Go/Python, YAML-lint og schema-validering for datafiler, deretter bygger Docker-images.
      - Automatiser push av images til container registry.
      - Deploy til eit testing-miljø (staging) automatisk; for prod deploy kan det være manuell godkjenning."
  - "Overvaking:
      - Integrer Prometheus-klient i API-koden for å samle metrikkar (t.d. `/metrics` endepunkt med info).
      - Kjør Prometheus i kluster for å scrape desse metrikkane.
      - Set opp Grafana med dashboard som visualiserer viktige metrikkar: trafikk, responstid, antall nye lemma per dag, osb. **(🔄 Kva fungerte?)**"
  - "Logging og alarmar:
      - Sørg for at konteinarane sine loggar blir samla (enten via Kubernetes logging eller ekstern loggtjeneste).
      - Definer alert-reglar i Prometheus (t.d. dersom API ikkje svarer, eller ingen nye oppdateringar på X dagar – dette kan indikere problem i dugnadsflyten)."
  - "Regelmessig evaluering:
      - Gjennomgå overvakinga for å identifisere flaskehalsar eller områder å forbedre (t.d. dersom få bidrag kjem inn via oppgåvesystemet, vurdere endringar). 
      - Bruk denne innsikta til å planleggje neste iterasjon av utvikling – nye idéfrø for neste syklus."

🧵 Sy-instruks – samanstilling av systemet

For å sy saman alle modulane til eit heilskapleg system, definerer me ei overordna sy-instruks. Denne forklarar korleis dei ulike .jaml-filene (funksjonsmodulane) heng saman og kva rekkjefylgje dei typisk blir utført i. Sy-instruksen fungerer som ein samanføying av trådane – frå frø til ferdig plante – slik at utviklaren ser den store samanhengen.

# Fil: sy_instruks.jaml
system:
  fasar:
    Såfrø:
      - "stig.jaml – etablerer rotstrukturen (filsystem og skjema) for prosjektet"
    Spire:
      - "kjeldeflette.jaml – samlar inn og plantar data (YAML-filer) i den definerte strukturen"
    Greiner:
      - "oppstig.jaml – held styr på veksten (versjonering av data over tid)"
      - "yaml2cypher.jaml – fører næring (data) vidare inn i grafdatabasen for sterke samband"
      - "api.jaml – opnar stammen ut til omverda via eit API (tilgjengeleggjering av data internt og eksternt)"
      - "nordisk.jaml – tilpassar systemet nye greiner (fleire språkvariantar) utan å endre rota"
    Blomstring:
      - "frontend.jaml – gjer systemet synleg og vakkert for brukarane; interaktiv bløming av dataene"
      - "forklar.jaml – formidlar kunnskapen og sikrar at blomane (innsiktene) kan delast fritt (dokumentasjon & lisens)"
    Høsting:
      - "oppgåvesystem.jaml – sankar inn bidrag frå fellesskapet, slik at nye frø kan spire (fyller datagap og motiverer vidare dugnad)"
      - "infra.jaml – tek vare på heile økosystemet sitt helse; overvaker og legg til rette for at syklusen kan halde fram"
  avhengighetskjede:
    - "stig → kjeldeflette → oppstig → yaml2cypher"
    - "yaml2cypher → api → frontend"
    - "api → oppgåvesystem (for data om manglar)"
    - "alle → forklar (dokumentasjon trekker frå alle moduler)"
    - "infra omsluttar heile systemet for å køyre og overvake det i fellesskap"
  samhandling:
    - "Kjeldeflette-modulen hentar ord og lagrar som YAML (definert av Stig)."
    - "Oppstig merker kvar YAML-endring med dato, for historikk."
    - "Yaml2cypher les YAML og byggjer grafstruktur i Neo4j."
    - "API-et nyttar Neo4j (og ved behov YAML) for å svare på søk og endringsoperasjonar, med autentisering."
    - "Frontend-klienten brukar API-et for å vise og endre data i sanntid."
    - "Oppgåvesystemet køyrer via API-et for å finne manglar og registrere oppgåveløysingar."
    - "Forklar-modulen samlar trådane: dokumenterer kvar del og gjev oversyn til brukarane av korleis alt heng saman."
    - "Infra-modulen syter for at alle komponentane ovanfor køyrer stabilt saman, og gir tilbakemelding (metrikkar) for kontinuerleg læring."

Samandrag: Gjennom desse fem fasane og tilhøyrande modular har me bygd eit robust, skalerbart økosystem der høgnorsk språkdata er i fokus, og alle prosessar frå innsanking til deling følgjer ein naturleg syklus. Frå Såfrø (planlegging av struktur) via Spire (innhenting og konvertering), Greiner (parallelle utvidingar), Blomstring (brukargrensesnitt og deling) til Høsting (evaluering og fellesskapsdugnad), kvar del av systemet er beskrive i JAMl-format slik at ein utviklar kan ta kvar .jaml-spesifikasjon og implementere den i kode. Resultatet er eit levande samskapingssystem for Høgnorskkjernen – der kvar bidragsytar kan vere med og foredle språket vårt, og kvar syklus med utvikling etterlet seg nye frø for komande generasjonar av funksjonar og data. Vi har med dette lagt grunnlaget for språkleg fridom i digital form, der høgnorsk står som den einskilde sanningskjelda og alt anna finn sin plass rundt han. Lukke til med den vidare veksten! 🌱🚀
