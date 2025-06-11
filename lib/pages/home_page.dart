import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  String _barcodeData = '1234567890';
  int _selectedBarcodeIndex = 0;

  final List<BarcodeOption> _barcodeTypes = [
    BarcodeOption('Code 128', Barcode.code128()),
    BarcodeOption('Code 39', Barcode.code39()),
    BarcodeOption('Code 93', Barcode.code93()),
    BarcodeOption('EAN-13', Barcode.ean13()),
    BarcodeOption('EAN-8', Barcode.ean8()),
    BarcodeOption('QR Code', Barcode.qrCode()),
    BarcodeOption('Data Matrix', Barcode.dataMatrix()),
    BarcodeOption('PDF417', Barcode.pdf417()),
  ];

  Barcode get _selectedBarcodeType =>
   _barcodeTypes[_selectedBarcodeIndex].barcode;

   @override
   void initState() {
    super.initState();
    _textController.text = _barcodeData;
   }

   void _generateBarcode() {
    setState(() {
      _barcodeData = _textController.text.isEmpty
          ? '1234567890'
          : _textController.text;
    });

void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _barcodeData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode is Copied')),
    );
  }

  Widget _buildBarcodeWidget() {
    try {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // This changes position of shadow
            ),
          ],
        ),
        child: BarcodeWidget(
          barcode: _selectedBarcodeType,
          data: _barcodeData,
          width: 300,
          height: 100,
          style: const TextStyle(
            fontSize: 12.0,
          ),
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 48.0,
              SizedBox(height: 8.0),
              Text(
                'Invalid Barcode Data',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),

              Text(
                'Please confirm your input or try different BarCode',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              )
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBar(
        title: Text(
          'Bar Gen',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Input product data',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Enter barcode data',
                          hintText: 'Enter Product Data, SKU, or Code',
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.circular(8.0),                            
                          ),
                          prefix: Icon(
                            Icons.qr_code,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _textController.clear();
                              });
                            },
                            icon: Icon(
                              icons.clear,
                            ),
                          ),
                        ),
                        
                        onChanged: _generateBarcode(),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Barcode Type',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8.0),

                      const Container(
                        padding: EdgeInsets.symmetric(horizontal: 11.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),

                          borderRadius: BorderRadius.circular(8.0),
                        ),

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: _selectedBarcodeIndex,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                            ),
                            items: _barcodeTypes.asMap().entries.map(entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(
                                  entry.value.name,
                                ),
                              );
                            }
                          ).toList(),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedBarcodeIndex = newValue;
                                
                              });
                            }
                          }

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Generated Barcode',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          IconButon(
                            onPressed: _copyToClipboard,
                            icon: Icon(
                              Icons.copy,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                )
              )
            ],
          )
        )
      )
    );
  }
}
}
class BarcodeOption {
  final String name;
  final Barcode barcode;

  BarcodeOption(this.name, this.barcode);
}

class Barcode {
}