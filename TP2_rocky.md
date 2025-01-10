🌞 Afficher la quantité d'espace disque disponible (partition montée sur /) 

📎 Commande : df 

df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4 
 

Explication : 

df -h / : Affiche l'espace disque pour la partition / en format lisible (humain). 

grep '/' : Filtre la ligne qui concerne /. 

tr -s ' ' : Réduit les espaces multiples en un seul espace. 

cut -d' ' -f4 : Sélectionne la 4e colonne (espace disponible). 

 

🌞 Afficher combien de fichiers il est possible de créer (inodes disponibles sur /) 

📎 Commande : df avec l'option -i 

df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4 
 

Explication : 

df -i / : Affiche les informations sur les inodes pour la partition /. 

 

🌞 Afficher l'heure et la date (format dd/mm/yy hh:mm:ss) 

📎 Commande : date 

date '+%d/%m/%y %H:%M:%S' 
 

Explication : 

Le format est personnalisé avec l'option +. 

 

🌞 Afficher la version de l'OS précise 

📎 Commande : source 

source /etc/os-release && echo "$PRETTY_NAME" 
 

Explication : 

source /etc/os-release : Charge les variables définies dans ce fichier. 

$PRETTY_NAME : Variable qui contient le nom complet de l'OS. 

 

🌞 Afficher la version du kernel en cours d'utilisation précise 

📎 Commande : uname 

uname -r 
 

 

🌞 Afficher le chemin vers la commande python3 

📎 Commande : which 

which python3 
 

 

🌞 Afficher l'utilisateur actuellement connecté 

📎 Commande : echo $variable 

echo $USER 
 

 

🌞 Afficher le shell par défaut de votre utilisateur actuellement connecté 

📎 Commande : cat <fichier> | grep $variable 

grep "^$USER:" /etc/passwd | cut -d':' -f7 
 

Explication : 

^$USER: : Filtre la ligne de l'utilisateur connecté. 

cut -d':' -f7 : Sélectionne la 7e colonne, qui indique le shell par défaut. 

 

🌞 Afficher le nombre de paquets installés 

📎 Commande : rpm 

rpm -qa | wc -l 
 

Explication : 

rpm -qa : Liste tous les paquets installés. 

wc -l : Compte le nombre de lignes (donc de paquets). 

 

🌞 Afficher le nombre de ports en écoute 

📎 Commande : ss 

ss -tuln | grep -c LISTEN 
 

Explication : 

ss -tuln : Liste les sockets TCP/UDP en écoute. 

grep -c LISTEN : Compte les lignes contenant "LISTEN". 

 
 Partie II : Un premier ptit script 

 

🌞 1. Script de base avec toutes les informations : 

#!/bin/bash 

# Script d'identification et d'infos système 

# it4 - 08/12/2024 

  

# Variables 

USER_NAME=$(echo $USER) 

DATE=$(date '+%d/%m/%y %H:%M:%S') 

SHELL=$(grep "^$USER_NAME:" /etc/passwd | cut -d':' -f7) 

OS=$(source /etc/os-release && echo "$PRETTY_NAME") 

KERNEL=$(uname -r) 

FREE_RAM=$(free -mh | grep 'Mem:' | tr -s ' ' | cut -d' ' -f7) 

DISK_SPACE=$(df -h / | grep '/' | tr -s ' ' | cut -d' ' -f4) 

INODES=$(df -i / | grep '/' | tr -s ' ' | cut -d' ' -f4) 

PACKAGES=$(rpm -qa | wc -l) 

PORTS=$(ss -tuln | grep -c LISTEN) 

PYTHON_PATH=$(which python3) 

  

# Affichage 

echo "Salu a toa $USER_NAME." 

echo "Nouvelle connexion $DATE." 

echo "Connecté avec le shell $SHELL." 

echo "OS : $OS - Kernel : $KERNEL" 

echo "Ressources :" 

echo "  - $FREE_RAM RAM dispo" 

echo "  - $DISK_SPACE espace disque dispo" 

echo "  - $INODES fichiers restants" 

echo "Actuellement :" 

echo "  - $PACKAGES paquets installés" 

echo "  - $PORTS port(s) ouvert(s)" 

echo "Python est bien installé sur la machine au chemin : $PYTHON_PATH" 

 

 

🌞 2. Ajout de l'état du firewall 

On ajoute un test conditionnel pour afficher l'état du service firewalld. 

FIREWALL_STATE=$(systemctl is-active firewalld) 

  

if [[ $FIREWALL_STATE == "active" ]]; then 

    echo "Le firewall est actif." 

else 

    echo "Le firewall est inactif." 

fi 

 

 

 

🌞 3. URL vers une photo de chat 

On utilise curl pour récupérer une URL. 

 

CAT_URL=$(curl -s https://api.thecatapi.com/v1/images/search | grep -oP '"url":"\K[^"]+') 

echo "Voilà ta photo de chat : $CAT_URL" 

 

🌞 4. Ajouter l'exécution automatique dans le terminal 

sudo mv id.sh /opt/ 

sudo chmod +x /opt/id.sh 