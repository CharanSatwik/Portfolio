import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/components/editorial_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:portfolio/components/hand_drawn_underline.dart';
import 'package:portfolio/components/marquee_text.dart';
import 'package:portfolio/components/paper_texture.dart';
import 'package:portfolio/components/stat_item.dart';
import 'package:portfolio/components/custom_cursor.dart';
import 'package:portfolio/theme.dart';
import 'package:portfolio/components/loading_screen.dart';
import 'package:portfolio/components/reveal_on_scroll.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charan\'s Portfolio',
      theme: EditorialTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  bool _isLoading = false;

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      alignment: 0.0, // Scroll exactly to the anchor spacer
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.08;

    return Scaffold(
      body: CustomCursor(
        child: Stack(
          children: [
            // MAIN CONTENT
            PaperTexture(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Spacer so content isn't hidden behind the fixed header
                    const SizedBox(height: 100),

                    // HERO SECTION
                    RevealOnScroll(
                      delay: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: padding,
                          vertical: 60,
                        ),
                        child: _buildHero(context),
                      ),
                    ),

                    // MARQUEE
                    SizedBox(height: 120, key: _aboutKey),

                    // EDUCATION & ABOUT
                    RevealOnScroll(
                      child: Container(
                        child: _buildEducationAbout(context, padding),
                      ),
                    ),

                    SizedBox(height: 120, key: _projectsKey),

                    // PROJECTS SECTION
                    RevealOnScroll(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Container(child: _buildProjects(context)),
                      ),
                    ),

                    const SizedBox(height: 80),
                    const Divider(height: 1, thickness: 0.5),
                    SizedBox(height: 120, key: _skillsKey),

                    // SKILLS SECTION (COMBINED)
                    Column(
                      children: [
                        const MarqueeText(
                          items: [
                            'Dart',
                            'Flutter',
                            'Riverpod',
                            'Firebase',
                            'Machine Learning',
                            'Predictive Analytics',
                            'Rest API',
                            'Git',
                          ],
                        ),
                        const SizedBox(height: 40),
                        RevealOnScroll(
                          child: _buildSkillsGrid(context, padding),
                        ),
                      ],
                    ),

                    const SizedBox(height: 120),

                    // INTERESTS
                    RevealOnScroll(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: _buildInterests(context),
                      ),
                    ),

                    SizedBox(height: 120, key: _contactKey),

                    // DARK CTA FOOTER
                    RevealOnScroll(
                      child: Container(child: _buildDarkCTA(context, padding)),
                    ),

                    // BOTTOM FOOTER
                    RevealOnScroll(child: _buildBottomFooter(context, padding)),
                  ],
                ),
              ),
            ),

            // FIXED HEADER — stays on top while scrolling
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: RevealOnScroll(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Vuppala Charan Satwik.',
            style: theme.textTheme.displayMedium,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 45),
            _NavLink(label: 'About', onTap: () => _scrollToSection(_aboutKey)),
            const SizedBox(width: 24),
            _NavLink(
              label: 'Projects',
              onTap: () => _scrollToSection(_projectsKey),
            ),
            const SizedBox(width: 24),
            _NavLink(
              label: 'Skills',
              onTap: () => _scrollToSection(_skillsKey),
            ),
            const SizedBox(width: 24),
            _NavLink(
              label: 'Contact',
              onTap: () => _scrollToSection(_contactKey),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: EditorialButton(
            label: 'Resume',
            borderRadius: 5,
            onPressed: () => _launchURL(
              'https://drive.google.com/file/d/1yFM0M4LABMcwNtgP1iVLLO0CGiymBC7d/view?usp=drive_link',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FLUTTER\nDEVELOPER & ML\nENTHUSIAST.',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 400,
                child: Text(
                  'I believe in deep learning through complete execution, not just tutorials or clones.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 2,
          child: Column(
            children: const [
              StatItem(value: '1', label: 'Shipped App'),
              StatItem(value: '3+', label: 'ML Models Built'),
              StatItem(value: 'Always', label: 'Learning'),
              StatItem(value: '100%', label: 'Self-taught'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjects(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PROJECTS I BUILT.', style: theme.textTheme.labelLarge),
        const SizedBox(height: 40),
        Text(
          'HabitSpec - Personal Habit Tracker',
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 64),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            _buildTag(context, 'Flutter'),
            _buildTag(context, 'Firebase'),
            _buildTag(context, 'Firestore Cloud'),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'THE PROBLEM'),
                  Text(
                    'Most habit trackers are either too complex, requiring a degree to use, or too simple, offering no actionable insights. I needed something brutally honest and visually stark to force accountability.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  _buildSectionLabel(context, 'THE SOLUTION'),
                  Text(
                    'A hyper-focused mobile application that leverages raw data visualization and severe, high-contrast UI to make habit tracking an unavoidable truth rather than a passive suggestion.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'WHAT I LEARNED'),
                  _buildBulletPoint(
                    context,
                    'State management architecture with Provider.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Real-time data persistence and synchronization using Cloud Firestore.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Implementing custom glassmorphism UI and seamless navigation routing.',
                  ),
                  const SizedBox(height: 60),
                  EditorialButton(
                    label: '< VIEW SOURCE',
                    onPressed: () =>
                        _launchURL('https://github.com/CharanSatwik/HabitSpec'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 100),
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 100),

        // Phishing URL Detection
        Text(
          'Phishing URL Detection',
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 64),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            _buildTag(context, 'Python'),
            _buildTag(context, 'Machine Learning'),
            _buildTag(context, 'Flask'),
            _buildTag(context, 'HTML/CSS'),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'THE PROBLEM'),
                  Text(
                    'The digital landscape is plagued by malicious URLs that deceive users. Detecting these in real-time requires a highly accurate model that can analyze lexical patterns and domain signatures instantly.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  _buildSectionLabel(context, 'THE SOLUTION'),
                  Text(
                    'A Gradient Boosting Classifier trained on a massive dataset of 100,000+ URLs from PhishTank. The system achieves a 97.4% detection accuracy by engineering features like domain age and HTTPS usage.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'WHAT I LEARNED'),
                  _buildBulletPoint(
                    context,
                    'Engineering URL-based features to reduce false-positive rates.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Deploying ML models as real-time Flask web applications.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Handling large-scale datasets and ensuring model robustness against unseen threats.',
                  ),
                  const SizedBox(height: 60),
                  EditorialButton(
                    label: '< VIEW SOURCE',
                    onPressed: () => _launchURL(
                      'https://github.com/CharanSatwik/Phishing-Website-Detection',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 100),
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 100),

        // Image Deepfake Detection
        Text(
          'Deepfake Detection',
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 64),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            _buildTag(context, 'Python'),
            _buildTag(context, 'CNN'),
            _buildTag(context, 'TensorFlow'),
            _buildTag(context, 'Streamlit'),
          ],
        ),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'THE PROBLEM'),
                  Text(
                    'With the rapid advancement of generative AI, distinguishing authentic media from deepfakes has become a critical challenge for information integrity.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  _buildSectionLabel(context, 'THE SOLUTION'),
                  Text(
                    'A Convolutional Neural Network (CNN) architecture trained on over 20,000 images. It utilizes OpenCV for advanced preprocessing and contrast normalization to achieve 91% accuracy in media authentication.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(context, 'WHAT I LEARNED'),
                  _buildBulletPoint(
                    context,
                    'Designing and training deep learning models for image classification.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Implementing data augmentation to improve model generalization.',
                  ),
                  _buildBulletPoint(
                    context,
                    'Building user-centric prediction interfaces using Streamlit.',
                  ),
                  const SizedBox(height: 60),
                  EditorialButton(
                    label: '< VIEW SOURCE',
                    onPressed: () => _launchURL(
                      'https://github.com/CharanSatwik/Image-Deepfake-Detection',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(BuildContext context, double padding) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.onSurface, width: 0.5),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMFORTABLE WITH',
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 32),
                    _buildSkillItem(context, 'Dart & Flutter SDK', true),
                    _buildSkillItem(context, 'Provider / Riverpod', true),
                    _buildSkillItem(context, 'Machine Learning', true),
                    _buildSkillItem(context, 'Git & Basic CI/CD', true),
                    _buildSkillItem(context, 'Firebase (Auth/Firestore)', true),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: Center(
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    width: 0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENTLY LEARNING',
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 32),
                    _buildSkillItem(context, 'Advanced BLoC Pattern', false),
                    _buildSkillItem(context, 'Method Channels (Native)', false),
                    _buildSkillItem(context, 'Performance Profiling', false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationAbout(BuildContext context, double padding) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 0.5,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 100),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EDUCATION', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 24),
                  Text(
                    'B.Tech',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    'Computer Science & Engineering - Artificial Intelligence \nGPA: 8.9/10',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '2025',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Container(
              width: 0.5,
              height: double.infinity,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ABOUT ME', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 24),
                  Text(
                    'I come from a Machine Learning background and picked up Flutter because I wanted to build things people could actually touch and use, not just models that output numbers. I am a self-taught Flutter developer who learns by building, breaking, and rebuilding. HabitSpec is where that clicked for me. I am hungry to join a team where I can contribute immediately while growing into a stronger mobile developer.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterests(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INTERESTS', style: theme.textTheme.labelSmall),
              const SizedBox(height: 24),
              Text(
                'What I do when I\'m \nnot building.',
                style: theme.textTheme.displayMedium?.copyWith(fontSize: 40),
              ),
            ],
          ),
        ),
        const SizedBox(width: 85),
        Container(width: 0.5, height: 250, color: theme.colorScheme.onSurface),
        const SizedBox(width: 40),
        const SizedBox(width: 40),
        const Expanded(child: ShufflingInterestStack()),
      ],
    );
  }

  Widget _buildDarkCTA(BuildContext context, double padding) {
    final theme = Theme.of(context);
    return CustomCursorArea(
      expand: false,
      cursorColor: const Color.fromARGB(255, 255, 255, 255),
      child: Container(
        width: double.infinity,
        color: theme.colorScheme.onSurface,
        padding: EdgeInsets.symmetric(vertical: 120, horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'LOOKING FOR MY FIRST\n',
                    style: TextStyle(color: theme.colorScheme.surface),
                  ),
                  TextSpan(
                    text: 'FLUTTER ',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  TextSpan(
                    text: 'ROLE.',
                    style: TextStyle(color: theme.colorScheme.surface),
                  ),
                ],
              ),
              style: theme.textTheme.displayLarge,
            ),
            const SizedBox(height: 60),
            Row(
              children: [
                _FooterSocialItem(
                  icon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: 'charansatwik76@gmail.com',
                  onTap: () => _launchURL('mailto:charansatwik76@gmail.com'),
                ),
                const SizedBox(width: 40),
                _FooterSocialItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SvgPicture.string(
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  label: 'LINKEDIN',
                  onTap: () =>
                      _launchURL('https://www.linkedin.com/in/charan684/'),
                ),
                const SizedBox(width: 40),
                _FooterSocialItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SvgPicture.string(
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white"><path d="M12 0C5.374 0 0 5.373 0 12c0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/></svg>',
                      width: 18,
                      height: 18,
                    ),
                  ),
                  label: 'GITHUB',
                  onTap: () => _launchURL('https://github.com/CharanSatwik'),
                ),
                const SizedBox(width: 40),
                _FooterSocialItem(
                  icon: const Icon(Icons.phone, color: Colors.white, size: 20),
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
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
      child: Center(
        child: Text(
          '© 2026 Vuppala Charan Satwik. Built with Flutter & Intent.',
          style: theme.textTheme.labelSmall,
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, String label, bool completed) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          const Spacer(),
          Icon(
            completed ? Icons.check_circle_outline : Icons.hourglass_empty,
            color: completed
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
            size: 20,
          ),
        ],
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

class _FooterSocialItem extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _FooterSocialItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_FooterSocialItem> createState() => _FooterSocialItemState();
}

class _FooterSocialItemState extends State<_FooterSocialItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return CustomCursorArea(
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 8),
              HandDrawnUnderline(
                animate: _isHovered,
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  widget.label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return CustomCursorArea(
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: HandDrawnUnderline(
            animate: _isHovered,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
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
      // Small delay between checks when not visible to save resources
      if (!_isVisible) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted && _isVisible) {
        await _controller.forward();
        if (mounted && _isVisible) {
          setState(() {
            int oldNext =
                _shuffledIndices[(_pointer + 1) % _shuffledIndices.length];
            int oldNextNext =
                _shuffledIndices[(_pointer + 2) % _shuffledIndices.length];

            _pointer = (_pointer + 1) % _shuffledIndices.length;

            if (_pointer == 0) {
              _shuffledIndices.shuffle();
              _shuffledIndices.remove(oldNext);
              _shuffledIndices.insert(0, oldNext);
              _shuffledIndices.remove(oldNextNext);
              _shuffledIndices.insert(1, oldNextNext);
            }
            _controller.value = 0.0;
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
      key: const Key('interests_stack_visibility'),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0.1;
        if (visible != _isVisible) {
          setState(() {
            _isVisible = visible;
          });
        }
      },
      child: SizedBox(
        height: 250,
        child: RepaintBoundary(
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              // Show 3 cards: current, next, and next-next from shuffled sequence
              final reverseIndex = 2 - index;
              final interestIndex =
                  _shuffledIndices[(_pointer + reverseIndex) %
                      _shuffledIndices.length];
              final interest = _interests[interestIndex];

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double yOffset = reverseIndex * 12.0;
                  double scale = 1.0 - (reverseIndex * 0.05);
                  double opacity = 1.0 - (reverseIndex * 0.2);
                  double rotation = reverseIndex * -0.03;

                  if (reverseIndex == 0) {
                    // Top card animating away
                    yOffset -= _animation.value * 200;
                    opacity *= (1.0 - _animation.value);
                    rotation -= _animation.value * 0.2;
                    scale += _animation.value * 0.1;
                  } else {
                    // Background cards sliding up
                    yOffset -= _animation.value * 12.0;
                    scale += _animation.value * 0.05;
                    opacity += _animation.value * 0.2;
                    rotation += _animation.value * 0.03;
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
    final theme = Theme.of(context);
    return CustomCursorArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
        constraints: const BoxConstraints(minWidth: 320),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 28,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
