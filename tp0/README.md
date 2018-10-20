# Organizacion de computadoras

Para poder hacer uso del Makefile, primero es necesario crear la carpeta `gxemul` en la raiz del repositorio. La misma esta agregada a `.gitignore` ya que ahí estará el emulador y no queremos agregarlo al repositorio (pesa 2 GB aproximadamente).

Una vez creada la carpeta, descomprimimos el gxemul con su imagen ahí dentro.

Para bootear el emulador ejecutamos:

`make gxemul`

Nos pedirá usuario y contraseña:
`user: root`
`password: orga6620`

Configuramos el loopback desde el hostOS, es necesario hacerlo cada vez que reiniciamos nuestra computadora:
`make loopback`

Creamos el túnel desde el guestOS a nuestro hostOS, ejecutamos en la terminal de NetBSD:
`ssh -R 2222:127.0.0.1:22 <USER_NAME_HOST>@172.20.0.1`

Nos pedirá la contraseña de nuestro usuario host. Una vez finalizado esta consola deberá quedar abierta, es nuestra conexión entre host y guest.

Con el comando `make ssh` ejecutado de hostOS creamos consolas remotas de guestOS.

Creamos la carpeta `tp1` en guestOS con el comando `mkdir tp1`. La misma debe ubicarse en `/root/tp1`.

Tenemos los siguientes comandos útiles que podemos ejecutar desde el hostOS:
* `make c2guest`: envía los archivos `*.c` a la carpeta `tp1` de guestOS
* `make h2guest`: envía los archivos `*.h` a la carpeta `tp1` de guestOS
* `make make2guest`: envía el archivo `Makefile` a la carpeta `tp1` de guestOS


Tenemos los siguientes comandos útiles que podemos ejecutar desde el guestOS:
* `make asm`: genera el código assembly del programa.
* `make bin`: compila los archivos y genera un binario `tp`.

