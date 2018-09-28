#!/bin/bash
OLD=
readarray PSWD < /home/deploy/peatio/current/pswd.fil
grep -InHirl $OLD /home/deploy/ --exclude-dir=M --exclude-dir=app --exclude-dir=lib --exclude-dir=log --exclude-dir=public --exclude-dir=binancebot --exclude=changes.sh --exclude=.bash_history --exclude=shadow- > /home/deploy/files.fil
readarray files < /home/deploy/files.fil
for ((filein=0; filein < ${#files[@]}; filein++)); do
        PSWD="${PSWD[filein]%\\n}"
        echo ${files[filein]} "--" ${PSWD[filein]}
        echo "sed -i 's/"$OLD"/"${PSWD[filein]}"/g' ${files[filein]}" >> chpass.sh
done
bash chpass.sh
sudo rm chpass.sh
sed -i "s/$OLD/${PSWD[22]}/g" /etc/shadow
