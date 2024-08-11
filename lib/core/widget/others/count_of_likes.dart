import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../features/user/presentation/screen/users_who_likes_for_mobile.dart';
import '../../../features/user/presentation/screen/users_who_likes_for_web.dart';
import '../../../models/post/post.dart';
import '../../constants/constants.dart';
import '../../routes/getnav.dart';
import '../../routes/hero_dialog_route.dart';
import '../../utils/strings_manager.dart';

class CountOfLikes extends StatelessWidget {
  final Post postInfo;
  const CountOfLikes({super.key, required this.postInfo});

  @override
  Widget build(BuildContext context) {
    int likes = postInfo.likes.length;

    return InkWell(
      onTap: () {
        if (isThatMobile) {
          Go(context).push(
              page: UsersWhoLikesForMobile(
            showSearchBar: true,
            usersIds: postInfo.likes,
            isThatMyPersonalId: postInfo.publisherId == myPersonalId,
          ));
        } else {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => UsersWhoLikesForWeb(
                usersIds: postInfo.likes,
                isThatMyPersonalId: postInfo.publisherId == myPersonalId,
              ),
            ),
          );
        }
      },
      child: Text(
          '$likes ${likes > 1 ? StringsManager.likes.tr : StringsManager.like.tr}',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
