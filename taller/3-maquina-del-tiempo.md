# Misión 3 · La máquina del tiempo

> **Laura:** Tenemos problemas. Esta noche la copia de seguridad ha **machacado los archivos originales** del servidor, ha desaparecido un procedimiento que estaba documentado y... creo que alguien subió una contraseña al repositorio hace tiempo. Necesito que investigues la historia. Ponte el sombrero de detective.

**Aprenderás:** leer la historia (`log`, `show`, `blame`) · descartar cambios (`restore`) · deshacer un commit (`revert`) · recuperar archivos borrados · viajar al pasado (`switch --detach`) · `.gitignore`

Antes de empezar, asegúrate de que estás en la carpeta del taller y al día:

```bash
cd ~/taller/taller-git
git pull
```

---

## Parte 1 · Leer la historia

Cada commit tiene un **identificador** (hash) como `a3f9c2e8b1d...`. Para referirte a un commit basta con los 7 primeros caracteres: `a3f9c2e`. En esta misión, cuando veas `HASH`, cámbialo por el identificador del commit que toque.

Estos son los comandos del detective. Pruébalos todos:

```bash
git log --oneline                    # un commit por línea
git log --oneline --graph --all      # con dibujo de ramas (también las de tus compañeros)
git log --reverse --oneline          # del más antiguo al más reciente
git log --author="Ana"               # solo los commits de Ana
git shortlog -sn                     # cuántos commits ha hecho cada persona
git log --stat                       # qué archivos cambió cada commit
git log --oneline -- empresa/inventario/impresoras.md   # solo los commits que tocan ese archivo
git show HASH                        # qué cambió exactamente en un commit
git log -p -- empresa/red/direcciones-ip.md             # la historia de un archivo con todos sus cambios
git blame empresa/red/direcciones-ip.md                 # quién escribió cada línea y en qué commit
```

> **Recuerda:** si ves `:` abajo, muévete con las flechas y sal con `q`.

### Preguntas de detective

Responde usando los comandos de arriba. Después mira las soluciones.

1. ¿Quién hizo el **primer commit** del repositorio y qué día?
2. Sin contarte a ti, ¿quién ha hecho **más commits** en la rama `main`?
3. ¿Quién añadió la **impresora de recepción** y qué día?
4. ¿Qué IP tiene el **NAS** y quién la reservó?
5. ¿Qué archivos borró el commit **«Limpia archivos antiguos»**?

<details>
<summary>Ver soluciones</summary>

1. **Laura Martín, el 1 de septiembre de 2026.** Es el primero que sale con `git log --reverse`.
2. **Laura Martín**, con 7 commits. Lo dice `git shortlog -sn`.
3. **Javi Gómez, el 18 de septiembre de 2026.** Con `git log -- empresa/inventario/impresoras.md` o con `git blame empresa/inventario/impresoras.md`.
4. **192.168.10.20, la reservó Carlos Ruiz.** La línea del NAS en `git blame empresa/red/direcciones-ip.md`.
5. **`empresa/notas-viejas.txt` y `empresa/procedimientos/alta-usuario.md`.** Con `git log --stat` o con `git show --stat HASH`. ¿Un procedimiento en un commit de «archivos antiguos»? Sospechoso... Lo necesitarás en la parte 4.
</details>

---

## Parte 2 · Descartar cambios que aún no has guardado

Vamos a romper algo **a propósito**:

```bash
echo "LO HE ROTO TODO" > empresa/inventario/equipos.md
cat empresa/inventario/equipos.md
git status
git diff
```

¡Te has cargado el inventario! Pero como **no has hecho commit**, se arregla con:

```bash
git restore empresa/inventario/equipos.md
git status
cat empresa/inventario/equipos.md
```

Como si no hubiera pasado nada. `git restore` devuelve el archivo a como estaba en el último commit.

> **Importante:** `git restore` **tira** los cambios que no has guardado y no hay forma de recuperarlos. Úsalo solo cuando quieras deshacerte de ellos de verdad.
>
> Si ya habías hecho `git add`, primero saca el archivo del staging con `git restore --staged archivo` (eso no pierde nada) y luego ya puedes descartarlo con `git restore archivo`.

---

## Parte 3 · El script asesino

> **Laura:** El script `empresa/scripts/copia-seguridad.sh` funcionaba perfectamente a mediados de septiembre, cuando Carlos lo mejoró. Ahora, en vez de copiar los archivos del servidor al NAS, ¡machaca los originales con la copia vieja! Alguien lo ha tocado. Encuentra qué commit lo rompió y deshazlo.

1. Mira el script:
   ```bash
   cat empresa/scripts/copia-seguridad.sh
   ```
   Fíjate en la línea de `rsync`. Pista: `rsync -a ORIGEN DESTINO` copia de ORIGEN a DESTINO. ¿Ves algo raro?

2. Busca qué commits han tocado el script:
   ```bash
   git log --oneline -- empresa/scripts/copia-seguridad.sh
   ```
   Han sido varios. Mira qué hizo cada uno con `git show HASH`, o ve directamente a la línea sospechosa con:
   ```bash
   git blame empresa/scripts/copia-seguridad.sh
   ```

3. Cuando tengas al culpable, **no lo arregles a mano**. Usa:
   ```bash
   git revert HASH
   ```
   `git revert` crea un **commit nuevo que hace justo lo contrario** del commit que le digas. Se abrirá el editor con un mensaje ya escrito (`Revert "..."`). No cambies nada: guarda y cierra.
   - **nano:** `Ctrl + O`, `Enter` y `Ctrl + X`.
   - **VS Code:** guarda (`Ctrl + S`) y cierra la pestaña.

4. Comprueba que el script vuelve a estar bien y que hay un commit nuevo:
   ```bash
   cat empresa/scripts/copia-seguridad.sh
   git log --oneline -3
   ```

> **¿Por qué `revert` y no borrar el commit malo?** Porque esa historia ya está compartida: tus compañeros tienen ese commit en sus ordenadores. `revert` no borra nada: añade un commit que deshace el cambio, y así queda constancia de qué pasó y de cómo se arregló. (Existe `git reset` para borrar commits, pero solo se usa con commits que **todavía no has subido**.)

---

## Parte 4 · El procedimiento desaparecido

> **Laura:** Alguien ha borrado `empresa/procedimientos/alta-usuario.md`. Lo necesitamos: recupera la **última versión** que hubo.

1. Busca qué commits han tocado ese archivo (aunque ya no exista, Git lo recuerda):
   ```bash
   git log --oneline -- empresa/procedimientos/alta-usuario.md
   ```
   El de arriba (el más reciente) es el que lo borró. Compruébalo:
   ```bash
   git show --stat HASH
   ```

2. El archivo existía en el commit **anterior** a ese. En Git, `HASH~1` significa «el commit anterior a HASH». Recupera el archivo de ahí:
   ```bash
   git restore --source=HASH~1 empresa/procedimientos/alta-usuario.md
   ```

3. Ya lo tienes en tu carpeta (`ls empresa/procedimientos/`). Guárdalo:
   ```bash
   git add empresa/procedimientos/alta-usuario.md
   git commit -m "Recupera el procedimiento de alta de usuarios, borrado por error"
   ```

---

## Parte 5 · La contraseña filtrada

> **Laura:** Hace tiempo alguien subió la configuración del router con la contraseña de administración. La borré enseguida... pero me temo que con eso no basta.

1. El archivo era `empresa/config/router.conf`. Ya no está:
   ```bash
   ls empresa/
   ```

2. Pero Git lo recuerda todo:
   ```bash
   git log --oneline --all -- empresa/config/router.conf
   ```
   Salen dos commits: el que lo creó y el que lo borró.

3. **Viaja al pasado**, al commit que lo creó (el de abajo, «Sube la configuración del router»):
   ```bash
   git switch --detach HASH
   ls empresa/
   cat empresa/config/router.conf
   ```
   Ahora estás viendo el repositorio **tal y como estaba ese día**: fíjate en que faltan carpetas y archivos que se crearon después (también desaparecen `taller/`, `README.md` y `comprobar.sh`: vuelven en cuanto regreses a `main`). Git solo responde `HEAD is now at ...`, pero si haces `git status` verás `HEAD detached at ...`: estás en ***detached HEAD***, de visita en el pasado, así que no hagas commits aquí.

   Apunta la contraseña de administración (lo que va detrás de `admin_password=`) y **vuelve al presente**:
   ```bash
   git switch main
   ```

   > **Atajo** para leer un archivo antiguo sin viajar: `git show HASH:empresa/config/router.conf`

4. **Moraleja:** borrar un archivo **no lo borra de la historia**. Cualquiera que clone el repositorio puede leer esa contraseña. Si una contraseña llega a GitHub hay que **cambiarla inmediatamente**: hay programas que rastrean GitHub en busca de contraseñas y claves a los pocos minutos de que se suban.

5. Para que no vuelva a pasar existe **`.gitignore`**: un archivo con una lista de cosas que Git debe **ignorar**. Lo que aparezca ahí, Git no lo verá ni lo subirá nunca.

   Crea en la carpeta principal del taller (`~/taller/taller-git`) un archivo llamado **`.gitignore`** (con el punto delante):
   ```bash
   code .gitignore     # o: nano .gitignore
   ```
   con este contenido:
   ```gitignore
   # Archivos con contraseñas o secretos
   secreto.txt
   .env

   # Registros (logs)
   *.log

   # Copias de seguridad locales
   copias/
   ```
   `*.log` significa «cualquier archivo que acabe en `.log`», y `copias/` es «la carpeta copias y todo lo que tenga dentro».

6. Ahora crea un archivo `secreto.txt` (también en la carpeta principal) y escribe dentro **solo la contraseña** que has encontrado (lo que va detrás de `admin_password=`, sin nada más). Cambia `LA-CONTRASEÑA` por la de verdad:
   ```bash
   echo "LA-CONTRASEÑA" > secreto.txt
   git status
   ```
   ¡Git no ve `secreto.txt`! Lo que sí ve es `.gitignore`, que hay que guardar:
   ```bash
   git add .gitignore
   git commit -m "Añade .gitignore para no subir secretos ni logs"
   ```
   No borres `secreto.txt`: el script de comprobación lo leerá para saber si encontraste la contraseña correcta.

---

## Parte 6 · Sube tu trabajo

```bash
git push
```

Mira tu fork en GitHub: verás tus tres commits nuevos (el revert, la recuperación y el `.gitignore`)... y ni rastro de `secreto.txt`.

---

## Reto

1. ¿Qué cambió exactamente Laura el **14 de octubre**? ¿Quién usa ese equipo?
2. Crea un archivo `prueba.log` y una carpeta `copias` con un archivo dentro. Comprueba con `git status` que Git los ignora.
3. Mira cómo ha quedado la historia con `git log --oneline --graph` y localiza los commits que has hecho en esta misión.

<details>
<summary>Solución de la pregunta 1</summary>

Cambió el disco de **pc-admin-02** de *SSD 512 GB* a *SSD 1 TB*. Ese equipo lo usa **Lucía**. Se ve con `git log --author="Laura"` para encontrar el commit y `git show HASH` para ver el cambio.
</details>

## Comprueba tu misión

```bash
bash comprobar.sh 3
```

---

## Resumen

| Comando | Para qué sirve |
|---|---|
| `git log --oneline --graph --all` | La historia completa con todas las ramas |
| `git log -- archivo` | Los commits que han tocado un archivo |
| `git log --author="nombre"` | Los commits de una persona |
| `git shortlog -sn` | Cuántos commits ha hecho cada persona |
| `git show HASH` | Qué cambió en un commit |
| `git show HASH:archivo` | Cómo era un archivo en un commit |
| `git blame archivo` | Quién escribió cada línea |
| `git restore archivo` | Descarta los cambios sin guardar de un archivo |
| `git restore --staged archivo` | Saca un archivo del staging |
| `git restore --source=HASH archivo` | Recupera un archivo tal y como estaba en un commit |
| `git revert HASH` | Crea un commit que deshace otro |
| `git switch --detach HASH` | Viaja a un commit del pasado (solo para mirar) |
| `git switch main` | Vuelve al presente |
| `HASH~1` | El commit anterior a HASH |
| `.gitignore` | Lista de archivos que Git debe ignorar |

---

Anterior: [Misión 2](2-sube-a-la-nube.md) · **Siguiente: [Misión 4 · Universos paralelos](4-universos-paralelos.md)**
