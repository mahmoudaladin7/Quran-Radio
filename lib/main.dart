import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome

// Data Model for Radio Channels
class RadioChannel {
  final String name;
  final String country;
  final String url;
  final String frequency;

  const RadioChannel({
    required this.name,
    required this.country,
    required this.url,
    required this.frequency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RadioChannel &&
              runtimeType == other.runtimeType &&
              url == other.url;

  @override
  int get hashCode => url.hashCode;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure portrait mode for a consistent experience, especially for radio apps.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Radio',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 35,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      // Directly show SplashScreen as the initial screen
      home: const SplashScreen(),
    );
  }
}

// --- NEW WIDGET: SplashScreen ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation and navigate after it completes
    _controller.repeat(reverse: true); // Loop the animation

    // Add a listener to navigate after a set duration (e.g., 3 seconds total display)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'اذاعة القرآن الكريم'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Match your app's dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ethereal Glow Effect
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.5 * _animation.value),
                        blurRadius: 50 * _animation.value,
                        spreadRadius: 10 * _animation.value,
                      ),
                    ],
                  ),
                  // Optional: Add a subtle icon in the center of the glow
                  child: Center(
                    child: Icon(
                      Icons.radio, // Or a more spiritual icon like Icons.mosque
                      size: 80,
                      color: Colors.white.withOpacity(0.8 * _animation.value),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Loading Text
            FadeTransition(
              opacity: _animation,
              child: Text(
                'استمع إلى نور القرآن', // "Listen to the light of the Quran"
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _animation,
              child: Text(
                'جاري التحميل...', // "Loading..."
                style: TextStyle(
                  color: Colors.orangeAccent.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50), // Spacing for progress indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent.withOpacity(0.7)),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

// (Rest of your existing code for MyHomePage, RadioChannel, FrequencyDisplay, GradientPlayPauseButton)

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = true;
  bool _isPlaying = false;

  final List<RadioChannel> _channels = [
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇪🇬 مصر',
      url: 'http://live.mp3quran.net:9994/;stream.mp3',
      frequency: '98.2 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇸🇦 السعودية',
      url: 'http://live.mp3quran.net:9956/;stream.mp3',
      frequency: '91.9 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇸🇩 السودان',
      url: 'http://live.mp3quran.net:9960/;stream.mp3',
      frequency: '99 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇶🇦 قطر',
      url: 'https://live.kwikmotion.com/qmcquranradio2live/quranradio2/chunks.m3u8',
      frequency: '106 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇮🇶 العراق',
      url: 'http://live.mp3quran.net:9964/;stream.mp3',
      frequency: '93.7 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇦🇪 الإمارات',
      url: 'http://live.mp3quran.net:9980/;stream.mp3',
      frequency: '95.0 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇮🇷 إيران',
      url: 'http://live.mp3quran.net:9902/;stream.mp3',
      frequency: '92.5 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇵🇸 فلسطين',
      url: 'http://quran-radio.org:8080/;stream.mp3',
      frequency: '96.9 FM',
    ),
    const RadioChannel(
      name: 'بث مباشر',
      country: '🇸🇾 سوريا',
      url: 'http://live.mp3quran.net:9996/;stream.mp3',
      frequency: '97.1 FM',
    ),
  ];


  late RadioChannel _selectedChannel;

  @override
  void initState() {
    super.initState();
    _selectedChannel = _channels.first;
    _setupPlayerListeners();
    _loadChannel(autoplay: false);
  }

  void _setupPlayerListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isLoading = state.processingState == ProcessingState.loading ||
              state.processingState == ProcessingState.buffering;
        });
      }
    });

    _audioPlayer.playingStream.listen((isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  Future<void> _loadChannel({bool autoplay = true}) async {
    try {
      await _audioPlayer.setUrl(_selectedChannel.url);
      if (autoplay) {
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error loading audio source: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تشغيل القناة: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _changeChannel(RadioChannel? newChannel) async {
    if (newChannel == null || newChannel == _selectedChannel) return;

    await _audioPlayer.stop();

    setState(() {
      _selectedChannel = newChannel;
    });

    await _loadChannel();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.play();
      } catch (e) {
        print('Error playing audio: $e');
        await _loadChannel();
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FrequencyDisplay(channel: _selectedChannel),
              const SizedBox(height: 30),
              _buildCountrySelector(),
              const SizedBox(height: 30),
              GradientPlayPauseButton(
                isPlaying: _isPlaying,
                isLoading: _isLoading,
                onPressed: _togglePlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _showCustomPopupMenu(details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  _selectedChannel.country,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Icon(Icons.language_outlined, color: Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  void _showCustomPopupMenu(Offset position) async {
    final selected = await showMenu<RadioChannel>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // 🎯 Rounded corners here
      ),
      items: _channels.map((channel) {
        return PopupMenuItem<RadioChannel>(
          value: channel,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  channel.country,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      _changeChannel(selected);
    }
  }



}

class FrequencyDisplay extends StatelessWidget {
  final RadioChannel channel;

  const FrequencyDisplay({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    // Extract only the country name without flag
    final countryWithoutFlag = channel.country.replaceAll(RegExp(r'^[^\w\s]*'), '').trim();

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 350,
          height: 350,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange,
                Colors.orangeAccent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[900],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  channel.frequency,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$countryWithoutFlag - ${channel.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class GradientPlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPressed;

  const GradientPlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange,
            Colors.orangeAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          size: 45,
          color: Colors.white,
        ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}