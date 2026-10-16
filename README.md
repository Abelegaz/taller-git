# Taller de Git y GitHub

**Technova Solutions** · Departamento de Sistemas

> **Laura (jefa de sistemas):** ¡Hola, te damos la bienvenida al equipo! En este departamento todo lo importante (el inventario de equipos, el plan de direcciones IP, los scripts de mantenimiento, los procedimientos...) está guardado en **este repositorio de Git**. Así sabemos quién cambió qué, cuándo y por qué, y podemos deshacer cualquier error. Antes de tocar nada necesito que aprendas a usarlo, así que te he preparado unas misiones. ¡Suerte!

---

## Cómo funciona este taller

- Hay **7 misiones**. Hazlas **en orden**: cada una usa lo que aprendiste en la anterior.
- Cada misión te explica lo que necesitas saber, te guía paso a paso y, casi siempre, termina con un **reto** que haces tú solo/a.
- Al terminar cada misión, compruebas tu trabajo con un script que lo corrige:
  ```bash
  bash comprobar.sh 3     # cambia el 3 por el número de la misión
  ```
- Ve a tu ritmo: lee, prueba, rompe cosas y arréglalas. Para eso está.
- Si algo falla, mira [Me he atascado](taller/atascos.md) antes de preguntar.

## Antes de empezar: haz tu copia del taller

1. Entra en GitHub con tu cuenta. Si todavía no tienes, créala en [github.com/signup](https://github.com/signup) (lee antes el [paso 1 de la misión 0](taller/0-preparacion.md#1-crea-tu-cuenta-de-github)).
2. Pulsa aquí: **[Hacer fork del taller](https://github.com/GonJimenezCampos/taller-git/fork)**
3. **Desmarca** la casilla **Copy the `main` branch only** y pulsa **Create fork**.

Ya tienes tu propia copia del taller en GitHub: `github.com/TU-USUARIO/taller-git`. A partir de ahora trabajarás siempre en **tu** copia. Qué es exactamente un *fork* lo entenderás en la misión 2.

> Si estás leyendo esto en tu fork (debajo del nombre del repositorio pone *forked from GonJimenezCampos/taller-git*), este paso ya está hecho.

## Misiones

| | Misión | Qué aprenderás |
|:-:|---|---|
| 0 | [Prepara tu puesto](taller/0-preparacion.md) | Instalar y configurar Git, descargar el taller |
| 1 | [Tu primer repositorio](taller/1-primer-repositorio.md) | `init`, `status`, `add`, `commit`, `log`, `diff` |
| 2 | [Sube a la nube](taller/2-sube-a-la-nube.md) | GitHub, `clone`, `push`, `pull`, Markdown |
| 3 | [La máquina del tiempo](taller/3-maquina-del-tiempo.md) | Investigar el historial y deshacer errores |
| 4 | [Universos paralelos](taller/4-universos-paralelos.md) | Ramas, fusiones y conflictos |
| 5 | [Trabajo en equipo](taller/5-trabajo-en-equipo.md) | Issues y Pull Requests |
| 6 | [Misión final](taller/6-mision-final.md) | Todo junto, en pareja |
| + | [Extras](taller/extras.md) | Para seguir aprendiendo |

Cuando acabes todas: `bash comprobar.sh todas`

## Material de consulta

- [Chuleta de comandos](taller/chuleta.md): tenla siempre abierta en otra pestaña.
- [Glosario](taller/glosario.md): qué significa cada palabreja (commit, rama, merge...).
- [Me he atascado](taller/atascos.md): errores típicos y cómo salir de ellos.

## Qué hay en este repositorio

| Carpeta | Qué es |
|---|---|
| [`empresa/`](empresa/) | La documentación del departamento de sistemas de Technova Solutions. Es lo que vas a mantener. |
| [`taller/`](taller/) | Las misiones y el material de consulta. |
| [`clase/`](clase/) | Las presentaciones de la clase (misión 5). |
| `comprobar.sh` | El script que corrige tus misiones. |

> Technova Solutions es una empresa inventada. Las personas, equipos, IPs y contraseñas de este repositorio son ficticios.
