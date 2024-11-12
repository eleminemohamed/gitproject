# II. Files and users

Une partie aux *utilisateurs* et aux *fichiers* du système.

➜ **Sous n'importe quel OS, chaque *fichier* a un *propriétaire*.** 

Le *propriétaire* d'un *fichier*, c'est l'utilisateur qui possède le *fichier* : il a tous les droits sur ce *fichier* (il peut le lire, le modifier et l'exécuter comme un programme).

➜ En plus d'un *propriétaire*, **un *fichier* possède des *permissions***

Les *permissions* indiquent les droits que les *utilisateurs* du système ont sur le *fichier*.

➜ **Aussi, il est important de noter que certains des *fichiers* sont des *programmes*** (des exécutables).

Lorsqu'un *programme* est exécuté, il est exécuté sous l'identité de l'utilisateur qui lance le *programme*.

Si un *programme*, pendant son exécution, essaie d'ouvrir un *fichier*, ce sera donc les droits de l'utilisateur qui a lancé le *programme* qui seront utilisés pour déterminer si le *programme* a le droit ou non d'ouvrir le *fichier*.

➜ **Un dernier truc : les dossiers de l'OS sont organisés proprement**

Dans Windows, on trouve par exemple un dossier `Users` et un dossier `Program Files` à la racine de la partition principale (qui s'appelle `C:`).

Dans Linux, on trouve notamment les dossiers `home` (équivalent de `Users`) mais aussi `var`, `etc`, et d'autres. Cette structure s'appelle le FHS et on en reparlera !

Le seul endroit où t'es legit autorisé à foutre le bordel c'est ton *homedirectory* : ton répertoire personnel. Dans Windows c'est `C:/Users/<TON_USER>` et dans Linux `/home/<TON_USER>`. Y'a généralement un sous-dossier `Documents`, `Downloads`, etc.

> Vous remarquez que les chemins sous Linux ne commencent pas par une lettre comme `C:/`. Bah ça existe juste pas sous Linux, le premier dossier, la racine, c'est donc juste `/` et pas `C:/`

## Sommaire

- [II. Files and users](#ii-files-and-users)
  - [Sommaire](#sommaire)
- [1. Fichiers](#1-fichiers)
  - [A. Find me](#a-find-me)
- [2. Users](#2-users)
  - [A. Nouveau user](#a-nouveau-user)
  - [B. Infos enregistrées par le système](#b-infos-enregistrées-par-le-système)
  - [C. Hint sur la ligne de commande](#c-hint-sur-la-ligne-de-commande)
  - [D. Connexion sur le nouvel utilisateur](#d-connexion-sur-le-nouvel-utilisateur)

# 1. Fichiers

## A. Find me

🌞 **Trouver le chemin vers le répertoire personnel de votre utilisateur**

```
pwd (/home/ms379)

```

🌞 **Vérifier les permissions du répertoire personnel de votre utilisateurs**

```
cd /home
ls -l 

```

🌞 **Trouver le chemin du fichier de configuration du serveur SSH**

```
find / -name "sshd_config"

```

# 2. Users

## A. Nouveau user

🌞 **Créer un nouvel utilisateur**

```
useradd -d /home/papier_alu/marmotte marmotte

```
```
mkdir -p /home/papier_alu/marmotte

```
```
passwd marmotte

```

## B. Infos enregistrées par le système

➜ **Pour le compte-rendu**, et pour vous habituer à **utiliser le terminal de façon pratique**, petit hint :

```bash
# supposons un fichier "nul.txt", on peut afficher son contenu avec la commande :
$ cat /chemin/vers/nul.txt
salut
à
toi

# il est possible en une seule ligne de commande d'afficher uniquement une ligne qui contient un mot donné :
$ cat /chemin/vers/nul.txt | grep salut
salut

# à l'aide de `| grep xxx`, on a filtré la sortie de la commande cat
# ça n'affiche donc que la ligne qui contient le mot demandé : "salut"
```

🌞 **Prouver que cet utilisateur a été créé**

```
cat /etc/passwd/ | grep marmotte

```

🌞 **Déterminer le *hash* du password de l'utilisateur `marmotte`**

```
cat etc/shadow | grep marmotte

```

> **On ne stocke JAMAIS le mot de passe des utilisateurs** (sous Linux, ou ailleurs) mais **on stocke les *hash* des mots de passe des users.** Un *hash* c'est un dérivé d'un mot de passe utilisateur : il permet de vérifier à l'avenir que le user tape le bon password, mais sans l'avoir stocké ! On verra peut-être ça une autre fois en détails.

![File ?](./img/file.jpg)

## C. Hint sur la ligne de commande

> *Ce qui est dit dans cette partie est valable pour tous les OS.*

**Quand on donne le chemin d'un fichier à une commande, on peut utiliser soit un *chemin relatif*, soit un *chemin absolu* :**

➜ **chemin absolu**

- c'est le chemin complet vers le fichier
  - il commence forcément par `/` sous Linux ou MacOS
  - il commence forcément par `C:/` (ou une autre lettre) sous Windows
- peu importe où on l'utilise, ça marche tout le temps
- par exemple :
  - `/etc/ssh/sshd_config` est un chemin absolu
  - *et c'est le chemin vers le fichier de conf du serveur SSH sous Linux en l'occurrence*
- mais parfois c'est super long et chiant à taper/utiliser donc on peut utiliser...

➜ ... un **chemin relatif**

- on écrit pas le chemin en entier, mais uniquement le chemin depuis le dossier où se trouve
- par exemple :
  - si on se trouve dans le dossier `/etc/ssh/`
  - on peut utiliser `./sshd_config` : c'est le chemin relatif de `sshd_config` quand on se trouve dans `/etc/ssh/`
  - un chemin relatif commence toujours par un `.`
  - `.` c'est "le dossier actuel"

➜ **Exemples :**

```bash
# on se déplace dans un répertoire spécifique, ici le répertoire personnel du user it4
$ cd /home/it4

# on affiche (parce que pourquoi pas) le fichier de conf du serveur SSH
# en utilisant le chemin absolu du fichier
$ cat /etc/ssh/sshd_config
[...] # ça fonctionne

# cette fois chemin relatif ???
$ cat ./sshd_config
cat: sshd_config: No such file or directory
# on a une erreur car le fichier "sshd_config" n'existe pas dans "/home/it4"

# on se déplace dans le bon dossier
$ cd /etc/ssh

# et là
$ cat ./sshd_config
[...] # ça fonctionne

# en vrai pour permettre d'aller plus vite, ça marche aussi si on met pas le ./ au début
$ cat sshd_config
[...] # ça fonctionne
```

## D. Connexion sur le nouvel utilisateur

🌞 **Tapez une commande pour vous déconnecter : fermer votre session utilisateur**

```
exit
logout

```

🌞 **Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur `marmotte`**

```
su - marmotte

```
```
ls /home/ms379

```

> **On verra en détails la gestion des droits très vite.**
