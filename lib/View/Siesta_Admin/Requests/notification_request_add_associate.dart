import 'package:flutter/material.dart';
import 'package:siestaamsapp/Model/Request_Model/notificationRequest_model.dart';
import 'package:siestaamsapp/Utils/Routes/routes_name.dart';
import 'package:siestaamsapp/constants/string_res.dart';

class NotfReqItemAddAssociate extends StatefulWidget {
  final NotificationRequests? item;
  final Function? reloadParent;
  final bool openDetailPage;

  NotfReqItemAddAssociate({
    Key? key,
    this.item,
    this.reloadParent,
    this.openDetailPage = true,
  }) : super(key: key);

  @override
  State<NotfReqItemAddAssociate> createState() =>
      NotfReqItemAddAssociateState();
}

class NotfReqItemAddAssociateState extends State<NotfReqItemAddAssociate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.openDetailPage
          ? null
          : () {
              Navigator.pushNamed(context, RoutesName.cameraScreen)
                  .then((value) {
                if (value == null || !(value is bool)) {
                  return;
                }
                if ((value as bool)) {
                  try {
                    widget.reloadParent!();
                  } catch (e) {
                    print(e);
                  }
                }
              }).catchError((e) {
                print(e);
              });
            },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            child: RichText(
              text: TextSpan(
                  text:
                      '${widget.item!.createdByName}(${widget.item!.createdByMobile})\n',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${AppString.get(context).wantsToAdd()}: ',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                    ),
                    TextSpan(
                      text: AppString.get(context).associateMember(),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
