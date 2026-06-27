import 'package:flutter/material.dart';
import '../../../controller/network_controller.dart';
import '../../../model/network_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/measureWidgetHeight.dart';
import 'card.dart';
import 'package:graphview/graphview.dart';

class NetworkListView extends StatefulWidget {
  const NetworkListView({super.key, required this.controller});

  final NetworkController controller;

  @override
  State<NetworkListView> createState() => _NetworkListViewState();
}

class _NetworkListViewState extends State<NetworkListView> {
  final TransformationController _transformationController =
      TransformationController();
  List<Userslist> finalUserList = [];
  bool nodegeneratorBuilt = false;
  List<List<int>> nodeModel = [];
  int childLevel = 0;
  double widgetScale = 0;
  var widgetHeight = Size.zero;


  listBuilder(List<Userslist> userlist) {
    try {
      finalUserList = [];
      nodeModel = [];
      childLevel = 0;
      listBuilderSub(userlist, 0);
    } catch (e) {
      print('Error in listBuilder: $e');
      finalUserList = [];
      nodeModel = [];
    }
  }

  listBuilderSub(List<Userslist> userlist, int level) {
    for (int i = 0; i < userlist.length; i++) {
      finalUserList.add(userlist[i]);
      if (level != 0) {
        nodeModel.add([
          (level),
          (finalUserList.indexOf(userlist[i]) + 1),
        ]);
      }

      if (userlist[i].children.isNotEmpty) {
        listBuilderSub(userlist[i].children, level + 1);
      }
    }
  }

  splitName(String name, int part) {
    try {
      int idx = name.indexOf("<");
      int idx2 = name.indexOf("src='");
      int idx3 = name.indexOf("'>");
      if (idx == -1 || idx2 == -1 || idx3 == -1) {
        return part == 1 ? name : '';
      }
      List parts = [
        name.substring(0, idx).trim(),
        name.substring(idx2 + 5, idx3).trim(),
      ];
      print('Image link: ' + parts[1]);
      return part == 1 ? parts[0] : parts[1];
    } catch (e) {
      print('Error in splitName: $e');
      return part == 1 ? name : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width; // calculate the scale factor

    // Add null check
    if (widget.controller.networkData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    var netModel = widget.controller.networkData!.data.userslist;
    listBuilder(netModel);
    if (nodegeneratorBuilt == false) {
      Future.delayed(const Duration(milliseconds: 300), () {
        nodegenerator();
      });
      nodegeneratorBuilt = true;
    }

    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double childHeight = constraints.maxHeight;
        double scale = (MediaQuery.of(context).size.height-300) / childHeight;

        return InteractiveViewer(
          // minScale: 0.35,
          // maxScale: 1,
          boundaryMargin: EdgeInsets.all(double.infinity),
          // minScale: 0.5,
          // maxScale: 2.0,
          transformationController: _transformationController,
          onInteractionEnd: (details) {
            // Details.scale can give values below 0.5 or above 2.0 and resets to 1
            // Use the Controller Matrix4 to get the correct scale.
            double correctScaleValue =
                _transformationController.value.getMaxScaleOnAxis();
          },
          onInteractionUpdate: (ScaleUpdateDetails details) {
            // get the scale from the ScaleUpdateDetails callback
            var myScale = details.scale;
            print(myScale); // print the scale here
          },
          child: OverflowBox(
              alignment: Alignment.center,
              minWidth: 0.0,
              minHeight: 0.0,
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.scale(
                scale: scale,
                child: finalUserList.length == 1
                    ? NetworkCard(data: finalUserList[0])
                    : MeasureSize(
                        onChange: (size) {
                          setState(() {
                            widgetHeight = size;
                          });
                        },
                        child: GraphView(
                          graph: graph,
                          algorithm: BuchheimWalkerAlgorithm(
                              builder, TreeEdgeRenderer(builder)),
                          paint: Paint()
                            ..color = AppColor.appPrimary
                            ..strokeWidth = 2
                            ..style = PaintingStyle.stroke,
                          builder: (Node node) {
                            // I can decide what widget should be shown here based on the id
                            var a = node.key!.value as int;
                            return NetworkCard(data: finalUserList[a - 1]);
                          },
                        ),
                      ),
              )),
        );
      }),
    );
  }

  final Graph graph = Graph()..isTree = true;

  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  nodegenerator() {
    List<Node> nodes = [];
    nodes = List.generate(finalUserList.length, (i) => Node.Id(i + 1));

// edges represented as nested list
    List<List<int>> edges = [];
    edges = nodeModel;

    for (var edge in edges) {
      graph.addEdge(nodes[edge[0] - 1], nodes[edge[1] - 1]);
    }

    builder
      ..siblingSeparation = (30)
      ..levelSeparation = (30)
      ..subtreeSeparation = (80)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }

  @override
  void initState() {
    super.initState();  // Call super.initState() first
    if (widget.controller.networkData != null) {  // Add null check
      var netModel = widget.controller.networkData!.data.userslist;
      listBuilder(netModel);
      nodegenerator();
    }
  }
}
