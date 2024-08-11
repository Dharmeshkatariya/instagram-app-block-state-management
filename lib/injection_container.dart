



import 'export.dart';
import 'feature_export.dart';


import 'features/messages/data/data_sources/remote/calling_room/calling_room_network_db.dart';
import 'features/messages/data/data_sources/remote/group_chat/group_chat_network_db.dart';
import 'features/messages/data/data_sources/remote/single_chat/single_chat_network_db.dart';
import 'features/messages/data/repository/calling_rooms_repo_impl.dart';
import 'features/messages/data/repository/group_message_repo_impl.dart';
import 'features/messages/domain/repository/group_message.dart';
import 'features/messages/domain/use_cases/calling_rooms/cancel_joining_to_room.dart';
import 'features/messages/domain/use_cases/calling_rooms/create_calling_room.dart';
import 'features/messages/domain/use_cases/calling_rooms/delete_the_room.dart';
import 'features/messages/domain/use_cases/calling_rooms/get_calling_status.dart';
import 'features/messages/domain/use_cases/calling_rooms/get_users_info_in_room.dart';
import 'features/messages/domain/use_cases/calling_rooms/join_to_calling_room.dart';
import 'features/messages/domain/use_cases/common/get_specific_chat_info.dart';
import 'features/messages/domain/use_cases/group_message/add_message.dart';
import 'features/messages/domain/use_cases/group_message/delete_message.dart';
import 'features/messages/domain/use_cases/group_message/get_messages.dart';
import 'features/messages/domain/use_cases/single_message/add_message.dart';
import 'features/messages/domain/use_cases/single_message/delete_message.dart';
import 'features/messages/domain/use_cases/single_message/get_chat_users_info.dart';
import 'features/messages/domain/use_cases/single_message/get_messages.dart';
import 'features/messages/presentation/bloc/callingRooms/bloc/calling_status_bloc.dart';
import 'features/messages/presentation/bloc/callingRooms/calling_rooms_cubit.dart';
import 'features/messages/presentation/bloc/message/bloc/message_bloc.dart';
import 'features/messages/presentation/bloc/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'features/messages/presentation/bloc/message/cubit/message_cubit.dart';
import 'features/notification/data/data_sources/remote/device_notification_db/device_notification_db.dart';
import 'features/notification/data/data_sources/remote/device_notification_db/device_notification_impl.dart';
import 'features/notification/data/data_sources/remote/firebase_notification/firebase_notification_db.dart';
import 'features/notification/data/data_sources/remote/firebase_notification/firebase_notification_db_impl.dart';
import 'features/notification/data/repository/firestore_notification_impl.dart';
import 'features/notification/domain/use_cases/create_notification_use_case.dart';
import 'features/notification/domain/use_cases/delete_notification.dart';
import 'features/notification/domain/use_cases/get_notifications_use_case.dart';
import 'features/story/data/data_sources/remote/firebase_story_network_db.dart';
import 'features/story/data/data_sources/remote/firebase_story_network_db_impl.dart';
import 'features/story/data/repository/story_repo_impl.dart';
import 'features/story/domain/repository/story_repo.dart';
import 'features/story/domain/use_cases/create_story.dart';
import 'features/story/domain/use_cases/delete_story.dart';
import 'features/story/domain/use_cases/get_specific_stories.dart';
import 'features/story/domain/use_cases/get_stories_info.dart';
import 'features/story/presentation/bloc/story_cubit.dart';
import 'features/user/data/data_sources/remote/firestore_user_db.dart';
import 'features/user/data/data_sources/remote/firestore_user_network_db_impl.dart';
import 'features/user/data/repository/user_repository_impl.dart';
import 'features/user/domain/repository/user_repository.dart';
import 'features/user/domain/use_cases/add_new_user_usecase.dart';
import 'features/user/domain/use_cases/add_post_to_user.dart';
import 'features/user/domain/use_cases/follow/follow_this_user.dart';
import 'features/user/domain/use_cases/follow/remove_this_follower.dart';
import 'features/user/domain/use_cases/getUserInfo/get_all_un_followers_info.dart';
import 'features/user/domain/use_cases/getUserInfo/get_all_users_info.dart';
import 'features/user/domain/use_cases/getUserInfo/get_followers_and_followings_usecase.dart';
import 'features/user/domain/use_cases/getUserInfo/get_user_from_user_name.dart';
import 'features/user/domain/use_cases/getUserInfo/get_user_info_usecase.dart';
import 'features/user/domain/use_cases/my_personal_info.dart';
import 'features/user/domain/use_cases/search_about_user.dart';
import 'features/user/domain/use_cases/upload_profile_image_usecase.dart';
import 'features/user/presentation/bloc/add_new_user_cubit.dart';
import 'features/user/presentation/bloc/follow/follow_cubit.dart';
import 'features/user/presentation/bloc/searchAboutUser/search_about_user_bloc.dart';
import 'features/user/presentation/bloc/user_info_cubit.dart';
import 'features/user/presentation/bloc/users_info_cubit.dart';
import 'features/user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

//:::::::::::::::::::::::::::::::::::::::  Auth  ::::::::::::::::::::::::::::::::::::::::::*/

  // Firebase auth useCases
  locator.registerLazySingleton<LogInAuthUseCase>(
      () => LogInAuthUseCase(locator()));

  locator.registerLazySingleton<SignUpAuthUseCase>(
      () => SignUpAuthUseCase(locator()));

  locator.registerLazySingleton<SignOutAuthUseCase>(
      () => SignOutAuthUseCase(locator()));

  locator.registerLazySingleton<EmailVerificationUseCase>(
      () => EmailVerificationUseCase(locator()));

  //repostory-auth

  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authNetworkDB: locator()));

  //network-auth

  locator.registerLazySingleton<AuthNetworkDB>(() => AuthNetworkDbImpl());

  //bloc-auth
  locator.registerFactory<AuthCubit>(
    () => AuthCubit(),
  );
//:::::::::::::::::::::::::::::::::::::::  Comments   ::::::::::::::::::::::::::::::::::::::::::*/

  //network-Comments

  locator
      .registerLazySingleton<CommentsNetworkDb>(() => CommentsNetworkDbImpl());
  locator.registerLazySingleton<FireStorePostNetworkDb>(
      () => FireStorePostNetworkDbImpl());
  locator.registerLazySingleton<FireStoreReplyNetworkDb>(
      () => FireStoreReplyNetworkDbImpl());

  //repository-Comments

  locator.registerLazySingleton<FireStoreCommentRepository>(
      () => FireStoreCommentRepositoryImpl(firestoreComment: locator()));
  locator.registerLazySingleton<FireStorePostRepository>(
      () => FireStorePostRepositoryImpl(firestorePost: locator()));
  locator.registerLazySingleton<FireStoreReplyRepository>(
      () => FireStoreRepliesRepositoryImpl(firestoreReply: locator()));

  //use cases comments
  locator.registerLazySingleton<GetSpecificCommentsUseCase>(
      () => GetSpecificCommentsUseCase(locator()));
  locator.registerLazySingleton<PutLikeOnThisReplyUseCase>(
      () => PutLikeOnThisReplyUseCase(locator()));
  locator.registerLazySingleton<RemoveLikeOnThisReplyUseCase>(
      () => RemoveLikeOnThisReplyUseCase(locator()));
  locator.registerLazySingleton<GetRepliesOfThisCommentUseCase>(
      () => GetRepliesOfThisCommentUseCase(locator()));
  locator.registerLazySingleton<ReplyOnThisCommentUseCase>(
      () => ReplyOnThisCommentUseCase(locator()));
  locator.registerLazySingleton<AddCommentUseCase>(
      () => AddCommentUseCase(locator()));
  locator.registerLazySingleton<PutLikeOnThisCommentUseCase>(
      () => PutLikeOnThisCommentUseCase(locator()));
  locator.registerLazySingleton<RemoveLikeOnThisCommentUseCase>(
      () => RemoveLikeOnThisCommentUseCase(locator()));

  //  post  //

  locator.registerLazySingleton<DeletePostUseCase>(
      () => DeletePostUseCase(locator()));
  locator.registerLazySingleton<GetAllPostsInfoUseCase>(
      () => GetAllPostsInfoUseCase(locator()));
  locator.registerLazySingleton<GetPostsInfoUseCase>(
      () => GetPostsInfoUseCase(locator()));
  locator.registerLazySingleton<GetSpecificUsersPostsUseCase>(
      () => GetSpecificUsersPostsUseCase(locator()));
  locator.registerLazySingleton<PutLikeOnThisPostUseCase>(
      () => PutLikeOnThisPostUseCase(locator()));
  locator.registerLazySingleton<RemoveTheLikeOnThisPostUseCase>(
      () => RemoveTheLikeOnThisPostUseCase(locator()));
  locator.registerLazySingleton<UpdatePostUseCase>(
      () => UpdatePostUseCase(locator()));
  locator.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(locator()));

  //bloc-comments

  locator.registerFactory<CommentLikesCubit>(
    () => CommentLikesCubit(),
  );
  locator.registerFactory<CommentsInfoCubit>(
    () => CommentsInfoCubit(),
  );

  //bloc-reply

  locator.registerFactory<ReplyLikesCubit>(
    () => ReplyLikesCubit(),
  );

  //bloc-post

  locator.registerFactory<PostCubit>(
    () => PostCubit(),
  );

  locator.registerFactory<PostLikesCubit>(
    () => PostLikesCubit(),
  );

  locator.registerFactory<SpecificUsersPostsCubit>(
    () => SpecificUsersPostsCubit(),
  );

//::::::::::::::::          Messages           :::::::::::::::::::::*/

  //network-Messages

  locator.registerLazySingleton<CallingRoomNetworkDb>(
      () => CallingRoomNetworkDbImpl());
  locator.registerLazySingleton<GroupChatNetworkDb>(
      () => GroupChatNetworkDbImpl());
  locator.registerLazySingleton<SingleChatNetworkDb>(
      () => SingleChatNetworkDbImpl());

  //repository-Messages

  locator.registerLazySingleton<CallingRoomsRepository>(
      () => CallingRoomsRepoImpl(fireStoreCallingRoom: locator()));

  locator.registerLazySingleton<FireStoreGroupMessageRepository>(
      () => FirebaseGroupMessageRepoImpl(firestoreGroupChat: locator()));

  //use cases -Messages

  //use cases calling room
  locator.registerLazySingleton<CancelJoiningToRoomUseCase>(
      () => CancelJoiningToRoomUseCase(locator()));
  locator.registerLazySingleton<CreateCallingRoomUseCase>(
      () => CreateCallingRoomUseCase(locator()));
  locator.registerLazySingleton<DeleteTheRoomUseCase>(
      () => DeleteTheRoomUseCase(locator()));
  locator.registerLazySingleton<GetCallingStatusUseCase>(
      () => GetCallingStatusUseCase(locator()));
  locator.registerLazySingleton<GetUsersInfoInRoomUseCase>(
      () => GetUsersInfoInRoomUseCase(locator()));
  locator.registerLazySingleton<JoinToCallingRoomUseCase>(
      () => JoinToCallingRoomUseCase(locator()));

  //use cases common

  locator.registerLazySingleton<GetSpecificChatInfo>(
      () => GetSpecificChatInfo(locator()));

  //use cases group messages

  locator.registerLazySingleton<AddMessageForGroupChatUseCase>(
      () => AddMessageForGroupChatUseCase(locator()));
  locator.registerLazySingleton<DeleteMessageForGroupChatUseCase>(
      () => DeleteMessageForGroupChatUseCase(locator()));
  locator.registerLazySingleton<GetMessagesGroGroupChatUseCase>(
      () => GetMessagesGroGroupChatUseCase(locator()));

  //use cases single messages
  locator.registerLazySingleton<AddMessageUseCase>(
      () => AddMessageUseCase(locator()));
  locator.registerLazySingleton<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(locator()));
  locator.registerLazySingleton<GetChatUsersInfoAddMessageUseCase>(
      () => GetChatUsersInfoAddMessageUseCase(locator()));
  locator.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(locator()));

  //bloc-messages

  locator.registerFactory<CallingStatusBloc>(
    () => CallingStatusBloc(),
  );
  locator.registerFactory<CallingRoomsCubit>(
    () => CallingRoomsCubit(),
  );
  locator.registerFactory<MessageBloc>(
    () => MessageBloc(),
  );

  locator.registerFactory<MessageForGroupChatCubit>(
    () => MessageForGroupChatCubit(),
  );

  locator.registerFactory<MessageCubit>(
    () => MessageCubit(),
  );

//::::::::::::::::          Notification            :::::::::::::::::::::*/

  //network-notification

  locator.registerLazySingleton<DeviceNotificationDb>(
      () => DeviceNotificationImpl());
  locator.registerLazySingleton<FirebaseNotificationDb>(
      () => FirebaseNotificationDbImpl());

  //repository-notification

  locator.registerLazySingleton<FireStoreNotificationRepository>(
      () => FireStoreNotificationRepoImpl(firestoreNotification: locator()));

  //use cases - notification
  locator.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCase(locator()));
  locator.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(locator()));
  locator.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(locator()));

  //bloc-notification

  locator.registerFactory<NotificationCubit>(
    () => NotificationCubit(),
  );
//::::::::::::::::          Story             :::::::::::::::::::::*/

  //network-Story

  locator.registerLazySingleton<FirebaseStoryNetworkDb>(
      () => FirebaseStoryNetworkDbImpl());

  //repository-Story

  locator.registerLazySingleton<FireStoreStoryRepository>(
      () => FireStoreStoryRepositoryImpl(fireStoreStory: locator()));

  //use cases - Story
  locator.registerLazySingleton<CreateStoryUseCase>(
      () => CreateStoryUseCase(locator()));
  locator.registerLazySingleton<DeleteStoryUseCase>(
      () => DeleteStoryUseCase(locator()));
  locator.registerLazySingleton<GetSpecificStoriesInfoUseCase>(
      () => GetSpecificStoriesInfoUseCase(locator()));
  locator.registerLazySingleton<GetStoriesInfoUseCase>(
      () => GetStoriesInfoUseCase(locator()));
//bloc-Story

  locator.registerFactory<StoryCubit>(
    () => StoryCubit(),
  );
//::::::::::::::::          User              :::::::::::::::::::::*/

  //network-User

  locator.registerLazySingleton<FireStoreUserDb>(
      () => FireStoreUserNetworkDbImpl());

  //repository-User

  locator.registerLazySingleton<FireStoreUserRepository>(
      () => UserRepositoryImpl(userNetworkDb: locator()));

  //use cases - User

  locator.registerLazySingleton<FollowThisUserUseCase>(
      () => FollowThisUserUseCase(locator()));
  locator.registerLazySingleton<UnFollowThisUserUseCase>(
      () => UnFollowThisUserUseCase(locator()));
  locator.registerLazySingleton<GetAllUnFollowersUseCase>(
      () => GetAllUnFollowersUseCase(locator()));
  locator.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(locator()));
  locator.registerLazySingleton<GetFollowersAndFollowingsUseCase>(
      () => GetFollowersAndFollowingsUseCase(locator()));
  locator.registerLazySingleton<GetSpecificUsersUseCase>(
      () => GetSpecificUsersUseCase(locator()));
  locator.registerLazySingleton<GetUserFromUserNameUseCase>(
      () => GetUserFromUserNameUseCase(locator()));
  locator.registerLazySingleton<GetUserInfoUseCase>(
      () => GetUserInfoUseCase(locator()));
  locator.registerLazySingleton<AddNewUserUseCase>(
      () => AddNewUserUseCase(locator()));
  locator.registerLazySingleton<AddPostToUserUseCase>(
      () => AddPostToUserUseCase(locator()));
  locator.registerLazySingleton<GetMyInfoUseCase>(
      () => GetMyInfoUseCase(locator()));
  locator.registerLazySingleton<SearchAboutUserUseCase>(
      () => SearchAboutUserUseCase(locator()));

  locator.registerLazySingleton<UpdateUserInfoUseCase>(
      () => UpdateUserInfoUseCase(locator()));
  locator.registerLazySingleton<UploadProfileImageUseCase>(
      () => UploadProfileImageUseCase(locator()));

  //bloc-User

  locator.registerFactory<FollowCubit>(
    () => FollowCubit(),
  );

  locator.registerFactory<SearchAboutUserBloc>(
    () => SearchAboutUserBloc(),
  );

  locator.registerFactory<UsersInfoReelTimeBloc>(
    () => UsersInfoReelTimeBloc(),
  );
  locator.registerFactory<FireStoreAddNewUserCubit>(
    () => FireStoreAddNewUserCubit(),
  );

  locator.registerFactory<UserInfoCubit>(
    () => UserInfoCubit(),
  );
  locator.registerFactory<UsersInfoCubit>(
    () => UsersInfoCubit(),
  );
}
