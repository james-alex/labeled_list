import 'package:unique_list/unique_list.dart';
import 'package:list_utilities/base_list.dart';

/// {@template labeled_list.LabeledList}
///
/// An implementation of list that accepts an optional
/// label with every element added to the list.
///
/// {@endtemplate}
class LabeledList<E> extends BaseList<E> {
  /// {@macro labeled_list.LabeledList}
  LabeledList()
      : _labels = UniqueList<String?>.strict(),
        super(<E>[], growable: true);

  /// Constructs a new empty [LabeledList].
  ///
  /// {@template labeled_list.LabeledList.growable}
  ///
  /// If [growable] is `false`, the returned list will be a fixed-length
  /// list, otherwise the list is growable and identical to the default
  /// constructor.
  ///
  /// {@endtemplate}
  LabeledList.empty({bool growable = false})
      : _labels = UniqueList<String?>.empty(growable: growable, strict: true),
        super(List<E>.empty(growable: growable), growable: growable);

  /// Constructs a new [LabeledList] from [elements].
  ///
  /// If [elements] is a [List], the returned [LabeledList] will wrap it;
  /// otherwise, a new [List] will be constructed from [elements].
  ///
  /// __Note:__ Use the [LabeledList.of] constructor to construct a
  /// new [LabeledList] containing the elements of a [List], without
  /// referencing the original list.
  ///
  /// {@template labeled_list.LabeledList.labels}
  ///
  /// If [labels] are provided, there must be a label or a `null` value for
  /// every element in in the list. `labels.length` must equal the length of
  /// the list.
  ///
  /// {@endtemplate}
  ///
  /// {@macro labeled_list.LabeledList.growable}
  LabeledList.from(
    Iterable<E> elements, {
    Iterable<String?>? labels,
    bool growable = true,
  })  : assert(labels == null || labels.length == elements.length),
        _labels = _buildLabels(labels, elements.length, growable: growable),
        super(
          elements is List<E>
              ? elements
              : List<E>.from(elements, growable: growable),
          growable: growable,
        );

  /// Constructs a new [LabeledList] containing all [elements].
  ///
  /// __Note:__ Use the [LabeledList.from] constructor to construct
  /// a new [LabeledList] that wraps and references [elements].
  ///
  /// {@macro labeled_list.LabeledList.labels}
  ///
  /// {@macro labeled_list.LabeledList.growable}
  LabeledList.of(
    Iterable<E> elements, {
    Iterable<String?>? labels,
    bool growable = true,
  })  : assert(labels == null || labels.length == elements.length),
        _labels = _buildLabels(labels, elements.length, growable: growable),
        super(List<E>.from(elements, growable: growable), growable: growable);

  /// Constructs a new [LabeledList] of the given [length] with
  /// [fill] for every element.
  ///
  /// {@macro labeled_list.LabeledList.labels}
  ///
  /// {@macro labeled_list.LabeledList.growable}
  LabeledList.filled(
    int length,
    E fill, {
    Iterable<String?>? labels,
    bool growable = false,
  })  : assert(length >= 0),
        assert(labels == null || labels.length == length),
        _labels = _buildLabels(labels, length, growable: growable),
        super(List<E>.filled(length, fill, growable: growable),
            growable: growable);

  /// Generates a [LabeledList] of values, as returned by [generator].
  ///
  /// {@macro labeled_list.LabeledList.labels}
  ///
  /// {@macro labeled_list.LabeledList.growable}
  LabeledList.generate(
    int length,
    Generator<E> generator, {
    Iterable<String?>? labels,
    bool growable = true,
  })  : assert(length >= 0),
        assert(labels == null || labels.length == length),
        _labels = _buildLabels(labels, length, growable: growable),
        super(List<E>.generate(length, generator, growable: growable),
            growable: growable);

  /// Constructs an unmodifiable [LabeledList] of [elements].
  ///
  /// {@macro labeled_list.LabeledList.labels}
  LabeledList.unmodifiable(
    Iterable<E> elements, {
    Iterable<String?>? labels,
  })  : assert(labels == null || labels.length == elements.length),
        _labels = _buildLabels(labels, elements.length, growable: false),
        super(List<E>.unmodifiable(elements), growable: false);

  /// The list of labels associated with [elements].
  ///
  /// Every element in [elements] has label at the same index in [_labels],
  /// or a `null` value, if the element wasn't labeled.
  final UniqueList<String?> _labels;

  /// Returns a list containing all of the labels mapped to this list.
  ///
  /// __Note:__ This getter constructs a new list from the underlying list
  /// of labels. Any changes made to it will not affect the underlying list.
  List<String?> get labels => _labels.toList(growable: growable);

  /// Returns `true` if this list contains an element labeled as [label].
  bool hasLabel(String label) => _labels.contains(label);

  /// Returns `true` if the element at [index] has a label.
  bool hasLabelAt(int index) {
    assert(index >= 0 && index < length);
    return _labels[index] != null;
  }

  /// Returns the index of the element associated with [label].
  int indexOfLabel(String label) {
    assert(hasLabel(label),
        'This list doesn\'t contain an element assocaited with [label].');
    return _labels.indexOf(label);
  }

  /// Returns the label associated with [element].
  String? getLabel(E element) {
    assert(elements.contains(element), 'This list doesn\'t contain [element].');
    return _labels[elements.indexOf(element)];
  }

  /// Returns the label associated with the element at [index].
  String? getLabelAt(int index) {
    assert(index >= 0 && index < length);
    return _labels[index];
  }

  /// Sets the label associated with [element].
  void setLabel(E element, String? label) {
    assert(elements.contains(element), 'This list doesn\'t contain [element].');
    _labels[elements.indexOf(element)] = label;
  }

  /// Sets the label associated with the element at [index].
  void setLabelAt(int index, String? label) {
    assert(index >= 0 && index < length);
    _labels[index] = label;
  }

  /// Sets the label of every element that pass the [test] to `null`.
  void removeLabelWhere(Test<E> test) {
    for (var i = 0; i < length; i++) {
      if (test(elements[i])) {
        _labels[i] = null;
      }
    }
  }

  /// Removes the element associated with [label] from the list.
  E removeByLabel(String label) {
    assert(hasLabel(label),
        'This list doesn\'t contain an element assocaited with [label].');
    final index = _labels.indexOf(label);
    _labels.removeAt(index);
    return elements.removeAt(index);
  }

  /// Adapts [source] to be a `LabeledList<T>`.
  ///
  /// Any time the list would produce an element that is not a [T],
  /// the element access will throw.
  ///
  /// Any time a [T] value is attempted stored into the adapted list,
  /// the store will throw unless the value is also an instance of [S].
  ///
  /// If all accessed elements of [source] are actually instances of [T],
  /// and if all elements stored into the returned list are actually instance
  /// of [S], then the returned list can be used as a `LabeledList<T>`.
  static LabeledList<T> castFrom<S, T>(
    List<S> source, {
    Iterable<String?>? labels,
    bool growable = true,
  }) {
    assert(labels == null || labels.length == source.length);
    final elements = List.castFrom<S, T>(source);
    return LabeledList<T>.from(
      elements,
      labels: _buildLabels(labels, source.length, growable: growable),
      growable: growable,
    );
  }

  @override
  LabeledList<R> cast<R>({bool? growable}) =>
      LabeledList<R>.of(elements.cast<R>(),
          labels: _labels, growable: growable ?? this.growable);

  @override
  Iterable<E> followedBy(
    Iterable<E> other, {
    bool labeled = false,
    bool? growable,
  }) {
    final elements = this.elements.followedBy(other);
    if (!labeled) return elements;
    var labels = _labels;
    if (other is LabeledList) labels += (other as LabeledList)._labels;
    growable ??= this.growable;
    return LabeledList<E>.of(elements, labels: labels, growable: growable);
  }

  @override
  Iterable<T> map<T>(
    Mapper<T, E> f, {
    bool labeled = false,
    bool? growable,
  }) {
    final elements = this.elements.map<T>(f);
    if (!labeled) return elements;
    growable ??= this.growable;
    return LabeledList<T>.of(elements, labels: _labels, growable: growable);
  }

  @override
  Iterable<E> where(Test<E> test, {bool labeled = false, bool? growable}) {
    if (!labeled) return super.where(test);
    final elements = <E>[];
    final labels = <String?>[];
    for (var i = 0; i < length; i++) {
      final element = this.elements[i];
      if (test(element)) {
        elements.add(element);
        labels.add(_labels[i]);
      }
    }
    growable ??= this.growable;
    return LabeledList<E>.of(elements, labels: labels, growable: growable);
  }

  @override
  Iterable<T> whereType<T>({bool labeled = false, bool? growable}) {
    if (!labeled) return super.whereType<T>();
    final elements = <T>[];
    final labels = <String?>[];
    for (var i = 0; i < length; i++) {
      final element = this.elements[i];
      if (element is T) {
        elements.add(element);
        labels.add(_labels[i]);
      }
    }
    growable ??= this.growable;
    return LabeledList<T>.of(elements, labels: labels, growable: growable);
  }

  @override
  void add(E value, {String? label}) {
    if (!growable) {
      throw UnsupportedError('Cannot add values to a fixed-length list.');
    }
    _labels.add(label);
    elements.add(value);
  }

  @override
  void addAll(Iterable<E> iterable, {Iterable<String?>? labels}) {
    if (!growable) {
      throw UnsupportedError('Cannot add values to a fixed-length list.');
    }
    assert(labels == null || labels.length == iterable.length);
    labels ??= List<String?>.filled(iterable.length, null);
    _labels.addAll(labels);
    elements.addAll(iterable);
  }

  @override
  void insert(int index, E element, {String? label}) {
    if (!growable) {
      throw UnsupportedError('Cannot add values to a fixed-length list.');
    }
    _labels.insert(index, label);
    elements.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable, {Iterable<String?>? labels}) {
    if (!growable) {
      throw UnsupportedError('Cannot add values to a fixed-length list.');
    }
    assert(labels == null || labels.length == iterable.length);
    labels ??= List<String?>.filled(iterable.length, null);
    _labels.insertAll(index, labels);
    elements.insertAll(index, iterable);
  }

  @override
  bool remove(Object? value) {
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    if (value is! E) return false;
    final index = elements.indexOf(value);
    if (index == -1) return false;
    _labels.removeAt(index);
    elements.removeAt(index);
    return true;
  }

  @override
  E removeAt(int index) {
    assert(index >= 0 && index < length);
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    _labels.removeAt(index);
    return elements.removeAt(index);
  }

  @override
  E removeLast() {
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    _labels.removeLast();
    return elements.removeLast();
  }

  @override
  void removeRange(int start, int end) {
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    _labels.removeRange(start, end);
    elements.removeRange(start, end);
  }

  @override
  void removeWhere(Test<E> test) {
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    var removed = 0;
    for (var i = 0; i < length + removed; i++) {
      if (test(elements[i - removed])) {
        elements.removeAt(i - removed);
        _labels.removeAt(i - removed);
        removed++;
      }
    }
  }

  @override
  void retainWhere(Test<E> test) {
    if (!growable) {
      throw UnsupportedError('Cannot remove values from a fixed-length list.');
    }
    var removed = 0;
    for (var i = 0; i < length + removed; i++) {
      if (!test(elements[i - removed])) {
        elements.removeAt(i - removed);
        _labels.removeAt(i - removed);
        removed++;
      }
    }
  }

  @override
  LabeledList<E> sublist(int start, [int? end]) {
    assert(start >= 0 && start <= (end ?? length));
    assert(end == null || (end >= start && end <= length));
    return LabeledList<E>.from(
      elements.sublist(start, end),
      labels: _labels.sublist(start, end),
      growable: growable,
    );
  }

  @override
  Iterable<E> take(int count, {bool labeled = false, bool? growable}) {
    assert(count > 0);
    if (!labeled) return super.take(count);
    growable ??= this.growable;
    return LabeledList.of(elements.take(count),
        labels: _labels.take(count), growable: growable);
  }

  @override
  Iterable<E> takeWhile(Test<E> test, {bool labeled = false, bool? growable}) {
    if (!labeled) return super.takeWhile(test);
    final elements = <E>[];
    final labels = <String?>[];
    for (var i = 0; i < length; i++) {
      final element = this.elements[i];
      if (!test(element)) break;
      elements.add(element);
      labels.add(_labels[i]);
    }
    growable ??= this.growable;
    return LabeledList<E>.of(elements, labels: labels, growable: growable);
  }

  @override
  Iterable<E> skip(int count, {bool labeled = false, bool? growable}) {
    assert(count > 0);
    if (!labeled) return super.skip(count);
    growable ??= this.growable;
    return LabeledList.of(elements.skip(count),
        labels: _labels.skip(count), growable: growable);
  }

  @override
  Iterable<E> skipWhile(Test<E> test, {bool labeled = false, bool? growable}) {
    if (!labeled) return super.skipWhile(test);
    final elements = <E>[];
    final labels = <String?>[];
    var skipping = true;
    for (var i = 0; i < length; i++) {
      final element = this.elements[i];
      if (skipping && !test(element)) skipping = false;
      if (!skipping) {
        elements.add(element);
        labels.add(_labels[i]);
      }
    }
    growable ??= this.growable;
    return LabeledList.of(elements, labels: labels, growable: growable);
  }

  /// Returns the list as a map, with the labels as keys,
  /// and the elements as values.
  ///
  /// Any elements that don't have a label will have their
  /// index as the key.
  Map<String, E> toMap() {
    final map = <String, E>{};
    for (var i = 0; i < length; i++) {
      map.addAll({_labels[i] ?? i.toString(): elements[i]});
    }
    return map;
  }

  @override
  set length(int newLength) {
    if (!growable) {
      throw UnsupportedError(
          'Cannot add or remove values from a fixed-length list.');
    }
    _labels.length = newLength;
    elements.length = newLength;
  }

  /// Returns the value associated with [identifier].
  ///
  /// {@template labeled_list.LabeledList.identifier}
  ///
  /// The [identifier] must be an index ([int]) or a label ([String]).
  ///
  /// A [RangeError] will be thrown if the [identifier] isn't a valid
  /// index, or a [StateError] will be thrown if isn't a valid label.
  ///
  /// {@endtemplate}
  @override
  E operator [](Object identifier) {
    assert(identifier is int || identifier is String);

    if (identifier is String) {
      if (!_labels.contains(identifier)) {
        throw StateError('The provided [identifier] isn\'t '
            'associated with any element in this list.');
      }
      return elements[_labels.indexOf(identifier)];
    }

    return elements[identifier as int];
  }

  /// Sets the value assocaited with [identifier] to [value].
  ///
  /// {@macro labeled_list.LabeledList.identifier}
  @override
  void operator []=(Object identifier, E value) {
    assert(identifier is int || identifier is String);

    if (identifier is String) {
      if (!_labels.contains(identifier)) {
        throw StateError('The provided [identifier] isn\'t '
            'associated with any element in this list.');
      }
      elements[_labels.indexOf(identifier)] = value;
      return;
    }

    elements[identifier as int] = value;
  }

  /// Returns a [UniqueList] filled with `null` values if [labels]
  /// is `null`, otherwise constructs a [UniqueList] from [labels].
  static UniqueList<String?> _buildLabels(
    Iterable<String?>? labels,
    int length, {
    required bool growable,
  }) {
    if (labels == null) {
      return UniqueList.filled(length, growable: growable, strict: true);
    }
    return UniqueList.from(labels, growable: growable, strict: true);
  }
}
