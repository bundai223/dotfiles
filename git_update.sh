#! sh
# 自分のリポジトリから更新するスクリプト

DIRNAME=`dirname $0`
PATH_TO_HERE=`readlink -f ${DIRNAME}`

CURREND_DIR=$PWD

echo "**** ${PATH_TO_HERE} ****"
cd ${PATH_TO_HERE}
git pull

cd ${CURREND_DIR}

