import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/tokenpage.dart';
import 'package:upi_india/upi_india.dart';

FirebaseFirestore firebaseref = FirebaseFirestore.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test UPI',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String hospitalName;
  final DateTime dateTime;
  final String location;
  HomePage({this.hospitalName, this.location, this.dateTime});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<UpiResponse> _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;

  @override
  void initState() {
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    super.initState();
  }

  Future<UpiResponse> initiateTransaction(String app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: '8247572140@PAYTM',
      receiverName: 'Medifly',
      transactionRefId: 'TestingUpiIndiaPlugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 10.00,
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps.length == 0)
      return Center(child: Text("No apps found to handle transaction."));
    else
      return Center(
        child: Wrap(
          children: apps.map<Widget>((UpiApp app) {
            return GestureDetector(
              onTap: () {
                _transaction = initiateTransaction(app.app);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.memory(
                      app.icon,
                      height: 60,
                      width: 60,
                    ),
                    Text(app.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColorBlue,
        title: Center(child: Text('Payment', textAlign: TextAlign.center)),
      ),
      body: Column(
        children: <Widget>[
          Container(child: displayUpiApps()),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('An Unknown error has occured'),
                    );
                  }
                  UpiResponse _upiResponse;
                  _upiResponse = snapshot.data;
                  if (_upiResponse.error != null) {
                    String text = '';
                    switch (snapshot.data.error) {
                      case UpiError.APP_NOT_INSTALLED:
                        text = "Requested app not installed on device";
                        break;
                      case UpiError.INVALID_PARAMETERS:
                        text = "Requested app cannot handle the transaction";
                        break;
                      case UpiError.NULL_RESPONSE:
                        text = "requested app didn't returned any response";
                        break;
                      case UpiError.USER_CANCELLED:
                        text = "You cancelled the transaction";
                        break;
                    }
                    return Center(
                      child: Text(text),
                    );
                  }
                  String txnId = _upiResponse.transactionId;
                  String resCode = _upiResponse.responseCode;
                  String txnRef = _upiResponse.transactionRefId;
                  String status = _upiResponse.status;
                  String approvalRef = _upiResponse.approvalRefNo;
                  switch (status) {
                    case UpiPaymentStatus.SUCCESS:
                      print('Transaction Successful');
                      break;
                    case UpiPaymentStatus.SUBMITTED:
                      print('Transaction Submitted');
                      break;
                    case UpiPaymentStatus.FAILURE:
                      print('Transaction Failed');
                      break;
                    default:
                      print('Received an Unknown transaction status');
                  }
                  return status == 'success'
                      ? SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          backgroundColor: Colors.green,
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            Center(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () {firebaseref.collection('token_data').add({
                        'hospitalName': widget.hospitalName,
                        'address': widget.location,
                        'day': '${widget.dateTime.day}',
                        'month': '${widget.dateTime.month}',
                        'year': '${widget.dateTime.year}',
                      });
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TokenScreen(
                                          day: '${widget.dateTime.day}',
                                          month: '${widget.dateTime.month}',
                                          year: ' ${widget.dateTime.year}',
                                          hospitalname: widget.hospitalName,
                                          address: widget.location),
                                    ),
                                  );
                                },
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                  child: Text(
                                    'Proceed',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          title: Text(
                            'Transaction Succes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      : SimpleDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          backgroundColor: Colors.red,
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            Center(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                elevation: 0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          title: Text(
                            'Transaction Failed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        );
                  // Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[Text('Transation Failed')],
                  //   );
                } else
                  return Text(' ');
              },
            ),
          )
        ],
      ),
    );
  }
}
