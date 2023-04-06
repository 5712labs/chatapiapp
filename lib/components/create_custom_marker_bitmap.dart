import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'dart:ui' as ui;

import 'package:chat_api_app/src/request_office_model.dart';
import 'package:intl/intl.dart';

Future<BitmapDescriptor> createCustomMarkerBitmap(
  Cluster<RequestOffice> cluster,
  int loginId,
  //   String title, {
  //   required TextStyle textStyle,
  //   Color backgroundColor = Colors.blueAccent,
  // }) async {
  // String title,
  // String desc,
  // TextStyle textStyle,
  // Color backgroundColor,
) async {
  var title = '';
  const textStyle =
      TextStyle(fontSize: (kIsWeb) ? 14 : 28, color: Colors.white);
  var backgroundColor = AppTheme.kDarkGreenColor;

  TextSpan span = TextSpan(
    style: textStyle,
    text: title,
  );
  TextPainter painter = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: ui.TextDirection.ltr,
  );

  if (cluster.isMultiple == false) {
    for (var p in cluster.items) {
      if (p.users.id == loginId) backgroundColor = AppTheme.darkGrey;
    }
  }

  // 2개 이상: 지도 확대하기
  if (cluster.isMultiple) {
    title = '${cluster.count.toString()}건';
    var size = 120;
    // if (kIsWeb) size = (size / 2).floor();
    if (kIsWeb) size = 80;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = backgroundColor;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    // canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (title != null) {
      TextPainter painter = TextPainter(textDirection: ui.TextDirection.ltr);
      painter.text = TextSpan(
        text: title,
        style: textStyle,
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
    // 1개: 상세 정보보기
  } else {
    cluster.items.forEach((p) => {
          title =
              '${p.categories.name}\n${converPriceToString(p.price.toString())}',
        });
    painter.text = TextSpan(
      // text: title.toString(),
      text: title,
      style: textStyle,
    );
    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    painter.layout();
    painter.paint(canvas, const Offset(20.0, 10.0));
    int textWidth = painter.width.toInt();
    int textHeight = painter.height.toInt();
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, 0, textWidth + 40, textHeight + 20,
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10)),
        Paint()..color = backgroundColor);
    var arrowPath = Path();
    arrowPath.moveTo((textWidth + 40) / 2 - 15, textHeight + 20);
    arrowPath.lineTo((textWidth + 40) / 2, textHeight + 40);
    arrowPath.lineTo((textWidth + 40) / 2 + 15, textHeight + 20);
    arrowPath.close();
    canvas.drawPath(arrowPath, Paint()..color = backgroundColor);
    painter.layout();
    painter.paint(canvas, const Offset(20.0, 10.0));
    ui.Picture p = pictureRecorder.endRecording();
    ByteData? pngBytes = await (await p.toImage(
            painter.width.toInt() + 40, painter.height.toInt() + 50))
        .toByteData(format: ui.ImageByteFormat.png);
    Uint8List data = Uint8List.view(pngBytes!.buffer);
    return BitmapDescriptor.fromBytes(data);
  }
}

String converPriceToString(String price) {
  if (price == '0') {
    return '나눔';
  }
  var cPrice = NumberFormat.simpleCurrency(
    locale: "ko_kr",
    name: '',
    decimalDigits: 0,
  ).format(int.parse(price));

  return '$cPrice원';
}
