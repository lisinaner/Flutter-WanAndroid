import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/components/disclaimer_msg.dart';
import 'package:flutter_wanandroid/components/list_view_item.dart';
import 'package:flutter_wanandroid/components/list_refresh.dart' as listComp;
import 'package:flutter_wanandroid/components/pagination.dart';
import 'package:flutter_wanandroid/views/search_page/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';




class HomePage extends StatefulWidget {
  @override
  FirstPageState createState() => new FirstPageState();
}

class FirstPageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _unKnow;
  GlobalKey<DisclaimerMsgState> key;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (key == null) {
      key = GlobalKey<DisclaimerMsgState>();
      //获取sharePre
      _unKnow = _prefs.then((SharedPreferences prefs) {
        return (prefs.getBool('disclaimer::Boolean') ?? false);
      });

      /// 判断是否需要弹出免责声明,已经勾选过不在显示,就不会主动弹
      _unKnow.then((bool value) {
        new Future.delayed(const Duration(seconds: 1),(){
          if (!value) {
            key.currentState.showAlertDialog(context);
          }
        });
      });
    }
  }


  /// 列表中的卡片item
  Widget makeCard(index,item){

    var mId = item.id;
    var mTitle = '${item.title}';
    var mShareUserName = '${'👲'}: ${item.shareUser} ';

    if(item.shareUser == ""){
      mShareUserName = '${'👲'}: ${item.author} ';
    }
    var mLikeUrl = '${item.link}';
    var mNiceDate = '${'🔔'}: ${item.niceDate}';
    return new ListViewItem(itemId: mId, itemTitle: mTitle, itemUrl:mLikeUrl,itemShareUser: mShareUserName, itemNiceDate: mNiceDate);
  }

  /// banner
  headerView(){
    return
      Column(
        children: <Widget>[
          Stack(
              children: <Widget>[
                // banner
                Pagination(),
                Positioned(//方法二
                    top: 10.0,
                    left: 0.0,
                    child: DisclaimerMsg(key:key,pWidget:this)
                ),
              ]),
          SizedBox(height: 1, child:Container(color: Theme.of(context).primaryColor)),
          SizedBox(height: 10),
        ],
      );

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: new AppBar(title: SearchPage(),),
      body: new Column(
          children: <Widget>[
            SizedBox(height: 2, child:Container(color: Theme.of(context).primaryColor)),
            new Expanded(
                child: listComp.ListRefresh(makeCard,headerView)
            )
          ]

      ),
    );
  }
}


