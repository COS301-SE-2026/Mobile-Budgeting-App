import 'package:budgetit/utils/app_colour.dart';
import 'package:flutter/material.dart';
//import 'package:popover/popover.dart';

class FABMenu extends StatefulWidget {
  const FABMenu({Key? key}) : super(key: key);

  @override
  State<FABMenu> createState() => _FABMenuState();
}

class _FABMenuState extends State<FABMenu> {
  bool isHover1 = false;
 bool isHover2 = false;
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: MyColours().secondary, 
      padding: EdgeInsets.all(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () => {},
                    onHover: (isHovering) => setState(() { isHover1 = isHovering;
                      
                    }),
                    child: Container(
                      
                      decoration: BoxDecoration(
                        color: isHover1? MyColours().background : MyColours().secondary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColours().background, width: 2, style: BorderStyle.solid  ),
                        
                      ),
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Add Transaction',
                        style: TextStyle(color: isHover1? MyColours().secondary : MyColours().background),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: () => {},
                    onHover: (isHovering) => setState(() { isHover2 = isHovering;
                      
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                         color: isHover2? MyColours().background :  MyColours().secondary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColours().background, width: 2, style: BorderStyle.solid  ),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Import PDF/CSV',
                        style: TextStyle(color: isHover2 ? MyColours().secondary : MyColours().background),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
    );
  }
}
