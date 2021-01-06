import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:leonpierre_mememaker/blocs/favorites/favoritesbloc.dart';
import 'package:leonpierre_mememaker/models/contentbase.dart';
import 'package:leonpierre_mememaker/models/mememodel.dart';
import 'package:leonpierre_mememaker/repositories/entities/contentbase.dart';
import 'package:leonpierre_mememaker/services/memedownloadservice.dart';
import 'package:queries/collections.dart';
import 'package:validators/validators.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  static final String portName = 'mrmeme_port';
  MemeDownloadService _downloadService;
  FavoritesBloc _favoritesBloc;

  ReceivePort _port = ReceivePort();
  StreamSubscription<dynamic> _portSubscription;
  StreamSubscription _favoritesSubscription;
  Meme _memeToDownload;

  DownloadBloc(this._downloadService, this._favoritesBloc) : super(DownloadIdealState());

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    switch (event.id) {
      case DownloadEventIds.Loaded:
        yield await FlutterDownloader.loadTasksWithRawQuery(query: 
          "SELECT * FROM task WHERE status=3 ORDER BY time_created DESC LIMIT 5")
          .then((tasks) => tasks.map((task) => _mapTaskToEntity(task)))
          .then((downloads) => DownloadIdealState(recentDownloads: Collection(downloads)));
        break;
      case DownloadEventIds.DownloadRequested:
        var downloadEvent = event as DownloadRequestEvent;
        
        if(!isURL(downloadEvent.url))
        {
          yield DownloadIdealState(url: downloadEvent.url, isValid: false);
          return;
        }

        yield DownloadLoadingState();

        yield await _downloadService.getMemeByUrlAsync(downloadEvent.url)
          .then((meme) async {
            _memeToDownload = Meme.mapFromEntity(meme);
            return downloadEvent;
          })
          .then((value) => Future.delayed(Duration(seconds: 2),() => value))
          .then((event) async => await FlutterDownloader.enqueue(
            openFileFromNotification: false,
            url: _memeToDownload.path.toString(),
            savedDir: event.downloadDirectory
          ))
          .then((_) => DownloadLoadingState())
          .catchError((error) => DownloadErrorState());
        break;
      case DownloadEventIds.DownloadUrlChanged:
        var downloadEvent = event as DownloadUrlChangedEvent;
        var currentState = state;
        var isValid = isURL(downloadEvent.url);

        //check if the user has already downloaded the meme that they input ????

        if(currentState is DownloadIdealState) {
          yield currentState.copyWith(url: downloadEvent.url, isValid: isValid);
          return;
        }
        
        yield DownloadIdealState(url: downloadEvent.url, isValid: isValid);
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
        var meme = (event as DownloadMemeEvent).meme;
        _favoritesBloc.add(FavoriteStateChangedEvent(FavoritesEventId.MemeAdded, meme));
        yield DownloadCompletedState(meme, isValid: true);
        break;
    }
  }

  @override
  Future<void> close() {
    IsolateNameServer.removePortNameMapping(portName);
    _portSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    if(_portSubscription != null && IsolateNameServer.lookupPortByName(portName) != null) return;

    if(!IsolateNameServer.registerPortWithName(_port.sendPort, portName)) {
      add(DownloadErrorEvent(1));
      _portSubscription = null;
      IsolateNameServer.removePortNameMapping(portName);
      await initialize();
      return;
    }

    FlutterDownloader.registerCallback(downloadCallback);

    _favoritesSubscription = _favoritesBloc.listen((state) {
      //if(state is FavoritedContentChangedState)
        //state.content.
    });

    _portSubscription = _port.listen((dynamic data) async {
      //String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      
      if (status == DownloadTaskStatus.running)
        add(DownloadProgressEvent(progress));
      else if (status == DownloadTaskStatus.failed)
        add(DownloadErrorEvent(2));
      else if(status == DownloadTaskStatus.complete)
        add(DownloadMemeEvent(_memeToDownload));
    });

    add(DownloadInitializeEvent());
  }

  ContentBase _mapTaskToEntity(DownloadTask task) {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = task.taskId;
    json['path'] = task.filename;
    json['name'] = "";
    json['description'] = "";
    json['dateLiked'] = task.timeCreated.toString();

    return ContentBase.fromEntity(ContentBaseEntity.fromJson(json));
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(portName);
    send.send([id, status, progress]);
  }
}
