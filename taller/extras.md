# Extras

Para quien quiera seguir aprendiendo. Hazlos en el orden que quieras.

---

## Publica una web gratis con GitHub Pages

GitHub puede convertir un repositorio en una página web. Con una cuenta gratuita, el repositorio tiene que ser **público** (si hiciste `mi-primer-repo` privado, cámbialo en **Settings** → **General** → **Danger Zone** → **Change visibility**).

1. En tu repositorio `mi-primer-repo`, ve a **Settings** → **Pages**.
2. En *Branch* elige `main` y la carpeta `/ (root)`. Pulsa **Save**.
3. Espera un poco y recarga: arriba aparecerá la dirección, `https://TU-USUARIO.github.io/mi-primer-repo/`

Tu `README.md` ya es una página web. Prueba a crear un `index.md` con más contenido, súbelo y mira cómo cambia.

## Tu perfil de GitHub

Si creas un repositorio que se llame **exactamente igual que tu usuario** (por ejemplo `lucia-garcia/lucia-garcia`) y le pones un `README.md`, ese README aparecerá en la portada de tu perfil. Úsalo para presentarte: quién eres, qué estudias, qué sabes hacer. Es tu CV técnico.

## Git sin terminal: VS Code y GitHub Desktop

Ya sabes lo que pasa por debajo, así que ahora puedes usar herramientas gráficas sin perderte:

- **VS Code:** abre la carpeta del taller (`code .`) y pulsa el icono de ramas de la barra lateral (*Source Control*, `Ctrl + Mayús + G`).
  - El **+** junto a un archivo = `git add`
  - El cuadro de texto y el botón **Commit** = `git commit -m`
  - **Sync Changes** = `git pull` + `git push`
  - Abajo a la izquierda ves y cambias la rama actual.
- **GitHub Desktop** ([desktop.github.com](https://desktop.github.com), solo Windows y Mac): una aplicación para hacer lo mismo con botones.

Haz un cambio con cada una y busca qué comando equivale a cada botón.

## Claves SSH

En vez de iniciar sesión con el navegador, puedes conectarte a GitHub con una **clave SSH**, igual que haríais para entrar en un servidor:

```bash
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"   # pulsa Enter a todo
cat ~/.ssh/id_ed25519.pub                         # copia lo que sale
```

1. En GitHub: tu foto → **Settings** → **SSH and GPG keys** → **New SSH key**. Pega la clave pública.
2. Comprueba la conexión: `ssh -T git@github.com`
3. A partir de ahora puedes clonar con la dirección SSH: `git clone git@github.com:TU-USUARIO/mi-primer-repo.git`

**Importante:** el archivo **sin** `.pub` es tu clave **privada**: no se comparte nunca.

## `git stash`: guardar cambios a medias

¿Estás a mitad de algo y necesitas cambiar de rama? Guarda tus cambios sin hacer commit:

```bash
git stash          # guarda los cambios y deja la carpeta limpia
git switch otra-rama
# ...haces lo que tengas que hacer...
git switch main
git stash pop      # recupera los cambios
```

## Corregir el último commit

¿Te has equivocado en el mensaje o se te ha olvidado un archivo? Si **todavía no lo has subido**:

```bash
git add archivo-olvidado
git commit --amend -m "Mensaje corregido"
```

**Importante:** no lo hagas con commits que ya has subido: cambiarías una historia que otros ya tienen.

## Etiquetas (versiones)

Para marcar un commit importante, como una versión:

```bash
git tag v1.0
git push origin v1.0
```

En GitHub aparecerá en **Releases / Tags**.

## Atajos (alias)

```bash
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
```

Ahora `git st` es `git status` y `git lg` dibuja todas las ramas.

## Practica jugando

- **[Learn Git Branching](https://learngitbranching.js.org/?locale=es_ES):** niveles visuales para dominar las ramas. En español. Muy recomendable.
- **[Oh My Git!](https://ohmygit.org/):** un juego de cartas para aprender Git.

---

[Volver al inicio](../README.md)
