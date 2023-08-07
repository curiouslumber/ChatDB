import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Elements/checkinternet.dart';
import 'controller.dart';

class ChatFragment extends StatelessWidget {
  ChatFragment({super.key});

  final Controller c = Get.put(Controller());
  final CheckInternet p = Get.put(CheckInternet());
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 8.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(right: 16.0),
              alignment: Alignment.centerRight,
              child: const Text(
                'Connected',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontFamily: 'Ubuntu', color: Color(0xffFFCFA3)),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Row(children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: const EdgeInsets.only(right: 4.0),
                              alignment: Alignment.center,
                              child: Obx(
                                () => TextField(
                                  controller: textEditingController,
                                  style: const TextStyle(fontSize: 14),
                                  cursorColor:
                                      const Color.fromARGB(255, 85, 193, 89),
                                  decoration: InputDecoration(
                                    hintText: c.userMessage.value
                                        ? 'Enter your message...'
                                        : (p.activeConnection.value
                                            ? 'Please wait...'
                                            : 'Not Connected'),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 1.0),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2.0),
                                    ),
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    fillColor: c.userMessage.value
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.2),
                                    filled: true,
                                    enabled: c.userMessage.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: MaterialButton(
                              onPressed: () async {
                                await p.checkUserConnection();
                                if (p.activeConnection.value) {
                                  if (c.userMessage.value == false) {
                                    c.userMessage.value = true;
                                  }
                                  String message = textEditingController.text;
                                  if (message.isNotEmpty) {
                                    c.userMessagesObx.add(message);
                                    if (c.messageCount.value == 1) {
                                      c.userMessageIndexesObx.removeAt(0);
                                      c.userMessagesObx.removeAt(0);
                                    }
                                    c.messageCount.value += 1;
                                    c.userMessageIndexesObx
                                        .add(c.messageCount.value - 1);
                                    textEditingController.clear();
                                    c.userMessage.value = false;
                                    c.processUsertoAI(message);
                                    c.aioruser.add("user");
                                  }
                                } else {
                                  c.userMessage.value = false;
                                }
                              },
                              height: 60,
                              color: Colors.green,
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
