#!/bin/bash
#
# キーワードgrep(高速) 複数行出力用
# ---- 引数
# 1.検索方法オプション
# 2.検索ディレクト名を連ねたファイル名
# 3.検索キーワードを連ねたファイル名
# 4.検索結果を出力するファイル名
#
# Ex) ./grep.sh -E dir_list.txt keyword_list.txt "grep_result"
#
# 通常検索、正規表現両対応
#
# autoer yhasegawa
# since 2016.10.28
#
#

# 定数
LIMIT=90     # ディスク容量閾値（パーセント）
INTERVAL=10s # チェック間隔

#
# 対象のプロセスを停止する
# killtree
#
# @param $1 pid
# @param $1 signal
#
killtree() {
    local _pid=$1
    local _sig=${2:-TERM}
    kill -stop ${_pid}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

#
# 送られてきたパラメータの有無を確認する
# check_parameter
# @param $1
# @param $2
#
# @return 1 ... error
#
check_parameter() {

    if [ "$1" == "" ]; then
        echo 'ERROR:検索ディレクトリ名のファイル名がありません'　>&2
        return 1
    fi

    if [ ! -e "$1" ]; then
        echo 'ERROR:'${1}'が見つかりませんでした' >&2
        return 1
    exit
        fi

    if [ "$2" == "" ]; then
        echo 'ERROR:検索キーワードファイル名がありません' >&2
        return 1
    fi

    if [ ! -e "$2" ]; then
        echo 'ERROR:'${2}'が見つかりませんでした' >&2
        return 1
    fi

    return 0
}

#
# プロセスの確認を定期的に行い、データベースの閾値を超えるようなら終了する処理
# check_process
# @param $1 ... プロセスID
#
#
check_process(){
    # 長時間実行していた場合、grepのプロセスを削除
    # 判定はディスク容量
    if [ -z $1 ] ; then
        echo 'ERROR:grepのプロセスIDが見つかりませんでした' >&2
        return 1
    fi
    pid=$1
    sleep $INTERVAL
    while ps -ef | awk -v pid=$pid 'BEGIN{ err=1 }{ if ($2 == pid) { err=0; exit } }END{ exit err }'
    do
        if df -P ./ | awk -v limit=$LIMIT 'BEGIN{ err=1 }
            { if (NR == 1) next; sub(/%$/, "", $5); if (int($5) > limit) { err=0; exit } }
            END{ exit err }'
        then
            echo $now
            df
            killtree $pid KILL
            echo 'ERROR:grep処理が規定容量を超えたので中断いたしました' >&2
            # メール送信

            exit 1
        fi
        sleep $INTERVAL
    done &
}

# grepを開始する
# grep_start
# @param dirlist_filename
# @param searchwords
# @param result_filename
#
grep_start() {
    OPTION=$1
    DIR_LIST_FILE=$2
    KEYWORD_LIST_FILE=$3

    if [ "$4" == "" ]; then
        TARGET_FILENAME=grep
    else
        TARGET_FILENAME=$4
    fi


    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Environment
    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    DATE=`date '+%Y%m%d_%H%M%S'`
    START_DATE=`date`

    CURRENT_DIR=`dirname $0`
    OUTPUT_DIR="./result"

    # 検索対象から除外するディレクトリをinclude
    EXCLUDE_DIR_LIST_FILE="${CURRENT_DIR}/conf/grep_exclude_dir_list.conf"
    flg=0
    EXCLUDE_LIST=""
    while read EXCLUDE_DIR
    do
        if [ $flg == 1 ]; then
            EXCLUDE_LIST="${EXCLUDE_LIST} -or "
        fi
        EXCLUDE_LIST="${EXCLUDE_LIST}-name \"${EXCLUDE_DIR}\""
        flg=1
    done < ${EXCLUDE_DIR_LIST_FILE}

    # 検索対象のファイル名リストをinclude
    WHITE_EXT_LIST_FILE="${CURRENT_DIR}/conf/grep_white_ext_list.conf"
    flg=0
    WHITE_EXT_LIST=""
    while read WHITE_EXT
    do
        if [ $flg == 1 ]; then
            WHITE_EXT_LIST="${WHITE_EXT_LIST} -or "
        fi
        WHITE_EXT_LIST="${WHITE_EXT_LIST}-name \"*.${WHITE_EXT}\""
        flg=1
    done < ${WHITE_EXT_LIST_FILE}

    if [ ! -e $OUTPUT_DIR ]; then
        mkdir ${OUTPUT_DIR}
    fi

    # 検索結果のファイル名を設定
    OUTPUT_FILENAME="${OUTPUT_DIR}/${TARGET_FILENAME}_${DATE}.txt"

    LINE="---------------------------------------------------------------------------------"

    # 検索ワードのカラ行を削除して、検索ファイルに入れなおす
    KEYWORDDATA=`cat ${KEYWORD_LIST_FILE} | sed '/^$/d'`
    sleep 1
    echo -e "${KEYWORDDATA}" > ${KEYWORD_LIST_FILE}
    sleep 1

    # 正規表現用検索キーワードを生成
    flg=0
    KEY=""
    while read KEYWORD
    do
        if [ $flg == 1 ]; then
            KEY="$KEY|"
        fi
        KEY="$KEY$KEYWORD"
        flg=1
    done < ${KEYWORD_LIST_FILE}

    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Main
    #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    echo $START_DATE
    echo ""

    echo "[Information]" >> $OUTPUT_FILENAME
    echo "***DIR_LIST***" >> $OUTPUT_FILENAME
    eval "cat ${DIR_LIST_FILE} >> ${OUTPUT_FILENAME}"
    echo "***KEYWORD_LIST***" >> $OUTPUT_FILENAME
    eval "cat ${KEYWORD_LIST_FILE} >> ${OUTPUT_FILENAME}"
    echo $LINE >> $OUTPUT_FILENAME

    while read DIR_PATH
    do
        # ディレクトリにカラ行があったら次のディレクトリを検索
        if [ $DIR_PATH == "" ] ; then
            continue
        fi

        echo "target dir .... ${DIR_PATH}"
        echo ""

        # grepコマンド生成
        if [ $OPTION == '-E' ] ; then
            # 正規表現
            cmd="find ${DIR_PATH} -type d \\( ${EXCLUDE_LIST} \\) -prune -o -type f \\( ${WHITE_EXT_LIST} \\) -print | sort | xargs grep -InE '${KEY}' >> ${OUTPUT_FILENAME}"
        fi
        if [ $OPTION == '-F'  ] ; then
            # 通常
            cmd="find ${DIR_PATH} \\( \\( -type d -and \\( ${EXCLUDE_LIST} \\) \\) -and -prune \\) -or \\( -type f -and \\( ${WHITE_EXT_LIST} \\) \\) -and -print | sort | xargs grep -InFf '${KEYWORD_LIST_FILE}' >> ${OUTPUT_FILENAME}"
        fi
        echo $cmd
        eval $cmd
        echo ""
    done < ${DIR_LIST_FILE}

    echo $LINE
    echo ""
    echo $OUTPUT_FILENAME

    echo ""
    echo "開始：${START_DATE}"
    echo "終了：`date`"
}


#
# エラー時に共通して出力を行う文言
# echo_error
#
# @param nothing
# @return nothing
#
echo_error() {

    echo 'grep.shの引数は以下のパターンで実行できます' >&2
    echo '---- コマンドリスト ----' >&2
    echo '第一引数：検索方法(-E, -F) ※省略可デフォルトは-F' >&2
    echo '第二引数：検索ディレクトリを保存したファイル名' >&2
    echo '第三引数：検索ワードを保存したファイル名' >&2
    echo '第四引数：検索結果出力時のファイル名 ※省略可' >&2
}

#
# main処理開始
#
#

# 引数チェック

# 引数が2個以下の場合はエラー
if [ $# -lt 2 ] ; then
    echo 'ERROR:パラメータが足りません' >&2
    echo_error
    exit 1
fi

# 各引数を条件に合わせて割り当てる
OPTION=''      # オプション名
DIRLIST=''     # 検索ディレクトリファイル名
KEYWORDLIST='' # 検索キーワードファイル名
RESULTNAME=''  # 結果を出力するファイル名

if [ $# -eq 4 ] ; then
    OPTION=$1
    DIRLIST=$2
    KEYWORDLIST=$3
    RESULTNAME=$4
fi

if [ $# -eq 3 ] ; then
    if [ $1 == '-E' -o $1 == '-F' ] ; then
        OPTION=$1
        DIRLIST=$2
        KEYWORDLIST=$3
        RESULTNAME=''
    else
        OPTION='-F'
        DIRLIST=$1
        KEYWORDLIST=$2
        RESULTNAME=$3
    fi
fi

if [ $# -eq 2 ] ; then
    OPTION='-F'
    DIRLIST=$1
    KEYWORDLIST=$2
    RESULTNAME=''
fi

check_parameter $DIRLIST $KEYWORDLIST
if [ $?  -gt 0 ] ; then
    echo_error
    exit 1
fi

# grep開始
grep_start $OPTION $DIRLIST $KEYWORDLIST $RESULTNAME &

# grepプロセスをチェックしてHDDの閾値超えたら止める
check_process $!

exit 0
