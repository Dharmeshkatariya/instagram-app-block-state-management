import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/features/comments/presentation/bloc/post/post_state.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import '../../../../../injection_container.dart';
import '../../../../../models/post/post.dart';
import '../../../domain/use_cases/create_post.dart';
import '../../../domain/use_cases/delete/delete_post.dart';
import '../../../domain/use_cases/get/get_all_posts.dart';
import '../../../domain/use_cases/get/get_post_info.dart';
import '../../../domain/use_cases/update/update_post.dart';

class PostCubit extends Cubit<PostState> {
  Post? newPostInfo;
  List<Post>? myPostsInfo;
  List<Post>? userPostsInfo;

  List<Post>? allPostsInfo;

  PostCubit() : super(CubitPostLoading());

  static PostCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createPost(Post postInfo, List<SelectedByte> files,
      {Uint8List? coverOfVideo}) async {
    newPostInfo = null;
    emit(CubitPostLoading());
    await locator
        .call<CreatePostUseCase>()
        .call(paramsOne: postInfo, paramsTwo: files, paramsThree: coverOfVideo)
        .then((postInfo) {
      newPostInfo = postInfo;
      emit(CubitPostLoaded(postInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e.toString()));
    });
  }

  Future<void> getPostsInfo(
      {required List<dynamic> postsIds,
      required bool isThatMyPosts,
      int lengthOfCurrentList = -1}) async {
    emit(CubitPostLoading());
    await locator
        .call<GetPostsInfoUseCase>()
        .call(paramsOne: postsIds, paramsTwo: lengthOfCurrentList)
        .then((postsInfo) {
      if (isThatMyPosts) {
        myPostsInfo = postsInfo;
        emit(CubitMyPersonalPostsLoaded(postsInfo));
      } else {
        userPostsInfo = postsInfo;
        emit(CubitPostsInfoLoaded(postsInfo));
      }
    }).catchError((e) {
      emit(CubitPostFailed(e.toString()));
    });
  }

  Future<void> getAllPostInfo(
      {bool isVideosWantedOnly = false, String skippedVideoUid = ""}) async {
    emit(CubitPostLoading());
    await locator
        .call<GetAllPostsInfoUseCase>()
        .call(paramsOne: isVideosWantedOnly, paramsTwo: skippedVideoUid)
        .then((allPostsInfo) {
      this.allPostsInfo = allPostsInfo;
      emit(CubitAllPostsLoaded(allPostsInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> updatePostInfo({required Post postInfo}) async {
    emit(CubitUpdatePostLoading());
    await locator
        .call<UpdatePostUseCase>()
        .call(params: postInfo)
        .then((postUpdatedInfo) {
      if (myPostsInfo != null) {
        int index = myPostsInfo!.indexOf(postInfo);
        myPostsInfo![index] = postUpdatedInfo;
        emit(CubitMyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(CubitUpdatePostLoaded(postUpdatedInfo));
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }

  Future<void> deletePostInfo({required Post postInfo}) async {
    emit(CubitDeletePostLoading());
    await locator.call<DeletePostUseCase>().call(params: postInfo).then((_) {
      if (myPostsInfo != null) {
        myPostsInfo!
            .removeWhere((element) => element.postUid == postInfo.postUid);
        emit(CubitMyPersonalPostsLoaded(myPostsInfo!));
      }
      emit(CubitDeletePostLoaded());
    }).catchError((e) {
      emit(CubitPostFailed(e));
    });
  }
}
