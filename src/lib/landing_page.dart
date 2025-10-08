import 'package:flutter/material.dart';

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
            
            // Money Placeholder
            
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

            Placeholder (
              fallbackHeight: 550,
            )
          ],
        ),
      ),
    );
  }
}