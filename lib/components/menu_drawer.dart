import 'package:aesd_app/models/user_model.dart';
import 'package:aesd_app/providers/auth.dart';
import 'package:aesd_app/requests/auth_request.dart';
import 'package:aesd_app/screens/user/dashbord/dashbord.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({super.key, this.pageIndex});

  int? pageIndex;

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  final AuthRequest _authRequest = AuthRequest();

  _refreshUserInfo() async {
    try {
      final response = await _authRequest.getUserInfo();

      final data = response.data;

      Provider.of<Auth>(context, listen: false).setUserData(UserModel.fromJson(data['user']));
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    int pageIndex = widget.pageIndex ?? 0;

    return RefreshIndicator(
        color: kPrimaryColor,
        backgroundColor: Colors.white,
        onRefresh: () => _refreshUserInfo(),
      child: Drawer(
          child: Consumer<Auth>(
              builder: (context, auth, child) {

                String userInitials = "";
                for (var word in auth.user.name.split(" ")){
                  userInitials += word[0];
                }

                return ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(auth.user.name),
                      accountEmail: Text(auth.user.email),
                      decoration: const BoxDecoration(
                        color: kHeaderColor,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        child: Text(
                          userInitials.toUpperCase(),
                          style: GoogleFonts.philosopher(
                            textStyle: TextStyle(
                              fontSize: 40,
                              color: Colors.green.shade800,
                            )
                          )
                        ),
                      ),
                    ),

                    _customTileSection(
                      title: "GENERAL",
                      tiles: [
                        _customTile(
                          title: "Accueil",
                          icon: Icons.home_filled,
                          primaryColor: pageIndex == 0
                        ),
                        if(!auth.user.isFaithful) _customTile(
                          title: "Tableau de bord",
                          icon: Icons.dashboard,
                          primaryColor: pageIndex == 1,
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute( builder: (context) => const Dashbord())
                            );
                          }
                        ),
                        /* _customTile(
                          title: "Mon profil",
                          icon: Icons.person,
                          primaryColor: _pageIndex == 2
                        ) */
                      ]
                    )
                    
                    /* ListTile(
                      leading: Icon(Icons.money, color: Colors.black,),
                      title: const Text('Mes jetons'),
                      trailing: Badge(
                          label: Text(auth.user.totalCoins.toString())
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoinsScreen(),
                          ),
                        );
                      },
                    ), */
                    /*
                    if (auth.user.canManage)
                      ListTile(
                        leading: const Icon(Icons.follow_the_signs_outlined, color: Colors.black,),
                        title: const Text('Suivies'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChurchFollowing(),
                            ),
                          );
                        },
                      ),
                    */

                    /*
                    if (auth.user.canManage)
                      ListTile(
                        leading: const Icon(Icons.live_tv_outlined, color: Colors.black,),
                        title: const Text('Directes'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CoursesFollowing(),
                            ),
                          );
                        },
                      ),
                    */
                    /*ListTile(
                leading: Icon(Icons.settings, color: Colors.black,),
                title: const Text('Paramètres'),
                onTap: () {
                },
              ),*/
                  ],
                );
              })
      ),
    );
  }

  Widget _customTile({
    required String title,
    required IconData icon,
    void Function()? onTap,
    bool primaryColor = false
  }){
    return ListTile(
      leading: Icon(icon),
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: primaryColor ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary
        ),
      ),
      iconColor: primaryColor ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
    );
  }

  Widget _customTileSection({
    required String title,
    required List<Widget> tiles
  }){
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
          ),
          ...tiles
        ],
      ),
    );
  }
}
