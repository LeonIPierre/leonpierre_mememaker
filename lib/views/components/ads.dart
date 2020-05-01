import 'package:dev_libraries/bloc/adbloc.dart';
import 'package:dev_libraries/dev_libraries.dart';
import 'package:dev_libraries/models/ad.dart';
import 'package:dev_libraries/models/adconfiguration.dart';
import 'package:dev_libraries/models/adservice.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/appbloc.dart';

class AdsWidget extends StatefulWidget {
  final AdBloc adBloc;
  final AppBloc appBloc;
  AdsWidget(this.adBloc, this.appBloc, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  initState() {
    super.initState();
    
    var adUnitId = widget.appBloc.configuration["adUnitId"];
    //var adUnitId = "ca-app-pub-3940256099942544/1033173712";
    widget.adBloc.add(AdEvent(AdEventId.StartAdStream, adConfiguration: AdConfiguration(AdType.Banner, adUnitId)));
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: widget.adBloc.ads,
    initialData: widget.adBloc.ads.value,
    builder: (BuildContext context, AsyncSnapshot<Ad> snapshot) {
      if(snapshot.hasData && snapshot.data.adObject is Widget)
        return snapshot.data.adObject as Widget;

      return Container();
    },
  );
}