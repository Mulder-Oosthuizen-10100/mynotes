// import 'package:flutter/material.dart';
// import 'package:mynotes/constants/route.dart';
// import 'package:mynotes/enums/menu_action.dart';
// import 'package:mynotes/services/auth/auth_services.dart';
// import 'package:mynotes/services/crud/notes_services.dart';
// import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
// import 'package:mynotes/views/notes/notes_list_view.dart';

// class NotesView extends StatefulWidget {
//   const NotesView({Key? key}) : super(key: key);

//   @override
//   State<NotesView> createState() => _NotesViewState();
// }

// class _NotesViewState extends State<NotesView> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentUser!.email;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Notes'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(createOrUpdateNoteRout);
//             },
//             icon: const Icon(Icons.add),
//           ),
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await AuthService.firebase().logOut();
//                     if (mounted) {
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                         loginRout,
//                         (_) => false,
//                       );
//                     }
//                   }
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem(
//                   value: MenuAction.logout,
//                   child: Text('Log out'),
//                 )
//               ];
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                   stream: _notesService.allNotes,
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.active:
//                         if (snapshot.hasData) {
//                           final allNotes = snapshot.data as List<DatabaseNote>;
//                           return NotesListView(
//                             notes: allNotes,
//                             onDeleteNote: (note) async {
//                               await _notesService.deleteNote(id: note.id);
//                             },
//                             onTap: (note) {
//                               Navigator.of(context).pushNamed(
//                                 createOrUpdateNoteRout,
//                                 arguments: note,
//                               );
//                             },
//                           );
//                         } else {
//                           return const CircularProgressIndicator();
//                         }
//                       default:
//                         return const CircularProgressIndicator();
//                     }
//                   });
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/route.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRout);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    // await AuthService.firebase().logOut();
                    if (mounted) {
                      context.read<AuthBloc>().add(
                            const AuhtEventLogOut(),
                          );
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      // loginRout,
                      // (_) => false,
                      // );
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                )
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRout,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
