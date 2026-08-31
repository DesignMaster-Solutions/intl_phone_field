import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key, required this.phoneNumber, this.countryCode}) : super(key: key);

  final String phoneNumber;
  final String? countryCode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test Intl Phone Field',
        home: Scaffold(
          appBar: AppBar(title: const Text("")),
          body: IntlPhoneField(
            initialValue: phoneNumber,
            initialCountryCode: countryCode,
          ),
        ));
  }
}

void main() {
  testWidgets(
      'country picker keeps a tapped row valid while a search rebuild is pending',
      (tester) async {
    final pickerCountries = countries.take(2).toList();

    await tester.pumpWidget(
      MaterialApp(
        home: CountryPickerDialog(
          searchText: 'Search country',
          languageCode: 'en',
          countryList: pickerCountries,
          filteredCountries: pickerCountries,
          selectedCountry: pickerCountries.first,
          onCountryChanged: (_) {},
        ),
      ),
    );

    final searchField = tester.widget<TextField>(find.byType(TextField));
    final firstVisibleCountry =
        tester.widget<ListTile>(find.byType(ListTile).first);

    searchField.onChanged!('no-country-has-this-name');

    expect(firstVisibleCountry.onTap, returnsNormally);
  });

  testWidgets('Test intl_phone_field setup with completeNumber', (WidgetTester tester) async {
    await tester.pumpWidget(const TestWidget(
      phoneNumber: '+447891234467',
    ));

    final countryCodeFinder = find.text('+44');
    final numberFinder = find.text('7891234467');

    expect(countryCodeFinder, findsOneWidget);
    expect(numberFinder, findsOneWidget);
  });

  testWidgets('Test intl_phone_field setup with Guernsey number: +441481960194', (WidgetTester tester) async {
    await tester.pumpWidget(const TestWidget(
      phoneNumber: '+441481960194',
      countryCode: 'GG',
    ));

    final countryCodeFinder = find.text('+44 1481');
    final numberFinder = find.text('960194');

    expect(countryCodeFinder, findsOneWidget);
    expect(numberFinder, findsOneWidget);
  });

  testWidgets('Test intl_phone_field setup with UK number: +447891244567', (WidgetTester tester) async {
    await tester.pumpWidget(const TestWidget(
      phoneNumber: '+447891244567',
      countryCode: 'GB',
    ));

    final countryCodeFinder = find.text('+44');
    final numberFinder = find.text('7891244567');

    expect(countryCodeFinder, findsOneWidget);
    expect(numberFinder, findsOneWidget);
  });
}
