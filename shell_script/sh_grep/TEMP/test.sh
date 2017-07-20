#!/sh/bash

HOST=`hostname`
MAIL=`sed 's/<!--SERVER-->/{$hostname}/i' ../conf/diskover.mail`
MAIL_TO='yuuki-hasegawa@tribeat.com'

sh /usr/goonet/goolib/mail/SendMail.sh 'grep.shÄä»ß' 1 "{$MAIL_TO}" "{$MAIL}"
