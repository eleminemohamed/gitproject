DOCUMENTATION 

1. Programme, service, processus 

Lister tous les processus en cours d'exécution sur votre machine : 

Get-Process | Select-Object Name, Id 

Get-Process : Récupère tous les processus en cours d'exécution sur la machine. 

| : Envoie le résultat de la première commande (Get-Process) à la commande suivante. 

Select-Object Name, Id : Filtre les propriétés pour n'afficher que le nom (Name) et l'identifiant unique (Id). 

 

Trouver les 3 processus qui ont le plus petit identifiant : 

Get-Process | Sort-Object Id | Select-Object -First 3 Name, Id 

Get-Process : Récupère tous les processus en cours d'exécution. 

Sort-Object Id : Trie les processus en fonction de leur identifiant, du plus petit au plus grand. 

Select-Object -First 3 Name, Id : Sélectionne les trois premiers processus dans la liste triée et affiche seulement leur nom et leur identifiant. 

 

Lister tous les services de la machine : 

Get-Service 

Lister les services en cours d'exécution : 

Get-Service | Where-Object { $_.Status -eq 'Running' } 

Lister les services qui existent mais ne sont pas lancés : 

Get-Service | Where-Object { $_.Status -eq 'Stopped' } 

Get-Service : Récupère tous les services de la machine. 

Where-Object { $_.Status -eq 'Running' } : Filtre les services pour n'afficher que ceux dont l'état est "Running". 

Where-Object { $_.Status -eq 'Stopped' } : Filtre pour n'afficher que ceux dont l'état est "Stopped". 

 

 

 

 

2. Mémoire et CPU 

RAM :  

Afficher la quantité de RAM totale : 

(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory  

Afficher la quantité de RAM libre : 

(Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory  

Get-CimInstance -ClassName Win32_ComputerSystem : Récupère des informations sur le système, y compris la mémoire totale. 

TotalPhysicalMemory : Propriété qui contient la RAM totale en octets (divisée par 1GB pour obtenir des gigaoctets). 

Get-CimInstance -ClassName Win32_OperatingSystem : Récupère des informations sur le système d'exploitation, y compris la RAM libre. 

FreePhysicalMemory : Propriété qui contient la RAM libre en kilo-octets (divisée par 1MB pour obtenir des mégaoctets). 

 

CPU : 

afficher l'utilisation du CPU : 

Get-Process 

Get-Process : Pour afficher tous les processus en cours d'exécution 

 

3. Stockage 

Périphériques 

lister les périphériques de stockage : 

Get-CimInstance -ClassName Win32_DiskDrive | Select-Object Model, Size 

Get-CimInstance -ClassName Win32_DiskDrive : Récupère des informations sur les périphériques de stockage physiques. 

Model : Propriété qui affiche la marque et le modèle du disque dur ou du SSD. 

Size : Propriété qui donne la taille du disque en octets 

 

Partitions 

lister les partitions du système 

Get-Partition | Select-Object PartitionNumber, DriveLetter, Size, SizeRemaining 

Get-Partition : Récupère des informations sur toutes les partitions présentes sur les disques de la machine. 

Select-Object PartitionNumber, DriveLetter, Size, SizeRemaining : Affiche des informations spécifiques sur chaque partition : 

PartitionNumber : Numéro de la partition. 

DriveLetter : Lettre de lecteur attribuée à la partition (si disponible). 

Size : Taille totale de la partition. 

SizeRemaining : Espace restant sur la partition. 

 

Espace disque 

afficher l'espace disque restant sur votre partition principale : 

Get-PSDrive -Name C | Select-Object Used, Free 

Get-PSDrive -Name C : Récupère des informations sur le lecteur C:. 

Select-Object Used, Free : Sélectionne les propriétés utilisées et libres. 

 

4. Réseau 

Cartes réseau 

afficher la liste des cartes réseau de votre PC :  

Get-NetAdapter | Select-Object Name, @{Name="IPv4 Address"; Expression={(Get-NetIPAddress -InterfaceAlias $_.Name -AddressFamily IPv4).IPAddress}} 

Get-NetAdapter : Récupère des informations sur les adaptateurs réseau de la machine. 

Select-Object Name : Sélectionne le nom de l'adaptateur réseau. 

@{Name="IPv4 Address"; Expression={(Get-NetIPAddress -InterfaceAlias $_.Name -AddressFamily IPv4).IPAddress}} : Crée une nouvelle propriété pour afficher l'adresse IP de l'adaptateur. Cela utilise Get-NetIPAddress pour récupérer l'adresse IP en fonction de l'alias de l'interface (le nom de l'adaptateur). 

 

Connexions réseau 

lister les connexions réseau actuellement en cours 

"actuellement en cours" c'est qu'elles sont dans l'état "établi" ou "established" en anglais 

on doit voir apparaître :  

l'adresse IP du serveur auquel vous êtes connectés 

le nom et/ou l'identifiant du processus responsable de cette connexion 

Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' } | Select-Object LocalAddress, RemoteAddress, @{Name='ProcessId';Expression={($_.OwningProcess)}}, @{Name='ProcessName';Expression={(Get-Process -Id $_.OwningProcess).Name}} 

 

Get-NetTCPConnection : Récupère les connexions TCP sur la machine. 

Where-Object { $_.State -eq 'Established' } : Filtre les connexions pour ne garder que celles dont l'état est "Established". 

Select-Object : Sélectionne les propriétés à afficher : 

LocalAddress : Adresse IP locale. 

RemoteAddress : Adresse IP du serveur distant auquel tu es connecté. 

ProcessId : Identifiant du processus qui possède la connexion. 

ProcessName : Nom du processus, récupéré en utilisant l'identifiant du processus. 

 

 

5. Utilisateurs 

Lister les utilisateurs de la machine 

on devrait voir au moins :  

votre utilisateur  

l'utilisateur qui est administrateur sur la machine 

 

Get-LocalUser | Select-Object Name, Enabled 

Get-LocalUser : Récupère une liste de tous les comptes d'utilisateurs locaux sur la machine. 

 

Lister les processus en cours d'exécution 

cette fois, on doit voir apparaître en plus le nom de l'utilisateur qui a lancé chacun d'entre eux : 

 

Get-Process | Select-Object Id, ProcessName 

 

Get-Process : Récupère une liste de tous les processus en cours d'exécution. 

Select-Object : Sélectionne les propriétés à afficher : 

Id : Identifiant du processus (PID). 

ProcessName : Nom du processus. 

 

Sur un fichier random qui se trouve dans votre dossier Téléchargements/ 

déterminer quel utilisateur est le propriétaire du fichier 

$filepath = "$env:USERPROFILE\Downloads\menu.php" 

(Get-Acl $filepath).Owner  

$env:USERPROFILE\Downloads\menu.php : Chemin d'accès au fichier dans le dossier Téléchargements de l'utilisateur courant. 

Get-Acl : Récupère la liste de contrôle d'accès (ACL) du fichier, qui contient des informations sur le propriétaire et les permissions. 

.Owner : Propriété qui retourne le nom de l'utilisateur qui possède le fichier. 

 

 

6. Random 

Uptime 

afficher l'heure/la date de l'allumage de la machine 

(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime 

 

(get-date) : Obtient l'heure et la date actuelles. 

(gcim Win32_OperatingSystem).LastBootUpTime : Récupère la dernière date et heure de démarrage de l'ordinateur en utilisant la classe WMI Win32_OperatingSystem. 

(get-date) - ... : Calcule la durée depuis le dernier démarrage en soustrayant la date de démarrage à la date actuelle. 

 

 

 

 

 