import 'package:flutter/material.dart';
import 'package:last_local_flutter/models/data_model.dart';
import 'package:last_local_flutter/utils/database_utilities.dart';
import 'package:last_local_flutter/utils/ui_utilities.dart';
import 'package:last_local_flutter/values/app_colors.dart';
import 'package:sembast/sembast.dart';

class DatabaseBasedHome extends StatefulWidget {
  const DatabaseBasedHome({Key? key}) : super(key: key);

  @override
  _DatabaseBasedHomeState createState() => _DatabaseBasedHomeState();
}

class _DatabaseBasedHomeState extends State<DatabaseBasedHome> {
  DataModel? dataModel;
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

    dynamic jsonObject = await dataStoreReference.record('data').get(database!);
    if (jsonObject != null) {
      //debugPrint("jsonObject : $jsonObject");
      DataModel localDataModel = DataModel.fromJson(jsonObject);
      dataModel = localDataModel;
    }

    setState(() {
      showLinearProgress = false;
    });

    debugPrint('data length : ${dataModel!.tags!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Database based Home'),
          bottom: PreferredSize(
            child: showLinearProgress
                ? Container(
                    child: UiUtilities.showLinearProgressIndicator(context))
                : Container(),
            preferredSize: const Size.fromHeight(4.0),
          ),
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
                  dataModel != null
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: dataModel!.tags!.length,
                              itemBuilder: (context, index) {
                                return dataModel!.tags![index].displayName!
                                            .toLowerCase()
                                            .contains(keywordToFilterResults
                                                .toLowerCase()) ||
                                        dataModel!.tags![index].description!
                                            .toLowerCase()
                                            .contains(keywordToFilterResults
                                                .toLowerCase())
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Card(
                                                  elevation: 4,
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      dataModel!.tags![index]
                                                          .displayName!
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.onSurface,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                dataModel!.tags![index].meta !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          dataModel!
                                                              .tags![index]
                                                              .meta!,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8,
                                                    top: 4.0,
                                                    bottom: 8,
                                                  ),
                                                  child: Text(dataModel!
                                                      .tags![index]
                                                      .description!),
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
                                                      color:
                                                          AppColors.onSurface,
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
                      : const SizedBox.shrink(),
                ],
              ),
      ),
    );
  }
}
