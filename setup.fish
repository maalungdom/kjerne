#!/usr/bin/env fish
# setup-safe.fish – opprett struktur og skjelett‑YAML utan å overskrive README

# 1. Opprett hovudmappene om dei ikkje finst
set dirs kjeldeflette yaml2cypher api frontend infra docs
for d in $dirs
    if not test -d $d
        mkdir -p $d
        echo "📂 Oppretta mappe: $d"
    else
        echo "✅ Mappe finst: $d"
    end
end

# 2. Skjelett‑YAML i docs/ berre om filen ikkje finst
if not test -d docs
    mkdir docs
end

if not test -f docs/lemma.yml
    echo """# lemma.yml – definisjon av hovudobjektet “lemma”
id: string        # unik ID
ord: string       # Høgnorsk grunnform av ordet
bøyingar:        # Liste av bøyingsformer
  - form: string
    type: string  # t.d. “presens”, “preteritum”
definisjonar:
  - tekst: string  # Ordforklaring
    kjelde: string # Kjeldenamn
fletting:           # Eventuelle språkvariantar
  - språk: string   # t.d. “bokmål” eller “nynorsk”
    variant: string # Variant av grunnlemma
metadata:
  oppretta_dato: datetime
  endra_dato: datetime
""" > docs/lemma.yml
    echo "📄 Oppretta skjelett‑fil: docs/lemma.yml"
else
    echo "✅ Fil finst frå før: docs/lemma.yml"
end

if not test -f docs/forms.yml
    echo """# forms.yml – bøyingsformer
lemma_id: string
type: enum        # substantiv, verb, adjektiv…
form: string
metadata:
  oppretta_dato: datetime
  endra_dato: datetime
""" > docs/forms.yml
    echo "📄 Oppretta skjelett‑fil: docs/forms.yml"
else
    echo "✅ Fil finst frå før: docs/forms.yml"
end

if not test -f docs/grammar.yml
    echo """# grammar.yml – grammatikkreglar
rule_id: string
lemma_id: string
description: string
pattern: string
metadata:
  oppretta_dato: datetime
  endra_dato: datetime
""" > docs/grammar.yml
    echo "📄 Oppretta skjelett‑fil: docs/grammar.yml"
else
    echo "✅ Fil finst frå før: docs/grammar.yml"
end

if not test -f docs/relations.yml
    echo """# relations.yml – ordrelasjonar (synonym, antonym, osv.)
from_lemma: string
to_lemma: string
type: enum        # synonym, antonym, osv.
metadata:
  oppretta_dato: datetime
  endra_dato: datetime
""" > docs/relations.yml
    echo "📄 Oppretta skjelett‑fil: docs/relations.yml"
else
    echo "✅ Fil finst frå før: docs/relations.yml"
end

# 3. Legg til «Såfrø»-seksjon i README.md om ikkje funnen
if test -f README.md
    grep -q "## 🌱 Såfrø" README.md
    if test $status -ne 0
        echo """

## 🌱 Såfrø

Grunnstruktur for fase “Såfrø”:
- 📂 kjeldeflette/
- 📂 yaml2cypher/
- 📂 api/
- 📂 frontend/
- 📂 infra/
- 📂 docs/
  - 📄 lemma.yml
  - 📄 forms.yml
  - 📄 grammar.yml
  - 📄 relations.yml

""" >> README.md
        echo "✅ La til «Såfrø»-seksjon i README.md"
    else
        echo "✅ README.md inneheld allereie «Såfrø»-seksjonen"
    end
else
    echo "⚠️ Ingen README.md i rot – opprett gjerne sjølv"
end

# 4. Git‑commit (bare om nytt lagt til)
if test -d .git
    git add .
    git diff --cached --quiet
    if test $status -ne 0
        git commit -m "✨ Legg til struktur og skjelett‑YAML for Såfrø‑fasen utan å overskrive README"
        echo "✔️ Commit utført"
    else
        echo "ℹ️ Ingen nye endringar å committe"
    end
else
    echo "⚠️ Git‑repo ikkje initialisert – køyr 'git init' først om naudsynleg"
end
