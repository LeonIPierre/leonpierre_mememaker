import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/services/memedownloadservice.dart';
import 'package:queries/collections.dart';
import 'package:validators/validators.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  MemeDownloadService _downloadService;
  FavoritesBloc _favoritesBloc;

  ReceivePort _port = ReceivePort();
  StreamSubscription<dynamic> _portSubscription;
  Meme _memeToDownload;

  DownloadBloc(this._downloadService, this._favoritesBloc) : super(DownloadIdealState()) {
    _initialize();
  }

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    switch (event.id) {
      case DownloadEventIds.Loaded:
        //get recent downloaded memes

        break;
      case DownloadEventIds.DownloadRequested:
        var downloadEvent = event as DownloadRequestEvent;

        yield await _downloadService.getMemeByUrlAsync(downloadEvent.url)
          .then((meme) async {
            _memeToDownload = Meme.mapFromEntity(meme);
            return downloadEvent;
          })
          .then((event) async => await FlutterDownloader.enqueue(
            url: _memeToDownload.path.toString(),
            savedDir: event.downloadDirectory
          ))
          .then((_) => DownloadIdealState(url: downloadEvent.url))
          .catchError((error) => DownloadErrorState());
        break;
      case DownloadEventIds.DownloadUrlChanged:
        var downloadEvent = event as DownloadUrlChangedEvent;
        var currentState = state;

        if(currentState is DownloadIdealState) {
          yield currentState.copyWith(url: downloadEvent.url, isValid: isURL(downloadEvent.url));
          return;
        }
        
        yield DownloadIdealState(url: downloadEvent.url, isValid: isURL(downloadEvent.url));
        break;
      case DownloadEventIds.DownloadProgressUpdate:
        yield DownloadLoadingState(progress: (event as DownloadProgressEvent).progress);
        break;
      case DownloadEventIds.DownloadError:
        var message;

        switch((event as DownloadErrorEvent).errorId)
        {
          case 1:
            message = 'Error when creating port';
            break;
          case 2:
            message = 'Error when downloading meme';
            break;
          case 3:
            message = 'Failed when saving favorites';
            break;
          default:
            message = '';
            break;
        }

        yield DownloadErrorState(message: message);
        break;
      case DownloadEventIds.DownloadCompleted:
        yield DownloadCompletedState((event as DownloadMemeEvent).meme);
    }
  }

  Future<void> _initialize() async {
    if(_portSubscription != null) return;

    _portSubscription = await FlutterDownloader.initialize(debug: true
    ).then((_) {
      if(!IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port')) {
        add(DownloadErrorEvent(1));
        return null;
      }
      
      return _port.listen((dynamic data) async {
          //String id = data[0];
          DownloadTaskStatus status = data[1];
          int progress = data[2];

          if (status == DownloadTaskStatus.running)
            add(DownloadProgressEvent(progress));
          else if (status == DownloadTaskStatus.failed)
            add(DownloadErrorEvent(2));
          else if(status == DownloadTaskStatus.complete)
          {
            _favoritesBloc.add(FavoriteStateChangedEvent(FavoritesEventId.MemeAdded, _memeToDownload));
            //await _favoritesRepository.favoriteMeme(_memeToDownload, DateTime.now())
            //  .then((favorited) => favorited ? add(DownloadMemeEvent(_memeToDownload)) : add(DownloadErrorEvent(3)));
          }
        });
    });
  }

  @override
  Future<void> close() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _portSubscription?.cancel();
    return super.close();
  }
}
