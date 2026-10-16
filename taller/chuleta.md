# Chuleta de Git

## El día a día

```bash
git pull                       # 1. Al empezar: bajo lo nuevo
git status                     # 2. ¿Qué he cambiado?
git add archivo                # 3. Preparo los cambios
git commit -m "Qué he hecho"   # 4. Los guardo
git push                       # 5. Al terminar: los subo
```

## Configurar (una sola vez)

| Comando | Para qué |
|---|---|
| `git config --global user.name "Nombre"` | Tu nombre en los commits |
| `git config --global user.email "email"` | Tu email en los commits |
| `git config --global init.defaultBranch main` | La rama principal se llama main |
| `git config --global pull.rebase false` | `git pull` fusiona |
| `git config --global core.editor "nano"` | Editor para los mensajes |
| `git config --global --list` | Ver tu configuración |

## Empezar un repositorio

| Comando | Para qué |
|---|---|
| `git init` | Convierte la carpeta actual en un repositorio |
| `git clone URL` | Descarga un repositorio con toda su historia |

## Guardar cambios

| Comando | Para qué |
|---|---|
| `git status` | Estado de todo. **Úsalo siempre.** |
| `git diff` | Cambios que aún no están en el staging |
| `git diff --staged` | Cambios que ya están en el staging |
| `git add archivo` | Pasa un archivo al staging |
| `git add .` | Pasa todos los cambios al staging |
| `git commit -m "mensaje"` | Crea un commit con lo que hay en el staging |
| `git rm archivo` | Borra un archivo (y prepara el borrado) |
| `git mv viejo nuevo` | Renombra o mueve un archivo |

## Ver la historia

| Comando | Para qué |
|---|---|
| `git log` | Historia completa |
| `git log --oneline` | Un commit por línea |
| `git log --oneline --graph --all` | Con el dibujo de todas las ramas |
| `git log -- archivo` | Solo los commits que tocan un archivo |
| `git log --author="Ana"` | Solo los commits de Ana |
| `git log -p` | Historia con los cambios de cada commit |
| `git shortlog -sn` | Cuántos commits ha hecho cada persona |
| `git show HASH` | Qué cambió en un commit |
| `git show HASH:archivo` | Cómo era un archivo en un commit |
| `git blame archivo` | Quién escribió cada línea |

## Deshacer

| Situación | Comando |
|---|---|
| He cambiado un archivo y quiero dejarlo como estaba | `git restore archivo` |
| He hecho `git add` de algo que no quería | `git restore --staged archivo` |
| Quiero recuperar un archivo de un commit antiguo | `git restore --source=HASH archivo` |
| Un commit ya subido estaba mal y quiero deshacerlo | `git revert HASH` |
| El último commit tiene mal el mensaje (y no lo he subido) | `git commit --amend -m "nuevo mensaje"` |
| Estoy en mitad de una fusión con conflictos y me he liado | `git merge --abort` |

## Ramas

| Comando | Para qué |
|---|---|
| `git branch` | Lista tus ramas (`*` = la actual) |
| `git branch -a` | Lista también las de GitHub |
| `git switch -c nueva` | Crea una rama y te cambia a ella |
| `git switch rama` | Te cambia a otra rama |
| `git merge rama` | Trae los cambios de `rama` a la rama actual |
| `git branch -d rama` | Borra una rama ya fusionada |
| `git switch --detach HASH` | Viaja a un commit antiguo (solo para mirar) |

## Remotos (GitHub)

| Comando | Para qué |
|---|---|
| `git remote -v` | Lista los remotos |
| `git remote add origin URL` | Conecta tu repositorio con uno de GitHub |
| `git remote add upstream URL` | Conecta tu fork con el original |
| `git push` | Sube tus commits |
| `git push -u origin rama` | Sube una rama por primera vez |
| `git fetch` | Mira qué hay nuevo, sin tocar tus archivos |
| `git pull` | Baja lo nuevo y lo aplica |

## Resolver un conflicto

1. `git status` → mira qué archivos están en conflicto (*both modified*).
2. Abre cada uno, decide cómo debe quedar y **borra las marcas** `<<<<<<<`, `=======` y `>>>>>>>`.
3. `git add archivo`
4. `git commit`

## Símbolos útiles

| Símbolo | Significado |
|---|---|
| `HEAD` | Donde estás ahora |
| `HASH~1` | El commit anterior a HASH |
| `main..otra` | Commits que están en `otra` pero no en `main` |
| `origin/main` | La rama `main` de GitHub (según la última vez que preguntaste) |
| `q` | Salir cuando un comando ocupa más de una pantalla |

---

[Volver al inicio](../README.md)
