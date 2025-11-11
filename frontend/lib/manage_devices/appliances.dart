import'package:flutter/material.dart';




void main()=> runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: SelectAppliances(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SelectAppliances extends StatefulWidget {
  const SelectAppliances({super.key});

  @override
  State<SelectAppliances> createState() => _SelectAppliancesState();
}

class _SelectAppliancesState extends State<SelectAppliances> {
  List<Map<String, String>> Appliances = [
    {
      "product": "Samsung",
      "usage": "Air Conditioner",
    },
    {
      "product": "Secondary Lights",
      "usage": "Smart Bulb",
    },
    {
      "product": "Primary Lights",
      "usage": "Philips Lamp",
    },
    {
      "product": "Home Theater",
      "usage": "Sony",
    },
    {
      "product": "Curtain 1",
      "usage": "Smart Curtains",
    },
    {
      "product": "Sony Tv",
      "usage": "Television",
    },
    {
      "product": "Alexa Speaker",
      "usage": "Speakers",
    },
  ];

  Set<String> selectedAppliances = {
    'Samsung',"Secondary Lights","Primary Lights",'Home Theater',"Curtain 1","Sony Tv", "Alexa Speaker"
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed:()=>Navigator.pop(context), icon: Icon(Icons.arrow_back),),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Select Appliances",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "I'm Out",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: Appliances.length,
                itemBuilder: (context, index) {
                  final item = Appliances[index];
                  final isSelected = selectedAppliances.contains(item["product"]);
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        if (isSelected){
                          selectedAppliances.remove(item["product"]);
                        }
                        else{
                          selectedAppliances.add(item["product"]!);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color:isSelected?Color(0xFFD4AE7B):Colors.grey.shade300,
                              width : isSelected?2:1),
                          boxShadow: [
                            BoxShadow(
                              color:Colors.black12,
                              blurRadius:4,
                              offset:Offset(2,2),
                            )
                          ]
                      ),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item["product"]??"",style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height : 4),
                              Text(item["usage"]??"",style: TextStyle(color:Colors.grey,fontSize: 12),)
                            ],

                          ),
                          Icon(
                            isSelected?Icons.check_circle:Icons.radio_button_unchecked,
                            color: isSelected?Color(0xFFD4AE7B):Colors.grey,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              ),
              Padding(padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFFD4AE7B),shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                        minimumSize: Size(double.infinity,50
                        )
                    ),onPressed: (){}, child: Text('Continue',style: TextStyle(
                    fontSize: 16,color: Colors.white
                ),)),)
            ],
          ),) ,

      ),
      backgroundColor: Colors.white,
    );
  }
}
