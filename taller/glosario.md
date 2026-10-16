# Glosario

| Palabra | Qué significa |
|---|---|
| **Blame** | Comando que muestra quién escribió cada línea de un archivo y en qué commit. *Blame* significa «culpar». |
| **Branch** (rama) | Una línea de trabajo paralela. Puedes hacer commits en ella sin afectar a las demás. |
| **Clone** | Descargar un repositorio de GitHub a tu ordenador, con toda su historia. |
| **Collaborator** | Persona a la que el dueño de un repositorio de GitHub deja subir cambios. |
| **Commit** | Un «punto de guardado»: cómo estaban los archivos en un momento, con autor, fecha y mensaje. |
| **Conflicto** | Cuando dos ramas cambian la misma parte de un archivo y Git no sabe con qué quedarse. Lo resuelves tú. |
| **Detached HEAD** | Estás mirando un commit antiguo en lugar de una rama. Para volver: `git switch main`. |
| **Diff** | Las diferencias entre dos versiones de un archivo. `+` es lo añadido y `-` lo quitado. |
| **Fast-forward** | Una fusión sencilla: la rama no había cambiado, así que Git solo la «adelanta». |
| **Fetch** | Preguntar a GitHub qué hay nuevo, sin tocar tus archivos. |
| **Fork** | Tu copia en GitHub del repositorio de otra persona. |
| **Git** | El programa de control de versiones. Funciona en tu ordenador. |
| **GitHub** | Una web donde se guardan repositorios de Git para compartirlos y colaborar. |
| **.gitignore** | Archivo con la lista de cosas que Git debe ignorar (contraseñas, logs...). |
| **Hash** | El identificador de un commit, por ejemplo `a3f9c2e`. |
| **HEAD** | «Dónde estás ahora»: normalmente, el último commit de tu rama actual. |
| **Issue** | Una tarea o incidencia apuntada en GitHub, como un ticket de soporte. |
| **main** | El nombre habitual de la rama principal (antes se llamaba `master`). |
| **Markdown** | El formato de los archivos `.md`: texto normal con símbolos como `#` o `**`. |
| **Merge** (fusionar) | Juntar los cambios de una rama en otra. |
| **Merge commit** | El commit que crea Git al fusionar dos ramas que habían avanzado por separado. |
| **origin** | El nombre habitual del remoto principal: de donde clonaste (tu fork). |
| **Pull** | Bajar los cambios de GitHub y aplicarlos (`fetch` + `merge`). |
| **Pull Request** (PR) | Una propuesta de cambios: «¿fusionas mi rama en la tuya?». |
| **Push** | Subir tus commits a GitHub. |
| **Remoto** | Una copia del repositorio en otro sitio (normalmente GitHub). |
| **Repositorio** | Una carpeta cuya historia guarda Git. |
| **Restore** | Devolver un archivo a como estaba en un commit. |
| **Revert** | Crear un commit nuevo que deshace otro commit. |
| **Review** | Revisar los cambios de una Pull Request: comentar, aprobar o pedir cambios. |
| **Staging** | La zona de preparación: los cambios elegidos para el próximo commit. |
| **upstream** | El nombre habitual del repositorio original del que hiciste fork. |
| **Working directory** | Tu carpeta de trabajo, con los archivos tal y como están ahora. |

## Mensajes de Git en inglés y en español

Según cómo esté instalado, Git te hablará en inglés o en español (la traducción exacta puede variar un poco según la versión).

| En inglés | En español | Qué quiere decir |
|---|---|---|
| `Untracked files` | `Archivos sin seguimiento` | Archivos nuevos que Git aún no sigue |
| `Changes not staged for commit` | `Cambios no rastreados para el commit` | Has cambiado archivos pero no has hecho `git add` |
| `Changes to be committed` | `Cambios a ser confirmados` | Lo que hay en el staging: entrará en el próximo commit |
| `modified` | `modificados` | Archivo cambiado |
| `new file` | `nuevos archivos` | Archivo nuevo |
| `deleted` | `borrados` | Archivo borrado |
| `both modified` | `ambos modificados` | Archivo con conflicto |
| `nothing to commit, working tree clean` | `nada para hacer commit, el árbol de trabajo está limpio` | Todo guardado |
| `Your branch is ahead of 'origin/main' by 2 commits` | `Tu rama está adelantada a 'origin/main' por 2 commits` | Tienes 2 commits sin subir: `git push` |
| `Your branch is behind 'origin/main' by 1 commit` | `Tu rama está detrás de 'origin/main' por 1 commit` | Hay 1 commit nuevo en GitHub: `git pull` |
| `Your branch is up to date` | `Tu rama está actualizada` | Igual que GitHub (según la última vez que preguntaste) |

---

[Volver al inicio](../README.md)
