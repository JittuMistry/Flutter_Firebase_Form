// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:form/utils/colors_utils.dart';
import 'package:form/utils/extensions_utils.dart';
import 'package:form/utils/font_utils.dart';

class CustomCard extends StatelessWidget {
  final String companyName;
  final String companyIcon;
  final String userName;
  final String email;
  final String mobile;
  final String address;
  final String color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDownload;

  const CustomCard({
    Key? key,
    required this.companyName,
    required this.companyIcon,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.address,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideMenu(
        menuItems: <Widget>[
          button(icon: Icons.edit, onPressed: onEdit),
          button(icon: Icons.delete, onPressed: onDelete),
          button(icon: Icons.file_download_outlined, onPressed: onDownload),
        ],
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: HexColor(color),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          companyIcon,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.image,
                            size: 40,
                            color: AppColors.white,
                          ),
                        )),
                    const SizedBox(width: 8),
                    text(
                      title: companyName,
                      fontSize: 16,
                      fontFamily: Fonts.normal,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                text(
                  title: userName,
                  fontSize: 16,
                  fontFamily: Fonts.bold,
                ),
                const SizedBox(height: 8),
                text(title: email, fontSize: 12),
                const SizedBox(height: 8),
                text(title: mobile, fontSize: 12),
                const SizedBox(height: 8),
                text(title: address, fontSize: 12),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Widget text({
    String? title,
    double? fontSize,
    String? fontFamily,
  }) {
    return Text(
      title ?? "",
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.white,
        fontFamily: fontFamily ?? Fonts.normal,
      ),
    );
  }

  Widget button({
    final IconData? icon,
    required void Function()? onPressed,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightGrey,
        shape: BoxShape.circle,
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 24,
            color: AppColors.black,
          )),
    );
  }
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  const SlideMenu({Key? key, required this.child, required this.menuItems})
      : super(key: key);

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation =
        Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
            .animate(CurveTween(curve: Curves.decelerate).animate(controller));

    return GestureDetector(onHorizontalDragUpdate: (data) {
      setState(() {
        controller.value -= (data.primaryDelta! / (context.size!.width * 0.2));
      });
    }, onHorizontalDragEnd: (data) {
      if (data.primaryVelocity! > 1500)
        controller.animateTo(.0);
      else if (controller.value >= .5 || data.primaryVelocity! < -1500)
        controller.animateTo(1.0);
      else
        controller.animateTo(.0);
    }, child: LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: [
          SlideTransition(position: animation, child: widget.child),
          AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Positioned(
                  right: .0,
                  top: .0,
                  bottom: .0,
                  width: constraint.maxWidth * animation.value.dx * -1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      children: widget.menuItems.map((child) {
                        return Expanded(
                          child: child,
                        );
                      }).toList(),
                    ),
                  ),
                );
              })
        ],
      );
    }));
  }
}
