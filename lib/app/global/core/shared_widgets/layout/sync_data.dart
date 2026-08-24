import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safe2biz/app/global/core/core.dart';
import 'package:safe2biz/app/ui/module_ui.dart';

class SyncDataScreen {
  static void show({
    required BuildContext context,
    String? message,
    required VoidCallback onTap,
    required VoidCallback onClosed,
  })
  {
    showCupertinoModalPopup(
      context: context,
      barrierColor: S2BColors.white,
      barrierDismissible: false,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(S2BSpacing.zero),
        child: _SyncDataWidget(
          message: message,
          onTap: onTap,
          onClosed: onClosed,
        ),
      ),
    );
  }
}

class _SyncDataWidget extends StatefulWidget {

  const _SyncDataWidget({
    Key? key,
    this.message,
    required this.onTap,
    required this.onClosed,
  }) : super(key: key);

  final String? message;
  final VoidCallback onTap;
  final VoidCallback onClosed;



  @override
  State<_SyncDataWidget> createState() => _SyncDataWidgetState();
}



class _SyncDataWidgetState extends State<_SyncDataWidget> {

  @override

  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {


    ElevatedButton ele =  ElevatedButton(
      onPressed: () => widget.onTap,
      child: Text("Ir a Sincronizar"),
    );

    Future.delayed(Duration(milliseconds: 1500), (){
    ele.onPressed?.call();
    widget.onTap;
    });


    return WillPopScope(
      onWillPop: () async {
        Nav.back(context);
        return false;
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            UiValues.couldSyncIconGif,
          ),
          Positioned(
            top: kToolbarHeight,
            right: 10,
            child: IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(
                FontAwesomeIcons.xmark.data,
                size: S2BSpacing.xl,
                color: S2BColors.primaryColor,
              ),
              onPressed: widget.onClosed,
            ),
          ),
          Positioned(
            bottom: 100,
            left: S2BSpacing.lg,
            right: S2BSpacing.lg,
            child: TextLabel.h6(
              widget.message ??
                  'Para continuar primero debes sincronizar la información',
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              color: S2BColors.primaryColor,
            ),
          ),
          Positioned(
            bottom: 20,
            left: S2BSpacing.xl,
            right: S2BSpacing.xl,
            child: Padding(
              padding: const EdgeInsets.only(top: S2BSpacing.md),
              child: ElevatedButton(
                onPressed: widget.onTap,
                child: Text("Ir a Sincronizar"),
              )
            ),
          ),
        ],
      ),
    );
  }
}
