import 'package:flutter/material.dart';
import 'game_logic.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String res = '';
  Game game = Game();
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Text("It's $activePlayer player turn",style: const TextStyle(
              color: Colors.white, fontSize: 52
          ),textAlign: TextAlign.center,),
          Expanded(child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            children: List.generate(9, (index){
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: gameOver ? null : () => _onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blueAccent
                  ),
                  child: Center(child: Text(Player.playerX.contains(index) ?
                  'X' : Player.playerO.contains(index) ?
                    'O' : '',style: TextStyle(
                      color: Player.playerX.contains(index) ?
                      Colors.red : Colors.green, fontSize: 42
                  ),textAlign: TextAlign.center,),)),
                );
            })
          )),
          Text(res,style: const TextStyle(
              color: Colors.white, fontSize: 42
          ),textAlign: TextAlign.center,),
          ElevatedButton.icon(onPressed: (){
            setState(() {
              Player.playerO = [];
              Player.playerX = [];
              activePlayer = 'X';
              gameOver = false;
              turn = 0;
              res = '';
            });
          },icon: const Icon(Icons.replay)
              , label: const Text('Repeat the game'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white)
            ),
          )
        ],
      ),
    );
  }

  _onTap(int index) async{

    if((!Player.playerX.contains(index) || Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) || Player.playerO.isEmpty)){
      game.playGame(index, activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;

      String winnerPlayer = game.checkWinner();
      if(winnerPlayer != '')
        {
          gameOver = true;
          res = '$winnerPlayer is the winner';
        }
      else if(!gameOver && turn == 9){
        res = "It's draw";
      }
    });
  }
}
