# Meilisearch Zsh Terminal Plugin

This is a zsh plugin built for Meilisearch API requests in Terminal.

It is written based on `curl` and is meant to help users quickly test
Meilisearch from Terminal.


## Environment
- `macOS` 12.0.1
- `zsh` 5.8
- `curl` 7.77.0
- `Meilisearch` 0.27.2


## Install
The prerequisite for this plugin is `curl`. Please refer to installation guide
on the [official website](https://curl.se/download.html) if you haven't gotten
it.

To use the plugin out of the box, you can source it from your terminal.
```bash
source .ms.plugin.zsh
```

In addition, you can run the following command to append it to your `.zshrc` and
avoid sourcing it manually every time.
```bash
echo "source $(realpath .ms.plugin.zsh)" >> ~/.zshrc
```


## Environment Variable
Please update the environment variable before running plugin functions.
- `MS_HOST`
  - where meilisearch is hosted
  - default: "localhost:7700"


## Functions
- Run functions with positional arguments to send request to Meilisearch.
  ```bash
  <function_name> $1 $2...
  ```

- Besides, you can run a function with `-h` or `--help` arguments and see the
description or available positional arguments for it.
  ```bash
  <function_name> --help
  ```
- offset
  - an argument to skip a certain amount of result from the head

- limit
  - an argument to limit how many result to return


### Index
| functions         | description      | positional arguments                           | reference                                                                        |
|:------------------|------------------|------------------------------------------------|----------------------------------------------------------------------------------|
| `ms-index-ls`     | List all indexes | (optional) $1: offset,<br>(optional) $2: limit | [link](https://docs.meilisearch.com/reference/api/indexes.html#list-all-indexes) |
| `ms-index-create` | Create an index  | $1: index name,<br>$2: primary key name        | [link](https://docs.meilisearch.com/reference/api/indexes.html#create-an-index)  |
| `ms-index-delete` | Delete an index  | $1: index name                                 | [link](https://docs.meilisearch.com/reference/api/indexes.html#delete-an-index)  |


### Documents
| functions           | description                                                                                                                 | positional arguments                                              | reference                                                                                  |
|:--------------------|-----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| `ms-doc-get-by-id`  | Get one document using its unique id.                                                                                       | $1: index name,<br>$2: doc id                                     | [link](https://docs.meilisearch.com/reference/api/documents.html#get-one-document)         |
| `ms-doc-get-asc`    | Get documents by batch.<br>Documents are ordered by Meilisearch depending on the hash of their id.                          | $1: index name,<br>(optional) $2: offset,<br>(optional) $3: limit | [link](https://docs.meilisearch.com/reference/api/documents.html#get-documents)            |
| `ms-doc-index`      | Add a list of documents or replace them if they already exist.<br>If the provided index does not exist, it will be created. | $1: index name,<br>$2: path to data                               | [link](https://docs.meilisearch.com/reference/api/documents.html#add-or-replace-documents) |
| `ms-doc-delete`     | Delete one document based on its unique id.                                                                                 | $1: index name,<br>$2: doc id                                     | [link](https://docs.meilisearch.com/reference/api/documents.html#delete-one-document)      |
| `ms-doc-delete-all` | Delete all documents in the specified index.                                                                                | $1: index name                                                    | [link](https://docs.meilisearch.com/reference/api/documents.html#delete-all-documents)     |


### Settings
| functions            | description                      | positional arguments                                 | reference                                                                        |
|:---------------------|----------------------------------|------------------------------------------------------|----------------------------------------------------------------------------------|
| `ms-settings-ls`     | Get the settings of an index.    | $1: index name                                       | [link](https://docs.meilisearch.com/reference/api/settings.html#get-settings)    |
| `ms-settings-update` | Update the settings of an index. | $1: index name,<br>$2: path to updated settings file | [link](https://docs.meilisearch.com/reference/api/settings.html#update-settings) |


### Task
| functions           | description                                   | positional arguments                                                     | reference                                                                  |
|:--------------------|-----------------------------------------------|--------------------------------------------------------------------------|----------------------------------------------------------------------------|
| `ms-task-ls`        | List all tasks globally, regardless of index. | (optional) $1: limit,<br>(optional) $2: task id of the first task returned | [link](https://docs.meilisearch.com/reference/api/tasks.html#get-tasks)    |
| `ms-task-get-by-id` | Get a single task.                            | $1: task id                                                              | [link](https://docs.meilisearch.com/reference/api/tasks.html#get-one-task) |


## Reference
- [Meilisearch API reference](https://docs.meilisearch.com/reference/api/overview.html)
