
---
---

# Tipos de Conexión en la Jetson Nano

Esta sección describe los diferentes métodos de conexión disponibles en la Jetson Nano, incluyendo USB Device Mode, Wi-Fi y acceso remoto mediante VNC. Cada método permite acceder y controlar el sistema Jetson de forma local o remota, dependiendo de los recursos disponibles.

---
---

## 1. Conexión por USB Device Mode (USB-Dev).

La Jetson Nano permite establecer una conexión directa con un equipo host (Linux, Windows o macOS) mediante un único cable USB, sin necesidad de monitor ni periféricos. Esta conexión se realiza a través del **USB Device Mode**, el cual expone dispositivos virtuales para facilitar la comunicación.

### Protocolos soportados

- **Ethernet**: Permite acceso mediante SSH o transferencia de archivos vía SFTP.
- **Serial (UART)**: Proporciona acceso a la consola mediante una terminal.
- **USB Mass Storage**: Expone una unidad de solo lectura con documentación y drivers.

---

### 1.1 Ethernet (SSH sobre USB).

Una vez conectado mediante USB, la Jetson crea una interfaz de red virtual. Es posible acceder por SSH utilizando herramientas como PuTTY o Tera Term:

- **Dirección IP**: `192.168.55.1`
- **Usuario / Contraseña**: Definidos durante la instalación del sistema operativo.

#### Problemas comunes

Cuando se conectan múltiples Jetson Nano a la misma máquina host, todas comparten la misma IP (`192.168.55.1`). Para asignar direcciones únicas, se deben modificar los parámetros en el siguiente archivo:

```bash
sudo nano /opt/nvidia/l4t-usb-device-mode/nv-l4t-usb-device-mode-config.sh
```

Modificar las siguientes variables:

```bash
net_ip
net_mask
net_net
net_dhcp_start
net_dhcp_end
```

---

### 1.2 Consola serial (UART).

La Jetson también expone un puerto serial virtual (CDC ACM):

- En Windows aparece como `COMx`.
- Compatible con PuTTY, Tera Term, Screen, etc.
- No requiere una velocidad de baudios específica (se trata de un puerto emulado).

#### Instalación del driver en Windows

En versiones anteriores a Windows 10 puede ser necesario instalar el driver manualmente:

1. Abrir **Administrador de dispositivos**.
2. Buscar el dispositivo “CDC Serial”.
3. Actualizar el controlador desde la unidad USB que expone la Jetson.

---

### 1.3 Almacenamiento USB.

Al conectarse, la Jetson también expone una unidad de almacenamiento de solo lectura, visible como `E:`, `F:`, etc. Contiene:

- Documentación de Linux for Tegra.
- Drivers y archivos relacionados.

---

### 1.4 Deshabilitar temporalmente el modo USB.

Para detener temporalmente el modo USB:

```bash
sudo service nv-l4t-usb-device-mode stop
```

Para reactivarlo:

```bash
sudo service nv-l4t-usb-device-mode start
```

---

### 1.5 Deshabilitar permanentemente el modo USB.

Para desactivar el servicio de forma permanente:

```bash
sudo systemctl disable nv-l4t-usb-device-mode.service
sudo service nv-l4t-usb-device-mode stop
```

Y para reactivarlo en el futuro:

```bash
sudo systemctl enable /opt/nvidia/l4t-usb-device-mode/nv-l4t-usb-device-mode.service
sudo service nv-l4t-usb-device-mode start
```

---
---

## 2. Conexión por Wi-Fi en Jetson Nano.

La Jetson Nano puede conectarse a redes Wi-Fi utilizando herramientas de línea de comandos o la interfaz gráfica (en caso de tener un monitor conectado por HDMI).

> Todos los comandos deben ejecutarse directamente en la Jetson Nano.

---

### 2.1 Verificar e instalar Network Manager.

Antes de conectarse, es importante asegurarse de que **Network Manager** esté instalado y activo:

```bash
sudo apt update
sudo apt install network-manager
sudo service NetworkManager start
```

---

### 2.2 Conexión por línea de comandos.

Para conectarse a una red Wi-Fi específica:

```bash
sudo nmcli device wifi connect 'SSID' password 'PASSWORD'
```

- `'SSID'`: Nombre de la red.
- `'PASSWORD'`: Contraseña de la red.

La conexión se recordará para futuras sesiones.

Para listar redes disponibles:

```bash
nmcli device wifi list
```

---

### 2.3 Conexión mediante interfaz gráfica (HDMI).

Cuando se utiliza un monitor:

1. Hacer clic en el ícono de red (parte superior derecha del escritorio).
2. Seleccionar la red deseada.
3. Ingresar la contraseña y conectar.


---

### Consideraciones importantes

- El adaptador Wi-Fi debe estar correctamente conectado (USB o M.2).
- Para verificar el estado de los dispositivos de red:

```bash
nmcli device
```

Si el adaptador no aparece, puede ser necesario instalar el driver correspondiente.

---
---

## 3. Acceso remoto con VNC (interfaz gráfica).

El servidor VNC permite acceder remotamente a la interfaz gráfica de la Jetson Nano mediante red, sin necesidad de monitor o periféricos físicos.

> Todos los comandos deben ejecutarse directamente en la Jetson Nano.

---

### 3.1 Instalación del servidor VNC.

Verificar que el servidor VNC (`vino`) esté instalado:

```bash
sudo apt update
sudo apt install vino
```

---

### 3.2 Configuración del servidor VNC.

1. Habilitar el inicio automático del servidor VNC:

    ```bash
    mkdir -p ~/.config/autostart
    cp /usr/share/applications/vino-server.desktop ~/.config/autostart
    ```

2. Configurar el servidor:

    ```bash
    gsettings set org.gnome.Vino prompt-enabled false
    gsettings set org.gnome.Vino require-encryption false
    gsettings set org.gnome.Vino authentication-methods "['vnc']"
    ```

3. Establecer la contraseña (reemplazar `'thepassword'`):

    ```bash
    gsettings set org.gnome.Vino vnc-password $(echo -n 'thepassword' | base64)
    ```

    **Importante:** Esta contraseña será requerida para acceder al servidor VNC.

4. Reiniciar para aplicar los cambios:

    ```bash
    sudo reboot
    ```


> El servidor VNC estará disponible únicamente después de iniciar sesión localmente. Para habilitarlo automáticamente, se recomienda activar el inicio de sesión automático en la configuración del sistema.

---

### 3.3 Conexión al servidor VNC.

1. Obtener la IP de la Jetson con:

    ```bash
    ifconfig
    ```

    Identificar la dirección correspondiente a:

    - `eth0`: Ethernet
    - `wlan0`: Wi-Fi
    - `l4tbr0`: USB Device Mode

2. En el cliente VNC (Remmina, RealVNC, etc.), conectarse a:

    ```
    IP_DE_LA_JETSON:5900
    ```

    Ejemplo: `192.168.55.1:5900`

3. Al usar clientes como `xrdp`, seleccionar:

    - Tipo de sesión: `vnc-any`
    - Dirección IP: `IP_DE_LA_JETSON`
    - Puerto: `5900`
    - Contraseña: la configurada anteriormente

---

### 3.4 Establecer resolución del escritorio sin monitor.

En ausencia de un monitor, el sistema usa una resolución por defecto de `640x480`. Para cambiarla:

```bash
sudo nano /etc/X11/xorg.conf
```

Agregar o editar la siguiente sección:

```conf
Section "Screen"
    Identifier    "Default Screen"
    Monitor       "Configured Monitor"
    Device        "Tegra0"
    SubSection "Display"
        Depth    24
        Virtual 1280 720  # Cambiar según la resolución deseada
    EndSubSection
EndSection
```

Resoluciones recomendadas: `1920x1080`, `1024x768`, `1280x720`, etc.

---
---
