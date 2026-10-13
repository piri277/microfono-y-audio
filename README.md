# 🎙️ Audio Recorder Flutter

Aplicación móvil desarrollada en **Flutter** que permite **grabar audio utilizando el micrófono del dispositivo** y posteriormente **reproducir la grabación**.

El proyecto implementa el manejo de permisos en **Android, iOS y Web**, incluyendo el caso en el que el usuario **rechaza el acceso al micrófono**.

---

## 👥 Integrantes

| Nombre                        | Rol en el proyecto                             |

| Jaider Enrique Monrroy Diaz   | Explicación del tema, paquetes y documentación |
| Juan Sebastian Tovas Mosquera | Configuración de permisos Android, iOS y Web   |
| David Rojas Morales           | Implementación, pruebas y demostración         |

**Grupo:** grupo 04
**Fecha:** 12 de Octubre de 2026

---

## 📱 Funcionalidades

- Solicitar permiso para acceder al micrófono.
- Iniciar la grabación de audio.
- Detener la grabación.
- Guardar el audio en un archivo.
- Reproducir la grabación realizada.
- Mostrar mensajes según el estado de la aplicación.
- Manejar el permiso de micrófono rechazado.
- Evitar errores cuando no existe permiso o no hay archivo disponible.

---

## 🧰 Paquetes utilizados

| Paquete | Uso |
|---|---|
| [`record`](https://pub.dev/packages/record) | Grabación de audio desde el micrófono |
| [`audioplayers`](https://pub.dev/packages/audioplayers) | Reproducción del archivo de audio |
| [`path_provider`](https://pub.dev/packages/path_provider) | Obtención de la ruta para guardar el audio |

### Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter

  record: ^7.1.1
  audioplayers: ^6.8.1
  path_provider: ^2.1.5
```

---

## ⚙️ Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone [https://github.com/usuario/audio-recorder-flutter.git](https://github.com/usuario/audio-recorder-flutter.git)
cd audio-recorder-flutter
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la aplicación

Para Android:

```bash
flutter run
```

Para Web:

```bash
flutter run -d chrome
```

Para iOS, se requiere una Mac con Xcode:

```bash
flutter run
```

---

## 🔐 Permisos

### Android

El permiso de micrófono se declara en:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

Además, el permiso se solicita durante la ejecución de la aplicación. Si el usuario lo rechaza, la app muestra un mensaje informativo y no inicia la grabación.

### iOS

La configuración se realiza en:

```text
ios/Runner/Info.plist
```

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Esta aplicación necesita el micrófono para grabar audio.</string>
```

iOS utiliza esta descripción para informar al usuario por qué la aplicación requiere acceso al micrófono.

### Web

En Web, el acceso al micrófono se solicita mediante la API del navegador:

```javascript
navigator.mediaDevices.getUserMedia({ audio: true })
```

Requisitos:

- La aplicación debe ejecutarse en **HTTPS**.
- En desarrollo se puede utilizar `localhost`.
- El usuario debe autorizar el acceso desde el navegador.
- El comportamiento puede variar según el navegador utilizado.

---

## 🧠 Explicación técnica

El flujo principal de la aplicación es el siguiente:

```text
Usuario
   ↓
Presiona “Grabar audio”
   ↓
Verificación del permiso
   ↓
Solicitud de acceso al micrófono
   ↓
Grabación con record
   ↓
Archivo de audio guardado
   ↓
Reproducción con audioplayers
```

### Inicialización

```dart
final AudioRecorder _recorder = AudioRecorder();
final AudioPlayer _player = AudioPlayer();
```

- `AudioRecorder` permite controlar la grabación.
- `AudioPlayer` permite reproducir el archivo de audio.

### Verificación del permiso

```dart
final hasPermission = await _recorder.hasPermission();

if (!hasPermission) {
  setState(() {
    _message = 'Permiso de micrófono rechazado';
  });
  return;
}
```

Si el usuario no ha concedido el permiso, la aplicación no intenta grabar y muestra un mensaje claro.

### Inicio de la grabación

```dart
await _recorder.start(
  const RecordConfig(
    encoder: AudioEncoder.wav,
    sampleRate: 44100,
    numChannels: 1,
  ),
  path: path,
);
```

La grabación se configura en formato **WAV**, con una frecuencia de muestreo de **44.100 Hz** y un canal de audio.

### Detención de la grabación

```dart
final path = await _recorder.stop();
```

Al detener la grabación, se obtiene la ruta del archivo generado.

### Reproducción

```dart
await _player.play(
  DeviceFileSource(_audioPath!),
);
```

El paquete `audioplayers` reproduce el archivo guardado previamente.

---

## ⚠️ Manejo de errores

La aplicación contempla los siguientes casos:

| Situación | Respuesta de la aplicación |
|---|---|
| El usuario rechaza el permiso | Muestra un mensaje informativo |
| No hay permiso disponible | No inicia la grabación |
| No existe archivo de audio | Indica que primero debe realizarse una grabación |
| Falla al iniciar la grabación | Muestra un mensaje de error |
| Falla la reproducción | Muestra un mensaje de error |

---

## 🎥 Demostración

En el video se muestra:

1. La solicitud del permiso de micrófono.
2. La aceptación del permiso.
3. La grabación de un audio.
4. La detención de la grabación.
5. La reproducción del archivo.
6. El rechazo del permiso.
7. El mensaje mostrado cuando el micrófono no está disponible.

**Enlace al video:** [Agregar enlace público del video]

**Enlace al repositorio:** [Agregar enlace público del repositorio]

---

## ✅ Buenas prácticas aplicadas

- Solicitar el permiso solo cuando el usuario intenta usar el micrófono.
- Informar al usuario sobre el estado de la aplicación.
- Manejar el rechazo del permiso sin que la app se cierre.
- Liberar recursos al cerrar la aplicación.
- Documentar la configuración de permisos por plataforma.

---

## 🧩 Posibles dificultades

- Diferencias en la solicitud de permisos entre Android, iOS y Web.
- Compatibilidad de formatos de audio según el navegador.
- Necesidad de HTTPS para acceder al micrófono en Web.
- Configuración adicional requerida para ejecutar la aplicación en dispositivos iOS.
- Manejo correcto del permiso rechazado por el usuario.

---

## 📄 Licencia

Este proyecto fue desarrollado con fines académicos.
