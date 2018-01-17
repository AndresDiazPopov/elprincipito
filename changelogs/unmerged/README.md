Cada vez que se haga una feature:

1. Hay que crear uno o más archivos (se creará un archivo por cambio) en `changelogs/unmerged/`, con el nombre `CODE-XX.yml` (según el código de la tarea en JIRA), que contenga los cambios con siguiente formato:

```yaml
action: Added | Changed | Fixed | Deprecated
message: Texto descriptivo del cambio
issue: Código de la tarea, tal y como aparece en JIRA (OPCIONAL PERO RECOMENDABLE!)
```

2. Eso se sube junto con los cambios en sí al Pull Request.