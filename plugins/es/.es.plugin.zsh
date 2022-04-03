if type elasticsearch >/dev/null || [[ -f "/etc/init.d/elasticsearch" ]]; then

    # if ES_HOST not set, use localhost
    [[ -z ${ES_HOST+x} ]] && export ES_HOST="localhost:9200"

    alias es="elasticsearch"

    function es-settings-ls(){
        curl -XGET "$ES_HOST/$1/_settings?pretty"
    }

    function es-settings-update(){
        curl -XPUT "$ES_HOST/$1/_settings/?pretty" \
             -H "Content-Type: application/json" \
             -d "$(jq -r '.settings' $2)"
    }

    function es-mappings-ls(){
        curl -XGET "$ES_HOST/$1/_mappings?pretty"
    }

    function es-mappings-update(){
        curl -XPUT "$ES_HOST/$1/_mappings/?pretty" \
             -H "Content-Type: application/json" \
             -d "$(jq -r '.mappings' $2)"
    }

    function es-index-ls(){
        curl -XPOST "$ES_HOST/_refresh?pretty"
        curl -XGET "$ES_HOST/_cat/indices?v&pretty"
    }

    function es-index-close(){
        curl -XPOST "$ES_HOST/$1/_close?pretty"
    }

    function es-index-open(){
        curl -XPOST "$ES_HOST/$1/_open?pretty"
    }

    function es-index-create(){
        curl -XPUT "$ES_HOST/"$1 \
             -H 'Content-Type: application/json' \
             -d '@'$2
    }

    function es-index-delete(){
        curl -XDELETE "$ES_HOST/$1?pretty"
    }

    function es-aliases-ls(){
        curl -XPOST "$ES_HOST/_refresh?pretty"
        curl -XGET "$ES_HOST/_cat/aliases?v&pretty"
    }

    function es-aliases-add(){
        curl -XPOST "$ES_HOST/_aliases" -H "Content-Type: application/json" -d'
        {
           "actions": [
               { "add": {
                    "index": "'$1'",
                    "alias": "'$2'"
               }}
           ]
        }
        '
    }

    function es-aliases-remove(){
        curl -XPOST "$ES_HOST/_aliases" -H "Content-Type: application/json" -d'
        {
           "actions": [
               { "remove": {
                    "index": "'$1'",
                    "alias": "'$2'"
               }}
           ]
        }
        '
    }

    function es-doc-index(){
        curl -XPUT "$ES_HOST/$1/_doc/$2?pretty" \
             -H "Content-Type: application/json" \
             -d"@"$3
    }

    function es-doc-get-id(){
        curl -XGET "$ES_HOST/$1/_doc/$2?pretty"
    }

    function es-search-all(){
        curl -XGET "$ES_HOST/$1/_search/?pretty" \
             -H "Content-Type: application/json" \
             -d '{"from":0, "size":'$2', "query": {"match_all": {}}}'
    }

    function es-search-recent(){
        curl -XGET "$ES_HOST/$1/_search/?pretty" \
             -H "Content-Type: application/json" \
             -d '{"from":0, "size":'$2',"query": {"match_all": {}},"sort":[{"'$3'":"desc"}]}'
    }

    function es-search-query(){
        curl -XGET "$ES_HOST/$1/_search/?pretty" \
             -H "Content-Type: application/json" \
             -d '{"from":0, "size":'$2', "query": '"$(cat $3)"'}'
    }

    function es-curl-query(){
        curl -XGET "$ES_HOST/$1/_search/?pretty" \
             -H "Content-Type: application/json" \
             -d "$(cat $2)"
    }

fi
