# North Pole Enterprises – company overview

North Pole Enterprises (NPE) designs, builds and delivers about 2 billion gifts a year. The season peaks between 1 and 24 December.

## Organisation

| Who | Role | Cares about |
|---|---|---|
| Santa Claus | CEO | Will every gift arrive on the 24th? Big numbers and a map. |
| Mrs. Claus | CFO & Head of Naughty-Nice Compliance | Delivery rate against the November baseline, the naughty/nice list, signing off "unknown" children |
| Pepper Minstix | Head Elf, Operations | Elf staffing, strikes, productivity, defect rates per workshop |
| Elf Union (ELFU) | Works council | Cookie rate, shift length |
| The Board | Reindeer union + Tooth Fairy | Weekly PDF report |

## Operations

- **8 workshops** build toys and dispatch sleighs. Each workshop serves one sales area (see `dim_workshop.serves`). Rovaniemi (W01) serves the Nordics, Reykjavik (W03) Western Europe and Tromso (W04) Central & Eastern Europe.
- **46 delivery regions** in 7 macro regions. The KPI target is a 95% delivery rate.
- **About 6,000 elves** in 7 departments. Roughly 60–70% of the European elves are union members.
- **8 reindeer teams**. Nordic Express (T01) is led by Rudolph, with Olive as backup lead.
- **Letters** arrive by post, email, chimney drop, the Santa app and mall scans. The format varies wildly per channel and country, and parsing them into wishes is still partly manual.

## KPIs on the Mission Control dashboard

| KPI | Definition | Target |
|---|---|---|
| Delivery rate | delivered gifts / planned gifts | ≥ 95% |
| Change vs baseline | delivery rate / November baseline − 1 | RED at −30% or worse, AMBER at −10% or worse |
| On-time rate | shipments delivered within 60 minutes of schedule | — |
| Absence rate | (sick + strike) / rostered elves | < 5% |
| Defect rate | rejected / built toys | < 3% |
| Nice share | children with behaviour score ≥ 70 | — |

## Known pain points (from the 2026 retro)

- The dbt models were built by a contractor elf who left in 2024. There's no documentation and hardly any tests.
- Santa calls Ops in a panic whenever the map turns red, and finding the cause means digging through four systems by hand.
- Business managers ask the BI team for every number. There's no self-service.
- Every dashboard request starts from a blank Tableau canvas.
