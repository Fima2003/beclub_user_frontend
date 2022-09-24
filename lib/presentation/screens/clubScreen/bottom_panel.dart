part of './club_screen.dart';

class BottomPanel extends StatefulWidget {
  final String type;
  final List<LoyaltyPromotion> promotions;
  const BottomPanel({Key? key, required this.type, required this.promotions}) : super(key: key);

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: clubs()![widget.type]['primary_color'] as Color,
            width: 2
          )
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("Promotions", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: clubs()![widget.type]['primary_color'] as Color),textAlign: TextAlign.center,)
          ),
          Expanded(
            child: widget.promotions.isNotEmpty ? GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              children: widget.promotions.map(
                (promotion){
                  return Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(promotion.mediaUrl),
                                fit: BoxFit.cover
                            ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        width: 40,
                        height: 40,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: clubs(height: 40, width: 40)[widget.type]['promotion_icon'],
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  promotion.points.toString(), style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kWhite, fontSize: 10),
                                ),
                              ),
                            )
                          ],
                        )
                      ),
                    ],
                  );
                }
              ).toList(),
            )
                : Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: const Text("This club has no promotions so far", textAlign: TextAlign.center, style: TextStyle(fontSize: 25),)
                  ),
                ),
          )
        ],
      ),
    );
  }
}
