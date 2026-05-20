import 'package:ai_helpdesk/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomerColumnOption {
  final String id;
  final String label;
  final bool isVisible;
  final bool isCustom;

  const CustomerColumnOption({
    required this.id,
    required this.label,
    required this.isVisible,
    required this.isCustom,
  });
}

class CustomerCustomFieldOption {
  final String id;
  final String name;
  final String type;

  const CustomerCustomFieldOption({
    required this.id,
    required this.name,
    required this.type,
  });
}

class CustomerColumnsFieldsPopover extends StatefulWidget {
  final List<CustomerColumnOption> columns;
  final List<CustomerCustomFieldOption> customFields;
  final ValueChanged<String> onToggleColumn;
  final void Function(String name, String type) onAddCustomField;
  final void Function(String id, String name) onRenameCustomField;
  final ValueChanged<String> onDeleteCustomField;

  const CustomerColumnsFieldsPopover({
    required this.columns,
    required this.customFields,
    required this.onToggleColumn,
    required this.onAddCustomField,
    required this.onRenameCustomField,
    required this.onDeleteCustomField,
    super.key,
  });

  @override
  State<CustomerColumnsFieldsPopover> createState() =>
      _CustomerColumnsFieldsPopoverState();
}

class _CustomerColumnsFieldsPopoverState
    extends State<CustomerColumnsFieldsPopover>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _newFieldController = TextEditingController();
  final TextEditingController _editFieldController = TextEditingController();

  String _selectedType = 'text';
  String? _editingFieldId;

  static const List<String> _fieldTypes = <String>['text', 'number', 'date'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _newFieldController.dispose();
    _editFieldController.dispose();
    super.dispose();
  }

  void _submitNewField() {
    final name = _newFieldController.text.trim();
    if (name.isEmpty) return;
    widget.onAddCustomField(name, _selectedType);
    _newFieldController.clear();
    setState(() => _selectedType = 'text');
  }

  void _startEditing(CustomerCustomFieldOption field) {
    setState(() {
      _editingFieldId = field.id;
      _editFieldController.text = field.name;
    });
  }

  void _submitEdit(CustomerCustomFieldOption field) {
    final name = _editFieldController.text.trim();
    if (name.isEmpty) return;
    widget.onRenameCustomField(field.id, name);
    setState(() => _editingFieldId = null);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final popoverWidth = width < 420 ? width - 32 : 360.0;

    return SizedBox(
      width: popoverWidth,
      height: 370,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primaryBlue,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'ẨN / HIỆN CỘT'),
                  Tab(text: 'TRƯỜNG TÙY CHỈNH'),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ColumnVisibilityTab(
                    columns: widget.columns,
                    onToggleColumn: widget.onToggleColumn,
                  ),
                  _CustomFieldsTab(
                    fields: widget.customFields,
                    fieldTypes: _fieldTypes,
                    selectedType: _selectedType,
                    newFieldController: _newFieldController,
                    editingFieldId: _editingFieldId,
                    editFieldController: _editFieldController,
                    onTypeChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                    onSubmitNewField: _submitNewField,
                    onStartEditing: _startEditing,
                    onCancelEditing: () => setState(() => _editingFieldId = null),
                    onSubmitEdit: _submitEdit,
                    onDeleteField: widget.onDeleteCustomField,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnVisibilityTab extends StatelessWidget {
  final List<CustomerColumnOption> columns;
  final ValueChanged<String> onToggleColumn;

  const _ColumnVisibilityTab({
    required this.columns,
    required this.onToggleColumn,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: columns.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final column = columns[index];
        return CheckboxListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          activeColor: AppColors.primaryBlue,
          value: column.isVisible,
          onChanged: (_) => onToggleColumn(column.id),
          title: Row(
            children: [
              if (column.isCustom)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'TEXT',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  column.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomFieldsTab extends StatelessWidget {
  final List<CustomerCustomFieldOption> fields;
  final List<String> fieldTypes;
  final String selectedType;
  final TextEditingController newFieldController;
  final String? editingFieldId;
  final TextEditingController editFieldController;
  final ValueChanged<String?> onTypeChanged;
  final VoidCallback onSubmitNewField;
  final ValueChanged<CustomerCustomFieldOption> onStartEditing;
  final VoidCallback onCancelEditing;
  final ValueChanged<CustomerCustomFieldOption> onSubmitEdit;
  final ValueChanged<String> onDeleteField;

  const _CustomFieldsTab({
    required this.fields,
    required this.fieldTypes,
    required this.selectedType,
    required this.newFieldController,
    required this.editingFieldId,
    required this.editFieldController,
    required this.onTypeChanged,
    required this.onSubmitNewField,
    required this.onStartEditing,
    required this.onCancelEditing,
    required this.onSubmitEdit,
    required this.onDeleteField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: fields.isEmpty
              ? const Center(
                  child: Text(
                    'Chưa có trường tùy chỉnh',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: fields.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final field = fields[index];
                    final isEditing = editingFieldId == field.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 52,
                            child: Text(
                              field.type.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: isEditing
                                ? SizedBox(
                                    height: 32,
                                    child: TextField(
                                      controller: editFieldController,
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => onSubmitEdit(field),
                                      decoration: _inputDecoration(),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  )
                                : Text(
                                    field.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 6),
                          if (isEditing) ...[
                            _IconAction(
                              icon: Icons.check,
                              tooltip: 'Lưu',
                              onPressed: () => onSubmitEdit(field),
                            ),
                            _IconAction(
                              icon: Icons.close,
                              tooltip: 'Hủy',
                              onPressed: onCancelEditing,
                            ),
                          ] else ...[
                            _IconAction(
                              icon: Icons.edit_outlined,
                              tooltip: 'Sửa',
                              onPressed: () => onStartEditing(field),
                            ),
                            _IconAction(
                              icon: Icons.delete_outline,
                              tooltip: 'Xóa',
                              onPressed: () => onDeleteField(field.id),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: newFieldController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onSubmitNewField(),
                    decoration: _inputDecoration(hintText: 'Tên trường'),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 92,
                height: 36,
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: _inputDecoration(),
                  iconSize: 18,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                  ),
                  items: fieldTypes
                      .map(
                        (type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: onTypeChanged,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                height: 36,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onSubmitNewField,
                  child: const Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 28,
        height: 28,
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 17,
          color: AppColors.textTertiary,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
