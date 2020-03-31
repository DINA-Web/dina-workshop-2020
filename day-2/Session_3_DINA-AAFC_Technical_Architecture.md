Tuesday March 31 2020

# Session 3 DINA-AAFC Technical Architecture

## Lessons learned from previous DINA years

* Separate modules vs Collaborative development on the same module
* Importance of API definition and process around it (TC Vote, approval process)
* Collaborative effort has an overhead (time/cost/complexity/communications). The gains should be worth it but there is a price to pay.

## AAFC guided tour through code bases

* Concepts
  * Microservices
  * Unified interface
* Object-Store API: https://github.com/AAFC-BICoE/object-store-api
* SeqDB API : https://github.com/AAFC-BICoE/seqdb-api
  * overlap with current SeqDB app and inherited complexity
* DINA UI: https://github.com/AAFC-BICoE/dina-ui/tree/dev
  * project technologies and structure

## Get the AAFC modules running on participants environment:

* Clone https://github.com/DINA-Web/dina-workshop-2020 repository
* Try DINA workshop 2020 [docker-compose](https://github.com/DINA-Web/dina-workshop-2020/tree/master/day-2/aafc-setup)
* Open 'day-2/aafc-setup/home.html'

## AAFC UI

* Unified UI
* AAFC requirements (Common look and feel, WCAG compliance)

## Automatic API documentation generation from JSON-Schema

* ObjectStore JSON Schema: https://github.com/DINA-Web/object-store-specs/tree/json-schema
* JSON Schema to ASCII doc: https://github.com/AAFC-BICoE/json-schema2adoc/tree/dev
* Result: https://dina-web.github.io/object-store-specs/

## API Guidelines

* Current guide: https://github.com/DINA-Web/guidelines/blob/master/DINA-Web-API-Guidelines.md
* GitHub issues with [workshop-2020 label](https://github.com/DINA-Web/guidelines/issues?q=is%3Aissue+is%3Aopen+label%3Aworkshop-2020)
* Discussion
  * UUID as module identifier - [description](https://github.com/DINA-Web/guidelines/issues/45)
  * Soft delete - [description](https://github.com/DINA-Web/guidelines/issues/46)
  * Inter-module reference/Differed referential integrity checks - [description](https://github.com/DINA-Web/guidelines/issues/48)
  * Global search index
