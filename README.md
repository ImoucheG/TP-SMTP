# Installation d’un serveur de messagerie

## Définition du besoin
Votre client veut voir mis en place un serveur de messagerie sécurisé. Pour des raisons de coûts, la distribution Debian a été choisie.
L’entreprise souhaite de votre part un prototype sur machine virtuelle.

## Contraintes
Pour s’intégrer dans son environnement, l’entreprise a choisi de mettre en place un serveur de messagerie avec les éléments suivants :
* [Postfix] comme serveur SMTP. Postfix est Open Source, rapide, sécurisé, fiable et sa 
configuration de base est abordable.
* [Postfixadmin] pour l'administration de notre seveur SMTP.
* [Dovecot] comme service de réception (POP3, POP3S, IMAP, IMAPS). La configuration de Dovecot est assez simple et Postfix s'appuiera sur Dovecot ou sur SASL pour le mécanisme d'authentification.
* Authentification SMTP pouvoir utiliser le serveur depuis l'extérieur du LAN.
* Envois d'emails en SMTPS, c'est à dire que les emails seront cryptés entre le poste de  travail et le serveur. C'est nécessaire si on utilise un ordinateur portable sur un réseau non sécurisé (hot spot wifi, etc.).
* Réception des emails en IMAPS et/ou POP3S, c'est à dire que les données seront cryptées entre le serveur et le poste de travail.
* Utilisation d'un annuaire LDAP pour la vérification des mots de passe.
* Protection contre les spams et les virus.
* Utilisation d'un webmail pour consulter les emails depuis une interface web.

## Documentation
La documentation complète, rédigée et mise en forme sera à rendre sous forme électronique.
Les différents fichiers de configuration sont attendu réunis dans une archive : paramétrage des services, adresse IP, comptes et mot de passe...

### Version
1.0.0

### Installation
```sh
$ cd /tmp/
$ git clone https://github.com/ImoucheG/TP-SMTP.git
$ cd TP-SMTP
$ chmod a+x setup.sh && ./setup.sh
```

### Todos
Coming soon.

### License
Apache

[postfix]: http://www.postfix.org/
[postfixadmin]: http://postfixadmin.sourceforge.net/
[dovecot]: http://www.dovecot.org/
