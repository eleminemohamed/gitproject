# TP5 


🌞 **Créer un répertoire de travail dans votre répertoire personnel**

```
pwd

```
```
cd Documents
mkdir work

```

# I. Programme minimal

## 2. Analyse du programme compilé

🌞 **Retrouvez à l'aide de `readelf` l'architecture pour laquelle le programme est compilé**

```
readelf -h hello1.c

```

🌞 **Afficher la liste des *sections* contenues dans le *programme***

```
readelf -S hello1.c

```

🌞 **Affichez le code *assembleur* de la section `.text` à l'aide d'`objdump`**

```
objdump -M intel -j .text -d hello1

```

## 2. Librairie et compilation dynamique

### A. Intro lib


### B. Intro compilation dynamique

```
nano hello 2.c

```
```
compiltation du code hello2.c

```

### C. Tracer les appels à des librairies


**C'est à dire qu'on peut afficher les *librairies* dont un *programme* a besoin, en demandant à *ld* de les afficher, grâce à la *commande* `ldd`.**

🌞 **Tracez à l'aide de la commande `ldd` les *librairies* appelées par...**

```
ldd hello2.c
ldd hello1.c
ls hello1.c
ls hello2.c
file hello1.c
file firefox

```

🌞 **Parmi les *librairies* appelées par *hello2*, déterminer le type du fichier nommé `libc.so.X`**

```
file libc.so.6

```

## 3. Compilation statique

➜ **Copiez le fichier `hello2.c` en un fichier `hello3.c`, puis *compilez*-le avec la *commande* suivante** :

```
cp hello2.c hello3.c

```
```bash
gcc -static -fno-stack-protector -g -m32 -o hello3 hello3.c
```


🌞 **Affichez le type des fichiers `hello2` et `hello3`**

```
file hello2.c
file hello3.c

```

🌞 **Affichez leurs tailles**

```
du -h hello2.c
du -h hello3.c

```

## 4. Compilation cross-platform


🌞 **Affichez l'*architecture* de votre *CPU***

```
lscpuinfo
cat /proc/cpuinfo

```

🌞 **Vérifiez que vous avez la commande `x86_64-linux-gnu-gcc`**

```
which x86-64-linux-gnu-gcc

```

🌞 **Compilez votre fichier `hello3.c` dans un fichier cible nommé `hello4` vers une autre *architecture* que la vôtre**

```
arm-linux-gnueabi-gcc -o hello4 hello3.c

```

🌞 **[Désassemblez](../../cours/memo/glossary.md#désassembler) `hello3` et `hello4` à l'aide d'`objdump`**

```
objdump -d hello3
objdump -d hello4

```

🌞 **Essayez d'exécuter le *programme* `hello4`**

```
./hello4

```