import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../commands/command_registry.dart';
import '../../commands/builtin_commands.dart';
import 'fastfetch_widget.dart';
import 'terminal_controller.dart';
import 'terminal_widget.dart';
import '../portfolio/portfolio_section.dart';
import '../portfolio/skill_card.dart';
import '../portfolio/project_card.dart';
import '../portfolio/contact_card.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage>
    with TickerProviderStateMixin {
  late final CommandRegistry _registry;
  late final TerminalController _controller;
  final bool _fastfetchDone = false;

  late final ScrollController _scrollController;
  double _currentScale = 1.0;
  Timer? _scalePillTimer;
  bool _showScalePill = false;

  late final AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _registry = _buildRegistry();
    _controller = TerminalController(registry: _registry);

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  CommandRegistry _buildRegistry() {
    final reg = CommandRegistry();
    reg.register('ls', LsCommand());
    reg.register('cat', CatCommand());
    reg.register('open', OpenCommand());
    reg.register('pwd', PwdCommand());
    reg.register('whoami', WhoamiCommand());
    reg.register('echo', EchoCommand());
    reg.register('clear', ClearCommand());
    reg.register('git', GitLogCommand());
    reg.register('vim', VimCommand());
    reg.register('man', ManCommand());
    reg.register('sudo', SudoCommand());
    reg.register('cd', CdCommand());
    reg.register('help', HelpCommand());
    reg.register('fastfetch', FastfetchCommand());
    reg.register('exit', ExitCommand());
    return reg;
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final heroHeight = MediaQuery.of(context).size.height;
    final progress = (offset / (heroHeight * 0.5)).clamp(0.0, 1.0);
    final eased = 1 - pow(1 - progress, 2);
    final newScale = 1.0 - (1.0 - 0.82) * eased;

    if ((newScale - _currentScale).abs() > 0.001) {
      setState(() {
        _currentScale = newScale;
      });
    }

    setState(() {
      _showScalePill = true;
    });

    _scalePillTimer?.cancel();
    _scalePillTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _showScalePill = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_onScroll);
    _scalePillTimer?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TerminalController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: GruvboxColors.bg,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHero(context),
              _buildBounceArrow(),
              _buildScrollCrossover(context),
              _buildAboutSection(context),
              _buildSkillsSection(),
              _buildProjectsSection(),
              _buildContactSection(),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          CustomPaint(
            painter: _DotGridPainter(),
            child: const SizedBox.expand(),
          ),
          Center(
            child: AnimatedScale(
              scale: _currentScale,
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              child: const TerminalWidget(),
            ),
          ),
          if (_showScalePill)
            Positioned(
              top: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showScalePill ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: GruvboxColors.overlay,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: GruvboxColors.surface),
                  ),
                  child: Text(
                    '${_currentScale.toStringAsFixed(2)}x',
                    style: GruvboxText.body(
                      color: GruvboxColors.yellow,
                      size: 10,
                    ),
                  ),
                ),
              ),
            ),
          if (!_fastfetchDone)
            Positioned.fill(
              child: FastfetchWidget(
                controller: _controller,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBounceArrow() {
    return Container(
      color: GruvboxColors.bg,
      padding: const EdgeInsets.only(top: 14),
      child: Center(
        child: AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 9 * _bounceController.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 1.5,
                    color: GruvboxColors.yellow,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 8,
                    height: 1.5,
                    color: GruvboxColors.yellow.withAlpha(89),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScrollCrossover(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = (width * 0.20).clamp(80.0, 160.0);
    final letterSpacing = width * 0.014;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: fontSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: fontSize / 2,
            child: Container(color: GruvboxColors.bg),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: fontSize / 2,
            child: Container(color: GruvboxColors.bgHard),
          ),
          Center(
            child: Text(
              'SCROLL',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: GruvboxColors.overlay,
                letterSpacing: letterSpacing,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return PortfolioSection(
      tag: '01 / ABOUT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aritra Sanyal',
            style: GruvboxText.sectionTitle(context),
          ),
          const SizedBox(height: 4),
          Text(
            'Flutter Developer · E-Cell President · Ships things that work.',
            style: GruvboxText.muted(size: 12),
          ),
          const SizedBox(height: 22),
          const Divider(height: 1, color: GruvboxColors.overlay),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _buildAboutLeft(),
                    const SizedBox(height: 22),
                    _buildAboutRight(),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAboutLeft()),
                  const SizedBox(width: 40),
                  Expanded(child: _buildAboutRight()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBlock('BIO', [
          'Flutter developer building cross-platform apps that actually ship.',
          'Comfortable across the full mobile stack — from signal processing',
          'to animated dashboards to AI-powered ad generators.',
        ]),
        const SizedBox(height: 18),
        _buildInfoBlock('EDUCATION', [
          'B.Tech CSE · UEM Jaipur · CGPA 7.65',
          '2022 – Present',
        ]),
        const SizedBox(height: 18),
        _buildInfoBlock('E-CELL', [
          'President · UEM Jaipur · 2024–25',
          '30-member team · 3 events · 200+ students',
        ]),
      ],
    );
  }

  Widget _buildAboutRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBlock('CONTACT', [
          '+91 7980769212',
          'aritra.sanyal.official@gmail.com',
        ], links: [
          null,
          'mailto:aritra.sanyal.official@gmail.com',
        ]),
        const SizedBox(height: 18),
        _buildInfoBlock('LOCATION', [
          'Jaipur, Rajasthan, India',
        ]),
        const SizedBox(height: 18),
        _buildInfoBlock('WORKSHOP', [
          'Mentor · Flutter Workshop 2024',
          '50–100 beginner · 40 advanced students',
        ]),
      ],
    );
  }

  Widget _buildInfoBlock(String label, List<String> lines,
      {List<String?>? links}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('[ $label ]', style: GruvboxText.infoLabel()),
        const SizedBox(height: 6),
        ...List.generate(lines.length, (i) {
          final isLink = links != null && links[i] != null;
          final url = isLink ? links[i] : null;
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: isLink
                ? InkWell(
                    onTap: () => _launchUrl(url!),
                    child: Text(
                      lines[i],
                      style: GruvboxText.link(size: 12),
                    ),
                  )
                : Text(
                    lines[i],
                    style: label == 'EDUCATION' ||
                            label == 'E-CELL' ||
                            label == 'WORKSHOP'
                        ? (i > 0
                            ? GruvboxText.muted(size: 12)
                            : GruvboxText.infoValue())
                        : GruvboxText.infoValue(),
                  ),
          );
        }),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return PortfolioSection(
      tag: '02 / SKILLS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Stack',
            style: GruvboxText.body(color: GruvboxColors.body, size: 18)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SkillCard(
                  name: 'Flutter', percent: 90, color: GruvboxColors.green),
              SkillCard(name: 'Dart', percent: 90, color: GruvboxColors.green),
              SkillCard(
                  name: 'Firebase', percent: 80, color: GruvboxColors.blue),
              SkillCard(
                  name: 'REST APIs', percent: 80, color: GruvboxColors.blue),
              SkillCard(
                  name: 'Android/iOS', percent: 70, color: GruvboxColors.cyan),
              SkillCard(name: 'Python', percent: 70, color: GruvboxColors.cyan),
              SkillCard(
                  name: 'PyTorch/HF', percent: 60, color: GruvboxColors.yellow),
              SkillCard(
                  name: 'Git/CI·CD', percent: 85, color: GruvboxColors.green),
              SkillCard(
                  name: 'SQLite/Mongo', percent: 65, color: GruvboxColors.cyan),
              SkillCard(
                  name: 'State Mgmt', percent: 80, color: GruvboxColors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    return PortfolioSection(
      tag: '03 / PROJECTS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipped Work',
            style: GruvboxText.body(color: GruvboxColors.body, size: 18)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ProjectCard(
                name: 'Advertisement Generation App',
                date: 'Aug 2024',
                desc:
                    'Flutter + Gemini AI generating personalized ad copy from text prompts. 92% code reuse across Android & iOS, cut dev time by 40%.',
                stack: 'Flutter · Dart · Gemini API · Firebase',
              ),
              ProjectCard(
                name: 'Mesure — Health App',
                date: 'Jan 2025',
                desc:
                    'Camera-based PPG tracking HR & SpO2 in real-time. Animated dashboard, PDF reports, mood logging, medication reminders. 15%+ accuracy improvement.',
                stack: 'Flutter · Dart · Firebase · Signal Processing',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return PortfolioSection(
      tag: '04 / CONTACT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get In Touch',
            style: GruvboxText.body(color: GruvboxColors.body, size: 18)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Open to Flutter roles, freelance, and interesting problems.',
            style: GruvboxText.muted(size: 12),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ContactCard(
                label: 'EMAIL',
                value: 'aritra.sanyal.official@gmail.com',
                url: 'mailto:aritra.sanyal.official@gmail.com',
              ),
              ContactCard(
                label: 'PHONE',
                value: '+91 7980769212',
              ),
              ContactCard(
                label: 'GITHUB',
                value: 'github.com/AritraSanyal',
                url: 'https://github.com/AritraSanyal',
              ),
              ContactCard(
                label: 'LOCATION',
                value: 'Jaipur, Rajasthan, India',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final t = ((width - 320) / (1200 - 320)).clamp(0.0, 1.0);
    final horizontalPad = width < 600 ? 20.0 : t * 40 + 20;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        color: GruvboxColors.bgHard,
        border: Border(
          top: BorderSide(color: GruvboxColors.overlay),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Aritra Sanyal · portfolio.sh',
            style: GruvboxText.footerLeft(),
          ),
          Text(
            '© 2026 · Built with Flutter Web',
            style: GruvboxText.footerRight(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GruvboxColors.overlay
      ..style = PaintingStyle.fill;

    const radius = 1.0;
    const spacing = 22.0;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
