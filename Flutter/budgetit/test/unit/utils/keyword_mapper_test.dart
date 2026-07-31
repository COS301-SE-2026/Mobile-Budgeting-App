import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/utils/keyword_mapper.dart';

void main() {
  group('KeywordMapper', () {
    test('classifies grocery merchants', () {
      expect(KeywordMapper.classify('CHECKERS HYPER PAYMENT'), 'Groceries');
      expect(KeywordMapper.classify('Pick n Pay groceries'), 'Groceries');
      expect(KeywordMapper.classify('Woolworths Food purchase'), 'Groceries');
    });

    test('classifies dining merchants', () {
      expect(KeywordMapper.classify('KFC PRETORIA'), 'Dining Out');
      expect(KeywordMapper.classify('Uber Eats order'), 'Dining Out');
      expect(KeywordMapper.classify('Coffee shop payment'), 'Dining Out');
    });

    test('classifies transport merchants', () {
      expect(KeywordMapper.classify('Uber trip'), 'Transport');
      expect(KeywordMapper.classify('Shell fuel payment'), 'Transport');
      expect(KeywordMapper.classify('Parking fee'), 'Transport');
    });

    test('classifies income and investment descriptions', () {
      expect(KeywordMapper.classify('Salary payment'), 'Salary');
      expect(KeywordMapper.classify('Freelance invoice paid'), 'Freelance');
      expect(KeywordMapper.classify('Easy Equities dividend'), 'Investments');
    });

    test('returns null when no keyword matches', () {
      expect(KeywordMapper.classify('Unknown random transaction'), isNull);
    });

    test('classification is case insensitive', () {
      expect(KeywordMapper.classify('NETFLIX MONTHLY FEE'), 'Subscriptions');
    });
  });
}
