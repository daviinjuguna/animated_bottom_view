import 'package:animated_bottom_view/object/bottom_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bottomItems = [
    BottomObject(
      name: "HOME",
      stateMachineName: "HOME_interactivity",
      label: "Home",
    ),
    BottomObject(
      name: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity",
      label: "Favourites",
    ),
    BottomObject(
      name: "CHAT",
      stateMachineName: "CHAT_Interactivity",
      label: "Chat",
    ),
    BottomObject(
      name: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity",
      label: "Settings",
    )
  ];

  int _currentIndex = 0;

  void _onNavigateAnimate(int index) {
    setState(() {
      _currentIndex = index;
    });
    _bottomItems.forEach((element) {
      if (element == _bottomItems[index]) {
        element.input?.value = true;
      } else {
        element.input?.value = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    rootBundle.load("assets/icons.riv").then((value) {
      final _file = RiveFile.import(value);
      final _bottomArtBoards = _bottomItems
          .map((item) => _file.artboards
              .firstWhere((element) => element.name == item.name))
          .toList();

      final _bottomControllers = _bottomItems.asMap().entries.map((entry) {
        final _i = entry.key;
        final _item = entry.value;

        return StateMachineController.fromArtboard(
          _bottomArtBoards[_i],
          _item.stateMachineName,
        );
      }).toList();

      if (_bottomControllers.every((element) => element != null)) {
        for (var i = 0; i < _bottomItems.length; i++) {
          _bottomArtBoards[i].addController(_bottomControllers[i]!);
          _bottomItems[i].setInput = _bottomControllers[i]!.findInput("active");
        }
      }

      setState(() {
        for (var i = 0; i < _bottomItems.length; i++) {
          _bottomItems[i].setArtboard = _bottomArtBoards[i];
        }
      });

      _bottomItems.forEach((element) {
        if (element == _bottomItems[_currentIndex]) {
          element.input?.value = true;
        } else {
          element.input?.value = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onNavigateAnimate,
        items: _bottomItems
            .map(
              (e) => BottomNavigationBarItem(
                label: e.label ?? "",
                icon: e.artboard != null
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: Rive(
                          artboard: e.artboard!,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Opacity(opacity: 0),
              ),
            )
            .toList(),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Text(
            _bottomItems[_currentIndex].label ?? "",
            key: ValueKey<int>(_currentIndex),
          ),
        ),
      ),
    );
  }
}
