import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/constants/constants.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'package:flutter_weather/screens/home_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';


class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String version;

  //the values displayed on the toggles
  bool useImperial;
  bool useDarkMode;
  bool use24;
  String windDropdownValue;
  String langDropdownValue;

  void initState() {
    super.initState();
    getVersion();
    getSharedPrefs();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  //gets the shared prefs to display on the toggles
  Future<void> getSharedPrefs() async {
    useImperial = await SharedPrefs.getImperial();
    useDarkMode = await SharedPrefs.getDark();
    use24 = await SharedPrefs.get24();
    switch (await SharedPrefs.getWindUnit()) {
      case WindUnit.MS:
        windDropdownValue = "meters/s";
        break;
      case WindUnit.MPH:
        windDropdownValue = "miles/h";
        break;
      case WindUnit.KMPH:
        windDropdownValue = "kilometers/h";
        break;
    }
    langDropdownValue = await SharedPrefs.getLanguageCode();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(),
      appBar: AppBar(
        brightness: ThemeColors.isDark ? Brightness.dark : Brightness.light,
        title: Text(
          Language.getTranslation("more"),
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 30,
            color: ThemeColors.primaryTextColor(),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                height: 125,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: kBorderRadius,
                  color: Colors.grey[900],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 15,
                      child: Text(
                        "Weather Today",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 35,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Text(
                        "by Cipher",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      activeColor: Colors.teal,
                      title: Text(
                        Language.getTranslation("darkMode"),
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                      value: useDarkMode ?? false,
                      onChanged: (bool value) async {
                        useDarkMode = true;
                        ThemeColors.switchTheme(value);
                        //restart the app to show theme changes
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HomeScreen();
                            },
                          ),
                        );
                      },
                      secondary: Icon(
                        Icons.lightbulb_outline,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      activeColor: Colors.teal,
                      title: Text(
                        Language.getTranslation("useFahrenheit"),
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      value: useImperial ?? false,
                      onChanged: (bool value) async {
                        await SharedPrefs.setImperial(value);
                        useImperial = value;
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text(Language.getTranslation("refreshToSee"))));
                      },
                      secondary: Icon(
                        Icons.thermostat_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: SwitchListTile(
                      activeColor: Colors.teal,
                      title: Text(
                        Language.getTranslation("use24HourTime"),
                        style: TextStyle(
                          color: ThemeColors.primaryTextColor(),
                        ),
                      ),
                      value: use24 ?? false,
                      onChanged: (bool value) async {
                        await SharedPrefs.set24(value);
                        use24 = value;
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text(Language.getTranslation("refreshToSee"))));
                      },
                      secondary: Icon(
                        Icons.timelapse_outlined,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
              SizedBox(
                height: 80,
                child: Card(
                  child: Center(
                    child: ListTile(
                      title: Text(
                        Language.getTranslation("windSpeedUnit"),
                        style: TextStyle(color: ThemeColors.primaryTextColor()),
                      ),
                      leading: Icon(
                        Icons.waves_sharp,
                        color: ThemeColors.secondaryTextColor(),
                      ),
                      trailing: DropdownButton<String>(
                        value: windDropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        style: TextStyle(
                            color: ThemeColors.primaryTextColor(),
                            fontSize: 16),
                        underline: Container(
                          height: 2,
                          color: Colors.teal,
                        ),
                        dropdownColor: ThemeColors.backgroundColor(),
                        onChanged: (String newValue) async {
                          windDropdownValue = newValue;
                          switch (newValue) {
                            case "miles/h":
                              await SharedPrefs.setWindUnit(WindUnit.MPH);
                              break;
                            case "meters/s":
                              await SharedPrefs.setWindUnit(WindUnit.MS);
                              break;
                            case "kilometers/h":
                              await SharedPrefs.setWindUnit(WindUnit.KMPH);
                              break;
                          }
                          setState(() {});
                        },
                        items: <String>["miles/h", "meters/s", "kilometers/h"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  color: ThemeColors.cardColor(),
                  shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
