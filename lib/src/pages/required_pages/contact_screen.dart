import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vsafe/src/db/db_services.dart';
import 'package:vsafe/src/model/contact_model.dart';
import 'package:vsafe/src/utils/constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contacts = [];
  List<Contact> contactsFilter = [];
  final DataBaseHelper _dataBaseHelper = DataBaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    List<Contact> contactsList = [];
    contactsList.addAll(contacts);

    if (searchController.text.isNotEmpty) {
      contactsList.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName != null
            ? element.displayName!.toLowerCase()
            : "Invalid Name";
        bool nameMatch = contactName.contains(searchTerm);

        if (nameMatch == true) {
          return true;
        }
        if (searchTermFlatten.isEmpty) {
          return false;
        }
        var phone = element.phones!.firstWhere((element) {
          String phoneFlattered = flattenPhoneNumber(element.value!);
          return phoneFlattered.contains(searchTermFlatten);
        });
        return phone.value != null;
      });
    }
    setState(() {
      contactsFilter = contactsList;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    } else {
      handleInvalidPermission(permissionStatus);
    }
  }

// function to get contact permission
  Future<PermissionStatus> getContactPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  handleInvalidPermission(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      showAlertDialogueBox(
          context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      showAlertDialogueBox(
          context, "May contact does not exist in this device");
    }
  }

  getAllContacts() async {
    List<Contact> contactsList =
        await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = contactsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExist = (contactsFilter.isNotEmpty || contacts.isNotEmpty);

    return Scaffold(
      body: contacts.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: const Color(0xfff9d2cf).withOpacity(0.5),
              ),
              child: const Center(child: CircularProgressIndicator()))
          : Container(
              decoration: BoxDecoration(
                color: const Color(0xfff9d2cf).withOpacity(0.5),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: "Search contact",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  listItemExist == true
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: isSearching == true
                                ? contactsFilter.length
                                : contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              Contact contact = isSearching == true
                                  ? contactsFilter[index]
                                  : contacts[index];
                              return ListTile(
                                // If contact is null then show it Blank Contact
                                title: contact.displayName != null
                                    ? Text(contact.displayName!)
                                    : const Text("Invalid Name"),
                                leading: contact.displayName != null
                                    ? contact.avatar != null &&
                                            contact.avatar!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor:
                                                const Color(0xff401793),
                                            backgroundImage:
                                                MemoryImage(contact.avatar!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor:
                                                const Color(0xff401793),
                                            child: Text(contact.initials()),
                                          )
                                    : const CircleAvatar(
                                        backgroundColor: Color(0xff401793),
                                        child: Text(
                                          "Blank",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                onTap: () {
                                  if (contact.phones!.isNotEmpty) {
                                    final String phoneNumber =
                                        contact.phones!.elementAt(0).value!;
                                    final String name = contact.displayName!;
                                    _addContact(
                                        TContactModel(phoneNumber, name));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Oops! Phone number of this contact doesn't exist");
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("Searching...")),
                ],
              )),
    );
  }

  void _addContact(TContactModel newContact) async {
    int result = await _dataBaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added in trusted contact list");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact!");
    }

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    Navigator.of(context).pop(true);
  }
}
