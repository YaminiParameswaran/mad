Geo-positioning: 
import 'package:flutter/material.dart'; 
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; 
 
class LocationPage extends 
StatefulWidget { @override 
_LocationPageState createState() => _LocationPageState(); 
} 
 
class _LocationPageState extends State<LocationPage> { 
Position? 
_currentPosition; 
String _currentAddress = ''; 
@override 
Widget build(BuildContext context) {
 return Scaffold( 
appBar: AppBar( 
iconTheme: IconThemeData( 
         color: Colors.black, 
), 
backgroundColor: Color(0xffef2e6c), title: Text("Location",style:TextStyle(color:Colors.black)), 
), 
body:
Center( child: 
Column( mainAxisAlignmn: 
MainAxisAlignment.center, children: 
<Widget>[ 
Image.asset('assets/images/undraw_Current_location_re_j
130.png'), TextButton( style: ButtonStyle(backgroundColor: 
MaterialStateProperty.all(Color(0xffef2e6c))), child: Text("Get location",style:TextStyle(fontSize: 20,color:Colors.white)), onPressed: 
() { 
_getCurrentLocation(); 
}, 
), 
Divider(color:Colors.transparent,thicknes s: 150), if (_currentAddress != null) Text( 
_currentAddress,style: TextStyle(fontSize: 20), 
), 
if (_currentPosition != null) Text( 'Latitude : ' + 
_currentPosition!.latitude.toString(),style: TextStyle(fontSize: 20), 
), 
if (_currentPosition != null) Text( 'Longitude : ' + 
_currentPosition!.longitude.toString(),style: TextStyle(fontSize: 20), 
), 
], 
), 
), 
); 
}  
_getCurrentLocation() { 
Geolocator 
.getCurrentPosition(desiredAccuracy: 
LocationAccuracy.best, forceAndroidLocationManager: 
true) 
.then((Position position) { setState(() { 
_currentPosition = position; 
_getAddressFromLatLng(); 
}); 
}).catchError((e) 
{ print(e); 
}); 
} 
 
_getAddressFromLatLng() async { try { 
List<Placemark> placemarks = await placemarkFromCoordinates( 
        _currentPosition!.latitude, 
        _currentPosition!.longitude 
); 
Placemark place = placemarks[0]; setState(() { _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}"; 
}); 
} catch (e) { print(e); 
} 
} 
}  


Accelerometer: 
import 'dart:async'; 
import 'package:flutter/material.dart'; 
import 'package:sensors/sensors.dart'; 
class FocusPage extends StatefulWidget { final String title='Focus!'; 
@override 
FocusPageState createState() => FocusPageState(); 
} 
class FocusPageState extends State<FocusPage> { 
Color color = Colors.greenAccent; 
AccelerometerEvent? event; 
 Timer? timer; StreamSubscription? 
accel; 
 
double top = 125; 
double? left; 
int count = 0; double? width; double? height; 
 
setColor(AccelerometerEvent event) { 
    double x = ((event.x * 12) + ((width! - 100) / 2)); 
    double y = event.y * 12 + 125; 
 
    xDiff = x.abs() - ((width! - 100) / 2); 
    var yDiff = y.abs() - 125; 
 
    if (xDiff.abs() < 3 && yDiff.abs() < 3) { 
setState(() { 
color = 
Colors.greenAccent; count += 1; 
}); 
} else { 
      setState(() { 
      color = Colors.red; 
      count = 0; 
}); 
} 
} 
 
setPosition(AccelerometerEvent 
event) { if (event == null) { 
return; 
} 
 
setState(() { 
left = ((event.x * 12) + ((width! - 100) / 2)); 
}); 
setState(() { 
top = event.y * 12 + 125; 
}); 
} 
startTimer() { 
    if (accel == null) { 
    accel = accelerometerEvents.listen((AccelerometerEvent eve) { setState(() { 
    event = eve; 
}); 
}); 
} else { 
      accel?.resume(); 
} 
if (timer == null || !timer!.isActive) { 
timer = Timer.periodic(Duration(milliseconds: 200), (_) { 
      if (count > 3) { 
pauseTimer(); 
} else { 
setColor(event!); setPosition(event!); 
} 
}); 
} 
} 
 
pauseTimer() { 
timer?.cancel(); accel?.pause(); 
setState(() { 
count = 0; color = Colors.green; 
}); 
}  
@override void dispose() { timer?.cancel(); accel?.cancel(); super.dispose(); 
} 
 
@override 
Widget build(BuildContext context) width = 
MediaQuery.of(context).size.width; height = 
MediaQuery.of(context).size.height; 
 
return Scaffold( 
appBar: 
AppBar( iconTheme: IconThemeData( 
color: Colors.black, 
), 
title: 
Text(widget.title,style:TextStyle(color:Colors.black)), 
backgroundColor : Color(0xffef2e6c), 
), 
body: Column( 
children: [ 
Padding( padding: const EdgeInsets.all(8.0), child: Text('Keep the circle in the center for 1 
         second',textAlign: TextAlign.center,style: 
         TextStyle(fontSize:25)), 
), 
Stack( children: [ 
Container( height: height! / 
2, width: width, 
), 
Positioned( 
top: 50, left: (width! - 250) / 2, 
child: Container( height: 250, 
width:250, 
decoration:BoxDecoration(
border: Border.all(
color: Colors.red, width: 
5.0), borderRadius: 
BorderRadius.circular(125), 
), 
), 
), 
 
Positioned
( top: top, 
left: left ?? (width! - 100) / 2, 
child: ClipOval( child: 
Container( width: 100, height: 100, color:
color, 
), 
), 
), 
Positioned
( top: 
125, 
left: (width! - 100) / 2, child: Container( height: 100, 
width:100, 
decoration:BoxDecoration(border: Border.all(color: Colors.green, width: 2.0), 
borderRadius: BorderRadius.circular(50), 
), 
), 
), 
], ), 
Text('x:${(event?.x ?? 0).toStringAsFixed(3)}',
style:TextStyle(fontSize: 20)), 
Text('y:${(event?.y ?? 0).toStringAsFixed(3)}',
style:TextStyle(fontSize: 
20)), 
Padding( padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0), child: TextButton( 
style: ButtonStyle(backgroundColor: 
MaterialStateProperty.all(Color(0xffef2e6c))), onPressed: startTimer, child: Text('Begin.!!',style: TextStyle(fontSize: 30.0,color:Colors.white),), 
), 
) 
], 
), 
); 
} 
} 



Gesture based UI: 
import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart';  
class AboutPage extends 
StatefulWidget { @override 
_AboutPageState createState() => _AboutPageState(); 
} 
 
class _AboutPageState extends 
State<AboutPage> { bool _lightIsOn = false; 
@override void dispose() { 
super.dispose(); 
} 
 
@override 
void initState() { 
super.initState(); 
} 
@override 
Widget build(BuildContext context) { return MaterialApp( 
theme:_lightIsOn? 
ThemeData.dark():ThemeData.light(), 
home: Scaffold( appBar: AppBar( title: Text('About', style:TextStyle(color:Colors.black)), backgroundColor: Color(0xffef2e6c), 
), 
body: Column(children: 
<Widget>[Container(margin: EdgeInsets.all(20), height: 200, width: 350, child: Image.asset('assets/images/logo.png'), 
), 
Divider(color:Colors.black,thickness: 2,), 
Container( 
            : FractionalOffset.center, child: Column( 
// mainAxisAlignment: MainAxisAlignment.center, children: 
<Widget>[ 
GestureDetector
( onTap: () { setState(() {  
_lightIsOn = !_lightIsOn; 
}); 
}, 
 
child: Container( 
margin: EdgeInsets.fromLTRB(350, 10, 3, 6), width : 50, height:50, padding: const EdgeInsets.all(8), 
decoration: 
BoxDecoration( shape : 
BoxShape.circle, color: 
Color(0xffef2e6c), 
), 
child: Icon( 
_lightIsOn ? Icons.light_mode_outlined : 
Icons.dark_mode_outlined, size: 30), 
), 
), 
], 
), 
), 
Text('In publishing and graphic design, ' 
'Lorem ipsum is a placeholder text commonly used to demonstrate ' 'the visual form of a document or a typeface without relying on ' 'meaningful content. Lorem ipsum may be used as a placeholder ' 'before final copy is available.', textAlign:TextAlign.center, 
softWrap: true, 
style:GoogleFonts.notoSerif(textStyle: TextStyle( 
color: _lightIsOn ? 
Colors.white : Colors.black,fontSize: 20),) 
), 
] 
) 
) 
); 
} 
} 
