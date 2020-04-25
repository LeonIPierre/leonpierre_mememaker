import 'package:dev_libraries/bloc/adbloc.dart';
import 'package:dev_libraries/dev_libraries.dart';
import 'package:dev_libraries/models/ad.dart';
import 'package:dev_libraries/services/ads/adservice.dart';
import 'package:flutter/widgets.dart';

class AdsWidget extends StatefulWidget {
  final AdBloc adBloc;
  AdsWidget(this.adBloc, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  initState() {
    super.initState();
    widget.adBloc.add(AdLoadEvent(AdType.Banner));
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