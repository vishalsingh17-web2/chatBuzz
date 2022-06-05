import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

editPersonalDetails({required BuildContext context, required String name, String? bio}) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController bioController = TextEditingController(text: bio ?? "");
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit personal details",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: bioController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<PersonalDetails>(context, listen: false).updateUserDetails(
                    name: nameController.text,
                    bio: bioController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      );
    },
  );
}
