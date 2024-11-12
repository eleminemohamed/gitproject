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
- [III. Programmes et paquets](#iii-programmes-et-paquets)
  - [Sommaire](#sommaire-1)
- [1. Programmes et processus](#1-programmes-et-processus)
  - [A. Run then kill](#a-run-then-kill)
  - [B. Tâche de fond](#b-tâche-de-fond)
  - [C. Find paths](#c-find-paths)
  - [D. La variable PATH](#d-la-variable-path)
- [2. Paquets](#2-paquets)

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

# III. Programmes et paquets

Une partie qui s'intéresse aux *programmes* au sens large.

➜ **Quand on exécute un *programme* on dit qu'on lance un *processus*.**

Un *processus* c'est donc juste un *programme* en cours d'exécution.

Les "commandes" du terminal, c'est des *programmes* hein !

> *C'est à dire qu'il a été déplacé en RAM et que le kernel ordonne au CPU d'exécuter les instructions que le programme contient.*

➜ En tant qu'utilisateur on peut facilement, depuis le terminal :

- voir la liste des *processus*
- interagir avec eux (pour les stopper par exemple)
- lancer un *processus* en tâche de fond

➜ **De plus, tout système Linux vient avec un *gestionnaire de paquets*.**

C'est une commande qui permet d'ajouter des nouveaux trucs au système, notamment des nouveaux *programmes*. C'est un app store avant l'heure quoi ! Utilisable en ligne de commande !

> On bénéficie d'une bien meilleure sécurité qu'en téléchargeant des *programmes* sur des sites internet chelous qui nous donnent des `.exe` chelous.

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
- [III. Programmes et paquets](#iii-programmes-et-paquets)
  - [Sommaire](#sommaire-1)
- [1. Programmes et processus](#1-programmes-et-processus)
  - [A. Run then kill](#a-run-then-kill)
  - [B. Tâche de fond](#b-tâche-de-fond)
  - [C. Find paths](#c-find-paths)
  - [D. La variable PATH](#d-la-variable-path)
- [2. Paquets](#2-paquets)

# 1. Programmes et processus

➜ Dans cette partie, afin d'avoir quelque chose à étudier, on va utiliser le programme `sleep`

- c'est une commande (= un *programme*) dispo sur tous les OS
- ça permet de... ne rien faire pendant X secondes
- la syntaxe c'est `sleep 90` pour attendre 90 secondes
- on s'en fout de `sleep` en soit, c'est une commande utile parmi plein d'autres, elle est pratique pour étudier les trucs que j'veux vous montrer

## A. Run then kill

🌞 **Lancer un processus `sleep`**

```
sleep 1000

```

```
ps aux | grep sleep

```

> Le *PID* pour *Process IDentifier* c'est un ID unique attribué à chaque process lancé. Chaque processus, on lui attribue un numéro quoi.

🌞 **Terminez le processus `sleep` depuis le deuxième terminal**

```
killall sleep

```

![Kill it](./img/killit.jpg)

## B. Tâche de fond

🌞 **Lancer un nouveau processus `sleep`, mais en tâche de fond**

```
sleep 1000 &

```

🌞 **Visualisez la commande en tâche de fond**

```
echo $!

```

## C. Find paths

➜ La commande `sleep`, comme toutes les commandes, c'est un programme

- sous Linux, on met pas l'extension `.exe`, s'il y a pas d'extensions, c'est que c'est un exécutable généralement

🌞 **Trouver le chemin où est stocké le programme `sleep`**

```
find / -type f -name "sleep" -executable 2>/dev/null

```

🌞 Tant qu'on est à chercher des chemins : **trouver les chemins vers tous les fichiers qui s'appellent `.bashrc`**

```
find / -type f -name ".bashrc" 2>/dev/null

```

## D. La variable PATH

**Sur tous les OS (MacOS, Windows, Linux, et autres) il existe une variable `PATH` qui est définie quand l'OS démarre.** Elle est accessible par toutes les applications qui seront lancées sur cette machine.

**On dit que `PATH` est une variable d'environnement.** C'est une variable définie par l'OS, et accessible par tous les programmes.

> *Il existe plein de variables d'environnement définie dès que l'OS démarre, `PATH` n'est pas la seule. On peut aussi en créer autant qu'on veut. Attention, suivant avec quel utilisateur on se connecte à une machine, les variables peuvent être différentes : parfait pour avoir chacun sa configuration !*

**`PATH` contient la liste de tous les dossiers qui contiennent des commandes/programmes.**

Ainsi quand on tape une commande comme `ls /home`, il se passe les choses suivantes :

- votre terminal consulte la valeur de la variable `PATH`
- parmi tous les dossiers listés dans cette variable, il cherche s'il y en a un qui contient un programme nommé `ls`
- si oui, il l'exécute
- sinon : `command not found`

Démonstration :

```bash
# on peut afficher la valeur de la variable PATH à n'importe quel moment dans un terminal
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/bin:/bin
# ça contient bien une liste de dossiers, séparés par le caractère ":"

# si la commande ls fonctionne c'est forcément qu'elle se trouve dans l'un de ces dossiers
# on peut savoir lequel avec la commande which qui interroge aussi la variable PATH
$ which ls
/usr/bin/ls
```

🌞 **Vérifier que**

```
which sleep

```
```
which ssh

```
```
which ping

```

# 2. Paquets

➜ **Tous les OS Linux sont munis d'un store d'application**

- c'est natif
- quand tu fais `apt install` ou `dnf install`, ce genre de commandes, t'utilises ce store
- on dit que `apt` et `dnf` sont des gestionnaires de paquets
- ça permet aux utilisateurs de télécharger des nouveaux programmes (ou d'autres trucs) depuis un endroit safe

🌞 **Installer le paquet `firefox`**

```
apt update

```
```
apt install firefox

```


🌞 **Utiliser une commande pour lancer Firefox**

```
cd Desktop
firefox

```

🌞 **Mais aussi déterminer...**

```
apt install HTTP

```