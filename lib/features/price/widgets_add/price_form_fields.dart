import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

// --- TEXT FIELD WIDGET ---
class PriceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isNumber;
  final bool readOnly; // YENİ: Salt okunur özelliği

  const PriceTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isNumber = false,
    this.readOnly = false, // Varsayılan false (yazılabilir)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Eğer salt okunursa arka planı hafif gri yap, değilse beyaz
        color: readOnly ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.accentGold, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly, // TextField'a aktar
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: TextStyle(
            fontWeight: FontWeight.w600, 
            // Salt okunursa rengi biraz soldur
            color: readOnly ? AppTheme.navyDark.withOpacity(0.7) : AppTheme.navyDark
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: AppTheme.textGrey, fontSize: 15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GradientIcon(
                icon,
                // Salt okunursa ikon gri olsun, değilse altın rengi
                gradient: readOnly 
                    ? const LinearGradient(colors: [Colors.grey, Colors.grey]) 
                    : AppTheme.accentGradient, 
                size: 24
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

// --- DROPDOWN WIDGET ---
class PriceDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  // Null olabilirliği yönetmek için ValueChanged kullanıyoruz
  final ValueChanged<String?>? onChanged; 

  const PriceDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // onChanged null ise (yani kilitliyse) gri arka plan
    bool isDisabled = onChanged == null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDisabled ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.accentGold, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          hint: Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GradientIcon(
                  icon,
                  gradient: isDisabled 
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                      : AppTheme.accentGradient, 
                  size: 24
              ),
            ),
            const SizedBox(width: 5),
            Text(hint,
                style:
                    const TextStyle(color: AppTheme.textGrey, fontSize: 15))
          ]),
          icon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GradientIcon(
                Icons.keyboard_arrow_down_rounded,
                gradient: isDisabled 
                      ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                      : AppTheme.accentGradient
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(color: AppTheme.navyDark)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// --- YARDIMCI GRADIENT ICON ---
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
    this.icon, {
    super.key,
    this.size = 24,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
      shaderCallback: (Rect bounds) {
        return gradient.createShader(bounds);
      },
    );
  }
}