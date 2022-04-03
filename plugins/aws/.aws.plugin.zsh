if type aws >/dev/null; then

    alias aws-account="aws sts get-caller-identity"
    alias aws-status="aws configure list"

fi
