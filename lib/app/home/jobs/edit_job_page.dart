import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/models/jobs_model.dart';
import 'package:time_tracker_flutter_course/app/services/database.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_dialog.dart';

class EditJobPage extends StatefulWidget with JobandRatePerHourValidators {
  EditJobPage({Key? key, required this.database, this.job}) : super(key: key);
  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _jobNameFocusNode = FocusNode();
  final _ratePerHourFocusNode = FocusNode();

  bool _isLoading = false;
  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _onEditingComplete() {
    final newFocus = widget.jobNameValidator.isValid(_name ?? '')
        ? _ratePerHourFocusNode
        : _jobNameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final jobs = await widget.database.jobStream().first;
        final allNames = jobs.map((e) => e.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          setState(() {
            _isLoading = false;
          });
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose another job name',
              defaultActionText: 'OK');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour ?? 0);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation Failed', exception: e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: _isLoading ? null : _submit,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        focusNode: _jobNameFocusNode,
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => widget.jobNameValidator.isValid(value!)
            ? null
            : widget.invalidJobNameText,
        textInputAction: TextInputAction.next,
        onSaved: (value) => _name = value,
        enabled: _isLoading == false,
        onChanged: (value) => _name = value,
        onEditingComplete: _onEditingComplete,
      ),
      TextFormField(
        focusNode: _ratePerHourFocusNode,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        validator: (value) => widget.ratePerHourValidator.isValid(value!)
            ? null
            : widget.invalidRatePerHourText,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.number,
        enabled: _isLoading == false,
        onSaved: (value) => _ratePerHour = int.tryParse(value ?? '0'),
      ),
    ];
  }
}
