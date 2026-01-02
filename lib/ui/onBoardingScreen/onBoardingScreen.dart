import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../configs/dimension.dart';
import '../../supports/utils/sharedPreferenceManager.dart';
import '../authenticationScreen/login_register_tab_view.dart';
import '../custom/customProceedButton.dart';
import 'onBoardingInstance.dart';
import 'onBoardingList/onBoardingListData.dart';

class OnBoardingScreen extends StatefulWidget {
  final AppDatabase appDatabase;
  const OnBoardingScreen({super.key, required this.appDatabase});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  PageController controller = PageController(initialPage: 0, keepPage: true);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!.round();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<OnBoardingData> onBoardingData = <OnBoardingData>[
      OnBoardingData(
          title: 'Note Down Expenses',
          description:
          'Daily note your expenses to help manage money',
          image: 'assets/images/onBoardingScreen1.jpg'),
      OnBoardingData(
          title: 'Simple Money Management',
          description:
          'get your notification or alert when you do the over expenses',
          image: 'assets/images/onBoardingScreen1.jpg'),
      OnBoardingData(
          title: 'Easy to Track and Analyze',
          description:
          'Track your expenses to help prevent from overspend',
          image: 'assets/images/onBoardingScreen3.png')
    ];

    final pages = List.generate(onBoardingData.length,
            (index) => OnBoardingInstance(onBoardingData: onBoardingData[index]));

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Stack(
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    height: height * .8,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: pages.length,
                      itemBuilder: (_, index) {
                        return pages[index % pages.length];
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding, horizontal: padding),
                    child: GestureDetector(
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () {
                        SharedPreferenceManager.setWalkthroughShown(true);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRegisterView(appDatabase: widget.appDatabase,)));
                      },
                    ),
                  ),
                ],
              ),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: ExpandingDotsEffect(
                    dotHeight: 7,
                    dotWidth: 7,
                    activeDotColor: Colors.greenAccent
                  // strokeWidth: 5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: GestureDetector(
                  onTap: (){
                    if (currentPage == pages.length - 1) {
                      SharedPreferenceManager.setWalkthroughShown(true);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRegisterView(appDatabase: widget.appDatabase,)));
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: CustomProceedButton(
                    titleName: currentPage == pages.length - 1 ? "Let's Start" : "Next",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
