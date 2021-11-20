// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DatePickerThemeData copyWith, ==, hashCode basics', () {
    expect(const DatePickerThemeData(), const DatePickerThemeData().copyWith());
    expect(const DatePickerThemeData().hashCode, const DatePickerThemeData().copyWith().hashCode);
  });

  test('DatePickerThemeData null fields by default', () {
    const DatePickerThemeData datePickerTheme = DatePickerThemeData();
    expect(datePickerTheme.backgroundColor, null);
    expect(datePickerTheme.entryModeIconColor, null);
    expect(datePickerTheme.helpTextStyle, null);
    expect(datePickerTheme.shape, null);
  });

  testWidgets('Default DatePickerThemeData debugFillProperties', (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const DatePickerThemeData().debugFillProperties(builder);

    final List<String> description = builder.properties
        .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
        .map((DiagnosticsNode node) => node.toString())
        .toList();

    expect(description, <String>[]);
  });

  testWidgets('DatePickerThemeData implements debugFillProperties', (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const DatePickerThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      entryModeIconColor: Color(0xFFFFFFFF),
      helpTextStyle: TextStyle(),
      shape: RoundedRectangleBorder(),
    ).debugFillProperties(builder);

    final List<String> description = builder.properties
        .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
        .map((DiagnosticsNode node) => node.toString())
        .toList();

    expect(description, <String>[
      'backgroundColor: Color(0xffffffff)',
      'entryModeIconColor: Color(0xffffffff)',
      'helpTextStyle: TextStyle(<all styles inherited>)',
      'shape: RoundedRectangleBorder(BorderSide(Color(0xff000000), 0.0, BorderStyle.none), BorderRadius.zero)',
    ]);
  });

  testWidgets('Passing no DatePickerThemeData uses defaults', (WidgetTester tester) async {
    final ThemeData defaultTheme = ThemeData.fallback();
    await tester.pumpWidget(const _DatePickerLauncher());
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final Material dialogMaterial = _dialogMaterial(tester);
    expect(dialogMaterial.color, defaultTheme.colorScheme.surface);
    expect(dialogMaterial.shape, const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))));

    final RenderParagraph helperText = _textRenderParagraph(tester, 'SELECT DATE');
    expect(
      helperText.text.style,
      Typography.material2014().englishLike.overline!
          .merge(Typography.material2014().white.overline),
    );

    final IconButton entryModeIconButton = _entryModeIconButton(tester);
    expect(
      entryModeIconButton.color,
      defaultTheme.colorScheme.onPrimary,
    );
  });

  testWidgets('Passing no DatePickerThemeData uses defaults - input mode', (WidgetTester tester) async {
    final ThemeData defaultTheme = ThemeData.fallback();
    await tester.pumpWidget(const _DatePickerLauncher(entryMode: DatePickerEntryMode.input));
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final Material dialogMaterial = _dialogMaterial(tester);
    expect(dialogMaterial.color, defaultTheme.colorScheme.surface);
    expect(dialogMaterial.shape, const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))));

    final RenderParagraph helperText = _textRenderParagraph(tester, 'SELECT DATE');
    expect(
      helperText.text.style,
      Typography.material2014().englishLike.overline!
          .merge(Typography.material2014().white.overline),
    );

    final IconButton entryModeIconButton = _entryModeIconButton(tester);
    expect(
      entryModeIconButton.color,
      defaultTheme.colorScheme.onPrimary,
    );
  });

  testWidgets('Date picker uses values from DatePickerThemeData', (WidgetTester tester) async {
    final DatePickerThemeData datePickerTheme = _datePickerTheme();
    final ThemeData theme = ThemeData(datePickerTheme: datePickerTheme);
    await tester.pumpWidget(_DatePickerLauncher(themeData: theme));
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final Material dialogMaterial = _dialogMaterial(tester);
    expect(dialogMaterial.color, datePickerTheme.backgroundColor);
    expect(dialogMaterial.shape, datePickerTheme.shape);

    final RenderParagraph helperText = _textRenderParagraph(tester, 'SELECT DATE');
    expect(
      helperText.text.style,
      Typography.material2014().englishLike.bodyText2!
          .merge(Typography.material2014().black.bodyText2)
          .merge(datePickerTheme.helpTextStyle),
    );

    final IconButton entryModeIconButton = _entryModeIconButton(tester);
    expect(
      entryModeIconButton.color,
      datePickerTheme.entryModeIconColor,
    );
  });

  testWidgets('Date picker uses values from DatePickerThemeData - input mode', (WidgetTester tester) async {
    final DatePickerThemeData datePickerTheme = _datePickerTheme();
    final ThemeData theme = ThemeData(datePickerTheme: datePickerTheme);
    await tester.pumpWidget(_DatePickerLauncher(themeData: theme, entryMode: DatePickerEntryMode.input));
    await tester.tap(find.text('X'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final Material dialogMaterial = _dialogMaterial(tester);
    expect(dialogMaterial.color, datePickerTheme.backgroundColor);
    expect(dialogMaterial.shape, datePickerTheme.shape);

    final RenderParagraph helperText = _textRenderParagraph(tester, 'SELECT DATE');
    expect(
      helperText.text.style,
      Typography.material2014().englishLike.bodyText2!
          .merge(Typography.material2014().black.bodyText2)
          .merge(datePickerTheme.helpTextStyle),
    );

    final IconButton entryModeIconButton = _entryModeIconButton(tester);
    expect(
      entryModeIconButton.color,
      datePickerTheme.entryModeIconColor,
    );
  });
}

DatePickerThemeData _datePickerTheme() {
  return const DatePickerThemeData(
    backgroundColor: Colors.orange,
    entryModeIconColor: Colors.red,
    helpTextStyle: TextStyle(fontSize: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
  );
}

class _DatePickerLauncher extends StatelessWidget {
  const _DatePickerLauncher({
    Key? key,
    this.themeData,
    this.entryMode = DatePickerEntryMode.calendar,
  }) : super(key: key);

  final ThemeData? themeData;
  final DatePickerEntryMode entryMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: Material(
        child: Center(
          child: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                child: const Text('X'),
                onPressed: () async {
                  await showDatePicker(
                    context: context,
                    initialEntryMode: entryMode,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Material _dialogMaterial(WidgetTester tester) {
  return tester.widget<Material>(find.descendant(of: find.byType(Dialog), matching: find.byType(Material)).first);
}

IconButton _entryModeIconButton(WidgetTester tester) {
  return tester.widget<IconButton>(find.descendant(of: find.byType(Dialog), matching: find.byType(IconButton)).first);
}

RenderParagraph _textRenderParagraph(WidgetTester tester, String text) {
  return tester.element<StatelessElement>(find.text(text).first).renderObject! as RenderParagraph;
}
