# I. Service SSH


## 1. Analyse du service


🌞 **S'assurer que le service `sshd` est démarré**

```
-[ms379@cestduuuur ~]$ systemctl status sshd


● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Sat 2024-11-30 20:48:26 CET; 11min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 705 (sshd)
      Tasks: 1 (limit: 11083)
     Memory: 5.0M
        CPU: 56ms
     CGroup: /system.slice/sshd.service
             └─705 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Nov 30 20:48:26 cestduuuur systemd[1]: Starting OpenSSH server daemon...
Nov 30 20:48:26 cestduuuur sshd[705]: Server listening on 0.0.0.0 port 22.
Nov 30 20:48:26 cestduuuur sshd[705]: Server listening on :: port 22.
Nov 30 20:48:26 cestduuuur systemd[1]: Started OpenSSH server daemon.
Nov 30 20:57:10 cestduuuur sshd[1335]: Accepted password for ms379 from 10.1.1.50 port 62426 ssh2
Nov 30 20:57:10 cestduuuur sshd[1335]: pam_unix(sshd:session): session opened for user ms379(uid=1000) by ms379(uid=0)

```

🌞 **Analyser les processus liés au service SSH**

```
[ms379@cestduuuur ~]$ ps -eF | grep sshd


root         705       1  0  4199  9344   0 20:48 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1335     705  0  5039 11520   0 20:57 ?        00:00:00 sshd: ms379 [priv]
ms379       1339    1335  0  5089  7068   0 20:57 ?        00:00:00 sshd: ms379@pts/0
ms379       1396    1340  0  1602  2432   0 21:01 pts/0    00:00:00 grep --color=auto sshd

```


🌞 **Déterminer le port sur lequel écoute le service SSH**

```
[ms379@cestduuuur ~]$ sudo ss -alnpt | grep sshd

+
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=705,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=705,fd=4))

```

🌞 **Consulter les logs du service SSH**

```
[ms379@migraine ~]$ sudo journalctl -xe -u sshd
~

Dec 02 14:43:57 migraine systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 228.
Dec 02 14:43:57 migraine sshd[703]: Server listening on 0.0.0.0 port 22.
Dec 02 14:43:57 migraine sshd[703]: Server listening on :: port 22.
Dec 02 14:43:57 migraine systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://wiki.rockylinux.org/rocky/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 228.
Dec 02 14:45:07 migraine sshd[1260]: Accepted password for ms379 from 192.168.177.1 port 50540 ssh2
Dec 02 14:45:07 migraine sshd[1260]: pam_unix(sshd:session): session opened for user ms379(uid=1000) by ms379(uid=0)

```


## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**


```

[ms379@migraine ssh]$ sudo cat sshd_config


#[ms379@migraine ssh]$ sudo cat sshd_config
[sudo] password for ms379:
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0

```



🌞 **Modifier le fichier de conf**

```
[ms379@migraine ~]$ sudo cat /etc/ssh/ssh_config | grep Port
#   Port 4911

```
```
[ms379@migraine ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 4911/tcp
  forward-ports:
  source-ports:

```


🌞 **Redémarrer le service**

```
[ms379@migraine ~]$ sudo systemctl restart sshd

```
```
[ms379@migraine ssh]$ sudo ss -alpnt | grep sshd


LISTEN 0      128          0.0.0.0:4911      0.0.0.0:*    users:(("sshd",pid=1864,fd=3))
LISTEN 0      128             [::]:4911         [::]:*    users:(("sshd",pid=1864,fd=4))

```

🌞 **Effectuer une connexion SSH sur le nouveau port**

- depuis votre PC
- il faudra utiliser une option à la commande `ssh` pour vous connecter à la VM

> Je vous conseille de remettre le port par défaut une fois que cette partie est terminée.

✨ **Bonus : affiner la conf du serveur SSH**

- faites vos plus belles recherches internet pour améliorer la conf de SSH
- par "améliorer" on entend essentiellement ici : augmenter son niveau de sécurité
- le but c'est pas de me rendre 10000 lignes de conf que vous pompez sur internet pour le bonus, mais de vous éveiller à divers aspects de SSH, la sécu ou d'autres choses liées

![Such a hacker](./img/such_a_hacker.png)

