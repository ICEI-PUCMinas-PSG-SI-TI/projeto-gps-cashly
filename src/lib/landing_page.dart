import 'package:flutter/material.dart';
import 'money_partition_row.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold (
      
      appBar: AppBar (
      
        title: Text('Cashly'),
        centerTitle: true,

        leading: IconButton (
            onPressed: () => print('Menu'),
            icon: Icon (
              Icons.menu
            )
          ),

        actions: [
          IconButton (
            onPressed: () => print('Perfil'),
            icon: Icon (
              Icons.person_2_rounded,
            ),
          ),
        ],
      ),

      body: Padding (
        padding: EdgeInsets.all(18.0),

        child: Column (
          
          spacing: 25,

          children: [
            
            // Main Finance Row
            Row (

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
                Text (
                  'R\$7500,00',
                  style: TextStyle (
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),

                IconButton (
                  onPressed: () => print('Change Value'), 
                  icon: Icon (
                    Icons.edit
                  )
                )
              
              ],
            ),

            SizedBox(height: 20),

            // Partitions of the Main Money
            MoneyPartitionRow (
              name: 'Alimentação',
              percentage: 0.7,
              totalValue: 2250,
            ),

            MoneyPartitionRow (
              name: 'Transporte',
              percentage: 0.5,
              totalValue: 2000,
            ),

            MoneyPartitionRow (
              name: 'Assinaturas',
              percentage: 0.3,
              totalValue: 1750,
            ),

            MoneyPartitionRow (
              name: 'Lazer',
              percentage: 0.9,
              totalValue: 1750,
            ),
          ],
        ),
      ),
    );
  }
}