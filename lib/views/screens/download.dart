import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/download/download_bloc.dart';
import 'package:path_provider/path_provider.dart';
import'dart:io' show Platform;

class DownloadPage extends StatefulWidget {
  final DownloadBloc _downloadBloc;

  const DownloadPage(this._downloadBloc, {Key key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    //textbox

    //top 10 recent downloads

    //view all shows all images from meme download folder

    //ad

    return BlocBuilder<DownloadBloc, DownloadState>(
        builder: (BuildContext context, DownloadState state) {
      if (state is DownloadLoadingState)
        return Center(child: CircularProgressIndicator());
      else if (state is DownloadErrorState)
        return Center(child: Text(state.message));
      else if (state is DownloadIdealState)
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(4.0),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  //errorText: errorText ?? errorText,
                  hintText: 'url'),
              keyboardType: TextInputType.url,
              validator: (value) => state.isValid ? null : 'errorText',
              onChanged: (value) =>
                  widget._downloadBloc.add(DownloadUrlChangedEvent(value)),
            ),

            IconButton(icon: Icon(Icons.download_rounded), 
              onPressed: () async => await _getDownloadPath()
                .then((path) => widget._downloadBloc.add(DownloadRequestEvent('', path))))
          ],
        );
    });
  }

  Future<String> _getDownloadPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}

class DownloadItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //download
    //share
    //edit


    return Container(
      
    );
  }
}
