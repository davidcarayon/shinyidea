# Application R-Shiny HowTo

Ce projet template utilise un **format basic** d'une application R-Shiny.

Dans ce template on dispose de :

* [ui.R](ui.R) la partie interface
* [server.R](server.R) la partie serveur
* [global.R](global.R) les définitions globals
* [www/](www/) Répertoire pour les fichiers statics
* [Dockerfile.simple.rshiny](Dockerfile.simple.rshiny) pour générer l'image docker de l'application
* [.gitlab-ci.yml](.gitlab-ci.yml) gère l'intégration continue pour l'application

## Développement de l'application.

Compléter les fichiers ui.R, server.R et global.R .

### Merci d'ajouter les remerciements et hébergement par SK8

```
TODO code Rshiny
```

## Modification à apporter

### Le dockerfile

Ajouter dans le fichier [Dockerfile.simple.rshiny](Dockerfile.simple.rshiny) les packages R a utiliser (ainsi que les libraires systèmes necessaires).

Pour ajouter de nouveau fichier Rscript ou autres il faut les ajouter dans le build avec la commande *RUN ADD*.

## Pour récupérer l'image docker de mon application

```
## Connection au dépôt image docker si le projet est privée.
docker login -u <uid> -t <token_gitlab> registry.forgemia.inra.fr
## Téléchargement et instantiation du container (l'application) sur sa machine.
docker run -it -p 3838:3838 registry.forgemia.inra.fr/<Chemin du projet>:latest
```

Accès à l'application:  
https://localhost:3838

## Fonctionnement du pipeline d'intégration

L'accès au pipeline s'effectue via le menu de gauche (**CI/CD**).  
Le dernier pipeline activé (au dernier commit and push) est le premier de la liste.  
En cliquant sur le pipeline, on a accès à différentes actions.  
La mise à jour de l'image de l'application, et la mise a jour de l'application en ligne.  

## Problèmes / questions

Contact via une issue : [https://forgemia.inra.fr/sk8/sk8-support](https://forgemia.inra.fr/sk8/sk8-support/-/issues/new)  de préférence.  
Ou par email contact-sk8@groupe.renater.fr
