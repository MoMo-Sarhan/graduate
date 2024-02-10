import 'package:flutter/material.dart';
import 'package:graduate/component/custom_text_filed.dart';
import 'package:graduate/services/user_data_services.dart';

class ChangeNamePage extends StatefulWidget {
  ChangeNamePage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final TextEditingController firstNameConroller = TextEditingController();
  final TextEditingController lastNameConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: widget.formKey,
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomTextFormFiled(
                hintText: 'First Name',
                isEnabled: true,
                label: 'First Name',
                onChange: (value) {},
                validator: (value) {
                  if (firstNameConroller.text.isEmpty) {
                    return 'Please Enter First Name';
                  }
                  return null;
                },
                controller: firstNameConroller,
                obscureText: false),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomTextFormFiled(
                hintText: 'Last Name',
                label: 'Last Name',
                isEnabled: true,
                onChange: (value) {},
                validator: (value) {
                  if (lastNameConroller.text.isEmpty) {
                    return 'Please Enter Last Name';
                  }
                  return null;
                },
                controller: lastNameConroller,
                obscureText: false),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
                onPressed: () async {
                  if (widget.formKey.currentState!.validate()) {
                    await UserServices().changeName(
                        firstName: firstNameConroller.text,
                        lastName: lastNameConroller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit')),
          )
        ]),
      ),
    );
  }
}
