# Me he atascado

Busca tu problema. Si no está aquí, pregunta a quien tengas al lado y, si tampoco lo sabe, al profe.

> **Regla de oro:** antes de nada, `git status`. Casi siempre te dice qué pasa y qué hacer.

---

### Se me ha abierto una pantalla rara y no sé salir

Depende de lo que veas:

| Ves... | Es... | Para salir |
|---|---|---|
| Líneas con `~` a la izquierda | **Vim** | Pulsa `Esc`, escribe `:wq` y pulsa `Enter` (guarda y sale). Para salir sin guardar: `Esc`, `:q!`, `Enter` |
| `^G Help  ^O Write Out  ^X Exit` abajo | **nano** | `Ctrl + O`, `Enter` (guardar) y `Ctrl + X` (salir) |
| Un `:` o `(END)` abajo del todo | El **paginador** (`git log`, `git diff`...) | Pulsa `q` |
| Una pestaña de VS Code con un mensaje y la terminal esperando | **VS Code** como editor | Guarda (`Ctrl + S`) y cierra la pestaña |

Para no volver a ver Vim: `git config --global core.editor "nano"`

### `Windows Subsystem for Linux has no installed distributions`

Has escrito el comando en **PowerShell** o en el **Símbolo del sistema**. Ahí, `bash` intenta abrir WSL (el Linux de Windows) en vez de Git Bash. Cierra esa ventana, abre **Git Bash** desde el menú Inicio y repite el comando.

### `fatal: not a git repository`

No estás dentro de un repositorio. Mira dónde estás con `pwd` y entra en la carpeta correcta:

```bash
cd ~/taller/taller-git
```

### `bash: comprobar.sh: No such file or directory`

Igual que el anterior: tienes que estar en `~/taller/taller-git`.

### `Author identity unknown` / `Please tell me who you are`

No has configurado tu nombre y tu email. Haz el [paso 4 de la misión 0](0-preparacion.md#4-dile-a-git-quién-eres).

### `git push` me pide usuario y contraseña, y mi contraseña no funciona

GitHub no acepta tu contraseña desde la terminal.

- **Windows:** debería abrirse una ventana para iniciar sesión con el navegador. Si no sale, reinstala Git dejando marcada la opción *Git Credential Manager*.
- **Ubuntu:** haz el [paso 5 de la misión 0](0-preparacion.md#5-prepara-el-inicio-de-sesión-con-github) (`gh auth login`).

### `remote: Permission to ... denied` o `403`

Estás intentando subir a un repositorio que no es tuyo, seguramente porque clonaste el **original** en vez de **tu fork**. Mira a dónde apunta `origin`:

```bash
git remote -v
```

Si sale `GonJimenezCampos/taller-git`, cámbialo por tu fork:

```bash
git remote set-url origin https://github.com/TU-USUARIO/taller-git.git
```

### `! [rejected] main -> main (fetch first)` o `(non-fast-forward)`

En GitHub hay commits que tú no tienes. Primero baja y luego sube:

```bash
git pull
git push
```

Si `git pull` da conflicto, resuélvelo (ver más abajo).

### `fatal: Need to specify how to reconcile divergent branches`

Falta una opción de configuración. Ponla y repite el pull:

```bash
git config --global pull.rebase false
git pull
```

### `CONFLICT (content): Merge conflict in ...`

No es un error. Dos cambios chocan y Git te pregunta a ti.

1. `git status` → mira qué archivos pone *both modified*.
2. Abre cada uno, déjalo como tiene que quedar y **borra las marcas** `<<<<<<<`, `=======` y `>>>>>>>`.
3. `git add archivo` y `git commit`.

¿Te has liado? `git merge --abort` lo deja todo como antes de fusionar.

### `error: Your local changes to the following files would be overwritten by merge` (o `by checkout`)

Tienes cambios sin guardar que se perderían. Elige:

- Guárdalos: `git add` + `git commit`, y repite lo que estabas haciendo.
- O tíralos, si no te sirven: `git restore archivo`

### `HEAD detached at ...` (en `git status`) o `You are in 'detached HEAD' state`

Estás mirando un commit del pasado. Vuelve al presente:

```bash
git switch main
```

### `error: src refspec main does not match any`

O todavía no has hecho ningún commit, o tu rama no se llama `main`. Mira con `git branch` cómo se llama. Si se llama `master`:

```bash
git branch -M main
```

### `merge: aula-2 - not something we can merge`

Git no conoce esa rama en tu ordenador. Primero haz `git switch aula-2` (eso la crea a partir de la de GitHub), vuelve a `main` y fusiona. Si tampoco funciona, mira «No me salen esas ramas» en la [misión 4](4-universos-paralelos.md).

### `error: remote upstream already exists` / `remote origin already exists`

Ya lo habías añadido antes. Comprueba que apunta donde debe con `git remote -v`.

### `warning: in the working copy of '...', LF will be replaced by CRLF`

Es solo un aviso, puedes ignorarlo. Windows y Linux marcan los finales de línea de forma distinta y Git los convierte por ti.

### Los nombres de archivo con tildes salen como `\303\241`

```bash
git config --global core.quotepath off
```

### He hecho `git add` de algo que no quería

```bash
git restore --staged archivo
```

El archivo sigue igual en tu carpeta; solo sale del staging.

### He hecho commit con un mensaje mal escrito

Si **no lo has subido** todavía:

```bash
git commit --amend -m "Mensaje bueno"
```

Si ya lo subiste, déjalo así: no pasa nada.

### He hecho commit en la rama equivocada

Avisa al profe. Tiene arreglo, pero es más fácil verlo juntos.

### La he liado tanto que quiero empezar de cero

Último recurso (pierdes todo lo que hayas hecho en el taller):

1. En GitHub, en tu fork: **Settings** → abajo del todo, **Delete this repository**.
2. En tu ordenador, borra la carpeta: `rm -rf ~/taller/taller-git`
3. Vuelve a hacer el fork y el clone ([misión 0](0-preparacion.md), pasos 2 y 6).

---

[Volver al inicio](../README.md)
