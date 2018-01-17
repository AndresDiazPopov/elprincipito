Cada vez que se haga un merge a `develop`, hay que ejecutar el script que modifica automáticamente el `CHANGELOG.md` en base a los archivos de `changelogs/unmerged/`:

```
./bin/changelog_parser CÓDIGO_VERSIÓN
```