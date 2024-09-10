/*
import 'package:agora_uikit/agora_uikit.dart';
import 'package:aesd_app/models/coin_plan_model.dart';
import 'package:aesd_app/models/stream_video_model.dart';
import 'package:aesd_app/requests/course_request.dart';
import 'package:flutter/material.dart';

class StreamAgoraUiKitShow extends StatefulWidget {
  final StreamVideoModel video;

  const StreamAgoraUiKitShow({super.key,  required this.video});

  @override
  State<StreamAgoraUiKitShow> createState() => _StreamAgoraUiKitShowState();
}

class _StreamAgoraUiKitShowState extends State<StreamAgoraUiKitShow> {
  final CourseRequest _courseRequest = CourseRequest();
  final List<CoinPlanModel> _plans = [];
  late AgoraClient client;

  @override
  void initState() {
    super.initState();
    initApp();
    // initAgora();
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

  Future<void> initApp() async {
    try {
      final response = await _courseRequest.playStream(widget.video.slug);

      final data = response.data;

      setState(() {
        data['plans'].forEach((plan) {
          _plans.add(CoinPlanModel.fromJson(plan));
        });
      });

      initAgora(data['uuid'], data['token']);
    } catch (e) {
      ////print(e);
      Navigator.pop(context);
    }
  }

  void initAgora(int uuid, String token) async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "d81bffed7e614cfd91922f8e88a213a1",
        channelName: widget.video.agoraChannelName ?? '',
        tempToken: token,
        uid: uuid,
      ),
      agoraChannelData: AgoraChannelData(
        channelProfileType: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );

    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora UI Kit'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.grid,
              showNumberOfUsers: true,
              // enableHostControls: true, // Add this to enable host controls
            ),
          ],
        ),
      ),
    );
  }
}
*/