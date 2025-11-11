import 'package:flutter/material.dart';
import 'package:utility/utils/app_fonts.dart';

import 'device_card.dart';
class DeviceSection extends StatefulWidget {
  const DeviceSection({super.key,
    required this.rooms,
    required this.title});
  final String title;
  final Map<String,List<DeviceCard>>rooms;

  @override
  State<DeviceSection> createState() => _DeviceSectionState();
}

class _DeviceSectionState extends State<DeviceSection> {
  bool _isExpanded =true;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,style: w400_14Poppins(color: Color(0xff11217D)),
              ),
              IconButton(icon:
              Icon(_isExpanded?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                color: Colors.brown,
              ),
                onPressed: (){
                  setState(() {
                    _isExpanded =!_isExpanded;
                  });
                },
              ),
            ],
          ),),
        if(_isExpanded)
          ...widget.rooms.entries.map((entry){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    entry.key,
                    style:w300_14Poppins(color: Colors.black),
                  ),),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: entry.value.map((device){
                        return SizedBox(
                          width: MediaQuery.of(context).size.width*0.42,
                          child: device,
                        );
                      }).toList()
                  ),)
                ,
              ],
            );
          }),

      ],);
  }
}
