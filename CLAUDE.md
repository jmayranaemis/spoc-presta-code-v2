# Contexte projet — SPOC.FR (Presta 8.2)

## Architecture
- Code PrestaShop 8.2 : themes / modules / override
- Déploiement via GitHub Actions (pas de push manuel serveur)

## Flux Git → environnements
- Push sur `develop`  → déploiement auto sur build.spoc.fr
- Push sur `preprod`  → déploiement auto sur preprod.spoc.fr
- Tag `vX.Y.Z` sur `main` → déploiement prod (spoc.fr)

## Méthode de déploiement (géré par les workflows, ne pas reproduire manuellement)
- rsync + cache:clear/warmup + healthcheck
- Workflows : .github/workflows/deploy-build.yml, deploy-preprod.yml, deploy-prod.yml

## Règles strictes
- INTERDICTION de supprimer le contenu des containers
- Ne jamais pousser directement sur `main` sans tag validé
- Toute modification de override/ doit être testée sur build avant preprod

## Consignes pour Claude Code
- Toujours demander confirmation avant un `git push`
- Ne jamais modifier les fichiers .github/workflows/*.yml sans validation explicite
- Travailler par petits commits clairs, un sujet = un commit

<!-- test migration Claude Code OK -->
