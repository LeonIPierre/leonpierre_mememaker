part of 'download_bloc.dart';

abstract class DownloadState extends Equatable {
  final String url;
  final bool isValid;

  const DownloadState({this.url = '', this.isValid = false});
  
  @override
  List<Object> get props => [];
}

class DownloadIdealState extends DownloadState {
  final IEnumerable<ContentBase> recentDownloads;

  const DownloadIdealState({String url = '', bool isValid = false, this.recentDownloads})
    : super(url: url, isValid: isValid);

  DownloadIdealState copyWith({ String url = '', bool isValid = false, IEnumerable<Meme> recentDownloads})
    => DownloadIdealState(url: url ?? this.url, isValid: isValid ?? this.isValid, 
      recentDownloads: recentDownloads ?? this.recentDownloads);

  @override
  List<Object> get props => [url, isValid, recentDownloads];
}

class DownloadCompletedState extends DownloadIdealState {
  final ContentBase meme;

  const DownloadCompletedState(this.meme, { String url = '', bool isValid = false, IEnumerable<Meme> recentDownloads})
    : super(url: url, isValid: isValid, recentDownloads: recentDownloads);

  @override
  List<Object> get props => [url, isValid, recentDownloads, meme];
}

class DownloadLoadingState extends DownloadState {
  final int progress;

   const DownloadLoadingState({this.progress});

  @override
  List<Object> get props => [progress];
}

class DownloadErrorState extends DownloadState {
  final String message;

  DownloadErrorState({this.message});

  @override
  List<Object> get props => [message];
}