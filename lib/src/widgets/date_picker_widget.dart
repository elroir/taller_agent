
import 'package:flutter/material.dart';


class DatePickerWidget extends StatefulWidget {

  final TextEditingController controller;
  final String initialValue;
  final double height;
  final double width;


  DatePickerWidget({this.controller,this.height,this.width,this.initialValue});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {

  bool _above18=false;
  String _date;

  @override
  void initState() {
    _date = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if (_date!=''&&_date!=null){
      List<String> list = widget.controller.text.split('/');

      int year = int.parse(list.removeLast());
      int month = int.parse(list.removeLast());
      int day = int.parse(list.removeLast());

      if(DateTime.now().year-year>18)
        _above18 = true;
      else
        _above18 = false;

      if ((DateTime.now().year-year==18)&&(DateTime.now().month-month)>0){
        _above18 = true;
      }else{
        if ((DateTime.now().year-year==18)&&((DateTime.now().month-month)==0)&&((DateTime.now().day-day)>=0)){
          _above18 = true;
        }
      }

      setState(() {
        _date = "${day.toString()}/${month.toString()}/${year.toString()}";
        widget.controller.text = _date;
      });
    }

    return Container(
        height: widget.height,
        width: widget.width==null ? size.width *0.63 : widget.width,
        child: TextFormField(
          enableInteractiveSelection: false ,
          controller: widget.controller,
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
            _selectDate(context);
          },
          validator: (value) {
            if (value.length==0)
              return 'La fecha de nacimiento es obligatoria';
            if (!_above18)
              return 'Necesita ser mayor de edad';
            return null;
          },
        )
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1910),
        lastDate: new DateTime.now(),

        locale: Locale('es','ES')
    );

    if (picked != null){
      if(DateTime.now().year-picked.year>18)
        _above18 = true;
      else
        _above18 = false;

      if ((DateTime.now().year-picked.year==18)&&(DateTime.now().month-picked.month)>0){
        _above18 = true;
      }else{
        if ((DateTime.now().year-picked.year==18)&&((DateTime.now().month-picked.month)==0)&&((DateTime.now().day-picked.day)>=0)){
          _above18 = true;
        }
      }

      setState(() {
        _date = "${picked.day.toString()}/${picked.month.toString()}/${picked.year.toString()}";
        widget.controller.text = _date;
      });
    }


  }

}
