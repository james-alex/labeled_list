# labeled_list

An implementation of list that accepts an optional label with
every element added to the list.

# Usage

```dart
import 'package:labeled_list/labeled_list.dart';
```

[LabeledList] behaves like any other [List], except its values can
be set and retrieved by an optional label assigned to each element.

```dart
final labledList =
    LabeledList<String>.of(['zero', 'one', 'two'], labels: ['a', 'b', 'c']);

print(labeledList[0]); // zero
print(labeledList['a']); // zero
```

Labels can be assigned to elements when a [LabeledList] is constructed,
when any new element(s) are added to the list, or with the [setLabel] and
[setLabelAt] methods.

__Note:__ The underlying list of labels is stored in a strict
[UniqueList](https://pub.dev/packages/unique_list), as each label
must be `null` or unique from every other label.

## Constructors

[LabeledList] has the same constructors as [List], with one key difference
in the behavior of the `of` and `from` constructors.

Like the [List.of] constructor, the [LabeledList.of] constructor constructs
a new list containing the elements of a provided [Iterable], and should be used
to create a new list that doesn't reference the provided [Iterable].

```dart
final list = <int>[0, 1, 2];
final labeledList = LabeledList<int>.of(list, labels: ['a', 'b', 'c']);

list.add(4);

print(list); // [0, 1, 2, 3, 4]
print(labeledList); // [0, 1, 2, 3]
```

The [LabeledList.from] constructor behaves the same as the [LabeledList.of]
constructor if provided an [Iterable] that isn't a [List]. However, if a [List]
is provided, the constructed [LabeledList] will wrap the provided [List]; as such,
any changes made to the provided list will also affect the [LabeledList], as it
references the provided [List].

```dart
final list = <int>[0, 1, 2];
final labeledList = LabeledList<int>.from(list, labels: ['a', 'b', 'c']);

list.add(4);

print(list); // [0, 1, 2, 3, 4]
print(labeledList); // [0, 1, 2, 3, 4]
```

__Note:__ The provided [labels] must contain the same number of elements as
the constructed list. `null` values should be provided for elements that aren't
labeled.

```dart
// Only the element at `1` is labeled.
final labeledList = LabeledList<int>.from([0, 1, 2], labels: [null, 'b', null]);
```

## Adding Elements

The [add] and [insert] methods take an optional named parameter, [label], to
assign a label to the newly added element.

```dart
final labeledList = LabeledList<int>.from([0, 1, 2], labels: ['a', 'b', 'c']);

labeledList.add(3, label: 'd');
print(labeledList['d']); // 3

labeledList.insert(0, 4, label: 'e');
print(labeledList['e']); // 4
```

The [addAll] and [insertAll] methods take an optional named parameter, [labels],
to assign labels to the newly added elements.

```dart
final labeledList = LabeledList<int>.from([0, 1, 2], labels: ['a', 'b', 'c']);
labeledList.addAll([3, 4, 5], labels: ['d', 'e', 'f']);
labeledList.insertAll(0, [6, 7, 8], labels: ['g', 'h', 'i']);
```

## Retrieving, Setting & Removing Labels

[LabeledList] has a handful of methods for interfacing with the labels.

### labels

The [labels] getter returns a list of every label associated with the
elements in the list. The returned list will contain one value for every
element in the list. Any unlabeled elements will have a label of `null`.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', 'c']);
print(list.labels); // ['a', 'b', 'c']
```

__Note:__ The returned list is a copy of the underlying list of labels,
as such any changes made to it will not affect the labels in the list.

### hasLabel & hasLabelAt

The [hasLabel] and [hasLabelAt] methods return `true` if the list contains
an element associated with the provided label, or if the element at the
provided index has a label, respectively.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', null]);

print(list.hasLabel('a')); // true
print(list.hasLabel('c')); // false

print(list.hasLabelAt(0)); // true
print(list.hasLabelAt(2)); // false
```

### indexOfLabel

The [indexOfLabel] method returns the index of the element associated with
the provided label.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', 'c']);
print(list.indexOfLabel('b')); // 1
```

### getLabel & getLabelAt

The [getLabel] and [getLabelAt] methods return the label associated with
the provided element, or associated with the element at the provided index,
respectively.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', 'c']);
print(list.getLabel(0)); // a
print(list.getLabelAt(0)); // b
```

### setLabel & setLabelAt

The [setLabel] and [setLabelAt] methods update the label associated
with the provided elemement, or associated with the element at the proivided
index, respectively.

```dart
final list = LabeledList<int>.of([5, 6, 7]);

list.setLabel(5, 'a');
print(list['a']); // 5

list.setLabelAt(1, 'b');
print(list['b']); // 6
```

### removeLabelWhere

The [removeLabelWhere] method removes the label associated with every element
that passes the provided test. __Note:__ By removing a label, its value is
set to `null` in the underlying list of labels.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', 'c']);
list.removeLabelWhere((element) => element.isEven);
print(list.labels); // [null, 'b', null]
```

### removeByLabel

The [removeByLabel] method removes the element associated with the provided
label from the list.

```dart
final list = LabeledList<int>.of([0, 1, 2], labels: ['a', 'b', 'c']);
list.removeByLabel('b');
print(list); // [0, 1]
```
