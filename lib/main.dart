import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  runApp(coffee_app());
}

class coffee_app extends StatefulWidget {
  @override
  _coffee_appState createState() => _coffee_appState();
}

class _coffee_appState extends State<coffee_app> {
  @override
  final controller = TextEditingController();
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  int tipPercentage = 0;
  double totalAmt = 0;
  double quantity = 0;
  double chocolate = 0;
  double cream = 0;
  double amt = 0;

  void tipDecrement() {
    setState(() {
      tipPercentage--;
    });
  }

  void tipIncrement() {
    setState(() {
      tipPercentage++;
    });
  }

  void calculate() {
    setState(() {
      totalAmt = chocolate + cream;
    });
  }

  sendMail() async {
    String username = 'dimplekakkar18@gmail.com';
    String password = 'imiitian';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'dimple')
      ..recipients.add('dimplekakkar18@gmail.com')
      ..ccRecipients
          .addAll(['dimplekakkar18@gmail.com', 'dimplekakkar18@gmail.com'])
      ..bccRecipients.add(Address('dimplekakkar18@gmail.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1>Order Summary</h1>\n<p>Name - Dimple\n chocolate +whipped icecream\n Total Amount = 90</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    final equivalentMessage = Message()
      ..from = Address(username, 'Your name 😀')
      ..recipients.add(Address('dimplekakkar18.com'))
      ..ccRecipients
          .addAll([Address('dimplekakkar18.com'), 'dimplekakkar18.com'])
      ..bccRecipients.add('dimplekakkar18@gmail.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>';

    final sendReport2 = await send(equivalentMessage, smtpServer);

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message
    await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Coffe Shopping App'),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 70,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                ),
              ),
              Text('Toppings'),
              SizedBox(
                height: 70,
                width: 70,
              ),
              Row(
                children: [
                  Checkbox(
                      value: checkBoxValue1,
                      onChanged: (bool value) {
                        if (value) {
                          setState(() {
                            checkBoxValue1 = value;
                            cream = 40;
                          });
                        } else {
                          setState(() {
                            checkBoxValue1 = value;
                            cream = 0;
                          });
                        }
                      }),
                  Text("Whipped Cream")
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: checkBoxValue2,
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            checkBoxValue2 = value;
                            chocolate = 50;
                          });
                        } else {
                          setState(() {
                            checkBoxValue2 = value;
                            chocolate = 0;
                          });
                        }
                      }),
                  Text("Chocolate")
                ],
              ),
              Text("Quantity"),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    tipDecrement();
                  },
                  child: Icon(Icons.remove_circle)),
              SizedBox(
                width: 10,
              ),
              Text("${tipPercentage}%"),
              GestureDetector(
                  onTap: () {
                    print("abcd");
                    tipIncrement();
                  },
                  child: Icon(Icons.add_circle)),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    calculate();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  )),
              SizedBox(
                height: 16,
              ),
              quantity != 0
                  ? Text("  Name = $controller\n quantity =  $quantity")
                  : Container(),
              SizedBox(
                height: 8,
              ),
              Text("    totalAmount = $totalAmt" + "\nThank You"),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      bool checkBoxValue1 = false;
                      bool checkBoxValue2 = false;
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMail();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        "Email Order",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
