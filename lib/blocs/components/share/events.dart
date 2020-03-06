import 'package:leonpierre_mememaker/models/mememodel.dart';

enum ShareEventId {
  LoadShareOptions,
  ShareOptionsLoaded,
  ShareOptionSelected,
  DismissShareOptions
}

abstract class ShareEvent {
  ShareEventId id;

  ShareEvent(this.id);
}

class ShareOptionsLoadEvent extends ShareEvent {
  Meme meme;
  ShareOptionsLoadEvent(this.meme) : super(ShareEventId.LoadShareOptions);
}

class ShareOptionsLoadedEvent extends ShareEvent {
  List<Uri> options;
  ShareOptionsLoadedEvent(this.options) : super(ShareEventId.ShareOptionsLoaded);
}

class ShareOptionsDismissedEvent extends ShareEvent {
  ShareOptionsDismissedEvent() : super(ShareEventId.DismissShareOptions);
}

class ShareOptionSelected extends ShareEvent {
  String url;

  ShareOptionSelected(this.url) : super(ShareEventId.ShareOptionSelected);
}