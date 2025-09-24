import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Widget getAssetImage(String assetName,
    {double? height, double? width, BoxFit? fit, double? scale}) {
  return Image.asset(
    "assets/images/$assetName",
    height: height,
    width: width,
    fit: fit,
    scale: scale,
  );
}





class PagePadding extends StatelessWidget {
  final Widget child;

  const PagePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.04,
            right: MediaQuery.of(context).size.width * 0.04,
            left: MediaQuery.of(context).size.width * 0.04,
            bottom: MediaQuery.of(context).size.width * 0.04),
        child: child);
  }
}

buildCommonAppBar(label, onTap,
    {Color? color,
    bool? showBack,
    bool? showDrawer,
    Widget? iconButton,
    required BuildContext context}) {
  return Container(
    height: 60,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            showBack == true || showDrawer == true
                ? GestureDetector(
                    onTap: () {
                      onTap();
                    },
                    child: Container(
                      color: Colors.white,
                      width: 40,
                      height: 35,
                      child: showDrawer == true
                          ? const Icon(Icons.menu,
                              weight: 100, size: 22, color: Colors.black)
                          : const Icon(Icons.arrow_back_ios,
                              weight: 100, size: 22, color: Colors.black),
                    ))
                : const SizedBox(
                    width: 20,
                  ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
            // const SizedBox(
            //   width: 20,
            // ),
            // iconButton ??
            //     const SizedBox(
            //       width: 20,
            //     )
          ],
        ),
        Divider(
          thickness: 1,
          color: HexColor.fromHex("#858585"),
        ),
      ],
    ),
  );
}

class AlternateRichText extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final TextStyle styleOne;
  final TextStyle styleTwo;
  AlternateRichText(
      {required this.textOne,
      required this.textTwo,
      required styleOne,
      required styleTwo})
      : styleOne = styleOne,
        styleTwo = styleTwo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(textOne, style: styleOne),
          ],
        ),
        Column(
          children: [
            Text(textTwo, style: styleTwo),
          ],
        )
      ],
    );
  }
}


class ListWithFixedButtonAtBottom extends StatelessWidget {
  final List<Widget> children;
  final List<Widget> fixedAtBottomChild;

  const ListWithFixedButtonAtBottom({
    super.key,
    required this.children,
    required this.fixedAtBottomChild,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: fixedAtBottomChild,
            ),
          ),
        )
      ],
    );
  }
}


class ButtonWithLoader extends StatefulWidget {
  final Function onPressed;
  final bool showLoading;
  final String label;
  final double? width;
  final bool? isDashboardButtons;
  final bool? isDisabled;
  final Color? color;

  final bool? isOnBoarding;
  final bool? needShadow;
  const ButtonWithLoader(
      {Key? key,
      required this.onPressed,
      required this.showLoading,
      required this.label,
      this.isDashboardButtons,
      this.needShadow,
      this.color,
      this.width,
      this.isOnBoarding,
      this.isDisabled})
      : super(key: key);

  @override
  State<ButtonWithLoader> createState() => _ButtonWithLoaderState();
}

class _ButtonWithLoaderState extends State<ButtonWithLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    animation =
        Tween<double>(begin: 1.0, end: 0.5).animate(animationController);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!widget.showLoading)
        ? FadeTransition(
            opacity: animation,
            child: InkWell(
              onTap: () {
                if (widget.isDisabled == false || widget.isDisabled == null) {
                  animationController.forward();
                  widget.onPressed();
                }
              },
              child: InnerShadow(
                blur: 5,
                color: HexColor.fromHex("#000000").withOpacity(0.25),
                offset: (widget.isOnBoarding == true)
                    ? const Offset(3, 3)
                    : const Offset(4, 4),
                child: Container(
                  width: widget.width,
                  height: widget.isOnBoarding == true ? 50 : 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: widget.isDisabled == true
                        ? Colors.grey
                        : widget.color ?? HexColor.fromHex("#048193"),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing:
                              widget.isDashboardButtons == true ? 0 : 2,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isDashboardButtons == true ? 14 : 15,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox(
            height: 40,
            width: 40,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )));
  }
}

class InnerShadow extends SingleChildRenderObjectWidget {
  const InnerShadow({
    Key? key,
    this.blur = 10,
    required this.color,
    this.offset = const Offset(10, 10),
    Widget? child,
  }) : super(key: key, child: child);

  final double blur;
  final Color color;
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  double? blur;
  Color? color;
  double? dx;
  double? dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final Rect rectOuter = offset & size;
    final Rect rectInner = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width - dx!,
      size.height - dy!,
    );
    final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
    context.paintChild(child!, offset);
    final Paint shadowPaint = Paint()
      ..blendMode = BlendMode.srcATop
      ..imageFilter = ImageFilter.blur(sigmaX: blur!, sigmaY: blur!)
      ..colorFilter = ColorFilter.mode(color!, BlendMode.srcOut);

    canvas
      ..saveLayer(rectOuter, shadowPaint)
      ..saveLayer(rectInner, Paint())
      ..translate(dx!, dy!);
    context.paintChild(child!, offset);
    context.canvas
      ..restore()
      ..restore()
      ..restore();
  }
}

class ProcessCompletionDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String path;
  final Function onTap;
  final String? buttonLabel;
  final Color? buttoncolor;
  final bool? requireCloseButton;
  final String? closeButtonLabel;
  final bool? showLoading;
  final bool? requireRefreshButton;
  final bool? fromSplash;
  final VoidCallback? onClose;
  const ProcessCompletionDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.onTap,
    this.buttonLabel,
    this.buttoncolor,
    this.requireCloseButton,
    this.closeButtonLabel,
    this.showLoading,
    this.fromSplash,
    this.onClose,
    this.requireRefreshButton,
  }) : super(key: key);
  @override
  State<ProcessCompletionDialog> createState() =>
      _ProcessCompletionDialogState();
}

class _ProcessCompletionDialogState extends State<ProcessCompletionDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          content: (widget.showLoading == false || widget.showLoading == null)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: widget.path == "" ? 0 : 60,
                    ),
                    widget.path == ""
                        ? getAssetImage(
                            "pop_up_image.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          )
                        : Container(),
                    SizedBox(
                      height: widget.path == "" ? 20 : 0,
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: widget.requireCloseButton ?? false,
                          child: Expanded(
                            child: buttonForPasswordSentDialog(
                              buttonColor: HexColor.fromHex("#048193"),
                              onTap: () {
                                if (widget.fromSplash == true) {
                                  widget.onClose!();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              buttonLabel: widget.closeButtonLabel ?? "Close",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: buttonForPasswordSentDialog(
                            buttonColor: widget.buttoncolor,
                            onTap: () {
                              widget.path == ""
                                  ? Navigator.pop(context)
                                  : widget.onTap();
                            },
                            buttonLabel: widget.buttonLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
      ),
      (widget.path != "")
          ? Positioned(
              top: MediaQuery.of(context).size.height / 3.7,
              left: 0, ////////////////////////////////
              right: 0,
              child: getAssetImage(
                widget.path,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            )
          : Container(),
    ]);
  }

  buttonForPasswordSentDialog(
      {Function? onTap, String? buttonLabel, Color? buttonColor}) {
    return ButtonWithLoader(
      isOnBoarding: true,
      showLoading: false,
      label: buttonLabel ?? "",
      color: buttonColor,
      onPressed: () {
        onTap!();
      },
    );
  }
}
