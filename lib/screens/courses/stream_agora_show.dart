/*
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:aesd_app/exceptions/http_form_validation_exception.dart';
import 'package:aesd_app/models/coin_plan_model.dart';
import 'package:aesd_app/models/stream_video_model.dart';
import 'package:aesd_app/requests/course_request.dart';
import 'package:aesd_app/services/web/course_service.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StreamAgoraShow extends StatefulWidget {
  final StreamVideoModel video;

  const StreamAgoraShow({super.key, required this.video});

  @override
  State<StreamAgoraShow> createState() => _StreamAgoraShowState();
}

class _StreamAgoraShowState extends State<StreamAgoraShow> {
  int? _remoteUid;
  final RtcEngine _engine = createAgoraRtcEngine();
  final CourseRequest _courseRequest = CourseRequest();
  final List<CoinPlanModel> _plans = [];
  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    initApp();
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

      await initAgora(data['uuid'], data['token']);
    } catch (e) {
      ////print(e);
      Navigator.pop(context);
    }
  }

  Future<void> initAgora(int uuid, String token) async {
    await _engine.initialize(const RtcEngineContext(
      appId: "d81bffed7e614cfd91922f8e88a213a1",
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          ////print("local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (remoteUid == widget.video.agoraChannelId) {
            setState(() {
              _remoteUid = remoteUid;
            });
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          if (remoteUid == widget.video.agoraChannelId) {
            setState(() {
              _remoteUid = null;
            });
          }
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          //print('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token';
        },
      ),
    );

    await _engine.enableVideo();

    // await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);

    _engine.joinChannel(
      token: token,
      channelId: widget.video.agoraChannelName ?? '',
      uid: uuid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    // await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _sendCoin(int coinId) async {
    try {
        await _courseService.sendCoin(slug: widget.video.slug, coinId: coinId);

        Fluttertoast.showToast(
          msg: 'Jeton envoyé avec succès.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: kDangerColor,
          textColor: kWhiteColor,
          fontSize: 13.0,
        );
    } on HttpFormValidationException catch (e) {
      final errors = e.getErrors();

      if (errors['coin_id'] != null) {
        Fluttertoast.showToast(
          msg: "Vous n'avez pas suffisamment de jeton. Pensez a recharger votre compte.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: kDangerColor,
          textColor: kWhiteColor,
          fontSize: 13.0,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Oups quelques choses s'est mal passé",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: kDangerColor,
        textColor: kWhiteColor,
        fontSize: 13.0,
      );
    } finally {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title),
      ),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _remoteVideo(),
              ),
            ),
            /* Positioned(
              bottom: 10,
              left: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(height: MediaQuery.of(context).size.height * 0.20),
                  items: _plans.map((plan) {

                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () async => await  _sendCoin(plan.id),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                                children: [
                                  ListTile(
                                  leading: Icon(Icons.money),
                                  title: Text(plan.value.toString()),
                                  subtitle: Text(
                                    plan.name,
                                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                              ]
                            )
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child:  Consumer<Auth>(
                builder: (context, auth, child) {
                return Badge(
                  textColor: Colors.white,
                  backgroundColor: Colors.red,
                  label: Text(auth.user.totalCoins.toString()),
                );
              })
            ), */
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.video.agoraChannelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
*/