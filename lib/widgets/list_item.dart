import 'package:flutter/material.dart';
import 'package:pingping/providers/app_provider.dart';
import 'package:provider/provider.dart';

class ListItem extends StatelessWidget {
  final int _index;
  AppProvider _appProvider;

  ListItem(this._index);

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    return Dismissible(
      key: Key('$_index'),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
        //  alignment: Alignment.centerRight,
      ),
      onDismissed: (DismissDirection direction) async {
        await _appProvider.dbProvider.deleteUrl(_appProvider.urls[_index]);
        _appProvider.urls.removeAt(_index);
      },
      child: FutureBuilder(
        future: _appProvider.ping(_appProvider.urls[_index]),
        builder: (BuildContext context, AsyncSnapshot<int> response) {
          if (response.connectionState != ConnectionState.done) {
            return ListTile(
              title: Text(_appProvider.urls[_index]),
              trailing: CircularProgressIndicator(
                strokeWidth: 1,
              ),
              subtitle: Text('Checking...'),
              leading: CircleAvatar(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.jpg',
                  image: '${_appProvider.urls[_index]}/favicon.ico',
                  width: 25,
                  height: 25,
                  fit: BoxFit.fill,
                ),
                backgroundColor: Colors.white,
                radius: 25,
              ),
            );
          }
          return ListTile(
            title: Text(_appProvider.urls[_index]),
            trailing:
                response.data == 0 ? Icon(Icons.check) : Icon(Icons.clear),
            subtitle: Text(response.data == 0 ? 'Up' : 'Down'),
            leading: CircleAvatar(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.jpg',
                image: '${_appProvider.urls[_index]}/favicon.ico',
                width: 25,
                height: 25,
                fit: BoxFit.fill,
              ),
              backgroundColor: Colors.white,
              radius: 25,
            ),
          );
        },
      ),
    );
  }
}
