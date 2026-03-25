
---
---

# Instalación y Configuración en Modo HEADLESS

## 1. Introducción.

Este documento describe los pasos para instalar y configurar un **Jetson Nano Developer Kit** en modo *headless* (sin monitor), basado en la guía oficial de NVIDIA.  
El modo headless permite interactuar con el Jetson Nano desde otro equipo (por consola serial o red), sin necesidad de conectar pantalla, teclado o ratón directamente al dispositivo.

---
---

## 2. Requisitos Previos.

- Jetson Nano Developer Kit (Con acceso a interfe, recomendado usar conexión ethernet o en su defecto modulo wifi)
- Tarjeta microSD (mínimo recomendado: **32 GB UHS‑1**)  
- Fuente de alimentación estable (5 V, 2 A o más)
- Cable micro-USB para conexión serial con la PC  
- Un conector jumper
- PC (Windows, macOS o Linux) con lector de tarjetas SD  
- Terminal serial o aplicación de consola (PuTTY, screen, etc.)

---
---

## 3. Grabado de la Imagen del Sistema en la MicroSD.

Para instalar el sistema operativo Ubuntu 18.04 en el Jetson Nano, es necesario preparar una tarjeta microSD utilizando la imagen oficial [**Jetson Nano Developer Kit SD Card Image**](https://developer.nvidia.com/jetson-nano-sd-card-image). Este proceso se divide en dos etapas: **formatear la tarjeta** y luego **grabar la imagen**.

---

### 3.1 Formateo de la MicroSD.

Previo a la grabación de la imagen, se recomienda formatear la tarjeta microSD utilizando la herramienta oficial proporcionada por la SD Association.

1. Descargar, instalar y abrir [**SD Memory Card Formatter**](https://www.sdcard.org/downloads/formatter/sd-memory-card-formatter-for-windows-download/).

2. Insertar la tarjeta microSD en el equipo y, en el campo **"Select card"**, seleccionar la unidad correspondiente.

3. En la sección **"Formatting options"**, configurar:
   - Format Type: `Quick format`
   - Volume Label: dejar en blanco

4. Hacer clic en **"Format"** y confirmar la advertencia con **"Yes"**.

---

### 3.2 Grabación de la Imagen con Etcher.

Una vez formateada la tarjeta, se procede a grabar la imagen del sistema utilizando la herramienta **Etcher**.

1. Descargar, instalar y ejecutar [**Etcher**](https://etcher.balena.io/).

2. Hacer clic en **"Select image"** y seleccionar el archivo `jetson-nano-jp461-sd-card-image.zip` previamente descargado desde la página oficial de NVIDIA.  
   > No es necesario descomprimir el archivo; Etcher puede trabajar directamente con archivos `.zip`.

3. Insertar la tarjeta microSD en el equipo.  
   > En caso de que Windows muestre un mensaje como “*Windows no puede leer el disco*”, se debe hacer clic en **Cancelar**.

4. Hacer clic en **"Select target"**, elegir la unidad correspondiente a la microSD y, finalmente, hacer clic en **"Flash!"** para iniciar el proceso.

   - La grabación y verificación de la imagen puede tomar entre **5 y 10 minutos**, especialmente si la tarjeta está conectada mediante un puerto USB 3.0.

5. Al finalizar, es posible que Windows muestre un error indicando que no puede leer el disco. Esto es normal, ya que la partición escrita no es compatible con Windows.  
   > En este caso, se debe hacer clic en **Cancelar** y expulsar la tarjeta microSD de forma segura.

---
---

## 4. Configuración Inicial en Modo Headless.

### 4.1 Preparar el hardware.

1. Inserta la microSD en el Jetson Nano.  
2. Coloca el **jumper en J48** si se usará alimentación por conector 5V.  
3. Conecta el **cable micro-USB** entre el Jetson y tu PC (esto activa el modo serial).  
4. Conecta la fuente de alimentación. El Jetson debería encenderse automáticamente.  
5. Espera ~1 minuto para que el sistema arranque.

---

### 4.2 Conexión serial desde la PC.

1. Abre el **Administrador de dispositivos**.  
2. Busca un dispositivo "USB Serial Device (COMx)" bajo "Puertos (COM y LPT)".  
3. Abre **PuTTY** o cualquier terminal serial y configura:
   - Serial line: `COMx`  
   - Baud rate: `115200`  
4. Haz clic en "**Open**" para iniciar la conexión.


---

### 4.3 Primer Arranque y Setup Inicial.

Desde la consola serial:

1. Acepta el contrato de licencia (EULA).  
2. Configura:
   - Idioma  
   - Teclado  
   - Zona horaria  
3. Crea un usuario, contraseña y hostname del equipo.
4. Al finalizar, se accede directamente al sistema con el nuevo usuario.

---
---

## 5. Consejos y Solución de Problemas.

| Problema | Posible causa / solución |
|---------|---------------------------|
| Jetson no arranca | Fuente de alimentación insuficiente. Usa mínimo 5 V, 2 A. |
| No hay salida por serial | Revisa conexión del cable micro-USB y usa el puerto correcto. |
| No aparece puerto COM en Windows | Instala controladores USB o prueba otro cable. |
| No se puede conectar por SSH | Verifica que esté en la misma red y que tenga IP válida. |
| Congelamientos o reinicios aleatorios | Puede ser provocado por alta temperatura, es recomendable que tega su disipador. Usa una fuente de mejor calidad o cambia la SD por una más rápida. |

---
---

## 6. Instalación de Herramientas

Esta sección detalla los pasos necesarios para actualizar el sistema e instalar herramientas esenciales en la Jetson Nano, como `code-oss` (Visual Studio Code), `Python 3.9`, `pip` y el editor de texto `nano`, utilizando exclusivamente la terminal.

---

### 6.1 Actualización del Sistema

Antes de instalar cualquier software, se recomienda actualizar los paquetes existentes en el sistema operativo. Para ello, se debe abrir una terminal y ejecutar:

```bash
sudo apt update
sudo apt upgrade

sudo nvpmodel -m 0
sudo jetson_clocks
```

Una vez finalizado, se puede cerrar la terminal si se desea.

---

### 6.2 Verificación e Instalación de `curl`

`curl` es una herramienta de línea de comandos utilizada para transferir datos desde o hacia un servidor, comúnmente empleada para descargar archivos o realizar solicitudes HTTP.

Para verificar si ya se encuentra instalada:

```bash
curl --version
```

Si el sistema devuelve un error o indica que el comando no existe, se debe proceder a instalarlo:

```bash
sudo apt install curl -y
```

---

### 6.3 Instalación de `Visual Studio Code` 

`code-oss` es la versión de código abierto de Visual Studio Code, útil para editar código fuente de manera eficiente desde un entorno gráfico.

Descarga e instalación (para Ubuntu 18.04):

```bash
wget https://update.code.visualstudio.com/1.85.2/linux-deb-arm64/stable -O /tmp/vscode.deb

sudo dpkg -i /tmp/vscode.deb
```

---

### 6.4 Verificación e Instalación de Python 3.9

Le jetpack de la Jetson Nano trae de forma predeterminada python 3.6.9 y python 2.7.17 y se puede comprobar con:

```bash
python3 --version
python2 --version
```

Antes es recomendable instalar correctamente todas las dependencias necesarias para la instalación de cualquier versión de python, es decir qie solamente se realiza una sola vez.

```bash
sudo apt install -y build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev
```

La versión 3.9, se puede instalar utilizando la pagina ofical de python, la cual ofrece versiones actualizadas de Python no disponibles en los repositorios estándar de Ubuntu.

```bash
wget https://www.python.org/ftp/python/3.9.1/Python-Python-3.9.1.tgz xzf Python-3.9.1.tgz
tar -xzvf Python-3.9.1.tgz
cd Python-3.9.1
./configure --enable-optimizations
make -j$(nproc)
sudo make altinstall
```

Una vez instalada, se puede verificar con:

```bash
python3.9 --version
```

Pagina oficial de python en donde buscar versiones, ademas se recomienda usar archivos tgz para la instalación.

```bash
https://www.python.org/ftp/python/
```

> **Nota:** Esta instalación no reemplaza la versión por defecto del sistema (usualmente Python 3.6 u otra).

---

### 6.5 Instalación de librerias con `pip`

`pip` es el gestor de paquetes oficial de Python, utilizado para instalar bibliotecas y módulos adicionales.

```bash
pip3.9 --version
```

Si se siguio correctamente los pasos para la instalación de las versiones de python, entonces ya tendria `pip`, en ese caso para la descarga de librerias se usa:

```bash
python3.9 -m pip install "nombre_libreria"
```

en donde se reemplaza `nombre_libreria` por el nombre de la libreria que se desea descargar

---

### 6.6 Instalación de `nano` y Configuración de Variables de Entorno para CUDA 10.2

El editor `nano` permite realizar modificaciones rápidas en archivos de configuración directamente desde la terminal.

Para instalarlo:

```bash
sudo apt install nano -y
```

#### Configuración del Entorno CUDA

Para utilizar correctamente CUDA desde la terminal (por ejemplo, al ejecutar `nvcc`), es necesario agregar sus rutas al archivo `.bashrc`.

Primero, se puede buscar la ruta donde está instalado CUDA:

```bash
whereis cuda
```

Una vez identificada la carpeta (`/usr/local/cuda-10.2` por ejemplo), se debe editar el archivo `.bashrc` del usuario actual:

```bash
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

Al final del archivo, se deben agregar las siguientes líneas (modificar la ruta `/usr/local/cuda-10.2` en caso de presentar una diferente):
Para guardar los cambios en `nano`:

```bash
nano ~/.bashrc
```
bajar hasta lo ultimo y se puede comprobar que se agrego.

- Presionar `CTRL + O`, luego `ENTER` para guardar.
- Presionar `CTRL + X` para salir.

> **Nota:** Esta configuración permite ejecutar comandos relacionados con CUDA desde cualquier ubicación en la terminal.

---
---

## 7. Apagar Correctamente la Jetson Nano desde la Terminal

> **IMPORTANTE:**  
> **Nunca se debe apagar la Jetson Nano desconectando el cable de energía directamente.**  
> Esto puede causar **corrupción del sistema operativo** o **pérdida de datos importantes**.

Para realizar un apagado seguro desde la terminal, se debe ejecutar el siguiente comando:

```bash
sudo shutdown now
```

**Esperar siempre** a que todos los LEDs de la Jetson Nano se apaguen por completo antes de desconectar la corriente.

---

**Buenas prácticas**:

- Cerrar todos los programas activos.
- Guardar el trabajo realizado.
- Apagar siempre desde la terminal de forma segura.

> S**Un apagado correcto protege el sistema y extiende su vida útil.**


---
---

## 8. Referencias y Recursos Recomendados.

- [Guía Oficial de NVIDIA para Jetson Nano Started](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit).

- [Guía de Usuario del Kit de Desarrollo Jetson Nano](https://developer.download.nvidia.com/assets/embedded/secure/jetson/Nano/docs/NV_Jetson_Nano_Developer_Kit_User_Guide.pdf?__token__=exp=1759211671~hmac=c8922dd6018eeffafe1a286fc2f277800ecd136aabd1fd09d60af82a9cc907a8&t=eyJscyI6InJlZiIsImxzZCI6IlJFRi1zZWFyY2guYnJhdmUuY29tLyJ9) o se puede ver una copia directamente en el [**repositorio**](../../PDF/NV_Jetson_Nano_Developer_Kit_User_Guide.pdf).

- [Plataforma Oficial de Información de Jetson Nano](https://developer.nvidia.com/embedded-computing).

- [Foro Oficial de Jetson Nano](https://forums.developer.nvidia.com/c/robotics-edge-computing/jetson-embedded-systems/jetson-projects/78).

---
---
