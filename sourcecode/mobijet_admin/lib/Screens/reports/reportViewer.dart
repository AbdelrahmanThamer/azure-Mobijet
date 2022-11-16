import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Localization/language_constants.dart';
import 'package:thinkcreative_technologies/Utils/custom_url_launcher.dart';
import 'package:thinkcreative_technologies/Widgets/timeWidgets/getwhen.dart';

void reportViewer(BuildContext context, var doc) {
  var h = MediaQuery.of(context).size.height;
  var w = MediaQuery.of(context).size.width;
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return new Container(
          margin: EdgeInsets.only(top: 0),
          height: h > w ? h / 1.3 : w / 1.2,
          color: Colors.transparent,
          child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getWhen(doc['time']),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            fontSize: 15.9,
                            color: Colors.black87.withOpacity(0.6),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Mycolors.greytext,
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                    // Divider(),
                    SizedBox(height: 10),

                    SizedBox(height: 30),
                    SelectableText(
                      '${getTranslatedForCurrentUser(context, 'xxsentbyxx')}   ' +
                          doc['phone'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          color: Mycolors.purple,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 30),
                    SelectableText(
                      doc['type'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15,
                          color: Mycolors.grey,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      '(${getTranslatedForCurrentUser(context, 'xxidxx')}  ${doc['id']})',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 13,
                          color: Mycolors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    SelectableText(
                      '${getTranslatedForCurrentUser(context, 'xxdescxx')} :',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 15,
                          color: Mycolors.blue,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 10),
                    SelectableLinkify(
                      style: TextStyle(fontSize: 15, height: 1.4),
                      text: doc['desc'],
                      onOpen: (link) async {
                        custom_url_launcher(link.url);
                      },
                    ),
                  ],
                ),
              ))),
        );
      });
}
