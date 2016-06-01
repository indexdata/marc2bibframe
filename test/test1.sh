#!/bin/sh
if test -n "$1"; then
	ZORBA="$1"
else
	if test -x /opt/idzorba/bin/zorba; then
		ZORBA=/opt/idzorba/bin/zorba
	else
		ZORBA=zorba
	fi
fi
R=1
for i in marc*[0-9].xml; do
	B=`basename $i .xml`
	NEW=${B}.rdf.xml.tmp
	OLD=${B}.rdf.xml
	DIFF=${B}.diff
	LOG=${B}.log
	echo -n "${i}: "
	$ZORBA -i -f -q ../xbin/zorba.xqy \
		-e marcxmluri:="$i" \
		-e baseuri:="http://base/" \
		-e writelog:=true \
		-e logfilename:="$LOG" \
		-e serialization:="rdfxml" >$NEW
	if test -f $OLD; then
		if diff $OLD $NEW >$DIFF; then
			echo "OK"
			rm -f $DIFF
			rm -f $NEW
		else
			echo "FAIL. See $DIFF"
			R=1
		fi
	else
		echo "FIRST"
		mv $NEW $OLD
		R=1
	fi
done
exit $R

