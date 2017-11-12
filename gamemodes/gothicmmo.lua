require ("Goth Engine/GothEngine")
require ("Init/Init")

function OnGamemodeInit()			
	Log_System("----Server is loading----");
	Setting_SetGamemode("MMORPG");
	Setting_SetDescription("Game version: 1.1");

	MySQL_Init("localhost", "root", "root", "gothic");
	Object_Init("gothicmmo");	
	RPChat_Init();
	
	Account_Create_Init_Use("account");
	Account_Login_Init_Use("login");
	Account_UsernameChange_Init_Use("userchange");
	Account_PasswordChange_Init_Use("pwchange");
	Interface_CharacterMenu_Create_Name_Init_Use("name");
	Character_Logout_Init_Use("logout");
	Character_Quest_OpenInitUse("quest");
	Character_Trade_Init_Use("trade");
	Character_Trade_Gold_Init_Use("gold");
	Character_Party_Invite_Init_Use("invite");
	Character_Party_Leave_Init_Use("leave");
	Time_Real_Change_Init_Use("hourchange");	
	RPChat_Private_Init_Use("pm");
	RPChat_Return_Init_Use("r");
	RPChat_Party_Init_Use("party");
	Human_Vendor_Gold_Init_Use("gold");
	
	Admin_Help_Init_Use("adminhelp");
	Admin_Message_Init_Use("adminm");
	Admin_PrivateMessage_Init_Use("adminpm");
	Admin_Kick_Init_Use("kick");
	Admin_Ban_Init_Use("ban");
	Admin_Time_Init_Use("time");
	Admin_Teleport_Init_Use("teleport");
	Admin_Position_Init_Use("pos");
	Admin_Distance_Init_Use("distance");
	
	Animation_Help_Init_Use("animationhelp")
	Animation_Sit_Init_Use("sit")
	Animation_Sleep_Init_Use("sleep")
	Animation_Pee_Init_Use("pee")
	Animation_Trainoh_Init_Use("train1h")
	Animation_Inspectoh_Init_Use("inspect1h")
	Animation_Pray_Init_Use("pray")
	Animation_Search_Init_Use("search")
	Animation_Plunder_Init_Use("plunder")
	Animation_Guardo_Init_Use("guard1")
	Animation_Guardt_Init_Use("guard2")

	Respawn_Set(20);
	Character_Stat_Max_Level(3);
	
	Respawn_AddText("You can use lots of animations.",2000,"Font_Old_20_White_Hi.TGA");
	Respawn_AddText("This story is not part of the original Gothic story.",800,"Font_Old_20_White_Hi.TGA");
	Respawn_AddText("The maximum level is 3.",2500,"Font_Old_20_White_Hi.TGA");
	Respawn_AddText("You can see the Brotherhood of Tooshoo in Arcania: Gothic 4.",1800,"Font_Old_10_White_Hi.TGA");
	
	Log_System("----Server loaded----");
end