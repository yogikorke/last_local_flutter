import 'package:flutter/material.dart';
import 'package:last_local_flutter/models/data_model.dart';
import 'package:last_local_flutter/pages/database_based_home.dart';
import 'package:last_local_flutter/utils/database_utilities.dart';
import 'package:last_local_flutter/utils/network_utilities.dart';
import 'package:last_local_flutter/utils/ui_utilities.dart';
import 'package:last_local_flutter/values/app_colors.dart';
import 'package:sembast/sembast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataModel? dataModel;
  String dataUrl = 'https://sigmatenant.com/mobile/tags';
  bool showLinearProgress = false;
  String keywordToFilterResults = '';
  Database? database;
  var dataStoreReference = StoreRef<String, Map<String, dynamic>>.main();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    database = await DatabaseUtilities.getDatabaseClient();
    getData();
  }

  void getData() async {
    setState(() {
      showLinearProgress = true;
    });

    dataModel = DataModel.fromJson(await NetworkUtilities(context)
        .executeGetRequest(dataUrl, null, context));
    dataStoreReference.record('data').put(database!, dataModel!.toJson());

    setState(() {
      showLinearProgress = false;
    });

    //debugPrint('data length : ${dataModel!.tags!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          bottom: PreferredSize(
            child: showLinearProgress
                ? Container(
                    child: UiUtilities.showLinearProgressIndicator(context))
                : Container(),
            preferredSize: const Size.fromHeight(4.0),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DatabaseBasedHome(),
                  ),
                );
              },
              icon: const Icon(
                Icons.storage,
              ),
            ),
          ],
        ),
        body: showLinearProgress
            ? const Center(
                child: Text(
                  'Loading, Please Wait ...',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Enter keyword to filter results',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          keywordToFilterResults = value;
                        });
                      },
                    ),
                  ),
                  dataListWidget(),
                ],
              ),
      ),
    );
  }

  Widget dataListWidget() {
    return dataModel != null
        ? Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: dataModel!.tags!.length,
                itemBuilder: (context, index) {
                  return dataModel!.tags![index].displayName!
                              .toLowerCase()
                              .contains(keywordToFilterResults.toLowerCase()) ||
                          dataModel!.tags![index].description!
                              .toLowerCase()
                              .contains(keywordToFilterResults.toLowerCase())
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 4,
                                    margin: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        dataModel!.tags![index].displayName!
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  dataModel!.tags![index].meta != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            dataModel!.tags![index].meta!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      top: 4.0,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                        dataModel!.tags![index].description!),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      top: 4.0,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      'Spaces',
                                      style: TextStyle(
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
          )
        : const SizedBox.shrink();
  }
}
