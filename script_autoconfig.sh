#!/bin/bash

# Fonction pour afficher les messages avec horodatage
log() {
    echo "$(date +'%H:%M:%S') [INFO] $1"
}

warn() {
    echo "$(date +'%H:%M:%S') [WARN] $1"
}

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi
log "Le script a bien été lancé en root."

# Désactivation temporaire de SELinux
SELINUX_STATUS=$(sestatus | grep "Current mode" | awk '{print $3}')
if [[ $SELINUX_STATUS != "permissive" ]]; then
    warn "SELinux est en mode $SELINUX_STATUS."
    log "Désactivation temporaire de SELinux."
    setenforce 0
else
    log "SELinux est déjà en mode permissif."
fi

# Désactivation permanente de SELinux
SELINUX_CONFIG=$(grep "^SELINUX=" /etc/selinux/config | cut -d'=' -f2)
if [[ $SELINUX_CONFIG != "permissive" ]]; then
    log "Désactivation permanente de SELinux dans le fichier de configuration."
    sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
else
    log "La configuration de SELinux est déjà en mode permissif."
fi

# Vérification du statut de firewalld
if systemctl is-active --quiet firewalld; then
    log "Le service firewalld est actif."
else
    echo "Le service firewalld n'est pas actif. Veuillez l'activer avant de continuer."
    exit 1
fi

# Modification du port SSH si nécessaire
SSH_PORT=$(ss -tuln | grep ssh | awk '{print $5}' | cut -d':' -f2)
if [[ $SSH_PORT -eq 22 ]]; then
    warn "Le service SSH utilise le port 22."
    NEW_PORT=$((RANDOM % 64510 + 1025))
    log "Changement du port SSH vers le port $NEW_PORT."
    sed -i "s/^#Port 22/Port $NEW_PORT/" /etc/ssh/sshd_config
    log "Redémarrage du service SSH."
    systemctl restart sshd
    log "Mise à jour du pare-feu : ouverture du port $NEW_PORT et fermeture du port 22."
    firewall-cmd --permanent --add-port=$NEW_PORT/tcp
    firewall-cmd --permanent --remove-port=22/tcp
    firewall-cmd --reload
else
    log "Le service SSH n'utilise pas le port 22."
fi

# Changement du nom d'hôte si nécessaire
CURRENT_HOSTNAME=$(hostnamectl --static)
if [[ $CURRENT_HOSTNAME == "localhost" ]]; then
    if [[ -z $1 ]]; then
        echo "Aucun nom d'hôte fourni. Veuillez exécuter le script avec le nom d'hôte souhaité en argument."
        exit 1
    fi
    log "Changement du nom d'hôte de 'localhost' à '$1'."
    hostnamectl set-hostname "$1"
else
    log "Le nom d'hôte est déjà défini sur '$CURRENT_HOSTNAME'."
fi

# Vérification de l'appartenance au groupe wheel
USER_NAME=$(whoami)
if groups $USER_NAME | grep &>/dev/null "\bwheel\b"; then
    log "L'utilisateur $USER_NAME appartient déjà au groupe wheel."
else
    warn "L'utilisateur $USER_NAME n'appartient pas au groupe wheel."
    log "Ajout de l'utilisateur $USER_NAME au groupe wheel."
    usermod -aG wheel $USER_NAME
fi

log "Le script d'autoconfiguration s'est terminé avec succès."

