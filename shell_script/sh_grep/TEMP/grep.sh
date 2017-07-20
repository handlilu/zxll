#!/bin/bash
#
# �������grep(��®) ʣ���Խ�����
# ---- ����
# 1.������ˡ���ץ����
# 2.�����ǥ��쥯��̾��Ϣ�ͤ��ե�����̾
# 3.����������ɤ�Ϣ�ͤ��ե�����̾
# 4.������̤���Ϥ���ե�����̾
#
# Ex) ./grep.sh -E dir_list.txt keyword_list.txt "grep_result"
#
# �̾︡��������ɽ��ξ�б�
#
# autoer yhasegawa
# since 2016.10.28
#
#

# ���
LIMIT=90     # �ǥ������������͡ʥѡ�����ȡ�
INTERVAL=10s # �����å��ֳ�

#
# �оݤΥץ�������ߤ���
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
# �����Ƥ����ѥ�᡼����̵ͭ���ǧ����
# check_parameter
# @param $1
# @param $2
#
# @return 1 ... error
#
check_parameter() {

    if [ "$1" == "" ]; then
        echo 'ERROR:�����ǥ��쥯�ȥ�̾�Υե�����̾������ޤ���'��>&2
        return 1
    fi

    if [ ! -e "$1" ]; then
        echo 'ERROR:'${1}'�����Ĥ���ޤ���Ǥ���' >&2
        return 1
    exit
        fi

    if [ "$2" == "" ]; then
        echo 'ERROR:����������ɥե�����̾������ޤ���' >&2
        return 1
    fi

    if [ ! -e "$2" ]; then
        echo 'ERROR:'${2}'�����Ĥ���ޤ���Ǥ���' >&2
        return 1
    fi

    return 0
}

#
# �ץ����γ�ǧ�����Ū�˹Ԥ����ǡ����١��������ͤ�Ķ����褦�ʤ齪λ�������
# check_process
# @param $1 ... �ץ���ID
#
#
check_process(){
    # Ĺ���ּ¹Ԥ��Ƥ�����硢grep�Υץ�������
    # Ƚ��ϥǥ���������
    if [ -z $1 ] ; then
        echo 'ERROR:grep�Υץ���ID�����Ĥ���ޤ���Ǥ���' >&2
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
            echo 'ERROR:grep�������������̤�Ķ�����Τ����Ǥ������ޤ���' >&2
            # �᡼������

            exit 1
        fi
        sleep $INTERVAL
    done &
}

# grep�򳫻Ϥ���
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

    # �����оݤ����������ǥ��쥯�ȥ��include
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

    # �����оݤΥե�����̾�ꥹ�Ȥ�include
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

    # ������̤Υե�����̾������
    OUTPUT_FILENAME="${OUTPUT_DIR}/${TARGET_FILENAME}_${DATE}.txt"

    LINE="---------------------------------------------------------------------------------"

    # ������ɤΥ���Ԥ������ơ������ե����������ʤ���
    KEYWORDDATA=`cat ${KEYWORD_LIST_FILE} | sed '/^$/d'`
    sleep 1
    echo -e "${KEYWORDDATA}" > ${KEYWORD_LIST_FILE}
    sleep 1

    # ����ɽ���Ѹ���������ɤ�����
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
        # �ǥ��쥯�ȥ�˥���Ԥ����ä��鼡�Υǥ��쥯�ȥ�򸡺�
        if [ $DIR_PATH == "" ] ; then
            continue
        fi

        echo "target dir .... ${DIR_PATH}"
        echo ""

        # grep���ޥ������
        if [ $OPTION == '-E' ] ; then
            # ����ɽ��
            cmd="find ${DIR_PATH} -type d \\( ${EXCLUDE_LIST} \\) -prune -o -type f \\( ${WHITE_EXT_LIST} \\) -print | sort | xargs grep -InE '${KEY}' >> ${OUTPUT_FILENAME}"
        fi
        if [ $OPTION == '-F'  ] ; then
            # �̾�
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
    echo "���ϡ�${START_DATE}"
    echo "��λ��`date`"
}


#
# ���顼���˶��̤��ƽ��Ϥ�Ԥ�ʸ��
# echo_error
#
# @param nothing
# @return nothing
#
echo_error() {

    echo 'grep.sh�ΰ����ϰʲ��Υѥ�����Ǽ¹ԤǤ��ޤ�' >&2
    echo '---- ���ޥ�ɥꥹ�� ----' >&2
    echo '��������������ˡ(-E, -F) ����ά�ĥǥե���Ȥ�-F' >&2
    echo '��������������ǥ��쥯�ȥ����¸�����ե�����̾' >&2
    echo '�軰������������ɤ���¸�����ե�����̾' >&2
    echo '��Ͱ�����������̽��ϻ��Υե�����̾ ����ά��' >&2
}

#
# main��������
#
#

# ���������å�

# ������2�İʲ��ξ��ϥ��顼
if [ $# -lt 2 ] ; then
    echo 'ERROR:�ѥ�᡼����­��ޤ���' >&2
    echo_error
    exit 1
fi

# �ư�������˹�碌�Ƴ�����Ƥ�
OPTION=''      # ���ץ����̾
DIRLIST=''     # �����ǥ��쥯�ȥ�ե�����̾
KEYWORDLIST='' # ����������ɥե�����̾
RESULTNAME=''  # ��̤���Ϥ���ե�����̾

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

# grep����
grep_start $OPTION $DIRLIST $KEYWORDLIST $RESULTNAME &

# grep�ץ���������å�����HDD������Ķ������ߤ��
check_process $!

exit 0
