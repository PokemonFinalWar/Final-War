#===============================================================================
# * Config Script For Your Game Here. Change the emo_ to what ever number is 
#        the cell holding the animation.
#===============================================================================
Unused_Common_Event         = 5		  #Common event should be blank, but reserved
Following_Activated_Switch = 126      # Switch should be reserved
Toggle_Following_Switch = 103         # Switch should be reserved
Current_Following_Variable = 36       # Variable should be reserved
ItemWalk=26                           # Variable should be reserved
Walking_Time_Variable = 27            # Variable should be reserved
Walking_Item_Variable = 28            # Variable should be reserved
Animation_Come_Out = 93               
Animation_Come_In = 94
Emo_Happy = 95
Emo_Normal = 96
Emo_Hate = 97
Emo_Poison= 98
Emo_sing= 99
Emo_love= 100

# * Support for Pokemon Birthsigns script
Emo_Cake= 92 if self.class.const_defined?(:PBBirthsigns) &&  self.class.const_get(:PBBirthsigns).instance_of?(::Module)

ALLOWTOGGLEFOLLOW = true             # Allow the player to toggle followers on/off
ALLOWFIELDSWITCHING = true          # Allow the player to cycle through pokemon
APPLYSTATUSTONES = true# Add tone to follower if statused
#Status tones to be used, if the above is true (Red,Green,Blue,Gray)
BURNTONE = [204,51,51,50]
POISONTONE = [153,102,204,50]
PARALYSISTONE = [255,255,153,50]
FREEZETONE = [153,204,204,50]
SLEEPTONE = [0,0,0,0]  # I did not use this tone, but you may if you wish
ALWAYS_ANIMATE  = true #Follower sprite will always animated while standing still
#Regardless of the above setting,the species in this array will always animate 
ALWAYS_ANIMATED_FOLLOWERS=[151]  # Mew
#Add exclusions to always animated (small birds like Pidgey mostly hop, due to small wings)
ALWAYS_ANIMATED_EXCEPTION=[16] #Pidgey
#Removed for now
#REGULAR_WALKING = true  
WATERPOKEMONCANSURF = true  # Allow water pokemon to follow the player while surfing
WATERPOKEMONCANDIVE = true #Allow water pokemon to follow the player while diving
ALWAYS_ANIMATED_CAN_SURF = true #Pokemon that are always animated can follow you 
                                # across water (flying, levitating, or specified)

#Don't change
FOLLOWER_FILE_PATH = "Graphics/Characters/"
#The subfolder where your follower sprites are located
#Has to be within Graphics/Characters
FOLLOWER_FILE_DIR = ""
                                            

#===============================================================================
# * Credit to Help-14 for both the original scripts and sprites
# * Change Log:
#===============================================================================

#===============================================================================
# * Edited by zingzags
#===============================================================================
# * Fixed bugs
# * Clean ups
# * Fixed Surf Bug (After Surf is done)
# * Fixed def talk_to_pokemon while in surf
# * Fixed Surf Check
# * Fixed Type Check
# * Added Door Support
# * Fixed Hp Bug
# * Added Pokemon Center Support
# * Animation problems
# * Fixed Walk_time_variable problem
# * Added random item loot
# * Added egg check
#===============================================================================

#===============================================================================
# * Edited by Rayd12smitty
# * Version 1.0
#===============================================================================
# * Fixed Walk_Time_Variable
# * Fixed crash when talking to Pokemon on a different map than the original
#   they appeared on
# * Receiving Items from Pokemon now works
# * Improved Talk_to_Pokemon wiht more messages and special messages
# * Added messages for all Status Conditions
# * Added Party Rotation to switch follower
# * Made Following Pokemon Toggleable
# * Added Animation for Pokemon coming out of Pokeball in sprite_refresh
# * Tidied up script layout and made more user friendly
# * Fixed Issues with Pokemon jumping around on ledges
# * Fixed Badge for Surf Typo in the script
#===============================================================================
# * Version 1.1
#===============================================================================
# * Fixed Surfing so Pokemon doesn't reappear on water when toggled off
# * Changed Layout and location of Toggle Script
#===============================================================================

#===============================================================================
# * Edited by Rayd12smitty and venom12
# * Version 1.2
#===============================================================================
# * Fixed Walk step count so it doesn't add on when Pokemon is toggled off
# * No longer have to manually set Toggle_Following_Switch and
#   Following_Activated_Switch whenever "pbPokemonFollow(x)" is called
# * Now supports Pokemon with multiple forms
# * Items found on specific maps support
# * Support for messages when on a map including a word/phrase in its name
#   rather than a single map
# * Added stepping animation for follower
# * Fixed dismount bike so Pokemon reappears
# * Fixed bike so if it couldn't be used it now can
# * Few other small bike fixes
#===============================================================================

#===============================================================================
# * Version 1.3
#===============================================================================
# * Fixed bug with surf where the Follower could block the player from being
#   able to surf, possibly stranding the player
# * Added script to animate all events named "Poke"
# * Increased time to find an item. I realize now that 5000 frames is less than
#   5 min. Way too short.
#===============================================================================

#===============================================================================
# * Edited by mej71
# * Version 1.4
#===============================================================================
# * Combined all into one script section for ease of installation
# * Added setting to allow/disallow cycling through pokemon in field
# * Added tone effect to following pokemon if statused
# * Fixed follower grass animations
# * NPCs won't walk over the follower
# * Fixed crash caused by toggling follower when loading a map sometimes
# * Prevent some HM usage when having a nonfollower dependent event
#   so hopefully this will lead more towards support for regular dependent events
# * Your followers don't automatically turn when you do, so it looks more natural
# * There's a setting now to make pokemon always animate while you're standing still
#   Note that flying, levitating, or any pokemon species specified will always animate
#   regardless of this setting
# *Reflected sprites support for followers
# *Player transfer works a bit better, your follower shouldn't appear on top of 
#  you anymore
# *There's a setting that allows water pokemon to follow you over water
# *Additional setting allows flying, levitating, or other pokemon species to also
#  follow you over water
# *Sprite refreshes after evolution
# *Blacking out won't cause errors
# *v15.1 compatability
# *Followers walk cycle works properly
# *Move routes work properly (they worked in old versions, but were temporarily 
#  broken in my version)
# *Pokemon get put away when transferring to a bike only map
# *Follower gets checked when going underwater (water pokemon can follow underwater)
# * Support for Pokemon Birthsigns script
#===============================================================================

#===============================================================================
# * To Do
#===============================================================================
# * None.  Perfect?
#===============================================================================



#===============================================================================
# * Control the following Pokemon
# * Example:
#     FollowingMoveRoute([
#         PBMoveRoute::TurnRight,
#         PBMoveRoute::Wait,4,
#         PBMoveRoute::Jump,0,0
#     ])
# * The Pokemon turns Right, waits 4 frames, and then jumps
# * Call pbPokeStep to animate all events on the map named "Poke"
#===============================================================================
def FollowingMoveRoute(commands,waitComplete=false)
  return if $Trainer.party[0].hp<=0 || $Trainer.party[0].isEgg? || 
      $game_variables[Current_Following_Variable]==0 ||
      !$game_switches[Toggle_Following_Switch]
  $PokemonTemp.dependentEvents.SetMoveRoute(commands,waitComplete)
end

def pbPokeStep
  for event in $game_map.events.values
    if event.name=="Poke"               
      pbMoveRoute(event,[PBMoveRoute::StepAnimeOn])
    end
  end
end
#===============================================================================
# * Toggle for Following Pokemon
#===============================================================================
def pbToggleFollowingPokemon
  return if $Trainer.party[0].hp<=0 || $Trainer.party[0].isEgg?
  if $game_switches[Following_Activated_Switch]
    if $game_switches[Toggle_Following_Switch]
      $game_switches[Toggle_Following_Switch]=false
      $PokemonTemp.dependentEvents.remove_sprite(true)
      pbWait(1)      
    else
      $game_switches[Toggle_Following_Switch]=true
      $PokemonTemp.dependentEvents.refresh_sprite
      pbWait(1)
      
    end
  end
end



class DependentEvents
  attr_accessor :realEvents
#===============================================================================
# Raises The Current Pokemon's Happiness level +1 per each time the 
# Walk_time_Variable reachs 5000 then resets to 0
# ItemWalk, is when the variable reaches a certain amount, that you are able 
# to talk to your pokemon to recieve an item
#===============================================================================
  def add_following_time
    if $game_switches[Toggle_Following_Switch] && $Trainer.party.length>=1
      $game_variables[Walking_Time_Variable]+=1 if $game_variables[Current_Following_Variable]!=0
      $game_variables[Walking_Item_Variable]+=1 if $game_variables[Current_Following_Variable]!=0
      if $game_variables[Walking_Time_Variable]==5000
        $Trainer.party[0].happiness+=1
        $game_variables[Walking_Time_Variable]=0
      end
      if $game_variables[Walking_Item_Variable]==1000
        if $game_variables[ItemWalk]==15
        else
          $game_variables[ItemWalk]+=1
        end
        $game_variables[Walking_Item_Variable]=0
      end
    end
  end
#===============================================================================
# * refresh_sprite
# * Updates the sprite sprite with an animation
#===============================================================================
  def refresh_sprite(animation=true)
    if $game_variables[Current_Following_Variable]!=0
      return unless $game_switches[Toggle_Following_Switch]
      return if $PokemonGlobal.bicycle
      if $Trainer.party[0].isShiny?
        shiny=true
      else
        shiny=false
      end
      if $Trainer.party[0].form>0
        form=$Trainer.party[0].form
      else
        form=nil
      end
      if defined?($Trainer.party[0].isShadow?)
        shadow = $Trainer.party[0].isShadow?
      else
        shadow = false
      end
      if $PokemonGlobal.surfing
        if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $Trainer.party[0].hasType?(:WATER) 
          events=$PokemonGlobal.dependentEvents
          if animation
            for i in 0...events.length
              $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
              pbWait(10)
            end
          end
          change_sprite($Trainer.party[0].species, shiny, false, form, $Trainer.party[0].gender, shadow)
        elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
          isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
          ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
          !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species)) &&
          $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? 
          events=$PokemonGlobal.dependentEvents
          if animation
            for i in 0...events.length
              $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
              pbWait(10)
            end
          end
          change_sprite($Trainer.party[0].species, shiny, false, form, $Trainer.party[0].gender, shadow)
        else
          remove_sprite(false)
        end  
      elsif $PokemonGlobal.diving
        if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $Trainer.party[0].hasType?(:WATER) && WATERPOKEMONCANDIVE
          events=$PokemonGlobal.dependentEvents
          if animation
            for i in 0...events.length
              $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
              pbWait(10)
            end
          end
          change_sprite($Trainer.party[0].species, shiny, false, form, $Trainer.party[0].gender, shadow)
        else
          remove_sprite(false)
        end  
      else
        if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $scene.is_a?(Scene_Map)
          events=$PokemonGlobal.dependentEvents
          if animation
            for i in 0...events.length
              $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
              pbWait(10)
            end
          end
          change_sprite($Trainer.party[0].species, shiny, false, form, $Trainer.party[0].gender, shadow)
        elsif $Trainer.party[0].hp<=0 || $Trainer.party[0].isEgg?
          remove_sprite(animation)
        end
      end
    else
      check_faint
    end
  end
#===============================================================================
# * change_sprite(id, shiny, animation)
# * Example, to change sprite to shiny lugia with animation:
#     change_sprite(249, true, true)
# * If just change sprite:
#     change_sprite(249)
#===============================================================================
  def change_sprite(id, shiny=nil, animation=nil, form=nil, gender=nil, shadow=false)
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8]=="Dependent"
        tgender = (gender==1)? "f" : ""
        tshiny  = (shiny)? "s" : ""
        tform   = (form && form>0) ? "_#{form}" : ""
        tshadow = (shadow)? "_shadow": ""
        speciesname = getConstantName(PBSpecies,id)
        bitmapFileName=sprintf("%s%s%s%s%s",speciesname,tgender,tshiny,tform,tshadow)
        if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
          events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
          @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
        else
          bitmapFileName=sprintf("%s%s",speciesname,tshiny)
          if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
            events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
            @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
          else
            bitmapFileName=sprintf("%s",speciesname)
            if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
              events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
              @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
            else  
              bitmapFileName=sprintf("%03d%s%s%s%s",id,tgender,tshiny,tform,tshadow)
              if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
                events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
              else  
                bitmapFileName=sprintf("%03d%s%s%s",id,tshiny,tform,tshadow)
                if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
                  events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                  @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
                else
                  bitmapFileName=sprintf("%03d%s",id,tshiny)
                  if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
                    events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                    @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
                  else
                    bitmapFileName=sprintf("%03d",id)
                    events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                    @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
                  end
                end
              end
            end
          end
        end
        if animation
          $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
        end
        $game_variables[Walking_Time_Variable]=0
      end
    end
  end
#===============================================================================
# * update_stepping
# * Adds step animation for followers
#===============================================================================  
  def update_stepping
    FollowingMoveRoute([PBMoveRoute::StepAnimeOn])
  end
  
  def stop_stepping
    FollowingMoveRoute([PBMoveRoute::StepAnimeOff])
  end
#===============================================================================
# * remove_sprite(animation)
# * Example, to remove sprite with animation:
#     remove_sprite(true)
# * If just remove sprite:
#     remove_sprite
#===============================================================================
  def remove_sprite(animation=nil)
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8]=="Dependent"
        events[i][6]=sprintf("nil")
        @realEvents[i].character_name=sprintf("nil")
        if animation==true
          $scene.spriteset.addUserAnimation(Animation_Come_In,@realEvents[i].x,@realEvents[i].y)
          pbWait(10)
        end
        $game_variables[Current_Following_Variable]=$Trainer.party[0]
        $game_variables[Walking_Time_Variable]=0
      end
    end
  end
#===============================================================================
# * check_surf(animation)
# * If current Pokemon is a water Pokemon, it is still following.
# * If current Pokemon is not a water Pokemon, remove sprite.
# * Require Water_Pokemon_Can_Surf = true to enable
#===============================================================================
  def check_surf(animation=nil)
    if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg?
      if ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
        isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
        ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
        !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
        
          #do nothing
      elsif $Trainer.party[0].hasType?(:WATER) && WATERPOKEMONCANSURF
        #do nothing
      else
        remove_sprite(animation)
      end
      
    end
  end
#===============================================================================
# * talk_to_pokemon
# * It will run when you talk to Pokemon following
#===============================================================================
  def talk_to_pokemon
    e=$Trainer.party[0]
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8]=="Dependent"
        pos_x=@realEvents[i].x
        pos_y=@realEvents[i].y
        case $game_player.direction
        when 2 # Facing Down
          return if $game_player.x != pos_x
          return if $game_player.y != pos_y-1
        when 4 # Facing Left
          return if $game_player.x != pos_x+1
          return if $game_player.y != pos_y
        when 6 # Facing Right
          return if $game_player.x != pos_x-1
          return if $game_player.y != pos_y
        when 8 # Facing Up
          return if $game_player.x != pos_x
          return if $game_player.y != pos_y+1
        else
          return false
        end
      end
    end
    if e!=0
      if e.hp>0 && !$Trainer.party[0].isEgg?        
        if $PokemonGlobal.bicycle
          return
        elsif $PokemonGlobal.surfing 
          flag = true
          if WATERPOKEMONCANSURF && $Trainer.party[0].hasType?(:WATER)
            flag = false
          elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
              isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
              ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
              !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
            flag = false
          end
          return if flag
        elsif $PokemonGlobal.diving && (!WATERPOKEMONCANDIVE || !$Trainer.party[0].hasType?(:WATER))
          return
        end
#===============================================================================
# * Checks to make sure the Pokemon isn't blocking a surfable water surface
# * If the water is blocked by the sprite (even though it is invisible) and
#   the player should be able to surf, calls surf
#===============================================================================
        terrain=Kernel.pbFacingTerrainTag
        notCliff=$game_map.passable?($game_player.x,$game_player.y,$game_player.direction)
        if PBTerrain.isWater?(terrain) || !notCliff
          if !pbGetMetadata($game_map.map_id,MetadataBicycleAlways) && !$PokemonGlobal.surfing
            if $DEBUG
              Kernel.pbSurf
              return
            elsif (HIDDENMOVESCOUNTBADGES ? $Trainer.numbadges>=BADGEFORSURF : $Trainer.badges[BADGEFORSURF])
              Kernel.pbSurf
              return
            end
          end
        end
#===============================================================================
# * talk_to_pokemon when possible begins here
#===============================================================================
        if e!=6 && $game_switches[Toggle_Following_Switch]==true
          pbPlayCry(e.species)
          random1=rand(7) # random message if no special conditions apply
          mapname=$game_map.name # Get's current map name
#===============================================================================
# * Pokemon Messages when Status Condition
#===============================================================================          
          if e.status==PBStatuses::POISON && e.hp>0 && !e.isEgg? # Pokemon Poisoned
            $scene.spriteset.addUserAnimation(Emo_Poison, pos_x, pos_y-2)
            pbWait(120)
            Kernel.pbMessage(_INTL("{1} is shivering with the effects of being poisoned.",e.name))
           
          elsif e.status==PBStatuses::BURN && e.hp>0 && !e.isEgg? # Pokemon Burned
            $scene.spriteset.addUserAnimation(Emo_Hate, pos_x, pos_y-2)
            pbWait(70)
            Kernel.pbMessage(_INTL("{1}'s burn looks painful.",e.name))
            
          elsif e.status==PBStatuses::FROZEN && e.hp>0 && !e.isEgg? # Pokemon Frozen
            $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
            pbWait(100)
            Kernel.pbMessage(_INTL("{1} seems very cold. It's frozen solid!",e.name))
          
          elsif e.status==PBStatuses::SLEEP && e.hp>0 && !e.isEgg? # Pokemon Asleep
            $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
            pbWait(100)
            Kernel.pbMessage(_INTL("{1} seems really tired.",e.name))
            
          elsif e.status==PBStatuses::PARALYSIS && e.hp>0 && !e.isEgg? # Pokemon Paralyzed
            $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
            pbWait(100)
            Kernel.pbMessage(_INTL("{1} is standing still and twitching.",e.name))
#===============================================================================
# * Pokemon is holding an item on a Specific Map
#===============================================================================           
          elsif $game_variables[ItemWalk]==15 and mapname=="Item Map" # Pokemon has item and is on map "Item Map"
            items=[:MASTERBALL,:MASTERBALL] # This array can be edited and extended. Look at the one below for a guide
            random2=0
            loop do
              random2=rand(items.length)
              break if hasConst?(PBItems,items[random2])
            end
            Kernel.pbMessage(_INTL("{1} seems to be holding something.",e.name))
            Kernel.pbPokemonFound(getConst(PBItems,items[random2]))
            $game_variables[ItemWalk]=0
#===============================================================================
# * Pokemon is holding an item on any other map
#===============================================================================            
          elsif $game_variables[ItemWalk]==15 # Pokemon has Item
            items=[:POTION,:SUPERPOTION,:FULLRESTORE,:REVIVE,:PPUP,
                 :PPMAX,:RARECANDY,:REPEL,:MAXREPEL,:ESCAPEROPE,
                 :HONEY,:TINYMUSHROOM,:PEARL,:NUGGET,:GREATBALL,
                 :ULTRABALL,:THUNDERSTONE,:MOONSTONE,:SUNSTONE,:DUSKSTONE,
                 :REDAPRICORN,:BLUAPRICORN,:YLWAPRICORN,:GRNAPRICORN,:PNKAPRICORN,
                 :BLKAPRICORN,:WHTAPRICORN
            ]
            random2=0
            loop do
              random2=rand(items.length)
              break if hasConst?(PBItems,items[random2])
            end

            Kernel.pbMessage(_INTL("{1} seems to be holding something.",e.name))
            Kernel.pbPokemonFound(getConst(PBItems,items[random2]))
            $game_variables[ItemWalk]=0
#===============================================================================
# * Examples of Map Specific Messages
#===============================================================================
          elsif mapname=="Dusk Forest" && e.hasType?(:BUG) # Bug Type in Dusk Forest
            $scene.spriteset.addUserAnimation(Emo_sing, pos_x, pos_y-2)
            pbWait(50)
            random3=rand(3)
            if random3==0
              Kernel.pbMessage(_INTL("{1} seems highly interested in the trees.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} seems to enjoy the buzzing of the bug Pokémon.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} is jumping around restlessly in the forest.",e.name,$Trainer.name))
            end
          
          elsif mapname=="Old Lab" # In the Old Lab
            $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
            pbWait(100)
            random3=rand(3)
            if random3==0
              Kernel.pbMessage(_INTL("{1} is touching some kind of switch.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} has a cord in its mouth!",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} seems to want to touch the machinery.",e.name,$Trainer.name))
            end  
            
          elsif mapname=="Home" # In the Player's Home
            $scene.spriteset.addUserAnimation(Emo_Happy, pos_x, pos_y-2)
            pbWait(70)
            random3=rand(3)
            if random3==0
              Kernel.pbMessage(_INTL("{1} is sniffing around the room.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} noticed {2}'s mom is nearby.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} seems to want to settle down at home.",e.name,$Trainer.name))
            end
#===============================================================================
# * Pokemon Messages when birthday
# * Support for Pokemon Birthsigns script
#===============================================================================          
          elsif defined?(e.isBirthday?) && e.isBirthday?
            $scene.spriteset.addUserAnimation(Emo_Cake, pos_x, pos_y-2)
            pbWait(50)
            messages=rand(10)
            case messages
            when 0
              Kernel.pbMessage(_INTL("{1} seems to be reminiscing on all it has learned in the last year.",e.name,$Trainer.name))
            when 1
              Kernel.pbMessage(_INTL("{1} seems glad to be spending its birthday with {2}.",e.name,$Trainer.name))
            when 2
              Kernel.pbMessage(_INTL("{1} is having the best birthday ever!",e.name,$Trainer.name))
            when 3
              Kernel.pbMessage(_INTL("{1} can't believe its been a whole year already!",e.name,$Trainer.name))
            when 4
              Kernel.pbMessage(_INTL("{1} seems to be sniffing around for presents...",e.name,$Trainer.name))
            when 5
              Kernel.pbMessage(_INTL("{1} seems a bit out of breath...\nYou're getting old!",e.name,$Trainer.name))
            when 6
              Kernel.pbMessage(_INTL("{1} looks ready to party!",e.name,$Trainer.name))
            when 7
              Kernel.pbMessage(_INTL("You wish {1} a happy birthday.\nHappy birthday, {1}!",e.name,$Trainer.name))
            when 8
              Kernel.pbMessage(_INTL("{1} seems to be looking forward to another year with {2}.",e.name,$Trainer.name))
            when 9
              Kernel.pbMessage(_INTL("{1} wants to eat some cake!",e.name,$Trainer.name))
            end
#===============================================================================
# * Random Messages if none of the above apply
#===============================================================================            
          elsif random1==0 # Music Note
            $scene.spriteset.addUserAnimation(Emo_sing, pos_x, pos_y-2)
            pbWait(50)
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} seems to want to play with {2}.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} is singing and humming.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} is looking up at the sky.",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} swayed and danced around as it pleased.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} is pulling out the grass.",e.name,$Trainer.name))
            end
            
          elsif random1==1 # Hate/Angry Face
            $scene.spriteset.addUserAnimation(Emo_Hate, pos_x, pos_y-2)
            pbWait(70)
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} let out a roar!",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} is making a face like it's angry!",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} seems to be angry for some reason.",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} chewed on your feet.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} is trying to be intimidating.",e.name,$Trainer.name))
            end
            
          elsif random1==2 # ... Emoji
            $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
            pbWait(70)
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} is looking down steadily.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} is sniffing at the floor.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} is concentrating deeply.",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} faced this way and nodded.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} is glaring straight into {2}'s eyes.",e.name,$Trainer.name))
            end
            
          elsif random1==3 # Happy Face
            $scene.spriteset.addUserAnimation(Emo_Happy, pos_x, pos_y-2)
            pbWait(70)
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} began poking you in the stomach.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} looks very happy.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} happily cuddled up to you.",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} is so happy that it can't stand still.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} looks like it wants to lead!",e.name,$Trainer.name))
            end
            
          elsif random1==4 # Heart Emoji
            $scene.spriteset.addUserAnimation(Emo_love, pos_x, pos_y-2)
            pbWait(70)
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} suddenly started walking closer.",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("Woah! {1} suddenly hugged {2}.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} is rubbing up against you.",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} is keeping close to {2}.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} blushed.",e.name,$Trainer.name))
            end
            
          elsif random1==5 # No Emoji
            random3=rand(5)
            if random3==0
              Kernel.pbMessage(_INTL("{1} spun around in a circle!",e.name,$Trainer.name))
            elsif random3==1
              Kernel.pbMessage(_INTL("{1} let our a battle cry.",e.name,$Trainer.name))
            elsif random3==2
              Kernel.pbMessage(_INTL("{1} is on the lookout!",e.name,$Trainer.name))
            elsif random3==3
              Kernel.pbMessage(_INTL("{1} is standing patiently.",e.name,$Trainer.name))
            elsif random3==4
              Kernel.pbMessage(_INTL("{1} is looking around restlessly.",e.name,$Trainer.name))
            end
#===============================================================================
# * This random message shows the Pokemon's Happiness Level
#===============================================================================             
          elsif random1==6 # Check Happiness Level
            if e.happiness>0 && e.happiness<=50
              $scene.spriteset.addUserAnimation(Emo_Hate, pos_x, pos_y-2)
              pbWait(70)
              Kernel.pbMessage(_INTL("{1} hates to travel with {2}.",e.name,$Trainer.name))
            elsif e.happiness>50 && e.happiness<=100
              $scene.spriteset.addUserAnimation(Emo_Normal, pos_x, pos_y-2)
              pbWait(100)
              Kernel.pbMessage(_INTL("{1} is still unsure about traveling with {2} is a good thing or not.",e.name,$Trainer.name))
            elsif e.happiness>100 && e.happiness<150
              $scene.spriteset.addUserAnimation(Emo_Happy, pos_x, pos_y-2)
              Kernel.pbMessage(_INTL("{1} is happy traveling with {2}.",e.name,$Trainer.name))
            elsif e.happiness>=150
              $scene.spriteset.addUserAnimation(Emo_love, pos_x, pos_y-2)
              pbWait(70)
              Kernel.pbMessage(_INTL("{1} loves traveling with {2}.",e.name,$Trainer.name))
            end
          end
        else
        end
    end
  end
end
#===============================================================================
# * Pokemon reapear after using surf
#===============================================================================
def Come_back(shiny=nil, animation=nil)
  return if !$game_variables[Following_Activated_Switch]
  return if $Trainer.party.length==0
  $PokemonTemp.dependentEvents.pbMoveDependentEvents
  events=$PokemonGlobal.dependentEvents
  if $game_variables[Current_Following_Variable]==$Trainer.party[0]
    remove_sprite(false)
    if $scene.is_a?(Scene_Map)
      for i in 0...events.length 
        $scene.spriteset.addUserAnimation(Animation_Come_Out,@realEvents[i].x,@realEvents[i].y)
      end
    end
  end
  if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg?
    $game_variables[Current_Following_Variable]=$Trainer.party[0]
    refresh_sprite(animation)
  end
  for i in 0...events.length 
    if events[i] && events[i][8]=="Dependent"
      id = $Trainer.party[0].species
      tgender = ($Trainer.party[0].gender==1)? "f" : ""
      tshiny  = ($Trainer.party[0].isShiny?)? "s" : ""
      tform   = ($Trainer.party[0].form && $Trainer.party[0].form>0) ? "_#{$Trainer.party[0].form}" : ""
      tshadow = ($Trainer.party[0].shadow)? "_shadow": ""
      speciesname = getConstantName(PBSpecies,id)
      bitmapFileName=sprintf("%s%s%s%s%s",speciesname,tgender,tshiny,tform,tshadow)
      if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
        events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
        @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
      else
        bitmapFileName=sprintf("%s%s",speciesname,tshiny)
        if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
          events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
          @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
        else
          bitmapFileName=sprintf("%s",speciesname)
          if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
            events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
            @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
          else  
            bitmapFileName=sprintf("%03d%s%s%s%s",id,tgender,tshiny,tform,tshadow)
            if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
              events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
              @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
            else  
              bitmapFileName=sprintf("%03d%s",id,tshiny)
              if pbResolveBitmap(FOLLOWER_FILE_PATH+FOLLOWER_FILE_DIR+bitmapFileName)
                events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
              else
                bitmapFileName=sprintf("%03d",id)
                events[i][6] = FOLLOWER_FILE_DIR+bitmapFileName
                @realEvents[i].character_name=FOLLOWER_FILE_DIR+bitmapFileName
              end
            end
          end
        end
      end
    end 
  end 
end
#===============================================================================
# * check_faint
# * If current Pokemon is fainted, removes the sprite
#===============================================================================
def check_faint
  return if !$game_switches[Following_Activated_Switch] || $Trainer.party.length<=0
  if $PokemonGlobal.bicycle
    return
  elsif $PokemonGlobal.diving && WATERPOKEMONCANDIVE && $Trainer.party[0].hasType?(:WATER)
    return
  elsif $PokemonGlobal.surfing && WATERPOKEMONCANSURF && $Trainer.party[0].hasType?(:WATER)
    return
  elsif $PokemonGlobal.surfing && ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
        isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
        ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
        !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
    return
  else
    if $Trainer.party[0].hp<=0 
      $game_variables[Current_Following_Variable]=0 
      remove_sprite
    elsif $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $game_variables[Current_Following_Variable]==0 
        $game_variables[Current_Following_Variable]=$Trainer.party[0]
        refresh_sprite
    end 
  end
end
#===============================================================================
# * SetMoveRoute
# * Used in the "Control Following Pokemon" Script listed farther above
#===============================================================================
def SetMoveRoute(commands,waitComplete=true)
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8]=="Dependent"
        pbMoveRoute(@realEvents[i],commands,waitComplete)
      end
    end
  end
end



#===============================================================================
# * Update followers for surfing
# * Non-follower dependent events not allowed
#===============================================================================
def Kernel.pbSurf
  if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
    return false
  end
  if $DEBUG ||
    (HIDDENMOVESCOUNTBADGES ? $Trainer.numbadges>=BADGEFORSURF : $Trainer.badges[BADGEFORSURF])
    movefinder=Kernel.pbCheckMove(:SURF)
    if $DEBUG || movefinder
      if Kernel.pbConfirmMessage(_INTL("The water is dyed a deep blue...  Would you like to surf?"))
        speciesname=!movefinder ? $Trainer.name : movefinder.name
        Kernel.pbMessage(_INTL("{1} used Surf!",speciesname))
        pbHiddenMoveAnimation(movefinder)
        surfbgm=pbGetMetadata(0,MetadataSurfBGM)
        $PokemonTemp.dependentEvents.check_surf(true)
        if surfbgm
          pbCueBGM(surfbgm,0.5)
        end
        pbStartSurfing()
        return true
      end
    end
  end
  return false
end

alias follow_pbStartSurfing pbStartSurfing
def pbStartSurfing()
  follow_pbStartSurfing
  $PokemonGlobal.surfing=true
end

alias follow_pbEndSurf pbEndSurf
def pbEndSurf(xOffset,yOffset)
  ret = follow_pbEndSurf(xOffset,yOffset)
  if $game_switches[Toggle_Following_Switch] && ret && $game_variables[Current_Following_Variable]!=0
    if WATERPOKEMONCANSURF && $Trainer.party[0].hasType?(:WATER)
      $PokemonTemp.dependentEvents.Come_back($Trainer.party[0].isShiny?,false)
    elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
        isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
        ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
        !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
        $PokemonTemp.dependentEvents.Come_back($Trainer.party[0].isShiny?,false)
    else
      $PokemonTemp.dependentEvents.Come_back(true)
    end
  end
end

#===============================================================================
# * Auto add Script to Kernel.pbCanUseHiddenMove, fix HM bug
# * Fixed so non-pokemon follower dependent events will return false
#===============================================================================
def Kernel.pbCanUseHiddenMove?(pkmn,move,showmsg=true)
  case move
    when PBMoves::FLY
      if !$DEBUG && !$Trainer.badges[BADGEFORFLY]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
     if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
       Kernel.pbMessage(_INTL("You can't use that if you have someone with you.")) if showmsg
       return false
     end
      if !pbGetMetadata($game_map.map_id,MetadataOutdoor)
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true
    when PBMoves::CUT
      if !$DEBUG && !$Trainer.badges[BADGEFORCUT]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      facingEvent=$game_player.pbFacingEvent
      if !facingEvent || facingEvent.name!="Tree"
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true
    when PBMoves::HEADBUTT
      facingEvent=$game_player.pbFacingEvent
      if !facingEvent || facingEvent.name!="HeadbuttTree"
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true
    when PBMoves::SURF
      terrain=Kernel.pbFacingTerrainTag
      if !$DEBUG && !$Trainer.badges[BADGEFORSURF]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      if $PokemonGlobal.surfing
        Kernel.pbMessage(_INTL("You're already surfing.")) if showmsg
        return false
      end
      if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
         Kernel.pbMessage(_INTL("You can't use that if you have someone with you.")) if showmsg
         return false
      end
      terrain=Kernel.pbFacingTerrainTag
      if pbGetMetadata($game_map.map_id,MetadataBicycleAlways)
        Kernel.pbMessage(_INTL("Let's enjoy cycling!")) if showmsg
        return false
      end
      if !PBTerrain.isWater?(terrain)
        Kernel.pbMessage(_INTL("No surfing here!")) if showmsg
        return false
      end
      return true
    when PBMoves::STRENGTH
      if !$DEBUG && !$Trainer.badges[BADGEFORSTRENGTH]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      facingEvent=$game_player.pbFacingEvent
      if !facingEvent || facingEvent.name!="Boulder"
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true  
    when PBMoves::ROCKSMASH
      terrain=Kernel.pbFacingTerrainTag
      if !$DEBUG && !$Trainer.badges[BADGEFORROCKSMASH]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      facingEvent=$game_player.pbFacingEvent
      if !facingEvent || facingEvent.name!="Rock"
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true  
    when PBMoves::FLASH
      if !$DEBUG && !$Trainer.badges[BADGEFORFLASH]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      if !pbGetMetadata($game_map.map_id,MetadataDarkMap)
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      if $PokemonGlobal.flashUsed
        Kernel.pbMessage(_INTL("This is in use already.")) if showmsg
        return false
      end
      return true
    when PBMoves::WATERFALL
      if !$DEBUG && !$Trainer.badges[BADGEFORWATERFALL]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      terrain=Kernel.pbFacingTerrainTag
      if terrain!=PBTerrain::Waterfall
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true
    when PBMoves::DIVE
      if !$DEBUG && !$Trainer.badges[BADGEFORDIVE]
        Kernel.pbMessage(_INTL("Sorry, a new Badge is required.")) if showmsg
        return false
      end
      if $PokemonGlobal.diving
        return true
      end
      if $game_player.terrain_tag!=PBTerrain::DeepWater
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      if !pbGetMetadata($game_map.map_id,MetadataDiveMap)
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      return true
    when PBMoves::TELEPORT
      if !pbGetMetadata($game_map.map_id,MetadataOutdoor)
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
     if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
       Kernel.pbMessage(_INTL("You can't use that if you have someone with you.")) if showmsg
       return false
     end
      healing=$PokemonGlobal.healingSpot
      if !healing
        healing=pbGetMetadata(0,MetadataHome) # Home
      end
      if healing
        mapname=pbGetMapNameFromId(healing[0])
        if Kernel.pbConfirmMessage(_INTL("Want to return to the healing spot used last in {1}?",mapname))
          return true
        end
        return false
      else
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
    when PBMoves::DIG
      escape=($PokemonGlobal.escapePoint rescue nil)
      if !escape || escape.empty?
        Kernel.pbMessage(_INTL("Can't use that here.")) if showmsg
        return false
      end
      if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
        Kernel.pbMessage(_INTL("You can't use that if you have someone with you.")) if showmsg
        return false
      end
      mapname=pbGetMapNameFromId(escape[0])
      if Kernel.pbConfirmMessage(_INTL("Want to escape from here and return to {1}?",mapname))
        return true
      end
      return false
    when PBMoves::SWEETSCENT
      return true
    else
      return HiddenMoveHandlers.triggerCanUseMove(move,pkmn)
    end
  return false
end


#===============================================================================
# * Modifies bike scripts to properly affect the follower sprites
#===============================================================================
module Kernel
  class << self
    alias follow_pbDismountBike pbDismountBike
    alias follow_pbMountBike pbMountBike
    alias follow_pbCancelVehicles pbCancelVehicles
  end
  
  def self.pbDismountBike
    return if !$PokemonGlobal.bicycle
    ret=follow_pbDismountBike
    if $game_switches[Toggle_Following_Switch]
      $PokemonTemp.dependentEvents.Come_back(true)
    end
    $PokemonTemp.dependentEvents.refresh_sprite
    return ret
  end
  
  def self.pbMountBike 
    ret=follow_pbMountBike
    if $game_switches[Toggle_Following_Switch]
      if pbGetMetadata($game_map.map_id,MetadataBicycleAlways)
        $PokemonTemp.dependentEvents.remove_sprite
      else
        $PokemonTemp.dependentEvents.remove_sprite(true)
      end
    end
    return ret
  end
  
  def self.pbCancelVehicles(destination=nil)
    if $game_switches[Toggle_Following_Switch] && ($PokemonGlobal.bicycle || 
                                                    $PokemonGlobal.diving) &&
                                                    destination.nil?
      $PokemonTemp.dependentEvents.Come_back(false)
    end
    return follow_pbCancelVehicles(destination)
  end
  
end

#===============================================================================
# * Replaces pbBikeCheck
# * Can still reject for dependent events if the pokemon follower has been removed
#===============================================================================
def pbBikeCheck
  if $PokemonGlobal.surfing ||
     (!$PokemonGlobal.bicycle && pbGetTerrainTag==PBTerrain::TallGrass)
    Kernel.pbMessage(_INTL("Can't use that here."))
    return false
  end
  if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
    Kernel.pbMessage(_INTL("It can't be used when you have someone with you."))
    return false
  end
  if $PokemonGlobal.bicycle
    if pbGetMetadata($game_map.map_id,MetadataBicycleAlways)
      Kernel.pbMessage(_INTL("You can't dismount your Bike here."))
      return false
    end
    return true
  else
    val=pbGetMetadata($game_map.map_id,MetadataBicycle)
    val=pbGetMetadata($game_map.map_id,MetadataOutdoor) if val==nil
    if !val
      Kernel.pbMessage(_INTL("Can't use that here."))
      return false
    end
    return true
  end
end



#===============================================================================
# * Refresh follower after accessing TrainerPC
#===============================================================================
alias follow_pbTrainerPC pbTrainerPC
def pbTrainerPC
  follow_pbTrainerPC
  $PokemonTemp.dependentEvents.refresh_sprite
end
#===============================================================================
# * Refresh follower after accessing TrainerPC
#===============================================================================
class TrainerPC

  alias follow_access access
  def access
    follow_access
    $PokemonTemp.dependentEvents.refresh_sprite
  end
end
#===============================================================================
# * Auto add Script to pbPokeCenterPC
#===============================================================================
alias follow_pbPokeCenterPC pbPokeCenterPC
def pbPokeCenterPC
  follow_pbPokeCenterPC
  $PokemonTemp.dependentEvents.refresh_sprite
end
#===============================================================================
#Fix for followers having animations (grass, etc) when toggled off
#Treats followers as if they are under a bridge when toggled
#===============================================================================
alias follow_pbGetTerrainTag pbGetTerrainTag
def pbGetTerrainTag(event=nil,countBridge=false)
  ret=follow_pbGetTerrainTag(event,countBridge)
  if event && event!=$game_player
    for devent in $PokemonGlobal.dependentEvents
      if event.id==devent[1] && (!$game_switches[Toggle_Following_Switch] ||
                                  $Trainer.party.length==0 ||
                                  $Trainer.party[0].isEgg? || $Trainer.party[0].hp<=0)
        ret = PBTerrain::Bridge 
        break
      end
    end
  end
  return ret
end




#===============================================================================
# * Start Pokemon Following
# * x is the Event ID that will become the follower
#===============================================================================
def pbPokemonFollow(x)
  Kernel.pbAddDependency2(x, "Dependent", Unused_Common_Event)
  $PokemonTemp.dependentEvents.refresh_sprite
  $PokemonTemp.dependentEvents.Come_back(nil,false)
  $game_switches[Following_Activated_Switch]=true
  $game_switches[Toggle_Following_Switch]=true
end


def pbTestPass(follower,x,y,direction=nil)
  ret = $MapFactory.isPassable?(follower.map.map_id,x,y,follower)
  if !ret && $PokemonGlobal.bridge>0&&
          PBTerrain.isBridge?($MapFactory.getTerrainTag(follower.map.map_id,x,y))
    ret = true
  end
  return ret
end


class DependentEvents

  def pbFollowEventAcrossMaps(leader,follower,instant=false,leaderIsTrueLeader=true)
    d=leader.direction
    areConnected=$MapFactory.areConnected?(leader.map.map_id,follower.map.map_id)
    # Get the rear facing tile of leader
    facingDirection=[0,0,8,0,6,0,4,0,2][d]
    if !leaderIsTrueLeader && areConnected
      relativePos=$MapFactory.getThisAndOtherEventRelativePos(leader,follower)
      if (relativePos[1]==0 && relativePos[0]==2) # 2 spaces to the right of leader
        facingDirection=6
      elsif (relativePos[1]==0 && relativePos[0]==-2) # 2 spaces to the left of leader
        facingDirection=4
      elsif relativePos[1]==-2 && relativePos[0]==0 # 2 spaces above leader
        facingDirection=8
      elsif relativePos[1]==2 && relativePos[0]==0 # 2 spaces below leader
        facingDirection=2
      end
    end
    facings=[facingDirection] # Get facing from behind
    facings.push([0,0,4,0,8,0,2,0,6][d]) # Get right facing
    facings.push([0,0,6,0,2,0,8,0,4][d]) # Get left facing
    if !leaderIsTrueLeader
      facings.push([0,0,2,0,4,0,6,0,8][d]) # Get forward facing
    end
    mapTile=nil
    if areConnected
      bestRelativePos=-1
      oldthrough=follower.through
      follower.through=false
      for i in 0...facings.length
        facing=facings[i]
        tile=$MapFactory.getFacingTile(facing,leader)
        passable=tile && $MapFactory.isPassable?(tile[0],tile[1],tile[2],follower)
        if !passable && $PokemonGlobal.bridge>0
          passable = PBTerrain.isBridge?($MapFactory.getTerrainTag(tile[0],tile[1],tile[2]))
        elsif passable && !$PokemonGlobal.surfing && $PokemonGlobal.bridge==0       
          passable=!PBTerrain.isWater?($MapFactory.getTerrainTag(tile[0],tile[1],tile[2]))
        end
        if i==0 && !passable && tile && 
           $MapFactory.getTerrainTag(tile[0],tile[1],tile[2],true)==PBTerrain::Ledge &&
           $PokemonGlobal.bridge==0
          # If the tile isn't passable and the tile is a ledge,
          # get tile from further behind
          tile=$MapFactory.getFacingTileFromPos(tile[0],tile[1],tile[2],facing)
          passable=tile && $MapFactory.isPassable?(tile[0],tile[1],tile[2],follower)
          if passable && !$PokemonGlobal.surfing
            passable=!PBTerrain.isWater?($MapFactory.getTerrainTag(tile[0],tile[1],tile[2]))
          end
        end
        if passable
          relativePos=$MapFactory.getThisAndOtherPosRelativePos(
             follower,tile[0],tile[1],tile[2])
          distance=Math.sqrt(relativePos[0]*relativePos[0]+relativePos[1]*relativePos[1])
          if bestRelativePos==-1 || bestRelativePos>distance
            bestRelativePos=distance
            mapTile=tile
          end
          if i==0 && distance<=1 # Prefer behind if tile can move up to 1 space
            break
          end
        end
      end
      follower.through=oldthrough
    else
      tile=$MapFactory.getFacingTile(facings[0],leader)
      passable=tile && $MapFactory.isPassable?(
         tile[0],tile[1],tile[2],follower)
      mapTile=passable ? mapTile : nil
    end
    if mapTile && follower.map.map_id==mapTile[0]
      # Follower is on same map
      newX=mapTile[1]
      newY=mapTile[2]
      deltaX=(d == 6 ? -1 : d == 4 ? 1 : 0)
      deltaY=(d == 2 ? -1 : d == 8 ? 1 : 0)
      posX = newX + deltaX
      posY = newY + deltaY
      follower.move_speed=leader.move_speed # sync movespeed
      if (follower.x-newX==-1 && follower.y==newY) ||
         (follower.x-newX==1 && follower.y==newY) ||
         (follower.y-newY==-1 && follower.x==newX) ||
         (follower.y-newY==1 && follower.x==newX)
        if instant
          follower.moveto(newX,newY)
        else
          pbFancyMoveTo(follower,newX,newY)
        end
      elsif (follower.x-newX==-2 && follower.y==newY) ||
            (follower.x-newX==2 && follower.y==newY) ||
            (follower.y-newY==-2 && follower.x==newX) ||
            (follower.y-newY==2 && follower.x==newX)
        if instant
          follower.moveto(newX,newY)
        else
          pbFancyMoveTo(follower,newX,newY)
        end
      elsif follower.x!=posX || follower.y!=posY
        if instant
          follower.moveto(newX,newY)
        else
          pbFancyMoveTo(follower,posX,posY)
          pbFancyMoveTo(follower,newX,newY)
        end
      end
    else
      if !mapTile
        # Make current position into leader's position
        mapTile=[leader.map.map_id,leader.x,leader.y]
      end
      if follower.map.map_id==mapTile[0]
        # Follower is on same map as leader
        follower.moveto(leader.x,leader.y)
        #pbTurnTowardEvent(follower,leader)
      else
        # Follower will move to different map
        events=$PokemonGlobal.dependentEvents
        eventIndex=pbEnsureEvent(follower,mapTile[0])
        if eventIndex>=0
          newFollower=@realEvents[eventIndex]
          newEventData=events[eventIndex]
          newFollower.moveto(mapTile[1],mapTile[2])
          newEventData[3]=mapTile[1]
          newEventData[4]=mapTile[2]
          if mapTile[0]==leader.map.map_id
            #pbTurnTowardEvent(follower,leader)
          end
        end
      end
    end
  end

  #Fix follower not being in the same spot upon save
  def pbMapChangeMoveDependentEvents
    return
  end
end



class DependentEventSprites
  
  attr_accessor :sprites
  
  def refresh
    for sprite in @sprites
      sprite.dispose
    end
    @sprites.clear
    $PokemonTemp.dependentEvents.eachEvent {|event,data|
       if data[0]==@map.map_id # Check original map
         #@map.events[data[1]].erase
       end
       if data[2]==@map.map_id # Check current map
         spr = Sprite_Character.new(@viewport,event)
         @sprites.push(spr)
       end
    }
  end

  def update
    if $PokemonTemp.dependentEvents.lastUpdate!=@lastUpdate
      refresh
      @lastUpdate=$PokemonTemp.dependentEvents.lastUpdate
    end
    for sprite in @sprites
      sprite.update
    end
    for i in 0...@sprites.length
      pbDayNightTint(@sprites[i])
      if $game_switches[Toggle_Following_Switch] && APPLYSTATUSTONES && $Trainer.party[0] && $Trainer.party[0].hp>0
        case $Trainer.party[0].status
        when PBStatuses::BURN
          @sprites[i].tone.set(@sprites[i].tone.red+BURNTONE[0],@sprites[i].tone.green+BURNTONE[1],@sprites[i].tone.blue+BURNTONE[2],@sprites[i].tone.gray+BURNTONE[3])
        when PBStatuses::POISON
          @sprites[i].tone.set(@sprites[i].tone.red+POISONTONE[0],@sprites[i].tone.green+POISONTONE[1],@sprites[i].tone.blue+POISONTONE[2],@sprites[i].tone.gray+POISONTONE[3])
        when PBStatuses::PARALYSIS
          @sprites[i].tone.set(@sprites[i].tone.red+PARALYSISTONE[0],@sprites[i].tone.green+PARALYSISTONE[1],@sprites[i].tone.blue+PARALYSISTONE[2],@sprites[i].tone.gray+PARALYSISTONE[3])
        when PBStatuses::FROZEN
          @sprites[i].tone.set(@sprites[i].tone.red+FREEZETONE[0],@sprites[i].tone.green+FREEZETONE[1],@sprites[i].tone.blue+FREEZETONE[2],@sprites[i].tone.gray+FREEZETONE[3])
        when PBStatuses::SLEEP
          @sprites[i].tone.set(@sprites[i].tone.red+SLEEPTONE[0],@sprites[i].tone.green+SLEEPTONE[1],@sprites[i].tone.blue+SLEEPTONE[2],@sprites[i].tone.gray+SLEEPTONE[3])
        end
      end
    end
  end

end


#Refresh following pokemon after switching pokemon around
class PokemonPartyScreen
  
  alias follow_pbSwitch pbSwitch
  def pbSwitch(oldid,newid)
    follow_pbSwitch(oldid,newid)
    $PokemonTemp.dependentEvents.refresh_sprite(false)
  end
  
  alias follow_pbRefreshSingle pbRefreshSingle
  def pbRefreshSingle(pkmnid)
    follow_pbRefreshSingle(pkmnid)
    $PokemonTemp.dependentEvents.refresh_sprite(false)
  end
  
end

#Refresh after evolution
class PokemonEvolutionScene
  
  alias follow_pbEndScreen pbEndScreen
  def pbEndScreen
    follow_pbEndScreen
    if @pokemon==$Trainer.party[0]
      $PokemonTemp.dependentEvents.refresh_sprite(false)
    end
  end
  
end

#Update follower's following time
class Game_Player < Game_Character
  
  alias follow_update update
  def update
    follow_update
    $PokemonTemp.dependentEvents.add_following_time
  end
  
  alias follow_moveto moveto
  def moveto(x,y)
    ret = follow_moveto(x,y)
    events=$PokemonGlobal.dependentEvents
    leader=$game_player
    for i in 0...events.length
      event=$PokemonTemp.dependentEvents.realEvents[i]
      $PokemonTemp.dependentEvents.pbFollowEventAcrossMaps(leader,event,true,i==0)
    end
    return ret
  end

end

#Update follower after battle
class PokeBattle_Scene
  
  alias follow_pbEndBattle pbEndBattle
  def pbEndBattle(result)
    follow_pbEndBattle(result)
    $PokemonTemp.dependentEvents.check_faint
  end
  
end

#Script for when a pokemon finds an item in the field
class PokemonField
  
  def Kernel.pbPokemonFound(item,quantity=1,plural=nil)
    itemname=PBItems.getName(item)
    pocket=pbGetPocket(item)
    e=$Trainer.party[0].name
    if $PokemonBag.pbStoreItem(item,quantity) 
      pbWait(5)
      if $ItemData[item][ITEMUSE]==3 || $ItemData[item][ITEMUSE]==4
        Kernel.pbMessage(_INTL("\\se[]{1} found {2}!\\se[itemlevel]\\nIt contained {3}.\\wtnp[30]",e,itemname,PBMoves.getName($ItemData[item][ITEMMACHINE])))
        Kernel.pbMessage(_INTL("{1} put the {2}\r\nin the {3} Pocket.",$Trainer.name,itemname,PokemonBag.pocketNames()[pocket]))
      elsif PBItems.const_defined?(:LEFTOVERS) && isConst?(item,PBItems,:LEFTOVERS)
        Kernel.pbMessage(_INTL("\\se[]{1} found some {2}!\\se[itemlevel]\\wtnp[30]",e,itemname))
        Kernel.pbMessage(_INTL("{1} put the {2}\r\nin the {3} Pocket.",$Trainer.name,itemname,PokemonBag.pocketNames()[pocket]))
      else
        if quantity>1
          if plural
            Kernel.pbMessage(_INTL("\\se[]{1} found {2} {3}!\\se[itemlevel]\\wtnp[30]",e,quantity,plural))
            Kernel.pbMessage(_INTL("{1} put the {2}\r\nin the {3} Pocket.",$Trainer.name,plural,PokemonBag.pocketNames()[pocket]))
          else
            Kernel.pbMessage(_INTL("\\se[]{1} found {2} {3}s!\\se[itemlevel]\\wtnp[30]",e,quantity,itemname))
            Kernel.pbMessage(_INTL("{1} put the {2}s\r\nin the {3} Pocket.",$Trainer.name,itemname,PokemonBag.pocketNames()[pocket]))
          end
        else
          Kernel.pbMessage(_INTL("\\se[]{1} found one {2}!\\se[itemlevel]\\wtnp[30]",e,itemname))
          Kernel.pbMessage(_INTL("{1} put the {2}\r\nin the {3} Pocket.",$Trainer.name,itemname,PokemonBag.pocketNames()[pocket]))
        end
      end
      return true
    else   # Can't add the item
      if $ItemData[item][ITEMUSE]==3 || $ItemData[item][ITEMUSE]==4
        Kernel.pbMessage(_INTL("{1} found {2}!\\wtnp[20]",e,itemname))
      elsif PBItems.const_defined?(:LEFTOVERS) && isConst?(item,PBItems,:LEFTOVERS)
        Kernel.pbMessage(_INTL("{1} found some {2}!\\wtnp[20]",$Trainer.name,itemname))
      else
        if quantity>1
          if plural
            Kernel.pbMessage(_INTL("{1} found {2} {3}!\\wtnp[20]",e,quantity,plural))
          else
            Kernel.pbMessage(_INTL("{1} found {2} {3}s!\\wtnp[20]",$Trainer.name,quantity,itemname))
          end
        else
          Kernel.pbMessage(_INTL("{1} found one {2}!\\wtnp[20]",e,itemname))
        end
      end
      Kernel.pbMessage(_INTL("Too bad... The Bag is full..."))
      return false
    end
  end
end

$IssueStop = false

#Toggle follower, cycle through pokemon in field
class Scene_Map
  
  alias follow_update update
  def update
    follow_update
    return if $FollowerMoveRoute
    for i in 0...$PokemonGlobal.dependentEvents.length
      event=$PokemonTemp.dependentEvents.realEvents[i]
      return if event.move_route_forcing
    end    
    if $game_switches[Following_Activated_Switch] && $Trainer.party.length>0
      if Input.trigger?(Input::C) # try to talk to pokemon
        $PokemonTemp.dependentEvents.talk_to_pokemon
      end
      # Pokemon always move if switch is on, have flying type, or are in a settings array
      moving = Input.press?(Input::DOWN) || Input.press?(Input::UP) ||
                Input.press?(Input::RIGHT) || Input.press?(Input::LEFT)
      if (ALWAYS_ANIMATE || $game_player.moving? || moving ||
        $Trainer.party[0].hasType?(:FLYING) || 
        isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
        ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
        !$PokemonGlobal.surfing
          if !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
            $PokemonTemp.dependentEvents.update_stepping
          end
      elsif $PokemonGlobal.surfing && $Trainer.party[0].hasType?(:WATER)
        if !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
          $PokemonTemp.dependentEvents.update_stepping
        end
      elsif $PokemonGlobal.surfing && 
                ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
                isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
                ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
                !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species)) &&
                $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? 
          $PokemonTemp.dependentEvents.update_stepping
      elsif $PokemonGlobal.diving && $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $Trainer.party[0].hasType?(:WATER)  && WATERPOKEMONCANDIVE
            $PokemonTemp.dependentEvents.update_stepping
      else
            $PokemonTemp.dependentEvents.stop_stepping
      end
      if Input.trigger?(Input::CTRL) && ALLOWTOGGLEFOLLOW && !$PokemonGlobal.bicycle
        if $PokemonGlobal.surfing
          if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $Trainer.party[0].hasType?(:WATER) 
            if WATERPOKEMONCANSURF
              pbToggleFollowingPokemon
            end
          elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
            isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
            ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
            !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species))
            
            pbToggleFollowingPokemon
          end
        elsif $PokemonGlobal.diving
          if $Trainer.party[0].hp>0 && !$Trainer.party[0].isEgg? && $Trainer.party[0].hasType?(:WATER) 
            if WATERPOKEMONCANDIVE
              pbToggleFollowingPokemon
            end
          end
        else
          pbToggleFollowingPokemon
        end
      end
      if ALLOWFIELDSWITCHING && !$PokemonGlobal.bicycle
        tlength=$Trainer.party.length-1
        tparty=$Trainer.party
        return if tlength<=0
        if Input.trigger?(Input::X) && $Trainer.party.size > 1
          tparty.push(tparty.delete_at(0))
          if $game_switches[Toggle_Following_Switch]
            if $PokemonGlobal.surfing
              if tparty[0].hp>0 && !tparty[0].isEgg? && tparty[0].hasType?(:WATER) 
                $PokemonTemp.dependentEvents.refresh_sprite
              elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
                isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
                ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
                !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species)) &&
                tparty[0].hp>0 && !tparty[0].isEgg? 
                
                $PokemonTemp.dependentEvents.refresh_sprite 
              else
                $PokemonTemp.dependentEvents.refresh_sprite(false)
              end
              if tparty[tlength].hp>0 && !tparty[tlength].isEgg? && tparty[tlength].hasType?(:WATER) 
                $PokemonTemp.dependentEvents.check_surf(true)
              elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[tlength].hasType?(:FLYING) || 
                isConst?($Trainer.party[tlength].ability,PBAbilities,:LEVITATE) ||
                ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[tlength].species)) &&
                !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[tlength].species)) &&
                tparty[tlength].hp>0 && !tparty[tlength].isEgg?
                
                $PokemonTemp.dependentEvents.check_surf(true)
              else
                $PokemonTemp.dependentEvents.check_surf(false)
              end
            elsif $PokemonGlobal.diving
              if tparty[0].hp>0 && !tparty[0].isEgg? && tparty[0].hasType?(:WATER) && WATERPOKEMONCANDIVE
                $PokemonTemp.dependentEvents.refresh_sprite
              end
              if tparty[tlength].hp>0 && !tparty[tlength].isEgg? && tparty[tlength].hasType?(:WATER) && WATERPOKEMONCANDIVE
                $PokemonTemp.dependentEvents.check_surf(true)
              end
            else
              $PokemonTemp.dependentEvents.refresh_sprite 
            end
          end
        end
        if Input.trigger?(Input::Z) && $Trainer.party.size > 1
          $Trainer.party.insert(0,$Trainer.party.pop)
          if $game_switches[Toggle_Following_Switch]
            if $PokemonGlobal.surfing
              if tparty[0].hp>0 && !tparty[0].isEgg? && tparty[0].hasType?(:WATER) 
                $PokemonTemp.dependentEvents.refresh_sprite
              elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[0].hasType?(:FLYING) || 
                isConst?($Trainer.party[0].ability,PBAbilities,:LEVITATE) ||
                ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[0].species)) &&
                !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[0].species)) &&
                tparty[0].hp>0 && !tparty[0].isEgg? 
                
                $PokemonTemp.dependentEvents.refresh_sprite 
                
              else
                $PokemonTemp.dependentEvents.refresh_sprite(false)
              end
              if tparty[1].hp>0 && !tparty[1].isEgg? && tparty[1].hasType?(:WATER) 
                $PokemonTemp.dependentEvents.check_surf(true)
              elsif ALWAYS_ANIMATED_CAN_SURF && ($Trainer.party[1].hasType?(:FLYING) || 
                isConst?($Trainer.party[1].ability,PBAbilities,:LEVITATE) ||
                ALWAYS_ANIMATED_FOLLOWERS.include?($Trainer.party[1].species)) &&
                !(ALWAYS_ANIMATED_EXCEPTION.include?($Trainer.party[1].species)) &&
                tparty[1].hp>0 && !tparty[1].isEgg? 
                
                $PokemonTemp.dependentEvents.check_surf(true) 
              else
                $PokemonTemp.dependentEvents.check_surf(false)
              end
            elsif $PokemonGlobal.diving
               if tparty[0].hp>0 && !tparty[0].isEgg? && tparty[0].hasType?(:WATER)  && WATERPOKEMONCANDIVE
                $PokemonTemp.dependentEvents.refresh_sprite
              end
              if tparty[1].hp>0 && !tparty[1].isEgg? && tparty[1].hasType?(:WATER) && WATERPOKEMONCANDIVE
                $PokemonTemp.dependentEvents.check_surf(true)
              end
            else
              $PokemonTemp.dependentEvents.refresh_sprite 
            end
          end
        end
      end
    end
  end

  alias follow_transfer transfer_player
  def transfer_player(cancelVehicles=true)
    follow_transfer(cancelVehicles)
    events=$PokemonGlobal.dependentEvents
    $PokemonTemp.dependentEvents.updateDependentEvents
    leader=$game_player
    for i in 0...events.length
      event=$PokemonTemp.dependentEvents.realEvents[i]
      $PokemonTemp.dependentEvents.pbFollowEventAcrossMaps(leader,event,false,i==0)
    end
    $PokemonTemp.dependentEvents.refresh_sprite
  end
  
end

#Fix follower landing on player when transfering
$NeedFollowerUpdate = false
#Don't try to unlock the follower events
class Interpreter
  
  def command_end
    # Clear list of event commands
    @list = nil
    # If main map event and event ID are valid
    if @main && @event_id > 0 && !($game_map.events[@event_id] && $game_map.events[@event_id].name=="Dependent")
      # Unlock event
      $game_map.events[@event_id].unlock if $game_map.events[@event_id]
    end
    if $NeedFollowerUpdate
      events=$PokemonGlobal.dependentEvents
      $PokemonTemp.dependentEvents.updateDependentEvents
      leader=$game_player
      for i in 0...events.length
        event=$PokemonTemp.dependentEvents.realEvents[i]
        $PokemonTemp.dependentEvents.pbFollowEventAcrossMaps(leader,event,false,i==0)
      end
      $NeedFollowerUpdate=false
    end
  end
  
  alias follow_201 command_201
  def command_201
    ret=follow_201
    $NeedFollowerUpdate=true
    return ret
  end
  
end


# Fix other events walking through dependent events
class Game_Map
  
  alias follow_passable? passable?
  def passable?(x, y, d, self_event=nil)
    ret=follow_passable?(x,y,d,self_event)
    if !ret && !$game_temp.player_transferring && $game_player.pbHasDependentEvents? && $game_switches[Toggle_Following_Switch] && 
       self_event != $game_player
         dependent=pbGetDependency("Dependent")
         if dependent != nil && self_event != dependent
           if dependent.x==x && dependent.y==y
             return false
           end
         end
    end
    return ret
   end
    
end


#Fix blacking out
#overwrite starting over to fix black out error
def Kernel.pbStartOver(gameover=false)
  if pbInBugContest?
    Kernel.pbBugContestStartOver
    return
  end
  pbHealAll()
  if $PokemonGlobal.pokecenterMapId && $PokemonGlobal.pokecenterMapId>=0
    if gameover
      Kernel.pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After the unfortunate defeat, {1} scurried to a Pokémon Center.",$Trainer.name))
    else
      Kernel.pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]{1} scurried to a Pokémon Center, protecting the exhausted and fainted Pokémon from further harm.",$Trainer.name))
    end
    Kernel.pbCancelVehicles
    pbRemoveDependencies()
    $game_switches[STARTING_OVER_SWITCH]=true
    $game_temp.player_new_map_id=$PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x=$PokemonGlobal.pokecenterX
    $game_temp.player_new_y=$PokemonGlobal.pokecenterY
    $game_temp.player_new_direction=$PokemonGlobal.pokecenterDirection
    $scene.transfer_player if $scene.is_a?(Scene_Map)
    $game_map.refresh
  else
    homedata=pbGetMetadata(0,MetadataHome)
    if (homedata && !pbRxdataExists?(sprintf("Data/Map%03d",homedata[0])) )
      if $DEBUG
        Kernel.pbMessage(_ISPRINTF("Can't find the map 'Map{1:03d}' in the Data folder. The game will resume at the player's position.",homedata[0]))
      end
      pbHealAll()
      return
    end
    if gameover
      Kernel.pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]After the unfortunate defeat, {1} scurried home.",$Trainer.name))
    else
      Kernel.pbMessage(_INTL("\\w[]\\wm\\c[8]\\l[3]{1} scurried home, protecting the exhausted and fainted Pokémon from further harm.",$Trainer.name))
    end
    if homedata
      Kernel.pbCancelVehicles
      pbRemoveDependencies() if !$game_switches[Following_Activated_Switch]
      $game_switches[STARTING_OVER_SWITCH]=true
      $game_temp.player_new_map_id=homedata[0]
      $game_temp.player_new_x=homedata[1]
      $game_temp.player_new_y=homedata[2]
      $game_temp.player_new_direction=homedata[3]
      $scene.transfer_player if $scene.is_a?(Scene_Map)
      $game_map.refresh
    else
      pbHealAll()
    end
  end
  pbEraseEscapePoint
end

#Fix Escape Rope
ItemHandlers::UseInField.add(:ESCAPEROPE,proc{|item|
   escape=($PokemonGlobal.escapePoint rescue nil)
   if !escape || escape==[]
     Kernel.pbMessage(_INTL("Can't use that here."))
     next
   end
   if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
     Kernel.pbMessage(_INTL("It can't be used when you have someone with you."))
     next
   end
   Kernel.pbMessage(_INTL("{1} used the {2}.",$Trainer.name,PBItems.getName(item)))
   pbFadeOutIn(99999){
      Kernel.pbCancelVehicles
      $game_temp.player_new_map_id=escape[0]
      $game_temp.player_new_x=escape[1]
      $game_temp.player_new_y=escape[2]
      $game_temp.player_new_direction=escape[3]
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
   }
   pbEraseEscapePoint
})


ItemHandlers::UseFromBag.add(:ESCAPEROPE,proc{|item|
   if $game_player.pbHasDependentEvents? && !$game_switches[Following_Activated_Switch]
     Kernel.pbMessage(_INTL("It can't be used when you have someone with you."))
     next 0
   end
   if ($PokemonGlobal.escapePoint rescue false) && $PokemonGlobal.escapePoint.length>0
     next 4 # End screen and consume item
   else
     Kernel.pbMessage(_INTL("Can't use that here."))
     next 0
   end
})


#Update sprites on give item
class PokemonPartyScreen

  alias follow_pbPokemonGiveScreen pbPokemonGiveScreen
  def pbPokemonGiveScreen(item)
    ret=follow_pbPokemonGiveScreen(item)
    $PokemonTemp.dependentEvents.refresh_sprite(false) if ret
    return ret
  end
  
end

#Update sprites on use item
module ItemHandlers
  
  class << self
    alias follow_triggerUseOnPokemon triggerUseOnPokemon
  end
  
  def self.triggerUseOnPokemon(item,pokemon,scene)
    ret = follow_triggerUseOnPokemon(item,pokemon,scene)
    $PokemonTemp.dependentEvents.refresh_sprite(false) if ret
    return ret
  end
  
end