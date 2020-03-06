import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leonpierre_mememaker/blocs/components/share/events.dart';
import 'package:leonpierre_mememaker/blocs/components/share/sharebloc.dart';
import 'package:leonpierre_mememaker/blocs/components/share/states.dart';

class ShareWidget extends StatelessWidget {
  ShareWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareBloc, ShareState>(
        condition: (previousState, current) {
          //previousState.
          return previousState != current;
        },
        builder: (BuildContext context, ShareState state) {
          
      if (state is ShareHiddenState)
        return Container();
      else if (state is ShareIdealState)
        return Container(
          decoration: BoxDecoration(color: Colors.black45),
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.white70,
                      onPressed: () {
                        
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shop),
                      color: Colors.white70,
                      onPressed: () {
                        
                      },
                    )
                  ],
                ),
              ),
              onTap: () =>
                BlocProvider.of<ShareBloc>(context)..add(ShareOptionsDismissedEvent())
              ),
        );
    
    return null;
    });
  }
}
