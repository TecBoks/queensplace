import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/global_search_bar.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:bequeen/workers/repository/workers_bloc.dart';
import 'package:bequeen/workers/screens/workers_detail.dart';
import 'package:bequeen/workers/widgets/workers_add_worker_modal.dart';

class WorkersHome extends StatefulWidget {
  const WorkersHome({Key? key}) : super(key: key);

  @override
  State<WorkersHome> createState() => _WorkersHomeState();
}

class _WorkersHomeState extends State<WorkersHome> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  String filter = "";

  @override
  Widget build(BuildContext context) {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: (userAuth['email'] == 'queenplacesps@gmail.com')
            ? FloatingActionButton(
                onPressed: () => _buildAddDialog(context),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add_circle, color: Colors.white))
            : Container(),
        backgroundColor: Colors.white,
        drawer:
            (media.width > 800) ? null : SideMenuResponsive(userAuth: userAuth),
        appBar: AppBar(
            title: Row(children: <Widget>[
          Container(
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset('assets/task.png')),
          Expanded(child: Container()),
          (media.width > 800)
              ? GestureDetector(
                  child: Text('¡Hola ${userAuth['name']}!'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container(),
          (media.width > 800)
              ? GestureDetector(
                  child: (userAuth['photoURL'] == null ||
                          userAuth['photoURL'] == '')
                      ? Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/profile.jpg'))))
                      : Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(userAuth['photoURL'])))),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container()
        ])),
        body: Stack(children: [
          Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: _container(context)))),
          (media.width > 800)
              ? HoverWidget(
                  hoverChild: SideMenu(size: 200, userAuth: userAuth),
                  child: SideMenu(size: 60, userAuth: userAuth),
                  onHover: (value) {})
              : Container(),
        ]));
  }

  Widget _container(context) {
    Size media = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(right: 15),
        width: MediaQuery.of(context).size.width,
        child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: EdgeInsets.only(left: (media.width > 700) ? 60 : 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: const [
                    Expanded(
                        child: Text('Colaboradores',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center))
                  ])),
              const SizedBox(height: 10),
              GlobalSearchBar(
                  changeFilter: changeFilter,
                  icon: Container(),
                  title: '¿Que buscas?'),
              StreamBuilder(
                  stream: workersBloc.getWorkers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> workers = snapshot.data.docs;
                      if (workers.isEmpty) {
                        return const Center(
                            child: Text('¡Aún no existe ningún colaborador!'));
                      } else {
                        return Container(
                            padding: const EdgeInsets.all(10),
                            width: (media.width > 800)
                                ? MediaQuery.of(context).size.width / 1.1
                                : MediaQuery.of(context).size.width,
                            child: _buildListWorkers(
                                listWorkers(workers), context));
                      }
                    } else {
                      return const SkeletonLoader();
                    }
                  })
            ])));
  }

  listWorkers(workers) {
    List<dynamic> newWorkers = [];
    if (workers.length > 0) {
      for (var item in workers) {
        if (filter == '') {
          newWorkers.add(item.data());
        } else if (item
            .data()['name']
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          newWorkers.add(item.data());
        }
      }
    }
    return newWorkers;
  }

  Widget _buildListWorkers(List<dynamic> workers, context) {
    return ListView.builder(
        itemCount: workers.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _workersCard(workers[index], context),
              onTap: () {
                // print(companies[index]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WorkersDetail(worker: workers[index])));
              });
        });
  }

  Widget _workersCard(worker, context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 5),
            ]),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("${worker['name']}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Correo: ${worker['email']}'),
                Text('Contacto: ${worker['phone']}'),
              ])),
          const SizedBox(width: 15),
        ]));
  }

  deleteWorker(context, worker) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("¡Advertencia!"),
              content: Text(
                  "¿Seguro que quieres eliminar el colaborador ${worker["name"]}?"),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder()),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      workersBloc.deleteWorker(worker['uid']);
                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar',
                        style: TextStyle(color: Colors.blue)))
              ]);
        });
  }

  Future _buildAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const WorkersAddWorkerModal();
        });
  }

  changeFilter(text) {
    setState(() {
      filter = text;
    });
  }
}
