import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const AudioApp());
}

class AudioApp extends StatelessWidget {
  const AudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Recorder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RecorderPage(),
    );
  }
}

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;

  String? _audioPath;

  String _message = 'Listo para grabar';

  Future<String> _getAudioPath() async {
    if (kIsWeb) {
      return 'audio_recording.wav';
    }

    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_recording.wav';

    // /data/user/0/com.example.microfono/app_flutter/audio_recording.wav
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();

      if (!hasPermission) {
        setState(() {
          _message = 'Permiso de micrófono rechazado';
        });
        return;
      }

      final path = await _getAudioPath();

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _audioPath = path;
        _message = 'Grabando audio...';
      });
    } catch (error) {
      setState(() {
        _message = 'Error al iniciar la grabación: $error';
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();

      setState(() {
        _isRecording = false;
        _audioPath = path ?? _audioPath;
        _message = 'Grabación finalizada';
      });
    } catch (error) {
      setState(() {
        _message = 'Error al detener la grabación: $error';
      });
    }
  }

  Future<void> _playRecording() async {
    if (_audioPath == null) {
      setState(() {
        _message = 'Primero debes realizar una grabación';
      });
      return;
    }

    try {
      if (kIsWeb) {
        await _player.play(DeviceFileSource(_audioPath!));
      } else {
        final file = File(_audioPath!);

        if (!await file.exists()) {
          setState(() {
            _message = 'No se encontró el archivo de audio';
          });
          return;
        }

        await _player.play(DeviceFileSource(_audioPath!));
      }

      setState(() {
        _isPlaying = true;
        _message = 'Reproduciendo grabación';
      });
    } catch (error) {
      setState(() {
        _message = 'Error al reproducir el audio: $error';
      });
    }
  }

  Future<void> _stopPlaying() async {
    await _player.stop();

    setState(() {
      _isPlaying = false;
      _message = 'Reproducción detenida';
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grabadora de audio')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic, size: 90, color: Colors.blue),
              const SizedBox(height: 20),

              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(
                  _isRecording ? 'Detener grabación' : 'Grabar audio',
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton.icon(
                onPressed: _isPlaying ? _stopPlaying : _playRecording,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? 'Detener audio' : 'Reproducir audio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
