import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_assets.dart';
import '../app_color.dart';
class NaviButton extends StatefulWidget {
  final void Function(int) onTabChanged;
  final int initialTab;

  const NaviButton({
    Key? key,
    required this.onTabChanged,
    this.initialTab = 0,
  }) : super(key: key);

  @override
  State<NaviButton> createState() => _NaviButtonState();
}

class _NaviButtonState extends State<NaviButton> with SingleTickerProviderStateMixin {
  late int activeTab;
  
  @override
  void initState() {
    super.initState();
    activeTab = widget.initialTab;
  }

  void _switchTab(int index) {
    if (index == activeTab) return;
    
    setState(() {
      activeTab = index;
    });
    
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    // Add some padding to help with sizing
    const double horizontalPadding = 8.0;
    const double verticalPadding = 6.0;
    
    return Container(
      height: 55,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding, 
        vertical: verticalPadding
      ),
      decoration: BoxDecoration(
        color: AppColor.inputField,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColor.border, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),  // Slightly smaller to account for padding
        child: Stack(
          children: [
            // Animated selection indicator with adjusted calculations
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // Calculate position based on container width minus padding
              left: activeTab * (MediaQuery.of(context).size.width - 40 - horizontalPadding * 2) / 2,
              top: 0,
              bottom: 0,
              // Calculate width based on container width minus padding
              width: (MediaQuery.of(context).size.width - 40 - horizontalPadding * 2) / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            
            // Tabs row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Resume Builder tab
                Expanded(
                  child: InkWell(
                    onTap: () => _switchTab(0),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.builderIcon,height:24,width:24),
                          const SizedBox(width: 8),
                          Text(
                            'Builder',
                            style: TextStyle(
                              color: activeTab == 0 ? AppColor.text : AppColor.secondaryText,
                              fontWeight: activeTab == 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Resume Analyzer tab
                Expanded(
                  child: InkWell(
                    onTap: () => _switchTab(1),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.scanIcon,width:24,height:24),
                          const SizedBox(width: 8),
                          Text(
                            'Analyzer',
                            style: TextStyle(
                              color: activeTab == 1 ? AppColor.text : AppColor.secondaryText,
                              fontWeight: activeTab == 1 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}