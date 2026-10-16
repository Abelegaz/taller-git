#!/usr/bin/env bash
# =====================================================================
#  comprobar.sh · Corrige las misiones del taller de Git
#
#  Uso:   bash comprobar.sh <número de misión>     p. ej.:  bash comprobar.sh 3
#         bash comprobar.sh todas
#
#  Si tu primer repositorio (misiones 1 y 2) no está en ~/taller/mi-primer-repo:
#         bash comprobar.sh 1 RUTA-DE-TU-REPOSITORIO
# =====================================================================

PROFE="GonJimenezCampos"
REPO="taller-git"
URL_ORIGINAL="${TALLER_URL_ORIGINAL:-https://github.com/$PROFE/$REPO.git}"

# Huella SHA-256 de la contraseña filtrada (misión 3). Así no se puede leer aquí
HUELLA_CLAVE="49a6ccb0ad10ab7f87403912af993032c93a0a0b564355e8288115b9198e6643"

SCRIPT_COPIAS="empresa/scripts/copia-seguridad.sh"
RSYNC_MALO='"$DESTINO/" "$ORIGEN/"'
RSYNC_BUENO='"$ORIGEN/" "$DESTINO/$FECHA/"'

if [ -t 1 ]; then
  VERDE=$'\033[32m'; ROJO=$'\033[31m'; AMARILLO=$'\033[33m'; CIAN=$'\033[36m'
  NEGRITA=$'\033[1m'; NORMAL=$'\033[0m'
else
  VERDE=; ROJO=; AMARILLO=; CIAN=; NEGRITA=; NORMAL=
fi

ACIERTOS=0
FALLOS=0

ok()    { echo "  ${VERDE}[ OK ]${NORMAL} $1"; ACIERTOS=$((ACIERTOS + 1)); }
fallo() { echo "  ${ROJO}[FALLO]${NORMAL} $1"; shift; pistas "$@"; FALLOS=$((FALLOS + 1)); }
aviso() { echo "  ${AMARILLO}[AVISO]${NORMAL} $1"; shift; pistas "$@"; }
pistas() { local p; for p in "$@"; do echo "          ${AMARILLO}>${NORMAL} $p"; done; }
cabecera() {
  ACIERTOS=0; FALLOS=0
  echo
  echo "${NEGRITA}${CIAN}=== Misión $1 · $2 ===${NORMAL}"
}

# --- Utilidades de Git -----------------------------------------------

existe_ref()  { git rev-parse -q --verify "$1^{commit}" >/dev/null 2>&1; }
es_ancestro() { git merge-base --is-ancestor "$1" "$2" 2>/dev/null; }
traer()       { GIT_TERMINAL_PROMPT=0 git fetch -q "$@" >/dev/null 2>&1; }
minusculas()  { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }
bonita()      { case "$1" in "$HOME"/*) printf '~%s' "${1#"$HOME"}" ;; *) printf '%s' "$1" ;; esac; }
dueno_url()   { printf '%s' "$1" | sed -E 's#.*github\.com[:/]+([^/]+)/.*#\1#'; }

# Busca la versión del repositorio original del profe para no confundir
# sus commits con los tuyos. Rellena NO_ORIGINAL=(--not REF) si lo consigue.
ORIGINAL=""
NO_ORIGINAL=()
cargar_original() {
  [ -n "$ORIGINAL" ] && return 0
  if git remote get-url upstream >/dev/null 2>&1 && traer upstream && existe_ref upstream/main; then
    ORIGINAL="upstream/main"
  elif traer "$URL_ORIGINAL" "+main:refs/taller/original" && existe_ref refs/taller/original; then
    ORIGINAL="refs/taller/original"
  fi
  [ -n "$ORIGINAL" ] && NO_ORIGINAL=(--not "$ORIGINAL")
}
trap 'git update-ref -d refs/taller/original >/dev/null 2>&1' EXIT

# ¿Está main igual que origin/main? Si no, explica la diferencia.
comprobar_subido() {
  if ! existe_ref origin/main; then
    fallo "No encuentro la rama main en GitHub (origin/main)" "git push -u origin main"
    return
  fi
  local cuentas antes atras
  cuentas=$(git rev-list --left-right --count main...origin/main 2>/dev/null)
  antes=${cuentas%%[[:space:]]*}
  atras=${cuentas##*[[:space:]]}
  if [ "$antes" = 0 ] && [ "$atras" = 0 ]; then
    ok "Todo está subido: tu main y el de GitHub son iguales"
  elif [ "$atras" = 0 ]; then
    fallo "Tienes $antes commit(s) sin subir a GitHub" "git push"
  elif [ "$antes" = 0 ]; then
    fallo "En GitHub hay $atras commit(s) que no tienes en tu ordenador" "git pull"
  else
    fallo "Tu main y el de GitHub se han separado ($antes tuyos sin subir, $atras de GitHub sin bajar)" "git pull  (resuelve conflictos si los hay)  y luego  git push"
  fi
}

necesito_email() {
  if [ -z "$EMAIL" ]; then
    fallo "Git no sabe quién eres: no tienes configurado tu email" "Haz la misión 0: git config --global user.email \"tu-email\""
    return 1
  fi
}

ruta_primer_repo() {
  if [ -n "$RUTA_PRIMER_REPO" ]; then echo "$RUTA_PRIMER_REPO"
  else echo "$(dirname "$RAIZ")/mi-primer-repo"; fi
}

# =====================================================================
#  MISIÓN 0 · Prepara tu puesto
# =====================================================================
mision0() {
  cabecera 0 "Prepara tu puesto"

  local version mayor menor
  version=$(git --version | sed -E 's/[^0-9]*([0-9]+)\.([0-9]+).*/\1 \2/')
  mayor=${version%% *}; menor=${version##* }
  if [ "$mayor" -gt 2 ] || { [ "$mayor" -eq 2 ] && [ "$menor" -ge 23 ]; }; then
    ok "Git está instalado ($(git --version))"
  else
    fallo "Tu Git es demasiado antiguo ($(git --version)): necesitas la 2.23 o superior" \
      "Windows: descarga e instala la última versión de git-scm.com" \
      "Ubuntu: sudo apt update && sudo apt install git"
  fi

  local nombre email
  nombre=$(git config --global user.name)
  email=$(git config --global user.email)
  if [ -n "$nombre" ]; then ok "Tu nombre está configurado: $nombre"
  else fallo "No has configurado tu nombre" 'git config --global user.name "Tu Nombre Apellido"'; fi
  case "$email" in
    *@*.*) ok "Tu email está configurado: $email" ;;
    *)     fallo "No has configurado tu email (o no es válido)" 'git config --global user.email "el-email-de-tu-cuenta-de-github"' ;;
  esac

  if [ "$(git config --global init.defaultBranch)" = main ]; then ok "La rama principal de tus repositorios se llamará main"
  else fallo "Falta configurar el nombre de la rama principal" "git config --global init.defaultBranch main"; fi

  if [ "$(git config --global pull.rebase)" = false ]; then ok "git pull fusionará los cambios (pull.rebase = false)"
  else fallo "Falta configurar cómo se comporta git pull" "git config --global pull.rebase false"; fi

  local editor
  editor=$(git config core.editor)
  if [ -n "$editor" ]; then ok "Editor para los mensajes: $editor"
  else aviso "No has elegido editor, así que Git usará Vim (para salir de Vim: Esc, luego :q! y Enter)" \
      'Mejor: git config --global core.editor "nano"   (o "code --wait" si usas VS Code)'; fi

  if [ -n "$(git config --get-urlmatch credential.helper https://github.com 2>/dev/null)" ]; then
    ok "El inicio de sesión con GitHub está preparado"
  else
    aviso "No hay nada preparado para iniciar sesión en GitHub: el primer git push fallará" \
      "Ubuntu: sudo apt install gh   y luego   gh auth login   (paso 5 de la misión 0)"
  fi

  local url dueno
  url=$(git remote get-url origin 2>/dev/null)
  if [ -z "$url" ]; then
    fallo "Esta carpeta no tiene remoto origin" "¿Has descargado el taller con git clone? (paso 6)"
  elif ! printf '%s' "$url" | grep -q 'github\.com'; then
    fallo "origin no apunta a GitHub: $url"
  else
    dueno=$(dueno_url "$url")
    if [ "$(minusculas "$dueno")" = "$(minusculas "$PROFE")" ]; then
      fallo "Has clonado el repositorio ORIGINAL del profe, no tu fork" \
        "Borra esta carpeta, haz tu fork (lo explica el README) y clona el tuyo:" \
        "git clone https://github.com/TU-USUARIO/$REPO.git"
    else
      ok "Estás en tu fork: $dueno/$REPO"
    fi
  fi

  if [ "$(basename "$(dirname "$RAIZ")")" = taller ]; then
    ok "El taller está en su sitio: $(bonita "$RAIZ")"
  else
    aviso "El taller no está dentro de una carpeta llamada 'taller' ($(bonita "$RAIZ"))" \
      "No es grave, pero al comprobar las misiones 1 y 2 tendrás que decir dónde está tu primer repositorio:" \
      "bash comprobar.sh 1 RUTA"
  fi

  if existe_ref origin/aula-2 && existe_ref origin/servidor-impresion; then
    ok "Tienes las ramas de tus compañeros (aula-2 y servidor-impresion)"
  elif existe_ref upstream/aula-2 && existe_ref upstream/servidor-impresion; then
    ok "Tienes las ramas de tus compañeros (desde upstream)"
  else
    aviso "No tienes las ramas aula-2 y servidor-impresion" \
      "Seguramente no desmarcaste 'Copy the main branch only' al hacer el fork." \
      "No pasa nada: en la misión 4 se explica cómo traerlas."
  fi
}

# =====================================================================
#  MISIÓN 1 · Tu primer repositorio
# =====================================================================
mision1() {
  cabecera 1 "Tu primer repositorio"
  local r
  r=$(ruta_primer_repo)

  if [ ! -d "$r" ]; then
    if [ -d "$RAIZ/mi-primer-repo" ]; then
      fallo "Has creado mi-primer-repo DENTRO de la carpeta del taller" \
        "Tiene que estar al lado, en ~/taller/mi-primer-repo. Muévelo:" \
        "mv $(bonita "$RAIZ")/mi-primer-repo ~/taller/"
    else
      fallo "No encuentro tu repositorio en $(bonita "$r")" \
        "Créalo en ~/taller/mi-primer-repo o dime dónde está: bash comprobar.sh 1 RUTA"
    fi
    return
  fi
  if [ ! -d "$r/.git" ]; then
    fallo "$(bonita "$r") existe, pero no es un repositorio de Git" "Entra en esa carpeta y ejecuta: git init"
    return
  fi
  ok "Has creado el repositorio $(bonita "$r")"

  local n
  n=$(git -C "$r" rev-list --count HEAD 2>/dev/null || echo 0)
  if [ "$n" -ge 5 ]; then ok "Tiene $n commits"
  else fallo "Tiene $n commit(s) y hacen falta al menos 5" "Repasa los pasos y el reto de la misión 1"; fi

  if git -C "$r" cat-file -e HEAD:mi-equipo.md 2>/dev/null; then
    local veces
    veces=$(git -C "$r" log --format=%H -- mi-equipo.md | wc -l)
    if [ "$veces" -ge 2 ]; then ok "mi-equipo.md está guardado y lo has modificado en $veces commits"
    else fallo "mi-equipo.md solo aparece en 1 commit" "Modifícalo (RAM, disco, IP...) y haz otro commit"; fi
  else
    fallo "mi-equipo.md no está guardado en ningún commit" 'git add mi-equipo.md   y   git commit -m "Añade la ficha de mi equipo"'
  fi

  if git -C "$r" cat-file -e HEAD:programas.md 2>/dev/null; then ok "programas.md está guardado (reto)"
  else fallo "Falta programas.md (es el reto de la misión 1)" "Créalo, y luego git add + git commit"; fi

  if [ -n "$(git -C "$r" log --diff-filter=D --format=%H | head -1)" ]; then ok "Has borrado un archivo con un commit"
  else fallo "Ningún commit borra un archivo" "git rm borrador.txt   y luego   git commit -m \"Elimina el archivo de prueba\""; fi

  if [ -z "$(git -C "$r" status --porcelain)" ]; then ok "No hay cambios pendientes (git status está limpio)"
  else fallo "Tienes cambios sin guardar en un commit" "Mira git status dentro de $(bonita "$r") y haz add + commit de lo que falte"; fi

  local cortos
  cortos=$(git -C "$r" log --format=%s | awk 'length($0) < 10' | head -3 | tr '\n' '|' | sed 's/|$//; s/|/", "/g')
  if [ -z "$cortos" ]; then ok "Tus mensajes de commit son descriptivos"
  else aviso "Algunos mensajes de commit son muy cortos: \"$cortos\"" \
      "Un buen mensaje explica qué has cambiado. No hace falta corregirlos: tenlo en cuenta para la próxima."; fi
}

# =====================================================================
#  MISIÓN 2 · Sube a la nube
# =====================================================================
mision2() {
  cabecera 2 "Sube a la nube"
  necesito_email || return
  echo "  (consultando GitHub...)"
  traer origin
  cargar_original

  local ficha c
  ficha=$(git log main -F --author="$EMAIL" --diff-filter=A --name-only --format= -- empresa/personal/ \
          | grep -v '^$' | grep -v 'LEEME' | head -1)
  if [ -n "$ficha" ]; then
    ok "Has creado tu ficha: $ficha"
    c=$(git log main -F --author="$EMAIL" --diff-filter=A --format=%H -- "$ficha" | tail -1)
    if existe_ref origin/main && es_ancestro "$c" origin/main; then ok "Tu ficha está subida a GitHub"
    else fallo "Tu ficha no está subida a GitHub" "git push"; fi
  else
    fallo "No encuentro una ficha tuya ($EMAIL) en empresa/personal/" \
      "Crea empresa/personal/TU-USUARIO.md, y luego git add, git commit y git push"
  fi

  if [ -n "$(git log main --no-merges -F --committer=noreply@github.com --format=%H "${NO_ORIGINAL[@]}" | head -1)" ]; then
    ok "Has bajado a tu ordenador un cambio hecho desde la web de GitHub"
  elif existe_ref origin/main && [ -n "$(git log origin/main --no-merges -F --committer=noreply@github.com --format=%H "${NO_ORIGINAL[@]}" | head -1)" ]; then
    fallo "Hiciste un cambio desde la web, pero no lo has bajado a tu ordenador" "git pull"
  else
    fallo "No encuentro ningún cambio hecho desde la web de GitHub" \
      "Edita tu ficha en GitHub (botón del lápiz) y pulsa Commit changes. Después: git pull"
  fi

  comprobar_subido

  local r u h arriba
  r=$(ruta_primer_repo)
  if [ ! -d "$r/.git" ]; then
    fallo "No encuentro tu primer repositorio en $(bonita "$r")" "Si está en otro sitio: bash comprobar.sh 2 RUTA"
    return
  fi
  u=$(git -C "$r" remote get-url origin 2>/dev/null)
  if ! printf '%s' "$u" | grep -q 'github\.com'; then
    fallo "mi-primer-repo no está conectado a GitHub" "Sigue el paso 4 de la misión 2: crea el repositorio vacío en GitHub y luego git remote add origin ..."
    return
  fi
  ok "mi-primer-repo está conectado a GitHub ($u)"
  GIT_TERMINAL_PROMPT=0 git -C "$r" fetch -q origin >/dev/null 2>&1
  h=$(git -C "$r" rev-parse -q --verify HEAD)
  arriba=$(git -C "$r" rev-parse -q --verify '@{u}' 2>/dev/null)
  if [ -z "$arriba" ]; then
    fallo "La rama de mi-primer-repo no está enlazada con GitHub" "cd $(bonita "$r")   y   git push -u origin main"
  elif [ "$h" = "$arriba" ]; then
    ok "mi-primer-repo está subido y al día"
  else
    fallo "mi-primer-repo tiene cambios sin subir o sin bajar" "cd $(bonita "$r")   y luego   git pull   y   git push"
  fi
  if git -C "$r" cat-file -e HEAD:README.md 2>/dev/null; then ok "mi-primer-repo tiene README.md (reto)"
  else fallo "mi-primer-repo no tiene README.md (es el reto)" "Créalo en tu ordenador, haz commit y push"; fi
  if [ -n "$(git -C "$r" log --no-merges -F --committer=noreply@github.com --format=%H | head -1)" ]; then
    ok "Has editado mi-primer-repo desde la web y lo has bajado (reto)"
  else
    fallo "No has bajado a mi-primer-repo ningún cambio hecho en la web (reto)" "Edita el README en GitHub y después: git pull"
  fi
}

# =====================================================================
#  MISIÓN 3 · La máquina del tiempo
# =====================================================================
mision3() {
  cabecera 3 "La máquina del tiempo"
  traer origin

  # El script asesino
  local actual culpable
  actual=$(git show "main:$SCRIPT_COPIAS" 2>/dev/null)
  culpable=$(git log main --format=%H -S"$RSYNC_MALO" -- "$SCRIPT_COPIAS" | tail -1)
  if printf '%s' "$actual" | grep -qF "$RSYNC_MALO"; then
    fallo "El script de copias sigue roto" \
      "Busca el culpable: git log --oneline -- $SCRIPT_COPIAS   o   git blame $SCRIPT_COPIAS" \
      "Y deshazlo con: git revert HASH"
  elif ! printf '%s' "$actual" | grep -qF "$RSYNC_BUENO"; then
    fallo "La línea de rsync del script no está como debería" \
      "Debería quedar: rsync -a $RSYNC_BUENO"
  elif [ -n "$culpable" ] && [ -n "$(git log main -F --grep="This reverts commit $culpable" --format=%H | head -1)" ]; then
    ok "Has encontrado el commit que rompió el script y lo has deshecho con git revert"
  else
    aviso "El script funciona, pero no lo has arreglado con git revert" \
      "No pasa nada, pero practica revert: es lo que se usa en un equipo de verdad."
  fi

  # El procedimiento desaparecido
  local f=empresa/procedimientos/alta-usuario.md
  if git cat-file -e "main:$f" 2>/dev/null; then
    if git show "main:$f" | grep -q 'passwd -e'; then ok "Has recuperado la última versión de alta-usuario.md"
    else fallo "Has recuperado alta-usuario.md, pero no es la última versión (le falta el paso 5)" \
        "Recupéralo del commit justo ANTERIOR al que lo borró: git restore --source=HASH~1 $f"; fi
  elif [ -f "$f" ]; then
    fallo "alta-usuario.md está en tu carpeta, pero no lo has guardado en un commit" "git add $f   y   git commit"
  else
    fallo "alta-usuario.md sigue sin aparecer" "Mira qué commit lo borró: git log --oneline -- $f"
  fi

  # .gitignore y la contraseña filtrada
  if git cat-file -e main:.gitignore 2>/dev/null; then
    if git diff --quiet main -- .gitignore 2>/dev/null; then ok ".gitignore está guardado en un commit"
    else fallo "Has cambiado .gitignore pero no has guardado los cambios" "git add .gitignore   y   git commit"; fi
  elif [ -f .gitignore ]; then
    fallo ".gitignore existe pero no está guardado en ningún commit" "git add .gitignore   y   git commit"
  else
    fallo "No hay archivo .gitignore en la raíz del taller" "Créalo como explica la parte 5"
  fi

  local prueba no_ignorados=""
  for prueba in "secreto.txt" ".env" "registro.log" "copias/lunes.tar.gz"; do
    git check-ignore -q "$prueba" || no_ignorados="$no_ignorados $prueba"
  done
  if [ -z "$no_ignorados" ]; then ok ".gitignore ignora los secretos, los logs y la carpeta copias/"
  else fallo "Git no ignora:$no_ignorados" "Revisa el contenido de tu .gitignore (parte 5)"; fi

  if [ ! -f secreto.txt ]; then
    fallo "No existe secreto.txt en la raíz del taller" "Créalo y escribe dentro la contraseña que encontraste (parte 5)"
  elif git ls-files --error-unmatch secreto.txt >/dev/null 2>&1; then
    fallo "¡Has guardado secreto.txt en un commit! Justo lo que NO hay que hacer" \
      "Sácalo del repositorio (sin borrarlo de tu carpeta): git rm --cached secreto.txt   y   git commit"
  else
    if [ "$(tr -d ' \r\n' < secreto.txt | sha256sum | cut -d' ' -f1)" = "$HUELLA_CLAVE" ]; then
      ok "secreto.txt tiene la contraseña que se filtró. ¡Buen trabajo, detective!"
    else
      fallo "La contraseña de secreto.txt no es la que se filtró" \
        "Busca router.conf en la historia: git log --oneline --all -- empresa/config/router.conf"
    fi
  fi

  comprobar_subido
}

# =====================================================================
#  MISIÓN 4 · Universos paralelos
# =====================================================================
ref_companero() {
  local r
  for r in "origin/$1" "upstream/$1" "$1"; do
    if existe_ref "$r"; then echo "$r"; return; fi
  done
}

mision4() {
  cabecera 4 "Universos paralelos"
  necesito_email || return
  traer origin

  if [ -n "$(git log main -F --author="$EMAIL" --format=%H -- empresa/inventario/impresoras.md | head -1)" ]; then
    ok "Has añadido tu impresora y el cambio está en main"
  else
    fallo "No encuentro en main tu commit con la nueva impresora" \
      "Hazlo en la rama nueva-impresora y fusiónala: git switch main   y   git merge nueva-impresora"
  fi

  local rama ref
  for rama in aula-2 servidor-impresion; do
    ref=$(ref_companero "$rama")
    if [ -z "$ref" ]; then
      fallo "No encuentro la rama $rama" "Lee el apartado «No me salen esas ramas» de la misión 4"
    elif es_ancestro "$ref" main; then
      ok "Has fusionado la rama $rama en main"
    else
      fallo "La rama $rama no está fusionada en main" "git switch main   y   git merge $rama"
    fi
  done

  if [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]; then
    fallo "Tienes una fusión a medias: termínala y vuelve a comprobar" \
      "Resuelve el conflicto, luego git add ARCHIVO y git commit   (o cancela con git merge --abort)"
    return
  fi
  local marcas
  marcas=$(git grep -l -E '^(<<<<<<<|>>>>>>>)( |$)' -- . ':!taller' 2>/dev/null | tr '\n' ' ')
  if [ -z "$marcas" ]; then ok "No quedan marcas de conflicto (<<<<<<< ======= >>>>>>>)"
  else fallo "Quedan marcas de conflicto en: $marcas" \
      "Abre el archivo y déjalo como debe quedar, sin las líneas <<<<<<<, ======= y >>>>>>>"; fi

  local tabla=empresa/red/direcciones-ip.md contenido repetidas ip_srv
  contenido=$(git show "main:$tabla" 2>/dev/null | tr -d '\r')
  repetidas=$(printf '%s\n' "$contenido" | grep -E '^\| *192\.168\.' | cut -d'|' -f2 | tr -d ' ' | sort | uniq -d | tr '\n' ' ')
  if [ -z "$repetidas" ]; then ok "No hay IPs repetidas en el plan de direcciones"
  else fallo "Hay IPs repetidas en $tabla: $repetidas" \
      "Dos dispositivos no pueden tener la misma IP: dale a uno de ellos una IP libre"; fi

  if printf '%s' "$contenido" | grep -q 'portatil-direccion' && printf '%s' "$contenido" | grep -q 'srv-impresion'; then
    ok "En el plan de IPs están los dos: el portátil de dirección y el servidor de impresión"
  else
    fallo "Falta el portátil de dirección o el servidor de impresión en $tabla" \
      "Al resolver el conflicto hay que quedarse con los dos, cada uno con su IP"
  fi

  ip_srv=$(printf '%s\n' "$contenido" | grep -E '^\|.*\| *srv-impresion *\|' | cut -d'|' -f2 | tr -d ' ' | head -1)
  if [ -n "$ip_srv" ] && git cat-file -e main:empresa/red/servidor-impresion.md 2>/dev/null; then
    local otras
    otras=$(git show main:empresa/red/servidor-impresion.md | grep -oE '192\.168\.[0-9]+\.[0-9]+' | grep -vxF "$ip_srv" | sort -u | tr '\n' ' ')
    if [ -z "$otras" ]; then
      ok "La IP del servidor de impresión ($ip_srv) coincide en la tabla y en servidor-impresion.md"
    else
      fallo "En la tabla el servidor de impresión tiene la $ip_srv, pero servidor-impresion.md dice: $otras" \
        "Si le cambiaste la IP al servidor, cámbiala también en empresa/red/servidor-impresion.md y haz commit"
    fi
  fi

  comprobar_subido
}

# =====================================================================
#  MISIÓN 5 · Trabajo en equipo
# =====================================================================
mision5() {
  cabecera 5 "Trabajo en equipo"
  necesito_email || return

  local u
  u=$(git remote get-url upstream 2>/dev/null)
  if [ -z "$u" ]; then
    fallo "No tienes el remoto upstream" "git remote add upstream https://github.com/$PROFE/$REPO.git"
  elif printf '%s' "$u" | grep -qi "$PROFE/$REPO"; then
    ok "upstream apunta al repositorio original ($PROFE/$REPO)"
  else
    fallo "upstream no apunta al repositorio original: $u" "git remote set-url upstream https://github.com/$PROFE/$REPO.git"
  fi
  echo "  (consultando GitHub...)"
  traer upstream
  traer origin

  local h archivo="" mio=""
  for h in $(git log --branches --remotes=origin -F --author="$EMAIL" --diff-filter=A --format=%H -- clase/); do
    archivo=$(git show --diff-filter=A --name-only --format= "$h" -- clase/ | grep -vE 'PLANTILLA|LEEME' | head -1)
    if [ -n "$archivo" ]; then mio=$h; break; fi
  done
  if [ -z "$mio" ]; then
    fallo "No encuentro tu presentación en clase/" \
      "Parte 3: git switch -c alta-TU-USUARIO upstream/main, copia la plantilla, commit y push"
    return
  fi
  ok "Has creado tu presentación: $archivo"

  local rama
  rama=$(git branch --format='%(refname:short)' --contains "$mio" | grep -vx 'main' | head -1)
  if [ -n "$rama" ]; then
    if existe_ref upstream/main; then
      local ajenos
      ajenos=$(git diff --name-only "upstream/main...$rama" | grep -v '^clase/' | head -3 | tr '\n' ' ')
      if [ -z "$ajenos" ]; then ok "Tu rama $rama solo lleva tu presentación"
      else fallo "Tu rama $rama lleva cambios que no son tu presentación: $ajenos..." \
          "La rama tiene que salir de upstream/main. Crea otra: git switch -c alta-2-TU-USUARIO upstream/main" \
          "vuelve a añadir tu archivo y abre la Pull Request desde esa rama"; fi
    fi
    if existe_ref "origin/$rama" && es_ancestro "$mio" "origin/$rama"; then ok "La rama $rama está subida a tu fork"
    else fallo "La rama $rama no está subida a tu fork" "git push -u origin $rama"; fi
  fi

  if existe_ref upstream/main && es_ancestro "$mio" upstream/main; then
    ok "¡Tu Pull Request ha sido aceptada! Tu presentación ya está en el repositorio original"
    if es_ancestro upstream/main main; then ok "Tu fork está al día con el original"
    else aviso "Tu main está por detrás del repositorio original" \
        "Parte 6: git switch main, git fetch upstream, git merge upstream/main y git push"; fi
  else
    aviso "Tu Pull Request todavía no está aceptada" \
      "Es normal: espera a que el profe la revise. Mientras, revisa la de algún compañero."
  fi
}

# =====================================================================
#  MISIÓN 6 · Misión final (en pareja)
# =====================================================================
mision6() {
  cabecera 6 "Misión final (en pareja)"
  echo "  (consultando GitHub...)"
  traer origin
  cargar_original

  local dueno pr
  dueno=$(dueno_url "$(git remote get-url origin 2>/dev/null)")
  pr=$(git log main --merges -i -E --grep="^Merge pull request #[0-9]+ from $dueno/" --format=%s "${NO_ORIGINAL[@]}" | head -1)
  if [ -n "$pr" ]; then ok "Hay una Pull Request aceptada en este repositorio: «$pr»"
  else fallo "No encuentro ninguna Pull Request fusionada en este repositorio ($dueno/$REPO)" \
      "Fase 2: issue → rama → Pull Request (¡con base repository $dueno/$REPO!) → revisión → Merge" \
      "Si ya la habéis fusionado: git switch main   y   git pull"; fi

  local filas
  filas=$(git show main:empresa/procedimientos/incidencias.md 2>/dev/null | tr -d '\r' | grep -cE '^\| *[0-9]{2}/[0-9]{2}/[0-9]{4}')
  if [ "$filas" -ge 5 ]; then ok "El registro de incidencias tiene las de los dos ($filas incidencias)"
  else fallo "En el registro de incidencias hay $filas incidencias y debería haber al menos 5" \
      "Fase 1: cada uno añade una y, al resolver el conflicto, os quedáis con las dos"; fi

  if git show main:empresa/inventario/equipos.md 2>/dev/null | tr -d '\r' | grep -E '^\| *pc-recepcion *\|' | grep -q '16 GB'; then
    ok "pc-recepcion ya tiene 16 GB de RAM en el inventario (ticket resuelto)"
  else
    fallo "En el inventario, pc-recepcion no tiene 16 GB de RAM" "Es el ticket de la fase 2"
  fi

  local personas
  personas=$(git log main --no-merges --format=%ae "${NO_ORIGINAL[@]}" -- empresa/procedimientos/incidencias.md | grep -v '@technova\.example$' | sort -u | grep -c .)
  if [ "$personas" -ge 2 ]; then ok "En el registro de incidencias habéis escrito al menos 2 personas"
  else fallo "Solo encuentro commits de una persona" \
      "¿Estáis trabajando los dos en el repositorio de A? ¿Has hecho git pull?"; fi

  comprobar_subido
}

# =====================================================================
#  Resumen y diploma
# =====================================================================
SIGUIENTE=("taller/1-primer-repositorio.md" "taller/2-sube-a-la-nube.md" "taller/3-maquina-del-tiempo.md"
           "taller/4-universos-paralelos.md" "taller/5-trabajo-en-equipo.md" "taller/6-mision-final.md"
           "taller/extras.md")

resumen() {
  echo
  if [ "$FALLOS" -eq 0 ]; then
    echo "  ${VERDE}${NEGRITA}*** ¡MISIÓN $1 COMPLETADA! ***${NORMAL}"
    echo "  Siguiente: ${SIGUIENTE[$1]}"
  else
    echo "  ${ROJO}${NEGRITA}Te falta(n) $FALLOS cosa(s).${NORMAL} Sigue las pistas (>) y vuelve a ejecutar: bash comprobar.sh $1"
  fi
  echo
}

todas() {
  local i estado=() completas=0
  for i in 0 1 2 3 4 5 6; do
    "mision$i"
    if [ "$FALLOS" -eq 0 ]; then estado+=("${VERDE}completada${NORMAL}"); completas=$((completas + 1))
    else estado+=("${ROJO}le faltan $FALLOS cosa(s)${NORMAL}"); fi
  done
  echo
  echo "${NEGRITA}${CIAN}=== RESUMEN ===${NORMAL}"
  for i in 0 1 2 3 4 5 6; do echo "  Misión $i: ${estado[$i]}"; done
  echo
  local nombre
  nombre=$(git config user.name)
  if [ "$completas" -eq 7 ] || { [ "$completas" -eq 6 ] && [ "$FALLOS" -gt 0 ]; }; then
    echo "${VERDE}${NEGRITA}"
    echo "  +------------------------------------------------------+"
    echo "  |                                                      |"
    echo "  |          D I P L O M A   D E   G I T                 |"
    echo "  |               Technova Solutions                     |"
    echo "  |                                                      |"
    echo "  +------------------------------------------------------+"
    echo "${NORMAL}"
    echo "    Se certifica que ${NEGRITA}${nombre:-(sin nombre)}${NORMAL}"
    echo "    ha completado el taller de Git y GitHub."
    if [ "$completas" -eq 7 ]; then echo "    ${AMARILLO}Con matrícula de honor: misión final incluida.${NORMAL}"; fi
    echo
    echo "    Firmado: Laura Martín, jefa de sistemas"
    echo
  else
    echo "  Llevas $completas de 7 misiones. ¡Sigue así!"
    echo "  (La misión 6 compruébala en la carpeta del repositorio de tu pareja si trabajasteis en el suyo.)"
    echo
  fi
}

uso() {
  echo "Uso: bash comprobar.sh <misión>    (de 0 a 6)"
  echo "     bash comprobar.sh todas"
  echo
  echo "Ejemplo: bash comprobar.sh 3"
}

# =====================================================================
#  Programa principal
# =====================================================================
RUTA_PRIMER_REPO=""
if [ -n "${2:-}" ]; then
  RUTA_PRIMER_REPO="$(cd "$2" 2>/dev/null && pwd || echo "$2")"
fi
cd "$(dirname "$0")" || exit 1
RAIZ="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$RAIZ" ]; then
  echo "Este script tiene que estar dentro de la carpeta del taller (la que descargaste con git clone)."
  exit 1
fi
RAIZ="$(cd "$RAIZ" && pwd)"
cd "$RAIZ" || exit 1
EMAIL="$(git config user.email)"

case "${1:-}" in
  0|1|2|3|4|5|6)
    "mision$1"
    resumen "$1"
    [ "$FALLOS" -eq 0 ]
    exit $?
    ;;
  todas)
    todas
    ;;
  *)
    uso
    exit 1
    ;;
esac
