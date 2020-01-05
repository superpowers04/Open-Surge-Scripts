// This is a script that upon pressing Fire5(For me I set it to E in input.defs) will teleport Surge(Or whoever you choose) to the player 
using SurgeEngine.Player;
using SurgeEngine.Actor;
using SurgeEngine.Level;
using SurgeEngine.Vector2;


object "Surge Teleporter" is "companion"
{
    player = parent;
    surge = Player("Surge");

    state "main"
    {
        if(player.input.buttonDown("fire5")) {
            surge.transform.position = player.transform.position;
            surge.speed = player.speed;
            //surge.direction = player.direction;
            if(player.rolling) {
                surge.roll();
            }
            if(player.jumping) {
                surge.roll();
            }
        }
        
    }

}
