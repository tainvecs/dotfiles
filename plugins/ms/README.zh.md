# Meilisearch Zsh Terminal Plugin

這是一個 `zsh` 終端機 plugins。
<br>它基於 `curl` 為 `Meilisearch` API Request 提供更加簡易的介面，以便於使用者在終端機環境中使用與測試
`Meilisearch`。


## 環境設置
- `macOS` 12.0.1
- `zsh` 5.8
- `curl` 7.77.0
- `Meilisearch` 0.27.2


## 安裝
如果終端機環境中缺少 `curl`，請先參考 [官方網站](https://curl.se/download.html) 安裝 `curl`。

在終端機中使用 `source` 指令讀取 plugin 原始碼，便可以馬上使用此 plugin。
```bash
source .ms.plugin.zsh
```

此外，你也可以在終端機中執行以下指令。
<br>它會將讀取 plugin 原始碼的 `source` 指令，加入到家目錄下的 `.zshrc` 中，使 `source` 指令於每次終端機開啟時被自動執行。
```bash
echo "source $(realpath .ms.plugin.zsh)" >> ~/.zshrc
```


## 環境變數
在使用 plugin 前，請檢查環境變數。
- `MS_HOST`
  - `Meilisearch` 所在連結
  - 預設："localhost:7700"


## Functions (函式)
- 執行 functions 並傳入適當 positional arguments (位置參數) 來向 `Meilisearch` 發送 request.
  ```bash
  <function_name> $1 $2...
  ```

- 在使用 plugin functions 時，你可以使用 `-h` 或 `--help` 來獲取 function 簡介或是參數資訊。
  ```bash
  <function_name> --help
  ```

- offset (偏移量)
  - 在取得回傳資料時，從第幾個開始取

- limit (限制)
  - 限制回傳的資料個數


### Index (索引)
| functions         | 簡介             | positional arguments                    | 參考連結                                                                         |
|:------------------|:-----------------|:----------------------------------------|:---------------------------------------------------------------------------------|
| `ms-index-ls`     | 列出所有 indexes | $1: offset,<br>$2: limit                | [link](https://docs.meilisearch.com/reference/api/indexes.html#list-all-indexes) |
| `ms-index-create` | 建立一個 index   | $1: index 名稱,<br>$2: primary key 名稱 | [link](https://docs.meilisearch.com/reference/api/indexes.html#create-an-index)  |
| `ms-index-delete` | 刪除一個 index   | $1: index 名稱                          | [link](https://docs.meilisearch.com/reference/api/indexes.html#delete-an-index)  |


### Documents (文檔)
| functions           | 簡介                                                                                                                   | positional arguments                        | 參考連結                                                                                   |
|:--------------------|:-----------------------------------------------------------------------------------------------------------------------|:--------------------------------------------|:-------------------------------------------------------------------------------------------|
| `ms-doc-get-by-id`  | 使用 primary key 取得 document。                                                                                       | $1: index 名稱,<br>$2: document id          | [link](https://docs.meilisearch.com/reference/api/documents.html#get-one-document)         |
| `ms-doc-get-asc`    | 取得批量 documents。<br>Documents 的排序是根據其在 `Meilisearch` 中的 hashed doc id。                                  | $1: index 名稱,<br>$2: offset,<br>$3: limit | [link](https://docs.meilisearch.com/reference/api/documents.html#get-documents)            |
| `ms-doc-index`      | 使用原始資料集建制索引。<br>如果索引中存在相同 primary key 的 documents 則之將被取代。<br>若索引不存在，則會自動建立。 | $1: index 名稱,<br>$2: 原始資料位置         | [link](https://docs.meilisearch.com/reference/api/documents.html#add-or-replace-documents) |
| `ms-doc-delete`     | 刪除特定 index 中所指定的一個 document                                                                                 | $1: index 名稱,<br>$2: doc id               | [link](https://docs.meilisearch.com/reference/api/documents.html#delete-one-document)      |
| `ms-doc-delete-all` | 刪除特定 index 中所有的 documents                                                                                      | $1: index 名稱                              | [link](https://docs.meilisearch.com/reference/api/documents.html#delete-all-documents)     |


### Settings (index 設定)
| functions            | 簡介            | positional arguments                     | 參考連結                                                                         |
|:---------------------|:----------------|:-----------------------------------------|:---------------------------------------------------------------------------------|
| `ms-settings-ls`     | 取得 index 設定 | $1: index 名稱                           | [link](https://docs.meilisearch.com/reference/api/settings.html#get-settings)    |
| `ms-settings-update` | 更新 index 設定 | $1: index 名稱, $2: 更新的 settings 位置 | [link](https://docs.meilisearch.com/reference/api/settings.html#update-settings) |


### Task
| functions           | 簡介                       | positional arguments                                 | 參考連結                                                                   |
|:--------------------|:---------------------------|:-----------------------------------------------------|:---------------------------------------------------------------------------|
| `ms-task-ls`        | 列出所有 tasks。           | $1: limit,<br>$2: 從特定 task id 後開始取 (optional) | [link](https://docs.meilisearch.com/reference/api/tasks.html#get-tasks)    |
| `ms-task-get-by-id` | 使用 task id 取得特定 task | $1: task id                                          | [link](https://docs.meilisearch.com/reference/api/tasks.html#get-one-task) |


## Reference
- [Meilisearch API reference](https://docs.meilisearch.com/reference/api/overview.html)
