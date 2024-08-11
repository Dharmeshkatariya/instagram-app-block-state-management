// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:instagram_dharmesh_bloc_demo/features/auth/presentation/bloc/cubit/auth_cubit.dart';
//
// import '../../../features/comments/presentation/bloc/commentsInfo/cubit/comment_likes/comment_likes_cubit.dart';
// import '../../../features/comments/presentation/bloc/commentsInfo/cubit/comments_info_cubit.dart';
// import '../../../features/comments/presentation/bloc/commentsInfo/cubit/repliesInfo/replyLikes/reply_likes_cubit.dart';
// import '../../../features/comments/presentation/bloc/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
// import '../../../features/comments/presentation/bloc/post/post_cubit.dart';
// import '../../../features/comments/presentation/bloc/postLikes/post_likes_cubit.dart';
// import '../../../features/comments/presentation/bloc/specific_users_posts/specific_users_posts_cubit.dart';
// import '../../../features/messages/presentation/bloc/callingRooms/bloc/calling_status_bloc.dart';
// import '../../../features/messages/presentation/bloc/callingRooms/calling_rooms_cubit.dart';
// import '../../../features/messages/presentation/bloc/message/bloc/message_bloc.dart';
// import '../../../features/messages/presentation/bloc/message/cubit/group_chat/message_for_group_chat_cubit.dart';
// import '../../../features/messages/presentation/bloc/message/cubit/message_cubit.dart';
// import '../../../features/notification/presentation/bloc/notification_cubit.dart';
// import '../../../features/story/presentation/bloc/story_cubit.dart';
// import '../../../features/user/presentation/bloc/add_new_user_cubit.dart';
// import '../../../features/user/presentation/bloc/follow/follow_cubit.dart';
// import '../../../features/user/presentation/bloc/searchAboutUser/search_about_user_bloc.dart';
// import '../../../features/user/presentation/bloc/user_info_cubit.dart';
// import '../../../features/user/presentation/bloc/users_info_cubit.dart';
// import '../../../features/user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';
// import '../../../injection_container.dart';
// import '../../constants/constants.dart';
//
// class MultiBlocs extends StatelessWidget {
//   final Widget materialApp;
//
//   const MultiBlocs(this.materialApp, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(providers: [
//       BlocProvider<AuthCubit>(
//         create: (context) => locator<AuthCubit>(),
//       ),
//       BlocProvider<UserInfoCubit>(
//         create: (context) => locator<UserInfoCubit>(),
//       ),
//       BlocProvider<FireStoreAddNewUserCubit>(
//         create: (context) => locator<FireStoreAddNewUserCubit>(),
//       ),
//       BlocProvider<PostCubit>(
//         create: (context) => locator<PostCubit>()..getAllPostInfo(),
//       ),
//       BlocProvider<FollowCubit>(
//         create: (context) => locator<FollowCubit>(),
//       ),
//       BlocProvider<UsersInfoCubit>(
//         create: (context) => locator<UsersInfoCubit>(),
//       ),
//       BlocProvider<SpecificUsersPostsCubit>(
//         create: (context) => locator<SpecificUsersPostsCubit>(),
//       ),
//       BlocProvider<PostLikesCubit>(
//         create: (context) => locator<PostLikesCubit>(),
//       ),
//       BlocProvider<CommentsInfoCubit>(
//         create: (context) => locator<CommentsInfoCubit>(),
//       ),
//       BlocProvider<CommentLikesCubit>(
//         create: (context) => locator<CommentLikesCubit>(),
//       ),
//       BlocProvider<ReplyLikesCubit>(
//         create: (context) => locator<ReplyLikesCubit>(),
//       ),
//       BlocProvider<ReplyInfoCubit>(
//         create: (context) => locator<ReplyInfoCubit>(),
//       ),
//       BlocProvider<MessageCubit>(
//         create: (context) => locator<MessageCubit>(),
//       ),
//       BlocProvider<MessageBloc>(
//         create: (context) => locator<MessageBloc>(),
//       ),
//       BlocProvider<StoryCubit>(
//         create: (context) => locator<StoryCubit>(),
//       ),
//       BlocProvider<SearchAboutUserBloc>(
//         create: (context) => locator<SearchAboutUserBloc>(),
//       ),
//       BlocProvider<NotificationCubit>(
//         create: (context) => locator<NotificationCubit>(),
//       ),
//       BlocProvider<CallingRoomsCubit>(
//         create: (context) => locator<CallingRoomsCubit>(),
//       ),
//       BlocProvider<CallingStatusBloc>(
//         create: (context) => locator<CallingStatusBloc>(),
//       ),
//       BlocProvider<MessageForGroupChatCubit>(
//         create: (context) => locator<MessageForGroupChatCubit>(),
//       ),
//       BlocProvider<UsersInfoReelTimeBloc>(
//         create: (context1) {
//           if (myPersonalId.isNotEmpty) {
//             return locator<UsersInfoReelTimeBloc>()..add(LoadMyPersonalInfo());
//           } else {
//             return locator<UsersInfoReelTimeBloc>();
//           }
//         },
//       ),
//     ], child: materialApp);
//   }
// }
