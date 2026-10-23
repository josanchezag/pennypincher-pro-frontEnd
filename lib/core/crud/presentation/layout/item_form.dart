import 'package:flutter/widgets.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// The form that creates an item of type [T] or edits it, producing drafts
/// of type [D]. The generic form sheet of `core/crud` takes its fields
/// from it.
abstract class ItemForm<T extends CrudItem, D> {
  const ItemForm();

  /// Controls of the form, filled with [initial] when it is being edited.
  FormGroup formGroup(T? initial);

  /// Fields of the form, top to bottom.
  List<Widget> formFields();

  /// Draft read from a valid [form].
  D draftOf(FormGroup form);
}
