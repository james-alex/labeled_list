import 'package:test/test.dart';
import 'package:collection/collection.dart';
import 'package:labeled_list/labeled_list.dart';

void main() {
  group('Constructors', () {
    test('default', () {
      final list = <int>[];
      final labeledList = LabeledList<int>();
      expect(list.equals(labeledList), equals(true));
    });

    test('empty', () {
      final list = List<int>.empty();
      final labeledList = LabeledList<int>.empty();
      expect(list.equals(labeledList), equals(true));
    });

    test('from', () {
      final list = <int>[0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.from(list, labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list.equals(labeledList), equals(true));
      labeledList.add(5, label: 'f');
      expect(labeledList.last, equals(list.last));
      labeledList.add(6);
      final labels = labeledList.labels;
      for (var i = 0; i < list.length; i++) {
        expect(labeledList[i], equals(i));
        expect(list[i], equals(labeledList[labels[i] ?? i]));
      }
    });

    test('of', () {
      final list = <int>[0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list.equals(labeledList), equals(true));
      labeledList.add(5, label: 'f');
      expect(labeledList.length != list.length, equals(true));
      labeledList.add(6);
      final labels = labeledList.labels;
      for (var i = 0; i < list.length; i++) {
        expect(labeledList[i], equals(i));
        expect(list[i], equals(labeledList[labels[i] ?? i]));
      }
    });

    test('filled', () {
      final list = List<int>.filled(5, 0);
      final labeledList =
          LabeledList<int>.filled(5, 0, labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list.equals(labeledList), equals(true));
      final labels = labeledList.labels;
      for (var i = 0; i < list.length; i++) {
        expect(list[i], equals(labeledList[labels[i]!]));
      }
    });

    test('generate', () {
      final list = List<int>.generate(5, (index) => index);
      final labeledList = LabeledList<int>.generate(5, (index) => index,
          labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list.equals(labeledList), equals(true));
      final labels = labeledList.labels;
      for (var i = 0; i < list.length; i++) {
        expect(labeledList[i], equals(i));
        expect(list[i], equals(labeledList[labels[i]!]));
      }
    });

    test('unmodifiable', () {
      final list = List<int>.unmodifiable([0, 1, 2, 3, 4]);
      final labeledList = LabeledList<int>.unmodifiable([0, 1, 2, 3, 4],
          labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list.equals(labeledList), equals(true));
      final labels = labeledList.labels;
      for (var i = 0; i < list.length; i++) {
        expect(labeledList[i], equals(i));
        expect(list[i], equals(labeledList[labels[i]!]));
      }

      late Object error;
      try {
        labeledList.add(5);
      } catch (e) {
        error = e;
      }
      expect(error is UnsupportedError, equals(true));
    });
  });

  group('Labels', () {
    test('labels', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      labeledList.labels.add('f');
      expect(labels, equals(['a', 'b', 'c', 'd', 'e']));
      expect(labeledList.labels, equals(labels));
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]], equals(i));
      }
    });

    test('hasLabel', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var label in labels) {
        expect(labeledList.hasLabel(label), equals(true));
      }
      expect(labeledList.hasLabel('f'), equals(false));
    });

    test('hasLabelAt', () {
      final labels = ['a', null, 'c', null, 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList.hasLabelAt(i), equals(i.isEven));
      }
    });

    test('getLabel', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList.getLabel(i), equals(labels[i]));
      }
    });

    test('getLabelAt', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList.getLabelAt(i), equals(labels[i]));
      }
    });

    test('setLabel', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final newLabels = ['f', 'g', 'h', 'i', 'j'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labeledList.length; i++) {
        labeledList.setLabel(i, newLabels[i]);
      }
      expect(labeledList.labels, equals(newLabels));
    });

    test('setLabelAt', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final newLabels = ['f', 'g', 'h', 'i', 'j'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labeledList.length; i++) {
        labeledList.setLabelAt(i, newLabels[i]);
      }
      expect(labeledList.labels, equals(newLabels));
    });

    test('removeByLabel', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList.removeByLabel(labels[i]), equals(i));
      }
      expect(labeledList.isEmpty, equals(true));
    });

    test('removeLabelWhere', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList = LabeledList<int>.of([0, 1, 2, 3, 4], labels: labels);
      labeledList.removeLabelWhere((element) => element.isOdd);
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList.hasLabelAt(i), equals(i.isEven));
        if (i.isEven) {
          expect(labeledList[labels[i]], equals(i));
        }
      }
    });
  });

  group('Methods, Getters & Setters', () {
    test('castFrom', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList =
          LabeledList.castFrom<num, int>([0, 1, 2, 3, 4], labels: labels);
      expect(labeledList is List<int>, equals(true));
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]], equals(i));
      }
    });

    test('cast', () {
      final labels = ['a', 'b', 'c', 'd', 'e'];
      final labeledList =
          LabeledList<num>.of([0, 1, 2, 3, 4], labels: labels).cast<int>();
      expect(labeledList.every((element) => element is int), equals(true));
      for (var i = 0; i < labels.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]], equals(i));
      }
    });

    test('followedBy', () {
      final list = [0, 1, 2, 3, 4];
      var labeledListA =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final labeledListB = LabeledList<int>.of([5, 6, 7, 8, 9],
          labels: ['f', 'g', 'h', 'i', 'j']);
      labeledListA = labeledListA.followedBy(labeledListB, labeled: true)
          as LabeledList<int>;
      expect(labeledListA.length, equals(10));
      expect(labeledListA.labels.length, equals(10));
      final labels = labeledListA.labels;
      for (var i = 0; i < labeledListA.length; i++) {
        expect(labeledListA[i], equals(i));
        final label = labels[i]!;
        expect(labeledListA[label], equals(i));
        if (i >= 5) {
          expect(labeledListB[i - 5], equals(i));
          expect(labeledListB[label], equals(i));
        }
      }
    });

    test('map', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final mappedList = labeledList.map<String>(
          (element) => element.toString(),
          labeled: true) as LabeledList<String>;
      expect(list.map<String>((element) => element.toString()),
          equals(mappedList));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        final label = labels[i]!;
        expect(labeledList[i], equals(i));
        expect(labeledList[label], equals(i));
        expect(mappedList[i], equals(i.toString()));
        expect(mappedList[label], equals(i.toString()));
      }
    });

    test('where', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final oddList = labeledList.where((element) => element.isOdd,
          labeled: true) as LabeledList<int>;
      expect(list.where((element) => element.isOdd), equals(oddList));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        final label = labels[i]!;
        expect(labeledList[i], equals(i));
        expect(labeledList[label], equals(i));
        Object? error;
        try {
          final value = oddList[label];
          expect(value, equals(i));
        } catch (e) {
          error = e;
        }
        if (i.isEven) {
          expect(error is StateError, equals(true));
        } else {
          expect(error, equals(null));
        }
      }
    });

    test('whereType', () {
      final list = [0.0, 1, 2.0, 3, 4.0];
      final labeledList =
          LabeledList<num>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final intList =
          labeledList.whereType<int>(labeled: true) as LabeledList<int>;
      expect(list.whereType<int>(), equals(intList));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        final label = labels[i]!;
        expect(labeledList[i], equals(i));
        expect(labeledList[label], equals(i));
        Object? error;
        try {
          final value = intList[label];
          expect(value, equals(i));
        } catch (e) {
          error = e;
        }
        if (i.isEven) {
          expect(error is StateError, equals(true));
        } else {
          expect(error, equals(null));
        }
      }
    });

    group('add', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..add(5), equals(labeledList..add(5, label: 'f')));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.add(6);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('addAll', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(
            list..addAll([5, 6, 7, 8, 9]),
            equals(labeledList
              ..addAll([5, 6, 7, 8, 9], labels: ['f', 'g', 'h', 'i', 'j'])));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.addAll([10, 11, 12, 13, 14]);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('insert', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(
            list..insert(5, 5), equals(labeledList..insert(5, 5, label: 'f')));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.insert(0, 26, label: 'z');
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('insertAll', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(
            list..insertAll(5, [5, 6, 7, 8, 9]),
            equals(labeledList
              ..insertAll(5, [5, 6, 7, 8, 9],
                  labels: ['f', 'g', 'h', 'i', 'j'])));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.insertAll(0, [26, 25, 24], labels: ['z', 'y', 'x']);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('remove', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..remove(4), equals(labeledList..remove(4)));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.remove(0);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('removeAt', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..removeAt(4), equals(labeledList..removeAt(4)));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.removeAt(0);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('removeLast', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..removeLast(), equals(labeledList..removeLast()));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.removeLast();
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('removeRange', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..removeRange(3, 5), equals(labeledList..removeRange(3, 5)));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.removeRange(0, 2);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('removeWhere', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..removeWhere((element) => element > 2),
            equals(labeledList..removeWhere((element) => element > 2)));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.removeWhere((element) => element.isOdd);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    group('retainWhere', () {
      final list = [0, 1, 2, 3, 4];

      test('growable', () {
        final labeledList =
            LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
        expect(list..retainWhere((element) => element < 3),
            equals(labeledList..retainWhere((element) => element < 3)));
        final labels = labeledList.labels;
        for (var i = 0; i < labeledList.length; i++) {
          expect(labeledList[i], equals(i));
          expect(labeledList[labels[i]!], equals(i));
        }
      });

      test('fixed-length', () {
        Object? error;
        try {
          final labeledList = LabeledList<int>.of(list, growable: false);
          labeledList.retainWhere((element) => element.isOdd);
        } catch (e) {
          error = e;
        }
        expect(error is UnsupportedError, equals(true));
      });
    });

    test('sublist', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final sublist = labeledList.sublist(2, 4);
      expect(list.sublist(2, 4), equals(sublist));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]!], equals(i));
        if (i >= 2 && i < 4) {
          expect(sublist[i - 2], equals(i));
          expect(sublist[labels[i]!], equals(i));
        }
      }
    });

    test('take', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final taken = labeledList.take(3, labeled: true) as LabeledList<int>;
      expect(list.take(3), equals(taken));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]!], equals(i));
        if (i < 3) {
          expect(taken[i], equals(i));
          expect(taken[labels[i]!], equals(i));
        }
      }
    });

    test('takeWhile', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final taken = labeledList.takeWhile((element) => element < 3,
          labeled: true) as LabeledList<int>;
      expect(list.takeWhile((element) => element < 3), equals(taken));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]!], equals(i));
        if (i < 3) {
          expect(taken[i], equals(i));
          expect(taken[labels[i]!], equals(i));
        }
      }
    });

    test('skip', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final taken = labeledList.skip(3, labeled: true) as LabeledList<int>;
      expect(list.skip(3), equals(taken));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]!], equals(i));
        if (i > 3) {
          expect(taken[i - 3], equals(i));
          expect(taken[labels[i]!], equals(i));
        }
      }
    });

    test('skipWhile', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final taken = labeledList.skipWhile((element) => element < 3,
          labeled: true) as LabeledList<int>;
      expect(list.skipWhile((element) => element < 3), equals(taken));
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(labeledList[i], equals(i));
        expect(labeledList[labels[i]!], equals(i));
        if (i > 3) {
          expect(taken[i - 3], equals(i));
          expect(taken[labels[i]!], equals(i));
        }
      }
    });

    test('toMap', () {
      final list = [0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      final map = labeledList.toMap();
      final labels = labeledList.labels;
      for (var i = 0; i < labeledList.length; i++) {
        expect(map.keys.elementAt(i), equals(labels[i]));
        expect(map.values.elementAt(i), equals(i));
      }
    });

    test('length setter', () {
      final list = <int?>[0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int?>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      expect(list..length = 6, equals(labeledList..length = 6));
    });

    test('[]', () {
      final list = <int>[0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      for (var i = 0; i < labeledList.length; i++) {
        expect(list[i], equals(labeledList[i]));
      }
    });

    test('[]=', () {
      final list = <int>[0, 1, 2, 3, 4];
      final labeledList =
          LabeledList<int>.of(list, labels: ['a', 'b', 'c', 'd', 'e']);
      for (var i = 0; i < labeledList.length; i++) {
        labeledList[i] = list[list.length - 1 - i];
      }
      expect(labeledList, equals(list.reversed));
    });
  });
}
