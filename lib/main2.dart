import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:portfolio/components/custom_cursor.dart';
import 'package:portfolio/components/marquee_text.dart';
import 'package:portfolio/components/paper_texture.dart';
import 'package:portfolio/components/reveal_on_scroll.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const NeoPortfolioApp());
}

class NeoPortfolioApp extends StatelessWidget {
  const NeoPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charan\'s Portfolio',
      theme: NeoBrutalTheme.light,
      home: const NeoHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NeoBrutalTheme {
  static const Color cream = Color(0xFFF8F3EB);
  static const Color ink = Color(0xFF111111);
  static const Color blue = Color(0xFF2563EB);
  static const Color paleBlue = Color(0xFFDCE9FF);
  static const Color softCream = Color(0xFFFFFBF2);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: const ColorScheme.light(
        surface: cream,
        onSurface: ink,
        primary: blue,
        onPrimary: cream,
        secondary: paleBlue,
        outline: ink,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 82,
          fontWeight: FontWeight.w800,
          height: 0.95,
          color: ink,
        ),
        displayMedium: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 34,
          fontWeight: FontWeight.w800,
          height: 1.05,
          color: ink,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 22,
          fontWeight: FontWeight.w800,
          height: 1.1,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Newsreader',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.45,
          color: ink,
        ),
        labelLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          height: 1,
          color: ink,
        ),
        labelSmall: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
      ),
    );
  }
}

class NeoHomeScreen extends StatefulWidget {
  const NeoHomeScreen({super.key});

  @override
  State<NeoHomeScreen> createState() => _NeoHomeScreenState();
}

class _NeoHomeScreenState extends State<NeoHomeScreen> {
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width < 720 ? 20.0 : width * 0.07;
    final headerHeight = width < 900 ? 150.0 : 104.0;

    return Scaffold(
      body: CustomCursor(
        child: Stack(
          children: [
            PaperTexture(
              opacity: 0.045,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: headerHeight + 40),
                    RevealOnScroll(
                      delay: const Duration(milliseconds: 250),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: _buildHero(context),
                      ),
                    ),
                    SizedBox(height: 110, key: _aboutKey),
                    RevealOnScroll(
                      child: _buildEducationAbout(context, padding),
                    ),
                    SizedBox(height: 110, key: _projectsKey),
                    RevealOnScroll(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: _buildProjects(context),
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(height: 3, child: _NeoRule()),
                    SizedBox(height: 100, key: _skillsKey),
                    const MarqueeText(
                      items: [
                        'Dart',
                        'Flutter',
                        'Riverpod',
                        'Firebase',
                        'Natural Language Processing',
                        'Machine Learning',
                        'Predictive Analytics',
                        'Rest API',
                        'Git',
                      ],
                    ),
                    const SizedBox(height: 46),
                    RevealOnScroll(child: _buildSkillsGrid(context, padding)),
                    const SizedBox(height: 100),
                    SizedBox(height: 3, child: _NeoRule()),
                    const SizedBox(height: 100),
                    RevealOnScroll(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: _buildInterests(context),
                      ),
                    ),
                    SizedBox(height: 120, key: _contactKey),
                    RevealOnScroll(child: _buildDarkCTA(context, padding)),
                    RevealOnScroll(child: _buildBottomFooter(context, padding)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: RevealOnScroll(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: NeoBrutalTheme.cream,
                    border: Border(
                      bottom: BorderSide(color: NeoBrutalTheme.ink, width: 3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: NeoBrutalTheme.ink,
                        offset: Offset(0, 6),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: _buildHeader(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        final nav = Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _NavPressButton(
              label: 'About',
              onTap: () => _scrollToSection(_aboutKey),
            ),
            _NavPressButton(
              label: 'Projects',
              onTap: () => _scrollToSection(_projectsKey),
            ),
            _NavPressButton(
              label: 'Skills',
              onTap: () => _scrollToSection(_skillsKey),
            ),
            _NavPressButton(
              label: 'Contact',
              onTap: () => _scrollToSection(_contactKey),
            ),
          ],
        );

        final resume = _NeoPressable(
          color: NeoBrutalTheme.blue,
          foregroundColor: NeoBrutalTheme.cream,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          onTap: () => _launchURL(
            'https://drive.google.com/file/d/1yFM0M4LABMcwNtgP1iVLLO0CGiymBC7d/view?usp=drive_link',
          ),
          child: Text(
            'RESUME',
            style: theme.textTheme.labelLarge?.copyWith(
              color: NeoBrutalTheme.cream,
            ),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vuppala Charan Satwik',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  resume,
                ],
              ),
              const SizedBox(height: 16),
              nav,
            ],
          );
        }

        return SizedBox(
          width: constraints.maxWidth,
          height: 58,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vuppala Charan Satwik',
                  style: theme.textTheme.displayMedium,
                ),
              ),
              Center(child: nav),
              Align(alignment: Alignment.centerRight, child: resume),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHero(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;
        final titleStyle = theme.textTheme.displayLarge?.copyWith(
          fontSize: compact ? 52 : 82,
        );

        final intro = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FLUTTER\nDEVELOPER & ML\nENTHUSIAST.', style: titleStyle),
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Text(
                'I believe in deep learning through complete execution, not just tutorials or clones.',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        );

        final stats = _NeoSurface(
          color: NeoBrutalTheme.paleBlue,
          padding: const EdgeInsets.all(24),
          child: const Column(
            children: [
              _NeoStat(value: '1', label: 'Shipped App'),
              _NeoStat(value: '3+', label: 'ML Models Built'),
              _NeoStat(value: 'Always', label: 'Learning'),
              _NeoStat(value: '100%', label: 'Self-taught'),
            ],
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [intro, const SizedBox(height: 42), stats],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Transform.translate(
                offset: const Offset(0, 18),
                child: intro,
              ),
            ),
            const SizedBox(width: 64),
            Expanded(flex: 2, child: stats),
          ],
        );
      },
    );
  }

  Widget _buildEducationAbout(BuildContext context, double padding) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: NeoBrutalTheme.softCream,
        border: Border.symmetric(
          horizontal: BorderSide(color: NeoBrutalTheme.ink, width: 3),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 86),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 820;
          final education = _InfoBlock(
            title: 'EDUCATION',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'B.Tech',
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 46),
                ),
                const SizedBox(height: 12),
                Text(
                  'Computer Science & Engineering - Artificial Intelligence \nGPA: 8.9/10',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                _NeoChip(label: '2025', color: NeoBrutalTheme.blue),
              ],
            ),
          );

          final about = _InfoBlock(
            title: 'ABOUT ME',
            child: Text(
              'I come from a Machine Learning background and picked up Flutter because I wanted to build things people could actually touch and use, not just models that output numbers. I am a self-taught Flutter developer who learns by building, breaking, and rebuilding. HabitSpec is where that clicked for me. I am hungry to join a team where I can contribute immediately while growing into a stronger mobile developer.',
              style: theme.textTheme.bodyLarge,
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [education, const SizedBox(height: 24), about],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: education),
              const SizedBox(width: 36),
              Expanded(child: about),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProjects(BuildContext context) {
    final projects = [
      _Project(
        title: 'HabitSpec - Personal Habit Tracker',
        tags: const ['Flutter', 'Firebase', 'Firestore Cloud'],
        problem:
            'Most habit trackers are either too complex, requiring a degree to use, or too simple, offering no actionable insights. I needed something brutally honest and visually stark to force accountability.',
        solution:
            'A hyper-focused mobile application that leverages raw data visualization and severe, high-contrast UI to make habit tracking an unavoidable truth rather than a passive suggestion.',
        learned: const [
          'State management architecture with Provider.',
          'Real-time data persistence and synchronization using Cloud Firestore.',
          'Implementing custom glassmorphism UI and seamless navigation routing.',
        ],
        source: 'https://github.com/CharanSatwik/HabitSpec',
      ),
      _Project(
        title: 'Phishing URL Detection',
        tags: const ['Python', 'Machine Learning', 'Flask', 'HTML/CSS'],
        problem:
            'The digital landscape is plagued by malicious URLs that deceive users. Detecting these in real-time requires a highly accurate model that can analyze lexical patterns and domain signatures instantly.',
        solution:
            'A Gradient Boosting Classifier trained on a massive dataset of 100,000+ URLs from PhishTank. The system achieves a 97.4% detection accuracy by engineering features like domain age and HTTPS usage.',
        learned: const [
          'Engineering URL-based features to reduce false-positive rates.',
          'Deploying ML models as real-time Flask web applications.',
          'Handling large-scale datasets and ensuring model robustness against unseen threats.',
        ],
        source: 'https://github.com/CharanSatwik/Phishing-Website-Detection',
      ),
      _Project(
        title: 'Deepfake Detection',
        tags: const ['Python', 'CNN', 'TensorFlow', 'Streamlit'],
        problem:
            'With the rapid advancement of generative AI, distinguishing authentic media from deepfakes has become a critical challenge for information integrity.',
        solution:
            'A Convolutional Neural Network (CNN) architecture trained on over 20,000 images. It utilizes OpenCV for advanced preprocessing and contrast normalization to achieve 91% accuracy in media authentication.',
        learned: const [
          'Designing and training deep learning models for image classification.',
          'Implementing data augmentation to improve model generalization.',
          'Building user-centric prediction interfaces using Streamlit.',
        ],
        source: 'https://github.com/CharanSatwik/Image-Deepfake-Detection',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Kicker(label: 'PROJECTS I BUILT'),
        const SizedBox(height: 34),
        for (var i = 0; i < projects.length; i++) ...[
          _ProjectCard(
            project: projects[i],
            index: i + 1,
            onSource: () => _launchURL(projects[i].source),
          ),
          if (i != projects.length - 1) const SizedBox(height: 56),
        ],
      ],
    );
  }

  Widget _buildSkillsGrid(BuildContext context, double padding) {
    final comfortable = [
      'Dart & Flutter SDK',
      'Provider / Riverpod',
      'Machine Learning',
      'Git & Basic CI/CD',
      'Firebase (Auth/Firestore)',
    ];
    final learning = [
      'Advanced BLoC Pattern',
      'Method Channels (Native)',
      'Performance Profiling',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 780;
          final left = _SkillPanel(
            title: 'COMFORTABLE WITH',
            items: comfortable,
            completed: true,
          );
          final right = _SkillPanel(
            title: 'CURRENTLY LEARNING',
            items: learning,
            completed: false,
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [left, const SizedBox(height: 28), right],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 34),
              Expanded(child: right),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInterests(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 820;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Kicker(label: 'INTERESTS'),
            const SizedBox(height: 24),
            Text(
              'What I do when I\'m \nnot building.',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 42),
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              const SizedBox(height: 30),
              const ShufflingInterestStack(),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: title),
            const SizedBox(width: 58),
            const Expanded(child: ShufflingInterestStack()),
          ],
        );
      },
    );
  }

  Widget _buildDarkCTA(BuildContext context, double padding) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: NeoBrutalTheme.ink,
        border: Border.symmetric(
          horizontal: BorderSide(color: NeoBrutalTheme.ink, width: 3),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 105, horizontal: padding),
      child: CustomCursorArea(
        expand: false,
        cursorColor: NeoBrutalTheme.cream,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'LOOKING FOR MY FIRST\n',
                    style: TextStyle(color: NeoBrutalTheme.cream),
                  ),
                  const TextSpan(
                    text: 'FLUTTER ',
                    style: TextStyle(color: NeoBrutalTheme.blue),
                  ),
                  const TextSpan(
                    text: 'ROLE.',
                    style: TextStyle(color: NeoBrutalTheme.cream),
                  ),
                ],
              ),
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 70),
            ),
            const SizedBox(height: 54),
            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                _FooterSocialButton(
                  icon: const Icon(
                    Icons.email_outlined,
                    color: NeoBrutalTheme.ink,
                    size: 20,
                  ),
                  label: 'charansatwik76@gmail.com',
                  onTap: () => _launchURL('mailto:charansatwik76@gmail.com'),
                ),
                _FooterSocialButton(
                  icon: SvgPicture.string(
                    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#111111"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>',
                    width: 18,
                    height: 18,
                  ),
                  label: 'LINKEDIN',
                  onTap: () =>
                      _launchURL('https://www.linkedin.com/in/charan684/'),
                ),
                _FooterSocialButton(
                  icon: SvgPicture.string(
                    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#111111"><path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/></svg>',
                    width: 18,
                    height: 18,
                  ),
                  label: 'GITHUB',
                  onTap: () => _launchURL('https://github.com/CharanSatwik'),
                ),
                _FooterSocialButton(
                  icon: const Icon(
                    Icons.phone,
                    color: NeoBrutalTheme.ink,
                    size: 20,
                  ),
                  label: '+91 9603925727',
                  onTap: () => _launchURL('tel:+919603925727'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context, double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 42),
      child: Center(
        child: _NeoSurface(
          color: NeoBrutalTheme.softCream,
          shadowOffset: const Offset(4, 4),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Text(
            '(c) 2026 Vuppala Charan Satwik. Built with Flutter & Intent.',
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _NeoPressable extends StatefulWidget {
  const _NeoPressable({
    required this.child,
    required this.onTap,
    this.color = NeoBrutalTheme.cream,
    this.foregroundColor = NeoBrutalTheme.ink,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.shadowOffset = const Offset(6, 6),
    this.shadowColor = NeoBrutalTheme.ink,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final Color foregroundColor;
  final EdgeInsetsGeometry padding;
  final Offset shadowOffset;
  final Color shadowColor;

  @override
  State<_NeoPressable> createState() => _NeoPressableState();
}

class _NeoPressableState extends State<_NeoPressable> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return CustomCursorArea(
      cursorColor: widget.foregroundColor,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _hovered ? 1 : 0),
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              final faceOffset = Offset.lerp(
                Offset.zero,
                widget.shadowOffset,
                value,
              )!;
              final shadowOffset = Offset.lerp(
                widget.shadowOffset,
                Offset.zero,
                value,
              )!;

              return Transform.translate(
                offset: faceOffset,
                child: NeuContainer(
                  offset: shadowOffset,
                  color: widget.color,
                  borderColor: NeoBrutalTheme.ink,
                  borderWidth: 3,
                  shadowColor: widget.shadowColor,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(padding: widget.padding, child: child),
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _NavPressButton extends StatelessWidget {
  const _NavPressButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoPressable(
      onTap: onTap,
      color: NeoBrutalTheme.softCream,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shadowOffset: const Offset(4, 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}

class _NeoSurface extends StatelessWidget {
  const _NeoSurface({
    required this.child,
    this.color = NeoBrutalTheme.cream,
    this.padding = EdgeInsets.zero,
    this.shadowOffset = const Offset(8, 8),
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      offset: shadowOffset,
      color: color,
      borderColor: NeoBrutalTheme.ink,
      borderWidth: 3,
      shadowColor: NeoBrutalTheme.ink,
      borderRadius: BorderRadius.circular(8),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _Kicker extends StatelessWidget {
  const _Kicker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return NeuTextButton(
      enableAnimation: true,
      buttonColor: NeoBrutalTheme.blue,
      borderColor: NeoBrutalTheme.ink,
      shadowColor: NeoBrutalTheme.ink,
      borderWidth: 3,
      borderRadius: BorderRadius.circular(6),
      buttonHeight: 38,
      buttonWidth: label.length > 18 ? 220 : 150,
      offset: const Offset(4, 4),
      onPressed: () {},
      text: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: NeoBrutalTheme.cream,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _NeoRule extends StatelessWidget {
  const _NeoRule();

  @override
  Widget build(BuildContext context) {
    return Container(color: NeoBrutalTheme.ink);
  }
}

class _NeoChip extends StatelessWidget {
  const _NeoChip({required this.label, this.color = NeoBrutalTheme.paleBlue});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textColor = color == NeoBrutalTheme.blue
        ? NeoBrutalTheme.cream
        : NeoBrutalTheme.ink;

    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: NeoBrutalTheme.ink, width: 2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: textColor, fontSize: 12),
      ),
    );
  }
}

class _NeoStat extends StatelessWidget {
  const _NeoStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: NeoBrutalTheme.ink, width: 2)),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: theme.textTheme.displayMedium?.copyWith(
              color: NeoBrutalTheme.blue,
              fontSize: 54,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _NeoSurface(
      color: NeoBrutalTheme.cream,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NeoChip(label: title, color: NeoBrutalTheme.paleBlue),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _Project {
  const _Project({
    required this.title,
    required this.tags,
    required this.problem,
    required this.solution,
    required this.learned,
    required this.source,
  });

  final String title;
  final List<String> tags;
  final String problem;
  final String solution;
  final List<String> learned;
  final String source;
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.index,
    required this.onSource,
  });

  final _Project project;
  final int index;
  final VoidCallback onSource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _NeoSurface(
      color: NeoBrutalTheme.softCream,
      padding: EdgeInsets.zero,
      shadowOffset: Offset(8 + index.toDouble(), 8 + index.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: NeoBrutalTheme.paleBlue,
              border: Border(
                bottom: BorderSide(color: NeoBrutalTheme.ink, width: 3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NeoChip(
                  label: index.toString().padLeft(2, '0'),
                  color: NeoBrutalTheme.blue,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    project.title,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 48,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    for (final tag in project.tags) _NeoChip(label: tag),
                  ],
                ),
                const SizedBox(height: 34),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 780;
                    final left = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProjectTextBlock(
                          title: 'THE PROBLEM',
                          body: project.problem,
                        ),
                        const SizedBox(height: 28),
                        _ProjectTextBlock(
                          title: 'THE SOLUTION',
                          body: project.solution,
                        ),
                      ],
                    );
                    final right = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WHAT I LEARNED',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: NeoBrutalTheme.blue,
                          ),
                        ),
                        const SizedBox(height: 18),
                        for (final item in project.learned)
                          _NeoBullet(text: item),
                        const SizedBox(height: 28),
                        _NeoPressable(
                          onTap: onSource,
                          color: NeoBrutalTheme.blue,
                          foregroundColor: NeoBrutalTheme.cream,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 16,
                          ),
                          child: Text(
                            'VIEW SOURCE',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: NeoBrutalTheme.cream,
                            ),
                          ),
                        ),
                      ],
                    );

                    if (compact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [left, const SizedBox(height: 34), right],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: left),
                        const SizedBox(width: 52),
                        Expanded(child: right),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTextBlock extends StatelessWidget {
  const _ProjectTextBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: NeoBrutalTheme.blue,
          ),
        ),
        const SizedBox(height: 14),
        Text(body, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _NeoBullet extends StatelessWidget {
  const _NeoBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: NeoBrutalTheme.blue,
              border: Border.all(color: NeoBrutalTheme.ink, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _SkillPanel extends StatelessWidget {
  const _SkillPanel({
    required this.title,
    required this.items,
    required this.completed,
  });

  final String title;
  final List<String> items;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _NeoSurface(
      color: completed ? NeoBrutalTheme.paleBlue : NeoBrutalTheme.softCream,
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NeoChip(
            label: title,
            color: completed ? NeoBrutalTheme.blue : NeoBrutalTheme.paleBlue,
          ),
          const SizedBox(height: 22),
          for (final item in items)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: NeoBrutalTheme.ink, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(item, style: theme.textTheme.bodyLarge)),
                  Icon(
                    completed
                        ? Icons.check_circle_outline
                        : Icons.hourglass_empty,
                    color: completed ? NeoBrutalTheme.blue : NeoBrutalTheme.ink,
                    size: 22,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FooterSocialButton extends StatelessWidget {
  const _FooterSocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _NeoPressable(
      onTap: onTap,
      color: NeoBrutalTheme.cream,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shadowOffset: const Offset(5, 5),
      shadowColor: NeoBrutalTheme.blue,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class ShufflingInterestStack extends StatefulWidget {
  const ShufflingInterestStack({super.key});

  @override
  State<ShufflingInterestStack> createState() => _ShufflingInterestStackState();
}

class _ShufflingInterestStackState extends State<ShufflingInterestStack>
    with SingleTickerProviderStateMixin {
  final List<String> _interests = [
    'MOVIES',
    'BADMINTON',
    'ANIME',
    'MUSIC',
    'VIDEO GAMES',
  ];

  late List<int> _shuffledIndices;
  int _pointer = 0;
  bool _isVisible = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _shuffledIndices = List.generate(_interests.length, (i) => i)..shuffle();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuint,
    );

    _startAutoShuffle();
  }

  void _startAutoShuffle() async {
    while (mounted) {
      if (!_isVisible) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted && _isVisible) {
        await _controller.forward();
        if (mounted && _isVisible) {
          setState(() {
            final oldNext =
                _shuffledIndices[(_pointer + 1) % _shuffledIndices.length];
            final oldNextNext =
                _shuffledIndices[(_pointer + 2) % _shuffledIndices.length];

            _pointer = (_pointer + 1) % _shuffledIndices.length;

            if (_pointer == 0) {
              _shuffledIndices.shuffle();
              _shuffledIndices.remove(oldNext);
              _shuffledIndices.insert(0, oldNext);
              _shuffledIndices.remove(oldNextNext);
              _shuffledIndices.insert(1, oldNextNext);
            }
            _controller.value = 0;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('neo_interests_stack_visibility'),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0.1;
        if (visible != _isVisible) {
          setState(() {
            _isVisible = visible;
          });
        }
      },
      child: SizedBox(
        height: 280,
        child: RepaintBoundary(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              final reverseIndex = 2 - index;
              final interestIndex =
                  _shuffledIndices[(_pointer + reverseIndex) %
                      _shuffledIndices.length];
              final interest = _interests[interestIndex];

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  var yOffset = reverseIndex * 14.0;
                  var scale = 1.0 - (reverseIndex * 0.045);
                  var opacity = 1.0 - (reverseIndex * 0.15);
                  var rotation = reverseIndex * -0.025;

                  if (reverseIndex == 0) {
                    yOffset -= _animation.value * 210;
                    opacity *= (1.0 - _animation.value);
                    rotation -= _animation.value * 0.18;
                    scale += _animation.value * 0.08;
                  } else {
                    yOffset -= _animation.value * 14.0;
                    scale += _animation.value * 0.045;
                    opacity += _animation.value * 0.15;
                    rotation += _animation.value * 0.025;
                  }

                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Transform.rotate(
                      angle: rotation,
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity.clamp(0.0, 1.0),
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: _buildInterestCard(context, interest),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestCard(BuildContext context, String label) {
    return CustomCursorArea(
      child: NeuCard(
        cardColor: NeoBrutalTheme.paleBlue,
        cardBorderColor: NeoBrutalTheme.ink,
        shadowColor: NeoBrutalTheme.ink,
        cardBorderWidth: 3,
        offset: const Offset(8, 8),
        borderRadius: BorderRadius.circular(8),
        paddingData: const EdgeInsets.symmetric(vertical: 34, horizontal: 46),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
