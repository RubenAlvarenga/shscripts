#!/bin/sh
# Hace Backup de producción, poniendo como nombre la fecha del día que se ejecuta y restaura en otro servidor
export DIR=/home/ruben/backup/
export ARCHIVO='kuriju'
export PGPASSWORD="postgres"
export FECHA=`date +%Y%m%d%H%M`
export NAME=${ARCHIVO}${FECHA}.dmp
export IPREMOTO="192.168.0.7"

cd $DIR
> ${NAME}
# chmod 777 ${NAME}
#vacuumdb -U postgres -h ${IPREMOTO} -d kuriju -f -z -v
#date
echo 'Se inicia BACKUP........'
pg_dump -U postgres -h ${IPREMOTO} -F c -b -v -f ${NAME} ${ARCHIVO}
return_code=$?
date
if [ $return_code -ne 0 ]
then
        date
        echo 'Error en el backup. Compruebe: usuario y permisos'
else
		psql -h localhost -U postgres -c "DROP DATABASE ${ARCHIVO};"
		psql -h localhost -U postgres -c "CREATE DATABASE ${ARCHIVO};"

        pg_restore -i -h localhost -p 5432 -U postgres  -d ${ARCHIVO} -v ${NAME}

        echo 'RESTAURACION COMPLETA..... iniciando compresion'

        gzip -f *.dmp
        echo 'Backup realizado correctamente. Archivo' ${DIR}/${NAME}.gz
fi
date
echo ${FECHA}

