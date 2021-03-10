### run-indexer.sh

A rather complicated script to pull in environmental variables and run
the GOlr indexer on a running Solr instance.

### run-command.sh

A less complicated script to start the Solr (GOlr) instance once the
index is present at the right location (see `run-indexer.sh`) and run
a command in that environment.

To be used as: `bash run-command.sh -c "echo 'nested command example'"`

### tester.sh

A small testing file to ensure that the bash arguments in
`run-command.sh` work as desired. Not to be entered into the image.
