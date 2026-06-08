import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


const kBg = Color(0xFF0A1810);
const kBg2 = Color(0xFF0D1F14);
const kSidebar = Color(0xFF071210);
const kGreen = Color(0xFF2ECC71);
const kGreenDim = Color(0xFF1A7A42);
const kGreenGlow = Color(0x1A2ECC71);
const kGreenGlow2 = Color(0x262ECC71);
const kText = Color(0xFFE8F5E9);
const kTextDim = Color(0xFF7A9E87);
const kCodeText = Color(0xFF2A5A3A);

const kWBg = Color(0xFF050505);
const kNeon = Color(0xFF00FF88);
const kNeonDim = Color(0x1A00FF88);
const kNeonBorder = Color(0x3300FF88);
const kNeonGlow = Color(0x0D00FF88);
const kWText = Color(0xFFF0F0F0);
const kWTextMid = Color(0xFFC8C8C8);
const kWTextMuted = Color(0xFF8A8A8A);
const kWTextFaint = Color(0xFF5E5E5E);
const kGlass = Color(0x08FFFFFF);
const kGlassBrd = Color(0x12FFFFFF);


class Responsive {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    return w >= 600 && w < 1024;
  }
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 1024;

  static double hPad(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < 600) return 20;
    if (w < 1024) return 40;
    return 56;
  }

  static double vPad(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600 ? 32 : 48;

  static double titleSize(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < 600) return 28;
    if (w < 1024) return 36;
    return 46;
  }

  static double heroTitleSize(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < 400) return 28;
    if (w < 600) return 34;
    if (w < 1024) return 44;
    return 52;
  }

  static double sectionTitleSize(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < 600) return 26;
    if (w < 1024) return 32;
    return 38;
  }
}
const _navIcons = [
  Icons.home_outlined,
  Icons.person_outline,
  Icons.miscellaneous_services_outlined,
  Icons.code_outlined,
  Icons.mail_outline,
];
const _navLabels = ['Home', 'About', 'Services', 'Projects', 'Contact'];


class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Muhsina | Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: kBg),
        home: const PortfolioHome(),
      );
}

void main() => runApp(const PortfolioApp());


class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final PageController _pageCtrl = PageController();
  int _activeIdx = 0;
  bool _isScrolling = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int idx) {
    if (_isScrolling) return;
    _isScrolling = true;
    setState(() => _activeIdx = idx);
    _pageCtrl
        .animateToPage(idx,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic)
        .then((_) => _isScrolling = false);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: kBg2,
      // Mobile: bottom nav bar
      bottomNavigationBar: isMobile ? _MobileNavBar(selected: _activeIdx, onTap: _goTo) : null,
      body: Row(children: [
        // Desktop / tablet: sidebar
        if (!isMobile) _Sidebar(selected: _activeIdx, onTap: _goTo),
        Expanded(
          child: PageView(
            controller: _pageCtrl,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) => setState(() => _activeIdx = i),
            children: [
              HeroSection(onHireMeTap: () => _goTo(4)),
              WhoAmISection(onScrollTo: _goTo),
              const ServicesSection(),
              const ProjectsSection(),
              const ContactSection(),
            ],
          ),
        ),
      ]),
    );
  }
}


class _MobileNavBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _MobileNavBar({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: kSidebar,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navIcons.length, (i) {
          final active = selected == i;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? kGreenGlow2 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_navIcons[i], color: active ? kGreen : kTextDim, size: 20),
                  if (active) ...[
                    const SizedBox(height: 2),
                    Text(
                      _navLabels[i],
                      style: const TextStyle(
                          color: kGreen, fontSize: 9, fontFamily: 'monospace'),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}


class _Sidebar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const _Sidebar({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: kSidebar,
      child: Column(children: [
        const SizedBox(height: 24),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              color: kGreen, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: const Text('M.',
              style: TextStyle(
                  color: kBg,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'monospace')),
        ),
        const SizedBox(height: 6),
        const Text('Muhsina\nFlutter Dev',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kTextDim,
                fontSize: 8,
                fontFamily: 'monospace',
                height: 1.4)),
        const SizedBox(height: 20),
        ...List.generate(_navIcons.length, (i) {
          final active = selected == i;
          return Tooltip(
            message: _navLabels[i],
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(vertical: 3),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: active ? kGreenGlow2 : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(children: [
                  if (active)
                    Positioned(
                      left: 0,
                      top: 12,
                      bottom: 12,
                      child: Container(
                        width: 3,
                        decoration: BoxDecoration(
                            color: kGreen,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                  Center(
                      child: Icon(_navIcons[i],
                          color: active ? kGreen : kTextDim, size: 20)),
                ]),
              ),
            ),
          );
        }),
        const Spacer(),
        ...List.generate(
            _navIcons.length,
            (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: selected == i ? 8 : 4,
                  height: selected == i ? 8 : 4,
                  decoration: BoxDecoration(
                    color: selected == i ? kGreen : kGreenDim.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
        const SizedBox(height: 24),
      ]),
    );
  }
}


class HeroSection extends StatefulWidget {
  final VoidCallback onHireMeTap;
  const HeroSection({super.key, required this.onHireMeTap});
  @override
  State<HeroSection> createState() => _HeroState();
}

class _HeroState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.hPad(context);

    return SizedBox(
      height: size.height,
      child: Container(
        color: kBg,
        child: Stack(children: [
        
          if (!isMobile)
            Positioned(
              top: 24,
              left: hPad,
              right: 0,
              child: const Text(
                "return MaterialApp(\n  title: 'Portfolio',\n    home: Scaffold(\n      body: Center(\n        child: Text",
                style: TextStyle(
                    color: kCodeText,
                    fontSize: 13,
                    fontFamily: 'monospace',
                    height: 2.0),
              ),
            ),
          
          if (!isMobile && !isTablet)
            Positioned(
              right: 60,
              top: 0,
              bottom: 0,
              child: Center(
                child: CustomPaint(
                    size: const Size(200, 200), painter: _FlutterPainter()),
              ),
            ),
          
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: Align(
                  alignment: isMobile
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          _buildTag(isMobile),
                          const SizedBox(height: 20),
                          _buildTitle(context, isMobile),
                          const SizedBox(height: 14),
                          _buildSubtitle(isMobile),
                          const SizedBox(height: 36),
                          _buildButtons(isMobile),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          if (!isMobile)
            const Positioned(
              bottom: 32,
              left: 32,
              child: Text("). // center\n). // scaffold\n}",
                  style: TextStyle(
                      color: kCodeText,
                      fontSize: 12,
                      fontFamily: 'monospace',
                      height: 1.8)),
            ),
          
          Positioned(
            bottom: isMobile ? 16 : 32,
            right: isMobile ? 0 : 80,
            left: isMobile ? 0 : null,
            child: Center(child: _ScrollHint()),
          ),
        ]),
      ),
    );
  }

  Widget _buildTag(bool isMobile) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: kGreenGlow2,
          border: Border.all(color: kGreenDim),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: kGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: kGreen.withOpacity(0.6), blurRadius: 6)
                  ])),
          const SizedBox(width: 8),
          const Text('Available for hire',
              style: TextStyle(
                  color: kGreen, fontSize: 12, fontFamily: 'monospace')),
        ]),
      );

  Widget _buildTitle(BuildContext context, bool isMobile) {
    final bigSize = Responsive.heroTitleSize(context);
    final smallerSize = bigSize * 0.96;
    final nameSize = bigSize + 4;

    return Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          RichText(
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              text: TextSpan(
                  style: TextStyle(fontSize: smallerSize),
                  children: const [
                TextSpan(
                    text: "('",
                    style: TextStyle(
                        color: kTextDim, fontWeight: FontWeight.w300)),
                TextSpan(
                    text: "Hi, I am",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)),
              ])),
          const SizedBox(height: 6),
          RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: nameSize, fontWeight: FontWeight.w900),
                  children: const [
                TextSpan(
                    text: "Muhsina",
                    style: TextStyle(
                      color: kGreen,
                      decoration: TextDecoration.underline,
                      decorationColor: kGreenDim,
                      decorationThickness: 2,
                    )),
              ])),
          const SizedBox(height: 6),
          RichText(
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              text: TextSpan(
                  style: TextStyle(fontSize: smallerSize),
                  children: const [
                TextSpan(
                    text: "Flutter Developer",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: kGreen,
                      decorationThickness: 3,
                    )),
                TextSpan(
                    text: "'),",
                    style: TextStyle(
                        color: kTextDim, fontWeight: FontWeight.w300)),
              ])),
        ]);
  }

  Widget _buildSubtitle(bool isMobile) => Text(
        'Building cross-platform mobile experiences\nwith Flutter & Dart',
        textAlign: isMobile ? TextAlign.center : TextAlign.left,
        style: const TextStyle(
            color: kTextDim,
            fontSize: 15,
            height: 1.7,
            fontFamily: 'monospace'),
      );

  Widget _buildButtons(bool isMobile) {
    final buttons = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: kBg,
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 28 : 40, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.bold),
          elevation: 8,
          shadowColor: kGreen.withOpacity(0.4),
        ),
        onPressed: widget.onHireMeTap,
        child: const Text('Hire me'),
      ),
      SizedBox(width: isMobile ? 12 : 16),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: kGreen,
          side: const BorderSide(color: kGreen, width: 1.5),
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle:
              TextStyle(fontSize: isMobile ? 13 : 15, fontWeight: FontWeight.w600),
        ),
        onPressed: _downloadCV,
        icon: const Icon(Icons.download_outlined, size: 18),
        label: const Text('Download CV'),
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [buttons[0], buttons[2]],
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  Future<void> _downloadCV() async {
    const cvUrl = 'https://drive.google.com/your-cv-link-here';
    final uri = Uri.parse(cvUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ScrollHint extends StatefulWidget {
  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _anim,
        child: const Column(mainAxisSize: MainAxisSize.min, children: [
          Text('scroll',
              style: TextStyle(
                  color: kTextDim,
                  fontSize: 10,
                  fontFamily: 'monospace',
                  letterSpacing: 2)),
          SizedBox(height: 4),
          Icon(Icons.keyboard_arrow_down, color: kGreenDim, size: 20),
        ]),
      );
}


class _FlutterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = kGreen.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(
        Path()
          ..moveTo(s.width * .55, s.height * .10)
          ..lineTo(s.width * .10, s.height * .55)
          ..lineTo(s.width * .30, s.height * .55)
          ..lineTo(s.width * .55, s.height * .30)
          ..close(),
        p);
    canvas.drawPath(
        Path()
          ..moveTo(s.width * .55, s.height * .45)
          ..lineTo(s.width * .30, s.height * .70)
          ..lineTo(s.width * .55, s.height * .70)
          ..lineTo(s.width * .75, s.height * .50)
          ..close(),
        p);
    p.color = const Color(0xFF27AE60).withOpacity(0.35);
    canvas.drawPath(
        Path()
          ..moveTo(s.width * .55, s.height * .55)
          ..lineTo(s.width * .30, s.height * .80)
          ..lineTo(s.width * .42, s.height * .92)
          ..lineTo(s.width * .75, s.height * .58)
          ..close(),
        p);
  }

  @override
  bool shouldRepaint(_) => false;
}


class WhoAmISection extends StatefulWidget {
  final ValueChanged<int> onScrollTo;
  const WhoAmISection({super.key, required this.onScrollTo});

  @override
  State<WhoAmISection> createState() => _WhoAmISectionState();
}

class _WhoAmISectionState extends State<WhoAmISection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slideL, _slideR;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slideL = Tween<Offset>(begin: const Offset(-0.10, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slideR = Tween<Offset>(begin: const Offset(0.10, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.hPad(context);

    return SizedBox(
      height: size.height,
      child: Container(
        color: kBg2,
        child: FadeTransition(
          opacity: _fade,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: hPad, vertical: Responsive.vPad(context)),
            child: (isMobile || isTablet)
                ? _buildSingleColumn()
                : _buildTwoColumn(),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoColumn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: SlideTransition(
              position: _slideL,
              child: _WhoLeftColumn(
                isMobile: false,
                onScrollTo: widget.onScrollTo,
              ),
            ),
          ),
          const SizedBox(width: 64),
          Expanded(
            flex: 4,
            child: SlideTransition(
              position: _slideR,
              child: const _WhoRightColumn(),
            ),
          ),
        ],
      );

  Widget _buildSingleColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
            position: _slideL,
            child:
                _WhoLeftColumn(isMobile: true, onScrollTo: widget.onScrollTo),
          ),
          const SizedBox(height: 58),
          SlideTransition(
            position: _slideR,
            child: const _WhoRightColumn(),
          ),
        ],
      );
}

class _WhoLeftColumn extends StatelessWidget {
  final bool isMobile;
  final ValueChanged<int> onScrollTo;
  const _WhoLeftColumn({required this.isMobile, required this.onScrollTo});

  @override
  Widget build(BuildContext context) {
    final titleSize = Responsive.titleSize(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// 01 — ABOUT ME',
          style: TextStyle(
            color: kNeon.withOpacity(0.80),
            fontSize: 11,
            fontFamily: 'monospace',
            letterSpacing: 3.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 40),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              height: 1.12,
              letterSpacing: -0.8,
            ),
            children: [
              const TextSpan(
                  text: 'Driven by ', style: TextStyle(color: kWText)),
              TextSpan(
                text: 'code',
                style: TextStyle(
                  color: kNeon,
                  decoration: TextDecoration.underline,
                  decorationColor: kNeon.withOpacity(0.30),
                  decorationThickness: 1.5,
                ),
              ),
              const TextSpan(text: '\n& ', style: TextStyle(color: kWText)),
              TextSpan(
                text: 'creativity',
                style: TextStyle(
                  color: kNeon,
                  decoration: TextDecoration.underline,
                  decorationColor: kNeon.withOpacity(0.30),
                  decorationThickness: 1.5,
                ),
              ),
              const TextSpan(text: '.', style: TextStyle(color: kWText)),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(width: 36, height: 1, color: kNeon.withOpacity(0.4)),
        const SizedBox(height: 30),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              fontWeight: FontWeight.w300,
              height: 1.85,
              color: kWTextMuted,
            ),
            children: [
              const TextSpan(text: "I'm "),
              const TextSpan(
                text: 'Muhsina C',
                style: TextStyle(color: kWTextMid, fontWeight: FontWeight.w500),
              ),
              const TextSpan(
                text:
                    ', a Flutter Developer Intern passionate about creating modern mobile applications and meaningful digital experiences. My expertise spans ',
              ),
              TextSpan(
                text: 'Flutter, Firebase, REST API Integration',
                style: TextStyle(
                    color: kNeon.withOpacity(0.90),
                    fontWeight: FontWeight.w400),
              ),
              const TextSpan(text: ', and '),
              const TextSpan(
                text: 'State Management',
                style:
                    TextStyle(color: kWTextMid, fontWeight: FontWeight.w400),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'I enjoy transforming ideas into scalable mobile applications with clean architecture, intuitive user experiences, and high-performance functionality. My development journey focuses on building responsive Flutter applications integrated with Firebase services, RESTful APIs, and efficient state management solutions.',
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w300,
            height: 1.90,
            color: kWTextFaint,
          ),
        ),
        const SizedBox(height: 36),
        _WhoCTAButton(onScrollTo: onScrollTo),
      ],
    );
  }
}

class _WhoCTAButton extends StatefulWidget {
  final ValueChanged<int> onScrollTo;
  const _WhoCTAButton({required this.onScrollTo});

  @override
  State<_WhoCTAButton> createState() => _WhoCTAButtonState();
}

class _WhoCTAButtonState extends State<_WhoCTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onScrollTo(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered ? kNeon.withOpacity(0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? kNeon : kNeon.withOpacity(0.45),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                        color: kNeon.withOpacity(0.22),
                        blurRadius: 24,
                        spreadRadius: 1)
                  ]
                : [],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                color: _hovered ? kNeon : kWTextMid,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                letterSpacing: 0.5,
              ),
              child: const Text("Let's Build Something Amazing"),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward,
                color: _hovered ? kNeon : kWTextMuted, size: 16),
          ]),
        ),
      ),
    );
  }
}

class _WhoRightColumn extends StatelessWidget {
  const _WhoRightColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WhoGlassCard(
          badgeText: '2022 – 2025',
          iconData: Icons.school_outlined,
          cardLabel: 'EDUCATION',
          title: 'BA English Graduate',
          body:
              'University of Calicut — analytical thinking, clear communication, and documentation skills that sharpen every line of code.',
        ),
        SizedBox(height: 14),
        _WhoGlassCard(
          badgeText: 'Current',
          isBadgeLive: true,
          iconData: Icons.work_outline,
          cardLabel: 'EXPERIENCE',
          title: 'Flutter Developer Intern',
          body:
              'Root-Sys International — 4-month intensive course followed by a 2-month hands-on internship building production-grade apps.',
        ),
        SizedBox(height: 14),
        _WhoGlassCard(
          iconData: Icons.code_outlined,
          cardLabel: 'EXPERTISE',
          title: 'Core Technical Skills',
          body:
              'Flutter · Dart · Firebase · REST APIs · BLoC · Provider · GetX',
          hasChips: true,
          chips: ['Flutter', 'REST APIs', 'Firebase', 'State Mgmt'],
        ),
        SizedBox(height: 14),
        _WhoGlassCard(
          iconData: Icons.center_focus_strong_outlined,
          cardLabel: 'FOCUS',
          title: 'What I Optimise For',
          body:
              'Clean Code · Responsive UI · Mobile App Development · Performance',
          hasChips: true,
          chips: ['Clean Code', 'Responsive UI', 'Mobile Dev'],
        ),
      ],
    );
  }
}

class _WhoGlassCard extends StatefulWidget {
  final String? badgeText;
  final bool isBadgeLive;
  final IconData iconData;
  final String cardLabel;
  final String title;
  final String body;
  final bool hasChips;
  final List<String> chips;

  const _WhoGlassCard({
    this.badgeText,
    this.isBadgeLive = false,
    required this.iconData,
    required this.cardLabel,
    required this.title,
    required this.body,
    this.hasChips = false,
    this.chips = const [],
  });

  @override
  State<_WhoGlassCard> createState() => _WhoGlassCardState();
}

class _WhoGlassCardState extends State<_WhoGlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFF0A1A10) : kBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? kNeon.withOpacity(0.4) : kGlassBrd,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: kNeon.withOpacity(0.09),
                      blurRadius: 26,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Stack(
          children: [
            if (_hovered)
              Positioned(
                left: -20,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: kNeon,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _hovered ? kNeon.withOpacity(0.18) : kNeonDim,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: kNeonBorder),
                    ),
                    child: Icon(widget.iconData, color: kNeon, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.cardLabel,
                      style: TextStyle(
                        color: kNeon.withOpacity(0.75),
                        fontSize: 10,
                        fontFamily: 'monospace',
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.badgeText != null) ...[
                    const SizedBox(width: 8),
                    _buildBadge(),
                  ],
                ]),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: _hovered ? kWText : const Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.body,
                  style: const TextStyle(
                    color: kWTextFaint,
                    fontSize: 12,
                    height: 1.65,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (widget.hasChips) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.chips.map((c) => _WhoMiniChip(c)).toList(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: widget.isBadgeLive ? kNeonDim : const Color(0x0CFFFFFF),
          border: Border.all(
              color:
                  widget.isBadgeLive ? kNeonBorder : const Color(0x1AFFFFFF)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (widget.isBadgeLive) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: kNeon,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: kNeon.withOpacity(0.60), blurRadius: 4)
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            widget.badgeText!,
            style: TextStyle(
              color: widget.isBadgeLive ? kNeon : const Color(0xFF9A9A9A),
              fontSize: 10,
              fontFamily: 'monospace',
              letterSpacing: 0.4,
            ),
          ),
        ]),
      );
}

class _WhoMiniChip extends StatelessWidget {
  final String label;
  const _WhoMiniChip(this.label);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: kNeonGlow,
          border: Border.all(color: kNeonBorder),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: kNeon,
            fontSize: 10,
            fontFamily: 'monospace',
            letterSpacing: 0.3,
          ),
        ),
      );
}


class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});
  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _services = [
    (
      icon: Icons.phone_android,
      title: 'Flutter App Dev',
      desc:
          'Cross-platform mobile apps for iOS & Android from a single beautiful codebase. Smooth, native-feeling UIs.'
    ),
    (
      icon: Icons.local_fire_department_outlined,
      title: 'Firebase Integration',
      desc:
          'Auth, Firestore, FCM push notifications — robust real-time backends built on Google Firebase.'
    ),
    (
      icon: Icons.api_outlined,
      title: 'REST API Integration',
      desc:
          'Seamless API connections tested in Postman, wired into clean Flutter architecture layers.'
    ),
    (
      icon: Icons.palette_outlined,
      title: 'UI/UX Design',
      desc:
          'Pixel-perfect Material & Cupertino interfaces with smooth micro-animations and responsive layouts.'
    ),
    (
      icon: Icons.manage_accounts_outlined,
      title: 'State Management',
      desc:
          'BLoC, Provider & GetX — scalable, testable state architecture for any app complexity.'
    ),
    (
      icon: Icons.devices_outlined,
      title: 'Responsive Design',
      desc:
          'Layouts that feel native on every screen size, from phone to tablet to web applications.'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.hPad(context);

    // Card width based on screen
    double cardWidth;
    if (isMobile) {
      cardWidth = size.width - hPad * 2;
    } else if (isTablet) {
      cardWidth = (size.width - hPad * 2 - 72 - 18) / 2; 
    } else {
      cardWidth = (size.width - hPad * 2 - 72 - 36) / 3; 
    }

    return SizedBox(
      height: size.height,
      child: Container(
        color: kBg2,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: Responsive.vPad(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('// services.dart'),
                  const SizedBox(height: 10),
                  _SectionTitle('What I Bring',
                      fontSize: Responsive.sectionTitleSize(context)),
                  const SizedBox(height: 8),
                  const Text(
                    'Root-Sys International · Flutter Development · 6-Month Training & Internship',
                    style: TextStyle(
                        color: kTextDim,
                        fontSize: 12,
                        fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 32),
                  const _PremiumSubHeader(label: '01', title: 'What I Do'),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: _services.map((s) => SizedBox(
                      width: cardWidth.clamp(240.0, 400.0),
                      child: _ServiceCard(
                          icon: s.icon, title: s.title, desc: s.desc),
                    )).toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});
  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _projects = <Map<String, dynamic>>[
    {
      'title': 'E-Commerce App',
      'desc':
          'Full shopping app with product listing, cart, Firebase auth, and Razorpay payment integration. Clean MVVM architecture.',
      'tags': ['Flutter', 'Firebase', 'Razorpay', 'API'],
      'icon': Icons.shopping_bag_outlined,
      'github': 'https://github.com/muhsina9947/flutter-ecommerce-app',
    },
    {
      'title': 'Netflix Clone',
      'desc':
          'Netflix-inspired streaming UI with TMDB API integration. Browse movies, trailers and categories with smooth animations.',
      'tags': ['Flutter', 'REST API', 'TMDB'],
      'icon': Icons.play_circle_outline,
      'github': 'https://github.com/muhsina9947/Netflix-Clone-App',
    },
    {
      'title': 'Translator App',
      'desc':
          'Multi-language translator using Google Translate API. Supports 50+ languages with voice input and Firebase backend.',
      'tags': ['Flutter', 'REST API', 'Firebase'],
      'icon': Icons.translate_outlined,
      'github': 'https://github.com/muhsina9947/translator_app_api',
    },
    {
      'title': 'Weather App',
      'desc':
          'Real-time weather app using OpenWeatherMap API. Shows current weather, 7-day forecast and GPS location updates.',
      'tags': ['Flutter', 'REST API', 'GetX'],
      'icon': Icons.wb_sunny_outlined,
      'github': 'https://github.com/muhsina9947/weather-Api',
    },
    {
      'title': 'Todo App',
      'desc':
          'Full CRUD todo app with Firebase Firestore backend, user authentication, and real-time sync across devices.',
      'tags': ['Flutter', 'Firebase', 'Firestore'],
      'icon': Icons.check_circle_outline,
      'github': 'https://github.com/muhsina9947/firebase-todo-app',
    },
    {
      'title': 'Calculator App',
      'desc':
          'Clean calculator built with Dart and BLoC state management. Supports all arithmetic operations with history.',
      'tags': ['Flutter', 'Dart', 'BLoC'],
      'icon': Icons.calculate_outlined,
      'github': 'https://github.com/muhsina9947/calculator_bloc',
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.hPad(context);

    // Calculate card widths responsively
    double cardWidth;
    if (isMobile) {
      cardWidth = size.width - hPad * 2;
    } else if (isTablet) {
      cardWidth = (size.width - hPad * 2 - 72 - 20) / 2;
    } else {
      cardWidth = (size.width - hPad * 2 - 72 - 40) / 3;
    }
    cardWidth = cardWidth.clamp(260.0, 380.0);

    return SizedBox(
      height: size.height,
      child: Container(
        color:kBg2,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: hPad, vertical: Responsive.vPad(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('// projects.dart'),
                  const SizedBox(height: 10),
                  _SectionTitle("What I've Built",
                      fontSize: Responsive.sectionTitleSize(context)),
                  const SizedBox(height: 28),
                  Wrap(
  spacing: 20,
  runSpacing: 20,
  children: _projects.map((p) {
    return SizedBox(
      width: 350,
      height: 250,
      child: _ProjectCard(p),
    );
  }).toList(),
),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const _ProjectCard(this.data);
  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;
  bool _ghHovered = false;

  Future<void> _openGithub() async {
    final url = widget.data['github'] as String;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kBg2,
          border:
              Border.all(color: _hovered ? kGreen : kGreenDim.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: kGreen.withOpacity(0.14),
                      blurRadius: 28,
                      spreadRadius: 2)
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _hovered ? kGreenGlow2 : kGreenGlow,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                                color: kGreen.withOpacity(0.3), blurRadius: 12)
                          ]
                        : [],
                  ),
                  child: Icon(
                    widget.data['icon'] as IconData,
                    color: kGreen,
                    size: 22,
                  ),
                ),
                Tooltip(
                  message: 'View Source Code',
                  preferBelow: false,
                  decoration: BoxDecoration(
                    color: kBg2,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: kGreenDim.withOpacity(0.5)),
                  ),
                  textStyle: const TextStyle(
                    color: kGreen,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _ghHovered = true),
                    onExit: (_) => setState(() => _ghHovered = false),
                    child: GestureDetector(
                      onTap: _openGithub,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _ghHovered
                              ? kGreen.withOpacity(0.15)
                              : kGreenGlow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _ghHovered
                                ? kGreen
                                : kGreenDim.withOpacity(0.4),
                            width: _ghHovered ? 1.5 : 1,
                          ),
                          boxShadow: _ghHovered
                              ? [
                                  BoxShadow(
                                      color: kGreen.withOpacity(0.25),
                                      blurRadius: 10)
                                ]
                              : [],
                        ),
                        child: Center(
                          child: AnimatedScale(
                            scale: _ghHovered ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 180),
                            child: _GitHubLogo(
                              size: 17,
                              color: _ghHovered
                                  ? kGreen
                                  : kGreenDim.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.data['title'] as String,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              widget.data['desc'] as String,
              style: const TextStyle(
                  color: kTextDim, fontSize: 12.5, height: 1.7),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: (widget.data['tags'] as List<String>)
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: kGreenGlow,
                          border:
                              Border.all(color: kGreenDim.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(t,
                            style: const TextStyle(
                                color: kGreen,
                                fontSize: 11,
                                fontFamily: 'monospace')),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GitHubLogo extends StatelessWidget {
  final double size;
  final Color color;
  const _GitHubLogo({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GitHubLogoPainter(color: color),
    );
  }
}

class _GitHubLogoPainter extends CustomPainter {
  final Color color;
  const _GitHubLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scaleX = s.width / 24.0;
    final scaleY = s.height / 24.0;
    canvas.scale(scaleX, scaleY);

    final path = Path();
    path.moveTo(12, 0.297);
    path.cubicTo(5.373, 0.297, 0, 5.67, 0, 12.297);
    path.cubicTo(0, 17.6, 3.438, 22.1, 8.205, 23.682);
    path.cubicTo(8.805, 23.795, 9.025, 23.424, 9.025, 23.105);
    path.cubicTo(9.025, 22.82, 9.015, 22.065, 9.01, 21.065);
    path.cubicTo(5.672, 21.789, 4.968, 19.454, 4.968, 19.454);
    path.cubicTo(4.422, 18.07, 3.633, 17.7, 3.633, 17.7);
    path.cubicTo(2.546, 16.956, 3.717, 16.971, 3.717, 16.971);
    path.cubicTo(4.922, 17.055, 5.555, 18.207, 5.555, 18.207);
    path.cubicTo(6.625, 20.042, 8.364, 19.512, 9.05, 19.205);
    path.cubicTo(9.158, 18.429, 9.467, 17.9, 9.81, 17.6);
    path.cubicTo(7.145, 17.3, 4.344, 16.268, 4.344, 11.67);
    path.cubicTo(4.344, 10.36, 4.809, 9.29, 5.579, 8.453);
    path.cubicTo(5.455, 8.153, 5.044, 6.928, 5.696, 5.274);
    path.cubicTo(5.696, 5.274, 6.704, 4.955, 8.997, 6.509);
    path.cubicTo(9.954, 6.245, 10.98, 6.113, 12, 6.107);
    path.cubicTo(13.02, 6.113, 14.047, 6.245, 15.006, 6.509);
    path.cubicTo(17.297, 4.955, 18.303, 5.274, 18.303, 5.274);
    path.cubicTo(18.956, 6.928, 18.545, 8.153, 18.421, 8.453);
    path.cubicTo(19.193, 9.29, 19.655, 10.36, 19.655, 11.67);
    path.cubicTo(19.655, 16.28, 16.849, 17.295, 14.176, 17.59);
    path.cubicTo(14.607, 17.95, 14.992, 18.686, 14.992, 19.81);
    path.cubicTo(14.992, 21.416, 14.977, 22.706, 14.977, 23.096);
    path.cubicTo(14.977, 23.411, 15.194, 23.786, 15.802, 23.679);
    path.cubicTo(20.565, 22.092, 24, 17.592, 24, 12.297);
    path.cubicTo(24, 5.67, 18.627, 0.297, 12, 0.297);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GitHubLogoPainter old) => old.color != color;
}


class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF0F2318) : kBg2,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _hovered ? kGreen : kGreen.withOpacity(0.15),
                width: _hovered ? 1.5 : 1),
            boxShadow: [
              BoxShadow(
                  color: _hovered
                      ? kGreen.withOpacity(0.18)
                      : kGreenGlow.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 1),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _hovered ? kGreenGlow2 : kGreenGlow,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(widget.icon, color: kGreen, size: 24),
              ),
              const SizedBox(height: 18),
              Text(widget.title,
                  style: TextStyle(
                      color: _hovered ? Colors.white : kText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(widget.value,
                  style: const TextStyle(color: kTextDim, fontSize: 13)),
              const SizedBox(height: 6),
              Text(widget.subtitle,
                  style: const TextStyle(color: kCodeText, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _email = 'chmuhsinach@gmail.com';
  static const _github = 'https://github.com/muhsina9947';
  static const _linkedin = 'https://www.linkedin.com/in/muhsina-c-9b572039a/';
  static const _phone = '+91 7012083937';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.hPad(context);

    
    double cardWidth;
    if (isMobile) {
      cardWidth = size.width - hPad * 2;
    } else if (isTablet) {
      cardWidth = (size.width - hPad * 2 - 100- 20) / 2;
    } else {
      cardWidth = (size.width - hPad * 2 - 100 - 60) / 4;
    }
    cardWidth = cardWidth.clamp(240.0, 320.0);

    return SizedBox(
      height: size.height,
      child: Container(
        color: kBg,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: hPad, vertical: Responsive.vPad(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('// contact.dart'),
                  const SizedBox(height: 10),
                  _SectionTitle('Get In Touch',
                      fontSize: Responsive.sectionTitleSize(context)),
                  const SizedBox(height: 32),
                  
                     const Text(
                      "I'm open to freelance projects, full-time roles,\nor just a Flutter conversation. Drop me a message!",
                      style: TextStyle(
                          color: kTextDim, fontSize: 14, height: 1.8),
                    ),
                  
                  const SizedBox(height: 100),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                       SizedBox(
                          width: cardWidth,
                          child: _ContactCard(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: _email,
                            subtitle: 'Tap to send email',
                            onTap: () => _launch('mailto:$_email'),
                          ),
                        ),
                     
                      SizedBox(
                          width: cardWidth,
                          child: _ContactCard(
                            icon: Icons.code,
                            title: 'GitHub',
                            value: 'github.com/muhsina9947',
                            subtitle: 'View my repositories',
                            onTap: () => _launch(_github),
                          ),
                        ),
                      
                    
                         SizedBox(
                          width: cardWidth,
                          child: _ContactCard(
                            icon: Icons.link,
                            title: 'LinkedIn',
                            value: 'linkedin.com/in/muhsina',
                            subtitle: 'Connect with me',
                            onTap: () => _launch(_linkedin),
                          ),
                        ),
                      
                       SizedBox(
                          width: cardWidth,
                          child: _ContactCard(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: _phone,
                            subtitle: 'Tap to call',
                            onTap: () => _launch('tel:$_phone'),
                          ),
                        ),
                     
                    ],
                  ),
                  const SizedBox(height: 100),

Align(
  alignment: Alignment.center,
  child: Text(
    '© 2026 Muhsina · Built with Flutter 💚',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: kTextDim.withOpacity(0.5),
      fontSize: 12,
      fontFamily: 'monospace',
    ),
  ),
),


                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}


class _PremiumSubHeader extends StatelessWidget {
  final String label, title;
  const _PremiumSubHeader({required this.label, required this.title});
  @override
  Widget build(BuildContext context) => Row(children: [
        Text(label,
            style: const TextStyle(
                color: kGreen,
                fontSize: 11,
                fontFamily: 'monospace',
                letterSpacing: 2,
                fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        Container(width: 24, height: 1, color: kGreen),
        const SizedBox(width: 12),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800)),
      ]);
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title, desc;
  const _ServiceCard(
      {required this.icon, required this.title, required this.desc});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hovered ? const Color(0xFF0F2318) : kBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: _hovered ? kGreen : kGreenDim.withOpacity(0.2),
              width: _hovered ? 1.5 : 1),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: kGreen.withOpacity(0.15),
                      blurRadius: 24,
                      spreadRadius: 1)
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _hovered ? kGreen.withOpacity(0.15) : kGreenGlow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                            color: kGreen.withOpacity(0.3), blurRadius: 12)
                      ]
                    : [],
              ),
              child: Icon(widget.icon,
                  color: _hovered ? kGreen : kGreen.withOpacity(0.7), size: 22),
            ),
            const SizedBox(height: 14),
            Text(widget.title,
                style: TextStyle(
                    color: _hovered ? Colors.white : kText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(widget.desc,
                style: const TextStyle(
                    color: kTextDim, fontSize: 12, height: 1.65)),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: kGreen,
          fontSize: 12,
          fontFamily: 'monospace',
          letterSpacing: 2));
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  const _SectionTitle(this.text, {this.fontSize = 38});
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w800));
}