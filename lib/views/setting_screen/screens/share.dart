import 'package:flutter/material.dart';
import 'package:mnh/widgets/share_btn.dart';


class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key,});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ShareBtn(iconColor: Colors.indigo, controller: _controller);
  }
}
