# Misión 0 · Prepara tu puesto

> **Laura:** Lo primero es lo primero: necesitas una cuenta de GitHub, tener Git instalado y configurado, y una copia del taller en tu ordenador. ¡Vamos allá!

**Al acabar esta misión tendrás:** cuenta de GitHub · tu fork del taller · Git instalado y configurado · el taller descargado en tu ordenador

---

## 1. Crea tu cuenta de GitHub

**GitHub** es una web donde se guardan repositorios de Git para compartirlos y trabajar en equipo. La usan millones de profesionales y empresas, así que tu cuenta te servirá también fuera del taller.

1. Entra en [github.com/signup](https://github.com/signup).
2. Usa un email al que tengas acceso: tendrás que verificarlo.
3. Elige bien tu **nombre de usuario**. Será tu identidad profesional y aparecerá en todo lo que hagas. Mejor algo como `lucia-garcia` o `lgarcia-smr` que `xX_destroyer_Xx`.

> En algún momento GitHub te pedirá activar la **verificación en dos pasos (2FA)**. Hazlo con una app del móvil (Google Authenticator, Microsoft Authenticator...) y guarda los códigos de recuperación en un sitio seguro.

## 2. Haz tu fork del taller

Si no lo hiciste al leer el [README](../README.md):

1. Pulsa **[Hacer fork del taller](https://github.com/GonJimenezCampos/taller-git/fork)**.
2. **Desmarca** la casilla **Copy the `main` branch only**.
3. Pulsa **Create fork**.

## 3. Instala Git

### Windows

1. Descarga el instalador desde [git-scm.com/downloads/win](https://git-scm.com/downloads/win).
2. Ejecútalo. Deja todas las opciones como vienen **excepto estas dos pantallas**:

   | Pantalla del instalador | Qué elegir |
   |---|---|
   | *Choosing the default editor used by Git* | **Use Visual Studio Code as Git's default editor** si tienes VS Code. Si no, **Use the Nano editor by default**. **Importante:** no dejes Vim si no sabes usarlo. |
   | *Adjusting the name of the initial branch in new repositories* | **Override the default branch name for new repositories** y escribe `main` |

3. Cuando termine, abre el menú Inicio y busca **Git Bash**. Ábrelo: esta será tu terminal durante todo el taller.

   > **Importante:** usa siempre **Git Bash**, no PowerShell ni el Símbolo del sistema. En PowerShell, el comando `bash` intenta abrir otro programa (WSL) y te dará un error.

### Ubuntu

Abre una terminal (`Ctrl + Alt + T`) y escribe:

```bash
sudo apt update
sudo apt install git
```

### Compruébalo

En Git Bash (Windows) o en la terminal (Ubuntu):

```bash
git --version
```

Tiene que salir algo como `git version 2.47.1`. Si sale `command not found`, Git no se ha instalado bien.

> **Sobre la terminal.** En este taller trabajarás con comandos. Los de Linux que ya conoces (`ls`, `cd`, `pwd`, `mkdir`, `cat`, `cp`, `mv`) funcionan igual en Git Bash.
>
> - Los bloques de código tienen un botón para **copiar** (arriba a la derecha).
> - Para **pegar**: en Git Bash, `Mayús + Insert` o botón derecho → *Paste*; en la terminal de Ubuntu, `Ctrl + Mayús + V`.
> - Las líneas que empiezan por `#` son comentarios: no hace falta escribirlas.

## 4. Dile a Git quién eres

Cada commit que hagas llevará tu nombre y tu email. Escribe esto **cambiando los datos por los tuyos**:

```bash
git config --global user.name "Tu Nombre Apellido"
git config --global user.email "tu-email@ejemplo.com"
```

**Importante:** usa **el mismo email que en tu cuenta de GitHub**. Así GitHub reconocerá tus commits y saldrán con tu foto.

Estas dos, cópialas tal cual:

```bash
git config --global init.defaultBranch main
git config --global pull.rebase false
```

Y elige el editor que abrirá Git cuando necesite que escribas un mensaje (**solo una** de estas líneas):

```bash
git config --global core.editor "code --wait"   # si usas VS Code
git config --global core.editor "nano"          # si no tienes VS Code
```

Comprueba que todo está bien:

```bash
git config --global --list
```

<details>
<summary>¿Qué hace cada opción?</summary>

| Opción | Para qué sirve |
|---|---|
| `user.name` y `user.email` | Firman tus commits: así se sabe quién hizo cada cambio. |
| `init.defaultBranch main` | La rama principal de tus repositorios se llamará `main` (antes se llamaba `master`). |
| `pull.rebase false` | Cuando bajes cambios de GitHub y tú también tengas cambios nuevos, Git los fusionará. Lo verás en la misión 6. |
| `core.editor` | El editor que se abre cuando Git te pide un mensaje (por ejemplo, al fusionar ramas). |

`--global` significa que la configuración vale para todos los repositorios de tu usuario, no solo para uno.
</details>

## 5. Prepara el inicio de sesión con GitHub

Para **subir** cosas a GitHub tendrás que identificarte. GitHub no acepta tu contraseña desde la terminal, así que se usa otro método:

- **Windows:** no tienes que hacer nada. La primera vez que subas algo se abrirá una ventana para iniciar sesión con el navegador (*Sign in with your browser*). Viene incluido con Git.
- **Ubuntu:** instala la herramienta oficial de GitHub y conéctala:

  ```bash
  sudo apt install gh
  gh auth login
  ```

  Responde así: **GitHub.com** → **HTTPS** → **Yes** (*Authenticate Git with your GitHub credentials*) → **Login with a web browser**. Copia el código que aparece, pulsa Enter, pégalo en la web que se abre y autoriza.

  > Si `apt` no encuentra el paquete `gh`, sigue las [instrucciones oficiales de instalación](https://github.com/cli/cli/blob/trunk/docs/install_linux.md).

## 6. Descarga el taller a tu ordenador

Vas a crear una carpeta `taller` dentro de tu carpeta personal y a descargar ahí **tu fork**. Cambia `TU-USUARIO` por tu usuario de GitHub:

```bash
mkdir -p ~/taller
cd ~/taller
git clone https://github.com/TU-USUARIO/taller-git.git
cd taller-git
```

> **Consejo:** la dirección exacta la tienes en tu fork: botón verde **<> Code** → pestaña **HTTPS** → botón de copiar.

Unas cosas útiles:

- `~` es tu carpeta personal: `C:\Users\tu-usuario` en Windows y `/home/tu-usuario` en Ubuntu.
- Para abrir la carpeta actual en el explorador de archivos: `explorer .` (Windows) o `xdg-open .` (Ubuntu).
- Para abrirla en VS Code: `code .`

Lo que acabas de hacer con `git clone` lo entenderás bien en la misión 2. Por ahora, mira lo que se ha descargado:

```bash
ls
```

## Comprueba tu misión

```bash
bash comprobar.sh 0
```

Si todo sale `[ OK ]`, ¡misión cumplida! Si algo sale `[FALLO]`, debajo tienes una pista (`>`) para arreglarlo. Corrígelo y vuelve a ejecutar el comando.

> **Importante:** `comprobar.sh` se ejecuta siempre desde la carpeta del taller. Si no estás en ella, entra con:
> ```bash
> cd ~/taller/taller-git
> ```

---

[Volver al inicio](../README.md) · **Siguiente: [Misión 1 · Tu primer repositorio](1-primer-repositorio.md)**
