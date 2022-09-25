lm# elm-project
Dans ce projet nous ferons comment faire des requêtes HTTP asynchrones, décoder des données JSON avec des décodeurs JSON classiques et des décodeurs JSON avec pipelines

# Create a file elm.json
```elm init```

# Compile a elm file
```elm make src/Main.elm``` par exemple

# Launch app elm
```elm init```

# Install http-server
```npm i http-server -g``` 

# Launch http server in a local
```http-server server -a localhost -p 3000```

# Install package elm/http
```elm install elm/http```

# Les problèmes de CORS
Si le chargement des données n’a pas fonctionné, consultez votre console vous devriez avoir un problème de CORS, car si nous ne l’avons pas activé au moment de lancer le serveur local.

# Solution pour résoudre le problème les CORS
Relancer le serveur local en précisant l’option des cors --cors
```http-server server -a localhost -p 3000 --cors```
Si l'erreur persiste essayer un autre navigateur web (safari, mozilla, opéra ...)


