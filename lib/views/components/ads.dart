import 'package:dev_libraries/blocs/ads/ads.dart';
import 'package:dev_libraries/models/ads/ads.dart';
import 'package:flutter/widgets.dart';

class AdsWidget extends StatefulWidget {
  final AdBloc adBloc;
  final Map<String, dynamic> configuration;
  AdsWidget(this.adBloc, this.configuration, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  @override
  initState() {
    super.initState();
    
    AdSize adSize = AdSize(widget.configuration["ad:height"], widget.configuration["ad:width"]);
    widget.adBloc.add(AdEvent(AdEventId.LoadAd, adConfiguration: AdConfiguration(AdType.Banner, adSize: adSize)));
    widget.adBloc.add(AdEvent(AdEventId.StartAdStream, adConfiguration: AdConfiguration(AdType.Banner)));
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: widget.adBloc.ads,
    initialData: widget.adBloc.ads.value,
    builder: (BuildContext context, AsyncSnapshot<Ad> snapshot) {
      if(!snapshot.hasData)
        return Container();

      if(snapshot.data.adObject is Widget)
        return snapshot.data.adObject as Widget;
    },
  );
}