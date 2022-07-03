import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/widgets/onboarding.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _controller;
  bool isLast = false;

  List<BoardingModel> pages = [
    const BoardingModel(
      title: "متطلبات العقار",
      body:
      "تستطيع من خلال التطبيق معرفة جميع متطلبات العقار  والتواصل مع مالك العقار",
      image: "assets/images/onboarding3.png",
    ),
    const BoardingModel(
      title: "احصل على زبونك بسهولة",
      body:
      "يمكنك عرض عقارك ومتطلباته للبيع او الايجار واحصل على الزبون المناسب",
      image: "assets/images/onboarding2.png",
    ),
    const BoardingModel(
      title: "تصفح العقارات",
      body:
      "الالاف من العقارات المعروضة في منطقتك مصممة خصيصاً لمتطلباتك",
      image: "assets/images/onboarding1.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: pages.length-1);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[index],
                onPageChanged: (int index){
                  if(index == 0){
                    setState(() {
                      isLast = true;
                    });
                  }else{
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      splashColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        if(isLast){
                          Navigator.pushReplacementNamed(context, "login");
                        }else{
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                        }
                      },
                      label: const Text("التالي", style: TextStyle(color: Colors.white)),
                    ),
                    Expanded(
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: pages.length,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            expansionFactor: 2,
                            dotWidth: 10,
                            dotHeight: 10,
                            spacing: 5,
                            activeDotColor: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "login");
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                            (states) => const EdgeInsets.all(10)),
                      ),
                      child: Text(
                        "تخطي",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
