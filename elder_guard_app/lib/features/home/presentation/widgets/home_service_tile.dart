import 'package:elder_guard_app/features/home/presentation/models/home_service_item.dart';
import 'package:flutter/material.dart';

class HomeServiceTile extends StatelessWidget {
  const HomeServiceTile({required this.item, required this.onTap, super.key});

  final HomeServiceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 15,
      color: const Color(0xFF143B39),
      height: 1.2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, item.accentColor.withValues(alpha: 0.16)],
            ),
            border: Border.all(
              color: item.accentColor.withValues(alpha: 0.24),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: item.accentColor.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: item.accentColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, color: item.accentColor, size: 28),
                ),
                const Spacer(),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
                const SizedBox(height: 18),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: item.accentColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
