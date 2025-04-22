---
title: "Høgnorskkjernen – nettbasert samskapingssystem"
description: >
  Dette dokumentet skildrar eit heilskapleg design for eit nettbasert samskapingssystem
  for Høgnorskkjernen. Systemet gjer det mogleg for språkinteresserte og maskinar å
  samarbeide om å byggje ei digital kjelde for høgnorsk språkdata (ordbok og grammatikk)
  på ein strukturert måte. Planen følgjer samskapingsprotokollen sine fem fasar – Såfrø,
  Spire, Greiner, Blomstring og Høsting – slik at utviklingsprosessen speglar naturleg vekst
  frå idé til ferdig produkt.
---

# 🖥️ Høgnorskkjernen – nettbasert samskapingssystem

## 📜 Beskrivelse
Dette dokumentet skildrar eit heilskapleg design for eit nettbasert samskapingssystem
for Høgnorskkjernen. Systemet gjer det mogleg for språkinteresserte og maskinar å
samarbeide om å byggje ei digital kjelde for høgnorsk språkdata (ordbok og grammatikk)
på ein strukturert måte. Planen følgjer samskapingsprotokollen sine fem fasar – Såfrø,
Spire, Greiner, Blomstring og Høsting – slik at utviklingsprosessen speglar naturleg vekst
frå idé til ferdig produkt.

---

## 🏷️ Fasane

### 🌱 Såfrø
**faseid:** `soafro`  
**Beskriving:** Initiativ og innsikt: Definerer rammene for prosjektet – filstruktur, dataskjema og kjelder – jordsmonnet der Høgnorskkjernen kan slå rot.

**Modul** 📄 `stig.jaml`  
- **Språk:** N/A  
- **Objektiv:**  
  - Etablere grunnstrukturen for prosjektet.  
  - Definere filstruktur og YAML‑skjema for språkdata (lemma, bøyingsformer m.m.).  
  - Leggje til rette for vidare modular ved å planta nødvendige filer og mapper.  
- **Avhengigheiter:**  
  - Ordredataskjema (YAML) for lemma, bøyingsformer, grammatikk, relasjonar  
  - Versjonskontroll (Git) for lagring av YAML-filer  
- **Datagropkartlegging:**  
  - **Krevst:** Definisjon av alle datatypar; sett med kjeldeordbøker  
  - **Manglar:** Fullstendig YAML‑skjema; unik ID for kvart lemma  
- **Kjelder:** ordbokene.no, ivaraasen.no, ordboki.no, norsk-ordbok.no, Høgnorsk ekspertkunnskap  
- **Implementasjonssteg:**  
  1. Opprett prosjektstruktur: `kjeldeflette/`, `yaml2cypher/`, `api/`, `frontend/`, `infra/`, `docs/`  
  2. Definer YAML‑skjema: `docs/lemma.yml`, `docs/forms.yml`, `docs/grammar.yml`, `docs/relations.yml`  
  3. Sett høgnorsk som kjerne, variantar under `fletting:`  
  4. Initialiser Git‑repo og legg til tomme filer/mapper  
  5. Dokumenter intensjonar i YAML‑filene  

---

### 🌿 Spire
**faseid:** `spire`  
**Beskriving:** Strukturell underdeling og grotid: Del opp i modular, hent inn rådata, transformer til felles format.

**Modul** 📄 `kjeldeflette.jaml`  
- **Språk:** Go + Python  
- **Objektiv:**  
  - Samle inn ordboksdata frå fleire kjelder og konvertere til felles YAML-format.  
  - Identifisere duplikat på tvers av kjelder med høgnorsk grunnform som fasit.  
- **Avhengigheiter:** HTTP‑klient, WARC‑verktøy, parser for HTML/XML/JSON, heuristisk flettemotor (Python)  
- **Datagropkartlegging:**  
  - **Krevst:** Rå HTML/XML, metadata, formateringsreglar  
  - **Manglar:** Felles unike ID-ar, oversikt over ekvivalentar, konsistente grammatikkmarkørar  
- **Kjelder:** WARC‑arkiv (`data/warc/`), offentlege API-ar/datadump, manuelle høgnorsk‑innspel  
- **Implementasjonssteg:**  
  1. Crawl og lagre rådata i WARC  
  2. Parse til AST → JSON/YAML  
  3. Konverter AST til YAML i tråd med `docs/lemma.yml`  
  4. Kjør flettemotor for duplikatdeteksjon  
  5. Prioriter høgnorsk, legg bokmålsvariantar under `fletting:`  
  6. Generer flettesuggesjonar og UI for godkjenning  
  7. Oppdater YAML og valider mot skjema  

---

### 🌳 Greiner
**faseid:** `greiner`  
**Beskriving:** Forgreining og tilpassing: Utvid funksjonaliteten parallelt – versjonskontroll, grafdatabase, API, nordisk normalisering.

- **Modul** 📄 `oppstig.jaml` (Python)  
  - **Objektiv:** Versjonskontroll av YAML‑filer; spore endringar med tidsstempel  
  - **Avhengigheiter:** Git, systemklokke, Git‑logg  
  - **Implementasjonssteg:** Oppdater schemas med dato, commit‑hook, endringslogg, test flyt  

- **Modul** 📄 `yaml2cypher.jaml` (Go)  
  - **Objektiv:** Konvertere YAML‑filer til Cypher‑spørringar for Neo4j  
  - **Avhengigheiter:** Neo4j Go‑driver, YAML‑parser  
  - **Implementasjonssteg:** Parse YAML → bygg Cypher → batch‑send til Neo4j → verifiser  

- **Modul** 📄 `api.jaml` (Go)  
  - **Objektiv:** HTTP API for CRUD på lemma med fletting og tilgangskontroll  
  - **Avhengigheiter:** Neo4j, Firebase Auth (JWT), Gin/net/http  
  - **Implementasjonssteg:** Definer endepunkt, JWT‑middleware, søk, historie, test roller  

- **Modul** 📄 `nordisk.jaml` (Python)  
  - **Objektiv:** Normalisere og flette nordiske variantar utan å endre kjernen  
  - **Avhengigheiter:** Eksterne ordboks‑APIar, omskrivingsreglar  
  - **Implementasjonssteg:** Hent nordiske data, match til høgnorsk, legg til under `fletting:`, valider  

---

### 🌸 Blomstring
**faseid:** `blomstring`  
**Beskriving:** Synleggjering og deling: Fruktene skal delast – frontend for brukarar, dokumentasjon for alle.

- **Modul** 📄 `frontend.jaml` (HTML/JS + Go‑template)  
  - **Objektiv:** Interaktivt søk, visning, inline redigering, sanntidsflettesuggesjonar  
  - **Avhengigheiter:** API, HTMX, CSS‑rammeverk, Firebase Auth UI  
  - **Implementasjonssteg:** Design UI, søkebar, trestruktur, HTMX‑redigering, SSE/websocket  

- **Modul** 📄 `forklar.jaml` (Markdown/JAMl)  
  - **Objektiv:** Leva handbok som dokumenterer modulane, historikk og retningslinjer  
  - **Avhengigheiter:** Alle .jaml-filer, sidegenerator, CC‑lisens  
  - **Implementasjonssteg:** Generer HTML frå .jaml, changelog‑side, forklar metaforikk, lisens  

---

### 🌾 Høsting
**faseid:** `hosting`  
**Beskriving:** Evaluering og nye frø: Hauste innsatsen, generer oppgåver, overvåk drift og så nye idéfrø.

- **Modul** 📄 `oppgåvesystem.jaml` (Go/Cloud Function)  
  - **Objektiv:** Identifisere hol i databasen og foreslå daglege oppgåver  
  - **Avhengigheiter:** API, notifikasjonssystem, poeng/badge‑system  
  - **Implementasjonssteg:** Definer oppgåvetypar, cron‑job, henta manglar, generer oppgåver, varsle, oppdater poeng  

- **Modul** 📄 `infra.jaml` (YAML/Docker/CI)  
  - **Objektiv:** Containerisering, CI/CD, overvaking og logging for stabil drift  
  - **Avhengigheiter:** Docker, Kubernetes, GitHub Actions, Prometheus & Grafana  
  - **Implementasjonssteg:** Skriv Dockerfile, Kubernetes‑manifester, CI/CD‑workflow, metrics‑/logging‑oppsett  

---

## 🔗 Systeminstruksjonar
- **Avhengighetskjede:**  
  - `stig → kjeldeflette → oppstig → yaml2cypher`  
  - `yaml2cypher → api → frontend`  
  - `api → oppgåvesystem`  
  - `alle → forklar`  
  - `infra` omsluttar alt  
- **Samhandling:**  
  1. `kjeldeflette` hentar orddatar (stig‑konfig) → YAML  
  2. `oppstig` merker endringar → metadata  
  3. `yaml2cypher` bygger graf i Neo4j  
  4. API nyttar graf/YAML for CRUD og fletting  
  5. Frontend viser og endrar i sanntid via API  
  6. `oppgåvesystem` finn manglar → oppgåver  
  7. `forklar` dokumenterer alle modulane  
  8. `infra` driftar, overvakar, gir tilbakemelding  
