local character={};

character["Male"]={};
character["Male"]["Face"]={};
character["Male"]["Face"].types={"Hum_Head_Pony","Hum_Head_Fighter","Hum_Head_FatBald","Hum_Head_Bald","Hum_Head_Thief","Hum_Head_Psionic"};
character["Male"]["Face"].length=6;
character["Male"]["Body"]={};
character["Male"]["Body"].types={"Hum_Body_Naked0"};
character["Male"]["Body"].length=1;
character["Male"]["White"]={};
character["Male"]["White"]["Face"]={};
character["Male"]["White"]["Face"].types={0,1,2,3,5,6,7,9,10,13,14,16,18,19,20,21,22,23,24,25,26,27,31,32,33,34,35,36,37,38,
										39,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,
										68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,
										96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,
										118,119,159,160,161,162};
character["Male"]["White"]["Face"].length=114;
character["Male"]["White"]["Body"]={};
character["Male"]["White"]["Body"].types={0,1,8,9,10};
character["Male"]["White"]["Body"].length=5;
character["Male"]["Brown"]={};
character["Male"]["Brown"]["Face"]={};
character["Male"]["Brown"]["Face"].types={8,15,29,30,40,120,121,122,123,124,125,126,127,128};
character["Male"]["Brown"]["Face"].length=14;
character["Male"]["Brown"]["Body"]={};
character["Male"]["Brown"]["Body"].types={2};
character["Male"]["Brown"]["Body"].length=1;
character["Male"]["Black"]={};
character["Male"]["Black"]["Face"]={};
character["Male"]["Black"]["Face"].types={4,11,12,17,28,129,130,131,132,133,134,135,136};
character["Male"]["Black"]["Face"].length=13;
character["Male"]["Black"]["Body"]={};
character["Male"]["Black"]["Body"].types={3};
character["Male"]["Black"]["Body"].length=1;

character["Female"]={};
character["Female"]["Face"]={};
character["Female"]["Face"].types={"Hum_Head_Babe","Hum_Head_BabeHair","Hum_Head_Babe1","Hum_Head_Babe2","Hum_Head_Babe3","Hum_Head_Babe4",
								"Hum_Head_Babe5","Hum_Head_Babe6","Hum_Head_Babe7","Hum_Head_Babe8"};
character["Female"]["Face"].length=10;
character["Female"]["Body"]={};
character["Female"]["Body"].types={"Hum_Body_Babe0"};
character["Female"]["Body"].length=1;
character["Female"]["White"]={};
character["Female"]["White"]["Face"]={};
character["Female"]["White"]["Face"].types={137,138,139,140,143,144,145,146,147,148,149,150,151,152,153,154,155,156};
character["Female"]["White"]["Face"].length=18;
character["Female"]["White"]["Body"]={};
character["Female"]["White"]["Body"].types={4,5,11,12};
character["Female"]["White"]["Body"].length=4;
character["Female"]["Brown"]={};
character["Female"]["Brown"]["Face"]={};
character["Female"]["Brown"]["Face"].types={141,158};
character["Female"]["Brown"]["Face"].length=2;
character["Female"]["Brown"]["Body"]={};
character["Female"]["Brown"]["Body"].types={6};
character["Female"]["Brown"]["Body"].length=1;
character["Female"]["Black"]={};
character["Female"]["Black"]["Face"]={};
character["Female"]["Black"]["Face"].types={142,157};
character["Female"]["Black"]["Face"].length=2;
character["Female"]["Black"]["Body"]={};
character["Female"]["Black"]["Body"].types={7};
character["Female"]["Black"]["Body"].length=1;

character["Fatness"]={};
character["Fatness"].minimum=0;
character["Fatness"].maximum=2;

function Character_Body_Default()
	local character={};
	character["body_type"]="Hum_Body_Naked0";
	character["body_id"]=9;
	character["face_type"]="Hum_Head_Pony";
	character["face_id"]=18;
	character["fatness"]=0;
	
	return character;
end

function Character_Body_Gender()
	gender={};
	gender.type={"Male","Female"};
	gender.length=2;
	return gender;
end

function Character_Body_Skin()
	skin={};
	skin.type={"White","Brown","Black"};
	skin.length=3;
	return skin;
end

function Character_Body_All()
	return character;
end