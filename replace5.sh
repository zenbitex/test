FROM="eur"
TO="aud"
#FILES=$(find | grep 'text.txt\|test.txt')
# FILES=$(text.txt | test.txt)
FILES=$(find /home/deploy/peatio/current | grep '_liability_tabs.html.slim')
echo ""
echo "$FROM => $TO"
echo "-----------------------------------------------"
for SUBJECT_FILE in ${FILES//\\n/ } ; do
    echo "$SUBJECT_FILE"
    vim "$SUBJECT_FILE" -c "%s/$FROM/$TO/gc" -c "wq"
done
echo "-----------------------------------------------"
echo ""
echo "Done!"

