part of 'download_bloc.dart';

enum DownloadEventIds {
  Loaded,

  DownloadError,
  DownloadUrlChanged,
  DownloadRequested,
  DownloadProgressUpdate,
  DownloadCompleted
}

abstract class DownloadEvent extends Equatable {
  final DownloadEventIds id;
  const DownloadEvent(this.id);

  @override
  List<Object> get props => [];
}

class DownloadInitializeEvent extends DownloadEvent {
  DownloadInitializeEvent() : super(DownloadEventIds.Loaded);
} 

class DownloadErrorEvent extends DownloadEvent {
  final int errorId;
  DownloadErrorEvent(this.errorId) : super(DownloadEventIds.DownloadError);

  @override
  List<Object> get props => [errorId];
} 

class DownloadProgressEvent extends DownloadEvent {
  final int progress;

  DownloadProgressEvent(this.progress) : super(DownloadEventIds.DownloadProgressUpdate);

  @override
  List<Object> get props => [progress];
}

class DownloadUrlChangedEvent extends DownloadEvent {
  final String url;

  DownloadUrlChangedEvent(this.url) : super(DownloadEventIds.DownloadUrlChanged);

  @override
  List<Object> get props => [url];
}

class DownloadMemeEvent extends DownloadEvent {
  final Meme meme;

  DownloadMemeEvent(this.meme) : super(DownloadEventIds.DownloadCompleted);

  @override
  List<Object> get props => [meme];
}

class DownloadRequestEvent extends DownloadEvent {
  final String url;
  final String downloadDirectory;

  DownloadRequestEvent(this.url, this.downloadDirectory) : super(DownloadEventIds.DownloadRequested);

  @override
  List<Object> get props => [url, downloadDirectory];
}