import 'package:flutter/material.dart';

/// Desenha um QR Code ILUSTRATIVO (não legível) a partir de um texto.
/// Na fase de implementação será substituído por um gerador real
/// (ex.: package qr_flutter) com o código único devolvido pela API.
class FakeQrCode extends StatelessWidget {
  final String data;
  final double size;

  const FakeQrCode({super.key, required this.data, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: CustomPaint(
        size: Size.square(size),
        painter: _QrPainter(data),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final String data;
  static const int modules = 25;

  _QrPainter(this.data);

  bool _isFinder(int r, int c) {
    bool inBox(int r0, int c0) => r >= r0 && r < r0 + 7 && c >= c0 && c < c0 + 7;
    return inBox(0, 0) || inBox(0, modules - 7) || inBox(modules - 7, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / modules;
    final paint = Paint()..color = Colors.black;

    // Padrão pseudo-aleatório determinístico a partir do texto.
    var seed = data.codeUnits.fold<int>(7, (acc, u) => (acc * 31 + u) & 0x7fffffff);
    int next() {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed;
    }

    for (var r = 0; r < modules; r++) {
      for (var c = 0; c < modules; c++) {
        if (_isFinder(r, c)) continue;
        // margem branca à volta dos padrões de posição
        final nearFinder = (r < 8 && c < 8) ||
            (r < 8 && c >= modules - 8) ||
            (r >= modules - 8 && c < 8);
        if (nearFinder) continue;
        if (next() % 100 < 48) {
          canvas.drawRect(Rect.fromLTWH(c * cell, r * cell, cell, cell), paint);
        }
      }
    }

    // Três padrões de posição (quadrados nos cantos)
    void finder(int r0, int c0) {
      final o = Offset(c0 * cell, r0 * cell);
      canvas.drawRect(o & Size(cell * 7, cell * 7), paint);
      canvas.drawRect(
        (o + Offset(cell, cell)) & Size(cell * 5, cell * 5),
        Paint()..color = Colors.white,
      );
      canvas.drawRect((o + Offset(cell * 2, cell * 2)) & Size(cell * 3, cell * 3), paint);
    }

    finder(0, 0);
    finder(0, modules - 7);
    finder(modules - 7, 0);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => oldDelegate.data != data;
}
