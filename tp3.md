# I. Utilisateurs

- [I. Utilisateurs](#i-utilisateurs)
  - [1. Liste des users](#1-liste-des-users)
  - [2. Hash des passwords](#2-hash-des-passwords)
  - [3. Sudo](#3-sudo)
    - [A. Intro](#a-intro)
    - [B. Practice](#b-practice)

## 1. Liste des users

La liste des utilisateurs qui existent sur le système est contenue dans un fichier : le fichier `/etc/passwd`.

Le fichier `/etc/passwd` est structuré comme suit :

- chaque ligne concerne un utilisateur
- chaque ligne contient plusieurs informations
  - c'est comme un tableau la structure de ce fichier
  - les colonnes de chaque ligne sont indiquées par le caractère `:`

🌞 **Afficher la ligne du fichier qui concerne votre utilisateur**

sudo cat /etc/passwd | grep ms379

🌞 **Afficher la ligne du fichier qui concerne votre utilisateur ET celle de `root` en même temps**

sudo cat /etc/passwd | grep ms379, root

🌞 **Afficher la liste des groupes d'utilisateurs de la *machine***

- ptite recherche par vous-mêmes pour trouver quel fichier c'est !
- le même sous tous les OS Linux :)

---

Une *[commande](../../cours/memo/glossary.md#commande)* pratique pour faire de l'affichage de juste certains trucs c'est `cut` et c'est facile à utiliser.

`cut` permet de traiter une ligne comme un tableau :

- on lui indique un caractère qui sert de colonne avec `-d` (pour *delimiter*)
- et on lui indique quel numéro de colonne on veut récupérer avec `-f` (pour *field*)

Pour récupérer que les noms d'utilisateur en regardant le contenu du fichier `passwd` on peut donc :

```bash
# on indique à cut que le delimiter de nos colonnes c'est le caractère :
# et on veut récupérer que la première colonne : les noms d'utilisateurs !
cat /etc/passwd | cut -d":" -f1
```

Avec le fichier `passwd` c'est un cas d'école car il est naturellement structuré en forme de tableau avec le caractère `:` comme *delimiter* !

🌞 **Afficher la ligne du fichier qui concerne votre utilisateur ET celle de `root` en même temps**

- afficher uniquement le nom d'utilisateur et le chemin vers leur répertoire personnel (celui de votre utilisateur est dans `/home`, celui de `root` c'est `/root`)
- on peut demander à `cut` d'afficher plusieurs colonnes avec `-fx,y` où `x` et `y` sont les deux numéros de colonnes qu'on veut afficher
- mettez uniquement ces deux lignes en évidence

## 2. Hash des passwords

Le *hash* des mots de passe des utilisateurs est stocké dans un fichier aussi : le fichier `/etc/shadow`.

🌞 **Afficher la ligne qui contient le hash du mot de passe de votre utilisateur**

sudo cat /etc/shadow | grep ms379

## 3. Sudo

### A. Intro

**La *commande* `sudo` (*switch user do*) permet d'exécuter une *commande* en tant qu'un autre utilisateur** (c'est dans le nom *switch user do* pour "changer d'utilisateur et faire un truc").

La syntaxe :

```bash
# la tête de la ligne c'est
sudo -u USER COMMAND

# pour qu'on exécute la commande COMMANDE
# sous l'identité de l'utilisateur USER

# par exemple
sudo -u toto ls /etc
# exécute la commande ls /etc en tant que toto
```

On l'utilise généralement pour exécuter une *commande* en tant que `root` sans se connecter directement en tant que `root`, ce qui est utile pour faire des tâches d'administration qui demandent les droits de `root`.

> *Par exemple, installer des paquets avec une comande `apt install`, ça demande les privilèges de `root`.*

On l'utilise tellement souvent pour exécuter une commande en tant que  `root` (et pas quelqu'un d'autre) que si on précise pas d'utilisateur avec `-u`, c'est `root`  par défaut qui sera utilisé !

> *Donc taper `sudo ls` c'est pareil que `sudo -u root ls` et ça fait économiser pas mal de caractères à taper vu que c'est quasiment tout le temps ce qu'on veut faire ! (quasiment)*

**Le fichier `/etc/sudoers` contient la configuration de la commande `sudo`.**

On y définit quel utilisateur a le droit d'utiliser `sudo` pour devenir quel autre utilisateur afin de taper quelle commande.

> *On peut par exemple dire que `it4` n'a le droit de taper que la commande `echo meow` en tant que l'utilisateur `toto`. Autrement dit, la seule commande `sudo` que `it4` peut taper sans avoir d'erreur ce serait : `sudo -u toto echo meow`.*

🌞 **Faites en sorte que votre utilisateur puisse taper n'importe quelle commande `sudo`**

usermod -aG sudo ms379

### B. Practice

🌞 **Créer un groupe d'utilisateurs**

sudo groupadd stronk_admins

🌞 **Créer un utilisateur**

sudo useradd -m imbob -p toto
sudo usermod -a -G stronk_admins imbob

🌞 **Prouver que l'utilisateur `imbob` est créé**

sudo cat /etc/passwd

🌞 **Prouver que l'utilisateur `imbob` a un password défini**

sudo cat /etc/shadow

🌞 **Prouver que l'utilisateur `imbob` appartient au groupe `stronk_admins`**

sudo cat /etc/group | grep stronk_admins

🌞 **Créer un deuxième utilisateur**

sudo useradd -m imnotbobsorry -p toto
sudo usermod -a -G stronk_admins

🌞 **Modifier la configuration de `sudo` pour que**

- les membres du groupes `stronk_admins` ait le droit de taper des commandes `apt` en tant que `root`
- l'utilisateur `imbob` peut taper n'importe quelle commande en tant que `root`

🌞 **Créer le dossier `/home/goodguy`** (avec une commande)

🌞 **Changer le répertoire personnel de `imbob`**

- avec une commande `usermod`, définissez ce dossier comme le *répertoire personnel* de `imbob`
- prouvez que le changement est effectif en affichant le contenu du fichier `passwd`

> "*Répertoire personnel*" ça se dit "*home directory*" en anglais, on dit souvent juste "*homedir*" pour faire court. Sous Windows, pour rappel, les *homedirs* des utilisateurs sont stockés par défaut dans `C:/Users/<USER>`, pour Linux c'est donc `/home/<USER>` par défaut.

usermod -d /newhome/imbob imbob

🌞 **Créer le dossier `/home/badguy`**

mkdir badguy

🌞 **Changer le répertoire personnel de `imnotbobsorry`**

- avec une commande `usermod`, définissez ce dossier `/home/badguy` comme le *répertoire personnel* de `imnotbobsorry`
- prouvez que le changement est effectif en affichant le contenu du fichier `passwd`

> Si t'essaies de te connecter en tant que `imbob` là en tapant la commande `su - imbob` il va sûrement se passer des trucs chelous... En tout cas `imbob` ne pourra pas y créer des fichiers. En effet, tu as sûrement du utiliser les droits de `root` pour créer le dossier, donc actuellement, le *répertoire personnel* de `imbob`, il appartient à `root`... Donc `imbob` n'a aucun droit dans son propre *répertoire personnel*, chelou.

usermod -d /home/badguy imnotbobsorry

🌞 **Prouver que les permissions du dossier `/home/gooduy` sont incohérentes**

- ça n'appartient pas à l'utilisateur `imbob`
- ce qui est chelou, l'utilisateur il peut se connecter, mais il peut pas créer quoique ce soit dans son propre *répertoire personnel*, genre dans son propre dossier "Mes Documents"

🌞 **Modifier les permissions de `/home/goodguy`**

- le dossier doit appartenir à `imbob`
- pareil pour tout son contenu
- avec une commande `chown` (il faudra mettre options et arguments)

🌞 **Modifier les permissions de `/home/badguy`**
- le dossier doit appartenir à `imnotbobsorry`
- pareil pour tout son contenu

🌞 **Connectez-vous sur l'utilisateur `imbob`**

- il faut utiliser la commande `su - <USER>` pour ouvrir une nouvelle session en tant qu'un utilisateur
  - ça doit sortir aucun message d'erreur particulier
- si tu fais `pwd` tu devrais être dans le dossier `/home/goodguy` tout de suite après connexion (le *répertoire personnel* de `imbob` !)
- si tu fais `sudo echo meow` ou n'importe quelle autre commande avec `sudo`, ça devrait fonctionner

🌞 **Connectez-vous sur l'utilisateur `imnotbobsorry`**

- il faut utiliser la commande `su - <USER>` pour ouvrir une nouvelle session en tant qu'un utilisateur
  - ça doit sortir aucun message d'erreur particulier
- si tu fais `pwd` tu devrais être dans le dossier `/home/badguy` tout de suite après 
- si tu fais `sudo echo meow` ou n'importe quelle autre commande avec `sudo`, ça ne devrait fonctionner PAS fonctionner
  - sauf les commandes `sudo apt...`, essaie un `sudo apt update` pour voir ?
