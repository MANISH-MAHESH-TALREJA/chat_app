import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_chat_app/screen/video_picker/controller/controller.dart';
import 'package:flutter_web_chat_app/screen/video_picker/video_picker_view_model.dart';
import 'package:flutter_web_chat_app/utils/app.dart';
import 'package:flutter_web_chat_app/utils/color_res.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class VideoPickerScreen extends StatelessWidget {
  VideoController videoController = Get.put(VideoController());

  VideoPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoPickerScreenViewModel>.reactive(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorRes.white,
            title: Row(
              children: [
                const Text(
                  "Select Videos",
                  style: TextStyle(color: ColorRes.black),
                ),
                const SizedBox(width: 10),
                Obx(() => Text(
                      "(${videoController.selectedVideoList.length} / 10)",
                      style: const TextStyle(color: ColorRes.black),
                    )),
                const Spacer(),
                Obx(
                  () => videoController.selectedVideoList.isNotEmpty
                      ? InkWell(
                          onTap: videoController.onSend,
                          child: const Text(
                            "Send",
                            style: TextStyle(color: ColorRes.green),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: ColorRes.black,
              ),
            ),
          ),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                controller: model.scrollController,
                itemCount: model.videoList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      videoController.onVideoSelect(model.videoList[index]);
                      //model.onVideoSelect(model.videoList[index]);
                    },
                    child: FutureBuilder(
                        future: model.videoList[index]
                            .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Image.memory(
                                        //model.videoAvatar[index],
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5, bottom: 5),
                                        child: Icon(
                                          Icons.videocam,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => videoController
                                              .selectedVideoList
                                              .contains(
                                                  model.videoList[index])
                                          ? Container(
                                              color: ColorRes.green
                                                  .withOpacity(0.3),
                                              height: 200,
                                              width: 200,
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -0.7, 0.7),
                                              child: const Icon(
                                                Icons.check_circle,
                                              ),
                                            )
                                          : Container(),
                                    )
                                  ],
                                )
                              : Image.asset(AssetsRes.galleryImage,color: ColorRes.green.withOpacity(0.5),);
                        }),
                  );
                },
              ),
        );
      },
      viewModelBuilder: () => VideoPickerScreenViewModel(),
    );
  }
}
