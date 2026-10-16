# Misión 6 · Misión final, en pareja

> **Laura:** Última prueba: trabajar codo con codo con otra persona en el mismo repositorio, como hacemos en el departamento. Vais a chocar, vais a tener conflictos... y vais a resolverlos.

**Practicarás:** colaboradores · push rechazado · conflictos entre personas · el ciclo completo issue → rama → Pull Request → revisión → merge

**En parejas**

---

## Reparto de papeles

Decidid quién es quién:

- **Persona A:** dueña del repositorio. Se trabaja en **el fork de A**.
- **Persona B:** colaboradora.

Si queréis, al final cambiáis los papeles y lo repetís en el fork de B.

En todos los comandos, cambia `USUARIO-A` por el usuario de GitHub de la persona A.

---

## Preparación

**A:**

1. En tu fork, ve a **Settings** → **Collaborators** → **Add people** y escribe el usuario de B. (GitHub puede pedirte la contraseña o el código 2FA.)
2. En **Settings** → **General**, baja hasta el apartado **Features** y marca **Issues**. En los forks vienen desactivadas.

**B:**

1. Acepta la invitación. Te llega por email, o entra directamente en `https://github.com/USUARIO-A/taller-git/invitations`
2. Clona el repositorio de A **en una carpeta nueva**, para no mezclarlo con el tuyo:
   ```bash
   cd ~/taller
   git clone https://github.com/USUARIO-A/taller-git.git equipo-USUARIO-A
   cd equipo-USUARIO-A
   ```

A partir de aquí, A trabaja en `~/taller/taller-git` y B en `~/taller/equipo-USUARIO-A`. Es el mismo repositorio de GitHub.

---

## Fase 1 · Choque de trenes

Vais a apuntar **cada uno una incidencia distinta, en el mismo sitio** del mismo archivo.

**A y B, a la vez:**

1. Poneos en `main` y bajad la última versión:
   ```bash
   git switch main
   git pull
   ```
2. Abrid `empresa/procedimientos/incidencias.md` y añadid **una fila al final** de la tabla *Registro*. Cada uno una incidencia inventada, distinta. Por ejemplo:
   ```markdown
   | 22/10/2026 | pc-aula1-03 | No detecta el ratón | Cambiado de puerto USB | Lucía |
   ```
3. Haced commit:
   ```bash
   git add empresa/procedimientos/incidencias.md
   git commit -m "Registra la incidencia de pc-aula1-03"
   ```
   (Cambia `pc-aula1-03` por el equipo de tu incidencia.)

**A** sube primero:

```bash
git push
```

**B** sube después:

```bash
git push
```

**¡Rechazado!**

```
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'https://github.com/USUARIO-A/taller-git.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally.
```

GitHub tiene un commit (el de A) que B no tiene. Git no deja subir para no machacarlo. La solución es siempre la misma: **primero bajar, luego subir**.

**B:**

```bash
git pull
```

Como los dos habéis tocado el mismo sitio del archivo: **conflicto**. Resuélvelo como en la misión 4: deja **las dos incidencias** y quita las marcas `<<<<<<<`, `=======` y `>>>>>>>`. Después:

```bash
git add empresa/procedimientos/incidencias.md
git commit -m "Junta las incidencias de A y de B"
git push
```

**A:** baja los cambios y comprueba que tienes las dos incidencias:

```bash
git pull
```

> **Moraleja:** haz `git pull` **antes de empezar** a trabajar y **sube a menudo**. Cuanto más tardes en subir, más fácil es chocar.

---

## Fase 2 · El ticket

Así se trabaja en un equipo de verdad: **issue → rama → Pull Request → revisión → merge**.

### 1. A abre una issue

En su repositorio, pestaña **Issues** → **New issue**:

- **Título:** `El PC de recepción va muy lento`
- **Descripción:** `Marta dice que tarda muchísimo en abrir el correo. Hay que ampliar la RAM a 16 GB, apuntarlo en el inventario y cerrar la incidencia del 08/10/2026.`
- A la derecha, en **Assignees**, asígnasela a B.

Pulsa **Create** y apuntad el número (seguramente `#1`).

### 2. B trabaja en una rama

```bash
git switch main
git pull
git switch -c ticket-ram-recepcion
```

- En `empresa/inventario/equipos.md`, cambia la RAM de `pc-recepcion` de 8 GB a **16 GB**.
- En `empresa/procedimientos/incidencias.md`, en la incidencia del 08/10/2026, cambia «Pendiente: valorar ampliar la RAM» por la solución.

Haz commit y sube la rama:

```bash
git add empresa/inventario/equipos.md empresa/procedimientos/incidencias.md
git commit -m "Amplía la RAM del PC de recepción a 16 GB"
git push -u origin ticket-ram-recepcion
```

### 3. B abre la Pull Request

En el repositorio de A en GitHub, pulsa **Compare & pull request**.

**¡Cuidado!** Como el repositorio de A es un fork, GitHub pone por defecto como destino el repositorio **del profe**. Cambia **base repository** a `USUARIO-A/taller-git`. Tiene que quedar:

**base repository:** `USUARIO-A/taller-git` · **base:** `main` ← **compare:** `ticket-ram-recepcion`

En la descripción escribe `Closes #1` (con el número de la issue) y pulsa **Create pull request**.

### 4. A revisa y pide un cambio

En la PR → pestaña **Files changed** → **Review changes** → elige **Request changes** y escribe, por ejemplo: *«Pon también en la incidencia la fecha en que se amplió la RAM.»* Pulsa **Submit review**.

### 5. B corrige

Haz el cambio que te piden, en la **misma rama**:

```bash
git add empresa/procedimientos/incidencias.md
git commit -m "Añade la fecha de la ampliación de RAM"
git push
```

La PR se actualiza sola.

### 6. A aprueba y fusiona

**Files changed** → **Review changes** → **Approve** → **Submit review**. Después, en la pestaña **Conversation**: **Merge pull request** → **Confirm merge**. Deja la opción que viene por defecto (*Create a merge commit*): no elijas *Squash* ni *Rebase*.

Mira la pestaña **Issues**: ¡la #1 se ha cerrado sola!

### 7. A y B os ponéis al día

```bash
git switch main
git pull
git log --oneline --graph
```

---

## Fase 3 (opcional) · Cambio de papeles

Repetid todo en el fork de B: ahora B es la dueña y A la colaboradora. Inventad otra issue: ¿el NAS se está quedando sin espacio? ¿llega una impresora nueva? ¿hay que reservar IP para un punto de acceso WiFi?

---

## Comprueba tu misión

Cada uno en **su carpeta del repositorio de A**:

- A: `cd ~/taller/taller-git`
- B: `cd ~/taller/equipo-USUARIO-A`

```bash
bash comprobar.sh 6
```

---

## ¡Lo has conseguido!

Desde tu propio repositorio, comprueba todas las misiones a la vez:

```bash
cd ~/taller/taller-git
bash comprobar.sh todas
```

Si en la pareja eras B, la misión 6 saldrá incompleta en tu repositorio, porque la hicisteis en el de A. No pasa nada: el diploma te sale igual.

Lo que has aprendido en este taller es lo que usan cada día millones de profesionales de la informática. Pon tu perfil de GitHub en tu CV: es tu escaparate.

¿Quieres seguir aprendiendo? Pásate por los **[Extras](extras.md)**.

---

Anterior: [Misión 5](5-trabajo-en-equipo.md) · [Volver al inicio](../README.md)
