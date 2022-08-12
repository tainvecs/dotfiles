# if MS_HOST not set, use localhost
[[ -z ${MS_HOST+x} ]] && export MS_HOST="localhost:7700"


# $1: delimiter
# https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash
function join_by { local IFS="$1"; shift; echo "$*"; }


# $1: offset, $2: limit
# https://docs.meilisearch.com/reference/api/indexes.html#list-all-indexes
function ms-index-ls(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'List all indexes.'
        echo '$1: offset, $2: limit'
        return 0
    fi

    # append args
    args_list=()
    if [[ $1 != "" ]]; then
        args_list+="offset=$1"
    fi
    if [[ $2 != "" ]]; then
        args_list+="limit=$2"
    fi

    # join args list into str
    args_str=$(join_by "&" "${args_list[@]}")

    # run curl
    curl -XGET "$MS_HOST/indexes?$args_str"
}

# $1: index name, $2: primary key name
# https://docs.meilisearch.com/reference/api/indexes.html#create-an-index
function ms-index-create(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Create an index.'
        echo '$1: index name, $2: primary key name'
        return 0
    fi

    curl -XPOST "$MS_HOST/indexes" \
         -H 'Content-Type: application/json' \
         --data-binary '{
             "uid": "'$1'",
             "primaryKey": "'$2'"
         }'
}

# $1: index name
# https://docs.meilisearch.com/reference/api/indexes.html#delete-an-index
function ms-index-delete(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Delete an index.'
        echo '$1: index name'
        return 0
    fi

    curl -XDELETE "$MS_HOST/indexes/$1"
}

# $1: index name, $2: doc id
# https://docs.meilisearch.com/reference/api/documents.html#get-one-document
function ms-doc-get-by-id(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Get one document using its unique id.'
        echo '$1: index name, $2: doc id'
        return 0
    fi

    curl -XGET "$MS_HOST/indexes/$1/documents/$2"
}

# $1: index name, $2: offset, $3: limit
# https://docs.meilisearch.com/reference/api/documents.html#get-documents
function ms-doc-get-asc(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Get documents by batch.'
        echo 'Documents are ordered by Meilisearch depending on the hash of their id.'
        echo '$1: index name, $2: offset, $3: limit'
        return 0
    fi

    # append args
    args_list=()
    if [[ $2 != "" ]]; then
        args_list+="offset=$2"
    fi
    if [[ $3 != "" ]]; then
        args_list+="limit=$3"
    fi

    # join args list into str
    args_str=$(join_by "&" "${args_list[@]}")

    # run curl
    curl -XGET "$MS_HOST/indexes/$1/documents?$args_str"
}


# $1: index name, $2: path to data
# https://docs.meilisearch.com/reference/api/documents.html#add-or-replace-documents
function ms-doc-index(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Add a list of documents or replace them if they already exist.'
        echo 'If the provided index does not exist, it will be created.'
        echo '$1: index name, $2: path to data'
        return 0
    fi

    curl -XPOST "$MS_HOST/indexes/$1/documents" \
         -H 'Content-Type: application/json' \
         -d"@"$2
}

# $1: index name, $2: doc id
# https://docs.meilisearch.com/reference/api/documents.html#delete-one-document
function ms-doc-delete(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Delete one document based on its unique id.'
        echo '$1: index name, $2: doc id'
        return 0
    fi

    curl -XDELETE "$MS_HOST/indexes/$1/documents/$2"
}

# $1: index name
# https://docs.meilisearch.com/reference/api/documents.html#delete-all-documents
function ms-doc-delete-all(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Delete all documents in the specified index.'
        echo '$1: index name'
        return 0
    fi

    curl -XDELETE "$MS_HOST/indexes/$1/documents"
}

# $1: limit, $2: task id of the first task returned
# https://docs.meilisearch.com/reference/api/tasks.html#get-tasks
function ms-task-ls(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'List all tasks globally, regardless of index. '
        echo '$1: limit, $2: task id of the first task returned'
        return 0
    fi

    # append args
    args_list=()
    if [[ $1 != "" ]]; then
        args_list+="limit=$1"
    fi
    if [[ $2 != "" ]]; then
        args_list+="from=$2"
    fi

    # join args list into str
    args_str=$(join_by "&" "${args_list[@]}")

    # run curl
    curl -XGET "$MS_HOST/tasks?$args_str"
}

# $1: task id
# https://docs.meilisearch.com/reference/api/tasks.html#get-one-task
function ms-task-get-by-id(){

    if [[ $1 == '-h' || $1 == '--help' ]]; then
        echo 'Get a single task.'
        echo '$1: task id'
        return 0
    fi

    curl -XGET "$MS_HOST/tasks/$1"
}
