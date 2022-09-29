part of './club_screen.dart';

class TopPanel extends StatefulWidget {
  final Club club;
  const TopPanel({Key? key, required this.club}) : super(key: key);

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  @override
  Widget build(BuildContext context) {
    return widget.club.type != "unknown" ? Container(
      padding: const EdgeInsets.only(left: 35, right: 15, top: 32, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.club.profileImage),
                radius: 46,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.club.name, style: Theme.of(context).textTheme.bodyMedium,),
                  Text(widget.club.website, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kBlue),)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 75, height: 72,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: clubs()[widget.club.type]?['primary_color'] as Color, width: 2),
                      boxShadow: [BoxShadow(
                          color: kBlack.withOpacity(.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4)
                        )],
                      color: kWhite
                    ),
                    child: clubs()[widget.club.type]?['icon'] as Widget,
                  ),
                  Container(
                    width: 75,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: clubs()[widget.club.type]?['primary_color'] as Color, width: 2),
                      color: clubs()[widget.club.type]?['primary_color'],
                      boxShadow: [
                        BoxShadow(
                          color: kBlack.withOpacity(.25),
                          blurRadius: 4,
                          offset: const Offset(0, 4)
                        )
                      ]
                    ),
                    child: Text('See what that means', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kWhite, fontSize: 12),),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: ExpandableText(
              widget.club.description,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.start,
              maxLines: 4,
              expandText: 'show more',
              collapseText: 'show less',
              expandOnTextTap: true,
              collapseOnTextTap: true,
              linkColor: clubs()[widget.club.type]?['primary_color'] as Color,
              animation: true,
              animationDuration: const Duration(milliseconds: 200),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: clubs()[widget.club.type]?['middle_widget'] as Widget
          )
        ],
      ),
    ) : Container();
  }
}
