import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Utils/color_light_dark.dart';

Widget customCircleAvatar({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Color(0xffE6E6E6),
      radius: radius ?? 30,
      child: Icon(
        Icons.person,
        size: radius != null ? radius * 1.5 : 27,
        color: Colors.white,
      ),
    );
  } else {
    return CircleAvatar(
      backgroundColor: Color(0xffE6E6E6),
      radius: radius ?? 30,
      backgroundImage: NetworkImage('$url'),
    );
  }
}

Widget customNotification(
    {Color? color, double? radius = 20, IconData? iconData}) {
  return CircleAvatar(
    backgroundColor: darken(Mycolors.primary, 0.04),
    radius: radius,
    child: Icon(
      iconData ?? Icons.notifications,
      size: radius ?? 22 / 1.6,
      color: color ?? Mycolors.white,
    ),
  );
}

Widget customCircleAvatarGroup({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Mycolors.greylightcolor,
      radius: radius ?? 30,
      child: Icon(
        Icons.people,
        color: Colors.white,
      ),
    );
  } else {
    return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              backgroundImage: NetworkImage('$url'),
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              child: Icon(
                Icons.people,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              child: Icon(
                Icons.people,
                color: Colors.white,
              ),
            ));
  }
}

Widget customCircleAvatarBroadcast({String? url, double? radius}) {
  if (url == null || url == '') {
    return CircleAvatar(
      backgroundColor: Mycolors.greylightcolor,
      radius: radius ?? 30,
      child: Icon(
        Icons.campaign_sharp,
        color: Colors.white,
      ),
    );
  } else {
    return CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              backgroundImage: NetworkImage('$url'),
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              child: Icon(
                Icons.campaign_sharp,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Mycolors.greylightcolor,
              radius: radius ?? 30,
              child: Icon(
                Icons.campaign_sharp,
                color: Colors.white,
              ),
            ));
  }
}
