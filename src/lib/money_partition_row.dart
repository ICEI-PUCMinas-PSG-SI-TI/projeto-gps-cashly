import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MoneyPartitionRow extends StatelessWidget {
  final double percentage;
  final double totalValue;
  final String name;
  final double radius = 60.0;
  
  const MoneyPartitionRow({
    super.key,
    required this.percentage,
    required this.name,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context){
    return Row (

      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        CircularPercentIndicator (
          radius: radius,
          lineWidth: 10,
          progressColor: Colors.lightBlue,
          percent: percentage,
          circularStrokeCap: CircularStrokeCap.round,
          center: Text (
            'R\$${(totalValue*percentage).toString()}',
            style: TextStyle (
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
          
            children: [
              
              Text (
                name,
                style: TextStyle (
                  fontSize: 25
                ),
              ),
          
              Text (
                'R\$${totalValue.toStringAsFixed(2)}',
          
                style: TextStyle (
                  fontSize: 20,
                ),
              )
            ],
          ),
        )

      ],
      
    );
  }
}

//TODO: Consertar o problema dos textos (eles não estao centralizados seguindo um padrão)