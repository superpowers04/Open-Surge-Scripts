// Based off of the dropdash script here http://opensnc.sourceforge.net/forum/viewtopic.php?pid=15681#p15681
// This is an example of the Dropdash that has some calculations for speed
// It also contains a dash if the player is underwater, To disable, Comment lines 65,66 and 67
//


using SurgeEngine.Level;
using SurgeEngine.Vector2;
using SurgeEngine.Audio.Sound;
using SurgeEngine.Player;




object "Drop Dash" is "companion"
{
    player = parent;   // since this object is configured as a
    Player = parent;  // companion, parent is the reference
                     // to the correct Player object
    charge = Sound("samples/charge.wav");
    release = Sound("samples/release.wav");
    rollsound = Sound("samples/roll.wav");


    // capture the event
    state "main"
    {
        // player is jumping but NOT holding jump
        if(player.jumping) {
            if(!player.input.buttonDown("fire1")) {
                state = "watching the jump";
            } 
        }
        else if (!player.jumping && player.midair && !player.rolling && player.input.buttonDown("fire1") && !player.dying && !player.frozen && !player.hit) { //Check if player is not rolling but is in midair, Not dead, frozen or jumping
            rollsound.play();
            player.roll(); // Roll
        }

    }

    // player is jumping; watch if he holds the jump button
    state "watching the jump"
    {
        // player is jumping, not dying, not frozen, not being damaged, doesn't have a thunder shield, AND holding jump

        if(player.jumping && !player.dying && !player.frozen && !player.hit && player.shield != "thunder") {

            if(player.input.buttonDown("fire1")) {

                charge.play();
                state = "ready to dash";
                player.anim = 20; // Comment/uncomment this to add/remove the dropdash animation
            }

        }
        else
            state = "main";
    }

    // wait to get on the ground
    state "ready to dash"
    {
        if(!player.midair || player.underwater) { // Remove "|| player.underwater" to disable jump dashing underwater
            player.roll(); // make the player roll
            if (player.underwater) {
                player.speed = speed() * player.direction; // Dash underwater, comment these 3 lines to disable jump dashing underwater
            }
            else 
                player.gsp = speed() * player.direction; // Dash normally on ground
            release.play();
            spawnSmoke();
            state = "main"; 
        }
        else if(!player.input.buttonDown("fire1"))
            state = "main"; // cancel the dash

        else {
            player.anim = 20;
        }
    }

    
    fun speed()
    {
        if (player.turbo) {
            ddefspeed = 1000; //Default turbo speed
        }
        else if (player.underwater) {
            ddefspeed = 400; //Default underwater speed 
        }
        else 
            ddefspeed = 600; //Default speed
        //hlfsped = player.speed / 2; Half of the players speed
        angl = player.angle * player.direction;
        ang2 = 360 * player.direction;
        ang3 = ang2 - angl;
        retrnddspeed = 0;
        if(player.angle <= 30 && player.angle >= 330  ) {
            retrnddspeed = ddefspeed; // Default speed on normal angles
        }

        else if(player.angle <= 180) {
            retrnddspeed = ddefspeed - angl; //Speed for angles 30 to 180
        } 
        else if (player.angle >= 180) {
            retrnddspeed = ddefspeed - ang3; //Speed for angles 180 330
        }
        else{
            retrnddspeed = ddefspeed; // default speed, Just in case the above are all somehow false
        }


        return retrnddspeed; // Returns speed

        // you may use more sophisticated computations for the speed:
        // https://forums.sonicretro.org/index.php?threads/how-the-drop-dash-works-in-mania.37587/
    }
    fun spawnSmoke() 
    {
        if(!player.midair) {
            Level.spawnEntity(
                "Speed Smoke",
                Vector2(
                    player.collider.center.x - player.direction * 22,
                    player.collider.bottom - 3
                )
            ).setDirection(player.direction);
        }
    }
}
