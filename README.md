# SPOC.FR – Code Presta 8.2 (themes/modules/override)

Flux créés:
- develop → déploiement auto sur build.spoc.fr
- preprod → déploiement auto sur preprod.spoc.fr
- tag vX.Y.Z sur main → déploiement prod (spoc.fr)

Déploiements: rsync + cache:clear/warmup + healthcheck.
Avec interdiction de supprimer le contenu des containers
