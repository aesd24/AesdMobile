/*

import 'package:agora_uikit/agora_uikit.dart';
//import 'package:aesd_app/models/coin_plan_model.dart';
import 'package:aesd_app/models/stream_video_model.dart';
//import 'package:aesd_app/requests/course_request.dart';
import 'package:flutter/material.dart';

class StreamLaunched extends StatefulWidget {
  final StreamVideoModel video;

  const StreamLaunched({super.key, required this.video});

  @override
  State<StreamLaunched> createState() => _StreamLaunchedState();
}

class _StreamLaunchedState extends State<StreamLaunched> {
  //final CourseRequest _courseRequest = CourseRequest();
  //final List<CoinPlanModel> _plans = [];
  late AgoraClient client;

  @override
  void initState() {
    super.initState();
    initAgora();
  }
  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await client.engine.leaveChannel();
    await client.engine.release();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "d81bffed7e614cfd91922f8e88a213a1",
        channelName: widget.video.agoraChannelName ?? '',
        tempToken: widget.video.agoraToken,
        uid: widget.video.agoraChannelId,
      ),
      agoraChannelData: AgoraChannelData(
        channelProfileType: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true,
              showNumberOfUsers: true,
            ),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}

*/