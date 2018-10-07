# Inicializa gxemul

installsvssh:
	sudo apt-get install openssh-server

gxemul:
	sudo ./gxemul/gxemul -e 3max -d gxemul/netbsd-pmax.img

# Este comando hay que ejecutarlo cada
# vez que reiniciamos nuestra computadora
loopback:
	sudo ifconfig lo:0 172.20.0.1

# Inicializa un shell remoto de NetBSD
ssh:
	sudo ssh -p 2222 root@127.0.0.1

# Envia los archivo .c del directorio actual
# a guest en la carpeta /root/tp1
c2guest:
	sudo scp -P2222 -r ./*.c root@127.0.0.1:/root/tp1

all2guest:
	sudo scp -P2222 -r ./*.c ./*.S ./*.h root@127.0.0.1:/root/tp1

# Envia los archivo .h del directorio actual
# a guest en la carpeta /root/tp1	
h2guest:
	sudo scp -P2222 -r ./*.h root@127.0.0.1:/root/tp1

# Envia los archivo Makefile del directorio actual
# a guest en la carpeta /root/tp1	
make2guest:
	sudo scp -P2222 ./Makefile root@127.0.0.1:/root/tp1

# Se ejecuta del lado de guest
# genera el archivo assembly
asm:
	gcc -Wall -O0 -S -mrnames *.c

casm:
	gcc -Wall -g -o tp1 *.c *.S

# Compila y genera un binario
# desde el lado del guest
bin:
	gcc -Wall -o tp1 *.c

cpbin: 
	cp tp1 /usr/bin

.PHONY: gxemul loopback
