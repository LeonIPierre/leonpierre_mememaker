import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/download/download_bloc.dart';
import 'package:leonpierre_mememaker/views/components/content.dart';
import 'package:leonpierre_mememaker/views/components/download_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show Platform;

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    DownloadBloc _downloadBloc = BlocProvider.of(context);
    
    return BlocBuilder<DownloadBloc, DownloadState>(
        builder: (BuildContext context, DownloadState state) {
      var textbox = TextFormField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4.0),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
            //errorText: errorText ?? errorText,
            hintText: 'url'),
        keyboardType: TextInputType.url,
        validator: (value) => state.isValid ? null : 'errorText',
        onChanged: (value) => _downloadBloc.add(DownloadUrlChangedEvent(value)),
      );

      var button = DownloadButton(
          stateWidgets: {
            ButtonState.idle: Icon(Icons.download_rounded),
            ButtonState.loading: CircularProgressIndicator(),
            ButtonState.fail: Icon(Icons.close_rounded),
            ButtonState.success: Icon(Icons.download_rounded)
          },
          stateColors: {
            ButtonState.idle: Colors.transparent,
            ButtonState.loading: Colors.transparent,
            ButtonState.fail: Colors.transparent,
            ButtonState.success: Colors.transparent,
          },
          onPressed: !state.isValid
              ? null
              : () async => await _getDownloadPath().then((path) =>
                  _downloadBloc.add(DownloadRequestEvent(state.url, path))),
          state: _mapToStatus(state));

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          Row(children: [
            Flexible(
              flex: 17,
              child: textbox),

            Flexible(
              flex: 3,
              child: button)
            ,
          ]),
          
          state is DownloadCompletedState ? ContentWidget(state.meme) 
            : Center(child: Text("Downloaded meme goes here")),

          //recent downloads
          
        ]),
      );
    });
  }

  Future<String> _getDownloadPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _mapToStatus(DownloadState state) {
    if (state is DownloadIdealState || state is DownloadCompletedState)
      return state.isValid ? ButtonState.success : ButtonState.idle;
    else if (state is DownloadErrorState)
      return ButtonState.fail;
    else if (state is DownloadLoadingState) return ButtonState.loading;
  }
}

class DownloadItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //download
    //share
    //edit

    return Container();
  }
}
