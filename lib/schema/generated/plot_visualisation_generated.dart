// automatically generated by the FlatBuffers compiler, do not modify
// ignore_for_file: unused_import, unused_field, unused_element, unused_local_variable

library visualisation;

import 'dart:typed_data' show Uint8List;
import 'package:flat_buffers/flat_buffers.dart' as fb;


class Plot {
  Plot._(this._bc, this._bcOffset);
  factory Plot(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<Plot> reader = _PlotReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  String? get key => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 4);
  String? get title => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 6);
  String? get xlabel => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 8);
  String? get ylabel => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 10);
  List<double>? get x => const fb.ListReader<double>(fb.Float32Reader()).vTableGetNullable(_bc, _bcOffset, 12);
  List<double>? get y => const fb.ListReader<double>(fb.Float32Reader()).vTableGetNullable(_bc, _bcOffset, 14);

  @override
  String toString() {
    return 'Plot{key: ${key}, title: ${title}, xlabel: ${xlabel}, ylabel: ${ylabel}, x: ${x}, y: ${y}}';
  }

  PlotT unpack() => PlotT(
      key: key,
      title: title,
      xlabel: xlabel,
      ylabel: ylabel,
      x: const fb.ListReader<double>(fb.Float32Reader(), lazy: false).vTableGetNullable(_bc, _bcOffset, 12),
      y: const fb.ListReader<double>(fb.Float32Reader(), lazy: false).vTableGetNullable(_bc, _bcOffset, 14));

  static int pack(fb.Builder fbBuilder, PlotT? object) {
    if (object == null) return 0;
    return object.pack(fbBuilder);
  }
}

class PlotT implements fb.Packable {
  String? key;
  String? title;
  String? xlabel;
  String? ylabel;
  List<double>? x;
  List<double>? y;

  PlotT({
    this.key,
    this.title,
    this.xlabel,
    this.ylabel,
    this.x,
    this.y});

  @override
  int pack(fb.Builder fbBuilder) {
    final int? keyOffset = key == null ? null
        : fbBuilder.writeString(key!);
    final int? titleOffset = title == null ? null
        : fbBuilder.writeString(title!);
    final int? xlabelOffset = xlabel == null ? null
        : fbBuilder.writeString(xlabel!);
    final int? ylabelOffset = ylabel == null ? null
        : fbBuilder.writeString(ylabel!);
    final int? xOffset = x == null ? null
        : fbBuilder.writeListFloat32(x!);
    final int? yOffset = y == null ? null
        : fbBuilder.writeListFloat32(y!);
    fbBuilder.startTable(6);
    fbBuilder.addOffset(0, keyOffset);
    fbBuilder.addOffset(1, titleOffset);
    fbBuilder.addOffset(2, xlabelOffset);
    fbBuilder.addOffset(3, ylabelOffset);
    fbBuilder.addOffset(4, xOffset);
    fbBuilder.addOffset(5, yOffset);
    return fbBuilder.endTable();
  }

  @override
  String toString() {
    return 'PlotT{key: ${key}, title: ${title}, xlabel: ${xlabel}, ylabel: ${ylabel}, x: ${x}, y: ${y}}';
  }
}

class _PlotReader extends fb.TableReader<Plot> {
  const _PlotReader();

  @override
  Plot createObject(fb.BufferContext bc, int offset) =>
      Plot._(bc, offset);
}

class PlotBuilder {
  PlotBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(6);
  }

  int addKeyOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }
  int addTitleOffset(int? offset) {
    fbBuilder.addOffset(1, offset);
    return fbBuilder.offset;
  }
  int addXlabelOffset(int? offset) {
    fbBuilder.addOffset(2, offset);
    return fbBuilder.offset;
  }
  int addYlabelOffset(int? offset) {
    fbBuilder.addOffset(3, offset);
    return fbBuilder.offset;
  }
  int addXOffset(int? offset) {
    fbBuilder.addOffset(4, offset);
    return fbBuilder.offset;
  }
  int addYOffset(int? offset) {
    fbBuilder.addOffset(5, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class PlotObjectBuilder extends fb.ObjectBuilder {
  final String? _key;
  final String? _title;
  final String? _xlabel;
  final String? _ylabel;
  final List<double>? _x;
  final List<double>? _y;

  PlotObjectBuilder({
    String? key,
    String? title,
    String? xlabel,
    String? ylabel,
    List<double>? x,
    List<double>? y,
  })
      : _key = key,
        _title = title,
        _xlabel = xlabel,
        _ylabel = ylabel,
        _x = x,
        _y = y;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? keyOffset = _key == null ? null
        : fbBuilder.writeString(_key!);
    final int? titleOffset = _title == null ? null
        : fbBuilder.writeString(_title!);
    final int? xlabelOffset = _xlabel == null ? null
        : fbBuilder.writeString(_xlabel!);
    final int? ylabelOffset = _ylabel == null ? null
        : fbBuilder.writeString(_ylabel!);
    final int? xOffset = _x == null ? null
        : fbBuilder.writeListFloat32(_x!);
    final int? yOffset = _y == null ? null
        : fbBuilder.writeListFloat32(_y!);
    fbBuilder.startTable(6);
    fbBuilder.addOffset(0, keyOffset);
    fbBuilder.addOffset(1, titleOffset);
    fbBuilder.addOffset(2, xlabelOffset);
    fbBuilder.addOffset(3, ylabelOffset);
    fbBuilder.addOffset(4, xOffset);
    fbBuilder.addOffset(5, yOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
class PlotGroup {
  PlotGroup._(this._bc, this._bcOffset);
  factory PlotGroup(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<PlotGroup> reader = _PlotGroupReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  String? get name => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 4);
  String? get type => const fb.StringReader().vTableGetNullable(_bc, _bcOffset, 6);
  List<Plot>? get plots => const fb.ListReader<Plot>(Plot.reader).vTableGetNullable(_bc, _bcOffset, 8);

  @override
  String toString() {
    return 'PlotGroup{name: ${name}, type: ${type}, plots: ${plots}}';
  }

  PlotGroupT unpack() => PlotGroupT(
      name: name,
      type: type,
      plots: plots?.map((e) => e.unpack()).toList());

  static int pack(fb.Builder fbBuilder, PlotGroupT? object) {
    if (object == null) return 0;
    return object.pack(fbBuilder);
  }
}

class PlotGroupT implements fb.Packable {
  String? name;
  String? type;
  List<PlotT>? plots;

  PlotGroupT({
    this.name,
    this.type,
    this.plots});

  @override
  int pack(fb.Builder fbBuilder) {
    final int? nameOffset = name == null ? null
        : fbBuilder.writeString(name!);
    final int? typeOffset = type == null ? null
        : fbBuilder.writeString(type!);
    final int? plotsOffset = plots == null ? null
        : fbBuilder.writeList(plots!.map((b) => b.pack(fbBuilder)).toList());
    fbBuilder.startTable(3);
    fbBuilder.addOffset(0, nameOffset);
    fbBuilder.addOffset(1, typeOffset);
    fbBuilder.addOffset(2, plotsOffset);
    return fbBuilder.endTable();
  }

  @override
  String toString() {
    return 'PlotGroupT{name: ${name}, type: ${type}, plots: ${plots}}';
  }
}

class _PlotGroupReader extends fb.TableReader<PlotGroup> {
  const _PlotGroupReader();

  @override
  PlotGroup createObject(fb.BufferContext bc, int offset) =>
      PlotGroup._(bc, offset);
}

class PlotGroupBuilder {
  PlotGroupBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(3);
  }

  int addNameOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }
  int addTypeOffset(int? offset) {
    fbBuilder.addOffset(1, offset);
    return fbBuilder.offset;
  }
  int addPlotsOffset(int? offset) {
    fbBuilder.addOffset(2, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class PlotGroupObjectBuilder extends fb.ObjectBuilder {
  final String? _name;
  final String? _type;
  final List<PlotObjectBuilder>? _plots;

  PlotGroupObjectBuilder({
    String? name,
    String? type,
    List<PlotObjectBuilder>? plots,
  })
      : _name = name,
        _type = type,
        _plots = plots;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? nameOffset = _name == null ? null
        : fbBuilder.writeString(_name!);
    final int? typeOffset = _type == null ? null
        : fbBuilder.writeString(_type!);
    final int? plotsOffset = _plots == null ? null
        : fbBuilder.writeList(_plots!.map((b) => b.getOrCreateOffset(fbBuilder)).toList());
    fbBuilder.startTable(3);
    fbBuilder.addOffset(0, nameOffset);
    fbBuilder.addOffset(1, typeOffset);
    fbBuilder.addOffset(2, plotsOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
class PlotBundle {
  PlotBundle._(this._bc, this._bcOffset);
  factory PlotBundle(List<int> bytes) {
    final rootRef = fb.BufferContext.fromBytes(bytes);
    return reader.read(rootRef, 0);
  }

  static const fb.Reader<PlotBundle> reader = _PlotBundleReader();

  final fb.BufferContext _bc;
  final int _bcOffset;

  List<PlotGroup>? get plotGroups => const fb.ListReader<PlotGroup>(PlotGroup.reader).vTableGetNullable(_bc, _bcOffset, 4);

  @override
  String toString() {
    return 'PlotBundle{plotGroups: ${plotGroups}}';
  }

  PlotBundleT unpack() => PlotBundleT(
      plotGroups: plotGroups?.map((e) => e.unpack()).toList());

  static int pack(fb.Builder fbBuilder, PlotBundleT? object) {
    if (object == null) return 0;
    return object.pack(fbBuilder);
  }
}

class PlotBundleT implements fb.Packable {
  List<PlotGroupT>? plotGroups;

  PlotBundleT({
    this.plotGroups});

  @override
  int pack(fb.Builder fbBuilder) {
    final int? plotGroupsOffset = plotGroups == null ? null
        : fbBuilder.writeList(plotGroups!.map((b) => b.pack(fbBuilder)).toList());
    fbBuilder.startTable(1);
    fbBuilder.addOffset(0, plotGroupsOffset);
    return fbBuilder.endTable();
  }

  @override
  String toString() {
    return 'PlotBundleT{plotGroups: ${plotGroups}}';
  }
}

class _PlotBundleReader extends fb.TableReader<PlotBundle> {
  const _PlotBundleReader();

  @override
  PlotBundle createObject(fb.BufferContext bc, int offset) =>
      PlotBundle._(bc, offset);
}

class PlotBundleBuilder {
  PlotBundleBuilder(this.fbBuilder);

  final fb.Builder fbBuilder;

  void begin() {
    fbBuilder.startTable(1);
  }

  int addPlotGroupsOffset(int? offset) {
    fbBuilder.addOffset(0, offset);
    return fbBuilder.offset;
  }

  int finish() {
    return fbBuilder.endTable();
  }
}

class PlotBundleObjectBuilder extends fb.ObjectBuilder {
  final List<PlotGroupObjectBuilder>? _plotGroups;

  PlotBundleObjectBuilder({
    List<PlotGroupObjectBuilder>? plotGroups,
  })
      : _plotGroups = plotGroups;

  /// Finish building, and store into the [fbBuilder].
  @override
  int finish(fb.Builder fbBuilder) {
    final int? plotGroupsOffset = _plotGroups == null ? null
        : fbBuilder.writeList(_plotGroups!.map((b) => b.getOrCreateOffset(fbBuilder)).toList());
    fbBuilder.startTable(1);
    fbBuilder.addOffset(0, plotGroupsOffset);
    return fbBuilder.endTable();
  }

  /// Convenience method to serialize to byte list.
  @override
  Uint8List toBytes([String? fileIdentifier]) {
    final fbBuilder = fb.Builder(deduplicateTables: false);
    fbBuilder.finish(finish(fbBuilder), fileIdentifier);
    return fbBuilder.buffer;
  }
}
