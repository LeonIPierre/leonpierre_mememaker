import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/blocs/components/share/events.dart';
import 'package:leonpierre_mememaker/blocs/components/share/states.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:queries/collections.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  Meme _meme;

  ShareBloc() : super(ShareHiddenState());
  
  @override
  Stream<ShareState> mapEventToState(ShareEvent event) async* {
    switch (event.id) {
      case ShareEventId.LoadShareOptions:
        var loadEvent = event as ShareOptionsLoadEvent;
        
        if(_meme == null || _meme != loadEvent.meme)
        {
          _meme = loadEvent.meme;
          var options = [Uri.parse("https://wwww.google.com")];
          add(ShareOptionsLoadedEvent(options));
        }
        else
        {
          add(ShareOptionsDismissedEvent());
        }
        break;
      case ShareEventId.ShareOptionsLoaded:
        var options = (event as ShareOptionsLoadedEvent).options;
        
        yield ShareIdealState(_meme, Collection(options));
        break;
      case ShareEventId.DismissShareOptions:
        _meme = null;
        yield ShareHiddenState();
        return;
      default:
        yield state;
        break;
    }
  }

  bool isSharing(Meme meme) => _meme == meme;
}
