# create .local.vimrc
local_vimrc_create()
{
    if [[ "" == ${1} ]]; then
        echo "usage : local_vimrc_create /path/to/target"
        return
    fi

    echo "Create local vimrc file."
    if [ -d ${1} ]; then
        dirpath=`cd ${1}&&pwd`
        filename=".local.vimrc"
        filepath="${dirpath}/${filename}"

        if [ -f ${filepath} ]; then
            echo "*Error* Already exist file. : ${filepath}"
        else
            echo "\" .local.vimrc">${filepath}
            echo "let \$PROJECT_ROOT=expand(\"${dirpath}\")">>${filepath}
            echo "lcd \$PROJECT_ROOT">>${filepath}

            echo "Done. : ${filepath}"
        fi
    else
        echo "*Error* Not find directory. : ${1}"
    fi
}


