# // script de autoria de usuarios BRKA  \\

echo "-------------------------------------------------------------------------#"
echo -e "#\e[1;33m           SCRIPT PARA AUDITORIA DE USUARIOS LINUX                      \e[0m#"
echo -e "#\e[1;36m                                              CRIADO em: 13/03/2021     \e[0m#"
echo -e "#\e[1;36m                                              AUTOR: CARLOS SILVA       \e[0m#"
echo -e "#\e[1;36m                                              github.com/obitog789      \e[0m#"
echo "------------------ ------------------------------------------------------#"
#Variaveis
    QTDUSER=`cut -d':'  -s -f1,1,1 --output-delimiter=':' /etc/passwd   | wc -l `           #QUANTIDADE DE LINHAS NO ARQUIVO PASSWD
    QTDUSERBLOCK=`cat /etc/shadow |grep -i ! | wc -l`                                       #QUANTIDADE DE LINHAS NO SHADOW
    USERBLOCK=`cat /etc/shadow | grep -i ! | cut -d: -f1 `                                  #VERIFICANDO USUARIOS BLOQUEADOS
    USERSUDO=`cat /etc/sudoers | grep -Ev '[:blank]*#|^[:blank]*$' | awk '{print $1,$2}'`   #VERIFICANDO USUARIOS NO ARQUIVO SUDOERS

echo -e "\e[1;32m -----------------=-------PATH DAS EVIDENCIAS--------------------------- \e[0m"
echo -e "\e[1;32m /tmp/auditoria/ \e[0m"

#CRIANDO DIRETORIO /tmp/auditoria"
    mkdir -p  /tmp/auditoria
    cd /tmp/auditoria

#COLETANDO INFORMAÇẼOS DOS ARQUIVOS, PASSWD, GROUPS, SHADOW
    echo -e "\e[1;32m --------------------LENDO O ARQUIVOS PASSWD/SUDOERS/GROUPS/SUDOERS-------------------------- \e[0m"
    echo -e $USER@$HOSTNAME:`pwd`'#' "hostname \n$USER@$HOSTNAME:`pwd`# $HOSTNAME \n$USER@$HOSTNAME:`pwd`# date \n$USER@$HOSTNAME:`pwd`# `date` \n"$USER@$HOSTNAME:`pwd`'#' 'cat /etc/passwd'> /tmp/auditoria/passwd_full.txt &&  cat /etc/passwd >> /tmp/auditoria/passwd_full.txt
    cut -d: -f1 /etc/passwd > /tmp/auditoria/passwd_user.txt
    cut -d: -f6 /etc/passwd > /tmp/auditoria/passwd_home.txt
    cut -d: -f7 /etc/passwd > /tmp/auditoria/passwd_bin.txt
    echo -e "Arquivos `ls -l /tmp/auditoria/` \nos arquivos foram criados com sucesso"

#COLETANDO INFORMAÇẼOS DOS ARQUIVO SUDOERS
    cat /etc/passwd  > /tmp/auditoria/passwd_full.txt 
    cat /etc/sudoers > /tmp/auditoria/sudoers_full.txt
    cat /etc/group   > /tmp/auditoria/groups_full.txt

#SAIDA PARA o usuario" 
echo -e "\e[1;32m-----------------------USUARIOS BLOQUEADOS----------------------------- \e[0m" "\n$USERBLOCK" > /tmp/auditoria/shadow_bloqueados.txt 
    echo "total de $QTDUSERBLOCK usuarios bloqueados " >> /tmp/auditoria/shadow_bloqueados.txt
    cat /tmp/auditoria/shadow_bloqueados.txt

#usuario sudo
echo -e "\e[1;32m----------------------------SUDOERS----------------------------- \e[0m" "\n$USERSUDO""" > /tmp/auditoria/sudoers_users.txt 
    cat /tmp/auditoria/sudoers_users.txt | awk '{print $1}' 
    echo "total `cat /tmp/auditoria/sudoers_users.txt | wc -l` usuarios root" 

echo -e "\e[1;32m--------------------------------------------------------------------------- \e[0m"

#COMPACTANDO
    echo -e "você deseja compactar as evidencias em ZIP? (Digite SIM ou NÃO)"
    read respostartargz 

#RESUMO
#CONCATENANDO TUDO EM 1 RESUVO CSV 
    paste -d "," /tmp/auditoria/passwd_user.txt  /tmp/auditoria/passwd_home.txt /tmp/auditoria/passwd_bin.txt > resumo.csv

if [ "$respostartargz" != "${respostartargz#[YysSsimSimyesYES]}" ] ;then
    echo -e "\e[1;32m                REALIZANDO A COMPACTAÇÃO                  \e[0m"    
    echo "---------------------Compactando tudo---------------------" 
    cd /tmp/auditoria ; zip  $HOSTNAME.evencias-auditoria.zip /tmp/auditoria/*
    echo "Arquivos compactados com sucesso!" 

#ENVIADO PARA UM REPOSITORIO 
echo "deseja enviar para um repositorio?, (Digite SIM ou NÃO)"
read resposta 
if [ "$resposta" != "${resposta#[YysSsimSimyesYES]}" ] ;then
    echo -e "\e[1;36m                ENVIANDO PARA UM REPOSITORIO EXTERNO                  \e[0m#"
    echo "por por favo digite o ip do repositorio :"
    read repositorio
    scp /tmp/auditoria/$HOSTNAME.evencias-auditoria.zip $repositorio@:/tmp/
else
    echo Muito obrigado 
fi

else
    echo "Obrigado, você é rasgado! fera"
fi
